Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbXBWHg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbXBWHg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 02:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXBWHg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 02:36:59 -0500
Received: from port326.ds1-brh.adsl.cybercity.dk ([217.157.160.207]:24205 "EHLO
	mail.jaquet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbXBWHg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 02:36:57 -0500
X-Greylist: delayed 1924 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Feb 2007 02:36:51 EST
Date: Fri, 23 Feb 2007 08:04:39 +0100
From: Rasmus Andersen <rasmus@jaquet.dk>
To: linux-kernel@vger.kernel.org
Subject: raid 1 check and component device mismatches
Message-ID: <20070223070439.GG7028@jaquet.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

Let me first start by saying that if a better place to ask these
quesions is to be found, please let me know.

I have a 2.6.20 kernel running a raid 1 set with two SATA disks.
Recently (on an older (gentoo-specific) kernel) I started getting
entries like this after my weekly 'echo check >
/sys/block/md0/md/sync_action'

mdadm: RebuildFinished event detected on md device /dev/md0, component 
device  mismatches found : 375936

I have tried 'repair' a number of times but to no avail. The disks seem
OK from their smart values and I have yet to discover an actual data
problem. Still, I am a bit unsettled and would like to hear opinions.
I have attached dmesg and smartctl -a output from both disks, if more is
needed I am happy to provide.

Thanks in advance,
  Rasmus

--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

000 end: 000000001ffef000 type: 3
copy_e820_map() start: 000000001ffef000 size: 0000000000010000 end: 000000001ffff000 type: 2
copy_e820_map() start: 000000001ffff000 size: 0000000000001000 end: 0000000020000000 type: 4
copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ffec000 (usable)
 BIOS-e820: 000000001ffec000 - 000000001ffef000 (ACPI data)
 BIOS-e820: 000000001ffef000 - 000000001ffff000 (reserved)
 BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
511MB LOWMEM available.
Entering add_active_range(0, 0, 131052) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131052
early_node_map[1] active PFN ranges
    0:        0 ->   131052
On node 0 totalpages: 131052
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 991 pages used for memmap
  Normal zone: 125965 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP (v000 ASUS                                  ) @ 0x000f7930
ACPI: RSDT (v001 ASUS   A7A266   0x42302e31 MSFT 0x31313031) @ 0x1ffec000
ACPI: FADT (v001 ASUS   A7A266   0x42302e31 MSFT 0x31313031) @ 0x1ffec080
ACPI: BOOT (v001 ASUS   A7A266   0x42302e31 MSFT 0x31313031) @ 0x1ffec040
ACPI: DSDT (v001   ASUS A7A266   0x00001000 MSFT 0x0100000b) @ 0x00000000
ACPI: PM-Timer IO Port: 0xe408
Allocating PCI resources starting at 30000000 (gap: 20000000:dfff0000)
Detected 1410.349 MHz processor.
Built 1 zonelists.  Total pages: 130029
Kernel command line: BOOT_IMAGE=2.6.20 ro root=902 root=/dev/ram0 lvm2root=/dev/data1/root elevator=cfq hda=none
ide_setup: hda=none
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (01402000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 513016k/524208k available (2387k kernel code, 10660k reserved, 938k data, 188k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xe0800000 - 0xfffb5000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdffec000   ( 511 MB)
      .init : 0xc0442000 - 0xc0471000   ( 188 kB)
      .data : 0xc0354fda - 0xc043f8a4   ( 938 kB)
      .text : 0xc0100000 - 0xc0354fda   (2387 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 2822.33 BogoMIPS (lpj=5644677)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff c1cbf9ff 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: After all inits, caps: 0383f9ff c1cbf9ff 00000000 00000420 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Athlon(TM) XP1600+ stepping 02
Checking 'hlt' instruction... OK.
ACPI: Core revision 20060707
ACPI: setting ELCR to 0200 (from 1e60)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf1170, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 *6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKI] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
PCI quirk: region e400-e43f claimed by ali7101 ACPI
PCI quirk: region e800-e81f claimed by ali7101 SMB
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
SCSI subsystem initialized
libata version 2.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:02: ioport range 0xe400-0xe47f could not be reserved
pnp: 00:02: ioport range 0xe800-0xe81f has been reserved
pnp: 00:02: ioport range 0x40b-0x40b has been reserved
pnp: 00:02: ioport range 0x480-0x48f has been reserved
pnp: 00:02: ioport range 0x4d6-0x4d6 has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: e6000000-e7dfffff
  PREFETCH window: e7f00000-efffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 16384 bind 8192)
TCP reno registered
checking if image is initramfs...it isn't (no cpio magic); looks like an initrd
Freeing initrd memory: 2436k freed
Simple Boot Flag at 0x3a set to 0x1
Machine check exception polling timer started.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Limiting direct PCI/PCI transfers.
Activating ISA DMA hang workarounds.
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: Invalid PBLK length [5]
lp: driver loaded but no devices found
Linux agpgart interface v0.101 (c) Dave Jones
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)]
lp0: using parport0 (interrupt-driven).
floppy0: no floppy controllers found
RAMDISK driver initialized: 4 RAM disks of 8192K size 1024 blocksize
loop: loaded (max 8 devices)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 12
PCI: setting IRQ 12 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 12 (level, low) -> IRQ 12
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:00:0a.0: 3Com PCI 3c905C Tornado at e080c000.
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
0000:00:0b.0: 3Com PCI 3c905C Tornado at e080e000.
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
hdb: WDC WD800BB-00CAA1, ATA DISK drive
Probing IDE interface ide1...
hdc: PLEXTOR DVDR PX-712A, ATAPI CD/DVD-ROM drive
Probing IDE interface ide2...
Probing IDE interface ide3...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hdb: max request size: 128KiB
hdb: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=65535/16/63
hdb: cache flushes not supported
 hdb: hdb1 hdb2
