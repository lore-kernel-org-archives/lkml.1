Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbZIWMok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbZIWMok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZIWMok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:44:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35344 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbZIWMoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:44:37 -0400
Date: Wed, 23 Sep 2009 14:44:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] perf_event, powerpc: Fix compilation after big
	perf_counter rename
Message-ID: <20090923124420.GA5525@elte.hu>
References: <19128.4280.813369.589704@cargo.ozlabs.ibm.com> <1253584591.7103.197.camel@pasglop> <20090922072834.GA25470@elte.hu> <1253606415.7103.216.camel@pasglop> <1253620332.10476.4.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253620332.10476.4.camel@concordia>
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

> On Tue, 2009-09-22 at 18:00 +1000, Benjamin Herrenschmidt wrote:
> > On Tue, 2009-09-22 at 09:28 +0200, Ingo Molnar wrote:
> > > 
> > > Nevertheless you are right that i should have caught this particular 
> > > PowerPC build bug - i missed it - sorry about that!
> > > 
> > Allright. Well, to help in general, we are setting up a build-bot
> > here too that will build -tip HEAD for at least powerpc daily with
> > a few configs too.
> 
> Results here:
> 
> http://kisskb.ellerman.id.au/kisskb/branch/12/

ok, seems green for today - the two failures are: one a powerpc 
toolchain problem it appears, plus a mainline warning.

Btw., for me to be able to notice failures there it would have to email 
me automatically if there's any -tip build failures that do not occur 
with the upstream branch. Does it have such a feature?

	Ingo

