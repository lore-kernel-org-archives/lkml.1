Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbYL0RjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbYL0RjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 12:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYL0RjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 12:39:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42339 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYL0RjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 12:39:01 -0500
Date: Sat, 27 Dec 2008 18:38:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Message-ID: <20081227173839.GA9793@elte.hu>
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu> <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> > ------------------>
> > Ingo Molnar (2):
> >      sparseirq: do not printk when migrating IRQ descriptors
> >      sparseirq: fix desc->lock init
> >
> > KOSAKI Motohiro (4):
> >      hrtimer: remove #include <linux/irq.h>
> >      irq: for_each_irq_desc() move to irqnr.h
> >      proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
> >      irq: simplify for_each_irq_desc() usage
> >
> > Yinghai Lu (4):
> >      sparseirq: remove duplicated arch_early_irq_init()
> >      sparseirq: work around compiler optimizing away __weak functions
> 
> Unfortunately, this workaround doesn't workaround.
> Kamalesh reported kernel still crashes.

well, it's a regression that is being worked on: certain buggy GCC 
versions (unclear yet what scope but quite rare it appears) optimize out 
__weak function calls incorrectly.

	Ingo
