Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbYD3SVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbYD3SVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYD3SVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:21:33 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:34890 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759340AbYD3SVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:21:32 -0400
Message-ID: <4818B8A7.4000902@davidnewall.com>
Date: Thu, 01 May 2008 03:51:27 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net> <4817EF91.4080800@davidnewall.com> <20080429.211835.130816277.davem@davemloft.net> <48186E57.5070805@davidnewall.com> <alpine.LFD.1.10.0804300739350.2997@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804300739350.2997@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Can you point to any actual stability problem?
>   

Well of course.  So could you because they are a matter of public record
on the list.  Don't pretend otherwise.  Just to give you some recent,
personal bugaboos, and not even drawing on the many hundreds of relevant
messages on LKML each month:

1. Out of memory, caused by apparent leak somewhere, resulting in
machine effectively hanging for a minute or two (massive disk i/o)
culminating in termination of one or more processes.  (For what it's
worth: 512MB, no swap.)  Problem takes a couple of days to develop
(hence I suspect a leak.)  This is running only Firefox, Thunderbird and
Evince, plus whatever xubuntu wants.  Restarting the killed
application(s) causes the problem to recur.  Restarting X doesn't help. 
Killing almost all processes also doesn't help.  Reboot is required. 
This problem seems not to be in 2.6.17, but is in 2.6.22 (plus whatever
patches xubuntu use) and 2.6.23.  I'm still testing 2.6.25, but probably
going to have to abandon it and go backwards, because...

2. Suspend to disk doesn't resume properly (two out of three times.) 
System comes back but X has severe wierdness.  Draws frames and title
bar, but not window contents.  Text-mode is just as bad: Screen is blank
(erased font table, perhaps?)  Subsequent suspend to disk doesn't resume
at all.

Note the wide range of kernels exhibiting problem 1.  I don't even want
to think about problem 2 at this stage; I just want to stop having to
reboot to reclaim memory, especially when a mate who does Windows
training visits!


> the fundamental issue is that we are just 
> too damn good at development.
>   

Not so good.  The process is flawed.  Inadequate testing.  Inadequate
review.  This has been mentioned by others, so you know I'm not making
it up.  The real fundamental issue is that people are too keen to
release and don't appear to care enough about correctness.

> you think that mentioning BSD as some 
> kind of shining example of goodness is a good way to reach that agenda.

Yes, BSD does seem to be a shining example of goodness, but I didn't
mention it because I think people should switch.  I did so to warn of
competition, to say that the world does not owe Linux a second chance
and isn't going to give it one.  It's pointless to debate the relative
merits of the two systems because, aside from the kernel, they are
identical; and there's little that matters between the kernels, other
than one appears to have a careful, robust and professional development
process.  Make no mistake about this point: I'm not saying that BSD is
better, rather that Linux cannot lose credibility and survive.

> But you know what? I really don't care one _whit_ what you do. You can 
> switch to Vista for all I care, and I really don't mind. All I care about 
> is doing a good job technically. 
>   
Sadly, you're doing a bad technical job in certain, important areas. 
You're pushing out buggy kernels and claiming that they're stable.  This
can't continue.  Attrition to BSD is the risk, not some threat that I'm
making.

> And you just show that you don't have a clue what you are talking about. 
> If you want stable kernel, don't follow the current -git tree.

Why are you bringing up git trees (which I don't use)?  I'm presently
plagued with a problem that's 2.6.22 or older, extending to at least
2.6.23 and maybe still current.  I've said quite clearly that I'm
talking about "stable" kernels, yet you presume I mean the git tree. 
Yet it's not the specifics of the problem I'm having that matters, it's
the systemic problems in Linux's development process.

I don't think I've anything to add unless the topic evolves in a
direction that asks what should be changed.  I'm posting this only
because I want on record the answer to the question about actual
stability problems.
