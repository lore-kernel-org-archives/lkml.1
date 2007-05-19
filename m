Return-Path: <linux-kernel-owner+w=401wt.eu-S1763962AbXESWbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763962AbXESWbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757826AbXESWa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:30:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:63091 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779AbXESWa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:30:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Gd0O+r1i5lmBQLtJ9sKIPKsUkhA4HQeOcfM34vm0aKgc/dQewbfU0yrxnLzGacOWg8CI0m5cPKyzqD9es0FG/XScnJwVlYDxis8GVwgv+e5NfHZY43v4EUBy/qdE1KNAJpjn0t/dCfxSDUEn9juioJsWTwmdS1/l5AClXVNTBHc=
Message-ID: <dcf706c60705191530x5a78f9aewbb520a97ad516f6d@mail.gmail.com>
Date: Sun, 20 May 2007 00:30:55 +0200
From: "Sasa Ostrouska" <casaxa@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: STRANGE ERROR
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

I tried today to upgrade the kernel to 2.6.21.1 and i got the same
error during the boot time.
Here is the dmesg of the 2.6.20.2, can somebody tell me what this is ?

Linux version 2.6.20.2 (root@server) (gcc version 3.4.6) #1 SMP
PREEMPT Sat May 19 17:51:41 CEST 2007
Command line: BOOT_IMAGE=Linux-26202 ro root=803
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007bfb0000 (usable)
 BIOS-e820: 000000007bfb0000 - 000000007bfc0000 (ACPI data)
 BIOS-e820: 000000007bfc0000 - 000000007bff0000 (ACPI NVS)
 BIOS-e820: 000000007bff0000 - 000000007c000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 507824) 1 entries of 256 used
end_pfn_map = 1048576
DMI present.
ACPI: RSDP (v000 ACPIAM                                ) @ 0x00000000000fa110
ACPI: RSDT (v001 A M I  OEMRSDT  0x09000610 MSFT 0x00000097) @
0x000000007bfb0000
ACPI: FADT (v002 A M I  OEMFACP  0x09000610 MSFT 0x00000097) @
0x000000007bfb0200
ACPI: MADT (v001 A M I  OEMAPIC  0x09000610 MSFT 0x00000097) @
0x000000007bfb0390
ACPI: MCFG (v001 A M I  OEMMCFG  0x09000610 MSFT 0x00000097) @
0x000000007bfb0400
ACPI: OEMB (v001 A M I  AMI_OEM  0x09000610 MSFT 0x00000097) @
0x000000007bfc0040
ACPI: DSDT (v001  ALVN6 ALVN6123 0x00000123 INTL 0x20051117) @
0x0000000000000000
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 507824) 1 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   507824
On node 0 totalpages: 507727
  DMA zone: 56 pages used for memmap
  DMA zone: 969 pages reserved
  DMA zone: 2974 pages, LIFO batch:0
  DMA32 zone: 6886 pages used for memmap
  DMA32 zone: 496842 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e8000
Nosave address range: 00000000000e8000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 7c000000:82c00000)
PERCPU: Allocating 31936 bytes of per cpu data
Built 1 zonelists.  Total pages: 499816
Kernel command line: BOOT_IMAGE=Linux-26202 ro root=803
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour dummy device 80x25
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
CPU 0: aperture @ cdd2000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 1995608k/2031296k available (2287k kernel code, 34888k
reserved, 981k data, 208k init)
Calibrating delay using timer specific routine.. 4732.96 BogoMIPS (lpj=2366480)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Freeing SMP alternatives: 28k freed
ACPI: Core revision 20060707
Using local APIC timer interrupts.
result 13437732
Detected 13.437 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4729.33 BogoMIPS (lpj=2364669)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 02
CPU 1: Syncing TSC to CPU 0.
CPU 1: synchronized TSC with CPU 0 (last diff 0 cycles, maxerr 556 cycles)
Brought up 2 CPUs
testing NMI watchdog ... OK.
Disabling vsyscall due to use of PM timer
time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
time.c: Detected 2365.041 MHz processor.
migration_cost=166
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
Error attaching device data
Error attaching device data
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:00:0d.0
PCI: Transparent bridge - 0000:00:04.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *10
ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *10
ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *11
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *10
ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *10
ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LMC9] (IRQs 20 21 22 23) *10
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *10
ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *11
ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 16 devices
Generic PHY: Registered new driver
SCSI subsystem initialized
libata version 2.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:0d: ioport range 0x290-0x29f has been reserved
PCI: Bridge: 0000:00:04.0
  IO window: e000-efff
  MEM window: dff00000-dfffffff
  PREFETCH window: 80000000-800fffff
