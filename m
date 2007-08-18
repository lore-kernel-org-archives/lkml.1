Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbXHRThl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbXHRThl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 15:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbXHRThb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 15:37:31 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:50056 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757520AbXHRTha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 15:37:30 -0400
Date: Sat, 18 Aug 2007 21:37:26 +0200
From: Philippe Bourcier <buffalo.phil@free.fr>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Cc: Carl-Daniel Hailfinger <c-d.hailfinger.kernel.2004@gmx.net>,
       linux-kernel@vger.kernel.org, Philippe Bourcier <buffalo.phil@free.fr>
Subject: linux-image-2.6.22-1-amd64: Ethernet not functioning on Nvidia
	MCP51
Message-ID: <20070818193726.GA10535@gala>
Mail-Followup-To: Debian Bug Tracking System <submit@bugs.debian.org>,
	Carl-Daniel Hailfinger <c-d.hailfinger.kernel.2004@gmx.net>,
	linux-kernel@vger.kernel.org,
	Philippe Bourcier <buffalo.phil@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Software Libre (copyleft - All rights reversed)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Package: linux-image-2.6.22-1-amd64
Version: 2.6.22-3
Severity: grave
Justification: renders package unusable


    hi all,

  I encountered the same problem than
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg182088.html.

/var/log/dmesg.2.gz:
- = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = -
Linux version 2.6.22-1-amd64 (Debian 2.6.22-3) (waldi@debian.org) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)) #1 SMP Sun Jul 29 13:54:41 UTC 2007
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
No NUMA configuration found
Faking a node at 0000000000000000-0000000077fc0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 491456) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-0000000077fc0000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   491456
On node 0 totalpages: 491359
  DMA zone: 56 pages used for memmap
  DMA zone: 1020 pages reserved
  DMA zone: 2923 pages, LIFO batch:0
  DMA32 zone: 6663 pages used for memmap
  DMA32 zone: 480697 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
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
PERCPU: Allocating 37896 bytes of per cpu data
Built 1 zonelists.  Total pages: 483620
Kernel command line: root=/dev/sdb2 ro video=nvidiafb:ywrap,mtrr vga=791
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2210.106 MHz processor.
Console: colour dummy device 80x25
Checking aperture...
CPU 0: aperture @ c270000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 1928104k/1965824k available (2009k kernel code, 37332k reserved, 946k data, 296k init)
Calibrating delay using timer specific routine.. 4424.04 BogoMIPS (lpj=8848081)
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
result 12557423
Detected 12.557 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4420.47 BogoMIPS (lpj=8840954)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ stepping 01
Brought up 2 CPUs
migration_cost=216
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using PIC for interrupt routing
Error attaching device data
Error attaching device data
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
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
Freeing initrd memory: 6165k freed
audit: initializing netlink socket (disabled)
audit(1009843224.084:1): initialized
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
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
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
Freeing unused kernel memory: 296k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI Exception (processor_core-0781): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0781): AE_NOT_FOUND, Processor Device is not present [20070126]
SCSI subsystem initialized
libata version 2.21 loaded.
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
pnp: the driver 'ide' has been registered
JMB363: IDE controller at PCI slot 0000:01:00.1
PCI: Enabling device 0000:01:00.1 (0000 -> 0001)
ACPI: PCI Interrupt Link [LNEC] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:01:00.1[B] -> Link [LNEC] -> GSI 11 (level, low) -> IRQ 11
JMB363: chipset revision 2
JMB363: 100% native mode on irq 11
PCI: Setting latency timer of device 0000:01:00.1 to 64
    ide0: BM-DMA at 0xd400-0xd407, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xd408-0xd40f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
