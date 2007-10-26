Return-Path: <linux-kernel-owner+w=401wt.eu-S1762762AbXJZWZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762762AbXJZWZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbXJZWYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:24:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56876 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754932AbXJZWYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:24:53 -0400
Date: Fri, 26 Oct 2007 15:24:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Giacomo Catenazzi <cate@cateee.net>
cc: Bart Van Assche <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <4722600A.4090903@cateee.net>
Message-ID: <alpine.LFD.0.999.0710261453160.30120@woody.linux-foundation.org>
References: <e2e108260710260729x4603211cgb68d7434ce1e54e9@mail.gmail.com>
 <e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com>
 <alpine.LFD.0.999.0710260756260.30120@woody.linux-foundation.org>
 <4722600A.4090903@cateee.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Giacomo Catenazzi wrote:
> 
> So we have the great opportunity to change the standard, then
> gcc will change ;-)

I see the smiley, but sadly, new standards take ten years or more to 
mature. Which means that even if the upcoming one is "perfect", things 
will be wrong with it, if only because people will have new usage 
scenarios where the standard simply isn't relevant or that it otherwise 
just doesn't address, and that then gets us back to the same issues 
somewhere else.

So it would be much better if developers just didn't think the standard 
trumped "real and existing code and problems", and shot down the language 
lawyers (and don't get me wrong - it's not just in gcc, btw. We _have_ had 
some of the same behavior in the kernel, although I will argue that our 
"backwards compatibility trumps pretty much everything else" rules at 
least solves _some_ of the problems).

Standards are just papers. Yes, they're important, but they are definitely 
not more important than anything else, and they are a lot _less_ important 
than some people seem to think. Gcc has done more for programming by being 
a de-facto standard and widely available, than the _paper_ standards often 
ever do!

It's also sad that a lot of these things seem to be done in the name of 
optimizing code, and then in many cases it drives people *away* from using 
that optimizer for anything but benchmarking.

In the kernel, we historically used to try for extreme optimizations, 
these days we spend more time tuning the optimizations _down_ because they 
aren't optimizations at all (ie using -Os instead of -O2), or they were 
buggy enough that we have to explicitly disable them (aliasing, 
"unit-at-a-time" etc).

			Linus


