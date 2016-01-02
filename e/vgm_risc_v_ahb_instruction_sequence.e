// Copyright 2016 Tudor Timisescu (verificationgentleman.com)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


<'
package vgm_risc_v_ahb;


extend vgm_ahb::slave_sequence_kind : [ INSTRUCTION_LAYERING ];

extend INSTRUCTION_LAYERING vgm_ahb::slave_sequence {
  stream_driver : vgm_risc_v::instruction_stream_driver;

  !seq_item : vgm_ahb::transfer;


  body() @driver.clock is {
    while TRUE {
      get_and_do_instruction();
    };
  };

  get_and_do_instruction() @driver.clock is {
    driver.wait_for_grant(me);
    var instr : vgm_risc_v::instruction = stream_driver.get_next_item();
    gen seq_item keeping { .data == pack(packing.low, instr) };
    mid_do(seq_item);
    driver.deliver_item(seq_item);
    driver.wait_for_item_done(NULL);
    emit stream_driver.item_done;
  };
};
'>
