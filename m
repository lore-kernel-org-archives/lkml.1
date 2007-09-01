Return-Path: <linux-kernel-owner+w=401wt.eu-S932884AbXIAWf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbXIAWf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbXIAWfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:35:11 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:48330 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320AbXIAWfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:35:07 -0400
Date: Sun, 2 Sep 2007 00:34:45 +0200
From: Philippe Bourcier <buffalo.phil@free.fr>
To: Debian Bug Tracking System <438663@bugs.debian.org>
Cc: Carl-Daniel Hailfinger <c-d.hailfinger.kernel.2004@gmx.net>,
       Manfred Spraul <manfred@colorfullife.com>,
       Andrew de Quincey <adq_dvb@lidskialf.net>, linux-kernel@vger.kernel.org,
       Ed W <lists@wildgooses.com>
Subject: linux-image-2.6.23-rc4-amd64: Ethernet not functioning on Nvidia
	MCP51
Message-ID: <20070901223445.GA15623@gala>
Mail-Followup-To: Debian Bug Tracking System <438663@bugs.debian.org>,
	Carl-Daniel Hailfinger <c-d.hailfinger.kernel.2004@gmx.net>,
	Manfred Spraul <manfred@colorfullife.com>,
	Andrew de Quincey <adq_dvb@lidskialf.net>,
	linux-kernel@vger.kernel.org, Ed W <lists@wildgooses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Reportbug-Version: 3.39
User-Agent: Software Libre (copyleft - All rights reversed)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Package: linux-image-2.6.23-rc4-amd64
Version: 2.6.23~rc4-1~experimental.1~snapshot.9433
Followup-For: Bug #438663


see: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=438663

/var/log/dmesg
- = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = -
Linux version 2.6.23-rc4-amd64 (Debian 2.6.23~rc4-1~experimental.1~snapshot.9433) (waldi@debian.org) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14+1)) #1 SMP Sat Sep 1 00:55:23 UTC 2007
Command line: root=/dev/sdb2 ro video=nvidiafb:ywrap,mtrr vga=791
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077fc0000 (usable)
 BIOS-e820: 0000000077fc0000 - 0000000077fce000 (ACPI data)
 BIOS-e820: 0000000077fce000 - 0000000077ff0000 (ACPI NVS)
 BIOS-e820: 0000000077ff0000 - 0000000078000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 491456) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000FB5A0, 0014 (r0 ACPIAM)
ACPI: RSDT 77FC0000, 0030 (r1 A M I  OEMRSDT   8000630 MSFT       97)
ACPI: FACP 77FC0200, 0084 (r2 A M I  OEMFACP   8000630 MSFT       97)
ACPI: DSDT 77FC0440, 6087 (r1  A0588 A0588000        0 INTL 20060113)
ACPI: FACS 77FCE000, 0040
ACPI: MCFG 77FC0400, 003C (r1 A M I  OEMMCFG   8000630 MSFT       97)
ACPI: OEMB 77FCE040, 0060 (r1 A M I  AMI_OEM   8000630 MSFT       97)
Scanning NUMA topology in Northbridge 24
CPU has 2 num_cores
No NUMA configuration found
Faking a node at 0000000000000000-0000000077fc0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 491456) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-0000000077fc0000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   491456
On node 0 totalpages: 491359
  DMA zone: 56 pages used for memmap
  DMA zone: 1045 pages reserved
  DMA zone: 2898 pages, LIFO batch:0
  DMA32 zone: 6663 pages used for memmap
  DMA32 zone: 480697 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x508
