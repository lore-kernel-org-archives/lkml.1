Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbXG1S3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbXG1S3T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 14:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbXG1S3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 14:29:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42720 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338AbXG1S3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 14:29:07 -0400
Date: Sat, 28 Jul 2007 11:28:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: jos poortvliet <jos@mijnkamer.nl>
cc: ck@vds.kolivas.org, Michael Chang <thenewme91@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
In-Reply-To: <200707282003.45142.jos@mijnkamer.nl>
Message-ID: <alpine.LFD.0.999.0707281109120.3442@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
 <b14e81f00707280618m73461fdfx989d87a3a0074192@mail.gmail.com>
 <alpine.LFD.0.999.0707281017230.3442@woody.linux-foundation.org>
 <200707282003.45142.jos@mijnkamer.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jul 2007, jos poortvliet wrote:
> 
> <sarcasm>

Actually, the tag you were looking for was "<clueless>"

> http://osnews.com/permalink.php?news_id=18350&comment_id=259044
> 
> Now I wonder. Apparently, one person complaining about SD was reason to keep 
> it out http://osnews.com/permalink.php?news_id=18350&comment_id=258997
> 
> Will this first post stop CFS from entering the kernel?

You seem to be not understanding the argument.

It wasn't about "one person complaining". Of *course* people will 
complain. That always happens, and sometimes with totally bogus complaints 
(the most common being "I'm not used to it").

The problem was the reaction to complaints. 

Ingo got lots of complaints too. He was very responsive to them (which is 
not something surprising - he's been doing this a long time), and while 
some of the tangents he went off on were definitely bogus (the whole 
renicing thing), they were still useful as part of the discussion.

And Ingo got other - totally unrelated - developers involved too, ie the 
group fairness logic came from Vatsa. And he ended up supporting not just 
scheduler people, but also talking to the block layer people ahout the 
scheduler timer usage as a fast clock for block requests etc.

And you have to realize that to me, as the top-level maintainer and one 
who seldom actually does big coding things, but just ends up making sure 
that people work with others, and fix the problems that crop up, *that* 
kind of behaviour is much much MUCH more important than the code itself.

Can you see that?

Can you see how big of a difference those whole approaches make? 

> Now I'll try to be a bit more constructive. I hope your benevolent 
> dictatorship allows self reflection.

Nobody is very good at self-reflection, I'm afraid. 

> Sure, the difference in behaviour (not in code) between SD and CFS is small, 
> and for me it doesn't matter. I'm fine with CFS in the kernel, it's a huge 
> improvement over the previous one. But why, while there was a seemingly good 
> alternative, did THAT one stay in that long? And this argument goes for more 
> code 'out there', btw.

Actually, nobody pushed SD to me, and neither Con nor anybody else tried 
to get me to merge it until some time in March of this year, I think.

Do you think I go trolling for code to merge? No. I actually _require_ 
that people send it to me, and that I also get the feeling that people are 
asking for it! 

In other words, my job is not to "merge code" (even though I sometimes 
describe it that way), my job is actually largely to "say no". You 
shouldn't see me as the person who goes out and tries to get everything 
together - quite the reverse. My job is to say "too late for the merge 
window", or "too experimental", or "you need to show numbers" or "are 
there going to be any _users_ for this"?

>  Some things get into the kernel, other don't. Some get in too soon, others 
> too late. Sure. But shouldn't we try to improve this process, instead of 
> saying 'it is what it is, get over it'?

Umm. The absolute *last* thing we want to do is to merge earlier. In fact, 
one of our biggest problems is that people send half-cooked stuff to me 
(and even more so, to Andrew). 

So in this case, if you've been on the CK mailing list, ask yourself: why 
wasn't parts of it pushed up to the standard kernel? Asking "why didn't 
Linus take it earlier" is exactly the wrong thing to do, since nobody even 
_asked_ me to. I never _ever_ got a patch saying "please merge this".

Seriously.

(Btw, on that note: please don't send me patches saying "please merge 
this". I want more than just that. I want an explanation, and I want it to 
be in many small pieces, and I want to feel like it got tested and is 
likely to be an obvious improvement).

So now look at what happened to CFS:

 - Ingo pushed it, and has been a maintainer of the area and shown himself 
   over years to be able to work with others and react to reports of 
   problems.

 - It was fairly obviously an improvement over the previous status quo
   (although I expect that there will be regressions - almost nothing is 
   ever a _pure_ improvement, if it's in any way non-trivial)

 - Even so, I asked for (and got) a series of independent patches.

Compare this to SD for a while. Ponder.

			Linus
