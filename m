Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbXEMWrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbXEMWrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 18:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXEMWrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 18:47:24 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755186AbXEMWrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 18:47:24 -0400
Date: Sun, 13 May 2007 15:47:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas.Mailhot@LaPoste.net
Cc: "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug 8473] New: Oops: 0010 [1] SMP
Message-Id: <20070513154718.bb338ceb.akpm@linux-foundation.org>
In-Reply-To: <200705132102.l4DL2onF003014@fire-2.osdl.org>
References: <200705132102.l4DL2onF003014@fire-2.osdl.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 14:02:50 -0700 bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8473

Please follow up via emailed reply-to-all.

In fact, please report -mm bugs via email.  bugzilla is more suited to
longer-term problems, and -mm bugs are super-short-term, we hope.


>            Summary: Oops: 0010 [1] SMP
>     Kernel Version: 2.6.21-mm2
>             Status: NEW
>           Severity: high
>              Owner: akpm@osdl.org
>          Submitter: Nicolas.Mailhot@LaPoste.net
> 
> 
> Most recent kernel where this bug did *NOT* occur: 2.6.21-mm1 (though I didn't
> test it that long)
> Distribution: Fedora Devel
> Hardware Environment: AMD C2 on CK804
> Software Environment: Normal workload (building a small package)
> Problem Description:
> 
> Steps to reproduce:
> May 13 22:59:43 rousalka kernel: Unable to handle kernel NULL pointer
> dereference at 0000000000000000 RIP: 
> May 13 22:59:43 rousalka kernel: [<0000000000000000>]
> May 13 22:59:43 rousalka kernel: PGD bf1a067 PUD f295067 PMD 0 
> May 13 22:59:43 rousalka kernel: Oops: 0010 [1] SMP 
> May 13 22:59:43 rousalka kernel: CPU 0 
> May 13 22:59:43 rousalka kernel: Pid: 8758, comm: bash Not tainted
> 2.6.21-9.mm2.fc7.nim #1
> May 13 22:59:43 rousalka kernel: RIP: 0010:[<0000000000000000>] 
> [<0000000000000000>]
> May 13 22:59:43 rousalka kernel: RSP: 0018:ffff81000ffedee0  EFLAGS: 00010296
> May 13 22:59:43 rousalka kernel: RAX: ffffffff804426a0 RBX: ffff81000abe6a80
> RCX: 00007fff565bbdc4
> May 13 22:59:43 rousalka kernel: RDX: 0000000000005410 RSI: ffff81000abe6a80
> RDI: ffff810009cc6fa0
> May 13 22:59:43 rousalka kernel: RBP: 00007fff565bbdc4 R08: 0000000000000000
> R09: 00000000009033a4
> May 13 22:59:43 rousalka kernel: R10: 0000000000000008 R11: 0000000000000246
> R12: 0000000000005410
> May 13 22:59:43 rousalka kernel: R13: 00000000000000ff R14: 00000000000000ff
> R15: 0000000000000000
> May 13 22:59:43 rousalka kernel: FS:  00002b2d544faf40(0000)
> GS:ffffffff8056b000(0000) knlGS:0000000000000000
> May 13 22:59:43 rousalka kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> May 13 22:59:43 rousalka kernel: CR2: 0000000000000000 CR3: 000000000bdf4000
> CR4: 00000000000006e0
> May 13 22:59:43 rousalka kernel: Process bash (pid: 8758, threadinfo
> ffff81000ffec000, task ffff81000bc82ac0)
> May 13 22:59:43 rousalka kernel: Stack:  ffffffff8028545d ffff81000abe6a80
> 00007fff565bbdc4 00007fff565bbdc4
> May 13 22:59:43 rousalka kernel: ffffffff802856ca 0000000000005410
> 00000000000000ff ffff81000abe6a80
> May 13 22:59:43 rousalka kernel: 0000000000000000 00007fff565bbdc4
> 0000000000005410 00000000000000ff
> May 13 22:59:43 rousalka kernel: Call Trace:
> May 13 22:59:43 rousalka kernel: [<ffffffff8028545d>] do_ioctl+0x55/0x6b
> May 13 22:59:43 rousalka kernel: [<ffffffff802856ca>] vfs_ioctl+0x257/0x270
> May 13 22:59:43 rousalka kernel: [<ffffffff8028573c>] sys_ioctl+0x59/0x79
> May 13 22:59:43 rousalka kernel: [<ffffffff8020955c>] tracesys+0xdc/0xe1
> May 13 22:59:43 rousalka kernel: 
> May 13 22:59:43 rousalka kernel: INFO: lockdep is turned off.
> May 13 22:59:43 rousalka kernel: 
> May 13 22:59:43 rousalka kernel: Code:  Bad RIP value.
> May 13 22:59:43 rousalka kernel: RIP  [<0000000000000000>]
> May 13 22:59:43 rousalka kernel: RSP <ffff81000ffedee0>
> May 13 22:59:43 rousalka kernel: CR2: 0000000000000000

Anything you can do to make that wordwrapping go away for ever would be
great, thanks.

I don't know what would have caused this.  do_ioctl() did a jump-to-zero,
but it has code in there to explicitly test for null pointers.

Perhaps some weird race, although I find it hard to imagine how we could
have such a race in any ioctl which bash is likely to be calling.

Is it repeatable at all?
