Return-Path: <linux-kernel-owner+w=401wt.eu-S1750952AbXCHUHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750952AbXCHUHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbXCHUHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:07:24 -0500
Received: from web52510.mail.yahoo.com ([206.190.48.193]:21456 "HELO
	web52510.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752623AbXCHUHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:07:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=PyjgHjuuC/VAnApBTgHfv+d3mEJ6i+vE15CbAsyD2yjULZPJz/i6XTHrAUSI3xKI7R6eWtozN4HrJ/zfFJrdAk7FL+yScApMKXrUPWoaD/3fYe7DLx2jcvRuzPahxzCd5s4+PoxLC0FHRMH3l3wPBjeRHgiEFOiT/uyjCtOYBtY=;
X-YMail-OSG: XnscuVkVM1lQK0IbPqcbGkieWJYqxBlAHnuj_UyQCjdW0Nl9Pyi5_WDyc9hGbJc50gSNgrKQbq__pYvxSbemmymC4tf26X70CO7xGxeHo2fCbXpWaJPqp7J2gsa56DBq
Date: Thu, 8 Mar 2007 12:07:16 -0800 (PST)
From: Marc Perkel <mperkel@yahoo.com>
Subject: More nVidia 4gb ram problems
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <447507.15233.qm@web52510.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Running FC6. When I try to format a Raid 1 device the
server locks up when it creates the journal. However
if I use just 2 gigs of ram then it doesn't lock up.
Asus motherboard.

Please CC me as I'm not a list member.

Linux version 2.6.19-1.2911.6.5.fc6
(brewbuilder@hs20-bc1-6.build.redhat.com) (gcc version
4.1.1 20070105 (Red Hat 4.1.1-51)) #1 SMP Sun Mar 4
16:05:34 EST 2007
Command line: ro root=LABEL=/ vga=1 pci=nommconf
iommu=soft
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00
(usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000
(reserved)
 BIOS-e820: 00000000000e5000 - 0000000000100000
(reserved)
 BIOS-e820: 0000000000100000 - 00000000abfc0000
(usable)
 BIOS-e820: 00000000abfc0000 - 00000000abfce000 (ACPI
data)
 BIOS-e820: 00000000abfce000 - 00000000abff0000 (ACPI
NVS)
 BIOS-e820: 00000000abff0000 - 00000000ac000000
(reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000
(reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000
(reserved)
 BIOS-e820: 00000000ff780000 - 0000000100000000
(reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200
used
Entering add_active_range(0, 256, 704448) 1 entries of
3200 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP (v002 ACPIAM                               
) @ 0x00000000000fb870
ACPI: XSDT (v001 A M I  OEMXSDT  0x04000619 MSFT
0x00000097) @ 0x00000000abfc0100
ACPI: FADT (v003 A M I  OEMFACP  0x04000619 MSFT
0x00000097) @ 0x00000000abfc0290
ACPI: MADT (v001 A M I  OEMAPIC  0x04000619 MSFT
0x00000097) @ 0x00000000abfc0390
ACPI: MCFG (v001 A M I  OEMMCFG  0x04000619 MSFT
0x00000097) @ 0x00000000abfc0400
ACPI: OEMB (v001 A M I  AMI_OEM  0x04000619 MSFT
0x00000097) @ 0x00000000abfce040
ACPI: DSDT (v001  A0368 A0368001 0x00000001 INTL
0x02002026) @ 0x0000000000000000
Scanning NUMA topology in Northbridge 24
Number of nodes 1
Node 0 MemBase 0000000000000000 Limit 00000000abfc0000
Entering add_active_range(0, 0, 159) 0 entries of 3200
used
Entering add_active_range(0, 256, 704448) 1 entries of
3200 used
NUMA: Using 63 for the hash shift.
Using node hash shift of 63
Bootmem setup node 0 0000000000000000-00000000abfc0000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   704448
On node 0 totalpages: 704351
  DMA zone: 64 pages used for memmap
  DMA zone: 1449 pages reserved
  DMA zone: 2486 pages, LIFO batch:0
  DMA32 zone: 10943 pages used for memmap
  DMA32 zone: 689409 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x508
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: IOAPIC (id[0x02] address[0xfec00000]
gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl
dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high
level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high
edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high
edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Setting APIC routing to physical flat
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009f000 -
00000000000a0000
Nosave address range: 00000000000a0000 -
00000000000e5000
Nosave address range: 00000000000e5000 -
0000000000100000
Allocating PCI resources starting at b0000000 (gap:
ac000000:52c00000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 43264 bytes of per cpu data
Built 1 zonelists.  Total pages: 691895
Kernel command line: ro root=LABEL=/ vga=1
pci=nommconf iommu=soft
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour VGA+ 80x50
Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9,
2097152 bytes)
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
PCI-DMA: Using software bounce buffering for IO
(SWIOTLB)
Placing software IO TLB between 0x428f000 - 0x828f000
Memory: 2692344k/2817792k available (2469k kernel
code, 125060k reserved, 1938k data, 312k init)
Calibrating delay using timer specific routine..
4824.85 BogoMIPS (lpj=2412427)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary
module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20060707
Using local APIC timer interrupts.
result 12557279
Detected 12.557 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine..
4821.26 BogoMIPS (lpj=2410632)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm)64 X2 Dual Core Processor  4800+
stepping 02
CPU 1: Syncing TSC to CPU 0.
CPU 1: synchronized TSC with CPU 0 (last diff -81
cycles, maxerr 622 cycles)
Brought up 2 CPUs
Disabling vsyscall due to use of PM timer
time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
time.c: Detected 2410.995 MHz processor.
sizeof(vma)=176 bytes
sizeof(page)=64 bytes
sizeof(inode)=720 bytes
sizeof(dentry)=224 bytes
sizeof(ext3inode)=968 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=240 bytes
sizeof(task_struct)=1904 bytes
migration_cost=513
checking if image is initramfs... it is
Freeing initrd memory: 1521k freed
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:00:05.0
PCI: Transparent bridge - 0000:00:10.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.PCE0._PRT]
ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.PCE1._PRT]
ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.PCE2._PRT]
ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0,
disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0,
disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0,
disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *5
ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0,
disabled.
ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *0,
disabled.
ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0,
disabled.
ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *5
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *5
ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *5
ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0,
disabled.
ACPI: PCI Interrupt Link [LMC9] (IRQs 20 21 22 23) *0,
disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *5
ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *10
ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *11
ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *10
ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0,
disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 14 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If
it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:0b: ioport range 0x290-0x297 has been reserved
PCI: Bridge: 0000:00:02.0
  IO window: disabled.
  MEM window: disabled.
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
  IO window: c000-cfff
  MEM window: faa00000-faafffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:02.0 to
64
PCI: Setting latency timer of device 0000:00:03.0 to
64
PCI: Setting latency timer of device 0000:00:04.0 to
64
PCI: Setting latency timer of device 0000:00:10.0 to
64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8,
1048576 bytes)
TCP established hash table entries: 131072 (order: 10,
4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152
bytes)
TCP: Hash tables configured (established 131072 bind
65536)
TCP reno registered
audit: initializing netlink socket (disabled)
audit(1173355039.607:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096
bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key BA345A59F0682455
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:02.0 to
64
pcie_portdrv_probe->Dev[02fc:10de] has invalid IRQ.
Check vendor BIOS
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
PCI: Setting latency timer of device 0000:00:03.0 to
64
pcie_portdrv_probe->Dev[02fd:10de] has invalid IRQ.
Check vendor BIOS
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
PCI: Setting latency timer of device 0000:00:04.0 to
64
pcie_portdrv_probe->Dev[02fb:10de] has invalid IRQ.
Check vendor BIOS
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:04.0:pcie00]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports,
IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K
size 4096 blocksize
Uniform Multi-Platform E-IDE driver Revision:
7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes;
override with idebus=xx
NFORCE-MCP51: IDE controller at PCI slot 0000:00:0d.0
NFORCE-MCP51: chipset revision 161
NFORCE-MCP51: not 100% native mode: will probe irqs
later
NFORCE-MCP51: 0000:00:0d.0 (rev a1) UDMA133 controller
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings:
hda:pio, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings:
hdc:pio, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
Probing IDE interface ide0...
Probing IDE interface ide1...
ide-floppy driver 0.99.newide
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using
default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 2 AMD Athlon(tm)64 X2 Dual Core
Processor  4800+ processors (version 2.00.00)
powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0x8
powernow-k8:    1 : fid 0xe (2200 MHz), vid 0xa
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xc
powernow-k8:    3 : fid 0xa (1800 MHz), vid 0xe
powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x12
ACPI: (supports S0 S1 S3 S4 S5)
Freeing unused kernel memory: 312k freed
Write protecting the kernel read-only data: 494k
input: AT Translated Set 2 keyboard as
/class/input/input0
USB Universal Host Controller Interface driver v3.0
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host
Controller (OHCI) Driver (PCI)
ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LUB0] ->
GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:0b.0 to
64
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered,
assigned bus number 1
ohci_hcd 0000:00:0b.0: irq 23, io mem 0xfebde000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [LUB2] ->
GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:0b.1 to
64
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: new USB bus registered,
assigned bus number 2
ehci_hcd 0000:00:0b.1: debug port 1
PCI: cache line size of 64 is not supported by device
0000:00:0b.1
ehci_hcd 0000:00:0b.1: irq 22, io mem 0xfebdfc00
ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
SCSI subsystem initialized
libata version 2.00 loaded.
sata_nv 0000:00:0e.0: version 2.0
ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LSA0] ->
GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:0e.0 to
64
ata1: SATA max UDMA/133 cmd 0xE800 ctl 0xE482 bmdma
0xE000 irq 21
ata2: SATA max UDMA/133 cmd 0xE400 ctl 0xE082 bmdma
0xE008 irq 21
scsi0 : sata_nv
ata1: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0xE807
scsi1 : sata_nv
usb 1-1: new low speed USB device using ohci_hcd and
address 2
usb 1-1: configuration #1 chosen from 1 choice
input: Logitech USB-PS/2 Optical Mouse as
/class/input/input1
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical
Mouse] on usb-0000:00:0b.0-1
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7, max UDMA/133, 976773168 sectors: LBA48
NCQ (depth 0/32)
ata2.00: ata2: dev 0 multi count 16
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      ST3500641AS  
   3.AA PQ: 0 ANSI: 5