Intel MultiProcessor Specification v1.4
MPTABLE: OEM ID: ASUS     MPTABLE: Product ID:  MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
I/O APIC #2 at 0xFEC00000.
Setting APIC routing to flat
Processors: 2
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 78000000:86c00000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 35176 bytes of per cpu data
Built 1 zonelists in Node order.  Total pages: 483595
Policy zone: DMA32
Kernel command line: root=/dev/sdb2 ro video=nvidiafb:ywrap,mtrr vga=791
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2210.125 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Checking aperture...
CPU 0: aperture @ c270000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 1927924k/1965824k available (2066k kernel code, 37512k reserved, 977k data, 304k init)
Calibrating delay using timer specific routine.. 4424.07 BogoMIPS (lpj=8848148)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 8ca0)
ExtINT not setup in hardware but reported by MP table
Using local APIC timer interrupts.
result 12557531
Detected 12.557 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4420.40 BogoMIPS (lpj=8840808)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ stepping 01
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3)
ACPI: Using PIC for interrupt routing
Error attaching device data
Error attaching device data
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:10.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNEA] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNEB] (IRQs *5 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNEC] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNED] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUB0] (IRQs *5 7 10 11 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 10 11 14 *15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 10 11 14 *15)
ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMC9] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LSA0] (IRQs 5 *7 10 11 14 15)
ACPI: PCI Interrupt Link [LSA1] (IRQs 5 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LATA] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  AF, should be AE [20070126]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: ACPI device : hid PNP0A03
pnp: ACPI device : hid PNP0200
pnp: ACPI device : hid PNP0B00
pnp: ACPI device : hid PNP0800
pnp: ACPI device : hid PNP0C04
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0303
pnp: ACPI device : hid PNP0F03
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C01
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
ACPI: RTC can wake from S4
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:05' and the driver 'system'
pnp: 00:05: iomem range 0xfefe0000-0xfefe01ff has been reserved
pnp: match found with the PnP device '00:06' and the driver 'system'
pnp: 00:06: iomem range 0xdfd80000-0xdfdbffff has been reserved
pnp: 00:06: iomem range 0xfee01000-0xfeefffff has been reserved
pnp: 00:06: iomem range 0x78000000-0x7fffffff has been reserved
pnp: match found with the PnP device '00:07' and the driver 'system'
pnp: 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
pnp: match found with the PnP device '00:0b' and the driver 'system'
pnp: 00:0b: ioport range 0xa00-0xa0f has been reserved
pnp: 00:0b: ioport range 0xa10-0xa1f has been reserved
pnp: 00:0b: ioport range 0xa20-0xa2f has been reserved
pnp: 00:0b: ioport range 0xa30-0xa3f has been reserved
pnp: match found with the PnP device '00:0c' and the driver 'system'
pnp: 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
pnp: match found with the PnP device '00:0d' and the driver 'system'
pnp: 00:0d: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0d: iomem range 0xc0000-0xcffff has been reserved
pnp: 00:0d: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0d: iomem range 0x100000-0x7fffffff could not be reserved
PCI: Bridge: 0000:00:02.0
  IO window: d000-dfff
  MEM window: dfe00000-dfefffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:04.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:10.0
  IO window: e000-efff
  MEM window: dff00000-dfffffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:00:03.0 to 64
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:00:10.0 to 64
NET: Registered protocol family 2
Time: acpi_pm clocksource has been installed.
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 6291456 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 6257k freed
audit: initializing netlink socket (disabled)
audit(1188674072.828:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:05.0
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
PCI: Setting latency timer of device 0000:00:04.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:04.0:pcie00]
vesafb: framebuffer at 0xc0000000, mapped to 0xffffc20000b00000, using 3072k, total 131072k
vesafb: mode is 1024x768x16, linelength=2048, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:08' and the driver 'serial'
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
pnp: the driver 'i8042 kbd' has been registered
pnp: match found with the PnP device '00:09' and the driver 'i8042 kbd'
pnp: the driver 'i8042 aux' has been registered
pnp: match found with the PnP device '00:0a' and the driver 'i8042 aux'
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Freeing unused kernel memory: 304k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI Exception (processor_core-0797): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0797): AE_NOT_FOUND, Processor Device is not present [20070126]
SCSI subsystem initialized
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LUB0] -> GSI 5 (level, low) -> IRQ 5
PCI: Setting latency timer of device 0000:00:0b.0 to 64
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:0b.0: irq 5, io mem 0xdfdde000
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
libata version 2.21 loaded.
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ahci 0000:01:00.0: version 2.3
ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 5
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 5 (level, low) -> IRQ 5
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
pnp: the driver 'ide' has been registered
usb 1-1: new full speed USB device using ohci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
usb 1-2: new low speed USB device using ohci_hcd and address 3
ahci 0000:01:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:01:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
PCI: Setting latency timer of device 0000:01:00.0 to 64
scsi0 : ahci
scsi1 : ahci
ata1: SATA max UDMA/133 cmd 0xffffc20000aac100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 5
ata2: SATA max UDMA/133 cmd 0xffffc20000aac180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 5
usb 1-2: configuration #1 chosen from 1 choice
ata1: SATA link down (SStatus 0 SControl 300)
usb 1-7: new full speed USB device using ohci_hcd and address 4
usb 1-7: configuration #1 chosen from 1 choice
hub 1-7:1.0: USB hub found
hub 1-7:1.0: 4 ports detected
ata2: SATA link down (SStatus 0 SControl 300)
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 15
PCI: setting IRQ 15 as level-triggered
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LMAC] -> GSI 15 (level, low) -> IRQ 15
PCI: Setting latency timer of device 0000:00:14.0 to 64
forcedeth: using HIGHDMA
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /class/input/input1
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:0b.0-2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
eth0: forcedeth.c: subsystem: 01043:81bc bound to 0000:00:14.0
sata_nv 0000:00:0e.0: version 3.4
ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 7
net eth2: device_rename: sysfs_create_symlink failed (-17)
udev: renamed network interface eth0 to eth2
PCI: setting IRQ 7 as level-triggered
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LSA0] -> GSI 7 (level, low) -> IRQ 7
PCI: Setting latency timer of device 0000:00:0e.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x000000000001c800 ctl 0x000000000001c482 bmdma 0x000000000001c000 irq 7
ata4: SATA max UDMA/133 cmd 0x000000000001c400 ctl 0x000000000001c082 bmdma 0x000000000001c008 irq 7
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATAPI: ASUS    DRW-1814BLT, 1.04, max UDMA/66
ata4.00: configured for UDMA/66
scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 3:0:0:0: CD-ROM            ASUS     DRW-1814BLT      1.04 PQ: 0 ANSI: 5
ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [LSA1] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:0f.0 to 64
scsi4 : sata_nv
scsi5 : sata_nv
ata5: SATA max UDMA/133 cmd 0x000000000001bc00 ctl 0x000000000001b882 bmdma 0x000000000001b400 irq 11
ata6: SATA max UDMA/133 cmd 0x000000000001b800 ctl 0x000000000001b482 bmdma 0x000000000001b408 irq 11
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-7: ST3160812AS, 3.AAD, max UDMA/133
ata5.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata5.00: configured for UDMA/133
ata6: SATA link down (SStatus 0 SControl 300)
scsi 4:0:0:0: Direct-Access     ATA      ST3160812AS      3.AA PQ: 0 ANSI: 5
JMB363: IDE controller at PCI slot 0000:01:00.1
PCI: Enabling device 0000:01:00.1 (0000 -> 0001)
ACPI: PCI Interrupt Link [LNEC] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:01:00.1[B] -> Link [LNEC] -> GSI 10 (level, low) -> IRQ 10
JMB363: chipset revision 2
JMB363: 100% native mode on irq 10
PCI: Setting latency timer of device 0000:01:00.1 to 64
    ide0: BM-DMA at 0xd400-0xd407, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xd408-0xd40f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 15
ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [LUB2] -> GSI 15 (level, low) -> IRQ 15
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:04:05.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:0b.1 to 64
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:0b.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:0b.1
ehci_hcd 0000:00:0b.1: irq 15, io mem 0xdfddfc00
ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb 1-1: USB disconnect, address 2
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
firewire_ohci: Added fw-ohci device 0000:04:05.0, OHCI version 1.10
hub 2-0:1.0: 8 ports detected
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<6>usb 1-2: USB disconnect, address 3
 sda1 sda2
