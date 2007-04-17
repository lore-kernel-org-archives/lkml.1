Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbXDQHkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbXDQHkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbXDQHkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:40:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34025 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbXDQHkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:40:01 -0400
Date: Tue, 17 Apr 2007 09:39:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417073922.GA3233@elte.hu>
References: <20070416220715.GA4071@elte.hu> <200704170053.58611.gene.heskett@gmail.com> <20070417061849.GA12385@elte.hu> <20070417070132.GA27261@elte.hu> <Pine.LNX.4.64.0704170029350.30516@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704170029350.30516@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> > ok, i've got something better to test: i separated the delta out 
> > into a more finegrained stack of 3 patches. You can pick them up 
> > from:
> > 
> >  http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0.patch
> >  http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0-preempt-fix.patch
> >  http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0-child-runs-first.patch
> >  http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0-misc.patch
> 
> Isn't that easier for everyone if you keep them as quilt series (ala 
> syslets)?

i _do_ have a quilt tree, but i never had the clean splitup above. Why? 
Because i worked on all of these aspects (and a whole lot of other 
aspects as well) in parallel during the past 2 days, back and forth, 
often mixing changes, etc. and there was never any clean splitup.

Now it turned out that the clean splitup of -rc0->final delta would ease 
Gene's testing so i created it. Note that this is just 30% of the total 
v1->v2 delta and i just saved the work of having to do a clean splitup 
of the other 70%. (and note that this splitup will be undone because it 
makes no sense for any potential upstream merge at all, it's only to 
ease testing for Gene)

	Ingo
