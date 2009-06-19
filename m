Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZFSPFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZFSPFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 11:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZFSPFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 11:05:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42724 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZFSPFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 11:05:45 -0400
Date: Fri, 19 Jun 2009 17:05:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.30-rc6 -> final regression: warn_on tty_io.c, broken bluetooth
Message-ID: <20090619150539.GF1389@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-rc6 was okay... definitely no warn on, and bluetooth was flakey
but worked.

I doublechecked config is same between -rc and final.

Linux version 2.6.30 (pavel@toy.ucw.cz) (gcc version 4.3.2 (Debian 4.3.2-1) ) #7 PREEMPT Fri Jun 19 15:07:11 CEST 2009
CPU: XScale-PXA270 [69054114] revision 4 (ARMv5TE), cr=0000397f
CPU: VIVT data cache, VIVT instruction cache
Machine: SHARP Spitz
Memory policy: ECC disabled, Data cache writeback
On node 0 totalpages: 16384
free_area_init_node: node 0, pgdat c03a54ec, node_mem_map c03bd000
  Normal zone: 128 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 16256 pages, LIFO batch:3
Run Mode clock: 208.00MHz (*16)
Turbo Mode clock: 416.00MHz (*2.0, active)
Memory clock: 208.00MHz (/2)
System bus clock: 208.00MHz 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
Kernel command line: console=tty1 noinitrd root=/dev/hda3 rootfstype=ext3   user_debug=-1 fbcon=rotate:1 rootdelay=3 no_console_suspend
NR_IRQS:192
PID hash table entries: 256 (order: 8, 1024 bytes)
Console: colour dummy device 80x30
console [tty1] enabled
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 64MB = 64MB total
Memory: 61084KB available (3360K code, 244K data, 88K init, 0K highmem)
SLUB: Genslabs=11, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop... 415.33 BogoMIPS (lpj=2076672)
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
net_namespace: 668 bytes
NET: Registered protocol family 16
Sharp Scoop Device found at 0x10800000 -> 0xc4814000
Sharp Scoop Device found at 0x08800040 -> 0xc4818040
bio: create slab <bio-0> at 0
I2C: i2c-0: PXA I2C adapter
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 2048 (order: 2, 16384 bytes)
TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 2048 bind 2048)
TCP reno registered
NET: Registered protocol family 1
PXA CPU 27x max frequency not defined (pxa27x_maxfreq), assuming pxa271 with 416000kHz maxfreq
PXA CPU frequency change support initialized
JFFS2 version 2.2. (NAND) (SUMMARY)  ÂŠ 2001-2006 Red Hat, Inc.
msgmni has been set to 119
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Console: switching to colour frame buffer device 80x30
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
PPP generic driver version 2.4.2
orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
NAND device: Manufacturer ID: 0xec, Chip ID: 0x73 (Samsung NAND 16MiB 3,3V 8-bit)
Scanning device for bad blocks
Creating 3 MTD partitions on "sharpsl-nand":
0x000000000000-0x000000700000 : "System Area"
0x000000700000-0x000000c00000 : "Root Filesystem"
0x000000c00000-0x000001000000 : "Home Filesystem"
mice: PS/2 mouse device common for all mice
input: Spitz Keyboard as /class/input/input0
ads7846 spi2.0: touchscreen, irq 75
input: ADS784x Touchscreen as /class/input/input1
Bluetooth: HCI UART driver ver 2.2
Bluetooth: HCI H4 protocol initialized
Bluetooth: HCI BCSP protocol initialized
cpuidle: using governor ladder
Registered led device: spitz:amber:charge
pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
pcmcia 0.0: pcmcia: registering new device pcmcia0.0
Registered led device: spitz:green:hddactivity
ttyS0: detected caps 00000700 should be 00000100
0.0: ttyS0 at I/O 0xc48202f8 (irq = 169) is a 16C950/954
TCP cubic registered
NET: Registered protocol family 17
Bluetooth: L2CAP ver 2.13
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
XScale iWMMXt coprocessor detected.
Waiting 3sec before mounting root device...
pcmcia_socket pcmcia_socket1: pccard: PCMCIA card inserted into slot 1
pcmcia 1.0: pcmcia: registering new device pcmcia1.0
Probing IDE interface ide0...
sharpsl-pm sharpsl-pm: AC Status: 0
sharpsl-pm sharpsl-pm: Battery: voltage: 199, status: 0, percentage: 65, time: -29837
hda: HMS360404D5CF00, CFA DISK drive
ide0 at 0xc4840000-0xc4840007,0xc484000e on irq 170
hda: max request size: 128KiB
hda: 7999488 sectors (4095 MB) w/128KiB Cache, CHS=7936/16/63
hda: cache flushes supported
 hda: hda1 hda2 hda3
