Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbXCKDjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbXCKDjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 22:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbXCKDjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 22:39:18 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:42306 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809AbXCKDjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 22:39:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BS++r0pzY5g9chYIRZUWPrjlczdmz/F95dV3BpEoqnszax40M5sw5uoIshG5ufYJVjzXlppCAyAZpF0ZoP1x6aRsbOlXFsD7mQ9xGuOCOxLOl3+CbzzD8ByYQx0fJlLG10+8qQMPVmfGToxUI4jxm7DbqeeqH9fVgk30jn9LE/c=
Message-ID: <dcbc67440703101939y596aeb90hf2dc727b546cfbf@mail.gmail.com>
Date: Sun, 11 Mar 2007 00:39:16 -0300
From: "Gerardo Exequiel Pozzi" <djgera@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: ATA: abnormal status 0x7F on port 0xNNNN since 2.6.20
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since linux 2.6.20 the kernel log shows at boot time these error. The
system are stable, but shows this, that in 2.6.19.N does not show.
(please CC to my email, i am currently not subscribe to lkml)

Thanks,


Linux version 2.6.20.2 (root@djgera) (gcc version 3.4.6) #1 PREEMPT Fri
Mar 9 21:43:32 ART 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end:
000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end:
00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end:
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001fef0000 end:
000000001fff0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001fff0000 size: 0000000000008000 end:
000000001fff8000 type: 3
copy_e820_map() start: 000000001fff8000 size: 0000000000008000 end:
0000000020000000 type: 4
copy_e820_map() start: 00000000fec00000 size: 0000000000001000 end:
00000000fec01000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end:
00000000fee01000 type: 2
copy_e820_map() start: 00000000fff80000 size: 0000000000080000 end:
0000000100000000 type: 2
BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
BIOS-e820: 000000001fff0000 - 000000001fff8000 (ACPI data)
BIOS-e820: 000000001fff8000 - 0000000020000000 (ACPI NVS)
BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
511MB LOWMEM available.
Entering add_active_range(0, 0, 131056) 0 entries of 256 used
Zone PFN ranges:
 DMA             0 ->     4096
 Normal       4096 ->   131056
early_node_map[1] active PFN ranges
   0:        0 ->   131056
On node 0 totalpages: 131056
 DMA zone: 32 pages used for memmap
 DMA zone: 0 pages reserved
 DMA zone: 4064 pages, LIFO batch:0
 Normal zone: 991 pages used for memmap
 Normal zone: 125969 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP (v000 AMI                                   ) @ 0x000fa8c0
ACPI: RSDT (v001 AMIINT VIA_K7   0x00000010 MSFT 0x00000097) @ 0x1fff0000
ACPI: FADT (v001 AMIINT VIA_K7   0x00000011 MSFT 0x00000097) @ 0x1fff0030
ACPI: MADT (v001 AMIINT VIA_K7   0x00000009 MSFT 0x00000097) @ 0x1fff00c0
ACPI: DSDT (v001    VIA    K7VT4 0x00001000 INTL 0x02002024) @ 0x00000000
ACPI: PM-Timer IO Port: 0x808
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Detected 1666.250 MHz processor.
Built 1 zonelists.  Total pages: 130033
Kernel command line: BOOT_IMAGE=2.6.20.2 ro root=305
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 516100k/524224k available (2321k kernel code, 7572k reserved,
462k data, 144k init, 0k highmem)
virtual kernel memory layout:
   fixmap  : 0xffff8000 - 0xfffff000   (  28 kB)
   vmalloc : 0xe0800000 - 0xffff6000   ( 503 MB)
   lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
     .init : 0xc03bc000 - 0xc03e0000   ( 144 kB)
     .data : 0xc0344554 - 0xc03b806c   ( 462 kB)
     .text : 0xc0100000 - 0xc0344554   (2321 kB)
Checking if this processor honours the WP bit even in supervisor mode...
Ok.
Calibrating delay using timer specific routine.. 3334.64 BogoMIPS
(lpj=1667322)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383fbff c1cbfbff 00000000 00000000
00000000 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: After all inits, caps: 0383fbff c1cbfbff 00000000 00000420 00000000
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: AMD Sempron(tm) 2400+ stepping 01
Checking 'hlt' instruction... OK.
ACPI: Core revision 20060707
ACPI: setting ELCR to 0200 (from 0c88)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfda71, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [URP2] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 9 devices
SCSI subsystem initialized
libata version 2.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
report
PCI: Bridge: 0000:00:01.0
 IO window: disabled.
 MEM window: dde00000-dfefffff
 PREFETCH window: bdd00000-ddcfffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 16384 bind 8192)
