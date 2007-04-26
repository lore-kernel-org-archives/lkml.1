Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbXDZRU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbXDZRU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbXDZRU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:20:57 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753498AbXDZRU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:20:56 -0400
Date: Thu, 26 Apr 2007 10:20:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <20070426165950.GO3468@stusta.de>
Message-ID: <alpine.LFD.0.98.0704261007481.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
 <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>
 <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
 <20070426165950.GO3468@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Adrian Bunk wrote:
> 
> They get frustrated because they focussed on developing new features 
> instead of fixing regressions, and now it takes longer until their new 
> features get merged because noone fixed the regressions...

I agree. That's part of it. But part of it is not just the "it's 2 months 
until the next release", part of it is also very much a "nothing has 
happened in the normal kernel for the last 8 weeks, this is boring, so 
I'll do my own exciting stuff".

So one _fundmanetal_ issue is that all the people who aren't directly 
involved with a particular regression are simply bored. And bored is not 
good. You want people productive - and that meas that you want a 
active development kernel that they can work with, since they aren't going 
to help with the regressions anyway.

This is why the -stable tree is so useful. It's not only that users want a 
stable tree - it allows people who do *not* have regressions on their 
plate to not be stuck twiddling their thumbs - they can be on the regular 
kernel.

> I'm not saying it always have to be 4 months.

I'm saying that four months wouldn't even have *helped* in the case of 
2.6.21.

Do you really think bugs get fixed faster just because there wasn't a 
release? Quite the reverse. Bugs get _found_ faster thanks to a release 
(simply because you tend to get more information thanks to more users), 
giving the stable people more information, causing the bugs to be able to 
be found and fixed _more_quickly_ in the stable release than if we had 
waited for four months to release 2.6.21.

The two last weeks of 2.6.21-rc were almost entirely "wasted", apart from 
getting the e1000 issue at least resolved (which was the reason for that 
delay, so I'm not complaining - I'm just saying that not a lot of people 
actually were able to _help_ with regressions during that time, and for 
some of them, we might well be better off with more information about the 
issue).

Did we fix other bugs? Yes. There was one long-time bug (since 2.6.15 or 
something) that happened to come in during that time, and we had some 
cleanups, we had MIPS bugs, we found some networking issues etc etc. But 
the amount of combined effort people put on it was pretty weak. 

> "wait for reports to trickle in from testers" is exactly the opposite of 
> our problem.

I disagree. Quite often, having 5 people report the same thing is actually 
more useful (because you see a pattern) than having one known regression 
that you don't know _why_ that regression happened. And that's the case we 
had for most of them. 

You have things like the maintainer (see Oliver's reply, for example) 
simply unable to reproduce it, and needing more information. It 
*does*not*matter* that the original report may be old. If you need more 
information, you need more information, and a two-month-old report isn't 
any better just because it's two months old.

At some point, you need to say: we're not making progress, need to release 
it, that might get us *off* this stuck situation.

That's the part you seem unable to accept. You think that "we have a 
listed regression" means that you should be able to fix it. Not so. We 
*often* need more information. 

> But I am not happy with the current state of released kernels.

So you're going to help exactly how? By stopping to help? Or kvetching 
about developers that can't figure out why something regressed.

Sure, that makes tons of sense sense, Adrian.

NOT.

		Linus
