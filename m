Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbXFLTfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbXFLTfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 15:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbXFLTfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 15:35:12 -0400
Received: from mail.bencastricum.nl ([213.84.203.196]:40871 "EHLO
	bencastricum.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbXFLTfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 15:35:09 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jun 2007 15:35:08 EDT
Message-ID: <001d01c7ad27$a0cbf780$0602a8c0@links>
From: "Ben Castricum" <mail0706@bencastricum.nl>
To: <linux-kernel@vger.kernel.org>
Subject: PCI: Bus #0d (-#10) is hidden behind transparent bridge #08 (-#09)
Date: Tue, 12 Jun 2007 21:26:46 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am asked to report this, so I hope this helps anyone. I don't experience 
any problems (well.. besides the intelfb that just doesn't seem to do what I 
want).

Regards,
Ben

root@laptop:/var/adm# diff -u bootmessages-2.6.22-rc4-nopci 
bootmessages-2.6.22-rc4 | more
--- bootmessages-2.6.22-rc4-nopci       2007-06-12 21:14:17.000000000 +0200
+++ bootmessages-2.6.22-rc4     2007-06-12 21:15:50.000000000 +0200
@@ -59,18 +59,18 @@
 Using ACPI (MADT) for SMP configuration information
 Allocating PCI resources starting at 50000000 (gap: 40000000:b8000000)
 Built 1 zonelists.  Total pages: 227584
-Kernel command line: BOOT_IMAGE=2.6.22-rc4 root=803 
video=intelfb:mode=1024x768-32@70
+Kernel command line: BOOT_IMAGE=2.6.22-rc4 root=803 
video=intelfb:mode=1024x768-32@70 pci=assign-busses
 mapped APIC to ffffd000 (fee00000)
 mapped IOAPIC to ffffc000 (fec00000)
 Enabling fast FPU save and restore... done.
 Enabling unmasked SIMD FPU exception support... done.
 Initializing CPU#0
 PID hash table entries: 4096 (order: 12, 16384 bytes)
-Detected 1662.668 MHz processor.
-Console: colour VGA+ 80x60
+Detected 1662.687 MHz processor.
+Console: colour VGA+ 80x25
 Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
 Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
-Memory: 905672k/917504k available (1954k kernel code, 11440k reserved, 999k 
data, 196k init, 0k highmem)
+Memory: 905672k/917504k available (1954k kernel code, 11436k reserved, 999k 
data, 196k init, 0k highmem)
 virtual kernel memory layout:
     fixmap  : 0xfffb8000 - 0xfffff000   ( 284 kB)
     vmalloc : 0xf8800000 - 0xfffb6000   ( 119 MB)
@@ -81,7 +81,7 @@
 Checking if this processor honours the WP bit even in supervisor mode... 
Ok.
 hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
 hpet0: 3 64-bit timers, 14318180 Hz
-Calibrating delay using timer specific routine.. 3329.22 BogoMIPS 
(lpj=6658452)
+Calibrating delay using timer specific routine.. 3329.20 BogoMIPS 
(lpj=6658405)
 Mount-cache hash table entries: 512
 CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 
0000c189 00000000 00000000
 monitor/mwait feature present.
@@ -110,7 +110,7 @@
 CPU0: Intel Genuine Intel(R) CPU           T2300  @ 1.66GHz stepping 08
 Booting processor 1/1 eip 2000
 Initializing CPU#1
-Calibrating delay using timer specific routine.. 3325.13 BogoMIPS 
(lpj=6650265)
+Calibrating delay using timer specific routine.. 3325.08 BogoMIPS 
(lpj=6650171)
 CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 
0000c189 00000000 00000000
 monitor/mwait feature present.
 CPU: L1 I cache: 32K, L1 D cache: 32K
@@ -121,12 +121,12 @@
 Intel machine check architecture supported.
 Intel machine check reporting enabled on CPU#1.
 CPU1: Intel Genuine Intel(R) CPU           T2300  @ 1.66GHz stepping 08
-Total of 2 processors activated (6654.35 BogoMIPS).
+Total of 2 processors activated (6654.28 BogoMIPS).
 ENABLING IO-APIC IRQs
 ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
 checking TSC synchronization [CPU#0 -> CPU#1]: passed.
 Brought up 2 CPUs
-migration_cost=81
+migration_cost=682
 NET: Registered protocol family 16
 ACPI: bus type pci registered
 PCI: Using configuration type 1
@@ -144,10 +144,6 @@
 PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
 PCI quirk: region 1180-11bf claimed by ICH6 GPIO
 PCI: Transparent bridge - 0000:00:1e.0
-PCI: Bus #09 (-#0c) is hidden behind transparent bridge #08 (-#09) (try 
'pci=assign-busses')
-Please report the result to linux-kernel to fix this permanently
-PCI: Bus #0d (-#10) is hidden behind transparent bridge #08 (-#09) (try 
'pci=assign-busses')
-Please report the result to linux-kernel to fix this permanently
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
@@ -179,14 +175,14 @@
 PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.2
 PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.2
 PCI: Cannot allocate resource region 9 of bridge 0000:00:1c.2
