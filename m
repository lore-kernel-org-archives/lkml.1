Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbXG1Jq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbXG1Jq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 05:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbXG1JqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 05:46:16 -0400
Received: from pfepc.post.tele.dk ([195.41.46.237]:50808 "EHLO
	pfepc.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbXG1JqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 05:46:14 -0400
Subject: Re: Linus 2.6.23-rc1
From: Kasper Sandberg <lkml@metanurb.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, CK Mailinglist <ck@vds.kolivas.org>
In-Reply-To: <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185588279.1654.1.camel@localhost>
	 <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 28 Jul 2007 11:44:08 +0200
Message-Id: <1185615848.13701.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 19:35 -0700, Linus Torvalds wrote:
> 
> On Sat, 28 Jul 2007, Kasper Sandberg wrote:
> >
> > Im still not so keen about this, Ingo never did get CFS to match SD in
> > smoothness for 3d applications, where my test subjects are quake(s),
> > world of warcraft via wine, unreal tournament 2004. And this is despite
> > many patches he sent me to try and tweak it.
> 
> You realize that different people get different behaviour, don't you? 
> Maybe not.

Sure.

> 
> People who think SD was "perfect" were simply ignoring reality. Sadly, 
> that seemed to include Con too, which was one of the main reasons that I 
> never ended entertaining the notion of merging SD for very long at all: 
> Con ended up arguing against people who reported problems, rather than 
> trying to work with them.

Im not saying its perfect, not at all, neither am i saying CFS is bad,
surely CFS is much better than the old one, and i agree with what that
university test you mentioned on kerneltrap says, that CFS and SD is
basically impossible to feel difference in, EXCEPT for 3d under load,
where CFS simply can not compete with SD, theres no but, this is how it
has acted on every system ive tested, and YES, others reported it too,
whether you choose to see it or not. and others people who run games on
linux tells me the exact same thing, and i have had quite a few people
try this.

> 
> Andrew also reported an oops in the scheduler when SD was merged into -mm, 
> so there were other issues.

And whats the point here? If you are trying to pull the old "Con just
runs away", forget it, its a certainty that he would have put the
required time into fixing whatever issues arise.

> 
> > As far as im concerned, i may be forced to unofficially maintain SD for 
> > my own systems(allthough lots in the gaming community is bound to be 
> > interrested, as it does make games lots better)
> 
> You know what? You can do whatever you want to. That's kind of the point 
> of open source. Keep people honest by having alternatives.

True that

> 
> But the the thing is, if you want to do a good job of doing that, here's a 
> big hint: instead of keeping to your isolated world, instead of just 
> talking about your own machine and ignoring other peoples machines and 
First off, i've personally run tests on many more machines than my own,
i've had lots of people try on their machines, and i've seen totally
unrelated posts to lkml, plus i've seen the experiences people are
writing about on IRC. Frankly, im not just thinking of myself.

> issues and instead of just denying that problems may exist, and instead of 
> attacking people who report problems, how about working with them?

As i recall, there was only 1 persons reports that were attacked, and
that was because the person repeatedly reported the EXPECTED behavior as
broken, simply because it was FAIRLY allocating the cpu time, and this
did not meet with the dudes expectations. And it was after multiple
mails he was "attacked"

> 
> That was where the SD patches fell down. They didn't have a maintainer 
> that I could trust to actually care about any other issues than his own.

You may not have been able to trust Con, but thats because you havent
taken the time to actually really see whats been going on, if you just
read the threads for SD you'd realize that he was more than willing to
maintain it, after all, why do you think he wrote and submitted it? you
think he just wrote it to piss you off by having it merged and leave?

> 
> So here's a hint: if you think that your particular graphics card setup is 
> the only one that matters, it's not going to be very interesting for 
> anybody else.

as explained earlier, its not just my particular setup, but actually
that of alot of people, with lots of different hardware.

>  
> 
> [ I realize that this comes as a shock to some of the SD people, but I'm 
>   told that there was a university group that did some double-blind 
>   testing of the different schedulers - old, SD and CFS - and that 
>   everybody agreed that both SD and CFS were better than the old, but that 
>   there was no significant difference between SD and CFS. You can try 
>   asking Thomas Gleixner for more details. ]
> 
> I'm happy that SD was perfect for you. It wasn't for others, and it had 
> nobody who was even interested in trying to solve those issues. 
> 
> As a long-term maintainer, trust me, I know what matters. And a person who 
> can actually be bothered to follow up on problem reports is a *hell* of a 
> lot more important than one who just argues with reporters.

Okay, i wasnt going to ask, but ill do it anyway, did you even read the
threads about SD? Con was extremely polite to everyone, and he did work
with a multitude of people, you seem to be totally deadlocked into the
ONE incident with a person that was unhappy with SD, simply for being a
fair scheduler.

> 
> 			Linus
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

