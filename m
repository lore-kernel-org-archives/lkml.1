Return-Path: <linux-kernel-owner+w=401wt.eu-S940279AbXGaB3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940279AbXGaB3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbXGaB2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:28:53 -0400
Received: from eastrmmtao101.cox.net ([68.230.240.7]:43897 "EHLO
	eastrmmtao101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbXGaB2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:28:50 -0400
Message-ID: <46AE8F64.8020605@cox.net>
Date: Mon, 30 Jul 2007 20:24:52 -0500
From: Benny Acosta <bacosta5@cox.net>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: smp incompatible Nvidia mcp61s mainboard chip set
Content-Type: multipart/mixed;
 boundary="------------020706000609040005020100"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020706000609040005020100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

When using a kernel that has smp support enabled the computer will 
randomly power down. It does not happen when using a non-smp kernel. 
There is also no problem when using M$ with this chip set. There are no 
error messages. It just shuts down. Because of this I'm unable to make 
full use of my dual core. Which of course sucks. ;-)

I attached a copy of my dmesg so you can see what hardware I'm using.

I'm using ide hard drives cause I'm too broke to buy up to date sata 
drives. I lost one of my drives because of the power downs. So now I'm 
broke with one less drive. :-(

Below is a request for help I sent to the board manufacturer. It's 
worthless to you except for the mother board information.
Can you help?


<http://www.ecs.com.tw/ECSWebSite/Support/TSSCaseDetail.aspx#> Contact 
Information

  	First Name

	Benny 	
  	Last Name

	Acosta
  	Your E-mail Address:

	SHILIVAN@YAHOO.COM <mailto:SHILIVAN@YAHOO.COM>


<http://www.ecs.com.tw/ECSWebSite/Support/TSSCaseDetail.aspx#> Product 
Information

  	Product Name

	GeForce6100SM-M 	
  	Model Version

	V1.0
  	Product Serial No

	0017214f59bc 	
  	BIOS Version

	
  	Purchased From

	
	
  	Purchased Date

	2007/06/29


<http://www.ecs.com.tw/ECSWebSite/Support/TSSCaseDetail.aspx#> 
Environment Information

  	CPU

	Athalon Dual Core x64
  	Memory

	2 GB
  	HDD

	IDE
  	External VGA Card

	Nvidia Quadro
  	Power Supply

	420 watts
  	Operation System

	Linux (Slackware)
  	Other PCI card / device

	IDE controller card


Detail Problem Description

  	Case ID

	07072110015
  	Problem Subject

	Incompatibility between mcp61s chipset and SMP Linux Kernel

* * * Please Print Page or Write Down Case ID for Your Records * * *

Q&A


	
	
ECS Support(USA) 	Posted : GMT 2007/07/23 18:16:03
Unfortunately, our support is limited to Microsoft windows based OS that 
does provide a support on the Linux base OS. You may contact Nvidia for 
the more information on the compatibility issue on the Nvidia chipset 
and your version of the Linux.
 

Benny Acosta 	Posted : GMT 2007/07/21 19:27:24
If the linux kernel is compiled with symmetric multiprocessing support, 
the computer will power down at random intervals. It runs quite well 
otherwise. But the problem with powering down means that I am unable to 
make full use of the dual core processor. If only one processor is being 
used ( non smp kernel), the mother board is fine. No power downs. With 
no error messages to reference, I have no way of knowing why the system 
would power down. It does not do this with windows. Is there some kind 
of patch available that would allow me to run a linux smp kernel. I 
don't want to replace my motherboard.




--------------020706000609040005020100
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

00% native mode on irq 10
    ide1: MMIO-DMA , BIOS settings: hdc:pio, hdd:pio
    ide2: MMIO-DMA , BIOS settings: hde:pio, hdf:pio
Probing IDE interface ide1...
Probing IDE interface ide2...
Probing IDE interface ide1...
Probing IDE interface ide2...
hda: max request size: 128KiB
hda: Host Protected Area detected.
	current capacity is 78125000 sectors (40000 MB)
	native  capacity is 78165360 sectors (40020 MB)
hda: Host Protected Area disabled.
hda: 78165360 sectors (40020 MB) w/2048KiB Cache, CHS=65535/16/63, UDMA(100)
hda: cache flushes not supported
 hda: hda1 hda2 < hda5 >
hdb: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
Loading iSCSI transport class v2.0-724.
iscsi: registered transport (tcp)
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver (1.1-5[2423]-mh3)
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
scsi: <fdomain> Detection failed (no card)
sym53c416.c: Version 1.0.0-ac
qlogicfas: no cards were found, please specify I/O address and IRQ using iobase= and irq= options<6>QLogic Fibre Channel HBA Driver
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.1.11
Copyright(c) 2004-2006 Emulex.  All rights reserved.
seagate: ST0x/TMC-8xx not detected.
Failed initialization of WD-7000 SCSI card!
DC390: clustering now enabled by default. If you get problems load
	with "disable_clustering=1" and report to maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.10-rc1 Wed Feb 14 10:14:25 PST 2007
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.008.
nsp32: loading...
ipr: IBM Power RAID SCSI Device Driver version: 2.3.1 (January 23, 2007)
RocketRAID 3xxx SATA Controller driver v1.0 (060426)
st: Version 20070203, fixed bufsize 32768, s/g segs 256
sata_nv 0000:00:08.0: version 3.3
ACPI: PCI Interrupt Link [LSID] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LSID] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:08.0 to 64
ata1: SATA max UDMA/133 cmd 0x000109f0 ctl 0x00010bf2 bmdma 0x0001dc00 irq 11
ata2: SATA max UDMA/133 cmd 0x00010970 ctl 0x00010b72 bmdma 0x0001dc08 irq 11
scsi2 : sata_nv
ata1: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0x000109f7
scsi3 : sata_nv
ata2: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0x00010977
I2O subsystem v1.325
i2o: max drivers = 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.04
Fusion MPT FC Host driver 3.04.04
Fusion MPT SAS Host driver 3.04.04
usbmon: debugfs is not available
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 5 (level, low) -> IRQ 5
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 5, io mem 0xfe02e000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
116x: driver isp116x-hcd, 03 Nov 2005
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUBA] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUBA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 11, io mem 0xfe02f000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v3.0
sl811: driver sl811-hcd, 19 May 2005
Initializing USB Mass Storage driver...
usb 2-1: new full speed USB device using ohci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
raid6: int32x1   1036 MB/s
raid6: int32x2   1041 MB/s
raid6: int32x4    849 MB/s
raid6: int32x8    629 MB/s
raid6: mmxx1     1959 MB/s
raid6: mmxx2     3637 MB/s
raid6: sse1x1    1945 MB/s
raid6: sse1x2    3232 MB/s
raid6: sse2x1    3277 MB/s
raid6: sse2x2    4536 MB/s
raid6: using algorithm sse2x2 (4536 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :  7355.000 MB/sec
raid5: using function: pIII_sse (7355.000 MB/sec)
md: multipath personality registered for level -4
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
input: AT Translated Set 2 keyboard as /class/input/input1
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
ReiserFS: hda1: found reiserfs format "3.6" with standard journal
ReiserFS: hda1: using ordered data mode
ReiserFS: hda1: journal params: device hda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hda1: checking transaction log (hda1)
ReiserFS: hda1: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 340k freed
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:05.0[B] -> Link [LAZA] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:05.0 to 64
usbcore: registered new interface driver snd-usb-audio
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 5
ACPI: PCI Interrupt 0000:01:05.0[A] -> Link [LNK1] -> GSI 5 (level, low) -> IRQ 5
eth0: RealTek RTL8139 at 0xcc00, 00:11:95:1e:d7:82, IRQ 5
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
Adding 996020k swap on /dev/hda5.  Priority:-1 extents:1 across:996020k
input: PC Speaker as /class/input/input2
input: ImPS/2 Generic Wheel Mouse as /class/input/input3
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
lp0: using parport0 (interrupt-driven).
lp0: console ready
Linux agpgart interface v0.102 (c) Dave Jones
Capability LSM initialized
Intel ISA PCIC probe: not found.
Databook TCIC-2 PCMCIA probe: not found.
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
ata1: hard resetting port
ata1: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0x000109f7
ata1: EH complete
ata1: hard resetting port
ata1: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0x000109f7
ata1: EH complete
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0x00010977
ata2: EH complete
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0x00010977
ata2: EH complete
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
eth0: no IPv6 routers present
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt Link [LNK8] enabled at IRQ 11
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNK8] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:02:00.0 to 64
NVRM: loading NVIDIA UNIX x86 Kernel Module  100.14.09  Sat May 26 00:47:07 PDT 2007
PCI: Setting latency timer of device 0000:02:00.0 to 64
NVRM: loading NVIDIA UNIX x86 Kernel Module  100.14.09  Sat May 26 00:47:07 PDT 2007
ReiserFS: warning: is_leaf: free space seems wrong: level=1, nr_items=83, free_space=65336 rdkey 
ReiserFS: hda1: warning: vs-5150: search_by_key: invalid format found in block 7157756. Fsck?
ReiserFS: hda1: warning: vs-13070: reiserfs_read_locked_inode: i/o failure occurred trying to find stat data of [254462 254467 0x0 SD]
ReiserFS: warning: is_leaf: free space seems wrong: level=1, nr_items=83, free_space=65336 rdkey 
ReiserFS: hda1: warning: vs-5150: search_by_key: invalid format found in block 7157756. Fsck?
ReiserFS: hda1: warning: vs-13070: reiserfs_read_locked_inode: i/o failure occurred trying to find stat data of [254462 254467 0x0 SD]
ISO 9660 Extensions: Microsoft Joliet Level 3
ISOFS: changing to secondary root
ISO 9660 Extensions: Microsoft Joliet Level 3
ISOFS: changing to secondary root
UDF-fs: Partition marked readonly; forcing readonly mount
UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'Shilivan2', timestamp 2005/04/18 00:23 (1ed4)
hdb: media error (bad sector): status=0x51 { DriveReady SeekComplete Error }
hdb: media error (bad sector): error=0x30 { LastFailedSense=0x03 }
ide: failed opcode was: unknown
ATAPI device hdb:
  Error: Medium error -- (Sense key=0x03)
  Unrecovered read error -- (asc=0x11, ascq=0x00)
  The failed "Read 10" packet command was: 
  "28 00 00 22 ae 20 00 00 02 00 00 00 00 00 00 00 "
