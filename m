Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbYA1KNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbYA1KNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYA1KNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:13:11 -0500
Received: from kuber.nabble.com ([216.139.236.158]:59242 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbYA1KNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:13:09 -0500
Message-ID: <15132032.post@talk.nabble.com>
Date: Mon, 28 Jan 2008 02:13:09 -0800 (PST)
From: ManojKwal <kmanojcse23@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel is not booting.............
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


I sucessfully port u-boot on board...........But when i boot the kernel it
stuck in mid.........The complete log is following:




DRM-Engine # bootm 0x80000
## Booting image at 00080000 ...
   Image Name:   Linux-2.6.18-DRM
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    623896 Bytes = 609.3 kB
   Load Address: 0b008000
   Entry Point:  0b008000
   Verifying Checksum ... OK
OK
No initrd
## Transferring control to Linux (at address 0b008000) ...

Starting kernel ...

Uncompressing Linux........................................... done, booting
the kernel.
                                                                                       
Linux version 2.6.18-DRM (khandelwal@HotelTV-Server) (gcc version 4.0.0
(DENX ELDK 4.1 4.0.0)) #34 Mon Jan 28 17:35:46 KST 2008
CPU: ARM926EJ-S [41069263] revision 3 (ARMv5TEJ), cr=00053177
Machine: DTSP
Memory policy: ECC disabled, Data cache writeback
CPU0: D VIVT write-back cache
CPU0: I cache: 32768 bytes, associativity 4, 32 byte lines, 256 sets
CPU0: D cache: 32768 bytes, associativity 4, 32 byte lines, 256 sets
Built 1 zonelists.  Total pages: 16128
Kernel command line: root=/dev/ram0 mem=63M initrd=0xd000000,6M
ramdisk=16384 console=ttyS0,38400 init=/linuxrc
PID hash table entries: 256 (order: 8, 1024 bytes)
Console: colour dummy device 80x30
[cskim]:serial_dtsp_set_termios
[cskim] : [baud,quot] = 38400, 26
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 63MB = 63MB total
Memory: 56448KB available (980K code, 248K data, 68K
init)-------------------------->"HERE KERNEL STUCK"




Can anybody help me? I am a beginer on this type of work



Thanks in advance!

Regards
Manoj Khandelwal
Software Engineer

-- 
View this message in context: http://www.nabble.com/Kernel-is-not-booting.............-tp15132032p15132032.html
Sent from the linux-kernel mailing list archive at Nabble.com.

