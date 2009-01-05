Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbZAEKKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbZAEKKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 05:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZAEKK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 05:10:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60787 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbZAEKK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 05:10:26 -0500
Date: Mon, 5 Jan 2009 11:10:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090105101006.GA2059@elte.hu>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090105090239.GB17530@uranus.ravnborg.org> <20090105011202.835e75ec.akpm@linux-foundation.org> <20090105.011733.225349838.davem@davemloft.net> <20090105092110.GA11941@elte.hu> <20090105093931.GA17944@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105093931.GA17944@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Mon, Jan 05, 2009 at 10:21:10AM +0100, Ingo Molnar wrote:
> > 
> > * David Miller <davem@davemloft.net> wrote:
> > 
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > > Date: Mon, 5 Jan 2009 01:12:02 -0800
> > > 
> > > > On Mon, 5 Jan 2009 10:02:39 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
> > > > 
> > > > > Hi Andrew.
> > > > > 
> > > > > > sparc64-use-unsigned-long-long-for-u64.patch
> > > > > > sparc64-fix-unsigned-long-long-warnings-in-drivers.patch
> > > > > 
> > > > > Please drop these two.
> > > > 
> > > > Might, if they break my build.
> > > 
> > > They don't build, I tested them when I tried integrated Sam's patches.
> > 
> > do they break due to some warnings caught by -Werror?
> 
> Yup.

So your patches "dont build" because some Sparc configs produce new 
(presumably harmless) warnings?

And the solution is to not do your patch and export other warnings to the 
core kerne, which then get reported as bugs there and which result in 
fugly fixes? (and which resulted in a crapload of ugly fixes in the past 
10 years)

That is quite backwards, no matter how i look at it. Why doesnt Sparc do 
the obvious and turn off -Werror until it has gotten around to fix those 
few remaining warnings? It took me 30 minutes to fix up PowerPC defconfig 
with a similar change, it cannot be that much harder on Sparc either 
(powerpc arch code is a lot larger in fact). I'd be surprised if it took 
more than 10 minutes of davem's time.

	Ingo