Probing IDE interface ide1...
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 15
PCI: setting IRQ 15 as level-triggered
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LMAC] -> GSI 15 (level, low) -> IRQ 15
PCI: Setting latency timer of device 0000:00:14.0 to 64
forcedeth: using HIGHDMA
eth0: forcedeth.c: subsystem: 01043:81bc bound to 0000:00:14.0
ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LUB0] -> GSI 5 (level, low) -> IRQ 5
udev: renamed network interface eth0 to eth2
PCI: Setting latency timer of device 0000:00:0b.0 to 64
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:0b.0: irq 5, io mem 0xdfdde000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 15
ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [LUB2] -> GSI 15 (level, low) -> IRQ 15
PCI: Setting latency timer of device 0000:00:0b.1 to 64
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:0b.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:0b.1
ehci_hcd 0000:00:0b.1: irq 15, io mem 0xdfddfc00
ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
ahci 0000:01:00.0: version 2.2
ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 5
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 5 (level, low) -> IRQ 5
usb 2-7: new high speed USB device using ehci_hcd and address 4
ahci 0000:01:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:01:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
PCI: Setting latency timer of device 0000:01:00.0 to 64
scsi0 : ahci
scsi1 : ahci
ata1: SATA max UDMA/133 cmd 0xffffc20000aac100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 5
usb 2-7: configuration #1 chosen from 1 choice
hub 2-7:1.0: USB hub found
hub 2-7:1.0: 4 ports detected
ata2: SATA max UDMA/133 cmd 0xffffc20000aac180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 5
ata1: SATA link down (SStatus 0 SControl 300)
usb 1-1: new full speed USB device using ohci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
ata2: SATA link down (SStatus 0 SControl 300)
sata_nv 0000:00:0e.0: version 3.4
ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 7
PCI: setting IRQ 7 as level-triggered
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LSA0] -> GSI 7 (level, low) -> IRQ 7
PCI: Setting latency timer of device 0000:00:0e.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x000000000001c800 ctl 0x000000000001c482 bmdma 0x000000000001c000 irq 7
ata4: SATA max UDMA/133 cmd 0x000000000001c400 ctl 0x000000000001c082 bmdma 0x000000000001c008 irq 7
usb 1-2: new low speed USB device using ohci_hcd and address 3
usb 1-2: configuration #1 chosen from 1 choice
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /class/input/input1
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:0b.0-2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
ata3.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATAPI: ASUS    DRW-1814BLT, 1.04, max UDMA/66
ata4.00: configured for UDMA/66
scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 3:0:0:0: CD-ROM            ASUS     DRW-1814BLT      1.04 PQ: 0 ANSI: 5
ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 11
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
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:04:05.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
firewire_ohci: Added fw-ohci device 0000:04:05.0, OHCI version 1.10
NFORCE-MCP51: IDE controller at PCI slot 0000:00:0d.0
NFORCE-MCP51: chipset revision 161
NFORCE-MCP51: not 100% native mode: will probe irqs later
NFORCE-MCP51: 0000:00:0d.0 (rev a1) UDMA133 controller
    ide2: BM-DMA at 0xffa0-0xffa7, BIOS settings: hde:pio, hdf:pio
Probing IDE interface ide2...
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
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
 sdb: sdb1 sdb2 sdb3
sd 4:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg0 type 0
sr 3:0:0:0: Attached scsi generic sg1 type 5
sd 4:0:0:0: Attached scsi generic sg2 type 0
firewire_core: created new fw device fw0 (0 config rom retries)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Attempting manual resume
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: sdb2: orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 130595
ext3_orphan_cleanup: deleting unreferenced inode 130610
ext3_orphan_cleanup: deleting unreferenced inode 130612
ext3_orphan_cleanup: deleting unreferenced inode 130614
ext3_orphan_cleanup: deleting unreferenced inode 130621
ext3_orphan_cleanup: deleting unreferenced inode 130697
ext3_orphan_cleanup: deleting unreferenced inode 130698
ext3_orphan_cleanup: deleting unreferenced inode 130700
ext3_orphan_cleanup: deleting unreferenced inode 130705
ext3_orphan_cleanup: deleting unreferenced inode 130708
ext3_orphan_cleanup: deleting unreferenced inode 130709
ext3_orphan_cleanup: deleting unreferenced inode 130710
ext3_orphan_cleanup: deleting unreferenced inode 130713
ext3_orphan_cleanup: deleting unreferenced inode 179864
ext3_orphan_cleanup: deleting unreferenced inode 180281
ext3_orphan_cleanup: deleting unreferenced inode 180052
ext3_orphan_cleanup: deleting unreferenced inode 130338
ext3_orphan_cleanup: deleting unreferenced inode 130350
ext3_orphan_cleanup: deleting unreferenced inode 130449
ext3_orphan_cleanup: deleting unreferenced inode 114050
ext3_orphan_cleanup: deleting unreferenced inode 130442
ext3_orphan_cleanup: deleting unreferenced inode 130615
ext3_orphan_cleanup: deleting unreferenced inode 130613
ext3_orphan_cleanup: deleting unreferenced inode 130609
ext3_orphan_cleanup: deleting unreferenced inode 130608
ext3_orphan_cleanup: deleting unreferenced inode 130607
ext3_orphan_cleanup: deleting unreferenced inode 130605
ext3_orphan_cleanup: deleting unreferenced inode 130603
ext3_orphan_cleanup: deleting unreferenced inode 130602
ext3_orphan_cleanup: deleting unreferenced inode 130601
ext3_orphan_cleanup: deleting unreferenced inode 130599
ext3_orphan_cleanup: deleting unreferenced inode 130597
ext3_orphan_cleanup: deleting unreferenced inode 130596
ext3_orphan_cleanup: deleting unreferenced inode 130594
ext3_orphan_cleanup: deleting unreferenced inode 130390
ext3_orphan_cleanup: deleting unreferenced inode 179551
ext3_orphan_cleanup: deleting unreferenced inode 179457
EXT3-fs: sdb2: 37 orphan inodes deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
input: PC Speaker as /class/input/input2
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x600
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x700
ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
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
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)

