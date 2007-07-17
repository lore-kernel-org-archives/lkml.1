Return-Path: <linux-kernel-owner+w=401wt.eu-S1764034AbXGQIqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764034AbXGQIqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXGQIqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:46:42 -0400
Received: from v813.rev.tld.pl ([195.149.226.213]:41620 "EHLO
	smtp.host4.kei.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334AbXGQIqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:46:37 -0400
X-clamdmail: clamdmail 0.18a
From: Marcin Juszkiewicz <openembedded@hrw.one.pl>
To: linux-kernel@vger.kernel.org
Subject: [PCI] Dell D400 "pci=assign-busses" report
Date: Tue, 17 Jul 2007 09:09:15 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_bsGnGEkCfV4tORc"
Message-Id: <200707170909.15542.openembedded@hrw.one.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_bsGnGEkCfV4tORc
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


On my Dell D400 laptop I got that message from kernel on boot:

[   26.256057] PCI: Transparent bridge - 0000:00:1e.0
[   26.256125] PCI: Bus #02 (-#05) is hidden behind transparent bridge #01 
(-#01) (try 'pci=assign-busses')
[   26.256132] Please report the result to linux-kernel to fix this 
permanently
[   26.256169] PCI: Bus #06 (-#09) is hidden behind transparent bridge #01 
(-#01) (try 'pci=assign-busses')
[   26.256175] Please report the result to linux-kernel to fix this 
permanently

I added "pci=assign-busses" into kernel cmdline and everything is working 
without problems. And I did not noticed problems without it.

Attached files:

lspci-vvv.text is output of "lspci -vvv"
dmesg-nopci.text is dmesg output without "pci=assign-busses"
dmesg-pci.text is dmesg output with "pci=assign-busses"

--Boundary-00=_bsGnGEkCfV4tORc
Content-Type: text/plain;
  charset="us-ascii";
  name="lspci-vvv.text"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci-vvv.text"

00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
	Subsystem: Dell Latitude D400
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Region 0: Memory at <unassigned> (32-bit, prefetchable)
	Capabilities: [40] Vendor Specific Information

00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
	Subsystem: Dell Latitude D400
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
	Subsystem: Dell Latitude D400
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:02.0 VGA compatible controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02) (prog-if 00 [VGA])
	Subsystem: Dell Latitude D400
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at faf80000 (32-bit, non-prefetchable) [size=512K]
	Region 2: I/O ports at c000 [size=8]
	Capabilities: [d0] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 Display controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02)
	Subsystem: Dell Latitude D400
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at faf00000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: [d0] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Latitude D400
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 4: I/O ports at bf80 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Latitude D400
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 11
	Region 4: I/O ports at bf40 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Latitude D400
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 11
	Region 4: I/O ports at bf20 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: Dell Latitude D400
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 11
	Region 0: Memory at faeffc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 81) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR+
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=09, sec-latency=32
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fc000000-fdffffff
	Prefetchable memory behind bridge: 50000000-59ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 01) (prog-if 8a [Master SecP PriP])
	Subsystem: Intel Corporation Latitude D400
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at bfa0 [size=16]
	Region 5: Memory at 5a000000 (32-bit, non-prefetchable) [size=1K]

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 01)
	Subsystem: Dell Latitude D400
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 7
	Region 0: I/O ports at d800 [size=256]
	Region 1: I/O ports at dc40 [size=64]
	Region 2: Memory at faeff800 (32-bit, non-prefetchable) [size=512]
	Region 3: Memory at faeff400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5705M Gigabit Ethernet (rev 01)
	Subsystem: Dell Latitude D400
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (16000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fcff0000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at 58000000 [disabled] [size=64K]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-
		Address: fffffe7ffffff7f8  Data: dffd

01:01.0 CardBus bridge: Texas Instruments PCI7510 PC card Cardbus Controller (rev 01)
	Subsystem: Dell Latitude D400
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 168, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=01, secondary=02, subordinate=05, sec-latency=176
	Memory window 0: 50000000-53fff000 (prefetchable)
	Memory window 1: 5c000000-5ffff000
	I/O window 0: 0000e000-0000e0ff
	I/O window 1: 0000e400-0000e4ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001

01:01.1 CardBus bridge: Texas Instruments PCI7510,7610 PC card Cardbus Controller (rev 01)
	Subsystem: Dell Latitude D400
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 168, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fc001000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=01, secondary=06, subordinate=09, sec-latency=176
	Memory window 0: 54000000-57fff000 (prefetchable)
	Memory window 1: 60000000-63fff000
	I/O window 0: 0000e800-0000e8ff
	I/O window 1: 00001000-000010ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001

01:01.2 FireWire (IEEE 1394): Texas Instruments PCI7410,7510,7610 OHCI-Lynx Controller (prog-if 10 [OHCI])
	Subsystem: Dell Latitude D400
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (500ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fcfef800 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at fcfe8000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+

01:01.3 System peripheral: Texas Instruments PCI7410,7510,7610 PCI Firmware Loading Function
	Subsystem: Dell Latitude D400
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Region 0: I/O ports at ecf8 [size=8]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:03.0 Network controller: Broadcom Corporation BCM4309 802.11a/b/g (rev 03)
	Subsystem: Dell Truemobile 1450 MiniPCI
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32
	Interrupt: pin A routed to IRQ 7
	Region 0: Memory at fcfec000 (32-bit, non-prefetchable) [size=8K]


--Boundary-00=_bsGnGEkCfV4tORc
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg-nopci.text"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-nopci.text"

[    0.000000] Linux version 2.6.22-hrt1 (root@maluch) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #5 PREEMPT Wed Jul 11 19:52:18 CEST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fea6000 (usable)
[    0.000000]  BIOS-e820: 000000003fea6000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec20000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000fee00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] 126MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 261798) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   261798
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   261798
[    0.000000] On node 0 totalpages: 261798
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 253 pages used for memmap
[    0.000000]   HighMem zone: 32169 pages, LIFO batch:7
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FDF00, 0014 (r0 DELL  )
[    0.000000] ACPI: RSDT 3FEF0000, 002C (r1 DELL    CPi R   27D5061C ASL        61)
[    0.000000] ACPI: FACP 3FEF0400, 0074 (r1 DELL    CPi R   27D5061C ASL        61)
[    0.000000] ACPI: DSDT 3FEF0C00, 30C1 (r1 INT430 SYSFexxx     1001 MSFT  100000E)
[    0.000000] ACPI: FACS 3FEFF800, 0040
[    0.000000] ACPI: ASF! 3FEF0800, 005B (r16 DELL    CPi R   27D5061C ASL        61)
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bec10000)
[    0.000000] Built 1 zonelists.  Total pages: 259753
[    0.000000] Kernel command line: root=/dev/mapper/maluch80-rootfs ro vga=773 lapic  nmi_watchdog=0 netconsole=6665@192.168.1.120/eth0,6666@192.168.1.10/00:18:39:36:D0:B2 loglevel=8 
[    0.000000] netconsole: local port 6665
[    0.000000] netconsole: local IP 192.168.1.120
[    0.000000] netconsole: interface eth0
[    0.000000] netconsole: remote port 6666
[    0.000000] netconsole: remote IP 192.168.1.10
[    0.000000] netconsole: remote ethernet address 00:18:39:36:d0:b2
[    0.000000] Local APIC disabled by BIOS -- reenabling.
[    0.000000] Found and enabled local APIC!
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c0469000 soft=c0468000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1594.883 MHz processor.
[   26.002880] Console: colour dummy device 80x25
[   26.003400] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   26.003919] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   26.035959] Memory: 1029800k/1047192k available (2385k kernel code, 16572k reserved, 889k data, 188k init, 129688k highmem)
[   26.035977] virtual kernel memory layout:
[   26.035978]     fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
[   26.035979]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   26.035981]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   26.035982]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   26.035983]       .init : 0xc0434000 - 0xc0463000   ( 188 kB)
[   26.035985]       .data : 0xc0354771 - 0xc0432bbc   ( 889 kB)
[   26.035986]       .text : 0xc0100000 - 0xc0354771   (2385 kB)
[   26.036002] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   26.096112] Calibrating delay using timer specific routine.. 3190.58 BogoMIPS (lpj=1595294)
[   26.096163] Mount-cache hash table entries: 512
[   26.096271] CPU: After generic identify, caps: afe9fbbf 00000000 00000000 00000000 00000180 00000000 00000000
[   26.096287] CPU: L1 I cache: 32K, L1 D cache: 32K
[   26.096291] CPU: L2 cache: 2048K
[   26.096295] CPU: After all inits, caps: afe9fbbf 00000000 00000000 00002040 00000180 00000000 00000000
[   26.096305] Intel machine check architecture supported.
[   26.096311] Intel machine check reporting enabled on CPU#0.
[   26.096318] Compat vDSO mapped to ffffe000.
[   26.096330] CPU: Intel(R) Pentium(R) M processor 1.60GHz stepping 06
[   26.096337] Checking 'hlt' instruction... OK.
[   26.100173] ACPI: Core revision 20070126
[   26.101640] ACPI: setting ELCR to 0200 (from 0800)
[   26.205216] NET: Registered protocol family 16
[   26.205319] ACPI: bus type pci registered
[   26.237702] PCI: PCI BIOS revision 2.10 entry at 0xfc96e, last bus=1
[   26.237707] PCI: Using configuration type 1
[   26.237710] Setting up standard PCI resources
[   26.244477] ACPI: Interpreter enabled
[   26.244483] ACPI: (supports S0 S1 S3 S4 S5)
[   26.244505] ACPI: Using PIC for interrupt routing
[   26.255231] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   26.255255] PCI: Probing PCI hardware (bus 00)
[   26.255692] Force enabled HPET at base address 0xfed00000
[   26.255701] PCI quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
[   26.255707] PCI quirk: region 0880-08bf claimed by ICH4 GPIO
[   26.256057] PCI: Transparent bridge - 0000:00:1e.0
[   26.256125] PCI: Bus #02 (-#05) is hidden behind transparent bridge #01 (-#01) (try 'pci=assign-busses')
[   26.256132] Please report the result to linux-kernel to fix this permanently
[   26.256169] PCI: Bus #06 (-#09) is hidden behind transparent bridge #01 (-#01) (try 'pci=assign-busses')
[   26.256175] Please report the result to linux-kernel to fix this permanently
[   26.256192] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   26.256518] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[   26.275435] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
[   26.275541] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *11
[   26.275643] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 *11)
[   26.275745] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 *11)
[   26.275834] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[   26.275941] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[   26.276036] Linux Plug and Play Support v0.97 (c) Adam Belay
[   26.276047] pnp: PnP ACPI init
[   26.276060] ACPI: bus type pnp registered
[   26.301577] pnp: PnP ACPI: found 14 devices
[   26.301582] ACPI: ACPI bus type pnp unregistered
[   26.301588] PnPBIOS: Disabled by ACPI PNP
[   26.301678] SCSI subsystem initialized
[   26.301701] libata version 2.21 loaded.
[   26.301740] PCI: Using ACPI for IRQ routing
[   26.301745] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   26.308177] hpet clockevent registered
[   26.308184] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   26.308191] hpet0: 3 64-bit timers, 14318180 Hz
[   26.309254] pnp: 00:00: iomem range 0x0-0x9fbff could not be reserved
[   26.309260] pnp: 00:00: iomem range 0x9fc00-0x9ffff could not be reserved
[   26.309265] pnp: 00:00: iomem range 0xc0000-0xcffff could not be reserved
[   26.309271] pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
[   26.309278] pnp: 00:02: ioport range 0x4d0-0x4d1 has been reserved
[   26.309283] pnp: 00:02: ioport range 0x800-0x805 has been reserved
[   26.309290] pnp: 00:02: ioport range 0x808-0x80f has been reserved
[   26.309297] pnp: 00:03: ioport range 0xf400-0xf4fe has been reserved
[   26.309302] pnp: 00:03: ioport range 0x806-0x807 has been reserved
[   26.309306] pnp: 00:03: ioport range 0x810-0x85f has been reserved
[   26.309311] pnp: 00:03: ioport range 0x860-0x87f has been reserved
[   26.309316] pnp: 00:03: ioport range 0x880-0x8bf has been reserved
[   26.309321] pnp: 00:03: ioport range 0x8c0-0x8df has been reserved
[   26.309329] pnp: 00:08: ioport range 0x900-0x97f has been reserved
[   26.309336] pnp: 00:0d: ioport range 0x7b0-0x7bb has been reserved
[   26.309341] pnp: 00:0d: ioport range 0x7c0-0x7df has been reserved
[   26.309346] pnp: 00:0d: ioport range 0xbb0-0xbbb has been reserved
[   26.309351] pnp: 00:0d: ioport range 0xbc0-0xbdf has been reserved
[   26.309356] pnp: 00:0d: ioport range 0xfb0-0xfbb has been reserved
[   26.309360] pnp: 00:0d: ioport range 0xfc0-0xfdf has been reserved
[   26.309365] pnp: 00:0d: ioport range 0x13b0-0x13bb has been reserved
[   26.309370] pnp: 00:0d: ioport range 0x13c0-0x13df has been reserved
[   26.310049] Time: tsc clocksource has been installed.
[   26.339629] PCI: Bus 2, cardbus bridge: 0000:01:01.0
[   26.339634]   IO window: 0000e000-0000e0ff
[   26.339639]   IO window: 0000e400-0000e4ff
[   26.339645]   PREFETCH window: 50000000-53ffffff
[   26.339650]   MEM window: 5c000000-5fffffff
[   26.339656] PCI: Bus 6, cardbus bridge: 0000:01:01.1
[   26.339660]   IO window: 0000e800-0000e8ff
[   26.339665]   IO window: 00001000-000010ff
[   26.339670]   PREFETCH window: 54000000-57ffffff
[   26.339676]   MEM window: 60000000-63ffffff
[   26.339681] PCI: Bridge: 0000:00:1e.0
[   26.339685]   IO window: e000-efff
[   26.339692]   MEM window: fc000000-fdffffff
[   26.339698]   PREFETCH window: 50000000-59ffffff
[   26.339712] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   26.339725] PCI: Enabling device 0000:01:01.0 (0000 -> 0003)
[   26.339876] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   26.339881] PCI: setting IRQ 11 as level-triggered
[   26.339886] ACPI: PCI Interrupt 0000:01:01.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
[   26.339904] ACPI: PCI Interrupt 0000:01:01.1[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
[   26.339933] NET: Registered protocol family 2
[   26.349063] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   26.349169] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[   26.350555] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[   26.351029] TCP: Hash tables configured (established 131072 bind 65536)
[   26.351045] TCP reno registered
[   26.354216] checking if image is initramfs... it is
[   26.731384] Freeing initrd memory: 3661k freed
[   26.731927] audit: initializing netlink socket (disabled)
[   26.731953] audit(1184655289.171:1): initialized
[   26.732011] highmem bounce pool size: 64 pages
[   26.732180] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   26.732427] io scheduler noop registered
[   26.732449] io scheduler cfq registered (default)
[   26.732471] Boot video device is 0000:00:02.0
[   26.743014] vesafb: framebuffer at 0xf0000000, mapped to 0xf8880000, using 832k, total 832k
[   26.743021] vesafb: mode is 1024x768x8, linelength=1024, pages=0
[   26.743026] vesafb: protected mode interface info at 00ff:44f0
[   26.743030] vesafb: scrolling: redraw
[   26.743035] vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
[   26.754674] Console: switching to colour frame buffer device 128x48
[   26.766263] fb0: VESA VGA frame buffer device
[   26.766410] isapnp: Scanning for PnP cards...
[   27.078137] isapnp: No Plug & Play device found
[   27.080290] Real Time Clock Driver v1.12ac
[   27.080489] Linux agpgart interface v0.102 (c) Dave Jones
[   27.080649] agpgart: Detected an Intel 855GM Chipset.
[   27.082639] agpgart: Detected 892K stolen memory.
[   27.092179] agpgart: AGP aperture is 128M @ 0xf0000000
[   27.092328] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   27.092933] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   27.093621] RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
[   27.093846] tg3.c:v3.77 (May 31, 2007)
[   27.094136] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   27.094266] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
[   27.164514] eth0: Tigon3 [partno(BCM95705A50) rev 3001 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:0f:1f:fe:86:35
[   27.164802] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
[   27.164965] eth0: dma_rwctrl[763f0000] dma_mask[64-bit]
[   27.165147] netconsole: device eth0 not up yet, forcing it
[   27.172606] PM: Writing back config space on device 0000:01:00.0 at offset b (was 165d14e4, writing 865d1028)
[   27.172833] PM: Writing back config space on device 0000:01:00.0 at offset 3 (was 0, writing 2008)
[   27.173030] PM: Writing back config space on device 0000:01:00.0 at offset 2 (was 2000000, writing 2000001)
[   27.173244] PM: Writing back config space on device 0000:01:00.0 at offset 1 (was 2b00000, writing 2b00106)
[   31.506937] netconsole: timeout waiting for carrier
[   32.350946] netconsole: network logging started
[   32.355980] ata_piix 0000:00:1f.1: version 2.11
[   32.361077] PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
[   32.366265] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[   32.371270] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[   32.376391] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   32.381483] scsi0 : ata_piix
[   32.386492] scsi1 : ata_piix
[   32.391390] ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001bfa0 irq 14
[   32.396456] ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001bfa8 irq 15
[   32.555925] ata1.00: ATA-6: ST980815A, 3.ALD, max UDMA/100
[   32.560905] ata1.00: 156301488 sectors, multi 8: LBA48 
[   32.572559] ata1.00: configured for UDMA/100
[   32.728577] scsi 0:0:0:0: Direct-Access     ATA      ST980815A        3.AL PQ: 0 ANSI: 5
[   32.733700] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[   32.738735] sd 0:0:0:0: [sda] Write Protect is off
[   32.743744] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   32.748746] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.753849] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[   32.758895] sd 0:0:0:0: [sda] Write Protect is off
[   32.763873] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   32.768856] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.773969]  sda: sda1 sda2 sda3
[   32.831627] sd 0:0:0:0: [sda] Attached SCSI disk
[   32.836765] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[   32.846747] serio: i8042 KBD port at 0x60,0x64 irq 1
[   32.851968] serio: i8042 AUX port at 0x60,0x64 irq 12
[   32.857130] mice: PS/2 mouse device common for all mice
[   32.866150] input: AT Translated Set 2 keyboard as /class/input/input0
[   32.875964] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   32.881320] cpuidle: using governor ladder
[   32.886792] cpuidle: using governor menu
[   32.892172] Advanced Linux Sound Architecture Driver Version 1.0.14 (Thu May 31 09:03:25 2007 UTC).
[   32.898025] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 7
[   32.903290] PCI: setting IRQ 7 as level-triggered
[   32.908692] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 7 (level, low) -> IRQ 7
[   32.914243] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[   33.490362] input: PS/2 Mouse as /class/input/input1
[   33.517114] input: AlpsPS/2 ALPS GlidePoint as /class/input/input2
[   33.742032] intel8x0_measure_ac97_clock: measured 50520 usecs
[   33.747071] intel8x0: clocking to 48000
[   33.752713] ALSA device list:
[   33.757636]   #0: Intel 82801DB-ICH4 with STAC9750,51 at irq 7
[   33.762605] TCP bic registered
[   33.767518] NET: Registered protocol family 1
[   33.772448] NET: Registered protocol family 17
[   33.777426] Using IPI Shortcut mode
[   33.782439] Freeing unused kernel memory: 188k freed
[   35.039431] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3] C4[C3])
[   35.039449] ACPI: Processor [CPU0] (supports 8 throttling states)
[   35.039586] cpuidle: using driver acpi_idle
[   35.042590] ACPI: Thermal Zone [THM] (63 C)
[   35.192750] usbcore: registered new interface driver usbfs
[   35.192782] usbcore: registered new interface driver hub
[   35.192805] usbcore: registered new device driver usb
[   35.193578] USB Universal Host Controller Interface driver v3.0
[   35.193640] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[   35.193659] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   35.193665] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   35.193788] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   35.193811] uhci_hcd 0000:00:1d.0: irq 11, io base 0x0000bf80
[   35.193921] usb usb1: configuration #1 chosen from 1 choice
[   35.193944] hub 1-0:1.0: USB hub found
[   35.193951] hub 1-0:1.0: 2 ports detected
[   35.295305] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
[   35.295333] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   35.295338] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   35.295364] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[   35.295390] uhci_hcd 0000:00:1d.1: irq 11, io base 0x0000bf40
[   35.295514] usb usb2: configuration #1 chosen from 1 choice
[   35.295539] hub 2-0:1.0: USB hub found
[   35.295546] hub 2-0:1.0: 2 ports detected
[   35.396527] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
[   35.396556] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   35.396561] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   35.396591] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[   35.396617] uhci_hcd 0000:00:1d.2: irq 11, io base 0x0000bf20
[   35.396734] usb usb3: configuration #1 chosen from 1 choice
[   35.396760] hub 3-0:1.0: USB hub found
[   35.396766] hub 3-0:1.0: 2 ports detected
[   35.498239] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[   35.498253] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 11 (level, low) -> IRQ 11
[   35.498273] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   35.498279] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   35.498307] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
[   35.498342] ehci_hcd 0000:00:1d.7: debug port 1
[   35.498350] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   35.498360] ehci_hcd 0000:00:1d.7: irq 11, io mem 0xfaeffc00
[   35.502234] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   35.502331] usb usb4: configuration #1 chosen from 1 choice
[   35.502359] hub 4-0:1.0: USB hub found
[   35.502367] hub 4-0:1.0: 6 ports detected
[   35.603555] ACPI: PCI Interrupt 0000:01:01.2[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
[   35.653753] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[11]  MMIO=[fcfef800-fcfeffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   36.102298] usb 2-2: new full speed USB device using uhci_hcd and address 3
[   36.268250] usb 2-2: configuration #1 chosen from 1 choice
[   36.415497] Initializing USB Mass Storage driver...
[   36.415780] scsi2 : SCSI emulation for USB Mass Storage devices
[   36.415918] usb-storage: device found at 3
[   36.415922] usb-storage: waiting for device to settle before scanning
[   36.415935] usbcore: registered new interface driver usb-storage
[   36.415939] USB Mass Storage support registered.
[   36.909284] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[484fc0001f2bb030]
[   37.346134] Switched to high resolution mode on CPU 0
[   11.207000] Marking TSC unstable due to: possible TSC halt in C2.
[   11.234000] Time: hpet clocksource has been installed.
[   14.241000] usb-storage: device scan complete
[   14.245000] scsi 2:0:0:0: Direct-Access     Sony Eri Memory Stick     0000 PQ: 0 ANSI: 0
[   14.264000] sd 2:0:0:0: [sdb] 126912 512-byte hardware sectors (65 MB)
[   14.270000] sd 2:0:0:0: [sdb] Write Protect is off
[   14.270000] sd 2:0:0:0: [sdb] Mode Sense: 00 6a 00 00
[   14.270000] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   14.281000] sd 2:0:0:0: [sdb] 126912 512-byte hardware sectors (65 MB)
[   14.287000] sd 2:0:0:0: [sdb] Write Protect is off
[   14.287000] sd 2:0:0:0: [sdb] Mode Sense: 00 6a 00 00
[   14.287000] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   14.287000]  sdb: sdb1
[   14.358000] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   14.372000] Attempting manual resume
[   14.414000] swsusp: Basic memory bitmaps created
[   14.430000] swsusp: Basic memory bitmaps freed
[   14.469000] kjournald starting.  Commit interval 5 seconds
[   14.469000] EXT3-fs: mounted filesystem with ordered data mode.
[   16.948000] cdc_acm 2-2:1.1: ttyACM0: USB ACM device
[   16.950000] cdc_acm 2-2:1.3: ttyACM1: USB ACM device
[   16.952000] usbcore: registered new interface driver cdc_acm
[   16.952000] drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver for USB modems and ISDN adapters
[   17.268000] Yenta: CardBus bridge found at 0000:01:01.0 [1028:0139]
[   17.268000] Yenta: Using CSCINT to route CSC interrupts to PCI
[   17.268000] Yenta: Routing CardBus interrupts to PCI
[   17.268000] Yenta TI: socket 0000:01:01.0, mfunc 0x012c1202, devctl 0x64
[   17.328000] ieee80211_crypt: registered algorithm 'NULL'
[   17.347000] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   17.347000] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   17.491000] Yenta: ISA IRQ mask 0x0478, PCI irq 11
[   17.491000] Socket status: 30000006
[   17.491000] Yenta: Raising subordinate bus# of parent bus (#01) from #01 to #05
[   17.491000] pcmcia: parent PCI bridge I/O window: 0xe000 - 0xefff
[   17.491000] cs: IO port probe 0xe000-0xefff: clean.
[   17.491000] pcmcia: parent PCI bridge Memory window: 0xfc000000 - 0xfdffffff
[   17.491000] pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x59ffffff
[   17.492000] Yenta: CardBus bridge found at 0000:01:01.1 [1028:0139]
[   17.553000] irda_init()
[   17.553000] NET: Registered protocol family 23
[   17.614000] Yenta: ISA IRQ mask 0x0478, PCI irq 11
[   17.614000] Socket status: 30000047
[   17.614000] Yenta: Raising subordinate bus# of parent bus (#01) from #05 to #09
[   17.614000] pcmcia: parent PCI bridge I/O window: 0xe000 - 0xefff
[   17.614000] cs: IO port probe 0xe000-0xefff: clean.
[   17.614000] pcmcia: parent PCI bridge Memory window: 0xfc000000 - 0xfdffffff
[   17.614000] pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x59ffffff
[   17.890000] bcm43xx driver
[   17.890000] ACPI: PCI Interrupt 0000:01:03.0[A] -> Link [LNKB] -> GSI 7 (level, low) -> IRQ 7
[   17.890000] bcm43xx: Chip ID 0x4306, rev 0x3
[   17.890000] bcm43xx: Number of cores: 5
[   17.890000] bcm43xx: Core 0: ID 0x800, rev 0x4, vendor 0x4243
[   17.890000] bcm43xx: Core 1: ID 0x812, rev 0x5, vendor 0x4243
[   17.890000] bcm43xx: Core 2: ID 0x80d, rev 0x2, vendor 0x4243
[   17.890000] bcm43xx: Core 3: ID 0x807, rev 0x2, vendor 0x4243
[   17.890000] bcm43xx: Core 4: ID 0x804, rev 0x9, vendor 0x4243
[   17.893000] bcm43xx: PHY connected
[   17.894000] bcm43xx: Detected PHY: Analog: 2, Type 2, Revision 2
[   17.894000] bcm43xx: Detected Radio: ID: 2205017f (Manuf: 17f Ver: 2050 Rev: 2)
[   17.894000] bcm43xx: Radio turned off
[   17.894000] bcm43xx: Radio turned off
[   18.307000] cs: IO port probe 0x100-0x3af: excluding 0x280-0x287 0x2f8-0x2ff
[   18.307000] cs: IO port probe 0x3e0-0x4ff: clean.
[   18.308000] cs: IO port probe 0x820-0x8ff: clean.
[   18.308000] cs: IO port probe 0xc00-0xcf7: clean.
[   18.308000] cs: IO port probe 0xa00-0xaff: clean.
[   18.314000] cs: IO port probe 0x100-0x3af: excluding 0x280-0x287 0x2f8-0x2ff
[   18.315000] cs: IO port probe 0x3e0-0x4ff: clean.
[   18.316000] cs: IO port probe 0x820-0x8ff: clean.
[   18.316000] cs: IO port probe 0xc00-0xcf7: clean.
[   18.316000] cs: IO port probe 0xa00-0xaff: clean.
[   19.398000] EXT3 FS on dm-1, internal journal
[   19.809000] loop: module loaded
[   22.092000] kjournald starting.  Commit interval 5 seconds
[   22.100000] EXT3 FS on sda1, internal journal
[   22.100000] EXT3-fs: mounted filesystem with ordered data mode.
[   22.128000] kjournald starting.  Commit interval 5 seconds
[   22.128000] EXT3 FS on dm-3, internal journal
[   22.128000] EXT3-fs: mounted filesystem with ordered data mode.
[   22.204000] Adding 2097144k swap on /dev/mapper/maluch80-swap.  Priority:-1 extents:1 across:2097144k
[   32.038000] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   33.806000] NET: Registered protocol family 10
[   33.806000] lo: Disabled Privacy Extensions
[   33.806000] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   33.806000] Mobile IPv6
[   34.418000] ACPI: Battery Slot [BAT0] (battery present)
[   34.438000] ACPI: AC Adapter [AC] (on-line)
[   34.460000] input: Lid Switch as /class/input/input3
[   34.470000] ACPI: Lid Switch [LID]
[   34.480000] input: Power Button (CM) as /class/input/input4
[   34.489000] ACPI: Power Button (CM) [PBTN]
[   34.500000] input: Sleep Button (CM) as /class/input/input5
[   34.509000] ACPI: Sleep Button (CM) [SBTN]
[   37.954000] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   37.979000] NFSD: starting 90-second grace period
[   40.704000] Clocksource tsc unstable (delta = -2367171701 ns)
[   41.598000] Bluetooth: Core ver 2.11
[   41.598000] NET: Registered protocol family 31
[   41.598000] Bluetooth: HCI device and connection manager initialized
[   41.598000] Bluetooth: HCI socket layer initialized
[   41.615000] Bluetooth: L2CAP ver 2.8
[   41.616000] Bluetooth: L2CAP socket layer initialized
[   41.747000] Bluetooth: RFCOMM socket layer initialized
[   41.747000] Bluetooth: RFCOMM TTY layer initialized
[   41.747000] Bluetooth: RFCOMM ver 1.8