NFORCE-MCP51: IDE controller at PCI slot 0000:00:0d.0
NFORCE-MCP51: chipset revision 161
NFORCE-MCP51: not 100% native mode: will probe irqs later
NFORCE-MCP51: 0000:00:0d.0 (rev a1) UDMA133 controller
    ide2: BM-DMA at 0xffa0-0xffa7, BIOS settings: hde:pio, hdf:pio
Probing IDE interface ide2...
sd 2:0:0:0: [sda] Attached SCSI disk
sd 4:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
sd 4:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb:<6>usb 1-7: USB disconnect, address 4
 sdb1 sdb2 sdb3
sd 4:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg0 type 0
sr 3:0:0:0: Attached scsi generic sg1 type 5
sd 4:0:0:0: Attached scsi generic sg2 type 0
firewire_core: created new fw device fw0 (0 config rom retries, S400)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Attempting manual resume
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
usb 2-7: new high speed USB device using ehci_hcd and address 4
usb 2-7: configuration #1 chosen from 1 choice
hub 2-7:1.0: USB hub found
hub 2-7:1.0: 4 ports detected
usb 1-1: new full speed USB device using ohci_hcd and address 5
usb 1-1: configuration #1 chosen from 1 choice
usb 1-2: new low speed USB device using ohci_hcd and address 6
usb 1-2: configuration #1 chosen from 1 choice
input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:0b.0-2
input: PC Speaker as /class/input/input3
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x600
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x700
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input5
ACPI: Power Button (CM) [PWRB]
ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LAZA] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:10.1 to 64
hda_codec: Unknown model for AD1988, trying auto-probe from BIOS...
Adding 1951856k swap on /dev/sda1.  Priority:-1 extents:1 across:1951856k
Adding 1951856k swap on /dev/sdb1.  Priority:-2 extents:1 across:1951856k
EXT3 FS on sdb2, internal journal
loop: module loaded
it87: Found IT8716F chip at 0xa10, revision 1
it87: in3 is VCC (+5V)
it87: in7 is VCCH (+5V Stand-By)
fuse init (API version 7.8)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
- = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = -


