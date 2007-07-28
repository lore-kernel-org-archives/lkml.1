Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbXG1RNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbXG1RNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 13:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbXG1RN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 13:13:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651AbXG1RN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 13:13:27 -0400
Date: Sat, 28 Jul 2007 10:12:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jonathan Jessup <jonathanjessup@gmail.com>
cc: Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org, lkml@metanurb.dk
Subject: Re: [ck] Re: Linus 2.6.23-rc1
In-Reply-To: <954c7c800707280045t4607cebfj532ef025a7a57c05@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0707280956140.3442@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
  <1185588279.1654.1.camel@localhost>  <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
  <Pine.LNX.4.63.0707280817540.27758@alpha.polcom.net>
 <954c7c800707280045t4607cebfj532ef025a7a57c05@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jul 2007, Jonathan Jessup wrote:
> 
> Linus, there is a complaint about the Linux kernel, this complaint is that
> the Linux kernel isn't giving priorities to desktop interactivity and
> experience. The response on osnews.com etc have shown that there is public
> demand for it too.

No, the response on osnews.com only shows that there are a lot of armchair 
complainers around.

People are suggesting that you'd have a separate "desktop kernel". That's 
insane. It also shows total ignorance of maintainership, and reality. And 
I bet most of the people there haven't tested _either_ scheduler, they 
just like making statements.

The fact is, I've _always_ considered the desktop to be the most important 
part. And I suspect that that actually is true for most kernel developers, 
because quite frankly, that's what 99% of them ends up using. If a kernel 
developer uses Windows for his day-to-day work, I sure as hell wouldn't 
want to have him developing Linux. That has nothing to do with anything 
anti-windows: but the whole "eat your own dogfood" is a very fundamental 
thing, and somebody who doesn't do that shouldn't be allowed to be even 
_close_ to a compiler!

So the whole argument about how kernel developers think that the desktop 
isn't important is totally made-up crap by Con, and then parrotted by 
osnews and other places.

The fact is, most kernel developers realize that Linux is used in 
different places, on different machines, and with different loads. You 
cannot make _everybody_ happy, but you can try to do as good a job as 
possible. And doing "as good a job as possible" very much includes not 
focusing on any particular load.

And btw, "the desktop" isn't actually one single load. It's in fact a lot 
of very different loads, and different people want different things. What 
makes the desktop so interesting is in fact that it shows more varied 
usage than any other niche - and no, 3D gaming isn't "it". 

> Maybe once or twice Con couldn't help or fix an issue but isn't that what
> open source software is all about anyway?

That's not the issue. 

Con wass fixated on one thing, and one thing only, and wasn't interested 
in anythign else - and attacked people who complained. Compare that to 
Ingo, who saw that what Con's scheduler did was good, and tried to solve 
the problems of people who complained.

The ck mailing list is/was also apparently filled with people who all had 
the same issues, which is seriously the *wrong* thing to do. It means that 
any "consensus" coming out of that kind of private list is totally 
worthless, because the people you ask are already in agreement - you have 
a so-called "selection bias", and they just reinforce their own opinions.

Which is why I don't trust mailing lists with a narrow topic. They are 
_useless_. If you cannot get many different people from _different_ areas 
to test your patches, and cannot see the big picture, the end result won't 
likely be very interesting to others, will it?

The fact is, _any_ scheduler is going to have issues. I will bet you 
almost any amount of money that people are going to complain about Ingo's 
scheduler when 2.6.23 is released. That's not the issue: the issue is that 
the exact same thing would have happened with CK too.

So if you are going to have issues with the scheduler, which one do you 
pick: the one where the maintainer has shown that he can maintain 
schedulers for years, can can address problems from _different_ areas of 
life? Or the one where the maintainer argues against people who report 
problems, and is fixated on one single load?

That's really what it boils down to. I was actually planning to merge CK 
for a while. The _code_ didn't faze me.

			Linus
