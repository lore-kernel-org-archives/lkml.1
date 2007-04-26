Return-Path: <linux-kernel-owner+w=401wt.eu-S1031432AbXDZSnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031432AbXDZSnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031434AbXDZSnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:43:12 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031432AbXDZSnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:43:10 -0400
Date: Thu, 26 Apr 2007 11:42:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Diego Calleja <diegocg@gmail.com>
cc: Chuck Ebbert <cebbert@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <20070426201325.8a1ebda3.diegocg@gmail.com>
Message-ID: <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
 <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>
 <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
 <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Diego Calleja wrote:
> 
> From my humble POV, it's a problem that all this discussion was generated
> on what Adrian does or stop doing. Apparently, unless Adrian posts his
> list of know regressions, most of the people doesn't look at the bugzilla
> at all. Maybe it'd be useful to create a per-release bug tracker in the
> bugzilla or collect them into one of the a kernel.org's wiki, to make easier
> to follow the current state of all the "important" regressions. 

Any web-based interface is a no-no. It's one reason I don't use bugzilla a 
lot. If I can't get it by email, it doesn't exist, as far as I'm 
concerned.

I bet that's true even of a lot of people who are more "web oriented" than 
I am. They may look at webpages, but getting notified by email is still 
the wakeup call. There's a difference between "active and directed pushing 
to the involved people" and "the resource exists, that people could look 
at".

So it would have to be more than just a wiki or a bugzilla entry. It would 
have to have that weekly email status thing, and I think that it needs to 
have some human who tries to find messages on the kernel mailing list too, 
and make a first-level judgement on the bugs. Adrian was doing a good job.

But it doesn't necessarily need somebody with intimate knowledge of the 
kernel. In fact, almost everybody who *does* have intimate knowledge tends 
to have so in a very specific area (nobody knows everything - and that 
very much includes people like me and Andrew too) and maybe be skewed in 
other ways too, so a "generalist" is probably more useful than somebody 
who is a "deep coder" in some subsystem.

And it almost certainly doesn't have/prefer to be _one_ person. I suspect 
that this is something where it actually might be better to have some 
collection of people interested in it, and yes, perhaps editing a wiki is 
part of the process, but with at least that "automated email" thing going 
on in additin (and it needs to go to the people involved, not just the 
kernel mailing list - so part of it is not just gathering the reports 
themselves, but also gathering target addresses from MAINTAINERS files and 
perhaps git logs etc).

And yes, it's quite possibly a good way to get into kernel development - 
it definitely helps to know about programming, but as mentioned, I don't 
think it is something where you even need to know specifically about 
*kernel* programming per se.

For example, I don't think it was an accident that Adrian (who has been 
involved in kernelnewbies, janitors and the trivial tree) was the one who 
picked it up. That's exactly the kind of involvement that the regression 
tracking is all about!

(In fact, I think regression tracking might be "easier" to get into than 
actually getting into some of the janitorial projects, exactly because 
it's less about coding. The fact that a person who tracks regressions 
might then *also* indirectly get into the code itself would just be a big 
additional bonus!)

So yes, some automation can almost certainly help (especially if there are 
multiple people involved), but I think a lot of it is that "human 
judgement" and ability to group things and communicate. Are there any 
kernel janitors/newbies/mentors that can think of people who would want to 
do something like this?

			Linus
