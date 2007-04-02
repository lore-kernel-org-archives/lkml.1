Return-Path: <linux-kernel-owner+w=401wt.eu-S965698AbXDBTFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965698AbXDBTFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 15:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965699AbXDBTFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 15:05:13 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:22170 "EHLO
	outbound3-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965698AbXDBTFK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 15:05:10 -0400
X-BigFish: VP
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: Warning: unable to open an initial console.
Date: Mon, 2 Apr 2007 12:04:56 -0700
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Warning: unable to open an initial console.
Thread-Index: Acd1Wc1hrKotbialRiSww9D+/60QIg==
From: "Tom Strader" <tom.strader@xilinx.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Apr 2007 19:04:57.0182 (UTC) FILETIME=[CDFD57E0:01C77559]
Message-Id: <20070402190458.0EDD039005F@mail42-fra.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have seen quite a few posts regarding unable to open an initial console, but my system seems to have the necessary things in place so I come looking for help.  I have not yet subscribed to this mailing list so please CC the responses to me.  Quick summary before we get to console output, this is running on a PXA270 with 16MB flash at 0x00000000, 128MB RAM at 0xa0000000.  I am able to bring up U-boot and run ls /dev and the console appears there.  The only components on the board are memory so I am just going for a basic boot for now.  I guess my question is, what are some of the reasons for the console not to start.  Also just as a side note, the kernel appears to continue past "Warning: unable to open an initial console." And find /sbin/init but then goes to an idle loop.  With that said here is the output so hopefully we can fix it.  I am fairly new to linux so if I missed anything let me know.

Thanks,
Tom.Strader@Xilinx.com

U-Boot 1.1.6 (Mar 30 2007 - 14:52:10)

U-Boot code: A1700000 -> A17201BC  BSS: -> A175240C
RAM Configuration:
Bank #0: a0000000 64 MB
Bank #1: a4000000  0 kB
Bank #2: a8000000  0 kB
Bank #3: ac000000  0 kB
Flash: 16 MB
In:    serial
Out:   serial
Err:   serial
Hit any key to stop autoboot:  0
## Booting image at 00040000 ...
   Image Name:   Linux-2.6.17-pcm027-3
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    754152 Bytes = 736.5 kB
   Load Address: a0008000
   Entry Point:  a0008000
   Verifying Checksum ... OK
OK

Starting kernel ...

Uncompressing Linux................................................... done, booting the kernel.
Linux version 2.6.17-pcm027-3 (tstrader@xsjcfs20611) (gcc version 4.0.2) #7 PREEMPT Mon Apr 2 10:16:43 PDT 2007
CPU: XScale-PXA270 [69054117] revision 7 (ARMv5TE)
Machine: LogicPD PXA270 Card Engine
Memory policy: ECC disabled, Data cache writeback
On node 0 totalpages: 16384
  DMA zone: 16384 pages, LIFO batch:3
Run Mode clock: 91.00MHz (*7)
Turbo Mode clock: 182.00MHz (*2.0, inactive)
Memory clock: 91.00MHz (/1)
System bus clock: 45.50MHz
CPU0: D VIVT undefined 5 cache
CPU0: I cache: 32768 bytes, associativity 32, 32 byte lines, 32 sets
CPU0: D cache: 32768 bytes, associativity 32, 32 byte lines, 32 sets
Built 1 zonelists
Kernel command line: console=ttyS0,115200 loglevel=8 mtdparts=phys_mapped_flash:256k(uboot)ro,4096k(kernel),5m(uRamdisk),
-(jffs2_root) root=/dev/mtdblock3 rootfstype=jffs2
PID hash table entries: 512 (order: 9, 2048 bytes)
Console: colour dummy device 80x30
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 64MB 0MB 0MB 0MB = 64MB total
Memory: 63268KB available (1256K code, 261K data, 76K init)
Calibrating delay loop... 90.52 BogoMIPS (lpj=452608)
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
Device 'sa1100-rtc' does not have a release() function, it is broken and must be fixed.
Device 'pxa2xx-i2s' does not have a release() function, it is broken and must be fixed.
Device 'pxa2xx-i2c.0' does not have a release() function, it is broken and must be fixed.
Device 'pxa2xx-ir' does not have a release() function, it is broken and must be fixed.
Device 'pxa2xx-uart.2' does not have a release() function, it is broken and must be fixed.
Device 'pxa2xx-uart.1' does not have a release() function, it is broken and must be fixed.
Device 'pxa2xx-uart.0' does not have a release() function, it is broken and must be fixed.
Device 'pxa2xx-fb' does not have a release() function, it is broken and must be fixed.
Device 'pxa2xx-udc' does not have a release() function, it is broken and must be fixed.
Device 'pxa2xx-mci' does not have a release() function, it is broken and must be fixed.
Initialising gpio device class.
gpio: Unrecognized option ""
JFFS2 version 2.2. (NAND) (C) 2001-2003 Red Hat, Inc.
fuse init (API version 7.6)
io scheduler noop registered (default)
RAMDISK driver initialized: 8 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
physmap flash device: 1000000 at 0
phys_mapped_flash: Found 1 x16 devices at 0x0 in 16-bit bank
 Amd/Fujitsu Extended Query Table at 0x0040
Using buffer write method
phys_mapped_flash: CFI does not contain boot bank location. Assuming top.
number of CFI chips: 1
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
4 cmdlinepart partitions found on MTD device phys_mapped_flash
Creating 4 MTD partitions on "phys_mapped_flash":
0x00000000-0x00040000 : "uboot"
mtd: Giving out device 0 to uboot
0x00040000-0x00440000 : "kernel"
mtd: Giving out device 1 to kernel
0x00440000-0x00940000 : "uRamdisk"
mtd: Giving out device 2 to uRamdisk
0x00940000-0x01000000 : "jffs2_root"
mtd: Giving out device 3 to jffs2_root
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x003c7a1c: 0x3e18 instead
Empty flash at 0x003c7a28 ends at 0x003c7a2c
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x003c7a38: 0x3e38 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x003c7a3c: 0x3e38 instead
Empty flash at 0x003c7a48 ends at 0x003c7a4c
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x003c7a58: 0x3e58 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x003c7a5c: 0x3e58 instead
Empty flash at 0x003c7a68 ends at 0x003c7a6c
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x003c7a78: 0x3e78 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x003c7a7c: 0x3e78 instead
Empty flash at 0x003c7a88 ends at 0x003c7a8c
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x003c7a98: 0x3e98 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x003c7a9c: 0x3e98 instead
Empty flash at 0x003c7aa8 ends at 0x003c7aac
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x003c7ab8: 0x3eb8 instead
Further such events for this erase block will not be printed
Empty flash at 0x003c7ac8 ends at 0x003c7acc
...
Empty flash at 0x003cffe8 ends at 0x003cffec
VFS: Mounted root (jffs2 filesystem).
Freeing init memory: 76K
Warning: unable to open an initial console.