-- Package-specific info:

-- System Information:
Debian Release: lenny/sid
  APT prefers unstable
  APT policy: (500, 'unstable'), (500, 'testing'), (500, 'stable')
Architecture: amd64 (x86_64)

Kernel: Linux 2.6.18-5-amd64 (SMP w/2 CPU cores)
Locale: LANG=en_US.UTF-8, LC_CTYPE=fr_FR.UTF-8@euro (charmap=UTF-8) (ignored: LC_ALL set to en_US.UTF-8)
Shell: /bin/sh linked to /bin/bash

Versions of packages linux-image-2.6.23-rc4-amd64 depends on:
ii  e2fsprogs                    1.40.2-1    ext2 file system utilities and lib
ii  initramfs-tools [linux-initr 0.90a       tools for generating an initramfs
ii  module-init-tools            3.3-pre11-4 tools for managing Linux kernel mo

linux-image-2.6.23-rc4-amd64 recommends no packages.

-- debconf information:
  shared/kernel-image/really-run-bootloader: true
  linux-image-2.6.23-rc4-amd64/postinst/depmod-error-2.6.23-rc4-amd64: false
  linux-image-2.6.23-rc4-amd64/postinst/old-dir-initrd-link-2.6.23-rc4-amd64: true
  linux-image-2.6.23-rc4-amd64/postinst/old-system-map-link-2.6.23-rc4-amd64: true
  linux-image-2.6.23-rc4-amd64/postinst/depmod-error-initrd-2.6.23-rc4-amd64: false
  linux-image-2.6.23-rc4-amd64/postinst/create-kimage-link-2.6.23-rc4-amd64: true
  linux-image-2.6.23-rc4-amd64/preinst/elilo-initrd-2.6.23-rc4-amd64: true
  linux-image-2.6.23-rc4-amd64/postinst/kimage-is-a-directory:
  linux-image-2.6.23-rc4-amd64/preinst/lilo-initrd-2.6.23-rc4-amd64: true
  linux-image-2.6.23-rc4-amd64/preinst/failed-to-move-modules-2.6.23-rc4-amd64:
  linux-image-2.6.23-rc4-amd64/postinst/bootloader-error-2.6.23-rc4-amd64:
  linux-image-2.6.23-rc4-amd64/postinst/bootloader-test-error-2.6.23-rc4-amd64:
  linux-image-2.6.23-rc4-amd64/prerm/removing-running-kernel-2.6.23-rc4-amd64: true
  linux-image-2.6.23-rc4-amd64/preinst/initrd-2.6.23-rc4-amd64:
  linux-image-2.6.23-rc4-amd64/preinst/abort-install-2.6.23-rc4-amd64:
  linux-image-2.6.23-rc4-amd64/preinst/lilo-has-ramdisk:
  linux-image-2.6.23-rc4-amd64/postinst/old-initrd-link-2.6.23-rc4-amd64: true
  linux-image-2.6.23-rc4-amd64/preinst/overwriting-modules-2.6.23-rc4-amd64: true
  linux-image-2.6.23-rc4-amd64/preinst/already-running-this-2.6.23-rc4-amd64:
  linux-image-2.6.23-rc4-amd64/prerm/would-invalidate-boot-loader-2.6.23-rc4-amd64: true
  linux-image-2.6.23-rc4-amd64/preinst/abort-overwrite-2.6.23-rc4-amd64:
  linux-image-2.6.23-rc4-amd64/preinst/bootloader-initrd-2.6.23-rc4-amd64: true
