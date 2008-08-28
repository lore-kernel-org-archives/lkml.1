Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYH1NHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYH1NHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 09:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYH1NHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 09:07:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38292 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbYH1NHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 09:07:35 -0400
Date: Thu, 28 Aug 2008 15:07:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080828130708.GA19672@elte.hu>
References: <20080819103301.787700742@chello.nl> <200808272008.16106.nickpiggin@yahoo.com.au> <20080828105408.GA4488@elte.hu> <200808282203.48396.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808282203.48396.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> There is no customer issue and there is no handwaving about 
> compliance;

well, the reason i'm asking is that i cannot for anything in the world 
imagine you being so upset about _anything_ but something that involves 
benchmark runs ;-)

And what does SCHED_FIFO RT policy scheduling have to do with 
performance and benchmarks? Nothing usually in the real world, except 
for this little known fact: a common 'tuning' for TPC database 
benchmarks is to run all DB threads as SCHED_FIFO to squeeze the last 
0.1% of performance out of the setup.

So - and i'm taking an educated guess here - is SCHED_FIFO+TPC 
performance perhaps one of the factors that played a role in you 
initiating this thread? If yes then it's obviously an incredibly broken 
use of SCHED_FIFO and we can add the sysctl tuning to the long list of 
dozens of other tunings that happen before a TPC run anyway.

Hm?

	Ingo