end_request: I/O error, dev hdb, sector 9091200
Buffer I/O error on device hdb, logical block 1136400
hdb: media error (bad sector): status=0x51 { DriveReady SeekComplete Error }
hdb: media error (bad sector): error=0x30 { LastFailedSense=0x03 }
ide: failed opcode was: unknown
ATAPI device hdb:
  Error: Medium error -- (Sense key=0x03)
  Unrecovered read error -- (asc=0x11, ascq=0x00)
  The failed "Read 10" packet command was: 
  "28 00 00 22 ae 20 00 00 02 00 00 00 00 00 00 00 "
end_request: I/O error, dev hdb, sector 9091200
Buffer I/O error on device hdb, logical block 1136400
ISO 9660 Extensions: Microsoft Joliet Level 3
ISOFS: changing to secondary root
hdb: media error (bad sector): status=0x51 { DriveReady SeekComplete Error }
hdb: media error (bad sector): error=0x30 { LastFailedSense=0x03 }
ide: failed opcode was: unknown
ATAPI device hdb:
  Error: Medium error -- (Sense key=0x03)
  Unrecovered read error -- (asc=0x11, ascq=0x00)
  The failed "Read 10" packet command was: 
  "28 00 00 1c 31 ae 00 00 0f 00 00 00 00 00 00 00 "
