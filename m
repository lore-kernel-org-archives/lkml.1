Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbYHULDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbYHULDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758910AbYHULDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:03:05 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:28647 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758510AbYHULDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id:sender;
        b=UBjy5EKzbTO+uhAq2gBu2vA2DcauZN037OWYlzMwX0GdP+Ra6pL0wLN0CyXeQrXxBB
         aUmkXmPjyCHUOaYv4Hqe+NxBPGsTOfDVSLWXXd7eUjvoGG8en9krGajE1S3DevtnX/XI
         rsv8Q8On7UMSo/YciVe8kCHH8AzP6EPneDG24=
From: Eric Lacombe <tuxiko@free.fr>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: EXT3-fs error
Date: Thu, 21 Aug 2008 13:02:55 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
References: <200808211106.39574.tuxiko@free.fr> <20080821104626.0a10f40c@lxorguk.ukuu.org.uk>
In-Reply-To: <20080821104626.0a10f40c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211302.55530.tuxiko@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 11:46:26 Alan Cox wrote:
> On Thu, 21 Aug 2008 11:06:39 +0200
>
> Eric Lacombe <tuxiko@free.fr> wrote:
> > Hi,
> >
> > Recently, my computer freezes a lot, and I noted the problems below. I
> > wonder if my hard disk is going die.
> > Can someone confirm or infirm my suspicion?
>
> Might be worth running memtest86 on the box overnight and seeing if its
> memory or other problems. smartmontools will give you info on the disk
> status (as the disk sees it) which can sometimes give clues.

I will run memtest86 very soon. But in the meantime my computer just crashed.
The logs are presented below (I know that the module nvidia is loaded, but I 
never have problem with it before.).
I remark that a general protection fault occur, and I saw a lot of them 
recently (see also the second log trail for another error 2 hours earlier). 

Aug 21 12:29:14 hoth general protection fault: 0000 [1] PREEMPT SMP
Aug 21 12:29:14 hoth CPU 0
Aug 21 12:29:14 hoth Modules linked in: nvidia(P) atl1
Aug 21 12:29:14 hoth Pid: 11618, comm: configure Tainted: P          2.6.26.2 
#16
Aug 21 12:29:14 hoth RIP: 0010:[<ffffffff80286969>]  [<ffffffff80286969>] 
remove_vma+0x19/0x60
Aug 21 12:29:14 hoth RSP: 0018:ffff81014b1dfe88  EFLAGS: 00010206
Aug 21 12:29:14 hoth RAX: 1000000000000000 RBX: ffff81006e414c78 RCX: 
ffffffff8028699a
Aug 21 12:29:14 hoth RDX: ffff81006e4142a0 RSI: ffffe20001b90500 RDI: 
ffff81006e414c78
Aug 21 12:29:14 hoth RBP: ffff81006e414dc8 R08: 0000000000000000 R09: 
0000000000000000
Aug 21 12:29:14 hoth R10: 0000000000000002 R11: 00000000000001d9 R12: 
ffff81003c1609c0
Aug 21 12:29:14 hoth R13: 0000000000000000 R14: 00000000ffffffff R15: 
000000000076e350
Aug 21 12:29:14 hoth FS:  0000000000000000(0000) GS:ffffffff808a4000(0000) 
knlGS:0000000000000000
Aug 21 12:29:14 hoth CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 21 12:29:14 hoth CR2: 00007f83d24154c0 CR3: 0000000000201000 CR4: 
00000000000006e0
Aug 21 12:29:14 hoth DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
Aug 21 12:29:14 hoth DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
Aug 21 12:29:14 hoth Process configure (pid: 11618, threadinfo 
ffff81014b1de000, task ffff81015dd4de00)
Aug 21 12:29:14 hoth Stack:  0000000000000000 ffff8100010296e0 
ffff81006e414c78 ffffffff80286a8a
Aug 21 12:29:14 hoth 000000000000011e ffff8100010296e0 ffff81003c1609c0 
ffff81003c160a40
Aug 21 12:29:14 hoth 00007f83d26e1878 ffffffff80236174 0000000000000000 
ffff81015dd4de00
Aug 21 12:29:14 hoth Call Trace:
Aug 21 12:29:14 hoth [<ffffffff80286a8a>] ? exit_mmap+0xda/0x130
Aug 21 12:29:14 hoth [<ffffffff80236174>] ? mmput+0x44/0xd0
Aug 21 12:29:14 hoth [<ffffffff8023c435>] ? do_exit+0x1b5/0x7f0
Aug 21 12:29:14 hoth [<ffffffff8023caa3>] ? do_group_exit+0x33/0xa0
Aug 21 12:29:14 hoth [<ffffffff8020b61b>] ? system_call_after_swapgs+0x7b/0x80
Aug 21 12:29:14 hoth
Aug 21 12:29:14 hoth
Aug 21 12:29:14 hoth Code: b8 48 c7 c2 f4 ff ff ff eb c8 0f 1f 84 00 00 00 00 
00 55 53 48 89 fb 48 83 ec 08 48 8b 87 80 00 00 00 48 8b 6f 18 48 85 c0 74 0b 
<48> 8b 40 08 48 85 c0 74 02 ff d0 48 8b bb 90 00 00 00 48 85 ff
Aug 21 12:29:14 hoth RIP  [<ffffffff80286969>] remove_vma+0x19/0x60
Aug 21 12:29:14 hoth RSP <ffff81014b1dfe88>
Aug 21 12:29:14 hoth ---[ end trace b34a2473ba7584d0 ]---
Aug 21 12:29:14 hoth Fixing recursive fault but reboot is needed!

