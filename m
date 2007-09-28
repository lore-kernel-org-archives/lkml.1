Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbXI1O6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbXI1O6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbXI1O6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:58:17 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:42521 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753790AbXI1O6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:58:15 -0400
Message-ID: <46FD1670.5070109@idlum.be>
Date: Fri, 28 Sep 2007 16:57:52 +0200
From: Pierre-Yves Paulus <py@idlum.be>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       BlueZ development <bluez-devel@lists.sourceforge.net>
Subject: Re: Warnings and Oops on 2.6.23-rc6 while activily using rfcomm links
 (mm/slab.c)
References: <46F92364.3080603@idlum.be>	<46F952BD.4010009@redhat.com>	<46FA5E2E.3010300@idlum.be>	<20070927085658.1c66f1c8@gondolin.boeblingen.de.ibm.com>	<46FBC1AE.4020404@idlum.be>	<46FBF17A.6030009@idlum.be> <20070928085438.4eb5a38f@gondolin.boeblingen.de.ibm.com> <46FD1200.9020407@idlum.be>
In-Reply-To: <46FD1200.9020407@idlum.be>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 87.67.141.16 (16.141-67-87.adsl-dyn.isp.belgacom.be)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> I applied it, and re-tested without enabling slub debugging this time. I 
> got one Oops so far, but it seems it didn't hit your patch's log 
> statement. Testing is going on...

Another one, still not hitting it. After the first Oops happened, I 
issued a reboot command, but it hung with a second Oops (see the very 
bottom). At that point I had to hard-reset the box.


Linux version 2.6.23-rc8 (root@debian) (gcc version 4.1.2 20061115 
(prerelease) (Debian 4.1.1-21)) #1 Fri Sep 28 17:12:14 CEST 2007
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000000f7b0000 (usable)
  BIOS-e820: 000000000f7b0000 - 000000000f7b3000 (ACPI NVS)
  BIOS-e820: 000000000f7b3000 - 000000000f7c0000 (ACPI data)
  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
247MB LOWMEM available.
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->    63408
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
     0:        0 ->    63408
DMI 2.2 present.
ACPI: RSDP 000F63C0, 0014 (r0 AMDGX3)
ACPI: RSDT 0F7B3040, 0028 (r1 AMDGX3 AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 0F7B30C0, 0074 (r1 AMDGX3 AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 0F7B3180, 35BD (r1 AMDGX3 AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 0F7B0000, 0040
ACPI: PM-Timer IO Port: 0x9c10
Allocating PCI resources starting at 10000000 (gap: 0f7c0000:f0830000)
swsusp: Registered nosave memory region: 000000000009e000 - 000000000009f000
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
Built 1 zonelists in Zone order.  Total pages: 62913
Kernel command line: root=UUID=c925de24-972b-437c-860f-8109d900aa4b ro 
panic=60 console=ttyS1,38400 console=tty0
No local APIC present or hardware disabled
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 4096 bytes)
Detected 498.063 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS1] enabled
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 243152k/253632k available (1707k kernel code, 9908k reserved, 
679k data, 312k init, 0k highmem)
virtual kernel memory layout:
     fixmap  : 0xfffb3000 - 0xfffff000   ( 304 kB)
     vmalloc : 0xd0000000 - 0xfffb1000   ( 767 MB)
     lowmem  : 0xc0000000 - 0xcf7b0000   ( 247 MB)
       .init : 0xc0358000 - 0xc03a6000   ( 312 kB)
       .data : 0xc02aac35 - 0xc0354aa4   ( 679 kB)
       .text : 0xc0100000 - 0xc02aac35   (1707 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 997.66 BogoMIPS 
(lpj=1995333)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)
CPU: L2 Cache: 128K (32 bytes/line)
Compat vDSO mapped to ffffe000.
CPU: AMD Geode(TM) Integrated Processor by AMD PCS stepping 02
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0c00)
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfa740, last bus=0
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 11) *0
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 11) *0
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
NET: Registered protocol family 8
NET: Registered protocol family 20
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
pnp: 00:00: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:00: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
checking if image is initramfs...<6>Switched to high resolution mode on 
CPU 0
  it is
