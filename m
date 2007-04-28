Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbXD1X6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbXD1X6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbXD1X6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:58:42 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754399AbXD1X6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:58:41 -0400
Date: Sat, 28 Apr 2007 16:58:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <20070428230416.GF3468@stusta.de>
Message-ID: <alpine.LFD.0.98.0704281645100.9964@woody.linux-foundation.org>
References: <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>
 <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
 <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com>
 <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
 <20070426224148.69b91b2e.diegocg@gmail.com>
 <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
 <20070428195320.GZ3468@stusta.de> <alpine.LFD.0.98.0704281529080.9964@woody.linux-foundation.org>
 <20070428230416.GF3468@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Apr 2007, Adrian Bunk wrote:
> 
> Bugzilla has an email interface.
> Andrew forwards bugs from Bugzilla to developers.

Yes. And if you search around, you'll even see that I occasionally use it. 

But it's useful only once the bug has been assigned and somebody has 
actually *looked* at it. The fact that some people do this is a big credit 
(Andrew, Dave J etc)

> There might be small room for improvements, but I don't see how 
> man-power or technology could make a big difference in this area.

I'm talking about getting the developers to _look_ at the bugs in the 
first place. Bugzilla is not very good at that, because it has no useful 
interfaces for doing so (unless you can specify your area of interest so 
exactly that you can actually set yourself up as a maintainer of one 
particular area).

Almost none of the subtle (and thus harder) bugs tend to fall into that 
kind of nice category. 

For example, look at suspend/resume bugs. Do you realize that 99% of them 
are device driver issues, but how the heck do you connect a "my laptop 
does't resume" to the _right_ device driver maintainer?

And do you realize (and acknowledge) that it would be total madness to 
send all suspend/resume bugs to _everybody_ who maintains any device 
driver at all?

See? THAT is the problem with bugzilla. It only works for the "easy" 
cases. It works for the case where a reporter can say with certainty that 
the reason his machine doesn't boot is a particular network device driver 
(like the sis900 regression we had in 2.6.21). But once you know the 
subarea that precisely, bugzilla doesn't even help you that much, and it's 
likely easier and more productive to just send email directly to the right 
person and cc Jeff and netdev or something!

> "*once* you've found and gotten the right developer involved" is the 
> real problem, not how to track bugs.

And I agree 100%.

And bugzilla does *nothing* here.

> *This* is *the* problem.
> And no change in bug tracking will help with this problem.

So why are you pushing bugzilla? 

There are actually better bug trackers around. One of them is "google". 
For oopses, one of the thngs I do is to put in the most relevant 
information (backtrace etc) into google, and ask google to try to find the 
pattern. That sometimes actually does pretty well - you can get a real 
feel for "oh, there's a pattern here - they're all AMD machines with the 
NVidia chipset" kind of thing.

Bugzilla doesn't offer anything even remotely as useful. 

It's the "big picture" that tends to be hard to find.

And that's what *you* gave with the regression report. A summary. You even 
noted some of the patterns, so people actually had them already somewhat 
pre-sorted.

THAT is what we want.

But another way to get the "high-level picture" is to actually just say 
"what's active now". And that's why I think the whole "1600 open 
bug-reports" kind of thing is useless. Bugzilla does *not* have mail 
interfaces for that kind of "these 50 bugs were actively reported on and 
unresolved" in the last week summaries! 

(And if it did, it would still almost certainly need some human care and 
understanding)

		Linus