TCP reno registered
SGI XFS with no debug enabled
io scheduler noop registered
io scheduler cfq registered (default)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected VIA KT400/KT400A/KT600 chipset
agpgart: AGP aperture is 64M @ 0xe0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
loop: loaded (max 8 devices)
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 3
PCI: setting IRQ 3 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 3 (level, low)
-> IRQ 3
eth0: RealTek RTL8139 at 0xe081af00, 00:e0:7d:b3:eb:e3, IRQ 3
eth0:  Identified 8139 chip type 'RTL-8139C'
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller at PCI slot 0000:00:0f.1
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [LNKA] -> GSI 11 (level,
low) -> IRQ 11
PCI: VIA VLink IRQ fixup for 0000:00:0f.1, from 255 to 11
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
   ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:DMA, hdb:pio
   ide1: BM-DMA at 0xfc08-0xfc0f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: Maxtor 6E030L0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: HL-DT-STDVD-ROM GDR8163B, ATAPI CD/DVD-ROM drive
hdd: HL-DT-STDVDRRW GWA-4161B, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 60058656 sectors (30750 MB) w/2048KiB Cache, CHS=59582/16/63,
UDMA(133)
hda: cache flushes supported
hda: hda1 hda2 < hda5 hda6 hda7 hda8 hda9 > hda3 hda4
hdc: ATAPI 52X DVD-ROM drive, 256kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
sata_via 0000:00:0f.0: version 2.0
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [LNKB] -> GSI 10 (level,
low) -> IRQ 10
sata_via 0000:00:0f.0: routed to hard irq line 10
ata1: SATA max UDMA/133 cmd 0xEC00 ctl 0xE802 bmdma 0xDC00 irq 10
ata2: SATA max UDMA/133 cmd 0xE400 ctl 0xE002 bmdma 0xDC08 irq 10
scsi0 : sata_via
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ATA: abnormal status 0x7F on port 0xEC07
ATA: abnormal status 0x7F on port 0xEC07
ata1.00: ATA-7, max UDMA/133, 320173056 sectors: LBA48
ata1.00: ata1: dev 0 multi count 0
ata1.00: configured for UDMA/133
scsi1 : sata_via
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ATA: abnormal status 0x7F on port 0xE407
ATA: abnormal status 0x7F on port 0xE407
ata2.00: ATA-7, max UDMA/133, 398297088 sectors: LBA48 NCQ (depth 0/32)
ata2.00: ata2: dev 0 multi count 0
ata2.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y160M0   YAR5 PQ: 0
ANSI: 5
SCSI device sda: 320173056 512-byte hdwr sectors (163929 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sda: 320173056 512-byte hdwr sectors (163929 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6V200E0   VA11 PQ: 0
ANSI: 5
SCSI device sdb: 398297088 512-byte hdwr sectors (203928 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sdb: 398297088 512-byte hdwr sectors (203928 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sdb: sdb1 sdb2
sd 1:0:0:0: Attached scsi disk sdb
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input3
input: PC Speaker as /class/input/input4
input: ImPS/2 Generic Wheel Mouse as /class/input/input5
Creative EMU10K1 PCI Audio Driver, version 0.20a, 21:41:53 Mar  9 2007
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 7
PCI: setting IRQ 7 as level-triggered
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKD] -> GSI 7 (level, low)
-> IRQ 7
emu10k1: EMU10K1 rev 8 model 0x20 found, IO at 0xd000-0xd01f, IRQ 7
ac97_codec: AC97 Audio codec, id: 0x8384:0x7609 (SigmaTel STAC9721/23)
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
ACPI: (supports S0 S1 S4 S5)
Time: tsc clocksource has been installed.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 144k freed

00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600 AGP]
Host Bridge (rev 80)
       Subsystem: ASRock Incorporation K7VT6 motherboard
       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
       Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
       Latency: 8
       Region 0: Memory at e0000000 (32-bit, prefetchable) [size=64M]
       Capabilities: [80] AGP version 3.5
               Status: RQ=32 Iso- ArqSz=0 Cal=2 SBA+ ITACoh- GART64-
HTrans- 64bit- FW- AGP3+ Rate=x4,x8
               Command: RQ=1 ArqSz=0 Cal=2 SBA+ AGP+ GART64- 64bit- FW-
Rate=x8
       Capabilities: [c0] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge (prog-if 00
[Normal decode])
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
       Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
       Latency: 0
       Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
       Memory behind bridge: dde00000-dfefffff
       Prefetchable memory behind bridge: bdd00000-ddcfffff
       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
       BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
       Capabilities: [80] Power Management version 2
               Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0a.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 10)
       Subsystem: Realtek Semiconductor Co., Ltd. RT8139
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
       Latency: 32 (8000ns min, 16000ns max)
       Interrupt: pin A routed to IRQ 3
       Region 0: I/O ports at d400 [size=256]
       Region 1: Memory at dfffbf00 (32-bit, non-prefetchable) [size=256]
       Capabilities: [50] Power Management version 2
               Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0b.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev
08)
       Subsystem: Creative Labs CT4850 SBLive! Value
       Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-