Freeing initrd memory: 4718k freed
audit: initializing netlink socket (disabled)
audit(1190989970.245:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0b: ttyS2 at I/O 0x3e8 (irq = 5) is a 16550A
00:0c: ttyS3 at I/O 0x2e8 (irq = 5) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 1
Cannot allocate resource for EISA slot 6
EISA: Detected 0 cards.
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 312k freed
SCSI subsystem initialized
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LNKC] BIOS reported IRQ 0, using IRQ 11
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKC] -> GSI 11 (level, 
low) -> IRQ 11
eth0: RealTek RTL8139 at 0xf200, 00:04:5f:85:78:91, IRQ 11
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LNKB] -> GSI 11 (level, 
low) -> IRQ 11
eth1: RealTek RTL8139 at 0xf600, 00:04:5f:85:78:92, IRQ 11
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
ACPI: PCI Interrupt Link [LNKD] BIOS reported IRQ 0, using IRQ 10
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 10 (level, 
low) -> IRQ 10
sata_via 0000:00:0a.0: routed to hard irq line 11
usbcore: registered new device driver usb
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
scsi0 : sata_via
scsi1 : sata_via
scsi2 : sata_via
ata1: SATA max UDMA/133 cmd 0x0001ff00 ctl 0x0001ff0a bmdma 0x0001fb00 
irq 10
ata2: SATA max UDMA/133 cmd 0x0001fe00 ctl 0x0001fe0a bmdma 0x0001fb08 
irq 10
ata3: PATA max UDMA/133 cmd 0x0001fd00 ctl 0x0001fd0a bmdma 0x0001fb10 
irq 10
ata1: SATA link down (SStatus 0 SControl 310)
ata2: SATA link down (SStatus 0 SControl 310)
AMD5536: IDE controller at PCI slot 0000:00:0f.2
AMD5536: chipset revision 1
AMD5536: not 100% native mode: will probe irqs later
AMD5536: 0000:00:0f.2 (rev 01) UDMA100 controller
     ide0: BM-DMA at 0xfa00-0xfa07, BIOS settings: hda:DMA, hdb:pio
hda: PQI IDE DiskOnModule, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ACPI: PCI Interrupt 0000:00:0f.4[D] -> Link [LNKD] -> GSI 10 (level, 
low) -> IRQ 10
ohci_hcd 0000:00:0f.4: OHCI Host Controller
ohci_hcd 0000:00:0f.4: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:0f.4: irq 10, io mem 0xefffd000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
hda: max request size: 128KiB
hda: 4062240 sectors (2079 MB) w/0KiB Cache, CHS=4030/16/63, UDMA(33)
  hda: hda1 hda2 < hda5 hda6 >
