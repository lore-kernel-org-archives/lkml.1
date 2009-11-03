Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbZKCQjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbZKCQjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbZKCQjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:39:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972AbZKCQjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:39:01 -0500
Date: Tue, 3 Nov 2009 08:37:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Marcel Holtmann <marcel@holtmann.org>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
In-Reply-To: <alpine.LFD.2.01.0911030815180.31845@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0911030827040.31845@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net>  <20091102.224957.32364226.davem@davemloft.net>  <20091103065238.GE3212@core.coreip.homeip.net>  <1257232587.3420.55.camel@localhost.localdomain>  <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain>
  <1257262588.3420.79.camel@localhost.localdomain>  <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain> <1257264485.3420.87.camel@localhost.localdomain> <alpine.LFD.2.01.0911030815180.31845@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Nov 2009, Linus Torvalds wrote:
> 
> And yes, "dealing with it" very much means by-passing maintainers if 
> necessary. It can mean sending patches directly to me, but it _also_ means 
> asking me to just revert a commit that turns out to be buggy and was 
> merged late.

By the way, the "if necessary" part obviously means that I'll be very 
happy if it all happens through maintainers. I'm absolutely _not_ arguing 
for sending patches directly to me if there is a better way of doing 
things. 

But I do think that especially as a user who finds a problem, an email 
saying "please revert" is a great thing to send to me when you've 
identified a problem - especially late in the -rc series.

Of course, you should always Cc: all the people in the patch (author _and_ 
the sign-off-chain), to give them the opportunity to ask the reporter to 
try another patch or to ask me to pull a fix.

Especially as nobody reads email 24/7 and we're all on slightly different 
clocks (even within the same timezone we have different schedules: I start 
readin mail at 7:30AM, which is probably _not_ what most techies do), so 
the optimal situation is that by the time I see the revert request, I 
_also_ have another email in my mailbox saying "oh, apply this patch 
instead".

So the different schedules _can_ be an advantage, and it's why email is 
such a great communication medium for being "immediate, but asynchronous". 
We can have overlapping work, and be very efficient when things work well.

The pessimal solution, on the other hand, is to have a very rigid 
"channel" so that we end up waiting for several people in a long chain, 
all of which are on different schedules, and so each step takes a day or 
so to percolate.

Which is what I think happened now. 

			Linus
