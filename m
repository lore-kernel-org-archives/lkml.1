Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbXCZU54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbXCZU54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbXCZU54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:57:56 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41935 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbXCZU5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:57:54 -0400
Subject: Re: 2.6.21-rc4-mm1
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 13:57:57 -0800
Message-Id: <1174946277.16728.14.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 20:56 -0800, Andrew Morton wrote:
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> 


Panics my x86-64 box. 2.6.21-rc4 works fine.
Ideas on where to start ? Bisect ?

Thanks,
Badari

..
ReiserFS: hda2: found reiserfs format "3.6" with standard journal
ReiserFS: hda2: using ordered data mode
ReiserFS: hda2: journal params: device hda2, size 8192, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: hda2: checking transaction log (hda2)
ReiserFS: hda2: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 376k freed
INIT: version 2.86 booting
Unable to handle kernel NULL pointer dereference at 0000000000000020
RIP:
 [<ffffffff804ec090>] __sched_text_start+0x460/0x889
PGD 1c1898067 PUD 1c1897067 PMD 0
Oops: 0000 [1] SMP
last sysfs file: block/hda/range
CPU 3
Modules linked in:
Pid: 900, comm: boot Not tainted 2.6.21-rc4-mm1 #1
RIP: 0010:[<ffffffff804ec090>]  [<ffffffff804ec090>] __sched_text_start
+0x460/0x889
RSP: 0018:ffff8101014dfee0  EFLAGS: 00010086
RAX: 0000000000000001 RBX: ffff8101c0010218 RCX: 0000000000000000
RDX: ffff8101c0010ae8 RSI: 0000000000000000 RDI: ffffffffffffffd0
RBP: ffff8101014dff70 R08: 000000000000008c R09: ffff8101c0010ad8
R10: 000000000000001c R11: ffffffff802099be R12: ffff8101c000f780
R13: 0000000000000001 R14: 0000000a7bcffd6e R15: 0000000000000003
FS:  00002b9ef1d40ae0(0000) GS:ffff8101c07b6e40(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000020 CR3: 0000000100f8d000 CR4: 00000000000006e0
Process boot (pid: 900, threadinfo ffff8101014de000, task
ffff8101014dd490)
Stack:  0000038c802848cf ffff8101014dfef8 ffffffff80238d82
ffff8101014dd490
 ffffffffffffffd0 ffff8101014dd630 0000000000000000 00007fffb955ff80
 00007fffb9560090 0000000000000000 ffffffff802099be ffff8101014dff48
Call Trace:
 [<ffffffff80238d82>] recalc_sigpending+0x12/0x20
 [<ffffffff802099be>] system_call+0x7e/0x83
 [<ffffffff80207ef3>] sys_clone+0x23/0x30
 [<ffffffff80209a28>] sysret_careful+0xd/0x10


Code: 48 39 47 50 74 38 48 c7 47 40 00 00 00 00 48 63 56 f4 49 8b
RIP  [<ffffffff804ec090>] __sched_text_start+0x460/0x889
 RSP <ffff8101014dfee0>
CR2: 0000000000000020



