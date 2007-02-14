Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbXBNAGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbXBNAGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932078AbXBNAGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:06:43 -0500
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:54627 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932077AbXBNAGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:06:40 -0500
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200702140006.l1E06awJ013179@turbo.physics.adelaide.edu.au>
Subject: Bus behind transparent bridge
To: linux-kernel@vger.kernel.org
Date: Wed, 14 Feb 2007 10:36:36 +1030 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe)
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When booting my laptop I notice the following message:

  PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
  PCI quirk: region 1180-11bf claimed by ICH6 GPIO
  PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
  PCI: Transparent bridge - 0000:00:1e.0
  PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06 (-#07) (try
  'pci=assign-busses')
  Please report the result to linux-kernel to fix this permanently

I've tried using the "pci=assign-busses" kernel parameter but it didn't
seem to make any difference to the boot messages.  In any case, I'm 
reporting it as requested.

The machine is a 2.0 GHz Dothan Centrino.  I'm happy to test things and/or
provide more info if it will help.

Full dmesg is below.  This was with an RT kernel but the same message
appears with a stock kernel (as I would expect given what it is).

Regards
  jonathan

Linux version 2.6.19.2-rt15 (jwoithe@halite) (gcc version 3.4.6) #2 PREEMPT Sat Jan 13 07:47:59 CST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003f670000 (usable)
 BIOS-e820: 000000003f670000 - 000000003f681000 (ACPI data)
 BIOS-e820: 000000003f681000 - 000000003f700000 (ACPI NVS)
 BIOS-e820: 000000003f700000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0010000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
118MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 259696) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   259696
early_node_map[1] active PFN ranges
    0:        0 ->   259696
On node 0 totalpages: 259696
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 236 pages used for memmap
  HighMem zone: 30084 pages, LIFO batch:7