--Boundary-00=_bsGnGEkCfV4tORc
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg-pci.text"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-pci.text"

[    0.000000] Linux version 2.6.22-hrt1 (root@maluch) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #5 PREEMPT Wed Jul 11 19:52:18 CEST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fea6000 (usable)
[    0.000000]  BIOS-e820: 000000003fea6000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec20000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000fee00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] 126MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 261798) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   261798
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   261798
[    0.000000] On node 0 totalpages: 261798
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 253 pages used for memmap
[    0.000000]   HighMem zone: 32169 pages, LIFO batch:7
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FDF00, 0014 (r0 DELL  )
[    0.000000] ACPI: RSDT 3FEF0000, 002C (r1 DELL    CPi R   27D5061C ASL        61)
[    0.000000] ACPI: FACP 3FEF0400, 0074 (r1 DELL    CPi R   27D5061C ASL        61)
[    0.000000] ACPI: DSDT 3FEF0C00, 30C1 (r1 INT430 SYSFexxx     1001 MSFT  100000E)
[    0.000000] ACPI: FACS 3FEFF800, 0040
[    0.000000] ACPI: ASF! 3FEF0800, 005B (r16 DELL    CPi R   27D5061C ASL        61)
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bec10000)
[    0.000000] Built 1 zonelists.  Total pages: 259753
[    0.000000] Kernel command line: root=/dev/mapper/maluch80-rootfs ro vga=773 lapic pci=assign-busses nmi_watchdog=0 netconsole=6665@192.168.1.120/eth0,6666@192.168.1.10/00:18:39:36:D0:B2 loglevel=8 
[    0.000000] netconsole: local port 6665
[    0.000000] netconsole: local IP 192.168.1.120
[    0.000000] netconsole: interface eth0
[    0.000000] netconsole: remote port 6666
[    0.000000] netconsole: remote IP 192.168.1.10
[    0.000000] netconsole: remote ethernet address 00:18:39:36:d0:b2
[    0.000000] Local APIC disabled by BIOS -- reenabling.
[    0.000000] Found and enabled local APIC!
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c0469000 soft=c0468000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1594.873 MHz processor.
[    6.457592] Console: colour dummy device 80x25
[    6.458110] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    6.458624] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    6.490661] Memory: 1029800k/1047192k available (2385k kernel code, 16572k reserved, 889k data, 188k init, 129688k highmem)
[    6.490679] virtual kernel memory layout:
[    6.490680]     fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
[    6.490681]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    6.490683]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    6.490684]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    6.490685]       .init : 0xc0434000 - 0xc0463000   ( 188 kB)
[    6.490687]       .data : 0xc0354771 - 0xc0432bbc   ( 889 kB)
[    6.490688]       .text : 0xc0100000 - 0xc0354771   (2385 kB)
[    6.490704] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[    6.550813] Calibrating delay using timer specific routine.. 3190.58 BogoMIPS (lpj=1595292)
[    6.550865] Mount-cache hash table entries: 512
[    6.550975] CPU: After generic identify, caps: afe9fbbf 00000000 00000000 00000000 00000180 00000000 00000000
[    6.550990] CPU: L1 I cache: 32K, L1 D cache: 32K
[    6.550995] CPU: L2 cache: 2048K
[    6.550998] CPU: After all inits, caps: afe9fbbf 00000000 00000000 00002040 00000180 00000000 00000000
[    6.551008] Intel machine check architecture supported.
[    6.551014] Intel machine check reporting enabled on CPU#0.
[    6.551021] Compat vDSO mapped to ffffe000.
[    6.551034] CPU: Intel(R) Pentium(R) M processor 1.60GHz stepping 06
[    6.551041] Checking 'hlt' instruction... OK.
[    6.554874] ACPI: Core revision 20070126
[    6.556343] ACPI: setting ELCR to 0200 (from 0800)
[    6.659920] NET: Registered protocol family 16
[    6.660023] ACPI: bus type pci registered
[    6.692406] PCI: PCI BIOS revision 2.10 entry at 0xfc96e, last bus=1
[    6.692411] PCI: Using configuration type 1
[    6.692414] Setting up standard PCI resources
[    6.699171] ACPI: Interpreter enabled
[    6.699178] ACPI: (supports S0 S1 S3 S4 S5)
[    6.699199] ACPI: Using PIC for interrupt routing
[    6.710037] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    6.710060] PCI: Probing PCI hardware (bus 00)
[    6.710480] Force enabled HPET at base address 0xfed00000
[    6.710489] PCI quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
[    6.710494] PCI quirk: region 0880-08bf claimed by ICH4 GPIO
[    6.710860] PCI: Transparent bridge - 0000:00:1e.0
[    6.710961] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    6.711287] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    6.730060] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
[    6.730166] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *11
[    6.730268] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 *11)
[    6.730370] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 *11)
[    6.730459] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.730567] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    6.730662] Linux Plug and Play Support v0.97 (c) Adam Belay
[    6.730673] pnp: PnP ACPI init
[    6.730686] ACPI: bus type pnp registered
[    6.756197] pnp: PnP ACPI: found 14 devices
[    6.756202] ACPI: ACPI bus type pnp unregistered
[    6.756208] PnPBIOS: Disabled by ACPI PNP
[    6.756298] SCSI subsystem initialized
[    6.756320] libata version 2.21 loaded.
[    6.756360] PCI: Using ACPI for IRQ routing
[    6.756365] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    6.762797] hpet clockevent registered
[    6.762804] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    6.762811] hpet0: 3 64-bit timers, 14318180 Hz
[    6.763875] pnp: 00:00: iomem range 0x0-0x9fbff could not be reserved
[    6.763881] pnp: 00:00: iomem range 0x9fc00-0x9ffff could not be reserved
[    6.763886] pnp: 00:00: iomem range 0xc0000-0xcffff could not be reserved
[    6.763891] pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
[    6.763899] pnp: 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    6.763904] pnp: 00:02: ioport range 0x800-0x805 has been reserved
[    6.763910] pnp: 00:02: ioport range 0x808-0x80f has been reserved
[    6.763917] pnp: 00:03: ioport range 0xf400-0xf4fe has been reserved
[    6.763922] pnp: 00:03: ioport range 0x806-0x807 has been reserved
[    6.763927] pnp: 00:03: ioport range 0x810-0x85f has been reserved
[    6.763932] pnp: 00:03: ioport range 0x860-0x87f has been reserved
[    6.763937] pnp: 00:03: ioport range 0x880-0x8bf has been reserved
[    6.763942] pnp: 00:03: ioport range 0x8c0-0x8df has been reserved
[    6.763949] pnp: 00:08: ioport range 0x900-0x97f has been reserved
[    6.763957] pnp: 00:0d: ioport range 0x7b0-0x7bb has been reserved
[    6.763962] pnp: 00:0d: ioport range 0x7c0-0x7df has been reserved
[    6.763967] pnp: 00:0d: ioport range 0xbb0-0xbbb has been reserved
[    6.763972] pnp: 00:0d: ioport range 0xbc0-0xbdf has been reserved
[    6.763976] pnp: 00:0d: ioport range 0xfb0-0xfbb has been reserved
[    6.763981] pnp: 00:0d: ioport range 0xfc0-0xfdf has been reserved
[    6.763986] pnp: 00:0d: ioport range 0x13b0-0x13bb has been reserved
[    6.763991] pnp: 00:0d: ioport range 0x13c0-0x13df has been reserved
[    6.764750] Time: tsc clocksource has been installed.
[    6.794251] PCI: Bus 2, cardbus bridge: 0000:01:01.0
[    6.794255]   IO window: 0000e000-0000e0ff
[    6.794260]   IO window: 0000e400-0000e4ff
[    6.794266]   PREFETCH window: 50000000-53ffffff
[    6.794272]   MEM window: 5c000000-5fffffff
[    6.794277] PCI: Bus 6, cardbus bridge: 0000:01:01.1
[    6.794281]   IO window: 0000e800-0000e8ff
[    6.794286]   IO window: 00001000-000010ff
[    6.794291]   PREFETCH window: 54000000-57ffffff
[    6.794297]   MEM window: 60000000-63ffffff
[    6.794302] PCI: Bridge: 0000:00:1e.0
[    6.794307]   IO window: e000-efff
[    6.794313]   MEM window: fc000000-fdffffff
[    6.794319]   PREFETCH window: 50000000-59ffffff
[    6.794332] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    6.794346] PCI: Enabling device 0000:01:01.0 (0000 -> 0003)
[    6.794498] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    6.794503] PCI: setting IRQ 11 as level-triggered
[    6.794508] ACPI: PCI Interrupt 0000:01:01.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
[    6.794526] ACPI: PCI Interrupt 0000:01:01.1[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
[    6.794555] NET: Registered protocol family 2
[    6.803764] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    6.803870] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    6.805252] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[    6.805727] TCP: Hash tables configured (established 131072 bind 65536)
[    6.805744] TCP reno registered
[    6.808916] checking if image is initramfs... it is
[    7.186097] Freeing initrd memory: 3661k freed
[    7.186642] audit: initializing netlink socket (disabled)
[    7.186668] audit(1184655462.171:1): initialized
[    7.186726] highmem bounce pool size: 64 pages
[    7.186896] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    7.187139] io scheduler noop registered
[    7.187161] io scheduler cfq registered (default)
[    7.187181] Boot video device is 0000:00:02.0
[    7.197715] vesafb: framebuffer at 0xf0000000, mapped to 0xf8880000, using 832k, total 832k
[    7.197722] vesafb: mode is 1024x768x8, linelength=1024, pages=0
[    7.197726] vesafb: protected mode interface info at 00ff:44f0
[    7.197731] vesafb: scrolling: redraw
[    7.197735] vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
[    7.209375] Console: switching to colour frame buffer device 128x48
[    7.220963] fb0: VESA VGA frame buffer device
[    7.221106] isapnp: Scanning for PnP cards...
[    7.532834] isapnp: No Plug & Play device found
[    7.534988] Real Time Clock Driver v1.12ac
[    7.535187] Linux agpgart interface v0.102 (c) Dave Jones
[    7.535346] agpgart: Detected an Intel 855GM Chipset.
[    7.537334] agpgart: Detected 892K stolen memory.
[    7.546873] agpgart: AGP aperture is 128M @ 0xf0000000
[    7.547020] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[    7.547623] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.548312] RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
[    7.548536] tg3.c:v3.77 (May 31, 2007)
[    7.548825] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    7.548953] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
[    7.619215] eth0: Tigon3 [partno(BCM95705A50) rev 3001 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:0f:1f:fe:86:35
[    7.619504] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
[    7.619667] eth0: dma_rwctrl[763f0000] dma_mask[64-bit]
[    7.619848] netconsole: device eth0 not up yet, forcing it
[    7.627307] PM: Writing back config space on device 0000:01:00.0 at offset b (was 165d14e4, writing 865d1028)
[    7.627532] PM: Writing back config space on device 0000:01:00.0 at offset 3 (was 0, writing 2008)
[    7.627729] PM: Writing back config space on device 0000:01:00.0 at offset 2 (was 2000000, writing 2000001)
[    7.627942] PM: Writing back config space on device 0000:01:00.0 at offset 1 (was 2b00000, writing 2b00106)
[   11.961639] netconsole: timeout waiting for carrier
[   12.775363] netconsole: network logging started
[   12.780408] ata_piix 0000:00:1f.1: version 2.11
[   12.785479] PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
[   12.790669] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[   12.795675] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[   12.800797] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   12.805895] scsi0 : ata_piix
[   12.810909] scsi1 : ata_piix
[   12.815811] ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001bfa0 irq 14
[   12.820880] ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001bfa8 irq 15
[   12.980687] ata1.00: ATA-6: ST980815A, 3.ALD, max UDMA/100
[   12.985660] ata1.00: 156301488 sectors, multi 8: LBA48 
[   12.997321] ata1.00: configured for UDMA/100
[   13.153290] scsi 0:0:0:0: Direct-Access     ATA      ST980815A        3.AL PQ: 0 ANSI: 5
[   13.158437] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[   13.163492] sd 0:0:0:0: [sda] Write Protect is off
[   13.168500] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   13.173522] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.178654] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[   13.183718] sd 0:0:0:0: [sda] Write Protect is off
[   13.188735] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   13.193709] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.198831]  sda: sda1 sda2 sda3
[   13.258231] sd 0:0:0:0: [sda] Attached SCSI disk
[   13.263373] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[   13.273401] serio: i8042 KBD port at 0x60,0x64 irq 1
[   13.278600] serio: i8042 AUX port at 0x60,0x64 irq 12
[   13.283771] mice: PS/2 mouse device common for all mice
[   13.293163] input: AT Translated Set 2 keyboard as /class/input/input0
[   13.302986] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   13.308366] cpuidle: using governor ladder
[   13.313843] cpuidle: using governor menu
[   13.319228] Advanced Linux Sound Architecture Driver Version 1.0.14 (Thu May 31 09:03:25 2007 UTC).
[   13.324984] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 7
[   13.330250] PCI: setting IRQ 7 as level-triggered
[   13.335639] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 7 (level, low) -> IRQ 7
[   13.341160] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[   13.917209] input: PS/2 Mouse as /class/input/input1
[   13.943776] input: AlpsPS/2 ALPS GlidePoint as /class/input/input2
[   14.168745] intel8x0_measure_ac97_clock: measured 50512 usecs
[   14.173776] intel8x0: clocking to 48000
[   14.179424] ALSA device list:
[   14.184353]   #0: Intel 82801DB-ICH4 with STAC9750,51 at irq 7
[   14.189329] TCP bic registered
[   14.194204] NET: Registered protocol family 1
[   14.199130] NET: Registered protocol family 17
[   14.204116] Using IPI Shortcut mode
[   14.209139] Freeing unused kernel memory: 188k freed
[   15.466133] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3] C4[C3])
[   15.466151] ACPI: Processor [CPU0] (supports 8 throttling states)
[   15.466288] cpuidle: using driver acpi_idle
[   15.469295] ACPI: Thermal Zone [THM] (56 C)
[   15.647223] usbcore: registered new interface driver usbfs
[   15.647256] usbcore: registered new interface driver hub
[   15.647279] usbcore: registered new device driver usb
[   15.648049] USB Universal Host Controller Interface driver v3.0
[   15.648118] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[   15.648137] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   15.648142] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   15.648266] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   15.648289] uhci_hcd 0000:00:1d.0: irq 11, io base 0x0000bf80
[   15.648394] usb usb1: configuration #1 chosen from 1 choice
[   15.648421] hub 1-0:1.0: USB hub found
[   15.648428] hub 1-0:1.0: 2 ports detected
[   15.749243] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
[   15.749272] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   15.749277] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   15.749308] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[   15.749334] uhci_hcd 0000:00:1d.1: irq 11, io base 0x0000bf40
[   15.749452] usb usb2: configuration #1 chosen from 1 choice
[   15.749477] hub 2-0:1.0: USB hub found
[   15.749485] hub 2-0:1.0: 2 ports detected
[   15.850316] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
[   15.850344] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   15.850349] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   15.850379] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[   15.850405] uhci_hcd 0000:00:1d.2: irq 11, io base 0x0000bf20
[   15.850523] usb usb3: configuration #1 chosen from 1 choice
[   15.850549] hub 3-0:1.0: USB hub found
[   15.850557] hub 3-0:1.0: 2 ports detected
[   15.951936] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[   15.951949] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 11 (level, low) -> IRQ 11
[   15.951969] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   15.951974] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   15.952003] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
[   15.952037] ehci_hcd 0000:00:1d.7: debug port 1
[   15.952044] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   15.952054] ehci_hcd 0000:00:1d.7: irq 11, io mem 0xfaeffc00
[   16.038576] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   16.038723] usb usb4: configuration #1 chosen from 1 choice
[   16.038756] hub 4-0:1.0: USB hub found
[   16.038766] hub 4-0:1.0: 6 ports detected
[   16.056063] usb 2-2: new full speed USB device using uhci_hcd and address 2
[   16.139130] ACPI: PCI Interrupt 0000:01:01.2[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
[   16.189331] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[11]  MMIO=[fcfef800-fcfeffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   16.556005] usb 2-2: new full speed USB device using uhci_hcd and address 3
[   16.721188] usb 2-2: configuration #1 chosen from 1 choice
[   16.774274] Initializing USB Mass Storage driver...
[   16.774570] scsi2 : SCSI emulation for USB Mass Storage devices
[   16.774715] usb-storage: device found at 3
[   16.774718] usb-storage: waiting for device to settle before scanning
[   16.774732] usbcore: registered new interface driver usb-storage
[   16.774736] USB Mass Storage support registered.
[   17.444982] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[484fc0001f2bb030]
[   17.766836] Switched to high resolution mode on CPU 0
[   11.173000] Marking TSC unstable due to: possible TSC halt in C2.
[   11.206000] Time: hpet clocksource has been installed.
[   14.179000] usb-storage: device scan complete
[   14.182000] scsi 2:0:0:0: Direct-Access     Sony Eri Memory Stick     0000 PQ: 0 ANSI: 0
[   14.192000] sd 2:0:0:0: [sdb] 126912 512-byte hardware sectors (65 MB)
[   14.197000] sd 2:0:0:0: [sdb] Write Protect is off
[   14.197000] sd 2:0:0:0: [sdb] Mode Sense: 00 6a 00 00
[   14.197000] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   14.206000] sd 2:0:0:0: [sdb] 126912 512-byte hardware sectors (65 MB)
[   14.211000] sd 2:0:0:0: [sdb] Write Protect is off
[   14.211000] sd 2:0:0:0: [sdb] Mode Sense: 00 6a 00 00
[   14.211000] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   14.211000]  sdb: sdb1
[   14.228000] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   15.600000] Attempting manual resume
[   15.622000] swsusp: Basic memory bitmaps created
[   15.629000] swsusp: Basic memory bitmaps freed
[   15.660000] kjournald starting.  Commit interval 5 seconds
[   15.661000] EXT3-fs: mounted filesystem with ordered data mode.
[   18.085000] cdc_acm 2-2:1.1: ttyACM0: USB ACM device
[   18.087000] cdc_acm 2-2:1.3: ttyACM1: USB ACM device
[   18.089000] usbcore: registered new interface driver cdc_acm
[   18.089000] drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver for USB modems and ISDN adapters
[   18.625000] Yenta: CardBus bridge found at 0000:01:01.0 [1028:0139]
[   18.625000] Yenta: Using CSCINT to route CSC interrupts to PCI
[   18.625000] Yenta: Routing CardBus interrupts to PCI
[   18.625000] Yenta TI: socket 0000:01:01.0, mfunc 0x012c1202, devctl 0x64
[   18.648000] ieee80211_crypt: registered algorithm 'NULL'
[   18.684000] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   18.684000] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   18.850000] Yenta: ISA IRQ mask 0x0478, PCI irq 11
[   18.850000] Socket status: 30000006
[   18.850000] pcmcia: parent PCI bridge I/O window: 0xe000 - 0xefff
[   18.850000] cs: IO port probe 0xe000-0xefff: clean.
[   18.850000] pcmcia: parent PCI bridge Memory window: 0xfc000000 - 0xfdffffff
[   18.850000] pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x59ffffff
[   18.851000] Yenta: CardBus bridge found at 0000:01:01.1 [1028:0139]
[   18.991000] Yenta: ISA IRQ mask 0x0478, PCI irq 11
[   18.991000] Socket status: 30000047
[   18.991000] pcmcia: parent PCI bridge I/O window: 0xe000 - 0xefff
[   18.991000] cs: IO port probe 0xe000-0xefff: clean.
[   18.991000] pcmcia: parent PCI bridge Memory window: 0xfc000000 - 0xfdffffff
[   18.991000] pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x59ffffff
[   19.110000] bcm43xx driver
[   19.111000] ACPI: PCI Interrupt 0000:01:03.0[A] -> Link [LNKB] -> GSI 7 (level, low) -> IRQ 7
[   19.111000] bcm43xx: Chip ID 0x4306, rev 0x3
[   19.111000] bcm43xx: Number of cores: 5
[   19.111000] bcm43xx: Core 0: ID 0x800, rev 0x4, vendor 0x4243
[   19.111000] bcm43xx: Core 1: ID 0x812, rev 0x5, vendor 0x4243
[   19.111000] bcm43xx: Core 2: ID 0x80d, rev 0x2, vendor 0x4243
[   19.111000] bcm43xx: Core 3: ID 0x807, rev 0x2, vendor 0x4243
[   19.111000] bcm43xx: Core 4: ID 0x804, rev 0x9, vendor 0x4243
[   19.114000] bcm43xx: PHY connected
[   19.114000] bcm43xx: Detected PHY: Analog: 2, Type 2, Revision 2
[   19.114000] bcm43xx: Detected Radio: ID: 2205017f (Manuf: 17f Ver: 2050 Rev: 2)
[   19.114000] bcm43xx: Radio turned off
[   19.114000] bcm43xx: Radio turned off
[   19.189000] irda_init()
[   19.189000] NET: Registered protocol family 23
[   19.576000] cs: IO port probe 0x100-0x3af: excluding 0x280-0x287 0x2f8-0x2ff
[   19.577000] cs: IO port probe 0x3e0-0x4ff: clean.
[   19.577000] cs: IO port probe 0x820-0x8ff: clean.
[   19.578000] cs: IO port probe 0xc00-0xcf7: clean.
[   19.578000] cs: IO port probe 0xa00-0xaff: clean.
[   19.591000] cs: IO port probe 0x100-0x3af: excluding 0x280-0x287 0x2f8-0x2ff
[   19.592000] cs: IO port probe 0x3e0-0x4ff: clean.
[   19.592000] cs: IO port probe 0x820-0x8ff: clean.
[   19.592000] cs: IO port probe 0xc00-0xcf7: clean.
[   19.592000] cs: IO port probe 0xa00-0xaff: clean.
[   20.678000] EXT3 FS on dm-1, internal journal
[   21.090000] loop: module loaded
[   23.361000] kjournald starting.  Commit interval 5 seconds
[   23.369000] EXT3 FS on sda1, internal journal
[   23.369000] EXT3-fs: mounted filesystem with ordered data mode.
[   23.397000] kjournald starting.  Commit interval 5 seconds
[   23.398000] EXT3 FS on dm-3, internal journal
[   23.398000] EXT3-fs: mounted filesystem with ordered data mode.
[   23.473000] Adding 2097144k swap on /dev/mapper/maluch80-swap.  Priority:-1 extents:1 across:2097144k
[   27.774000] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   29.499000] NET: Registered protocol family 10
[   29.499000] lo: Disabled Privacy Extensions
[   29.499000] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   29.499000] Mobile IPv6
[   30.132000] ACPI: Battery Slot [BAT0] (battery present)
[   30.153000] ACPI: AC Adapter [AC] (on-line)
[   30.175000] input: Lid Switch as /class/input/input3
[   30.184000] ACPI: Lid Switch [LID]
[   30.195000] input: Power Button (CM) as /class/input/input4
[   30.204000] ACPI: Power Button (CM) [PBTN]
[   30.214000] input: Sleep Button (CM) as /class/input/input5
[   30.224000] ACPI: Sleep Button (CM) [SBTN]
[   33.812000] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   33.837000] NFSD: starting 90-second grace period
[   37.445000] Bluetooth: Core ver 2.11
[   37.445000] NET: Registered protocol family 31
[   37.445000] Bluetooth: HCI device and connection manager initialized
[   37.445000] Bluetooth: HCI socket layer initialized
[   37.473000] Bluetooth: L2CAP ver 2.8
[   37.473000] Bluetooth: L2CAP socket layer initialized
[   37.606000] Bluetooth: RFCOMM socket layer initialized
[   37.606000] Bluetooth: RFCOMM TTY layer initialized
[   37.606000] Bluetooth: RFCOMM ver 1.8
[   40.704000] Clocksource tsc unstable (delta = -4026918719 ns)

--Boundary-00=_bsGnGEkCfV4tORc--


