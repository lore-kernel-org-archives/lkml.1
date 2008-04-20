Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYDTXSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYDTXSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 19:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbYDTXSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 19:18:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:39858 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbYDTXS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 19:18:29 -0400
Date: Mon, 21 Apr 2008 01:18:18 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-parisc@vger.kernel.org
Subject: [REGRESSION] 2.6.25 on parisc - CPU 1 is stuck 
Message-ID: <20080420231818.GA2162@ska.dandreoli.com>
Mail-Followup-To: Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-parisc@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  as soon as I booted my dual PA8600 with 2.6.25 I got 1 CPU less. The
only other kernel I successfully used on that box is Debian's 2.6.22-3.

Debian never built 2.6.23 for parisc, 2.6.24 was still hanging last
time I checked it, 2.6.25 did not even build until recent -rc. So I am
not in the best position to bisect.

Here is the relevant dmesg.

Cheers,
Domenico

Linux version 2.6.25-02519-g3925e6f (cavok@ska) (gcc version 4.1.3 20080308 (prerelease) (Debian 4.1.2-21)) #4 SMP Sun Apr 20 04:53:48
FP[0] enabled: Rev 1 Model 16
The 64-bit Kernel has started...
console [ttyB0] enabled
Initialized PDC Console for debugging.
Determining PDC firmware type: System Map.
model 00005d10 00000491 00000000 00000002 77b406fc 100000f0 00000008 000000b2 000000b2
vers  00000300
CPUID vers 17 rev 10 (0x0000022a)
capabilities 0x3
model 9000/785/J5600
Total Memory: 3840 MB
LCD display at fffffff0f05d0008,fffffff0f05d0000 registered
SMP: bootstrap CPU ID is 0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 969600
Kernel command line: root=/dev/sdb5 panic=60 HOME=/ console=ttyS0 TERM=vt102 palo_kernel=2/vmlinux
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour dummy device 160x64
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Memory: 3858944k/3932160k available (2916k kernel code, 72892k reserved, 1283k data, 240k init)
virtual kernel memory layout:
    vmalloc : 0x0000000000008000 - 0x000000003f000000   (1007 MB)
    memory  : 0x0000000040000000 - 0x0000000130000000   (3840 MB)
      .init : 0x00000000405b0000 - 0x00000000405ec000   ( 240 kB)
      .data : 0x00000000403d9160 - 0x000000004051a000   (1283 kB)
      .text : 0x0000000040100000 - 0x00000000403d9160   (2916 kB)
SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 256
Brought up 1 CPUs
net_namespace: 1168 bytes
NET: Registered protocol family 16
EISA bus registered
Searching for devices...
Found devices:
1. Astro BC Runway Port at 0xfffffffffed00000 [10] { 12, 0x0, 0x582, 0x0000b }
2. Elroy PCI Bridge at 0xfffffffffed30000 [10/0] { 13, 0x0, 0x782, 0x0000a }
3. Elroy PCI Bridge at 0xfffffffffed32000 [10/1] { 13, 0x0, 0x782, 0x0000a }
4. Elroy PCI Bridge at 0xfffffffffed34000 [10/2] { 13, 0x0, 0x782, 0x0000a }
5. Elroy PCI Bridge at 0xfffffffffed38000 [10/4] { 13, 0x0, 0x782, 0x0000a }
6. Elroy PCI Bridge at 0xfffffffffed3c000 [10/6] { 13, 0x0, 0x782, 0x0000a }
7. Forte W+ 2w at 0xfffffffffffa0000 [32] { 0, 0x0, 0x5d1, 0x00004 }
8. Forte W+ 2w at 0xfffffffffffa2000 [34] { 0, 0x0, 0x5d1, 0x00004 }
9. Memory at 0xfffffffffed10200 [49] { 1, 0x0, 0x09e, 0x00009 }
Enabling regular chassis codes support v0.05
Releasing cpu 1 now, hpa=fffffffffffa2000
SMP: CPU:1 is stuck.
CPU(s): 2 x PA8600 (PCX-W+) at 552.000000 MHz
Setting cache flush threshold to f84c0 (1 CPUs online)
SBA found Astro 2.1 at 0xfffffffffed00000
Elroy version TR2.1 (0x2) found at 0xfffffffffed30000
PCI: Enabled native mode for NS87415 (pif=0x8f)
Elroy version TR2.1 (0x2) found at 0xfffffffffed32000
Elroy version TR2.1 (0x2) found at 0xfffffffffed34000
Elroy version TR2.1 (0x2) found at 0xfffffffffed38000
Elroy version TR2.1 (0x2) found at 0xfffffffffed3c000
iosapic: hpa not registered for 0000:04:07.0
powersw: Soft power switch at 0xfffffff0f0400804 enabled.
...

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
