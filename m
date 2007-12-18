Return-Path: <linux-kernel-owner+w=401wt.eu-S1762112AbXLRFj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762112AbXLRFj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 00:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbXLRFjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 00:39:48 -0500
Received: from kuber.nabble.com ([216.139.236.158]:38878 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbXLRFjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 00:39:47 -0500
Message-ID: <14384475.post@talk.nabble.com>
Date: Mon, 17 Dec 2007 21:39:46 -0800 (PST)
From: ManojKwal <kmanojcse23@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kobject_add failed for tts/0 (-13)-EACCES
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: kmanojcse23@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greetings! 

System details: 
Board: DTSP-ARM926Ej-S(new board) 
Cross-toolchain: ELDK4.1 
Linux kernel: 2.6.18
u-boot: 1.1.6

I have been able to successfully run u-boot and linux kernel with root file
system but when kernel is start the following error message
come.........."kobject_add failed for tts/0 (-13)"
The complete log is following:





U-Boot 1.1.6 (Dec 14 2007 - 19:27:49)

DRAM:  64 MB
*** Warning - bad CRC, using default environment

In:    serial
Out:   serial
Err:   serial
Hit any key to stop autoboot:  0 
Flash
## Booting image at 00010000 ...
   Image Name:   Linux-2.6.18-DRM
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    627476 Bytes = 612.8 kB
   Load Address: 08008000
   Entry Point:  08008000
   Verifying Checksum ... OK
OK

Starting kernel ...

Uncompressing Linux........................................... done, booting
the kernel.
                                                                                       
Linux version 2.6.18-DRM (khandelwal@HotelTV-Server) (gcc version 4.0.0
(DENX ELDK 4.1 4.0.0)) #18 Fri Dec 14 18:34:58 KST 2007
CPU: ARM926EJ-S [41069263] revision 3 (ARMv5TEJ), cr=00053177
Machine: DTSP
Memory policy: ECC disabled, Data cache writeback
CPU0: D VIVT write-back cache
CPU0: I cache: 32768 bytes, associativity 4, 32 byte lines, 256 sets
CPU0: D cache: 32768 bytes, associativity 4, 32 byte lines, 256 sets
Built 1 zonelists.  Total pages: 16128
Kernel command line: root=/dev/ram0 mem=63M initrd=0xA000000,6M
ramdisk=16384 console=ttyS0,38400 init=/linuxrc
PID hash table entries: 256 (order: 8, 1024 bytes)
Console: colour dummy device 80x30
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 63MB = 63MB total
Memory: 56448KB available (984K code, 248K data, 68K init)
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
checking if image is initramfs...it isn't (no cpio magic); looks like an
initrd
Freeing initrd memory: 6144K
dtsp_init() - platform_add_device - for serial
NetWinder Floating Point Emulator V0.97 (double precision)
Initializing Cryptographic API
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
serial_dtsp_init()
serial_dtsp_probe()
dtsp_uart.0: tts/0 at MMIO 0x20200000 (irq = 2) is a ttyS
kobject_add failed for tts/0 (-13)
[<c001d918>] (dump_stack+0x0/0x14) from [<c00c9d74>]
(kobject_add+0x168/0x1a4)
[<c00c9c0c>] (kobject_add+0x0/0x1a4) from [<c00eab84>]
(class_device_add+0x88/0x420)
 r8 = C0114240  r7 = 0CC00040  r6 = C3E11BC0  r5 = C0323440
 r4 = C0323440 
[<c00eaafc>] (class_device_add+0x0/0x420) from [<c00eaf38>]
(class_device_register+0x1c/0x20)
[<c00eaf1c>] (class_device_register+0x0/0x20) from [<c00eafc8>]
(class_device_create+0x8c/0xc4)
 r4 = C0323440 
[<c00eaf3c>] (class_device_create+0x0/0xc4) from [<c00d0ef0>]
(tty_register_device+0xc8/0xe8)
[<c00d0e28>] (tty_register_device+0x0/0xe8) from [<c00e500c>]
(uart_add_one_port+0x22c/0x2a0)
 r7 = C011FAE4  r6 = 00000002  r5 = 00000000  r4 = 60000013
[<c00e4de0>] (uart_add_one_port+0x0/0x2a0) from [<c00e6a9c>]
(serial_dtsp_probe+0x40/0x60)
[<c00e6a5c>] (serial_dtsp_probe+0x0/0x60) from [<c00eb7a8>]
(platform_drv_probe+0x20/0x24)
 r7 = C011FB84  r6 = 00000000  r5 = C0114240  r4 = C0114310
[<c00eb788>] (platform_drv_probe+0x0/0x24) from [<c00e9a18>]
(driver_probe_device+0x7c/0xcc)
[<c00e999c>] (driver_probe_device+0x0/0xcc) from [<c00e9b8c>]
(__driver_attach+0x84/0xe4)
 r7 = C011FB84  r6 = C00E9B08  r5 = C0114240  r4 = C0114310
[<c00e9b08>] (__driver_attach+0x0/0xe4) from [<c00e8e2c>]
(bus_for_each_dev+0x48/0x80)
 r5 = C01FBF18  r4 = 00000000 
[<c00e8de4>] (bus_for_each_dev+0x0/0x80) from [<c00e98a0>]
(driver_attach+0x20/0x28)
 r7 = C011FB98  r6 = C011FEFC  r5 = C011FB84  r4 = 00000000
[<c00e9880>] (driver_attach+0x0/0x28) from [<c00e9198>]
(bus_add_driver+0x6c/0x128)
[<c00e912c>] (bus_add_driver+0x0/0x128) from [<c00e9ff4>]
(driver_register+0x90/0xa0)
 r8 = 00000000  r7 = 00000000  r6 = C01FA000  r5 = C00172D8
 r4 = C011FB84 
[<c00e9f64>] (driver_register+0x0/0xa0) from [<c00eb8a8>]
(platform_driver_register+0x6c/0x88)
 r4 = 00000000 
[<c00eb83c>] (platform_driver_register+0x0/0x88) from [<c0016828>]
(serial_dtsp_init+0x2c/0x50)
[<c00167fc>] (serial_dtsp_init+0x0/0x50) from [<c00190e0>] (init+0x88/0x26c)
 r4 = C0017814 
[<c0019058>] (init+0x0/0x26c) from [<c002f59c>] (do_exit+0x0/0x814)
 r7 = 00000000  r6 = 00000000  r5 = 00000000  r4 = 00000000
RAMDISK driver initialized: 1 RAM disks of 16384K size 1024 blocksize
mice: PS/2 mouse device common for all mice
RAMDISK: Compressed image found at block 0
VFS: Mounted root (ext2 filesystem).
Freeing init memory: 68K
/etc/init.d/rcS: /etc/init.d/rcS: 2: mount: not found

Please press Enter to activate this console. 


BusyBox v1.1.3 (2007.12.13-08:41+0000) Built-in shell (ash)
Enter 'help' for a list of built-in commands.
# 




Please help me to sort out this problem. I have very little experience on
this type of work.............



Thanks in Advance...........

Manoj Khandelwal
Software Engineer

-- 
View this message in context: http://www.nabble.com/kobject_add-failed-for-tts-0-%28-13%29-EACCES-tp14384475p14384475.html
Sent from the linux-kernel mailing list archive at Nabble.com.

