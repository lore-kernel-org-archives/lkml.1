Return-Path: <linux-kernel-owner+w=401wt.eu-S934309AbYBUQgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309AbYBUQgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933778AbYBUQf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:35:56 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:56580 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934098AbYBUQfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:35:55 -0500
Date: Thu, 21 Feb 2008 08:35:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, gregkh <greg@kroah.com>
Subject: Re: 2.6.25-rc2-git4 BUG: sysfs_readdir
Message-Id: <20080221083529.a07fa66b.randy.dunlap@oracle.com>
In-Reply-To: <20080221082553.ddc4e723.randy.dunlap@oracle.com>
References: <20080221082553.ddc4e723.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 08:25:53 -0800 Randy Dunlap wrote:

> One of my (x86_64) test machines got this on booting 2.6.25-rc2-git4.

bah.  Make that 2.6.25-rc2-git5.  :(


> insmod used greatest stack depth: 4144 bytes left
> EXT3-fs: INFO: recovery required on readonly filesystem.
> EXT3-fs: write access will be enabled during recovery.
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: recovery complete.
> EXT3-fs: mounted filesystem with ordered data mode.
> modprobe used greatest stack depth: 3600 bytes left
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffff802d0f16>] sysfs_readdir+0xe0/0x13f
> PGD 0
> Oops: 0000 [1] SMP
> CPU 2
> Modules linked in: cciss ehci_hcd ohci_hcd uhci_hcd
> Pid: 697, comm: udevtrigger Not tainted 2.6.25-rc2-git5 #1
> RIP: 0010:[<ffffffff802d0f16>]  [<ffffffff802d0f16>] sysfs_readdir+0xe0/0x13f
> RSP: 0018:ffff81027e8c3eb8  EFLAGS: 00010286
> RAX: 0000000000000000 RBX: ffff81027fb35a50 RCX: ffffffffffffffff
> RDX: 0000000000000020 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff81027e8c3ee8 R08: 000000006765b9c6 R09: 000000000000000a
> R10: 0000000000000000 R11: 0000000000000202 R12: ffff81027e093b40
> R13: ffffffff80299e04 R14: ffff81027e8c3f38 R15: ffffffff80299e04
> FS:  00007ffe6743f710(0000) GS:ffff81027f88c680(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 000000027e8d6000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process udevtrigger (pid: 697, threadinfo ffff81027e8c2000, task ffff81027e5fa000)
> Stack:  ffff81027f467280 ffff81027f467338 ffff81027e093b40 00000000fffffffe
>  ffff81027f467280 ffff81027f467338 ffff81027e8c3f28 ffffffff80299f33
>  ffff81027e8c3f38 00007ffe6765b618 00000000fffffff7 ffff81027e093b40
> Call Trace:
>  [<ffffffff80299f33>] vfs_readdir+0x6a/0x9f
>  [<ffffffff8029a1b1>] sys_getdents+0x7a/0xc5
>  [<ffffffff8020bf5b>] system_call_after_swapgs+0x7b/0x80
> 
> 
> Code: 00 48 8b 5b 28 eb 04 48 8b 5b 10 48 85 db 74 62 48 8b 43 38 49 39 44 24 38 77 ec eb 40 48 8b 73 18 31 c0 48 83 c9 ff fc 48 89 f7 <f2> ae 4c 89 f7 48 f7 d1 48 8d 41 ff 48 8b 4b 38 89 c2 49 89 4c
> RIP  [<ffffffff802d0f16>] sysfs_readdir+0xe0/0x13f
>  RSP <ffff81027e8c3eb8>
> CR2: 0000000000000000
> ---[ end trace b4dedabc6a9f743a ]---


---
~Randy
