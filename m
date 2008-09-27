Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbYI0SW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbYI0SW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYI0SWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:22:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33308 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbYI0SWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:22:21 -0400
Date: Sat, 27 Sep 2008 20:22:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: trivial fix for incorrect comments
Message-ID: <20080927182208.GA12274@elte.hu>
References: <48D3C9FF.20504@nortel.com> <20080922110049.GA5987@elte.hu> <48D91464.9010501@nortel.com> <20080927181042.GD1108@elte.hu> <1222539550.16700.307.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222539550.16700.307.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Sat, 2008-09-27 at 20:10 +0200, Ingo Molnar wrote:
> > * Chris Friesen <cfriesen@nortel.com> wrote:
> > 
> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -298,9 +298,9 @@ static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
> > > static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
> > > static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
> > > #endif /* CONFIG_RT_GROUP_SCHED */
> > > -#else /* !CONFIG_FAIR_GROUP_SCHED */
> > > +#else /* !CONFIG_USER_SCHED */
> > > #define root_task_group init_task_group
> > > -#endif /* CONFIG_FAIR_GROUP_SCHED */
> > > +#endif /* CONFIG_USER_SCHED */
> > 
> > hm, these seem to be fixed already, via:
> > 
> > | commit 9a7e0b180da21885988d47558671cf580279f9d6
> > | Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > | Date:   Tue Aug 19 12:33:06 2008 +0200
> > |
> > |     sched: rt-bandwidth fixes
> > 
> > is all in tip/master.
> > 
> > (or is perhaps the direction of your patch wrong?)
> 
> No I think he got it right, as I vaguely remember fixing it too - now 
> I know where I left it ;-)
> 
> I often leave such trivial comment fixes in whatever patch I'm working 
> on at that moment.

that's OK. The risk is of course that if the other bits of this commit 
break something, and we drop or revert the commit, we drop the cleanup 
as well. But the patch was perfect in this case so all is fine :-)

	Ingo