-PCI: Cannot allocate resource region 0 of device 0000:05:00.0
+PCI: Cannot allocate resource region 0 of device 0000:03:00.0
 pnp: 00:00: iomem range 0xf8000000-0xfbffffff could not be reserved
 pnp: 00:02: iomem range 0xf8000000-0xfbffffff could not be reserved
 pnp: 00:02: iomem range 0xfed14000-0xfed17fff has been reserved
 pnp: 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
 pnp: 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
 pnp: 00:09: iomem range 0xfed00000-0xfed003ff could not be reserved
-ACPI: PCI Interrupt 0000:08:03.4[A] -> GSI 16 (level, low) -> IRQ 16
+ACPI: PCI Interrupt 0000:04:03.4[A] -> GSI 16 (level, low) -> IRQ 16
 Time: tsc clocksource has been installed.
 Switched to high resolution mode on CPU 0
 Switched to high resolution mode on CPU 1
@@ -203,12 +199,12 @@
   IO window: disabled.
   MEM window: 58100000-581fffff
   PREFETCH window: disabled.
-PCI: Bus 9, cardbus bridge: 0000:08:03.0
+PCI: Bus 5, cardbus bridge: 0000:04:03.0
   IO window: 00003000-000030ff
   IO window: 00003400-000034ff
   PREFETCH window: 50000000-53ffffff
   MEM window: 5c000000-5fffffff
-PCI: Bus 13, cardbus bridge: 0000:08:03.1
+PCI: Bus 9, cardbus bridge: 0000:04:03.1
   IO window: 00003800-000038ff
   IO window: 00003c00-00003cff
   PREFETCH window: 54000000-57ffffff
@@ -225,9 +221,9 @@
 ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 20 (level, low) -> IRQ 19
 PCI: Setting latency timer of device 0000:00:1c.2 to 64
 PCI: Setting latency timer of device 0000:00:1e.0 to 64
-ACPI: PCI Interrupt 0000:08:03.0[A] -> GSI 16 (level, low) -> IRQ 16
-PCI: Enabling device 0000:08:03.1 (0080 -> 0083)
-ACPI: PCI Interrupt 0000:08:03.1[A] -> GSI 16 (level, low) -> IRQ 16
+ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 16 (level, low) -> IRQ 16
+PCI: Enabling device 0000:04:03.1 (0080 -> 0083)
+ACPI: PCI Interrupt 0000:04:03.1[A] -> GSI 16 (level, low) -> IRQ 16
 NET: Registered protocol family 2
 IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
 TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
@@ -311,13 +307,13 @@
 ata3: SATA max UDMA/133 cmd 0xf883a600 ctl 0x00000000 bmdma 0x00000000 irq 
0
 ata4: SATA max UDMA/133 cmd 0xf883a680 ctl 0x00000000 bmdma 0x00000000 irq 
0
 ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00000e10036519df]
+Clocksource tsc unstable (delta = -119320063 ns)
 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
 ata1.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
 ata1.00: ATA-7: ST98823AS, 3.04, max UDMA/133
 ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
 ata1.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
 ata1.00: configured for UDMA/133
-Clocksource tsc unstable (delta = -107327923 ns)
 ata2: SATA link down (SStatus 0 SControl 0)
 ata3: SATA link down (SStatus 0 SControl 300)
 ata4: SATA link down (SStatus 0 SControl 0)
@@ -367,9 +363,9 @@
 NET: Registered protocol family 1
 Adding 987988k swap on /dev/sda2.  Priority:-1 extents:1 across:987988k
 EXT3 FS on sda3, internal journal
-ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
-PCI: Setting latency timer of device 0000:02:00.0 to 64
-sky2 0000:02:00.0: v1.14 addr 0xf0000000 irq 16 Yukon-EC Ultra (0xb4) rev 2
+ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
+PCI: Setting latency timer of device 0000:01:00.0 to 64
+sky2 0000:01:00.0: v1.14 addr 0xf0000000 irq 16 Yukon-EC Ultra (0xb4) rev 2
 sky2 eth0: addr 00:17:42:13:2a:f3
 NET: Registered protocol family 17
 sky2 eth0: enabling interface
root@laptop:/var/adm# lspci -vv
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT 
Express Memory Controller Hub (rev 03)
        Subsystem: Fujitsu Limited. Unknown device 1378
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS/940GML 
Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA])
        Subsystem: Fujitsu Limited. Unknown device 137a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f0300000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at 1800 [size=8]
        Region 2: Memory at e0000000 (32-bit, prefetchable) [size=256M]
        Region 3: Memory at f0400000 (32-bit, non-prefetchable) [size=256K]
        Capabilities: [90] Message Signalled Interrupts: 64bit- Queue=0/0 
Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML 
Express Integrated Graphics Controller (rev 03)
        Subsystem: Fujitsu Limited. Unknown device 137a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: Memory at f0380000 (32-bit, non-prefetchable) [size=512K]
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition 
Audio Controller (rev 02)
        Subsystem: Fujitsu Limited. Unknown device 1397
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at f0640000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=0/0 
Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x0, ASPM unknown, Port 
0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 
1 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: f0000000-f00fffff
        Prefetchable memory behind bridge: 0000000058000000-0000000058000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ 