end_request: I/O error, dev hdb, sector 7390904
Buffer I/O error on device hdb, logical block 1847726
Buffer I/O error on device hdb, logical block 1847727
Buffer I/O error on device hdb, logical block 1847728
Buffer I/O error on device hdb, logical block 1847729
Buffer I/O error on device hdb, logical block 1847730
Buffer I/O error on device hdb, logical block 1847731
Buffer I/O error on device hdb, logical block 1847732
Buffer I/O error on device hdb, logical block 1847733
Buffer I/O error on device hdb, logical block 1847734
Buffer I/O error on device hdb, logical block 1847735
hdb: media error (bad sector): status=0x51 { DriveReady SeekComplete Error }
hdb: media error (bad sector): error=0x30 { LastFailedSense=0x03 }
ide: failed opcode was: unknown
ATAPI device hdb:
  Error: Medium error -- (Sense key=0x03)
  Unrecovered read error -- (asc=0x11, ascq=0x00)
  The failed "Read 10" packet command was: 
  "28 00 00 1c 31 bd 00 00 20 00 00 00 00 00 00 00 "
end_request: I/O error, dev hdb, sector 7390964
hdb: media error (bad sector): status=0x51 { DriveReady SeekComplete Error }
hdb: media error (bad sector): error=0x30 { LastFailedSense=0x03 }
ide: failed opcode was: unknown
ATAPI device hdb:
  Error: Medium error -- (Sense key=0x03)
  Unrecovered read error -- (asc=0x11, ascq=0x00)
  The failed "Read 10" packet command was: 
  "28 00 00 1c 34 bd 00 00 04 00 00 00 00 00 00 00 "
