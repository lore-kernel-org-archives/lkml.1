Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbZHEBai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbZHEBai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 21:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbZHEBai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 21:30:38 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:53040 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004AbZHEBag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 21:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LhPUvXodHybnZbncMTNDl68Tp5JoTaShMeoGDqP1EEWcE0dAIgAWCB7RTRh6y5WRG2
         CVHGs6M+CbDKa0eM0rcvle9iyjo9xJdWVzvSbtSUbuUsUQZOBQDnFRpLNn0Co305YN8e
         dA1fBF2g7OGnOJ939m/dHFVm6Tohd62GejckY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	 <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	 <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	 <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	 <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	 <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	 <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
Date: Tue, 4 Aug 2009 18:30:36 -0700
X-Google-Sender-Auth: ef04101d43bcb996
Message-ID: <1f1b08da0908041830ybd718e6o2dde7eb05a48d590@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 5:48 PM, Thomas Gleixner<tglx@linutronix.de> wrote:
>   2) I'm going on vacation for 10 days. Please send patches and
>   bugreports^Wsuccess stories to the mailinglist as usual. There are
>   folks looking out.

I'm seeing the following if CONFIG_PREEMPT_RT is disabled:

Freeing unused kernel memory: 636k freed
Write protecting the kernel read-only data: 11512k
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff810b330b>] pagevec_move_tail+0x2b/0x140
PGD 0
Oops: 0000 [#1] SMP
last sysfs file:
CPU 1
Pid: 1, comm: init Tainted: G        W  2.6.31-rc4-rt1tirq #7 IBM
eServer BladeCenter LS20 -[885065U]-
RIP: 0010:[<ffffffff810b330b>]  [<ffffffff810b330b>]
pagevec_move_tail+0x2b/0x140
RSP: 0018:ffff880111a818a0  EFLAGS: 00010046
RAX: 0000000000000001 RBX: 0000000000000206 RCX: 0000000000000000
RDX: 0000000003b70630 RSI: 0000000000000000 RDI: ffff880028045c60
RBP: ffff880111a818d0 R08: 0000000000000000 R09: ffff88010f4e3d30
R10: 0000000000000002 R11: 00000000ca416065 R12: 0000000000000000
R13: ffff880028045c60 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880028037000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000010f44c000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process init (pid: 1, threadinfo ffff880111a80000, task ffff880111a7b770)
Stack:
 ffff88010f44dad8 0000000000000206 0000000000000005 0000000000000001
<0> ffff88010f44dad8 00007fffd7d6a000 ffff880111a81900 ffffffff810b3481
<0> 00000000fffffff4 0000000000001000 00000000fffffff4 00007fffffffe000
Call Trace:
 [<ffffffff810b3481>] lru_add_drain+0x61/0x80
 [<ffffffff810e7547>] setup_arg_pages+0x1b7/0x3b0
 [<ffffffff810ea0d5>] ? inode_permission+0x65/0xb0
 [<ffffffff8133eb9b>] ? get_random_int+0x5b/0x60
 [<ffffffff81122a34>] load_elf_binary+0x4d4/0x1e40
 [<ffffffff810ab276>] ? generic_file_aio_read+0x5e6/0x640
 [<ffffffff810e1b51>] ? do_sync_read+0xf1/0x130
 [<ffffffff812d3d11>] ? strrchr+0x11/0x30
 [<ffffffff81120530>] ? load_misc_binary+0x80/0x3d0
 [<ffffffff810e620f>] search_binary_handler+0x9f/0x1e0
 [<ffffffff8112101e>] load_script+0x1ee/0x240
 [<ffffffff810c2b42>] ? get_user_pages+0x32/0x40
 [<ffffffff810e5ecb>] ? get_arg_page+0x4b/0xb0
 [<ffffffff810e5e79>] ? put_arg_page+0x9/0x10
 [<ffffffff810e620f>] search_binary_handler+0x9f/0x1e0
 [<ffffffff810e7b2e>] do_execve+0x27e/0x340
 [<ffffffff8100a409>] sys_execve+0x49/0x70
 [<ffffffff8100ccb8>] kernel_execve+0x68/0xd0
 [<ffffffff8100918e>] ? run_init_process+0x1e/0x20
 [<ffffffff81009206>] init_post+0x76/0x110
 [<ffffffff81c38ace>] kernel_init+0x22e/0x250
 [<ffffffff8100cc3a>] child_rip+0xa/0x20
 [<ffffffff81c388a0>] ? kernel_init+0x0/0x250
 [<ffffffff8100cc30>] ? child_rip+0x0/0x20
Code: 55 31 c9 48 89 e5 41 57 41 56 41 55 49 89 fd 41 54 53 48 83 ec
08 8b 17 85 d2 0f 84 d3 00 00 00 45 31 ff 45 31 f6 4f 8b 64 f5 10 <49>
8b 04 24 48 89 c2 48 c1 e8 38 83 e0 03 48 c1 ea 3a 48 8d 04
RIP  [<ffffffff810b330b>] pagevec_move_tail+0x2b/0x140
 RSP <ffff880111a818a0>
CR2: 0000000000000000
---[ end trace 93761b2e97bc6de2 ]---


thanks
-john
