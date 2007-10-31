Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbXJaJzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbXJaJzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 05:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbXJaJzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 05:55:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54589 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbXJaJzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 05:55:32 -0400
Date: Wed, 31 Oct 2007 10:55:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Lorenzo Allegrucci <l.allegrucci@gmail.com>, Bj?rn <askadar@gmail.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.23 performance regression
Message-ID: <20071031095517.GA5817@elte.hu>
References: <4dcf7d360710300054m7ac77445pf786bd9044b572d7@mail.gmail.com> <200710311319.54210.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710311319.54210.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 30 October 2007 18:54, Lorenzo Allegrucci wrote:
> > Hi, sorry if this is a faq but reading
> > http://people.freebsd.org/~kris/scaling/7.0%20Preview.pdf (slides 17,
> > 18)
> > looks like 2.6.23 is having a performance regression on MySQL and
> > PostgreSQL benchmarks.  Has anyone investigated these?
> 
> I think Ingo was looking into them. I'm just in the middle of building 
> a new setup to investigate some performance issues too, so I hope to 
> look at this.
> 
> Apparently it did go unnoticed during CFS testing, unfortunately. 
> Although now it has been brought to light, I think 2.6.24 is supposed 
> to be better (although it now gets worse on other things).

yep. For those who fear the 1 million lines of code flux of 2.6.24, 
here's a backport of the scheduler changes to 2.6.23:

  http://people.redhat.com/mingo/cfs-scheduler/devel/sched-cfs-v2.6.23.1-v22.1-rc0.patch

Lorenzo, could you please try that report back your reports? Thanks,

	Ingo