hdc: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 8192kB Cache
Uniform CD-ROM driver Revision: 3.20
sata_sil 0000:00:09.0: version 2.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
ata1: SATA max UDMA/100 cmd 0xE0810080 ctl 0xE081008A bmdma 0xE0810000 irq 5
ata2: SATA max UDMA/100 cmd 0xE08100C0 ctl 0xE08100CA bmdma 0xE0810008 irq 5
scsi0 : sata_sil
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-7, max UDMA/133, 490234752 sectors: LBA48 
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/100
scsi1 : sata_sil
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata2.00: ATA-7, max UDMA/133, 625142448 sectors: LBA48 NCQ (depth 0/32)
ata2.00: ata2: dev 0 multi count 16
ata2.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y250M0   YAR5 PQ: 0 ANSI: 5
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: Attached scsi disk sda
scsi 1:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
SCSI device sdb: 625142448 512-byte hdwr sectors (320073 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 625142448 512-byte hdwr sectors (320073 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 1:0:0:0: Attached scsi disk sdb
ieee1394: raw1394: /dev/raw1394 device initialized
usbmon: debugfs is not available
USB Universal Host Controller Interface driver v3.0
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
Advanced Linux Sound Architecture Driver Version 1.0.14rc1 (Tue Jan 09 09:56:17 2007 UTC).
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0c.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
ALSA device list:
  #0: Ensoniq AudioPCI ENS1371 at 0x9400, irq 11
oprofile: using timer interrupt.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
ACPI: (supports S0 S1 S4 S5)
md: Autodetecting RAID arrays.
Time: tsc clocksource has been installed.
md: invalid raid superblock magic on hdb1
md: hdb1 has invalid sb, not importing!
md: invalid raid superblock magic on sdb1
md: sdb1 has invalid sb, not importing!
md: autorun ...
md: considering sdb2 ...
md:  adding sdb2 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb2>
md: running: <sdb2><sda1>
raid1: raid set md0 active with 2 out of 2 mirrors
md0: bitmap initialized from disk: read 12/12 pages, set 39 bits, status: 0
created bitmap (190 pages) for device md0
md: ... autorun DONE.
RAMDISK: Compressed image found at block 0
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 188k freed
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
ali15x3_smbus 0000:00:11.0: ALI15X3_smb region uninitialized - upgrade BIOS or use force_addr=0xaddr
ali15x3_smbus 0000:00:11.0: ALI15X3 not detected, module not inserted.
EXT3 FS on dm-6, internal journal
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (4095 buckets, 32760 max)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
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
EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
Adding 489972k swap on /dev/sda2.  Priority:1 extents:1 across:489972k
ip_tables: (C) 2000-2006 Netfilter Core Team
eth0:  setting full-duplex.
eth1:  setting full-duplex.
hdc: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
hdc: drive_cmd: error=0x04 { AbortedCommand }
ide: failed opcode was: 0xec
md: requested-resync of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for requested-resync.
md: using 128k window, over a total of 198306240 blocks.
md: md0: requested-resync done.
RAID1 conf printout:
 --- wd:2 rd:2
 disk 0, wo:0, o:1, dev:sdb2
 disk 1, wo:0, o:1, dev:sda1
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
md: requested-resync of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for requested-resync.
md: using 128k window, over a total of 198306240 blocks.
possible SYN flooding on port 6998. Sending cookies.
possible SYN flooding on port 6998. Sending cookies.
possible SYN flooding on port 6998. Sending cookies.
possible SYN flooding on port 6998. Sending cookies.
possible SYN flooding on port 6998. Sending cookies.
md: md0: requested-resync done.
RAID1 conf printout:
 --- wd:2 rd:2
 disk 0, wo:0, o:1, dev:sdb2
 disk 1, wo:0, o:1, dev:sda1

--vGgW1X5XWziG23Ko
Content-Type: application/vnd.stardivision.draw
Content-Disposition: attachment; filename="smart.sda"
Content-Transfer-Encoding: quoted-printable

smartctl version 5.36 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen=
=0AHome page is http://smartmontools.sourceforge.net/=0A=0A=3D=3D=3D START =
OF INFORMATION SECTION =3D=3D=3D=0AModel Family:     Maxtor DiamondMax Plus=
 9 family=0ADevice Model:     Maxtor 6Y250M0=0ASerial Number:    Y658CX1E=
=0AFirmware Version: YAR51HW0=0AUser Capacity:    251,000,193,024 bytes=0AD=
evice is:        In smartctl database [for details use: -P show]=0AATA Vers=
ion is:   7=0AATA Standard is:  ATA/ATAPI-7 T13 1532D revision 0=0ALocal Ti=
me is:    Fri Feb 23 08:03:11 2007 CET=0ASMART support is: Available - devi=
ce has SMART capability.=0ASMART support is: Enabled=0A=0A=3D=3D=3D START O=
F READ SMART DATA SECTION =3D=3D=3D=0ASMART overall-health self-assessment =
test result: PASSED=0A=0AGeneral SMART Values:=0AOffline data collection st=
atus:  (0x82)	Offline data collection activity=0A					was completed without=
 error.=0A					Auto Offline Data Collection: Enabled.=0ASelf-test execution=
 status:      (  35)	The self-test routine was interrupted=0A					by the ho=
st with a hard or soft reset.=0ATotal time to complete Offline =0Adata coll=
ection: 		 ( 363) seconds.=0AOffline data collection=0Acapabilities: 			 (0=
x5b) SMART execute Offline immediate.=0A					Auto Offline data collection o=
n/off support.=0A					Suspend Offline collection upon new=0A					command.=
=0A					Offline surface scan supported.=0A					Self-test supported.=0A					=
No Conveyance Self-test supported.=0A					Selective Self-test supported.=0A=
SMART capabilities:            (0x0003)	Saves SMART data before entering=0A=
					power-saving mode.=0A					Supports SMART auto save timer.=0AError logg=
ing capability:        (0x01)	Error logging supported.=0A					No General Pu=
rpose Logging support.=0AShort self-test routine =0Arecommended polling tim=
e: 	 (   2) minutes.=0AExtended self-test routine=0Arecommended polling tim=
e: 	 ( 106) minutes.=0A=0ASMART Attributes Data Structure revision number: =
16=0AVendor Specific SMART Attributes with Thresholds:=0AID# ATTRIBUTE_NAME=
          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VA=
LUE=0A  3 Spin_Up_Time            0x0027   191   181   063    Pre-fail  Alw=
ays       -       9686=0A  4 Start_Stop_Count        0x0032   253   253   0=
00    Old_age   Always       -       38=0A  5 Reallocated_Sector_Ct   0x003=
3   253   253   063    Pre-fail  Always       -       2=0A  6 Read_Channel_=
Margin     0x0001   253   253   100    Pre-fail  Offline      -       0=0A =
 7 Seek_Error_Rate         0x000a   253   252   000    Old_age   Always    =
   -       0=0A  8 Seek_Time_Performance   0x0027   250   243   187    Pre-=
fail  Always       -       42878=0A  9 Power_On_Minutes        0x0032   235=
   235   000    Old_age   Always       -       953h+07m=0A 10 Spin_Retry_Co=
unt        0x002b   253   252   157    Pre-fail  Always       -       0=0A =
11 Calibration_Retry_Count 0x002b   253   252   223    Pre-fail  Always    =
   -       0=0A 12 Power_Cycle_Count       0x0032   253   253   000    Old_=
age   Always       -       77=0A192 Power-Off_Retract_Count 0x0032   253   =
253   000    Old_age   Always       -       0=0A193 Load_Cycle_Count       =
 0x0032   253   253   000    Old_age   Always       -       0=0A194 Tempera=
ture_Celsius     0x0032   253   253   000    Old_age   Always       -      =
 13=0A195 Hardware_ECC_Recovered  0x000a   253   252   000    Old_age   Alw=
ays       -       886=0A196 Reallocated_Event_Count 0x0008   253   253   00=
0    Old_age   Offline      -       0=0A197 Current_Pending_Sector  0x0008 =
  253   253   000    Old_age   Offline      -       0=0A198 Offline_Uncorre=
ctable   0x0008   253   253   000    Old_age   Offline      -       0=0A199=
 UDMA_CRC_Error_Count    0x0008   199   199   000    Old_age   Offline     =
 -       0=0A200 Multi_Zone_Error_Rate   0x000a   253   252   000    Old_ag=
e   Always       -       0=0A201 Soft_Read_Error_Rate    0x000a   252   252=
   000    Old_age   Always       -       8900=0A202 TA_Increase_Count      =
 0x000a   252   252   000    Old_age   Always       -       0=0A203 Run_Out=
_Cancel          0x000b   252   252   180    Pre-fail  Always       -      =
 985=0A204 Shock_Count_Write_Opern 0x000a   252   252   000    Old_age   Al=
ways       -       0=0A205 Shock_Rate_Write_Opern  0x000a   252   252   000=
    Old_age   Always       -       0=0A207 Spin_High_Current       0x002a  =
 253   252   000    Old_age   Always       -       0=0A208 Spin_Buzz       =
        0x002a   253   252   000    Old_age   Always       -       0=0A209 =
Offline_Seek_Performnce 0x0024   198   193   000    Old_age   Offline      =
-       0=0A 99 Unknown_Attribute       0x0004   253   253   000    Old_age=
   Offline      -       0=0A100 Unknown_Attribute       0x0004   253   253 =
  000    Old_age   Offline      -       0=0A101 Unknown_Attribute       0x0=
004   253   253   000    Old_age   Offline      -       0=0A=0ASMART Error =
Log Version: 1=0ANo Errors Logged=0A=0ASMART Self-test log structure revisi=
on number 1=0ANo self-tests have been logged.  [To run self-tests, use: sma=
rtctl -t]=0A=0A=0ASMART Selective self-test log data structure revision num=
ber 1=0A SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS=0A    1        0      =
  0  Not_testing=0A    2        0        0  Not_testing=0A    3        0   =
     0  Not_testing=0A    4        0        0  Not_testing=0A    5        0=
        0  Not_testing=0ASelective self-test flags (0x0):=0A  After scannin=
g selected spans, do NOT read-scan remainder of disk.=0AIf Selective self-t=
est is pending on power-up, resume after 0 minute delay.=0A=0A
--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="smart.sdb"

smartctl version 5.36 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     ST3320620AS
Serial Number:    9RV02TPT
Firmware Version: 3.AAJ
User Capacity:    320,072,933,376 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   7
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Fri Feb 23 08:03:16 2007 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 ( 430) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 ( 115) minutes.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   105   099   006    Pre-fail  Always       -       0
  3 Spin_Up_Time            0x0003   098   097   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       6
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   072   060   030    Pre-fail  Always       -       20958701
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       180
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       34
187 Unknown_Attribute       0x0032   100   100   000    Old_age   Always       -       0
189 Unknown_Attribute       0x003a   100   100   000    Old_age   Always       -       0
190 Unknown_Attribute       0x0022   078   071   045    Old_age   Always       -       420872214
194 Temperature_Celsius     0x0022   022   040   000    Old_age   Always       -       22 (Lifetime Min/Max 0/21)
195 Hardware_ECC_Recovered  0x001a   070   060   000    Old_age   Always       -       6
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age   Offline      -       0
202 TA_Increase_Count       0x0032   100   253   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%       144         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.


--vGgW1X5XWziG23Ko--