PCI: Bridge: 0000:00:09.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler deadline registered (default)
io scheduler cfq registered
PCI: Setting latency timer of device 0000:00:09.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:09.0:pcie00]
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
vesafb: framebuffer at 0xc0000000, mapped to 0xffffc20000080000, using
3072k, total 65536k
vesafb: mode is 1024x768x16, linelength=2048, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Linux agpgart interface v0.101 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Marvell 88E1101: Registered new driver
Fixed PHY: Registered new driver
driver_bound: device fixed@100:1 already bound
Device 'fixed@100:1' does not have a release() function, it is broken
and must be fixed.
BUG: at drivers/base/core.c:104 device_release()

Call Trace:
 [<ffffffff802ec380>] kobject_cleanup+0x53/0x7e
 [<ffffffff802ec3ab>] kobject_release+0x0/0x9
 [<ffffffff802ecf3f>] kref_put+0x74/0x81
 [<ffffffff8035493b>] fixed_mdio_register_device+0x230/0x265
 [<ffffffff80564d31>] fixed_init+0x1f/0x35
 [<ffffffff802071a4>] init+0x147/0x2fb
 [<ffffffff80223b6e>] schedule_tail+0x36/0x92
 [<ffffffff8020a678>] child_rip+0xa/0x12
 [<ffffffff80311714>] acpi_ds_init_one_object+0x0/0x83
 [<ffffffff8020705d>] init+0x0/0x2fb
 [<ffffffff8020a66e>] child_rip+0x0/0x12

driver_bound: device fixed@10:1 already bound
Device 'fixed@10:1' does not have a release() function, it is broken
and must be fixed.
BUG: at drivers/base/core.c:104 device_release()

Call Trace:
 [<ffffffff802ec380>] kobject_cleanup+0x53/0x7e
 [<ffffffff802ec3ab>] kobject_release+0x0/0x9
 [<ffffffff802ecf3f>] kref_put+0x74/0x81
 [<ffffffff8035493b>] fixed_mdio_register_device+0x230/0x265
 [<ffffffff80564d42>] fixed_init+0x30/0x35
 [<ffffffff802071a4>] init+0x147/0x2fb
 [<ffffffff80223b6e>] schedule_tail+0x36/0x92
 [<ffffffff8020a678>] child_rip+0xa/0x12
 [<ffffffff80311714>] acpi_ds_init_one_object+0x0/0x83
 [<ffffffff8020705d>] init+0x0/0x2fb
 [<ffffffff8020a66e>] child_rip+0x0/0x12

tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Losing some ticks... checking if CPU frequency changed.
NFORCE-MCP61: IDE controller at PCI slot 0000:00:06.0
NFORCE-MCP61: chipset revision 162
NFORCE-MCP61: not 100% native mode: will probe irqs later
NFORCE-MCP61: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE-MCP61: 0000:00:06.0 (rev a2) UDMA133 controller
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
Probing IDE interface ide0...
hda: Optiarc DVD RW AD-7173A, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(66)
Uniform CD-ROM driver Revision: 3.20
sata_nv 0000:00:08.0: version 3.2
ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LSA0] -> GSI 23 (level,
low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:08.0 to 64
ata1: SATA max UDMA/133 cmd 0xD400 ctl 0xD082 bmdma 0xC880 irq 23
ata2: SATA max UDMA/133 cmd 0xD000 ctl 0xCC02 bmdma 0xC888 irq 23
scsi0 : sata_nv
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7, max UDMA/133, 488397168 sectors: LBA48 NCQ (depth 0/32)
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/133
scsi1 : sata_nv
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7, max UDMA/133, 488397168 sectors: LBA48 NCQ (depth 0/32)
ata2.00: ata2: dev 0 multi count 16
ata2.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      MAXTOR STM325082 3.AA PQ: 0 ANSI: 5
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      MAXTOR STM325082 3.AA PQ: 0 ANSI: 5
SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4
sd 1:0:0:0: Attached scsi disk sdb
sd 1:0:0:0: Attached scsi generic sg1 type 0
ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:08.1[B] -> Link [LSA1] -> GSI 22 (level,
low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:08.1 to 64
ata3: SATA max UDMA/133 cmd 0xC800 ctl 0xC482 bmdma 0xC000 irq 22
ata4: SATA max UDMA/133 cmd 0xC400 ctl 0xC082 bmdma 0xC008 irq 22
scsi2 : sata_nv
ata3: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0xC807
scsi3 : sata_nv
ata4: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0xC407
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
I2O subsystem v1.325
i2o: max drivers = 8
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
NET: Registered protocol family 17
input: AT Translated Set 2 keyboard as /class/input/input0
ReiserFS: sda3: found reiserfs format "3.6" with standard journal
ReiserFS: sda3: using ordered data mode
ReiserFS: sda3: journal params: device sda3, size 8192, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: sda3: checking transaction log (sda3)
ReiserFS: sda3: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 208k freed
Adding 2097136k swap on /dev/sda1.  Priority:-1 extents:1 across:2097136k
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7, dma 3
[PCSPP,TRISTATE,COMPAT,ECP,DMA]
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
ne2k-pci.c:v1.03 9/22/2003 D. Becker/P. Gortmaker
  http://www.scyld.com/network/ne2k-pci.html
usbcore: registered new device driver usb
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 19
ACPI: PCI Interrupt 0000:01:0a.0[A] -> Link [LNKC] -> <6>forcedeth.c:
Reverse Engineered nForce ethernet driver. Version 0.59.
GSI 19 (level, low) -> IRQ 19
eth0: RealTek RTL-8029 found at 0xec00, IRQ 19, 52:54:AB:16:48:35.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LMAC] -> GSI 21 (level,
low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:07.0 to 64
forcedeth: using HIGHDMA
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
eth1: forcedeth.c: subsystem: 01849:03ef bound to 0000:00:07.0
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 20 (level,
low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 20, io mem 0xdfefec00
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 23 (level,
low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 23, io mem 0xdfeff000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:05.0[B] -> Link [LAZA] -> GSI 22 (level,
low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:05.0 to 64
usb 1-1: new high speed USB device using ehci_hcd and address 2
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
usb 1-1: configuration #1 chosen from 1 choice
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 4 ports detected
lp0: using parport0 (interrupt-driven).
Capability LSM initialized
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
ReiserFS: sda2: found reiserfs format "3.6" with standard journal
ReiserFS: sda2: using ordered data mode
ReiserFS: sda2: journal params: device sda2, size 8192, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: sda2: checking transaction log (sda2)
ReiserFS: sda2: Using r5 hash to sort names
ReiserFS: sda5: found reiserfs format "3.6" with standard journal
ReiserFS: sda5: using ordered data mode
ReiserFS: sda5: journal params: device sda5, size 8192, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: sda5: checking transaction log (sda5)
ReiserFS: sda5: Using r5 hash to sort names
ReiserFS: sda6: found reiserfs format "3.6" with standard journal
ReiserFS: sda6: using ordered data mode
ReiserFS: sda6: journal params: device sda6, size 8192, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: sda6: checking transaction log (sda6)
ReiserFS: sda6: Using r5 hash to sort names
ReiserFS: sda7: found reiserfs format "3.6" with standard journal
ReiserFS: sda7: using ordered data mode
ReiserFS: sda7: journal params: device sda7, size 8192, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: sda7: checking transaction log (sda7)
ReiserFS: sda7: Using r5 hash to sort names
ReiserFS: sda8: found reiserfs format "3.6" with standard journal
ReiserFS: sda8: using ordered data mode
ReiserFS: sda8: journal params: device sda8, size 8192, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: sda8: checking transaction log (sda8)
ReiserFS: sda8: Using r5 hash to sort names
ReiserFS: sdb1: found reiserfs format "3.6" with standard journal
ReiserFS: sdb1: using ordered data mode
ReiserFS: sdb1: journal params: device sdb1, size 8125, journal first
block 66, max trans len 256, max batch 225, max commit age 30, max
trans age 30
ReiserFS: sdb1: checking transaction log (sdb1)
ReiserFS: sdb1: Using r5 hash to sort names
ReiserFS: sdb2: found reiserfs format "3.6" with standard journal
ReiserFS: sdb2: using ordered data mode
ReiserFS: sdb2: journal params: device sdb2, size 8125, journal first
block 66, max trans len 256, max batch 225, max commit age 30, max
trans age 30
ReiserFS: sdb2: checking transaction log (sdb2)
ReiserFS: sdb2: Using r5 hash to sort names
ReiserFS: sdb3: found reiserfs format "3.6" with standard journal
ReiserFS: sdb3: using ordered data mode
ReiserFS: sdb3: journal params: device sdb3, size 8125, journal first
block 66, max trans len 256, max batch 225, max commit age 30, max
trans age 30
ReiserFS: sdb3: checking transaction log (sdb3)
ReiserFS: sdb3: Using r5 hash to sort names
ReiserFS: sdb4: found reiserfs format "3.6" with standard journal
ReiserFS: sdb4: using ordered data mode
ReiserFS: sdb4: journal params: device sdb4, size 8125, journal first
block 66, max trans len 256, max batch 225, max commit age 30, max
trans age 30
ReiserFS: sdb4: checking transaction log (sdb4)
ReiserFS: sdb4: Using r5 hash to sort names

Rgds
Saxa
