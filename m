Return-Path: <linux-kernel-owner+w=401wt.eu-S1751030AbYEABlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030AbYEABlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYEABlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:41:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779AbYEABlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:41:14 -0400
Date: Wed, 30 Apr 2008 18:40:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <20080430224610.GO8474@1wt.eu> <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org> <200805010242.36775.rjw@sisk.pl> <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Apr 2008, Linus Torvalds wrote:
> 
> You (and Andrew) have tried to argue that slowing things down results in 
> better quality,

Sorry, not Andrew. DavidN.

Andrew argued the other way (quality->slower), which I also happen to not 
necessarily believe in, but that's a separate argument.

Nobody should ever argue against raising quality.

The question could be about "at what cost"? (although I think that's not 
necessarily a good argument, since I personally suspect that good quality 
code comes from _lowering_ costs, not raising them).

But what's really relevant is "how?"

Now, we do know that open-source code tends to be higher quality (along a 
number of metrics) than closed source code, and my argument is that it's 
not because of bike-shedding (aka code review), but simply because the 
code is out there and available and visible.

And as a result of that, my personal belief is that the best way to raise 
quality of code is to distribute it. Yes, as patches for discussion, but 
even more so as a part of a cohesive whole - as _merged_ patches!

The thing is, the quality of individual patches isn't what matters! What 
matters is the quality of the end result. And people are going to be a lot 
more involved in looking at, testing, and working with code that is 
merged, rather than code that isn't.

So _my_ answer to the "how do we raise quality" is actually the exact 
reverse of what you guys seem to be arguing.

IOW, I argue that the high speed of merging very much is a big part of 
what gives us quality in the end. It may result in bugs along the way, but 
it also results in fixes, and lots of people looking at the result (and 
looking at it in *context*, not just as a patch flying around).

And yes, maybe that sounds counter-intuitive. But hey, people thought open 
source was counter-intuitive. I spent years explaining why it should work 
at all!

			Linus
