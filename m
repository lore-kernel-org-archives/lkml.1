Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbYDJPHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbYDJPHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbYDJPHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:07:35 -0400
Received: from rtr.ca ([76.10.145.34]:2427 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326AbYDJPHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:07:34 -0400
Message-ID: <47FE2D34.10104@rtr.ca>
Date: Thu, 10 Apr 2008 11:07:32 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: yoshfuji@linux-ipv6.org, jeff@garzik.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
References: <47FD138B.2060801@rtr.ca>	<20080409.152933.132174258.davem@davemloft.net>	<47FD590C.5020003@rtr.ca> <20080409.182228.193699767.davem@davemloft.net>
In-Reply-To: <20080409.182228.193699767.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Mark Lord <lkml@rtr.ca>
> Date: Wed, 09 Apr 2008 20:02:20 -0400
> 
>> Really, folks.  Bug reports are intended to *help* the developers,
>> not something to be thrown back in their faces.
> 
> It's a two way street, we asked for a bisect which helps us a lot.
..

No, that's a one-way street, where the developers insist that the bug discover
do 100% of the work of finding/fixing the bug.

A two-way street is when we help each other, where the developers
might point out some likely commits, and the bug discover takes
additional time to patch/retest around them.

Years ago, Linus suggested that he opposed an in-kernel debugger
mainly because he preferred that we *think* more about the problems,
rather than just finding/fixing symptoms.

This 100% reliance upon git-bisect is worse than that.
It has people now just tossing regressions into the code left and right,
knowing that they can toss all of the testing back at the poor folks
whose systems end up not working.

> In fact, lately I notice a strong unwillingness to bisect on your
> part, in particular.
..

I just happen to find/report a lot of regressions.
And every single damn one so far has taken days of my
time to track down, and in most cases fix by myself.

All of them up until this one, have not been bisectable.
Yes, this one does seem to reproduce reliably now,
so it could be bisected if I wanted to take another day
out of my life for it.

I did bisect one other issue back in 2.6.24 (or .23?),
and that took about 9 hours in total.

I'd really like a hand or two with some of these bugs
at some point from the folks who keep breaking things.

Cheers
