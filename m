Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbZIXMOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbZIXMOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZIXMOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:14:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43978 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbZIXMOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:14:40 -0400
Date: Thu, 24 Sep 2009 14:14:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] perf_event, powerpc: Fix compilation after big
	perf_counter rename
Message-ID: <20090924121423.GB12262@elte.hu>
References: <19128.4280.813369.589704@cargo.ozlabs.ibm.com> <1253584591.7103.197.camel@pasglop> <20090922072834.GA25470@elte.hu> <1253606415.7103.216.camel@pasglop> <1253620332.10476.4.camel@concordia> <20090923124420.GA5525@elte.hu> <1253747995.6110.5.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253747995.6110.5.camel@concordia>
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


* Michael Ellerman <michael@ellerman.id.au> wrote:

> On Wed, 2009-09-23 at 14:44 +0200, Ingo Molnar wrote:
> > * Michael Ellerman <michael@ellerman.id.au> wrote:
> > 
> > > On Tue, 2009-09-22 at 18:00 +1000, Benjamin Herrenschmidt wrote:
> > > > On Tue, 2009-09-22 at 09:28 +0200, Ingo Molnar wrote:
> > > > > 
> > > > > Nevertheless you are right that i should have caught this particular 
> > > > > PowerPC build bug - i missed it - sorry about that!
> > > > > 
> > > > Allright. Well, to help in general, we are setting up a build-bot
> > > > here too that will build -tip HEAD for at least powerpc daily with
> > > > a few configs too.
> > > 
> > > Results here:
> > > 
> > > http://kisskb.ellerman.id.au/kisskb/branch/12/
> > 
> > ok, seems green for today - the two failures are: one a powerpc 
> > toolchain problem it appears, plus a mainline warning.
> 
> Yep that looks more or less normal.
> 
> > Btw., for me to be able to notice failures there it would have to 
> > email me automatically if there's any -tip build failures that do 
> > not occur with the upstream branch. Does it have such a feature?
> 
> Not really, it sends mails to me, but it doesn't have a way to filter 
> them by branch. I think the plan is we'll keep an eye on it and either 
> send you patches or at least let you know that it's broken.

how many mails are those per day, typically? If there's not too many and 
if there's a way to send all of them to me i could post-filter them for 
-tip relevance. If that is feasible. You bouncing it to me later is 
certainly also a solution. (but lengthens the latency of fixes, 
obviously.)

	Ingo
