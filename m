Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZIJKDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZIJKDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZIJKD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:03:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54844 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbZIJKD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:03:29 -0400
Date: Thu, 10 Sep 2009 12:03:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Nikos Chantziaras <realnc@arcor.de>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910100321.GA7922@elte.hu>
References: <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <20090909180404.GA11027@elte.hu> <4AA80C1E.2080901@arcor.de> <20090910060824.GF1335@elte.hu> <20090910064059.GA22646@elte.hu> <20090910095457.GD18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910095457.GD18599@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Sep 10 2009, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > However, the interactivity problems still remain.  Does that 
> > > > mean it's not a latency issue?
> > > 
> > > It means that Jens's test-app, which demonstrated and helped us 
> > > fix the issue for him does not help us fix it for you just yet.
> > 
> > Lemme qualify that by saying that Jens's issues are improved not 
> > fixed [he has not re-run with latest latt.c yet] but not all things 
> > are fully fixed yet. For example the xmodmap thing sounds 
> > interesting - could that be a child-runs-first effect?
> 
> I thought so too, so when -tip failed to boot I pulled the patches 
> from Mike into 2.6.31. It doesn't change anything for xmodmap, 
> though.

Note, you can access just the pristine scheduler patches by checking 
out and testing tip:sched/core - no need to pull them out and apply.

Your crash looks like clocksource related - that's in a separate 
topic which you can thus isolate if you use sched/core.

Thanks,

	Ingo
