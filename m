Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbXG1WSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbXG1WSz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 18:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbXG1WSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 18:18:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756324AbXG1WSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 18:18:47 -0400
Date: Sat, 28 Jul 2007 15:18:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bill Huey <billh@gnuppy.monkey.org>
cc: Diego Calleja <diegocg@gmail.com>, jos poortvliet <jos@mijnkamer.nl>,
       ck@vds.kolivas.org, Michael Chang <thenewme91@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
In-Reply-To: <20070728213232.GG32582@gnuppy.monkey.org>
Message-ID: <alpine.LFD.0.999.0707281445170.3442@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
 <200707282003.45142.jos@mijnkamer.nl> <alpine.LFD.0.999.0707281109120.3442@woody.linux-foundation.org>
 <200707282128.39906.jos@mijnkamer.nl> <20070728200705.GF32582@gnuppy.monkey.org>
 <20070728230609.43273a75.diegocg@gmail.com>
 <20070728213232.GG32582@gnuppy.monkey.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jul 2007, Bill Huey wrote:
> 
> My argument is that schedule development is open ended. Although having
> a central scheduler to hack is a a good thing, it shouldn't lock out or
> supress development from other groups that might be trying to solve the
> problem in unique ways.

I don't think anything was suppressed here.

You seem to say that more modular code would have helped make for a nicer 
way to do schedulers, but if so, where were those patches to do that? 
Con's patches didn't do that either. They just replaced the code.

In fact, Ingo's patches _do_ add some modularity, and might make it easier 
to replace the scheduler. So it would seem that you would argue for CFS, 
not against it?

> I think that's kind of a bogus assumption from the very get go. Scheduling
> in Linux is one of the most unevolved systems in the kernel that still
> could go through a large transformation and get big gains like what
> we've had over the last few months. This evident with both schedulers,
> both do well and it's a good thing overall the CFS is going in.
> 
> Now, the way it happened is completely screwed up in so many ways that I
> don't see how folks can miss it. This is not just Ingo versus Con, this
> is the current Linux community and how it makes decision from the top down
> and the current cultural attitude towards developers doing things that
> are:

I don't think so.

I think you're barking up the totally wrong tree here.

I think that what happened was very simple: somebody showed that we did 
badly and had benchmarks to show for it, and that in turn resulted in a 
huge spurt of coding from the people involved.

The fact that you think this is "broken" is interesting. I can point to a 
very real example of where this also happened, and where I bet you don't 
think the process was "broken".

Do you remember the mindcraft study?

Exact same thing. Somebody came in, and showed that Linux did really badly 
on some benchmark, and that an alternate approach was much better.

What happened? A huge spurt of development in a pretty short timeframe, 
that totally _obliterated_ the mindcraft results. 

It could have happened independently, but the fact is, it didn't. These 
kinds of events where somebody shows (with real numbers and code) that 
things can be done better really *are* a good way to do development, and 
it's how development generally ends up happening. It's hugely 
motivational, both because competition is motivational in itself, but also 
because somebody shows that things can be done so much better opens 
peoples eyes to it.

And if you think the scheduler situation is different, why? Was it just 
because the mindcraft study compared against Windows NT, not another 
version of Linux patches?

The thing is, development is slow and gradual, but at the same time, it 
happens in spurts (btw, if you have ever studied evolution, you'll find 
the exact same thing: evolution is slow and gradual, but it also happens 
in sudden "spurts" where you have relatively much bigger changes happening 
because you get into a feedback loop).

Another comparison to evolution: most of the competitive pressure actually 
comes from the _same_ species, not from outside. It's not so much rabbits 
competing against foxes (although that happens too), quite a lot of it is 
rabbits competing against other rabbits!

			Linus