$ sudo lspci -v
- = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = -
00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8222
	Flags: bus master, 66MHz, fast devsel, latency 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
	Capabilities: [e0] HyperTransport: MSI Mapping

00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8222
	Flags: 66MHz, fast devsel

00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8222
	Flags: 66MHz, fast devsel

00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8222
	Flags: bus master, 66MHz, fast devsel, latency 0

00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8222
	Flags: bus master, 66MHz, fast devsel, latency 0
	Capabilities: [44] #00 [00fe]
	Capabilities: [fc] #00 [0000]

00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8222
	Flags: 66MHz, fast devsel

00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8222
	Flags: 66MHz, fast devsel

00:02.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: dfe00000-dfefffff
	Capabilities: [40] Subsystem: nVidia Corporation Unknown device 0000
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
	Capabilities: [60] HyperTransport: MSI Mapping
	Capabilities: [80] Express Root Port (Slot+) IRQ 0

00:03.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Capabilities: [40] Subsystem: nVidia Corporation Unknown device 0000
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
	Capabilities: [60] HyperTransport: MSI Mapping
	Capabilities: [80] Express Root Port (Slot+) IRQ 0

00:04.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Capabilities: [40] Subsystem: nVidia Corporation Unknown device 0000
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
	Capabilities: [60] HyperTransport: MSI Mapping
	Capabilities: [80] Express Root Port (Slot+) IRQ 0

00:05.0 VGA compatible controller: nVidia Corporation C51PV [GeForce 6150] (rev a2) (prog-if 00 [VGA])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8222
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 10
	Memory at de000000 (32-bit, non-prefetchable) [size=16M]
	Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Memory at dd000000 (64-bit, non-prefetchable) [size=16M]
	[virtual] Expansion ROM at dfde0000 [disabled] [size=128K]
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-

00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 81bc
	Flags: bus master, 66MHz, fast devsel, latency 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
	Capabilities: [e0] HyperTransport: MSI Mapping

00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a3)
	Subsystem: ASUSTeK Computer Inc. Unknown device 81bc
	Flags: bus master, 66MHz, fast devsel, latency 0

00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a3)
	Subsystem: ASUSTeK Computer Inc. Unknown device 81bc
	Flags: 66MHz, fast devsel, IRQ 10
	I/O ports at 0600 [size=64]
	I/O ports at 0700 [size=64]
	Capabilities: [44] Power Management version 2

00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 81bc
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 5
	Memory at dfdde000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2

00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 81bc
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 15
	Memory at dfddfc00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port
	Capabilities: [80] Power Management version 2

00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1) (prog-if 8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc. Unknown device 81bc
	Flags: bus master, 66MHz, fast devsel, latency 0
	I/O ports at ffa0 [size=16]
	Capabilities: [44] Power Management version 2

00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev a1) (prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. Unknown device 81bc
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 7
	I/O ports at c800 [size=8]
	I/O ports at c480 [size=4]
	I/O ports at c400 [size=8]
	I/O ports at c080 [size=4]
	I/O ports at c000 [size=16]
	Memory at dfddd000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
	Capabilities: [cc] HyperTransport: MSI Mapping

00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev a1) (prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. Unknown device 81bc
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 11
	I/O ports at bc00 [size=8]
	I/O ports at b880 [size=4]
	I/O ports at b800 [size=8]
	I/O ports at b480 [size=4]
	I/O ports at b400 [size=16]
	Memory at dfddc000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
	Capabilities: [cc] HyperTransport: MSI Mapping

00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2) (prog-if 01 [Subtractive decode])
	Flags: bus master, 66MHz, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=64
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: dff00000-dfffffff
	Capabilities: [b8] Subsystem: Gammagraphx, Inc. Unknown device 0000
	Capabilities: [8c] HyperTransport: MSI Mapping

00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 821f
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 10
	Memory at dfdd4000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/0 Enable-
	Capabilities: [6c] HyperTransport: MSI Mapping

