Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYEZVOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYEZVOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 17:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYEZVOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 17:14:10 -0400
Received: from valhalla.ausics.net ([58.96.38.4]:54468 "EHLO
	valhalla.ausics.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYEZVOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 17:14:08 -0400
X-AIS-Watermark: 1212441244.53555@tSL1ncB0ybqJxVR4kZrMQA
Subject: PROBLEM: Serial error
From: "Noel   (Sourceforge)" <noelb@users.sourceforge.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Supporting Open Source
Message-Id: <1211836442.5745.1.camel@roswell.ausics.net>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-7) 
Date: Tue, 27 May 2008 07:14:02 +1000
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serial comms error with smsclient  >2.6.25 , worked fine up until and
including 2.6.24.7


smsclient a command line client for sending sms's, worked fine for all
previous versions but as of 2.6.25, I get errors "waiting for ACK" this
has been confirmed as a kernel related error, smsmclient worked fine for
years, carrier (Telstra) has been very helpful with assisting in
debugging, confirms no change, error kernel related verified by rolling
back to kernel 2.6.24.7, as of 2.6.25 something in the serial comms area
was altered and broke smsclient ability to send SMS's, it will connect
but not login to send, with timeout waiting for ID, been working on this
for weeks and again its confirmed to some change in the kernel versions
mentioned. Only changes made were kernel upgrades.

Slackware 12.0, kernel from kernel.org, same  .config file copied
through all upgrades, GCC    version 4.1.2 


00:00.0 Host bridge: Intel Corporation 82815 815 Chipset Host Bridge and
Memory
Controller Hub (rev 02)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort-
<MAbort+ >SERR- <PERR-
        Latency: 0
        Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [88] Vendor Specific Information
        Capabilities: [a0] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-
HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW-
Rate=<none>

00:01.0 PCI bridge: Intel Corporation 82815 815 Chipset AGP Bridge (rev
02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort-
<MAbort- >SERR- <PERR-
        Latency: 64
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fda00000-feafffff
        Prefetchable memory behind bridge: f3700000-f57fffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR+
        BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 02) (prog-if
00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fd900000-fd9fffff
        Prefetchable memory behind bridge: f3600000-f36fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801BA ISA Bridge (LPC) (rev 02)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801BA IDE U100 Controller
(rev 02) (prog-if 80 [Master])
        Subsystem: Intel Corporation Unknown device 4541
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: [virtual] Memory at 000001f0 (32-bit,
non-prefetchable) [disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3,
non-prefetchable) [disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit,
non-prefetchable) [disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3,
non-prefetchable) [disabled] [size=1]
        Region 4: I/O ports at ffa0 [size=16]
00:1f.2 USB Controller: Intel Corporation 82801BA/BAM USB Controller #1
(rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 4541
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 10
        Region 4: I/O ports at ef40 [size=32]

00:1f.3 SMBus: Intel Corporation 82801BA/BAM SMBus Controller (rev 02)
        Subsystem: Intel Corporation Unknown device 4541
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 6
        Region 4: I/O ports at efa0 [size=16]

00:1f.4 USB Controller: Intel Corporation 82801BA/BAM USB Controller #1
(rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 4541
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 9
        Region 4: I/O ports at ef80 [size=32]

00:1f.5 Multimedia audio controller: Intel Corporation 82801BA/BAM AC'97
Audio Controller (rev 02)
        Subsystem: Intel Corporation Unknown device 4541
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 6
        Region 0: I/O ports at e800 [size=256]
        Region 1: I/O ports at ef00 [size=64]

01:08.0 Ethernet controller: Intel Corporation 82801BA/BAM/CA/CAM
Ethernet Controller (rev 01)
        Subsystem: Intel Corporation EtherExpress PRO/100 VE
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at fd9fe000 (32-bit, non-prefetchable)
[size=4K]
        Region 1: I/O ports at df00 [size=64]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

01:0a.0 Ethernet controller: Lite-On Communications Inc LNE100TX (rev
20)
        Subsystem: Netgear FA310TX
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at d400 [size=256]
        Region 1: Memory at fd9ff800 (32-bit, non-prefetchable)
[size=256]
        Expansion ROM at f3600000 [disabled] [size=256K]

01:0c.0 Serial controller: PLX Technology, Inc. PCI <-> IOBus Bridge
(rev 01) (prog-if 00 [8250])
        Subsystem: Stallion Technologies, Inc. Unknown device f010
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 6
        Region 0: Memory at fd9ffc00 (32-bit, non-prefetchable)
[size=128]
        Region 1: I/O ports at dc00 [size=128]
        Region 2: I/O ports at d880 [size=128]

02:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA 2164W
[Millennium II] AGP (prog-if 00 [VGA])
        Subsystem: Matrox Graphics, Inc. Unknown device 1000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Region 0: Memory at fd9ffc00 (32-bit, non-prefetchable)
[size=128]
        Region 1: I/O ports at dc00 [size=128]
        Region 2: I/O ports at d880 [size=128]

02:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA 2164W
[Millennium II] AGP (prog-if 00 [VGA])
        Subsystem: Matrox Graphics, Inc. Unknown device 1000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at f4000000 (32-bit, prefetchable) [size=16M]
        Region 1: Memory at feafc000 (32-bit, non-prefetchable)
[size=16K]
        Region 2: Memory at fe000000 (32-bit, non-prefetchable)
[size=8M]
        Expansion ROM at feae0000 [disabled] [size=64K]
        Capabilities: [f0] AGP version 1.0
                Status: RQ=1 Iso- ArqSz=0 Cal=0 SBA- ITACoh- GART64-
HTrans- 64bit- FW- AGP3- Rate=<none>
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW-
Rate=<none>


Stallion Multiport Serial Driver: version 5.6.0
Stallion Intelligent Multiport Serial Driver: version 5.6.0
0000:01:0c.0: ttyS4 at I/O 0xd880 (irq = 6) is a ST16654
0000:01:0c.0: ttyS5 at I/O 0xd888 (irq = 6) is a ST16654
0000:01:0c.0: ttyS6 at I/O 0xd890 (irq = 6) is a ST16654
0000:01:0c.0: ttyS7 at I/O 0xd898 (irq = 6) is a ST16654
0000:01:0c.0: ttyS8 at I/O 0xd8a0 (irq = 6) is a ST16654
0000:01:0c.0: ttyS9 at I/O 0xd8a8 (irq = 6) is a ST16654
0000:01:0c.0: ttyS10 at I/O 0xd8b0 (irq = 6) is a ST16654
0000:01:0c.0: ttyS11 at I/O 0xd8b8 (irq = 6) is a ST16654 <-- phone line
in this port


suggestions or assistance appreciated.
Noel


