Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbXGCGQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbXGCGQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 02:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXGCGQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 02:16:21 -0400
Received: from mailhost.terra.es ([213.4.149.12]:26307 "EHLO
	csmtpout2.frontal.correo" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751237AbXGCGQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 02:16:19 -0400
Subject: Re: ppdev - libieee1284.so  conflicts with 2.6.21
From: Juan Antonio Martinez <jonsito@teleline.es>
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@stusta.de>
Content-Type: multipart/mixed; boundary="=-1LPWAi6EwKMVlSHfKBf/"
Date: Tue, 03 Jul 2007 08:16:05 +0200
Message-Id: <1183443365.3006.10.camel@drake.micasa.es>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1LPWAi6EwKMVlSHfKBf/
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Attached 3 reports:
2.6.21 with noisapnp pnpacpi=off
2.6.21 without extra options
2.6.20

I apologize for sending reports with fedora (not vanilla) kernels. I
have not enought time to recompile and test

By diffin'g reports, I've found these significant ( to me) difference in
2.6.20:

< ppdev0: registered pardevice
< ppdev0: negotiated back to compatibility mode because user-space
forgot
< ppdev0: unregistered pardevice


--=-1LPWAi6EwKMVlSHfKBf/
Content-Disposition: attachment; filename=report-2.6.20
Content-Type: text/plain; name=report-2.6.20; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linux version 2.6.20-2925.11.fc7xen (kojibuilder@hammer2.fedora.redhat.com) (gcc version 4.1.2 20070502 (Red Hat 4.1.2-12)) #1 SMP Mon Jun 11 16:21:08 EDT 2007
BIOS-provided physical RAM map:
sanitize start
sanitize bail 0
copy_e820_map() start: 0000000000000000 size: 000000001d801000 end: 000000001d801000 type: 1
 Xen: 0000000000000000 - 000000001d801000 (usable)
0MB HIGHMEM available.
472MB LOWMEM available.
Using x86 segment limits to approximate NX protection
Entering add_active_range(0, 0, 120833) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->   120833
  Normal     120833 ->   120833
  HighMem    120833 ->   120833
early_node_map[1] active PFN ranges
    0:        0 ->   120833
On node 0 totalpages: 120833
  DMA zone: 944 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 119889 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  HighMem zone: 0 pages used for memmap
DMI 2.2 present.
ACPI: RSDP (v000 VIA694                                ) @ 0x000f6db0
ACPI: RSDT (v001 VIA694 AWRDACPI 0x42302e31 AWRD 0x00000000) @ 0x1fff3000
ACPI: FADT (v001 VIA694 AWRDACPI 0x42302e31 AWRD 0x00000000) @ 0x1fff3040
ACPI: DSDT (v001 VIA694 AWRDACPI 0x00001000 MSFT 0x0100000c) @ 0x00000000
Built 1 zonelists.  Total pages: 119889
Kernel command line: ro root=LABEL=/ rhgb quiet
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c135c000 soft=c133c000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Xen reported: 1599.610 MHz processor.
Console: colour VGA+ 80x50
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1064 kB
 per task-struct memory footprint: 1200 bytes
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Software IO TLB enabled: 
 Aperture:     2 megabytes
 Kernel range: 0x00000000c015f000 - 0x00000000c035f000
 Address size: 30 bits
vmalloc area: de800000-f4ffe000, maxmem 2d7fe000
Memory: 453632k/483332k available (2022k kernel code, 21236k reserved, 1075k data, 180k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xf5315000 - 0xf57fe000   (5028 kB)
    pkmap   : 0xf5000000 - 0xf5200000   (2048 kB)
    vmalloc : 0xde800000 - 0xf4ffe000   ( 359 MB)
    lowmem  : 0xc0000000 - 0xdd801000   ( 472 MB)
      .init : 0xc130b000 - 0xc1338000   ( 180 kB)
      .data : 0xc11f9a5d - 0xc1306714   (1075 kB)
      .text : 0xc1000000 - 0xc11f9a5d   (2022 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4010.94 BogoMIPS (lpj=8021890)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383d1f1 c1cbf9ff 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: After all inits, caps: 0383d1f1 c1cbf9ff 00000000 00000420 00000000 00000000 00000000
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20060707
ACPI: setting ELCR to 0800 (from 0e00)
Brought up 1 CPUs
sizeof(vma)=88 bytes
sizeof(page)=32 bytes
sizeof(inode)=564 bytes
sizeof(dentry)=156 bytes
sizeof(ext3inode)=800 bytes
sizeof(buffer_head)=56 bytes
sizeof(skbuff)=176 bytes
sizeof(task_struct)=2656 bytes
Grant table initialized
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
Setting up standard PCI resources
Allocating PCI resources starting at 30000000 (gap: 20000000:dfff0000)
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
PCI quirk: region 6000-607f claimed by vt82c686 HW-mon
PCI quirk: region 5000-500f claimed by vt82c686 SMB
PCI: Firmware left 0000:00:14.0 e100 interrupts enabled, disabling
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
xen_mem: Initialising balloon driver.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI: Bridge: 0000:00:01.0
  IO window: 9000-9fff
  MEM window: d8000000-d9ffffff
  PREFETCH window: d4000000-d7ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 7, 524288 bytes)
TCP bind hash table entries: 8192 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 16384 bind 8192)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 7283k freed
IA-32 Microcode Update Driver: v1.14-xen <tigran@veritas.com>
audit: initializing netlink socket (disabled)
audit(1183441365.000:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Applying VIA southbridge workaround.
PCI: Disabling Via external APIC routing
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 2 throttling states)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected VIA Twister-K/KT133x/KM133 chipset
agpgart: AGP aperture is 64M @ 0xd0000000
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
Xen virtual console successfully installed as ttyS0
Event-channel device installed.
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
Freeing unused kernel memory: 180k freed
Write protecting the kernel read-only data: 759k
4gb seg fixup, process init (pid 1), cs:ip 73:00ef6b0d
4gb seg fixup, process init (pid 1), cs:ip 73:00883e67
4gb seg fixup, process init (pid 1), cs:ip 73:00eed710
4gb seg fixup, process init (pid 1), cs:ip 73:00f64659
4gb seg fixup, process init (pid 1), cs:ip 73:00ef0fdc
4gb seg fixup, process init (pid 1), cs:ip 73:00ef0fea
4gb seg fixup, process init (pid 1), cs:ip 73:00f47d82
4gb seg fixup, process init (pid 1), cs:ip 73:00ee9ff1
4gb seg fixup, process init (pid 1), cs:ip 73:00ef0fdc
4gb seg fixup, process init (pid 1), cs:ip 73:00ef0fea
input: PS2++ Logitech Wheel Mouse as /class/input/input2
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 10, io base 0x0000a400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:07.3[D] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:07.3: UHCI Host Controller
uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:07.3: irq 10, io base 0x0000a800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
SCSI subsystem initialized
libata version 2.00 loaded.
pata_via 0000:00:07.1: version 0.2.1
ata1: PATA max UDMA/100 cmd 0x1F0 ctl 0x3F6 bmdma 0xA000 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xA008 irq 15
scsi0 : pata_via
usb 1-1: new full speed USB device using uhci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
ata1.00: ATA-6, max UDMA/100, 39102336 sectors: LBA 
ata1.00: ata1: dev 0 multi count 16
ata1.01: ATAPI, max UDMA/33
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/33
scsi1 : pata_via
ata2.00: ATAPI, max MWDMA2
ata2.01: ATA-7, max UDMA/133, 80293248 sectors: LBA 
ata2.01: ata2: dev 1 multi count 16
ata2.00: configured for MWDMA2
ata2.01: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST320410A        5.33 PQ: 0 ANSI: 5
SCSI device sda: 39102336 512-byte hdwr sectors (20020 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 39102336 512-byte hdwr sectors (20020 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
scsi 0:0:1:0: CD-ROM            PIONEER  DVD RW  DVR-106D 1.05 PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            HL-DT-ST CD-RW GCE-8400B  1.00 PQ: 0 ANSI: 5
scsi 1:0:1:0: Direct-Access     ATA      Maxtor 6E040L0   NAR6 PQ: 0 ANSI: 5
SCSI device sdb: 80293248 512-byte hdwr sectors (41110 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 80293248 512-byte hdwr sectors (41110 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 1:0:1:0: Attached scsi disk sdb
printk: 15605 messages suppressed.
4gb seg fixup, process init (pid 1), cs:ip 73:00ef0fdc
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
sym0: <810a> rev 0x12 at pci 0000:00:11.0 irq 11
sym0: No NVRAM, ID 7, Fast-10, SE, parity checking
sym0: SCSI BUS has been reset.
scsi2 : sym-2.2.3
scsi: waiting for bus probes to complete ...
printk: 297 messages suppressed.
4gb seg fixup, process nash-hotplug (pid 272), cs:ip 73:00ef0fdc
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
security:  3 users, 6 roles, 1822 types, 79 bools, 1 sens, 1024 cats
security:  60 classes, 68296 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sda3, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev eventpollfs, type eventpollfs), uses task SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev cpuset, type cpuset), uses genfs_contexts
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
audit(1183441380.420:2): policy loaded auid=4294967295
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:0:1:0: Attached scsi generic sg1 type 5
scsi 1:0:0:0: Attached scsi generic sg2 type 5
sd 1:0:1:0: Attached scsi generic sg3 type 0
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
sr0: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:1:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
sr 1:0:0:0: Attached scsi CD-ROM sr1
Linux video capture interface: v2.00
bttv: driver version 0.9.16 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
bttv0: Bt848 (rev 18) at 0000:00:12.0, irq: 10, latency: 32, mmio: 0xdb102000
bttv0: using: Zoltrix TV-Max [card=15,insmod option]
bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
bttv0: using tuner=0
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
bttv0: i2c: checking for TDA9887 @ 0x86... not found
input: PC Speaker as /class/input/input3
tuner 0-0060: All bytes are equal. It is not a TEA5767
tuner 0-0060: chip found @ 0xc0 (bt848 #0 [sw])
tuner 0-0060: type set to 0 (Temic PAL (4002 FH5))
tuner 0-0060: type set to 0 (Temic PAL (4002 FH5))
tuner 0-0061: chip found @ 0xc2 (bt848 #0 [sw])
bttv0: registered device video0
bttv0: registered device vbi0
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
e100: eth0: e100_probe: addr 0xdb100000, irq 10, MAC addr 00:90:27:24:D0:34
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x378
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
parport_pc: VIA parallel port: io=0x378, irq=7
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:07.5[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:07.5 to 64
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
8250_pnp: Unknown symbol serial8250_unregister_port
8250_pnp: Unknown symbol serial8250_register_port
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
8250_pnp: Unknown symbol serial8250_unregister_port
8250_pnp: Unknown symbol serial8250_register_port
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x04F9 pid 0x0027
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
loop: loaded (max 8 devices)
lp0: using parport0 (interrupt-driven).
lp0: console ready
sonypi: Sony Programmable I/O Controller Driver v1.26.
SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input5
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [SLPB]
No dock devices found.
ibm_acpi: ec object not found
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sdb1, type ext3), uses xattr
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sdb2, type ext3), uses xattr
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
Adding 1052248k swap on /dev/sda2.  Priority:-1 extents:1 across:1052248k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (3776 buckets, 30208 max)
Bridge firewalling registered
ADDRCONF(NETDEV_UP): eth0: link is not ready
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
device eth0 entered promiscuous mode
audit(1183441417.885:3): dev=eth0 prom=256 old_prom=0 auid=4294967295
br0: port 1(eth0) entering learning state
br0: topology change detected, propagating
br0: port 1(eth0) entering forwarding state
audit(1183441423.153:4): audit_pid=1781 old=0 by auid=4294967295 subj=system_u:system_r:auditd_t:s0
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
br0: no IPv6 routers present
eth0: no IPv6 routers present
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: HIDP (Human Interface Emulation) ver 1.1
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
virbr0: no IPv6 routers present
br0: port 1(eth0) entering disabled state
pbr0: port 1(eth0) entering learning state
pbr0: topology change detected, propagating
pbr0: port 1(eth0) entering forwarding state
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized r128 2.5.0 20030725 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
pbr0: no IPv6 routers present
ppdev: user-space parallel port driver
ppdev0: registered pardevice
ppdev0: unregistered pardevice
ppdev0: registered pardevice
ppdev0: negotiated back to compatibility mode because user-space forgot
ppdev0: unregistered pardevice
ppdev0: registered pardevice
ppdev0: unregistered pardevice

--=-1LPWAi6EwKMVlSHfKBf/
Content-Disposition: attachment; filename=report-2.6.21
Content-Type: text/plain; name=report-2.6.21; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linux version 2.6.21-1.3228.fc7 (kojibuilder@xenbuilder2.fedora.redhat.com) (gcc version 4.1.2 20070502 (Red Hat 4.1.2-12)) #1 SMP Tue Jun 12 15:37:31 EDT 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001fef0000 end: 000000001fff0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001fff0000 size: 0000000000003000 end: 000000001fff3000 type: 4
copy_e820_map() start: 000000001fff3000 size: 000000000000d000 end: 0000000020000000 type: 3
copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 000000001fff3000 (ACPI NVS)
 BIOS-e820: 000000001fff3000 - 0000000020000000 (ACPI data)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
511MB LOWMEM available.
Using x86 segment limits to approximate NX protection
Entering add_active_range(0, 0, 131056) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131056
  HighMem    131056 ->   131056
early_node_map[1] active PFN ranges
    0:        0 ->   131056
On node 0 totalpages: 131056
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 991 pages used for memmap
  Normal zone: 125969 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
DMI 2.2 present.
Using APIC driver default
ACPI: RSDP 000F6DB0, 0014 (r0 VIA694)
ACPI: RSDT 1FFF3000, 0028 (r1 VIA694 AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 1FFF3040, 0074 (r1 VIA694 AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 1FFF30C0, 24A9 (r1 VIA694 AWRDACPI     1000 MSFT  100000C)
ACPI: FACS 1FFF0000, 0040
ACPI: PM-Timer IO Port: 0x4008
Allocating PCI resources starting at 30000000 (gap: 20000000:dfff0000)
Built 1 zonelists.  Total pages: 130033
Kernel command line: ro root=LABEL=/ rhgb quiet
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (0140b000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c077c000 soft=c075c000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1599.572 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 511896k/524224k available (2066k kernel code, 11672k reserved, 1092k data, 240k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc56000 - 0xfffff000   (3748 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
      .init : 0xc071b000 - 0xc0757000   ( 240 kB)
      .data : 0xc0604bc2 - 0xc0715cb4   (1092 kB)
      .text : 0xc0400000 - 0xc0604bc2   (2066 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3201.06 BogoMIPS (lpj=1600530)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff c1cbf9ff 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: After all inits, caps: 0383f1ff c1cbf9ff 00000000 00000420 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 14k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0800 (from 0e00)
CPU0: AMD Athlon(tm) XP 1900+ stepping 02
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
sizeof(vma)=84 bytes
sizeof(page)=32 bytes
sizeof(inode)=336 bytes
sizeof(dentry)=132 bytes
sizeof(ext3inode)=488 bytes
sizeof(buffer_head)=56 bytes
sizeof(skbuff)=176 bytes
sizeof(task_struct)=1376 bytes
Time:  5:54:45  Date: 06/03/107
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb380, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 6000-607f claimed by vt82c686 HW-mon
PCI quirk: region 5000-500f claimed by vt82c686 SMB
PCI: Firmware left 0000:00:14.0 e100 interrupts enabled, disabling
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:00: iomem range 0xcc000-0xcffff has been reserved
pnp: 00:00: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: 9000-9fff
  MEM window: d8000000-d9ffffff
  PREFETCH window: d4000000-d7ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 196608 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2862k freed
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
audit(1183442085.150:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key 949CEA51B56F22EC
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Applying VIA southbridge workaround.
PCI: Disabling Via external APIC routing
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 2 throttling states)
isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected VIA Twister-K/KT133x/KM133 chipset
agpgart: AGP aperture is 64M @ 0xd0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Time: acpi_pm clocksource has been installed.
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Processor cpuid 662 not supported
Using IPI No-Shortcut mode
  Magic number: 15:647:920
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Freeing unused kernel memory: 240k freed
Write protecting the kernel read-only data: 820k
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 10, io base 0x0000a400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:07.3[D] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:07.3: UHCI Host Controller
uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:07.3: irq 10, io base 0x0000a800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
input: PS2++ Logitech Wheel Mouse as /class/input/input2
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
SCSI subsystem initialized
libata version 2.20 loaded.
usb 1-1: new full speed USB device using uhci_hcd and address 2
pata_via 0000:00:07.1: version 0.2.1
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001a000 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001a008 irq 15
scsi0 : pata_via
usb 1-1: configuration #1 chosen from 1 choice
ata1.00: ata_hpa_resize 1: sectors = 39102336, hpa_sectors = 39102336
ata1.00: ATA-6: ST320410A, 5.33, max UDMA/100
ata1.00: 39102336 sectors, multi 16: LBA 
ata1.01: ATAPI, max UDMA/33
ata1.00: ata_hpa_resize 1: sectors = 39102336, hpa_sectors = 39102336
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/33
scsi1 : pata_via
ata2.00: ATAPI, max MWDMA2
ata2.01: ata_hpa_resize 1: sectors = 80293248, hpa_sectors = 80293248
ata2.01: ATA-7: Maxtor 6E040L0, NAR61590, max UDMA/133
ata2.01: 80293248 sectors, multi 16: LBA 
ata2.00: configured for MWDMA2
ata2.01: ata_hpa_resize 1: sectors = 80293248, hpa_sectors = 80293248
ata2.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      ST320410A        5.33 PQ: 0 ANSI: 5
SCSI device sda: 39102336 512-byte hdwr sectors (20020 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 39102336 512-byte hdwr sectors (20020 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
scsi 0:0:1:0: CD-ROM            PIONEER  DVD RW  DVR-106D 1.05 PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            HL-DT-ST CD-RW GCE-8400B  1.00 PQ: 0 ANSI: 5
scsi 1:0:1:0: Direct-Access     ATA      Maxtor 6E040L0   NAR6 PQ: 0 ANSI: 5
SCSI device sdb: 80293248 512-byte hdwr sectors (41110 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 80293248 512-byte hdwr sectors (41110 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 1:0:1:0: Attached scsi disk sdb
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
sym0: <810a> rev 0x12 at pci 0000:00:11.0 irq 11
sym0: No NVRAM, ID 7, Fast-10, SE, parity checking
sym0: SCSI BUS has been reset.
scsi2 : sym-2.2.3
scsi: waiting for bus probes to complete ...
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
security:  3 users, 6 roles, 1822 types, 79 bools, 1 sens, 1024 cats
security:  60 classes, 68296 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sda3, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev eventpollfs, type eventpollfs), uses task SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev cpuset, type cpuset), uses genfs_contexts
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
audit(1183442100.564:2): policy loaded auid=4294967295
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:0:1:0: Attached scsi generic sg1 type 5
scsi 1:0:0:0: Attached scsi generic sg2 type 5
sd 1:0:1:0: Attached scsi generic sg3 type 0
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
sr0: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:1:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
sr 1:0:0:0: Attached scsi CD-ROM sr1
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x378
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
parport_pc: VIA parallel port: io=0x378, irq=7
input: PC Speaker as /class/input/input3
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
e100: eth0: e100_probe: addr 0xdb100000, irq 10, MAC addr 00:90:27:24:D0:34
Linux video capture interface: v2.00
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
bttv0: Bt848 (rev 18) at 0000:00:12.0, irq: 10, latency: 32, mmio: 0xdb102000
bttv0: using: Zoltrix TV-Max [card=15,insmod option]
bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
bttv0: using tuner=0
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
bttv0: i2c: checking for TDA9887 @ 0x86... not found
tuner 1-0060: All bytes are equal. It is not a TEA5767
tuner 1-0060: chip found @ 0xc0 (bt848 #0 [sw])
tuner 1-0060: type set to 0 (Temic PAL (4002 FH5))
tuner 1-0060: type set to 0 (Temic PAL (4002 FH5))
tuner 1-0061: chip found @ 0xc2 (bt848 #0 [sw])
bttv0: registered device video0
bttv0: registered device vbi0
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x04F9 pid 0x0027
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:07.5[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:07.5 to 64
loop: loaded (max 8 devices)
lp0: using parport0 (interrupt-driven).
lp0: console ready
sonypi: Sony Programmable I/O Controller Driver v1.26.
SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
No dock devices found.
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input5
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [SLPB]
ibm_acpi: ec object not found
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sdb1, type ext3), uses xattr
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sdb2, type ext3), uses xattr
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
Adding 1052248k swap on /dev/sda2.  Priority:-1 extents:1 across:1052248k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (4095 buckets, 32760 max)
Bridge firewalling registered
ADDRCONF(NETDEV_UP): eth0: link is not ready
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
device eth0 entered promiscuous mode
audit(1183442136.597:3): dev=eth0 prom=256 old_prom=0 auid=4294967295
br0: port 1(eth0) entering learning state
br0: topology change detected, propagating
br0: port 1(eth0) entering forwarding state
audit(1183442141.596:4): audit_pid=1753 old=0 by auid=4294967295 subj=system_u:system_r:auditd_t:s0
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
eth0: no IPv6 routers present
br0: no IPv6 routers present
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
virbr0: no IPv6 routers present
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized r128 2.5.0 20030725 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
ppdev: user-space parallel port driver
ppdev0: registered pardevice
ppdev0: unregistered pardevice

--=-1LPWAi6EwKMVlSHfKBf/
Content-Disposition: attachment; filename=report-2.6.21-noisapnp_pnpacpi_off
Content-Type: text/plain; name=report-2.6.21-noisapnp_pnpacpi_off; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linux version 2.6.21-1.3228.fc7 (kojibuilder@xenbuilder2.fedora.redhat.com) (gcc version 4.1.2 20070502 (Red Hat 4.1.2-12)) #1 SMP Tue Jun 12 15:37:31 EDT 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001fef0000 end: 000000001fff0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001fff0000 size: 0000000000003000 end: 000000001fff3000 type: 4
copy_e820_map() start: 000000001fff3000 size: 000000000000d000 end: 0000000020000000 type: 3
copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 000000001fff3000 (ACPI NVS)
 BIOS-e820: 000000001fff3000 - 0000000020000000 (ACPI data)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
511MB LOWMEM available.
Using x86 segment limits to approximate NX protection
Entering add_active_range(0, 0, 131056) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131056
  HighMem    131056 ->   131056
early_node_map[1] active PFN ranges
    0:        0 ->   131056
On node 0 totalpages: 131056
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 991 pages used for memmap
  Normal zone: 125969 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
DMI 2.2 present.
Using APIC driver default
ACPI: RSDP 000F6DB0, 0014 (r0 VIA694)
ACPI: RSDT 1FFF3000, 0028 (r1 VIA694 AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 1FFF3040, 0074 (r1 VIA694 AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 1FFF30C0, 24A9 (r1 VIA694 AWRDACPI     1000 MSFT  100000C)
ACPI: FACS 1FFF0000, 0040
ACPI: PM-Timer IO Port: 0x4008
Allocating PCI resources starting at 30000000 (gap: 20000000:dfff0000)
Built 1 zonelists.  Total pages: 130033
Kernel command line: ro root=LABEL=/ rhgb quiet noisapnp pnpacpi=off
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (0140b000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c077c000 soft=c075c000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1599.572 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 511896k/524224k available (2066k kernel code, 11672k reserved, 1092k data, 240k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc56000 - 0xfffff000   (3748 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
      .init : 0xc071b000 - 0xc0757000   ( 240 kB)
      .data : 0xc0604bc2 - 0xc0715cb4   (1092 kB)
      .text : 0xc0400000 - 0xc0604bc2   (2066 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3201.03 BogoMIPS (lpj=1600517)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff c1cbf9ff 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: After all inits, caps: 0383f1ff c1cbf9ff 00000000 00000420 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 14k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0800 (from 0e00)
CPU0: AMD Athlon(tm) XP 1900+ stepping 02
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
sizeof(vma)=84 bytes
sizeof(page)=32 bytes
sizeof(inode)=336 bytes
sizeof(dentry)=132 bytes
sizeof(ext3inode)=488 bytes
sizeof(buffer_head)=56 bytes
sizeof(skbuff)=176 bytes
sizeof(task_struct)=1376 bytes
Time:  5:32:00  Date: 06/03/107
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb380, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 6000-607f claimed by vt82c686 HW-mon
PCI quirk: region 5000-500f claimed by vt82c686 SMB
PCI: Firmware left 0000:00:14.0 e100 interrupts enabled, disabling
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: 9000-9fff
  MEM window: d8000000-d9ffffff
  PREFETCH window: d4000000-d7ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 196608 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2862k freed
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
audit(1183440719.150:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key 949CEA51B56F22EC
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Applying VIA southbridge workaround.
PCI: Disabling Via external APIC routing
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 2 throttling states)
isapnp: ISA Plug & Play support disabled
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected VIA Twister-K/KT133x/KM133 chipset
agpgart: AGP aperture is 64M @ 0xd0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Time: acpi_pm clocksource has been installed.
Switched to high resolution mode on CPU 0
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Processor cpuid 662 not supported
Using IPI No-Shortcut mode
  Magic number: 15:235:516
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Freeing unused kernel memory: 240k freed
Write protecting the kernel read-only data: 820k
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 10, io base 0x0000a400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
input: PS2++ Logitech Wheel Mouse as /class/input/input2
ACPI: PCI Interrupt 0000:00:07.3[D] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:07.3: UHCI Host Controller
uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:07.3: irq 10, io base 0x0000a800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
SCSI subsystem initialized
libata version 2.20 loaded.
pata_via 0000:00:07.1: version 0.2.1
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001a000 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001a008 irq 15
scsi0 : pata_via
usb 1-1: new full speed USB device using uhci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
ata1.00: ata_hpa_resize 1: sectors = 39102336, hpa_sectors = 39102336
ata1.00: ATA-6: ST320410A, 5.33, max UDMA/100
ata1.00: 39102336 sectors, multi 16: LBA 
ata1.01: ATAPI, max UDMA/33
ata1.00: ata_hpa_resize 1: sectors = 39102336, hpa_sectors = 39102336
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/33
scsi1 : pata_via
ata2.00: ATAPI, max MWDMA2
ata2.01: ata_hpa_resize 1: sectors = 80293248, hpa_sectors = 80293248
ata2.01: ATA-7: Maxtor 6E040L0, NAR61590, max UDMA/133
ata2.01: 80293248 sectors, multi 16: LBA 
ata2.00: configured for MWDMA2
ata2.01: ata_hpa_resize 1: sectors = 80293248, hpa_sectors = 80293248
ata2.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      ST320410A        5.33 PQ: 0 ANSI: 5
SCSI device sda: 39102336 512-byte hdwr sectors (20020 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 39102336 512-byte hdwr sectors (20020 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
scsi 0:0:1:0: CD-ROM            PIONEER  DVD RW  DVR-106D 1.05 PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            HL-DT-ST CD-RW GCE-8400B  1.00 PQ: 0 ANSI: 5
scsi 1:0:1:0: Direct-Access     ATA      Maxtor 6E040L0   NAR6 PQ: 0 ANSI: 5
SCSI device sdb: 80293248 512-byte hdwr sectors (41110 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 80293248 512-byte hdwr sectors (41110 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 1:0:1:0: Attached scsi disk sdb
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
sym0: <810a> rev 0x12 at pci 0000:00:11.0 irq 11
sym0: No NVRAM, ID 7, Fast-10, SE, parity checking
sym0: SCSI BUS has been reset.
scsi2 : sym-2.2.3
scsi: waiting for bus probes to complete ...
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
security:  3 users, 6 roles, 1822 types, 79 bools, 1 sens, 1024 cats
security:  60 classes, 68296 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sda3, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev eventpollfs, type eventpollfs), uses task SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev cpuset, type cpuset), uses genfs_contexts
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
audit(1183440734.520:2): policy loaded auid=4294967295
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:0:1:0: Attached scsi generic sg1 type 5
scsi 1:0:0:0: Attached scsi generic sg2 type 5
sd 1:0:1:0: Attached scsi generic sg3 type 0
sr0: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:1:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
sr 1:0:0:0: Attached scsi CD-ROM sr1
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x378
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
input: PC Speaker as /class/input/input3
parport_pc: VIA parallel port: io=0x378, irq=7
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
e100: eth0: e100_probe: addr 0xdb100000, irq 10, MAC addr 00:90:27:24:D0:34
Linux video capture interface: v2.00
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
bttv0: Bt848 (rev 18) at 0000:00:12.0, irq: 10, latency: 32, mmio: 0xdb102000
bttv0: using: Zoltrix TV-Max [card=15,insmod option]
bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
bttv0: using tuner=0
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
bttv0: i2c: checking for TDA9887 @ 0x86... not found
tuner 1-0060: All bytes are equal. It is not a TEA5767
tuner 1-0060: chip found @ 0xc0 (bt848 #0 [sw])
tuner 1-0060: type set to 0 (Temic PAL (4002 FH5))
tuner 1-0060: type set to 0 (Temic PAL (4002 FH5))
tuner 1-0061: chip found @ 0xc2 (bt848 #0 [sw])
bttv0: registered device video0
bttv0: registered device vbi0
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:07.5[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:07.5 to 64
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x04F9 pid 0x0027
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
loop: loaded (max 8 devices)
lp0: using parport0 (interrupt-driven).
lp0: console ready
sonypi: Sony Programmable I/O Controller Driver v1.26.
SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
No dock devices found.
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input5
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [SLPB]
ibm_acpi: ec object not found
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sdb1, type ext3), uses xattr
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sdb2, type ext3), uses xattr
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
Adding 1052248k swap on /dev/sda2.  Priority:-1 extents:1 across:1052248k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (4095 buckets, 32760 max)
Bridge firewalling registered
ADDRCONF(NETDEV_UP): eth0: link is not ready
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
device eth0 entered promiscuous mode
audit(1183440770.513:3): dev=eth0 prom=256 old_prom=0 auid=4294967295
br0: port 1(eth0) entering learning state
br0: topology change detected, propagating
br0: port 1(eth0) entering forwarding state
audit(1183440775.012:4): audit_pid=1683 old=0 by auid=4294967295 subj=system_u:system_r:auditd_t:s0
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
eth0: no IPv6 routers present
br0: no IPv6 routers present
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
virbr0: no IPv6 routers present
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized r128 2.5.0 20030725 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
ppdev: user-space parallel port driver
ppdev0: registered pardevice
ppdev0: unregistered pardevice

--=-1LPWAi6EwKMVlSHfKBf/--