usb 1-1: new full speed USB device using ohci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 7 ports detected
ReiserFS: hda6: found reiserfs format "3.6" with standard journal
ReiserFS: hda6: using ordered data mode
ReiserFS: hda6: journal params: device hda6, size 8192, journal first 
block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
ReiserFS: hda6: checking transaction log (hda6)
usb 1-1.4: new full speed USB device using ohci_hcd and address 3
usb 1-1.4: configuration #1 chosen from 1 choice
hub 1-1.4:1.0: USB hub found
hub 1-1.4:1.0: 3 ports detected
usb 1-1.5: new full speed USB device using ohci_hcd and address 4
usb 1-1.5: configuration #1 chosen from 1 choice
hub 1-1.5:1.0: USB hub found
hub 1-1.5:1.0: 3 ports detected
usb 1-1.2: new full speed USB device using ohci_hcd and address 5
usb 1-1.2: configuration #1 chosen from 1 choice
usb 1-1.4.2: new full speed USB device using ohci_hcd and address 6
usb 1-1.4.2: configuration #1 chosen from 1 choice
usb 1-1.4.3: new full speed USB device using ohci_hcd and address 7
usb 1-1.4.3: configuration #1 chosen from 1 choice
usb 1-1.5.2: new full speed USB device using ohci_hcd and address 8
usb 1-1.5.2: configuration #1 chosen from 1 choice
usb 1-1.5.3: new full speed USB device using ohci_hcd and address 9
usb 1-1.5.3: configuration #1 chosen from 1 choice
usb 1-1.4.1: new full speed USB device using ohci_hcd and address 10
usb 1-1.4.1: configuration #1 chosen from 1 choice
usb 1-1.5.1: new full speed USB device using ohci_hcd and address 11
usb 1-1.5.1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: HID 0a5c:4502 as /class/input/input0
input: USB HID v1.11 Keyboard [HID 0a5c:4502] on usb-0000:00:0f.4-1.4.2
input: HID 0a5c:4503 as /class/input/input1
input: USB HID v1.11 Mouse [HID 0a5c:4503] on usb-0000:00:0f.4-1.4.3
input: HID 0a5c:4502 as /class/input/input2
input: USB HID v1.11 Keyboard [HID 0a5c:4502] on usb-0000:00:0f.4-1.5.2
input: HID 0a5c:4503 as /class/input/input3
input: USB HID v1.11 Mouse [HID 0a5c:4503] on usb-0000:00:0f.4-1.5.3
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
ReiserFS: hda6: replayed 144 transactions in 35 seconds
ReiserFS: hda6: Using r5 hash to sort names
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:01.2[A] -> Link [LNKA] -> GSI 10 (level, 
low) -> IRQ 10
geode-aes: GEODE AES engine enabled.
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
AMD Geode RNG detected
ACPI: PCI Interrupt 0000:00:0f.3[B] -> Link [LNKB] -> GSI 11 (level, 
low) -> IRQ 11
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input5
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [SLPB]
ACPI: AC Adapter [AC] (on-line)
Real Time Clock Driver v1.12ac
input: PC Speaker as /class/input/input7
FDC 0 is a post-1991 82077
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
Adding 264560k swap on /dev/hda5.  Priority:-1 extents:1 across:264560k
ReiserFS: hda6: Removing [28831 10644 0x0 SD]..done
ReiserFS: hda6: There were 1 uncompleted unlinks/truncates. Completed
loop: module loaded
Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 
sec (nowayout= 0)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
eth0: link down
eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
kobject l2cap: registering. parent: <NULL>, set: module
kobject holders: registering. parent: l2cap, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
kobject_uevent_env
fill_kobj_path: path = '/module/l2cap'
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
DEV: registering device: ID = 'acl0017B066F14B'
kobject acl0017B066F14B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0017B066F14B
bus bluetooth: add device acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'acl0016202CBF0B'
kobject acl0016202CBF0B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0016202CBF0B
bus bluetooth: add device acl0016202CBF0B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0016202CBF0B'
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
bus bluetooth: remove device acl0017B066F14B
PM: Removing info for bluetooth:acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
kobject acl0017B066F14B: cleaning up
kobject rfcomm: registering. parent: <NULL>, set: module
kobject holders: registering. parent: rfcomm, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
kobject_uevent_env
fill_kobj_path: path = '/module/rfcomm'
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
bus bluetooth: remove device acl0016202CBF0B
PM: Removing info for bluetooth:acl0016202CBF0B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0016202CBF0B'
kobject acl0016202CBF0B: cleaning up
DEV: registering device: ID = 'acl0016202CBF0B'
kobject acl0016202CBF0B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0016202CBF0B
bus bluetooth: add device acl0016202CBF0B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0016202CBF0B'
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
bus bluetooth: remove device acl0016202CBF0B
PM: Removing info for bluetooth:acl0016202CBF0B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0016202CBF0B'
kobject acl0016202CBF0B: cleaning up
DEV: registering device: ID = 'acl0016202CBF0B'
kobject acl0016202CBF0B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0016202CBF0B
bus bluetooth: add device acl0016202CBF0B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0016202CBF0B'
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'acl0017B066F14B'
kobject acl0017B066F14B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0017B066F14B
bus bluetooth: add device acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00126253F906'
bus bluetooth: remove device acl00126253F906
PM: Removing info for bluetooth:acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00126253F906'
kobject acl00126253F906: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'rfcomm0'
kobject rfcomm0: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEVICE: moving 'rfcomm0' to 'acl000AD9D7A99A'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
bus bluetooth: remove device acl0017B066F14B
PM: Removing info for bluetooth:acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
kobject acl0017B066F14B: cleaning up
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEVICE: moving 'rfcomm0' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: Unregistering device. ID = 'rfcomm0'
PM: Removing info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject rfcomm0: cleaning up
device_create_release called for rfcomm0
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00126253F906'
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
DEV: registering device: ID = 'acl00E0033364E5'
kobject acl00E0033364E5: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl00E0033364E5
bus bluetooth: add device acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
bus bluetooth: remove device acl00E0033364E5
PM: Removing info for bluetooth:acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
kobject acl00E0033364E5: cleaning up
DEV: registering device: ID = 'acl0017B066F14B'
kobject acl0017B066F14B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0017B066F14B
bus bluetooth: add device acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
DEV: registering device: ID = 'acl00E0033364E5'
kobject acl00E0033364E5: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl00E0033364E5
bus bluetooth: add device acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
DEV: registering device: ID = 'rfcomm0'
kobject rfcomm0: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEVICE: moving 'rfcomm0' to 'acl00126253F906'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEV: registering device: ID = 'rfcomm1'
kobject rfcomm1: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm1
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
DEVICE: moving 'rfcomm1' to 'acl0017B066F14B'
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'rfcomm2'
kobject rfcomm2: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm2
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
DEVICE: moving 'rfcomm2' to 'acl00E0033364E5'
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'rfcomm3'
kobject rfcomm3: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm3
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
DEVICE: moving 'rfcomm3' to 'acl000AD9D7A99A'
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0060574FEB37'
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
DEV: registering device: ID = 'rfcomm4'
kobject rfcomm4: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm4
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
DEVICE: moving 'rfcomm4' to 'acl0060574FEB37'
fill_kobj_path: path = '/class/tty/rfcomm4'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
bus bluetooth: remove device acl0017B066F14B
PM: Removing info for bluetooth:acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
DEV: registering device: ID = 'rfcomm5'
kobject rfcomm5: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm5
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm5'
DEVICE: moving 'rfcomm5' to 'acl006057BB4D92'
fill_kobj_path: path = '/class/tty/rfcomm5'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm5'
DEVICE: moving 'rfcomm1' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
kobject acl0017B066F14B: cleaning up
DEV: Unregistering device. ID = 'rfcomm1'
PM: Removing info for No Bus:rfcomm1
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject rfcomm1: cleaning up
device_create_release called for rfcomm1
bus bluetooth: remove device acl00E0033364E5
PM: Removing info for bluetooth:acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
DEV: Unregistering device. ID = 'rfcomm0'
PM: Removing info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00126253F906'
kobject rfcomm0: cleaning up
device_create_release called for rfcomm0
WARNING: at lib/kref.c:33 kref_get()
  [<c01c6db7>] kref_get+0x34/0x3d
  [<c01c61a9>] kobject_get+0xf/0x13
  [<c022578d>] get_device+0xe/0x14
  [<c02257a6>] device_move+0x13/0x114
  [<d02fbb7c>] rfcomm_tty_close+0x23/0x61 [rfcomm]
  [<c020f88d>] release_dev+0x1c0/0x54e
  [<d02fb0e5>] rfcomm_dev_destruct+0x59/0x65 [rfcomm]
  [<d02fb725>] rfcomm_dev_ioctl+0x329/0x4d0 [rfcomm]
  [<c0248124>] release_sock+0xc/0x74
  [<c020fc22>] tty_release+0x7/0xa
  [<c015dabd>] __fput+0x93/0x147
  [<c015b66a>] filp_close+0x51/0x58
  [<c02a8b0e>] __sched_text_start+0x1d6/0x245
  [<c015c70b>] sys_close+0x54/0x83
  [<c0103c72>] syscall_call+0x7/0xb
  =======================
