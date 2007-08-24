Return-Path: <linux-kernel-owner+w=401wt.eu-S932849AbXHXGJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbXHXGJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 02:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbXHXGJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 02:09:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53410 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbXHXGJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 02:09:30 -0400
Date: Fri, 24 Aug 2007 08:09:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bruce Ashfield <bruce.ashfield@windriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v20, for v2.6.22.5, v2.6.21.7,
	v2.6.20.16
Message-ID: <20070824060926.GA29166@elte.hu>
References: <20070823094346.GA26281@elte.hu> <3bd6b93c0708231843m1e94e192i6a806ce18c266f69@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bd6b93c0708231843m1e94e192i6a806ce18c266f69@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4804]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bruce Ashfield <bruce.ashfield@windriver.com> wrote:

> On 8/23/07, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > By popular demand, here is release -v20 of the CFS scheduler. It is a
> > full backport of the latest & greatest v2.6.23-rc3 CFS code to
> > v2.6.22.5, v2.6.21.7 and v2.6.20.16. The patches can be downloaded from
> > the usual place:
> 
> Ingo,
> 
> Great to see the older kernels updated, thanks for the patches. I've 
> got a bit of a modified 2.6.21.7, but when I built with 
> CONFIG_FAIR_GROUP_SCHED=y, I need the following change to make things 
> right (On a quick glance, my change matches the 2.6.23-rc3 code). Then 
> again, I may just be doing something stupid.
> 
> My apologies in advance if gmail decides to mangle the patch.
> 
> --- a/kernel/sched_fair.c.orig	2007-08-23 21:25:08.000000000 -0400
> +++ a/kernel/sched_fair.c	2007-08-23 21:25:18.000000000 -0400
> @@ -1057,7 +1057,7 @@ static void task_new_fair(struct rq *rq,
>   */
>  static void set_curr_task_fair(struct rq *rq)
>  {
> -	struct sched_entity *se = &rq->curr.se;
> +	struct sched_entity *se = &rq->curr->se;

thanks, applied.

	Ingo