======

I also had these logs just before another crash. I see a "scheduling while 
atomic" does it seems it will be a kernel bug ?


Aug 21 10:48:35 hoth general protection fault: 0000 [1] PREEMPT SMP
Aug 21 10:48:35 hoth CPU 0
Aug 21 10:48:35 hoth Modules linked in: nvidia(P) atl1
Aug 21 10:48:35 hoth Pid: 22405, comm: scanelf Tainted: P          2.6.26.2 
#16
Aug 21 10:48:35 hoth RIP: 0010:[<ffffffff803e1b10>]  [<ffffffff803e1b10>] 
prio_tree_insert+0x1d0/0x270
Aug 21 10:48:35 hoth RSP: 0018:ffff810164317d80  EFLAGS: 00010206
Aug 21 10:48:35 hoth RAX: 1000000000000000 RBX: 1000000000000000 RCX: 
0000000000000000
Aug 21 10:48:35 hoth RDX: 0000000000010002 RSI: 0000000000000002 RDI: 
ffff81006dc75978
Aug 21 10:48:35 hoth RBP: ffff81006dc75978 R08: ffff810164317d98 R09: 
0000000000000000
Aug 21 10:48:35 hoth R10: ffff81017ecd3c00 R11: 0000000000000000 R12: 
ffff8101624f9780
Aug 21 10:48:35 hoth R13: 0000000000000002 R14: 0000000000000000 R15: 
ffff8101624f9780
Aug 21 10:48:35 hoth FS:  00007ffc6b9886f0(0000) GS:ffffffff808a4000(0000) 
knlGS:0000000000000000
Aug 21 10:48:35 hoth CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 21 10:48:35 hoth CR2: 00007ffc6b9b6000 CR3: 0000000165f92000 CR4: 
00000000000006e0
Aug 21 10:48:35 hoth DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
Aug 21 10:48:35 hoth DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
Aug 21 10:48:35 hoth Process scanelf (pid: 22405, threadinfo ffff810164316000, 
task ffff810013c84680)
Aug 21 10:48:35 hoth Stack:  ffffffff806b5620 ffff8101624f9738 
0000000000000002 0000000000000000
Aug 21 10:48:35 hoth ffff8101624f9780 ffff8101624f9738 ffff8101624396c0 
ffff8101624396c8
Aug 21 10:48:35 hoth ffff81006dc75958 ffff810162439690 ffffffff8027ef38 
ffff8101624396c8
Aug 21 10:48:35 hoth Call Trace:
Aug 21 10:48:35 hoth [<ffffffff8027ef38>] ? vma_prio_tree_insert+0x28/0x60
Aug 21 10:48:35 hoth [<ffffffff80287b83>] ? vma_link+0xb3/0x150
Aug 21 10:48:35 hoth [<ffffffff80288672>] ? mmap_region+0x442/0x4d0
Aug 21 10:48:35 hoth [<ffffffff80288e92>] ? do_mmap_pgoff+0x3c2/0x3f0
Aug 21 10:48:35 hoth [<ffffffff80210c0c>] ? sys_mmap+0x10c/0x140
Aug 21 10:48:35 hoth [<ffffffff8020b61b>] ? system_call_after_swapgs+0x7b/0x80
Aug 21 10:48:35 hoth
Aug 21 10:48:35 hoth
Aug 21 10:48:35 hoth Code: 41 5f c3 48 89 de 48 89 ef 49 89 dc e8 6a fd ff ff 
48 89 5b 10 48 89 5b 08 49 89 de 48 89 1b 8b 55 08 e9 50 ff ff ff 49 89 04 24 
<4c> 89 60 10 eb bc ff c2 66 89 55 08 e9 35 ff ff ff 48 39 f2 0f
Aug 21 10:48:35 hoth RIP  [<ffffffff803e1b10>] prio_tree_insert+0x1d0/0x270
Aug 21 10:48:35 hoth RSP <ffff810164317d80>
Aug 21 10:48:35 hoth ---[ end trace 25a7f9dc7f0a7b26 ]---
Aug 21 10:48:35 hoth note: scanelf[22405] exited with preempt_count 1
Aug 21 10:48:35 hoth BUG: scheduling while atomic: scanelf/22405/0x00000002
Aug 21 10:48:35 hoth Pid: 22405, comm: scanelf Tainted: P      D   2.6.26.2 
#16
Aug 21 10:48:35 hoth
Aug 21 10:48:35 hoth Call Trace:
Aug 21 10:48:35 hoth [<ffffffff806874d7>] thread_return+0x498/0x511
Aug 21 10:48:35 hoth [<ffffffff8023967e>] printk+0x4e/0x60
Aug 21 10:48:35 hoth [<ffffffff80688b79>] __down_read+0x79/0xb1
Aug 21 10:48:35 hoth [<ffffffff80262322>] acct_collect+0x42/0x1b0
Aug 21 10:48:35 hoth [<ffffffff8023c3fa>] do_exit+0x17a/0x7f0
Aug 21 10:48:35 hoth [<ffffffff8022ebb3>] __wake_up+0x43/0x70
Aug 21 10:48:35 hoth [<ffffffff8020c8e7>] oops_end+0x87/0x90
Aug 21 10:48:35 hoth [<ffffffff806893b9>] error_exit+0x0/0x51
Aug 21 10:48:35 hoth [<ffffffff803e1b10>] prio_tree_insert+0x1d0/0x270
Aug 21 10:48:35 hoth [<ffffffff8027ef38>] vma_prio_tree_insert+0x28/0x60
Aug 21 10:48:35 hoth [<ffffffff80287b83>] vma_link+0xb3/0x150
Aug 21 10:48:35 hoth [<ffffffff80288672>] mmap_region+0x442/0x4d0
Aug 21 10:48:35 hoth [<ffffffff80288e92>] do_mmap_pgoff+0x3c2/0x3f0
Aug 21 10:48:35 hoth [<ffffffff80210c0c>] sys_mmap+0x10c/0x140
Aug 21 10:48:35 hoth [<ffffffff8020b61b>] system_call_after_swapgs+0x7b/0x80
Aug 21 10:48:35 hoth

>
> Alan

I hope this could give you some hint.

Thanks in advance.

	Eric
