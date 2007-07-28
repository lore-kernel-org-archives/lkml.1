Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbXG1Ub2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbXG1Ub2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 16:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbXG1UbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 16:31:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51485 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116AbXG1UbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 16:31:20 -0400
Date: Sat, 28 Jul 2007 13:31:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: jos poortvliet <jos@mijnkamer.nl>
cc: ck@vds.kolivas.org, Michael Chang <thenewme91@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
In-Reply-To: <200707282128.39906.jos@mijnkamer.nl>
Message-ID: <alpine.LFD.0.999.0707281313570.3442@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
 <200707282003.45142.jos@mijnkamer.nl> <alpine.LFD.0.999.0707281109120.3442@woody.linux-foundation.org>
 <200707282128.39906.jos@mijnkamer.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jul 2007, jos poortvliet wrote:
>
> Your point here seems to be: this is how it went, and it was right. Ok, got 
> that.

But I wanted to bring out more than what you make sound like "that's what 
happened, deal with it". I tried to explain _why_ the choices that were 
made were in fact made.

And it's a (I think) important thing for people to be aware of. The fact 
is, "personality" and "work with the other developers" is a big issue.

You cannot just go off and do your own thing in your private world, and 
then expect it to be accepted without any discussion or other people 
showing up and doing alternate things. That's _especially_ true in an area 
that has a respected and working maintainer.

>	 Yet, Con walked away (and not just over SD). Seeing Con go, I wonder 
> how many did leave without this splash.

We've had people go with a splash before. Quite frankly, the current 
scheduler situation looks very much like the CML2 situation. Anybody 
remember that? The developer there also got rejected, the improvement was 
made differently (and much more in line with existing practices and 
maintainership), and life went on. Eric Raymond, however, left with a 
splash.

It's not common, but it's not unheard of. Anybody who thinks that 
developers don't have huge egos probably haven't ever met a software 
engineer. And I suspect kernel people have bigger egos than most. No 
wonder there are clashes every once in a while - it's a wonder there 
aren't _more_ of them.

> How and why? And is it due to a deeper problem?

Well, one part of it is that the way to make changes in the kernel 
community is to do them incrementally.

Small and incremental improvements are much easier to merge. If you go off 
and rewrite a subsystem, you shouldn't expect it to get merged, at least 
not unless it can live side-by-side with the old one (the new firewire 
stack is an example of that, and most filesystems are this way too). And 
the closer to some central part you get, the harder that gets.

So the *bulk* of the kernel stuff can be handled either incrementally, or 
side-by-side, and as a result, you actually seldom see issues like this. 
The kernel is extremely modular, and a large reason for that is exactly to 
avoid couplings.

Some (very few) things cannot be done incrementally. That's why I bring 
up CML2 as a fairly good example of this having happened before. Some 
things require flag-days. But you should pretty much *assume* that if 
there is a flag-day, and if there is a maintainer, the maintainer has to 
be involved.

Does "maintainership" give infinite powers? No. I'll take patches that 
bypass maintainers, but there needs to be some reason for them (ie in some 
sense the maintainer needs to have done a bad job, or the patch just needs 
to be trivial enough - or it cuts across maintainership areas - that it's 
not even _worth_ going through all maintainers).

So maintainers aren't "everything". But they are important. You can't just 
ignore them and go do your own thing, and then expect it to be merged.

			Linus
