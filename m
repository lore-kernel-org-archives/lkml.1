Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbXGCWu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbXGCWu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbXGCWuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:50:21 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:59292 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbXGCWuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:50:20 -0400
Message-ID: <468AD29F.6040908@mandic.com.br>
Date: Tue, 03 Jul 2007 19:50:07 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: oakad@yahoo.com
Subject: [tifm] Infinite loop
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When I insert a SDCard in my laptop M45-S355 my system crash because 
tifm start a infinite loop. See below more detail about SD/MMC Card and 
infinite loop.


05:06.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
         Subsystem: Toshiba America Info Systems Unknown device ff10
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 168, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at b8001000 (32-bit, non-prefetchable) [size=4K]
         Bus: primary=05, secondary=06, subordinate=09, sec-latency=176
         Memory window 0: 88000000-8bfff000 (prefetchable)
         Memory window 1: bc000000-bffff000
         I/O window 0: 00008000-000080ff
         I/O window 1: 00008400-000084ff
         BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ 
PostWrite+
         16-bit legacy interface ports at 0001

05:06.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE 1394 
Host Controller (prog-if 10 [OHCI])
         Subsystem: Toshiba America Info Systems Unknown device ff10
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (500ns min, 1000ns max), Cache Line Size: 16 bytes
         Interrupt: pin C routed to IRQ 11
         Region 0: Memory at b8000000 (32-bit, non-prefetchable) [size=2K]
         Region 1: Memory at b8004000 (32-bit, non-prefetchable) [size=16K]
         Capabilities: [44] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME+

05:06.3 Mass storage controller: Texas Instruments PCIxx21 Integrated 
FlashMedia Controller
         Subsystem: Toshiba America Info Systems Unknown device ff10
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (1750ns min, 1000ns max), Cache Line Size: 16 bytes
         Interrupt: pin D routed to IRQ 5
         Region 0: Memory at b8008000 (32-bit, non-prefetchable) [size=8K]
         Capabilities: [44] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:06.4 Generic system peripheral [0805]: Texas Instruments PCI6411, 
PCI6421, PCI6611, PCI6621, PCI7411, PCI7421, PCI7611, PCI7621 Secure 
Digital (SD) Controller
         Subsystem: Toshiba America Info Systems Unknown device ff10
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (1750ns min, 1000ns max), Cache Line Size: 16 bytes
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at b800a000 (32-bit, non-prefetchable) [size=256]
         Region 1: Memory at b800a100 (32-bit, non-prefetchable) [size=256]
         Region 2: Memory at b800a200 (32-bit, non-prefetchable) [size=256]
         Capabilities: [80] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

======================
[<c02be23a>] __sched_text_start+0x62/0x558
[<c011f14b>] process_timeout+0x0/0x5
[<c011f118>] msleep+0xd/0x12
[<f9197091>] tifm_7xx1_toggle_sock_power+0x91/0xb2 [tifm_7xx1]
[<f91974c9>] tifm_7xx1_switch_media+0x6c/0x3a7 [tifm_7xx1]
[<c0127c93>] autoremove_wake_function+0x0/0x35
[<f919745d>] tifm_7xx1_switch_media+0x0/0x3a7 [tifm_7xx1]
[<c0127bcc>] kthread+0xa0/0xc8
[<c0127b2c>] kthread+0x0/0xc8
[<c0104823>] kernel_thread_helper+0x7/0x10
=======================
[<c02be23a>] __sched_text_start+0x62/0x558
[<c0118b17>] printk+0x1b/0x1f
[<c02bef2a>] schedule_timeout+0x7a/0x97
[<c011f14b>] process_timeout+0x0/0x5
[<c011f118>] msleep+0xd/0x12
[<f9197079>] tifm_7xx1_toggle_sock_power+0x79/0xb2 [tifm_7xx1]
[<f9197611>] tifm_7xx1_switch_media+0x1b4/0x3a7 [tifm_7xx1]
[<c0127c93>] autoremove_wake_function+0x0/0x35
[<f919745d>] tifm_7xx1_switch_media+0x0/0x3a7 [tifm_7xx1]
[<c0127bcc>] kthread+0xa0/0xc8
[<c0127b2c>] kthread+0x0/0xc8
[<c0104823>] kernel_thread_helper+0x7/0x10
=======================
[<c02be23a>] __sched_text_start+0x62/0x558
[<c02bef2a>] schedule_timeout+0x7a/0x97
[<c011f14b>] process_timeout+0x0/0x5
[<c011f118>] msleep+0xd/0x12
[<f9197091>] tifm_7xx1_toggle_sock_power+0x91/0xb2 [tifm_7xx1]
[<f9197611>] tifm_7xx1_switch_media+0x1b4/0x3a7 [tifm_7xx1]
[<c0127c93>] autoremove_wake_function+0x0/0x35
[<f919745d>] tifm_7xx1_switch_media+0x0/0x3a7 [tifm_7xx1]
[<c0127bcc>] kthread+0xa0/0xc8
[<c0127b2c>] kthread+0x0/0xc8
[<c0104823>] kernel_thread_helper+0x7/0x10
=======================
[<c02be23a>] __sched_text_start+0x62/0x558
[<c02bef2a>] schedule_timeout+0x7a/0x97
[<c011f14b>] process_timeout+0x0/0x5
[<c011f118>] msleep+0xd/0x12
[<f9197091>] tifm_7xx1_toggle_sock_power+0x91/0xb2 [tifm_7xx1]
[<f9197611>] tifm_7xx1_switch_media+0x1b4/0x3a7 [tifm_7xx1]
[<c0127c93>] autoremove_wake_function+0x0/0x35
[<f919745d>] tifm_7xx1_switch_media+0x0/0x3a7 [tifm_7xx1]
[<c0127bcc>] kthread+0xa0/0xc8
[<c0127b2c>] kthread+0x0/0xc8
[<c0104823>] kernel_thread_helper+0x7/0x10
=======================
tifm_7xx1: sd card detected in socket 3
[<c02be23a>] __sched_text_start+0x62/0x558
[<f91974c9>] tifm_7xx1_switch_media+0x6c/0x3a7 [tifm_7xx1]
[<c0127c93>] autoremove_wake_function+0x0/0x35
[<f919745d>] tifm_7xx1_switch_media+0x0/0x3a7 [tifm_7xx1]
[<c0127bcc>] kthread+0xa0/0xc8
[<c0127b2c>] kthread+0x0/0xc8
[<c0104823>] kernel_thread_helper+0x7/0x10
=======================
74c9>] tifm_7xx1_switch_media+0x6c/0x3a7 [tifm_7xx1]
  [<c0127c93>] autoremove_wake_function+0x0/0x35
  [<f919745d>] tifm_7xx1_switch_media+0x0/0x3a7 [tifm_7xx1]
  [<c0127bcc>] kthread+0xa0/0xc8
  [<c0127b2c>] kthread+0x0/0xc8
  [<c0104823>] kernel_thread_helper+0x7/0x10
  =======================
  [<c02be23a>] __sched_text_start+0x62/0x558
  [<f91974c9>] tifm_7xx1_switch_media+0x6c/0x3a7 [tifm_7xx1]
  [<c0127c93>] autoremove_wake_function+0x0/0x35
  [<f919745d>] tifm_7xx1_switch_media+0x0/0x3a7 [tifm_7xx1]
  [<c0127bcc>] kthread+0xa0/0xc8
  [<c0127b2c>] kthread+0x0/0xc8
  [<c0104823>] kernel_thread_helper+0x7/0x10

Best regards,
Renato S. Yamane