end_request: I/O error, dev hdb, sector 7394036
ISO 9660 Extensions: Microsoft Joliet Level 3
ISOFS: changing to secondary root
hdb: tray open
end_request: I/O error, dev hdb, sector 64
printk: 41 messages suppressed.
Buffer I/O error on device hdb, logical block 8
hdb: tray open
end_request: I/O error, dev hdb, sector 64
Buffer I/O error on device hdb, logical block 8
hdb: tray open
end_request: I/O error, dev hdb, sector 64
Buffer I/O error on device hdb, logical block 8
hdb: tray open
end_request: I/O error, dev hdb, sector 64
Buffer I/O error on device hdb, logical block 8
UDF-fs: Partition marked readonly; forcing readonly mount
UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'Carmen', timestamp 2005/04/18 02:30 (1ed4)
ReiserFS: warning: is_leaf: free space seems wrong: level=1, nr_items=83, free_space=65336 rdkey 
ReiserFS: hda1: warning: vs-5150: search_by_key: invalid format found in block 7157756. Fsck?
ReiserFS: hda1: warning: vs-13070: reiserfs_read_locked_inode: i/o failure occurred trying to find stat data of [254462 254467 0x0 SD]
atkbd.c: Unknown key pressed (translated set 2, code 0x96 on isa0060/serio0).
atkbd.c: Use 'setkeycodes e016 <keycode>' to make it known.
atkbd.c: Unknown key released (translated set 2, code 0x96 on isa0060/serio0).
atkbd.c: Use 'setkeycodes e016 <keycode>' to make it known.
ReiserFS: warning: is_leaf: free space seems wrong: level=1, nr_items=83, free_space=65336 rdkey 
ReiserFS: hda1: warning: vs-5150: search_by_key: invalid format found in block 7157756. Fsck?
ReiserFS: hda1: warning: vs-13070: reiserfs_read_locked_inode: i/o failure occurred trying to find stat data of [254462 254467 0x0 SD]
ReiserFS: warning: is_leaf: free space seems wrong: level=1, nr_items=83, free_space=65336 rdkey 
ReiserFS: hda1: warning: vs-5150: search_by_key: invalid format found in block 7157756. Fsck?
ReiserFS: hda1: warning: vs-13070: reiserfs_read_locked_inode: i/o failure occurred trying to find stat data of [254462 254467 0x0 SD]
usb 2-3: new full speed USB device using ohci_hcd and address 3
usb 2-3: configuration #1 chosen from 1 choice
scsi4 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 3 if 1 alt 0 proto 2 vid 0x03F0 pid 0x3B11
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
scsi 4:0:0:0: Direct-Access     HP                        1.00 PQ: 0 ANSI: 2
sd 4:0:0:0: Attached scsi removable disk sda
sd 4:0:0:0: Attached scsi generic sg0 type 0
usb-storage: device scan complete
drivers/usb/class/usblp.c: usblp0: removed

--------------020706000609040005020100--