SCSI device sda: 976773168 512-byte hdwr sectors
(500108 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
SCSI device sda: 976773168 512-byte hdwr sectors
(500108 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3 sda4
sd 1:0:0:0: Attached scsi disk sda
ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [LSA1] ->
GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:0f.0 to
64
ata3: SATA max UDMA/133 cmd 0xDC00 ctl 0xD882 bmdma
0xD400 irq 20
ata4: SATA max UDMA/133 cmd 0xD800 ctl 0xD482 bmdma
0xD408 irq 20
scsi2 : sata_nv
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7, max UDMA/133, 976773168 sectors: LBA48
NCQ (depth 0/32)
ata3.00: ata3: dev 0 multi count 16
ata3.00: configured for UDMA/133
scsi3 : sata_nv
ata4: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0xD807
scsi 2:0:0:0: Direct-Access     ATA      ST3500641AS  
   3.AA PQ: 0 ANSI: 5
SCSI device sdb: 976773168 512-byte hdwr sectors
(500108 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
SCSI device sdb: 976773168 512-byte hdwr sectors
(500108 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
 sdb: sdb1 sdb2 sdb3 sdb4
sd 2:0:0:0: Attached scsi disk sdb
EXT3-fs: INFO: recovery required on readonly
filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: sda2: orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode
1114151
ext3_orphan_cleanup: deleting unreferenced inode
1114150
ext3_orphan_cleanup: deleting unreferenced inode
1114149
EXT3-fs: sda2: 3 orphan inodes deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1173355045.660:2): selinux=0 auid=4294967295
input: PC Speaker as /class/input/input2
ieee1394: Initialized config rom entry `ip1394'
shpchp: Standard Hot Plug PCI Controller Driver
version: 0.4
EDAC MC: Ver: 2.0.1 Mar  4 2007
EDAC MC0: Giving out device to k8_edac
Athlon64/Opteron: DEV 0000:00:18.2
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 19
ACPI: PCI Interrupt 0000:04:05.0[A] -> Link [LNKD] ->
GSI 19 (level, low) -> IRQ 19
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7
[PCSPP,TRISTATE,EPP]
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19] 
MMIO=[faaff800-faafffff]  Max Packet=[2048]  IR/IT
contexts=[4/8]
forcedeth.c: Reverse Engineered nForce ethernet
driver. Version 0.57.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LMAC] ->
GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:14.0 to
64
forcedeth: using HIGHDMA
sd 1:0:0:0: Attached scsi generic sg0 type 0
sd 2:0:0:0: Attached scsi generic sg1 type 0
eth0: forcedeth.c: subsystem: 01043:8141 bound to
0000:00:14.0
ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LAZA] ->
GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:10.1 to
64
i2c_adapter i2c-0: nForce2 SMBus adapter at 0x600
i2c_adapter i2c-1: nForce2 SMBus adapter at 0x700
ieee1394: Host added: ID:BUS[0-00:1023] 
GUID[0011d80000916bf2]
FDC 0 is a post-1991 82077
lp0: using parport0 (interrupt-driven).
lp0: console ready
ACPI: Power Button (FF) [PWRF]
ACPI: Power Button (CM) [PWRB]
ibm_acpi: ec object not found
md: Autodetecting RAID arrays.
md: invalid raid superblock magic on sda4
md: sda4 has invalid sb, not importing!
md: invalid raid superblock magic on sdb4
md: sdb4 has invalid sb, not importing!
md: autorun ...
md: ... autorun DONE.
md: md0 stopped.
md: bind<sdb4>
md: bind<sda4>
md: md0: raid array is not clean -- starting
background reconstruction
md: raid1 personality registered for level 1
raid1: raid set md0 active with 2 out of 2 mirrors
md0: bitmap initialized from disk: read 1/1 pages, set
3234 bits, status: 0
created bitmap (4 pages) for device md0
md: resync of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for resync.
md: using 128k window, over a total of 468302644
blocks.
device-mapper: ioctl: 4.10.0-ioctl (2006-09-14)
initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 4016240k swap on /dev/sdb3.  Priority:-1
extents:1 across:4016240k
Adding 4016240k swap on /dev/sda3.  Priority:-2
extents:1 across:4016240k




 
____________________________________________________________________________________
Need Mail bonding?
Go to the Yahoo! Mail Q&A for great tips from Yahoo! Answers users.
http://answers.yahoo.com/dir/?link=list&sid=396546091
