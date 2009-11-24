Return-Path: <linux-kernel-owner+w=401wt.eu-S932497AbZKXJcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbZKXJcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbZKXJcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:32:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35511 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429AbZKXJcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:32:07 -0500
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Date: Tue, 24 Nov 2009 10:32:29 +0100
User-Agent: KMail/1.9.9
Cc: Otavio Salvador <otavio@ossystems.com.br>
References: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com>
In-Reply-To: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tg6CLmSpgCbgNhQ"
Message-Id: <200911241032.29820.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: Vortex86SX: only works with irqpoll
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_tg6CLmSpgCbgNhQ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Donnerstag, 19. November 2009, Otavio Salvador wrote:
> I got this machine working booting it with "irqpoll" parameter however
> it drops the performance a lot and I'd like to try to fix the root
> problem of it.
>
> Without 'irqpoll' the disk and network adaptor doesn't work.

What kernel revision do you are using?

We are using a Vortex86DX here and it works as expected. But I do not know the 
differences in the SoCs of Vortex86SX and Vortex86DX (okay, SX lacks the 
floating point unit). Find our dmesg output attached. Maybe it could help.

jbe

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | Phone: +49-8766-939 228     |
Vertretung Sued/Muenchen, Germany             | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686              | http://www.pengutronix.de/  |

--Boundary-00=_tg6CLmSpgCbgNhQ
Content-Type: text/plain;
  charset="iso-8859-1";
  name="Vortex86DX.dmsg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="Vortex86DX.dmsg"

Linux version 2.6.31.2 (mol@octopus) (gcc version 4.3.2 (OSELAS.Toolchain-1.99.3) ) #1 PREEMPT Wed Nov 11 23:54:42 CET 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMDs ext2fs, partition type 0x83
  NSC Geode by NSCage root=/dev/sda1 console=ttyS0,115200 vga=0x312 rootwait
  Cyrix CyrixInsteadetup=0x3000, size=0x1c1650]
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
CPU: vendor_id 'Vortex86 SoC' unknown, using generic init.
CPU: Your system may be unstable.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000008000000 (usable)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
DMI not present or invalid.
last_pfn = 0x8000 max_arch_pfn = 0x100000
init_memory_mapping: 0000000000000000-0000000008000000
128MB LOWMEM available.
  mapped low ram: 0 - 08000000
  low ram: 0 - 08000000
  node 0 low ram: 00000000 - 08000000
  node 0 bootmap 00001000 - 00002000
(6 early reservations) ==> bootmem [0000000000 - 0008000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 000048b670]    TEXT DATA BSS ==> [0000100000 - 000048b670]
  #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #3 [000048c000 - 000048e000]              BRK ==> [000048c000 - 000048e000]
  #4 [0000007000 - 0000025000]          PGTABLE ==> [0000007000 - 0000025000]
  #5 [0000001000 - 0000002000]          BOOTMAP ==> [0000001000 - 0000002000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00008000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x00008000
Allocating PCI resources starting at 8000000 (gap: 8000000:f7000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32415
Kernel command line: root=/dev/sda1 console=ttyS0,115200 vga=0x312 rootwait
PID hash table entries: 512 (order: 9, 2048 bytes)
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Initializing CPU#0
Memory: 125640k/131072k available (2483k kernel code, 4884k reserved, 825k data, 204k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffe5000 - 0xfffff000   ( 104 kB)
    vmalloc : 0xc8800000 - 0xfffe3000   ( 887 MB)
    lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
      .init : 0xc043c000 - 0xc046f000   ( 204 kB)
      .data : 0xc036ce9d - 0xc043b69c   ( 825 kB)
      .text : 0xc0100000 - 0xc036ce9d   (2483 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Preemptible RCU implementation.
NR_IRQS:16
Fast TSC calibration using PIT
Detected 800.057 MHz processor.
Console: colour dummy device 80x25
console [ttyS0] enabled
Calibrating delay loop (skipped), value calculated using timer frequency.. 1600.11 BogoMIPS (lpj=8000570)
Mount-cache hash table entries: 512
Performance Counters: CPU: Vortex86 SoC 05/02 stepping 02
Checking 'hlt' instruction... OK.
NET: Registered protocol family 16
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=0
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
pci 0000:00:07.0: default IRQ router [17f3:6031]
pci 0000:00:0a.0: BAR 0: address space collision on of device [0x0e2000-0x0e2fff]
pci 0000:00:0a.0: BAR 0: can't allocate resource
pci 0000:00:0a.1: BAR 0: address space collision on of device [0x0e3000-0x0e30ff]
pci 0000:00:0a.1: BAR 0: can't allocate resource
pci 0000:00:0b.0: BAR 0: address space collision on of device [0x0e0000-0x0e0fff]
pci 0000:00:0b.0: BAR 0: can't allocate resource
pci 0000:00:0b.1: BAR 0: address space collision on of device [0x0e1000-0x0e10ff]
pci 0000:00:0b.1: BAR 0: can't allocate resource
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
NET: Registered protocol family 1
platform rtc_cmos: registered platform RTC device (no PNP device found)
msgmni has been set to 245
alg: No test for stdrng (krng)
io scheduler noop registered (default)
vesafb: framebuffer at 0xf8000000, mapped to 0xc8880000, using 2400k, total 65472k
vesafb: mode is 640x480x32, linelength=2560, pages=5
vesafb: protected mode interface info at c000:791e
vesafb: pmi: set display start = c00c7958, set palette = c00c79ac
vesafb: scrolling: redraw
vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
fb0: VESA VGA frame buffer device
Serial: 8250/16550 driver, 8 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
<6>r6040: RDC R6040 NAPI net driver,version 0.24 (08Jul2009)
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:0a.1: EHCI Host Controller
ehci_hcd 0000:00:0a.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0a.1: irq 9, io mem 0x08002000
ehci_hcd 0000:00:0a.1: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.31.2 ehci_hcd
usb usb1: SerialNumber: 0000:00:0a.1
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:0b.1: irq 10, io mem 0x08002100
ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.31.2 ehci_hcd
usb usb2: SerialNumber: 0000:00:0b.1
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:0a.0: OHCI Host Controller
ohci_hcd 0000:00:0a.0: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:0a.0: irq 15, io mem 0x08000000
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.31.2 ohci_hcd
usb usb3: SerialNumber: 0000:00:0a.0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:0b.0: irq 11, io mem 0x08001000
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.31.2 ohci_hcd
usb usb4: SerialNumber: 0000:00:0b.0
usb 1-1: new high speed USB device using ehci_hcd and address 2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
usb 1-1: New USB device found, idVendor=090c, idProduct=1000
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: USB DISK
usb 1-1: Manufacturer: SMI Corporation
usb 1-1: SerialNumber: AA00000000002486
usb 1-1: configuration #1 chosen from 1 choice
scsi0 : SCSI emulation for USB Mass Storage devices
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
rtc_cmos rtc_cmos: setting system clock to 2009-11-19 15:08:27 UTC (1258643307)
Waiting for root device /dev/sda1...
scsi 0:0:0:0: Direct-Access     SMI      USB DISK         1100 PQ: 0 ANSI: 0 CCS
sd 0:0:0:0: [sda] 1981440 512-byte logical blocks: (1.01 GB/967 MiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1 sda2
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] Attached SCSI disk
VFS: Mounted root (ext2 filesystem) readonly on device 8:1.
Freeing unused kernel memory: 204k freed

--Boundary-00=_tg6CLmSpgCbgNhQ--
