Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbYEAB0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbYEAB0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYEAB0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:26:00 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35919 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYEAB0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:26:00 -0400
Date: Thu, 1 May 2008 04:25:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501012515.GP29330@cs181133002.pp.htv.fi>
References: <20080429.190352.137408408.davem@davemloft.net> <200805010145.39373.rjw@sisk.pl> <20080501003855.GN29330@cs181133002.pp.htv.fi> <200805010256.25018.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200805010256.25018.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 02:56:23AM +0200, Rafael J. Wysocki wrote:
> On Thursday, 1 of May 2008, Adrian Bunk wrote:
> > On Thu, May 01, 2008 at 01:45:38AM +0200, Rafael J. Wysocki wrote:
> > > On Thursday, 1 of May 2008, david@lang.hm wrote:
> > > > On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> > > > 
> > > > > On Wednesday, 30 of April 2008, Linus Torvalds wrote:
> > > > >>
> > > > >> On Wed, 30 Apr 2008, Rafael J. Wysocki wrote:
> > > > >> So your "fewer commits over a unit of time" doesn't make sense.
> > > > >
> > > > > Oh, yes it does.  Equally well you could say that having brakes in a car
> > > > > didn't make sense, even if you could drive it as fast as the engine allowed
> > > > > you to. ;-)
> > > > >
> > > > >> We have those ten thousand commits. They need to go in. They cannot take
> > > > >> forever.
> > > > >
> > > > > But perhaps some of them can wait a bit longer.
> > > > 
> > > > not really, if patches are produced at a rate of 1000/week and you decide 
> > > > to only accept 2000 of them this month, a month later you have 6000 
> > > > patches to deal with.
> > > 
> > > Well, I think you know how TCP works.  The sender can only send as much
> > > data as the receiver lets it, no matter how much data there are to send.
> > > I'm thinking about an analogous approach.
> > > 
> > > If the developers who produce those patches know in advance about the rate
> > > limit and are promised to be treated fairly, they should be able to organize
> > > their work in a different way.
> > >...
> > 
> > We cannot control who develops what.
> 
> We don't need to.
> 
> > When someone wants some feature or wants to get Linux running on his 
> > hardware he will always develop the code.
> > 
> > We can only control what we merge.
> 
> To be exact, we control what we merge and when.  There's no rule saying that
> every patch has to be merged as soon as it appears to be ready for merging,
> or during the nearest merge window, AFAICS.

What currently gets applied to the kernel are between two and three 
million lines changed per year.

We can discuss when and how to apply them.

But unless we want to create an evergrowing backlog we have to change 
roughly 200.000 lines per month on average.

Even with higher quality criteria that might result in some code not 
being merged we will still be > 100.000 lines per month on average.

> > And the main rationale for the 2.6 development model was that we do no 
> > longer want distributions to ship kernels with insane amounts of 
> > patches.
> 
> This was an argument agaist starting a separate development branch in analogy
> with 2.5, IIRC, and I agree with that.
>
> Still, I think we don't need to merge patches at the current rate and it might
> help improve their overall quality if we didn't.  Of course, the latter is only
> a speculation, although it's based on my experience.

See above - what do you want to do if we'd merge less and have a backlog 
of let's say one million lines to change after one year, much of it 
already in distribution kernels?

I also don't like this situation, but we have to cope with it.

> Thanks,
> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

