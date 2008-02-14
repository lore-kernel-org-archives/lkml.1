Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbYBNSDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbYBNSDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYBNSDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:03:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368AbYBNSDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:03:04 -0500
Date: Thu, 14 Feb 2008 10:01:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
In-Reply-To: <20080214232229.f7bdc6ac.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.1.00.0802140949460.6110@woody.linux-foundation.org>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080212042133.GA4625@kroah.com> <20080211203146.3d28d1a0@laptopd505.fenrus.org> <1202791555.20739.6.camel@heimdal.trondhjem.org> <20080212051136.GA12802@mit.edu> <20080211221535.bc0dc9cf.akpm@linux-foundation.org>
 <20080212225716.cf695fe4.sfr@canb.auug.org.au> <20080214081405.GA20791@flint.arm.linux.org.uk> <20080214232229.f7bdc6ac.sfr@canb.auug.org.au>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Feb 2008, Stephen Rothwell wrote:
> 
> Originally, I assumed the stable branch would be for our "usual" API
> changes, but it appears we are not having any more of those. :-)

It's not that we should _never_ have them, it's that they shouldn't be 
"business as usual".

I'm happy with them being a "a couple of times a year". I'm not happy with 
them being "once or twice for every release cycle". That's the big deal 
for me.

If we have a big flag-day that affects a lot of drivers (or architectures) 
once or twice a year, I think everybody involved will be happy to stand up 
and say "ok, that fixes problem X, and the new thing really is better, so 
let's do it, it's worth it".

But if it's something that happens essentially every single release, that 
is somethign else altogether. Then it's not a "ok, let's bite the bullet 
and make the kernel better" thing any more, but instead it devolves into 
"f*ck, the merge window is open again, now I have to fix up all the crap 
people pushed on me".

See? That's a *huge* difference, even if it is "only" a mental one (and 
clearly it isn't - there's the actual real work of the "I have to fix 
things up" part too).

So to recap: I have absolutely nothing against fixing up bad internal 
API's and breaking things. But 99% of the time that should be something we 
can do incrementally (ie introduce the new API, and simply accept the 
fact that removing the old API will take a few months). And the case when 
that _really_ doesn't work should be rare enough that it doesn't wear 
people down.

Because if you listen to the tone of people in this discussion, much of it 
is about people being _tired_ of having to fix things up. It's not exactly 
been a "wow, the end result sure was nice!" kind of discussion, is it?

And this is where "process" really matters. Making sure people don't get 
too frustrated about the constant grind.

>							  However,
> I see an argument for attempting to stabilise possible conflicting
> changes get Linus' review/ack and add them to the stable branch.
>
> Linus suggested that such changes should go into an independent tree that
> everyone could pull into their trees with the full confidence that that
> tree would be merged into Linus' tree when the merge window opens.  I am
> suggesting that that tree be the stable branch of linux-next.

I absolutely have no problem with having a "this is the infrastrcture 
changes that will go into the next release". In fact, I can even 
*maintain* such a branch. 

I've not wanted to open up a second branch for "this is for next release", 
because quite frankly, one of the other problems we have is that people 
already spend way too much time on the next release compared to just 
looking at regressions in the current one. But especially if we're talking 
about _purely_ API changes etc infrastructure, I could certainly do a 
"next" branch. 

			Linus