00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)
	Subsystem: ASUSTeK Computer Inc. Unknown device 81bc
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 15
	Memory at dfdd3000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at b080 [size=8]
	Capabilities: [44] Power Management version 2

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Flags: fast devsel
	Capabilities: [f0] #0f [0010]

01:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. Unknown device 81e4
	Flags: bus master, fast devsel, latency 0, IRQ 5
	Memory at dfefe000 (32-bit, non-prefetchable) [size=8K]
	Expansion ROM at dfee0000 [disabled] [size=64K]
	Capabilities: [68] Power Management version 2
	Capabilities: [50] Express Legacy Endpoint IRQ 1

01:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 02) (prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. Unknown device 81e4
	Flags: bus master, fast devsel, latency 0, IRQ 10
	I/O ports at dc00 [size=8]
	I/O ports at d880 [size=4]
	I/O ports at d800 [size=8]
	I/O ports at d480 [size=4]
	I/O ports at d400 [size=16]
	Capabilities: [68] Power Management version 2

04:05.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev c0) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 2a22
	Flags: bus master, medium devsel, latency 64, IRQ 11
	Memory at dffff800 (32-bit, non-prefetchable) [size=2K]
	I/O ports at ec00 [size=128]
	Capabilities: [50] Power Management version 2
- = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = -

  I hope this helps,
if not, ask more...

-- Package-specific info:

-- System Information:
Debian Release: lenny/sid
  APT prefers unstable
  APT policy: (500, 'unstable'), (500, 'testing'), (500, 'stable')
Architecture: amd64 (x86_64)

Kernel: Linux 2.6.18-5-amd64 (SMP w/2 CPU cores)
Locale: LANG=en_US.UTF-8, LC_CTYPE=fr_FR.UTF-8@euro (charmap=UTF-8) (ignored: LC_ALL set to en_US.UTF-8)
Shell: /bin/sh linked to /bin/bash

Versions of packages linux-image-2.6.22-1-amd64 depends on:
ii  e2fsprogs                    1.40.2-1    ext2 file system utilities and lib
ii  initramfs-tools [linux-initr 0.90        tools for generating an initramfs
ii  module-init-tools            3.3-pre11-4 tools for managing Linux kernel mo

linux-image-2.6.22-1-amd64 recommends no packages.

-- debconf information:
  linux-image-2.6.22-1-amd64/preinst/elilo-initrd-2.6.22-1-amd64: true
  linux-image-2.6.22-1-amd64/preinst/initrd-2.6.22-1-amd64:
  linux-image-2.6.22-1-amd64/preinst/lilo-has-ramdisk:
  shared/kernel-image/really-run-bootloader: true
  linux-image-2.6.22-1-amd64/preinst/lilo-initrd-2.6.22-1-amd64: true
  linux-image-2.6.22-1-amd64/preinst/already-running-this-2.6.22-1-amd64:
  linux-image-2.6.22-1-amd64/postinst/depmod-error-2.6.22-1-amd64: false
  linux-image-2.6.22-1-amd64/postinst/bootloader-error-2.6.22-1-amd64:
  linux-image-2.6.22-1-amd64/prerm/would-invalidate-boot-loader-2.6.22-1-amd64: true
  linux-image-2.6.22-1-amd64/postinst/old-dir-initrd-link-2.6.22-1-amd64: true
  linux-image-2.6.22-1-amd64/preinst/abort-install-2.6.22-1-amd64:
  linux-image-2.6.22-1-amd64/postinst/kimage-is-a-directory:
  linux-image-2.6.22-1-amd64/preinst/overwriting-modules-2.6.22-1-amd64: true
  linux-image-2.6.22-1-amd64/postinst/bootloader-test-error-2.6.22-1-amd64:
  linux-image-2.6.22-1-amd64/preinst/failed-to-move-modules-2.6.22-1-amd64:
  linux-image-2.6.22-1-amd64/postinst/create-kimage-link-2.6.22-1-amd64: true
  linux-image-2.6.22-1-amd64/postinst/old-initrd-link-2.6.22-1-amd64: true
  linux-image-2.6.22-1-amd64/prerm/removing-running-kernel-2.6.22-1-amd64: true
  linux-image-2.6.22-1-amd64/preinst/bootloader-initrd-2.6.22-1-amd64: true
  linux-image-2.6.22-1-amd64/preinst/abort-overwrite-2.6.22-1-amd64:
  linux-image-2.6.22-1-amd64/postinst/depmod-error-initrd-2.6.22-1-amd64: false
  linux-image-2.6.22-1-amd64/postinst/old-system-map-link-2.6.22-1-amd64: true
