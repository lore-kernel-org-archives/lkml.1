Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbYDUUYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbYDUUYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYDUUYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:24:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:49156 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYDUUYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:24:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AIwueqdcDrtRlCTIF7Hs9ow5pij6IJ3wkuaKouY0bflCTYUCTEJF3J+X2ooQAs+ECjU8iXRzt1Jtb0TYjAwAcN5vbXxZfyIh0ZiZ/nkD+U3xiUjOroP1fExURj83MmIrXmcV1fkBhr7dAf51LsP91d9MclfpmpJUEiKx3i4ZmtI=
Message-ID: <b40acdb70804211324j22e70bf4o36a54b40401f84b6@mail.gmail.com>
Date: Mon, 21 Apr 2008 22:24:35 +0200
From: "Domenico Andreoli" <cavokz@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [REGRESSION] 2.6.25 on parisc - CPU 1 is stuck
Cc: "Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-parisc@vger.kernel.org
In-Reply-To: <1208789018.3640.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080420231818.GA2162@ska.dandreoli.com>
	 <1208789018.3640.6.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/08, James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2008-04-21 at 01:18 +0200, Domenico Andreoli wrote:
>  > as soon as I booted my dual PA8600 with 2.6.25 I got 1 CPU less. The
>  > only other kernel I successfully used on that box is Debian's 2.6.22-3.
>  >
>  > Debian never built 2.6.23 for parisc, 2.6.24 was still hanging last
>  > time I checked it, 2.6.25 did not even build until recent -rc. So I am
>  > not in the best position to bisect.
>
> Try this one; it's a corrected version of debian 2.6.24-1 for parisc
>  systems:
>
>  http://www.parisc-linux.org/~jejb/parisc_debs/linux-image-2.6.24-1-parisc64-smp_2.6.24-5+b1_hppa.deb
>
>  It's known to boot correctly on B, A and rp3440 systems, but we don't
>  have a J system to try it out on.

it does not work :( it stops here:

Linux version 2.6.24-1-parisc64-smp (Debian 2.6.24-5+b1)
(jejb@parisc-linux.org) (gcc version 4.1.3 20080114 (prerelease)
(Debian 4.1.2-19)) #2 SMP W8
FP[0] enabled: Rev 1 Model 16
The 64-bit Kernel has started...
console [ttyB0] enabled
Initialized PDC Console for debugging.
Determining PDC firmware type: System Map.
model 00005d10 00000491 00000000 00000002 77b406fc 100000f0 00000008
000000b2 000000b2
vers  00000300
CPUID vers 17 rev 10 (0x0000022a)
capabilities 0x3
model 9000/785/J5600
Memory Ranges:
 0) Start 0x0000000000000000 End 0x00000000efffffff Size   3840 MB
 1) Start 0x00000010f0000000 End 0x00000010ffffffff Size    256 MB
Total Memory: 4096 MB
initrd: 7fa06000-7ffee68b
initrd: reserving 3fa06000-3ffee68b (mem_max 100000000)
LCD display at fffffff0f05d0008,fffffff0f05d0000 registered
SMP: bootstrap CPU ID is 0
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 1034240
Kernel command line: root=/dev/sdb5 panic=60 HOME=/ console=ttyS0
TERM=vt102 palo_kernel=2/vmlinux
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour dummy device 160x64
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Memory: 4109824k/4194304k available (3166k kernel code, 83792k
reserved, 1401k data, 296k init)
virtual kernel memory layout:
    vmalloc : 0x0000000000008000 - 0x000000003f000000   (1007 MB)
    memory  : 0x0000000040000000 - 0x0000001140000000   (69632 MB)
      .init : 0x000000004063c000 - 0x0000000040686000   ( 296 kB)
      .data : 0x0000000040417890 - 0x0000000040576000   (1401 kB)
      .text : 0x0000000040100000 - 0x0000000040417890   (3166 kB)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Brought up 1 CPUs
net_namespace: 120 bytes
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

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