ide-cs: hda: Vpp = 0.0
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
sharpsl-pm sharpsl-pm: Battery: voltage: 196, status: 0, percentage: 58, time: -28336
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 3:3.
Freeing init memory: 88K
sharpsl-pm sharpsl-pm: Battery: voltage: 195, status: 0, percentage: 55, time: -26836
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on hda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on hda2, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
sharpsl-pm sharpsl-pm: Battery: voltage: 194, status: 0, percentage: 53, time: -25336
sharpsl-pm sharpsl-pm: AC Status: 1
sharpsl-pm sharpsl-pm: Turning Charger On
sharpsl-pm sharpsl-pm: Toogling Charger at time: ffffa1db
sharpsl-pm sharpsl-pm: Average: 122 from values: 122, 122, 123, 122, 122
sharpsl-pm sharpsl-pm: Temperature: 122
sharpsl-pm sharpsl-pm: Average: 121 from values: 120, 121, 121, 122, 122
sharpsl-pm sharpsl-pm: AC Voltage: 121
sharpsl-pm sharpsl-pm: Charge LED On
sharpsl-pm sharpsl-pm: Battery: voltage: 208, status: 0, percentage: 88, time: -23836
Adding 55160k swap on /SWAP.  Priority:-1 extents:15 across:55220k 
sharpsl-pm sharpsl-pm: Battery: voltage: 209, status: 0, percentage: 90, time: -22336
bcsp_recv: Out-of-order packet arrived, got 1 expected 0
------------[ cut here ]------------
WARNING: at drivers/char/tty_io.c:1335 tty_open+0x358/0x494()
Modules linked in:
[<c0023a8c>] (unwind_backtrace+0x0/0xe4) from [<c003504c>] (warn_slowpath_common+0x4c/0x80)
[<c003504c>] (warn_slowpath_common+0x4c/0x80) from [<c017b910>] (tty_open+0x358/0x494)
[<c017b910>] (tty_open+0x358/0x494) from [<c0098228>] (chrdev_open+0x148/0x224)
[<c0098228>] (chrdev_open+0x148/0x224) from [<c0093094>] (__dentry_open+0x104/0x2b4)
[<c0093094>] (__dentry_open+0x104/0x2b4) from [<c0093328>] (nameidata_to_filp+0x58/0x60)
[<c0093328>] (nameidata_to_filp+0x58/0x60) from [<c00a1268>] (do_filp_open+0x1dc/0x804)
[<c00a1268>] (do_filp_open+0x1dc/0x804) from [<c0092ee0>] (do_sys_open+0x68/0xec)
[<c0092ee0>] (do_sys_open+0x68/0xec) from [<c001ef20>] (ret_fast_syscall+0x0/0x2c)
---[ end trace 76f9d103516197ad ]---
bcsp_recv: Out-of-order packet arrived, got 1 expected 0
sharpsl-pm sharpsl-pm: Battery: voltage: 209, status: 0, percentage: 90, time: -20836
bcsp_pkt_cull: Removed only 1 out of 0 pkts
bcsp_pkt_cull: Removed only 1 out of 0 pkts
bcsp_pkt_cull: Removed only 2 out of 1 pkts
------------[ cut here ]------------
WARNING: at drivers/char/tty_io.c:1335 tty_open+0x358/0x494()
Modules linked in:
[<c0023a8c>] (unwind_backtrace+0x0/0xe4) from [<c003504c>] (warn_slowpath_common+0x4c/0x80)
[<c003504c>] (warn_slowpath_common+0x4c/0x80) from [<c017b910>] (tty_open+0x358/0x494)
[<c017b910>] (tty_open+0x358/0x494) from [<c0098228>] (chrdev_open+0x148/0x224)
[<c0098228>] (chrdev_open+0x148/0x224) from [<c0093094>] (__dentry_open+0x104/0x2b4)
[<c0093094>] (__dentry_open+0x104/0x2b4) from [<c0093328>] (nameidata_to_filp+0x58/0x60)
[<c0093328>] (nameidata_to_filp+0x58/0x60) from [<c00a1268>] (do_filp_open+0x1dc/0x804)
[<c00a1268>] (do_filp_open+0x1dc/0x804) from [<c0092ee0>] (do_sys_open+0x68/0xec)
[<c0092ee0>] (do_sys_open+0x68/0xec) from [<c001ef20>] (ret_fast_syscall+0x0/0x2c)
---[ end trace 76f9d103516197ae ]---
SysRq : Changing Loglevel
Loglevel set to 1
bcsp_recv: Out-of-order packet arrived, got 1 expected 0
bcsp_pkt_cull: Removed only 1 out of 0 pkts
bcsp_pkt_cull: Removed only 2 out of 1 pkts
sharpsl-pm sharpsl-pm: Battery: voltage: 209, status: 0, percentage: 90, time: -19336

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
