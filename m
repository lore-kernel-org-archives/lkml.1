Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbYGXLK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbYGXLK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYGXLKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:10:15 -0400
Received: from kuber.nabble.com ([216.139.236.158]:52503 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYGXLKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:10:13 -0400
Message-ID: <18629746.post@talk.nabble.com>
Date: Thu, 24 Jul 2008 04:10:12 -0700 (PDT)
From: p_ashish <priyadarshi.ashish@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Linux Bootup hangs after adding RealTime Premption and HR-Timer
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: priyadarshi.ashish@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi All,

My Hardware is ARM based and the I am using ELDK (linux-2.6.19.2). I added a
patch for Real-Time Preemption and it did work. I added High Resolution
Timer as well (added architecture specific code). But  after this change the
system hangs during the boot-up itself.

Following is the boot log:


------------POWER OFF PHY-------------------PHY POWERED OFF
SUCCESSFULLY-------#
# Booting image at 01600000 ...
   Image Name:   Linux-2.6.19.2
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    1400696 Bytes =  1.3 MB
   Load Address: 00008000
   Entry Point:  00008000
OK

Starting kernel ...

Uncompressing
Linux.............................................................
.............................. done, booting the kernel.
Linux version 2.6.19.2 (pashish@dlhl0011) (gcc version 4.0.0 (DENX ELDK 4.1
4.0.
0)) #71 PREEMPT Thu Jul 24 14:52:27 IST 2008
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
Machine: STM-spearplus
Memory policy: ECC disabled, Data cache writeback
CPU0: D VIVT write-back cache
CPU0: I cache: 16384 bytes, associativity 4, 32 byte lines, 128 sets
CPU0: D cache: 16384 bytes, associativity 4, 32 byte lines, 128 sets
Real-Time Preemption Support (C) 2004-2006 Ingo Molnar
Built 1 zonelists.  Total pages: 16256
Kernel command line: console=ttyS0 root=/dev/ram0 initrd=0x00800040,7M
WARNING: experimental RCU implementation.
PID hash table entries: 256 (order: 8, 1024 bytes)

tmr allocated for ticks Tmr id = 1
 <6> Timer0: time_init():  TICK_RATE: 48000000, HZ: , period: 100
Inactive clock event device hrt Clock Event registered
HRT Clk Event mult=0xc49ba5
start_kernel(): bug: interrupts were enabled early
Console: colour dumDentry cache hash table entries: 8192 (order: 3, 32768
bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 64MB = 64MB total
Memory: 54752KB available (2344K code, 495K data, 104K init)
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
BUG: time warp detected!
prev > now, 0000000000000000 > a50923cf1312d000:
= 6554668410375843840 delta, on CPU#0
checking if image is initramfs...it isn't (no cpio magic); looks like an
initrd
Freeing initrd memory: 7168K
NET: Registered protocol family 16
AMBA peripheral sh:00 registered = 0
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NET: Registered protocol family 2
IP route cache hash table entries: 512 (order: -1, 2048 bytes)
TCP established hash table entries: 2048 (order: 4, 65536 bytes)
TCP bind hash table entries: 1024 (order: 2, 28672 bytes)
TCP: Hash tables configured (established 2048 bind 1024)
TCP reno registered
HRT Clk Source mult=0x4d555555
NetWinder Floating Point Emulator V0.97 (double precision)
JFFS2 version 2.2. (NAND) (C) 2001-2006 Red Hat, Inc.
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
CLCD: spearplus hardware, Samsung LMS700 display
SPEAR :: Initializing in drivers ST Microelectronics SPEAR UART -- CPG 
inside U
ART
ttyS0 at I/O 0x0 (irq = 24) is a ST Microelectronics SPEAR UART -- CPG
ttyS1 at I/O 0x0 (irq = 25) is a ST Microelectronics SPEAR UART -- CPRAMDISK
dri
ver initialized: 16 RAM disks of 8192K size 1024 blocksize
ST SPEARPLUS Ethernet Driver version 0.1

Size of struct eth_priv is 2016
struct eth_priv start(Virtual) address is ffd90000
struct eth_priv start(Physical) address is 3a31000
Physical address of Tx Descriptor chain is 3a31000
Physical address of Rx Descriptor chain is 3a31300<6>st: Version 20050830,
fixed
 bufsize 32768, s/g segs 256
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
STW Serial Flash initializing...

 Memory slot 1 is empty

 Memory slot 2 is empty

 Memory slot 3 is empty

 The partitioning is done as mentioned (static)
Creating 5 MTD partitions on "ST M25P64":
0x00000000-0x00010000 : "Xloader"
0x00010000-0x00050000 : "UBoot"
0x00050000-0x00300000 : "kernel"
0x00300000-0x007f0000 : "Root File system"
0x007f0000-0x00800000 : "Temp"
ATI STW Serial Flash Device initialization done.

Inside nand probe function
NAND device: Manufacturer ID: 0x20, Chip ID: 0x76 (ST Micro NAND 64MiB 3,3V
8-bi
t)
Scanning device for bad blocks
Bad eraseblock 52 at 0x000d0000
Bad eraseblock 2073 at 0x02064000
Bad eraseblock 3636 at 0x038d0000
Creating 6 MTD partitions on "NAND 64MiB 3,3V 8-bit":
0x00000000-0x00010000 : "X-Loader"
0x00010000-0x00014000 : "Mem Init Func"
0x00014000-0x00054000 : "U-Boot"
0x00054000-0x00354000 : "Kernel+Initrd images"
0x00354000-0x00d54000 : "Root filesystem"
0x00d54000-0x04000000 : "user filesystem"
Registering EHCI SPEAR driver
Enter ehci_hcd_spear_drv_probe
ehci_hcd ehci_hcd.2: SPEAr EHCI
ehci_hcd ehci_hcd.2: new USB bus registered, assigned bus number 1
ehci_hcd ehci_hcd.2: irq 59, io mem 0xe1800000
ehci_hcd ehci_hcd.2: USB 0.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 1 port detected
Enter ehci_hcd_spear_drv_probe
ehci_hcd ehci_hcd.3: SPEAr EHCI
ehci_hcd ehci_hcd.3: new USB bus registered, assigned bus number 2
ehci_hcd ehci_hcd.3: irq 61, io mem 0xe2000000
ehci_hcd ehci_hcd.3: USB 0.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 1 port detected
Loading OHCI SPEAR driver
Enter ohci_hcd_syn_drv_probe
ENTERING OHCI SPEAR PROBE
ohci_hcd ohci_hcd.0: SPEAr OHCI
ohci_hcd ohci_hcd.0: new USB bus registered, assigned bus number 3
ohci_hcd ohci_hcd.0: irq 58, io mem 0xe1900000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 1 port detected
Enter ohci_hcd_syn_drv_probe
ENTERING OHCI SPEAR PROBE
ohci_hcd ohci_hcd.1: SPEAr OHCI
ohci_hcd ohci_hcd.1: new USB bus registered, assigned bus number 4
ohci_hcd ohci_hcd.1: irq 60, io mem 0xe2100000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 1 port detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbtest
mice: PS/2 mouse device common for all mice

Real Time Clock Driver Initialized
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
Time: hrt Clock Source clocksource has been installed.
Clock event device hrt Clock Event configured with caps set: 08
Switched to high resolution mode on CPU 0
RAMDISK: Compressed image found at block 0
EXT2-fs warning: checktime reached, running e2fsck is recommended
VFS: Mounted root (ext2 filesystem).
INIT: version 2.85 booting
0
mknod: invalid option -- -
BusyBox v1.00-rc3 (2005.07.23-08:39+0000) multi-call binary

Usage: mknod [OPTIONS] NAME TYPE MAJOR MINOR

Create a special file (block, character, or pipe).

Options:
        -m      create the special file using the specified mode (default
a=rw)

TYPEs include:
        b:      Make a block (buffered) device.
        c or u: Make a character (un-buffered) device.
        p:      Make a named pipe. MAJOR and MINOR are ignored for named
pipes.

Mounting a tmpfs over /dev...done.
Creating initial device nodes...done.
mknod: invalid option -- -
BusyBox v1.00-rc3 (2005.07.23-08:39+0000) multi-call binary

Usage: mknod [OPTIONS] NAME TYPE MAJOR MINOR

Create a special file (block, character, or pipe).

Options:
        -m      create the special file using the specified mode (default
a=rw)

TYPEs include:
        b:      Make a block (buffered) device.
        c or u: Make a character (un-buffered) device.
        p:      Make a named pipe. MAJOR and MINOR are ignored for named
pipes.

0
Starting mounting  local flesystems: mount none on /var/run type tmpfs (rw)
none on /tmp type tmpfs (rw)
Setting up IP spoofing protection: rp_filter.
Disable TCP/IP Explicit Congestion Notification: done.
Starting network interfaces: udhcpc (v0.9.9-pre) started
udhcpc[871]: udhcpc (v0.9.9-pre) started
Sending discover...
udhcpc[871]: Sending discover...



Can someone help me for this (whoever did RealTime Preemption and HR Timer
for Kernel)? 
Any help/hint will be highly appreciated :)

regards
Ashish
 




-- 
View this message in context: http://www.nabble.com/Linux-Bootup-hangs-after-adding-RealTime-Premption-and-HR-Timer-tp18629746p18629746.html
Sent from the linux-kernel mailing list archive at Nabble.com.

