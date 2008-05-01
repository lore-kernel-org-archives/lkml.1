Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbYEAA4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbYEAA4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYEAA4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:56:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47527 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbYEAA4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:56:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 02:56:23 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net> <200805010145.39373.rjw@sisk.pl> <20080501003855.GN29330@cs181133002.pp.htv.fi>
In-Reply-To: <20080501003855.GN29330@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805010256.25018.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, Adrian Bunk wrote:
> On Thu, May 01, 2008 at 01:45:38AM +0200, Rafael J. Wysocki wrote:
> > On Thursday, 1 of May 2008, david@lang.hm wrote:
> > > On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> > > 
> > > > On Wednesday, 30 of April 2008, Linus Torvalds wrote:
> > > >>
> > > >> On Wed, 30 Apr 2008, Rafael J. Wysocki wrote:
> > > >> So your "fewer commits over a unit of time" doesn't make sense.
> > > >
> > > > Oh, yes it does.  Equally well you could say that having brakes in a car
> > > > didn't make sense, even if you could drive it as fast as the engine allowed
> > > > you to. ;-)
> > > >
> > > >> We have those ten thousand commits. They need to go in. They cannot take
> > > >> forever.
> > > >
> > > > But perhaps some of them can wait a bit longer.
> > > 
> > > not really, if patches are produced at a rate of 1000/week and you decide 
> > > to only accept 2000 of them this month, a month later you have 6000 
> > > patches to deal with.
> > 
> > Well, I think you know how TCP works.  The sender can only send as much
> > data as the receiver lets it, no matter how much data there are to send.
> > I'm thinking about an analogous approach.
> > 
> > If the developers who produce those patches know in advance about the rate
> > limit and are promised to be treated fairly, they should be able to organize
> > their work in a different way.
> >...
> 
> We cannot control who develops what.

We don't need to.

> When someone wants some feature or wants to get Linux running on his 
> hardware he will always develop the code.
> 
> We can only control what we merge.

To be exact, we control what we merge and when.  There's no rule saying that
every patch has to be merged as soon as it appears to be ready for merging,
or during the nearest merge window, AFAICS.

> And the main rationale for the 2.6 development model was that we do no 
> longer want distributions to ship kernels with insane amounts of 
> patches.

This was an argument agaist starting a separate development branch in analogy
with 2.5, IIRC, and I agree with that.

Still, I think we don't need to merge patches at the current rate and it might
help improve their overall quality if we didn't.  Of course, the latter is only
a speculation, although it's based on my experience.

Thanks,
Rafael
