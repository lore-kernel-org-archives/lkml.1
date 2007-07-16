Return-Path: <linux-kernel-owner+w=401wt.eu-S1760911AbXGPSvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbXGPSvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbXGPSvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:51:04 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:35761 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760068AbXGPSvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:51:00 -0400
Message-ID: <469BBE07.2010606@namesys.com>
Date: Mon, 16 Jul 2007 22:50:47 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Zan Lynx <zlynx@acm.org>
CC: ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [patch 0/3] reiser4 fixups
References: <1184090582.6933.20.camel@localhost>	 <469523FA.7010308@namesys.com>  <46968F88.7070300@acm.org> <1184344914.468943.3.camel@localhost>
In-Reply-To: <1184344914.468943.3.camel@localhost>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zan Lynx wrote:
...

>Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
> [<ffffffff8033d324>] reiser4_tree_by_page+0x4/0x20
>PGD 17594067 PUD d025067 PMD 0 
>Oops: 0000 [1] PREEMPT SMP 
>CPU 0 
>Modules linked in: nls_iso8859_1 isofs nls_base snd_pcm_oss snd_mixer_oss netconsole ipv6 usbhid hid snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer psmouse serio_raw evdev snd snd_page_alloc ohci_hcd ehci_hcd usbcore sg
>Pid: 469720, comm: rhythmbox Not tainted 2.6.22-rc6-mm1 #4
>RIP: 0010:[<ffffffff8033d324>]  [<ffffffff8033d324>] reiser4_tree_by_page+0x4/0x20
>RSP: 0018:ffff81000ba03940  EFLAGS: 00010296
>RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000c
>RDX: 0000000000000559 RSI: 0000000000000000 RDI: ffff810001433a88
>RBP: ffff810001433a88 R08: 0000000000000000 R09: 0000000000000001
>R10: 0000000000000000 R11: ffffffff8035a350 R12: ffff810001433a88
>R13: ffff81000ba03a90 R14: ffff8100125e0224 R15: ffff8100125e0224
>FS:  0000000043806940(0063) GS:ffffffff8075b000(0000) knlGS:00000000f7cd76b0
>CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>CR2: 0000000000000000 CR3: 0000000004b9e000 CR4: 00000000000006e0
>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>Process rhythmbox (pid: 469720, threadinfo ffff81000ba02000, task ffff810013c4edd0)
>Stack:  ffffffff8032649a ffff81000ba03a90 0000000000000000 ffff810001433a88
> ffff81000ba03a58 ffff81000ba03a90 ffff8100125e0224 ffff8100125e0224
> ffffffff8034db75 ffff810000000002 ffff810000000002 ffff810000000002
>Call Trace:
> [<ffffffff8032649a>] jnode_of_page+0x2a/0x2c0
> [<ffffffff8034db75>] uf_readpages_filler+0x235/0x300
> [<ffffffff8034d940>] uf_readpages_filler+0x0/0x300
> [<ffffffff8028a586>] read_cache_pages+0x96/0xc0
> [<ffffffff8034dc96>] readpages_unix_file+0x56/0xc0
> [<ffffffff8028a381>] __do_page_cache_readahead+0x1e1/0x2c0
> [<ffffffff8028a66b>] ondemand_readahead+0xbb/0x120
> [<ffffffff80282bc6>] do_generic_mapping_read+0x1b6/0x4b0
> [<ffffffff80281fb0>] file_read_actor+0x0/0x1b0
> [<ffffffff80284f46>] generic_file_aio_read+0x106/0x1c0
> [<ffffffff802ad019>] do_sync_read+0xd9/0x120
> [<ffffffff802a723b>] check_bytes_and_report+0x4b/0x100
> [<ffffffff802a7704>] check_object+0x224/0x260
> [<ffffffff80254580>] autoremove_wake_function+0x0/0x30
> [<ffffffff8052e669>] _spin_unlock+0x29/0x50
> [<ffffffff80330e2c>] reiser4_grab+0x8c/0xd0
> [<ffffffff8034cf9f>] read_unix_file+0x49f/0x4c0
> [<ffffffff802ad995>] vfs_read+0xc5/0x180
> [<ffffffff802ade93>] sys_read+0x53/0x90
> [<ffffffff8020c1de>] system_call+0x7e/0x83
>
>  
>

This is bug in Zam's new file_read: unlocked page was reclaimed,
then reiser4_tree_by_page() looks at page->mapping->host.
The patch #3 fixes this problem.

Andrew, please apply the following series.

Thanks,
Edward.

>INFO: lockdep is turned off.
>
>Code: 48 8b 00 48 8b 80 d0 01 00 00 48 8b 80 18 04 00 00 48 83 c0 
>RIP  [<ffffffff8033d324>] reiser4_tree_by_page+0x4/0x20
> RSP <ffff81000ba03940>
>CR2: 0000000000000000
>  
>