<TAbort- <MAbort- >SERR- <PERR-
       Latency: 32 (500ns min, 5000ns max)
       Interrupt: pin A routed to IRQ 7
       Region 0: I/O ports at d000 [size=32]
       Capabilities: [dc] Power Management version 1
               Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID
Controller (rev 80)
       Subsystem: ASRock Incorporation K7VT6 motherboard
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
       Latency: 32
       Interrupt: pin B routed to IRQ 10
       Region 0: I/O ports at ec00 [size=8]
       Region 1: I/O ports at e800 [size=4]
       Region 2: I/O ports at e400 [size=8]
       Region 3: I/O ports at e000 [size=4]
       Region 4: I/O ports at dc00 [size=16]
       Region 5: I/O ports at d800 [size=256]
       Capabilities: [c0] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0f.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
(prog-if 8a [Master SecP PriP])
       Subsystem: ASRock Incorporation K7VT2/K7VT6 motherboard
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
       Latency: 32
       Interrupt: pin A routed to IRQ 11
       Region 0: [virtual] Memory at 000001f0 (32-bit,
non-prefetchable) [size=8]
       Region 1: [virtual] Memory at 000003f0 (type 3,
non-prefetchable) [size=1]
       Region 2: [virtual] Memory at 00000170 (32-bit,
non-prefetchable) [size=8]
       Region 3: [virtual] Memory at 00000370 (type 3,
non-prefetchable) [size=1]
       Region 4: I/O ports at fc00 [size=16]
       Capabilities: [c0] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81) (prog-if 00 [UHCI])
       Subsystem: ASRock Incorporation K7VT6
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
       Latency: 32, Cache Line Size: 32 bytes
       Interrupt: pin A routed to IRQ 11
       Region 4: I/O ports at c000 [size=32]
       Capabilities: [80] Power Management version 2
               Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81) (prog-if 00 [UHCI])
       Subsystem: ASRock Incorporation K7VT6
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
       Latency: 32, Cache Line Size: 32 bytes
       Interrupt: pin A routed to IRQ 11
       Region 4: I/O ports at c400 [size=32]
       Capabilities: [80] Power Management version 2
               Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81) (prog-if 00 [UHCI])
       Subsystem: ASRock Incorporation K7VT6
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
       Latency: 32, Cache Line Size: 32 bytes
       Interrupt: pin B routed to IRQ 10
       Region 4: I/O ports at c800 [size=32]
       Capabilities: [80] Power Management version 2
               Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81) (prog-if 00 [UHCI])
       Subsystem: ASRock Incorporation K7VT6
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-

<TAbort- <MAbort- >SERR- <PERR-
       Latency: 32, Cache Line Size: 32 bytes
       Interrupt: pin B routed to IRQ 10
       Region 4: I/O ports at cc00 [size=32]
       Capabilities: [80] Power Management version 2
               Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86) (prog-if
20 [EHCI])
       Subsystem: ASRock Incorporation K7VT6 motherboard
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
       Latency: 32, Cache Line Size: 32 bytes
       Interrupt: pin C routed to IRQ 3
       Region 0: Memory at dfffbd00 (32-bit, non-prefetchable) [size=256]
       Capabilities: [80] Power Management version 2
               Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge
[KT600/K8T800/K8T890 South]
       Subsystem: ASRock Incorporation K7VT4 motherboard
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping+ SERR- FastB2B-
       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
       Latency: 0
       Capabilities: [c0] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: nVidia Corporation NV34 [GeForce FX
5500] (rev a1) (prog-if 00 [VGA])
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
       Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
       Latency: 248 (1250ns min, 250ns max)
       Interrupt: pin A routed to IRQ 11
       Region 0: Memory at de000000 (32-bit, non-prefetchable) [size=16M]
       Region 1: Memory at c0000000 (32-bit, prefetchable) [size=256M]
       [virtual] Expansion ROM at dfee0000 [disabled] [size=128K]
       Capabilities: [60] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-
       Capabilities: [44] AGP version 3.0
               Status: RQ=32 Iso- ArqSz=0 Cal=3 SBA+ ITACoh- GART64-
HTrans- 64bit- FW+ AGP3+ Rate=x4,x8
               Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit-
FW- Rate=x8
