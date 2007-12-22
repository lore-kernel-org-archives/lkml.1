Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbXLVJuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbXLVJuh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 04:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbXLVJub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 04:50:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52424 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbXLVJua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 04:50:30 -0500
Date: Sat, 22 Dec 2007 10:45:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: clameter@sgi.com, a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org, rjw@sisk.pl
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071222094459.GE26157@elte.hu>
References: <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <20071221.152008.11508772.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221.152008.11508772.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 21 Dec 2007 23:54:13 +0100
> 
> > Really, if your behavior is representative of how our SLAB allocator 
> > will be maintained in the future then i'm very, very worried :-(
> 
> Actually, to the contrary, I actually think Christoph responds to 
> every problem I've ever reported to him about his per-cpu counters 
> work and SLUB much better than most people who call themselves 
> "maintainers" around here.
> 
> And I say that without any reservations.
> 
> He doesn't deserve the ad-hominem attacks he is getting today, because 
> he does resolve every problem reported to him.
>
> The guy wrote test cases, he analyzed every problem, he wrote test 
> patches, and he doesn't stop doing any of that until the issue really 
> is reported as resolved by the testers.
> 
> I'll take Christoph as the implementor and maintainer of anything, any 
> day of the week.  He rocks.

well, maybe i got unlucky, this hackbench thing being the first time i'm 
exposed to a major SLUB regression. The hackbench problem was dead easy 
to reproduce, i (and others) offered immediate testing of whatever test 
patches, it also matched the profiles of the TPC-C regression but still 
i was only offered explanations about why this workload does not matter 
and how others suck because they are unable to give immediate test 
feedback from millions-of-dollars test equipment that is barely able to 
run our devel kernels. The regression is fixed now and i'm a happy 
camper!

Christoph, i'd like to apologize for all overly harsh words i said. (and 
i said quite a few :-/ )

	Ingo
