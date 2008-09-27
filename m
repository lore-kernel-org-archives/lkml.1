Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYI0STd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYI0STd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbYI0STR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:19:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53188 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbYI0STQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:19:16 -0400
Subject: Re: [patch] sched: trivial fix for incorrect comments
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080927181042.GD1108@elte.hu>
References: <48D3C9FF.20504@nortel.com> <20080922110049.GA5987@elte.hu>
	 <48D91464.9010501@nortel.com>  <20080927181042.GD1108@elte.hu>
Content-Type: text/plain
Date: Sat, 27 Sep 2008 20:19:09 +0200
Message-Id: <1222539550.16700.307.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-27 at 20:10 +0200, Ingo Molnar wrote:
> * Chris Friesen <cfriesen@nortel.com> wrote:
> 
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -298,9 +298,9 @@ static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
> > static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
> > static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
> > #endif /* CONFIG_RT_GROUP_SCHED */
> > -#else /* !CONFIG_FAIR_GROUP_SCHED */
> > +#else /* !CONFIG_USER_SCHED */
> > #define root_task_group init_task_group
> > -#endif /* CONFIG_FAIR_GROUP_SCHED */
> > +#endif /* CONFIG_USER_SCHED */
> 
> hm, these seem to be fixed already, via:
> 
> | commit 9a7e0b180da21885988d47558671cf580279f9d6
> | Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> | Date:   Tue Aug 19 12:33:06 2008 +0200
> |
> |     sched: rt-bandwidth fixes
> 
> is all in tip/master.
> 
> (or is perhaps the direction of your patch wrong?)

No I think he got it right, as I vaguely remember fixing it too - now I
know where I left it ;-)

I often leave such trivial comment fixes in whatever patch I'm working
on at that moment.



