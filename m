Return-Path: <linux-kernel-owner+w=401wt.eu-S936044AbXG1Cgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936044AbXG1Cgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 22:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXG1Cg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 22:36:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085AbXG1Cg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 22:36:26 -0400
Date: Fri, 27 Jul 2007 19:35:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kasper Sandberg <lkml@metanurb.dk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, CK Mailinglist <ck@vds.kolivas.org>
Subject: Re: Linus 2.6.23-rc1
In-Reply-To: <1185588279.1654.1.camel@localhost>
Message-ID: <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
 <1185588279.1654.1.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jul 2007, Kasper Sandberg wrote:
>
> Im still not so keen about this, Ingo never did get CFS to match SD in
> smoothness for 3d applications, where my test subjects are quake(s),
> world of warcraft via wine, unreal tournament 2004. And this is despite
> many patches he sent me to try and tweak it.

You realize that different people get different behaviour, don't you? 
Maybe not.

People who think SD was "perfect" were simply ignoring reality. Sadly, 
that seemed to include Con too, which was one of the main reasons that I 
never ended entertaining the notion of merging SD for very long at all: 
Con ended up arguing against people who reported problems, rather than 
trying to work with them.

Andrew also reported an oops in the scheduler when SD was merged into -mm, 
so there were other issues.

> As far as im concerned, i may be forced to unofficially maintain SD for 
> my own systems(allthough lots in the gaming community is bound to be 
> interrested, as it does make games lots better)

You know what? You can do whatever you want to. That's kind of the point 
of open source. Keep people honest by having alternatives.

But the the thing is, if you want to do a good job of doing that, here's a 
big hint: instead of keeping to your isolated world, instead of just 
talking about your own machine and ignoring other peoples machines and 
issues and instead of just denying that problems may exist, and instead of 
attacking people who report problems, how about working with them?

That was where the SD patches fell down. They didn't have a maintainer 
that I could trust to actually care about any other issues than his own.

So here's a hint: if you think that your particular graphics card setup is 
the only one that matters, it's not going to be very interesting for 
anybody else. 

[ I realize that this comes as a shock to some of the SD people, but I'm 
  told that there was a university group that did some double-blind 
  testing of the different schedulers - old, SD and CFS - and that 
  everybody agreed that both SD and CFS were better than the old, but that 
  there was no significant difference between SD and CFS. You can try 
  asking Thomas Gleixner for more details. ]

I'm happy that SD was perfect for you. It wasn't for others, and it had 
nobody who was even interested in trying to solve those issues. 

As a long-term maintainer, trust me, I know what matters. And a person who 
can actually be bothered to follow up on problem reports is a *hell* of a 
lot more important than one who just argues with reporters.

			Linus