Surpise+
                Slot: Number 2, PowerLimit 6.500000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 
Enable+
                Address: fee0300c  Data: 41c9
        Capabilities: [90] #0d [0000]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 
2 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 2
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ 
Surpise+
                Slot: Number 3, PowerLimit 6.500000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 
Enable+
                Address: fee0300c  Data: 41d1
        Capabilities: [90] #0d [0000]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 
3 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        Memory behind bridge: 58100000-581fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 3
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ 
Surpise+
                Slot: Number 4, PowerLimit 6.500000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 
Enable+
                Address: fee0300c  Data: 41d9
        Capabilities: [90] #0d [0000]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: Fujitsu Limited. Unknown device 1389
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 4: I/O ports at 1820 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: Fujitsu Limited. Unknown device 1389
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 11
        Region 4: I/O ports at 1840 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: Fujitsu Limited. Unknown device 1389
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 11
        Region 4: I/O ports at 1860 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: Fujitsu Limited. Unknown device 1389
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 11
        Region 4: I/O ports at 1880 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
Controller (rev 02) (prog-if 20 [EHCI])
        Subsystem: Fujitsu Limited. Unknown device 138a
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at f0644000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) 
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=04, subordinate=0c, sec-latency=32
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: f0200000-f02fffff
        Prefetchable memory behind bridge: 0000000050000000-0000000057f00000
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] #0d [0000]

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge 
(rev 02)
        Subsystem: Fujitsu Limited. Unknown device 1384
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller 
(rev 02) (prog-if 8a [Master SecP PriP])
        Subsystem: Fujitsu Limited. Unknown device 1385
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 21
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at 1810 [size=16]

00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial 
ATA Storage Controller AHCI (rev 02) (prog-if 01 [AHCI 1.0])
        Subsystem: Fujitsu Limited. Unknown device 1387
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 220
        Region 0: I/O ports at 18d0 [size=8]
        Region 1: I/O ports at 18c4 [size=4]
        Region 2: I/O ports at 18c8 [size=8]
        Region 3: I/O ports at 18c0 [size=4]
        Region 4: I/O ports at 18b0 [size=16]
        Region 5: Memory at f0644400 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 
Enable+
                Address: fee0300c  Data: 41e9
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 
02)
        Subsystem: Fujitsu Limited. Unknown device 1388
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 11
        Region 4: I/O ports at 18e0 [size=32]

01:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8055 PCI-E 
Gigabit Ethernet Controller (rev 12)
        Subsystem: Fujitsu Limited. Unknown device 139a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 219
        Region 0: Memory at f0000000 (64-bit, non-prefetchable) [size=16K]
        Region 2: I/O ports at 2000 [size=256]
        [virtual] Expansion ROM at 58000000 [disabled] [size=128K]
        Capabilities: [48] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
        Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 
Enable+
                Address: 00000000fee0300c  Data: 413a
        Capabilities: [e0] Express Legacy Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
                Link: Latency L0s <256ns, L1 unlimited
                Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1

03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network 
Connection (rev 02)
        Subsystem: Intel Corporation Unknown device 1001
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at 58100000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0 
Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] Express Legacy Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                Device: Latency L0s <512ns, L1 unlimited
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
                Link: Latency L0s <128ns, L1 <64us
                Link: ASPM L0s L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1

04:03.0 CardBus bridge: O2 Micro, Inc. OZ711MP1/MS1 MemoryCardBus Controller 
(rev 21)
        Subsystem: Fujitsu Limited. Unknown device 131e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f0203000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=04, secondary=05, subordinate=08, sec-latency=176
        Memory window 0: 50000000-53fff000 (prefetchable)
        Memory window 1: 5c000000-5ffff000
        I/O window 0: 00003000-000030ff
        I/O window 1: 00003400-000034ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ 
PostWrite-
        16-bit legacy interface ports at 0001

04:03.1 CardBus bridge: O2 Micro, Inc. OZ711MP1/MS1 MemoryCardBus Controller 
(rev 21)
        Subsystem: Fujitsu Limited. Unknown device 131e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping+ SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f0204000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=04, secondary=09, subordinate=0c, sec-latency=176
        Memory window 0: 54000000-57fff000 (prefetchable)
        Memory window 1: 60000000-63fff000
        I/O window 0: 00003800-000038ff
        I/O window 1: 00003c00-00003cff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ 
PostWrite-
        16-bit legacy interface ports at 0001

04:03.2 Class 0805: O2 Micro, Inc. Integrated MMC/SD Controller (rev 01)
        Subsystem: Fujitsu Limited. Unknown device 131e
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at f0202800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

04:03.3 Bridge: O2 Micro, Inc. Integrated MS/xD Controller (rev 01)
        Subsystem: Fujitsu Limited. Unknown device 131e
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at f0200000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

04:03.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02) 
(prog-if 10 [OHCI])
        Subsystem: O2 Micro, Inc. Firewire (IEEE 1394)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f0201000 (32-bit, non-prefetchable) [size=4K]
        Region 1: Memory at f0202000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+

root@laptop:/var/adm#

