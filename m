Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbZIJRDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbZIJRDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 13:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZIJRDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 13:03:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40095 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbZIJRDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 13:03:51 -0400
Date: Thu, 10 Sep 2009 19:03:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bret Towe <magnade@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nikos Chantziaras <realnc@arcor.de>, Jens Axboe <jens.axboe@oracle.com>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910170342.GA17041@elte.hu>
References: <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <20090909180404.GA11027@elte.hu> <4AA80C1E.2080901@arcor.de> <20090910060824.GF1335@elte.hu> <dda83e780909100902s32f076e7o87cebbbfc40d6dea@mail.gmail.com> <1252598709.7360.0.camel@twins> <dda83e780909100912t45eeeb9cj5179edda565526bc@mail.gmail.com> <20090910162611.GA31265@elte.hu> <dda83e780909100933q28cd1e06kcbceec53d2c94936@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dda83e780909100933q28cd1e06kcbceec53d2c94936@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bret Towe <magnade@gmail.com> wrote:

> On Thu, Sep 10, 2009 at 9:26 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Bret Towe <magnade@gmail.com> wrote:
> >
> >> On Thu, Sep 10, 2009 at 9:05 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >> > On Thu, 2009-09-10 at 09:02 -0700, Bret Towe wrote:
> >> >>
> >> >> thanks to this thread and others I've seen several kernel tunables
> >> >> that can effect how the scheduler performs/acts
> >> >> but what I don't see after a bit of looking is where all these are
> >> >> documented
> >> >> perhaps thats also part of the reason there are unhappy people with
> >> >> the current code in the kernel just because they don't know how
> >> >> to tune it for their workload
> >> >
> >> > The thing is, ideally they should not need to poke at these.
> >> > These knobs are under CONFIG_SCHED_DEBUG, and that is exactly
> >> > what they are for.
> >>
> >> even then I would think they should be documented so people can
> >> find out what item is hurting their workload so they can better
> >> report the bug no?
> >
> > Would be happy to apply such documentation patches. You could also
> > help start adding a 'scheduler performance' wiki portion to
> > perf.wiki.kernel.org, if you have time for that.
> 
> time isn't so much the issue but not having any clue as to what 
> any of the options do

One approach would be to list them in an email in this thread with 
question marks and let people here fill them in - then help by 
organizing and prettifying the result on the wiki.

Asking for clarifications when an explanation is unclear is also 
helpful - those who write this code are not the best people to judge 
whether technical descriptions are understandable enough.

	Ingo
