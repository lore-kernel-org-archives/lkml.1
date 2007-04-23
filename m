Return-Path: <linux-kernel-owner+w=401wt.eu-S1161256AbXDWGXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161256AbXDWGXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161242AbXDWGXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:23:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43586 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161256AbXDWGXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:23:36 -0400
Date: Mon, 23 Apr 2007 08:21:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] CFS scheduler, -v5
Message-ID: <20070423062116.GB4518@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu> <20070423051659.GA3929@gentoox2.trippelsdorf.de> <20070423052728.GB3929@gentoox2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423052728.GB3929@gentoox2.trippelsdorf.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> > The new version does not link here (amd64,smp):
> > 
> >   LD      .tmp_vmlinux1
> >   arch/x86_64/kernel/built-in.o:(.rodata+0x1dd8): undefined reference to
> >   `sys_yield_to'
> 
> Changing sys_yield_to to sys_sched_yield_to in 
> include/asm-x86_64/unistd.h fixes the problem.

thanks. I edited the -v5 patch so new downloads should have the fix. (i 
also test-booted x86_64 with this patch)

	Ingo
