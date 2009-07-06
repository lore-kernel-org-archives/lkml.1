Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZGFH0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZGFH0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 03:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbZGFH0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 03:26:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbZGFH0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 03:26:44 -0400
Date: Mon, 6 Jul 2009 09:26:47 +0200
From: Nick Piggin <npiggin@suse.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: 2.6.29.4: softlockup at find_get_page() et al
Message-ID: <20090706072647.GI2714@wotan.suse.de>
References: <20090616110051.GA4864@x200.localdomain> <20090616130833.GA27925@wotan.suse.de> <20090703140329.GA9546@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703140329.GA9546@x200.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 06:03:29PM +0400, Alexey Dobriyan wrote:
> On Tue, Jun 16, 2009 at 03:08:33PM +0200, Nick Piggin wrote:
> > On Tue, Jun 16, 2009 at 03:00:51PM +0400, Alexey Dobriyan wrote:
> > > Happened during overnight run when box was cross-compiling kernel slowly
> > > (only -j7).
> > > 
> > > Example messages:
> > > 
> > > [67287.109985] BUG: soft lockup - CPU#0 stuck for 61s! [conf:3980]
> > > [67287.110001] CPU 0:
> > > [67287.110001] Pid: 3980, comm: conf Not tainted 2.6.29.4-x86_64 #1 P5E
> > > [67287.110001] RIP: 0010:[<ffffffff80264902>]  [<ffffffff80264902>] find_get_page+0x52/0xb0
> > > [67287.110001] RSP: 0018:ffff8801001eddd8  EFLAGS: 00000246
> > > [67287.110001] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000034
> > > [67287.110001] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffffe200010a9f40
> > > [67287.110001] RBP: ffffffff8020c3ee R08: ffffe200010a9f48 R09: ffff8800aa798c28
> > > [67287.110001] R10: ffffe200010a9f40 R11: ffffffff802f9480 R12: ffff8800aa798c18
> > > [67287.110001] R13: ffffffff8020c3ee R14: ffffffff802f4e70 R15: 000000000000000c
> > > [67287.110001] FS:  0000000000000000(0000) GS:ffffffff8075b040(0063) knlGS:00000000557116c0
> > > [67287.110001] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> > > [67287.110001] CR2: 00000000556d9374 CR3: 000000012faa4000 CR4: 00000000000006e0
> > > [67287.110001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > [67287.110001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > [67287.110001] Call Trace:
> > > [67287.110001]  [<ffffffff802648cb>] ? find_get_page+0x1b/0xb0
> > > [67287.110001]  [<ffffffff80264bf3>] ? find_lock_page+0x23/0x80
> > > [67287.110001]  [<ffffffff80265631>] ? find_or_create_page+0x41/0xc0
> > > [67287.110001]  [<ffffffff802f4edd>] ? ext2_make_empty+0x2d/0x1f0
> > > [67287.110001]  [<ffffffff802f9556>] ? ext2_mkdir+0xd6/0x170
> > > [67287.110001]  [<ffffffff8029b37c>] ? sys_mkdirat+0x11c/0x130
> > > [67287.110001]  [<ffffffff802a585a>] ? alloc_fd+0x4a/0x140
> > > [67287.110001]  [<ffffffff8022ab14>] ? sysenter_dispatch+0x7/0x2b
> 
> memtest has found quite a lot of junk.

OK that's good to know (for Linux, maybe not for you!). Thanks
anyway for reporting, it is always helpful.

Thanks,
Nick