DEVICE: moving 'rfcomm0' to '<NULL>'
kobject <NULL>: cleaning up
device_create_release called for rfcomm0
DEVICE: moving 'rfcomm2' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
kobject acl00E0033364E5: cleaning up
DEV: Unregistering device. ID = 'rfcomm2'
PM: Removing info for No Bus:rfcomm2
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject rfcomm2: cleaning up
device_create_release called for rfcomm2
BUG: unable to handle kernel NULL pointer dereference at virtual address 
00000004
  printing eip:
c012797e
*pde = 00000000
Oops: 0002 [#1]
Modules linked in: rfcomm l2cap battery ipv6 dm_snapshot dm_mirror 
dm_mod softdog loop parport_pc parport floppy pcspkr rtc psmouse ac 
serio_raw button snd_cs5535audio snd_ac97_codec ac97_bus snd_pcm 
snd_timer snd soundcore snd_page_alloc geode_rng cs5535_gpio hci_usb 
bluetooth geode_aes blkcipher tsdev evdev usbhid hid reiserfs ide_disk 
generic amd74xx ide_core ohci_hcd sata_via ata_generic 8139cp libata 
usbcore 8139too mii scsi_mod thermal processor fan
CPU:    0
EIP:    0060:[<c012797e>]    Not tainted VLI
EFLAGS: 00010083   (2.6.23-rc8 #1)
EIP is at run_workqueue+0x52/0x103
eax: 00000000   ebx: cf7ab680   ecx: c3b45aac   edx: 00000000
esi: c3b45aa8   edi: 00000000   ebp: 00000000   esp: c124ff9c
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process events/0 (pid: 5, ti=c124e000 task=c1243500 task.ti=c124e000)
Stack: c124ffb4 00000046 c1243500 cf7ab680 cf7ab680 c0127ffe c124ffd0 
c01280b0
        00000000 c1243500 c012a510 c124ffc8 c124ffc8 cf7ab680 00000000 
c012a363
        c012a32d 00000000 c0104e17 c1245f24 00000000 00000000 00000000 
00000000
Call Trace:
  [<c0127ffe>] worker_thread+0x0/0xbe
  [<c01280b0>] worker_thread+0xb2/0xbe
  [<c012a510>] autoremove_wake_function+0x0/0x35
  [<c012a363>] kthread+0x36/0x5b
  [<c012a32d>] kthread+0x0/0x5b
  [<c0104e17>] kernel_thread_helper+0x7/0x10
  =======================
Code: 44 24 04 f5 06 2b c0 c7 04 24 61 50 2f c0 e8 b2 4c ff ff e8 58 e2 
fd ff e9 a1 00 00 00 8d 71 fc 8b 7e 0c 89 73 10 8b 11 8b 41 04 <89> 42 
04 89 10 89 49 04 89 09 fb 90 8d b4 26 00 00 00 00 90 8b
EIP: [<c012797e>] run_workqueue+0x52/0x103 SS:ESP 0068:c124ff9c
DEV: Unregistering device. ID = 'rfcomm3'
BUG: unable to handle kernel paging request at virtual address 20475542
  printing eip:
20475542
*pde = 00000000
Oops: 0000 [#2]
Modules linked in: rfcomm l2cap battery ipv6 dm_snapshot dm_mirror 
dm_mod softdog loop parport_pc parport floppy pcspkr rtc psmouse ac 
serio_raw button snd_cs5535audio snd_ac97_codec ac97_bus snd_pcm 
snd_timer snd soundcore snd_page_alloc geode_rng cs5535_gpio hci_usb 
bluetooth geode_aes blkcipher tsdev evdev usbhid hid reiserfs ide_disk 
generic amd74xx ide_core ohci_hcd sata_via ata_generic 8139cp libata 
usbcore 8139too mii scsi_mod thermal processor fan
CPU:    0
EIP:    0060:[<20475542>]    Tainted: G      D VLI
EFLAGS: 00010206   (2.6.23-rc8 #1)
EIP is at 0x20475542
eax: c674f210   ebx: c674f210   ecx: 00000001   edx: 00000001
esi: 20475542   edi: 400452c9   ebp: c3b45ab8   esp: cd6a5ecc
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process hcid (pid: 3236, ti=cd6a4000 task=c9c2cfc0 task.ti=cd6a4000)
Stack: c02a8454 c674f200 c6064980 c0225c30 c674f200 c6064980 400452c9 
ce413000
        c0225e6c c030b23a c674f2a4 c6064a00 d02fb0d6 c6064980 bff65ff8 
d02fb725
        00000282 00000206 c9c2cfc0 cf4fe000 00000003 00000000 00000000 
00000000
Call Trace:
  [<c02a8454>] klist_del+0x1c/0x1f
  [<c0225c30>] device_del+0x15/0x22e
  [<c0225e6c>] device_unregister+0x23/0x2d
  [<d02fb0d6>] rfcomm_dev_destruct+0x4a/0x65 [rfcomm]
  [<d02fb725>] rfcomm_dev_ioctl+0x329/0x4d0 [rfcomm]
  [<d02fa24e>] rfcomm_sock_ioctl+0x1e/0x2d [rfcomm]
  [<c0245fb0>] sock_ioctl+0x19f/0x1be
  [<c0245e11>] sock_ioctl+0x0/0x1be
  [<c0166445>] do_ioctl+0x19/0x4c
  [<c0166665>] vfs_ioctl+0x1ed/0x204
  [<c01666c8>] sys_ioctl+0x4c/0x64
  [<c0103c72>] syscall_call+0x7/0xb
  =======================
Code:  Bad EIP value.
EIP: [<20475542>] 0x20475542 SS:ESP 0068:cd6a5ecc
kobject <NULL>: cleaning up
DEV: Unregistering device. ID = 'vcs3'
PM: Removing info for No Bus:vcs3
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcs3'
kobject vcs3: cleaning up
device_create_release called for vcs3
DEV: Unregistering device. ID = 'vcsa3'
PM: Removing info for No Bus:vcsa3
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcsa3'
kobject vcsa3: cleaning up
device_create_release called for vcsa3
DEV: Unregistering device. ID = 'vcs4'
PM: Removing info for No Bus:vcs4
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcs4'
kobject vcs4: cleaning up
device_create_release called for vcs4
DEV: Unregistering device. ID = 'vcsa4'
PM: Removing info for No Bus:vcsa4
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcsa4'
kobject vcsa4: cleaning up
device_create_release called for vcsa4
DEV: Unregistering device. ID = 'vcs5'
PM: Removing info for No Bus:vcs5
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcs5'
kobject vcs5: cleaning up
device_create_release called for vcs5
DEV: Unregistering device. ID = 'vcsa5'
PM: Removing info for No Bus:vcsa5
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcsa5'
kobject vcsa5: cleaning up
device_create_release called for vcsa5
DEV: Unregistering device. ID = 'vcs2'
PM: Removing info for No Bus:vcs2
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcs2'
kobject vcs2: cleaning up
device_create_release called for vcs2
DEV: Unregistering device. ID = 'vcsa2'
PM: Removing info for No Bus:vcsa2
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcsa2'
kobject vcsa2: cleaning up
device_create_release called for vcsa2
DEV: Unregistering device. ID = 'vcs1'
PM: Removing info for No Bus:vcs1
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcs1'
kobject vcs1: cleaning up
device_create_release called for vcs1
DEV: Unregistering device. ID = 'vcsa1'
PM: Removing info for No Bus:vcsa1
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcsa1'
kobject vcsa1: cleaning up
device_create_release called for vcsa1
DEV: Unregistering device. ID = 'vcs6'
PM: Removing info for No Bus:vcs6
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcs6'
kobject vcs6: cleaning up
device_create_release called for vcs6
DEV: Unregistering device. ID = 'vcsa6'
PM: Removing info for No Bus:vcsa6
kobject_uevent_env
fill_kobj_path: path = '/class/vc/vcsa6'
kobject vcsa6: cleaning up
device_create_release called for vcsa6
BUG: unable to handle kernel NULL pointer dereference at virtual address 
00000004
  printing eip:
c022a3a4
*pde = 00000000
Oops: 0000 [#3]
Modules linked in: rfcomm l2cap battery ipv6 dm_snapshot dm_mirror 
dm_mod softdog loop parport_pc parport floppy pcspkr rtc psmouse ac 
serio_raw button snd_cs5535audio snd_ac97_codec ac97_bus snd_pcm 
snd_timer snd soundcore snd_page_alloc geode_rng cs5535_gpio hci_usb 
bluetooth geode_aes blkcipher tsdev evdev usbhid hid reiserfs ide_disk 
generic amd74xx ide_core ohci_hcd sata_via ata_generic 8139cp libata 
usbcore 8139too mii scsi_mod thermal processor fan
CPU:    0
EIP:    0060:[<c022a3a4>]    Tainted: G      D VLI
EFLAGS: 00010246   (2.6.23-rc8 #1)
EIP is at device_shutdown+0xa4/0xc4
eax: 00000000   ebx: ffffff7c   ecx: 00000000   edx: ffffffff
esi: ffffff7c   edi: b7f08ff4   ebp: cea54000   esp: cea55e7c
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process reboot (pid: 5316, ti=cea54000 task=c9522a80 task.ti=cea54000)
Stack: b7f08ff4 cea54000 c012557d 00000000 28121969 c012589b c01259a3 
b7e97cf0
        c0121510 01234567 c0125b08 a5087615 0000010c 00000000 000000bc 
b7e97000
        c1025ac0 00000200 00000000 c3b67a5c b7e97cf0 c9522a80 c014d18f 
c3b67a5c
Call Trace:
  [<c012557d>] blocking_notifier_call_chain+0x17/0x1a
  [<c012589b>] kernel_restart_prepare+0x20/0x25
  [<c01259a3>] kernel_restart+0xb/0x37
  [<c0121510>] __capable+0xc/0x1f
  [<c0125b08>] sys_reboot+0x132/0x178
  [<c014d18f>] handle_mm_fault+0x2eb/0x60c
  [<c028a710>] inet_gifconf+0x0/0x92
  [<c028c5a6>] inet_sock_destruct+0x16a/0x1b0
  [<c0248201>] lock_sock_nested+0x75/0x7c
  [<c016be8c>] destroy_inode+0x32/0x41
  [<c016a2e7>] d_kill+0x37/0x47
  [<c016a30c>] dput+0x15/0xcb
  [<c015db47>] __fput+0x11d/0x147
  [<c016dcd0>] mntput_no_expire+0x11/0x59
  [<c015b66a>] filp_close+0x51/0x58
  [<c015c70b>] sys_close+0x54/0x83
  [<c0103c72>] syscall_call+0x7/0xb
  =======================
Code: ff 8d 93 a4 00 00 00 89 54 24 08 89 44 24 04 c7 04 24 67 b9 30 c0 
e8 84 22 ef ff 8b 93 d4 00 00 00 89 d8 ff 92 84 00 00 00 89 f3 <8b> b6 
88 00 00 00 81 ee 84 00 00 00 81 fb 80 39 34 c0 0f 85 60
EIP: [<c022a3a4>] device_shutdown+0xa4/0xc4 SS:ESP 0068:cea55e7c


Best Regards,
Py