DMI 2.3 present.
ACPI: RSDP (v000 FUJ                                   ) @ 0x000f5710
ACPI: RSDT (v001 FUJ    FJNB19C  0x01050000 FUJ  0x00000100) @ 0x3f67a548
ACPI: FADT (v001 FUJ    FJNB19C  0x01050000 FUJ  0x00000100) @ 0x3f680f8c
ACPI: MADT (v001 FUJ    FJNB19C  0x01050000 FUJ  0x00000100) @ 0x3f680686
ACPI: SSDT (v001 FUJ    FJNB19C  0x01050000 INTL 0x20030522) @ 0x3f6806e0
ACPI: SSDT (v001 FUJ    FJNB19C  0x01050000 INTL 0x20030522) @ 0x3f680b25
ACPI: SSDT (v001 FUJ    FJNB19C  0x01050000 INTL 0x20030522) @ 0x3f680d01
ACPI: MCFG (v001 FUJ    FJNB19C  0x01050000 FUJ  0x00000100) @ 0x3f680f28
ACPI: BOOT (v001 FUJ    FJNB19C  0x01050000 FUJ  0x00000100) @ 0x3f680f64
ACPI: DSDT (v001 FUJ    FJNB19C  0x01050000 MSFT 0x0100000e) @ 0x00000000
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:13 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
Detected 1995.112 MHz processor.
Real-Time Preemption Support (C) 2004-2006 Ingo Molnar
Built 1 zonelists.  Total pages: 257668
Kernel command line: BOOT_IMAGE=L-2.6.19.2-rt15 ro root=801 acpi_sleep=s3_bios
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
WARNING: experimental RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1025724k/1038784k available (2212k kernel code, 12396k reserved, 794k data, 156k init, 121280k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03f2000 - 0xc0419000   ( 156 kB)
      .data : 0xc03290c5 - 0xc03ef8cc   ( 794 kB)
      .text : 0xc0100000 - 0xc03290c5   (2212 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3992.36 BogoMIPS (lpj=1996184)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: afe9fbff 00100000 00000000 00000000 00000180 00000000 00000000
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: After all inits, caps: afe9fbff 00100000 00000000 00000040 00000180 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Pentium(R) M processor 2.00GHz stepping 08
Checking 'hlt' instruction... OK.
ACPI: Core revision 20060707
ENABLING IO-APIC IRQs
.TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:00:02.0
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
PCI: Transparent bridge - 0000:00:1e.0
PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06 (-#07) (try 'pci=assign-busses')
Please report the result to linux-kernel to fix this permanently
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
intel_rng: FWH not detected
SCSI subsystem initialized
libata version 2.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.1
PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.1
PCI: Cannot allocate resource region 9 of bridge 0000:00:1c.1
PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: b0100000-b01fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bus 7, cardbus bridge: 0000:06:03.0
  IO window: 00002000-000020ff
  IO window: 00002400-000024ff
  PREFETCH window: 50000000-51ffffff
  MEM window: 54000000-55ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 2000-2fff
  MEM window: b0200000-b02fffff
  PREFETCH window: 50000000-51ffffff
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:06:03.0[A] -> GSI 16 (level, low) -> IRQ 17
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1835008 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x7f set to 0x1
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
Allocate Port Service[0000:00:1c.1:pcie03]
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [CMB1] (battery present)
ACPI: Battery Slot [CMB2] (battery absent)
ACPI: Power Button (FF) [PWRF]
ACPI: Lid Switch [LID]
ACPI: Power Button (CM) [PWRB]
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH6: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
ICH6: chipset revision 4
ICH6: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1410-0x1417, BIOS settings: hda:DMA, hdb:pio
Probing IDE interface ide0...
hda: MATSHITADVD-RAM UJ-840S, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ahci 0000:00:1f.2: version 2.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ahci 0000:00:1f.2: AHCI 0001.0000 32 slots 4 ports 1.5 Gbps 0x5 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part 
ata1: SATA max UDMA/133 cmd 0xF8818500 ctl 0x0 bmdma 0x0 irq 19
ata2: SATA max UDMA/133 cmd 0xF8818580 ctl 0x0 bmdma 0x0 irq 19
ata3: SATA max UDMA/133 cmd 0xF8818600 ctl 0x0 bmdma 0x0 irq 19
ata4: SATA max UDMA/133 cmd 0xF8818680 ctl 0x0 bmdma 0x0 irq 19
scsi0 : ahci
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7, max UDMA/100, 156301488 sectors: LBA48 NCQ (depth 31/32)
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/100
scsi1 : ahci
ata2: SATA link down (SStatus 0 SControl 0)
scsi2 : ahci
ata3: SATA link down (SStatus 0 SControl 300)
scsi3 : ahci
ata4: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHT2080B 0000 PQ: 0 ANSI: 5
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
EDAC MC: Ver: 2.0.1 Jan 13 2007
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
ACPI: (supports S0 S3 S4<6>Switched to high resolution mode on CPU 0
 S5)
input: AT Translated Set 2 keyboard as /class/input/input0
Synaptics Touchpad, model: 1, fw: 5.9, id: 0xf8eb1, caps: 0xa04793/0x102000
serio: Synaptics pass-through port at isa0060/serio4/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input1
input: PS/2 Generic Mouse as /class/input/input2
ReiserFS: sda1: found reiserfs format "3.6" with standard journal
ReiserFS: sda1: using ordered data mode
ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda1: checking transaction log (sda1)
ReiserFS: sda1: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 156k freed
Write protecting the kernel read-only data: 379k
Adding 506008k swap on /dev/sda5.  Priority:-1 extents:1 across:506008k
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected an Intel 915GM Chipset.
agpgart: Detected 7932K stolen memory.
agpgart: AGP aperture is 256M @ 0xc0000000
[drm] Initialized drm 1.0.1 20051102
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 17
[drm] Initialized i915 1.5.0 20060119 on minor 0
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001420
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001440
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001460
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 17, io base 0x00001480
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xb0004000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
ACPI: PCI Interrupt 0000:06:06.0[A] -> GSI 21 (level, low) -> IRQ 21
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[b0205000-b02057ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ieee1394: raw1394: /dev/raw1394 device initialized
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00000e10032944cc]
ReiserFS: sda6: found reiserfs format "3.6" with standard journal
ReiserFS: sda6: using ordered data mode
ReiserFS: sda6: journal params: device sda6, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda6: checking transaction log (sda6)
ReiserFS: sda6: Using r5 hash to sort names
ReiserFS: sda7: found reiserfs format "3.6" with standard journal
ReiserFS: sda7: using ordered data mode
ReiserFS: sda7: journal params: device sda7, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda7: checking transaction log (sda7)
ReiserFS: sda7: Using r5 hash to sort names
ReiserFS: sda8: found reiserfs format "3.6" with standard journal
ReiserFS: sda8: using ordered data mode
ReiserFS: sda8: journal params: device sda8, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda8: checking transaction log (sda8)
ReiserFS: sda8: Using r5 hash to sort names
Yenta: CardBus bridge found at 0000:06:03.0 [10cf:131e]
Yenta O2: res at 0x94/0xD4: 00/ea
Yenta O2: enabling read prefetch/write burst
Yenta: ISA IRQ mask 0x0cb8, PCI irq 17
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#06) from #07 to #0a
pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
pcmcia: parent PCI bridge Memory window: 0xb0200000 - 0xb02fffff
pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x51ffffff
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1b.0 to 64
ALSA sound/pci/hda/hda_intel.c:695: codec_mask = 0x3
ALSA sound/pci/hda/hda_codec.c:1749: hda_codec: PCI 10cf:1326, codec config 3 is selected
ALSA sound/pci/hda/hda_intel.c:555: hda_intel: azx_get_response timeout, switching to polling mode...
usb 5-3: new high speed USB device using ehci_hcd and address 2
usb 5-3: configuration #1 chosen from 1 choice
scsi4 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
scsi 4:0:0:0: Direct-Access     USB2.0   Flash Disk       2.00 PQ: 0 ANSI: 2
SCSI device sdb: 4144128 512-byte hdwr sectors (2122 MB)
sdb: Write Protect is off
sdb: Mode Sense: 0b 00 00 08
sdb: assuming drive cache: write through
SCSI device sdb: 4144128 512-byte hdwr sectors (2122 MB)
sdb: Write Protect is off
sdb: Mode Sense: 0b 00 00 08
sdb: assuming drive cache: write through
 sdb: sdb1
sd 4:0:0:0: Attached scsi removable disk sdb
sd 4:0:0:0: Attached scsi generic sg1 type 0
usb-storage: device scan complete
ReiserFS: sdb1: found reiserfs format "3.6" with standard journal
ReiserFS: sdb1: using ordered data mode
ReiserFS: sdb1: journal params: device sdb1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sdb1: checking transaction log (sdb1)
ReiserFS: sdb1: Using r5 hash to sort names
