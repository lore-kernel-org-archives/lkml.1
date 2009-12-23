Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZLWIui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZLWIui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbZLWIuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:50:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34324 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbZLWIug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:50:36 -0500
Date: Wed, 23 Dec 2009 09:49:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
Message-ID: <20091223084935.GC25240@elte.hu>
References: <4B3009DC.7020407@kernel.org>
 <1261480001.4937.21.camel@laptop>
 <4B319A20.9010305@kernel.org>
 <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain>
 <20091223060229.GA14805@elte.hu>
 <4B31C210.4010100@kernel.org>
 <20091223080144.GG23839@elte.hu>
 <4B31D487.6060706@kernel.org>
 <20091223083705.GA25240@elte.hu>
 <4B31D99D.4070705@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B31D99D.4070705@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 12/23/2009 05:37 PM, Ingo Molnar wrote:
> >> Sure, fair enough but there's also a different side.  It'll allow much 
> >> easier implementation of things like in-kernel media presence polling (I 
> >> have some code for this but it's still just forming) and per-device.  It 
> >> gives a much easier tool to extract concurrency and thus opens up new 
> >> possibilities.
> >>
> >> So, anyways, alright, I'll go try some conversions.
> > 
> > Well, but note that you are again talking performance. Concurrency
> > _IS_ performance: either in terms of reduced IO/app/request latency
> > or in terms of CPU utilization.
> 
> I wasn't talking about performance above.  Easiness or flexibility to 
> extract concurrency opens up possibilities for new things or easier ways of 
> doing things.  It affects the design process.  You don't have to jump 
> through hoops for concurrency management and removing that restriction 
> results in lower amount of convolution and simplifies design.

Which is why i said this in the next paragraph:

> > ( Plus reduction in driver complexity can be measured as well, in the 
> >   diffstat space.)

A new facility that is so mysterious that it cannot be shown to have any 
performance/scalability/latency benefit _nor_ can it be shown to reduce driver 
complexity simply does not exist IMO.

A tangle benefit has to show up _somewhere_ - if not in the performance space 
then in the diffstat space (and vice versa) - that's all what i'm arguing.

	Ingo
