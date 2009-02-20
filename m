Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZBTD7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZBTD7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZBTD7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:59:45 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37500 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZBTD7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:59:44 -0500
In-Reply-To: <a4423d670902190651t71638aaepbc2ba49b9b6a25c6@mail.gmail.com>
References: <a4423d670902190651t71638aaepbc2ba49b9b6a25c6@mail.gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>
MIME-Version: 1.0
Subject: Re: next-20090219: IMA: kernel BUG at include/linux/scatterlist.h:65
X-KeepSent: B35A95E1:5680E4C1-85257563:000DA64A;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OFB35A95E1.5680E4C1-ON85257563.000DA64A-85257563.0015F211@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Thu, 19 Feb 2009 22:59:42 -0500
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.5|December 05, 2008) at
 02/19/2009 22:59:42,
	Serialize complete at 02/19/2009 22:59:42
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov <a.beregalov@gmail.com> wrote on 02/19/2009 09:51:12 
AM:

> Hi
> 
>  kernel BUG at include/linux/scatterlist.h:65!
>  invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>  last sysfs file:
>  CPU 2
>  Modules linked in:
>  Pid: 1, comm: swapper Not tainted 2.6.29-rc5-next-20090219 #5 PowerEdge 
1950
>  RIP: 0010:[<ffffffff8045ec70>]  [<ffffffff8045ec70>] 
ima_calc_hash+0xc0/0x160
>  RSP: 0018:ffff88007f46bc40  EFLAGS: 00010286
>  RAX: ffffe200032c45e8 RBX: 00000000fffffff4 RCX: 0000000087654321
>  RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffff88007cf71048
>  RBP: ffff88007f46bcd0 R08: 0000000000000000 R09: 0000000000000163
>  R10: ffff88007f4707a8 R11: 0000000000000000 R12: ffff88007cf71048
>  R13: 0000000000001000 R14: 0000000000000000 R15: 0000000000009d98
>  FS:  0000000000000000(0000) GS:ffff8800051ac000(0000) 
knlGS:0000000000000000
>  CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>  CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Process swapper (pid: 1, threadinfo ffff88007f46a000, task 
ffff88007f470000)
>  Stack:
>   ffffffff8045e49e 0000004800000246 ffff88007cfbc3b8 ffff88007c853980
>   ffffffff8045e49e 0000000000000002 ffff88007cfbc440 ffff88007cfbc418
>   2222222222222222 2222222222222222 ffff88007d878b88 2222222200000000
>  Call Trace:
>   [<ffffffff8045e49e>] ? process_measurement+0x9e/0x110
>   [<ffffffff8045e49e>] ? process_measurement+0x9e/0x110

The patch I posted on linux-next resolves this bug
(http://marc.info/?l=linux-next&m=123509665514552&w=2).

Mimi Zohar
