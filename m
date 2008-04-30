Return-Path: <linux-kernel-owner+w=401wt.eu-S1765097AbYD3UGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765097AbYD3UGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759748AbYD3UGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:06:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758772AbYD3UGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:06:09 -0400
Date: Wed, 30 Apr 2008 13:05:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <200804302136.58005.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Apr 2008, Rafael J. Wysocki wrote:
> 
> IMO, the merge window is way too short for actually testing anything.

That is largely on purpose.

There's two choices:

 - have a longer and calmer merge window, spread out the joy, and have 
   people test and fix their things during the merge window too. In other 
   words, less black-and-white.

 - Really short merge window, and use the extra time *after* it to fix the 
   issues.

and I've obviously gone for the latter. In fact, I'd personally like to 
make it even shorter, because the problem with the long merge window can 
be summed up very simply:

   Long merge windows don't work - because rather than test more, it just 
   means that people will use them to make more changes!

So one of the major things about the short merge window is that it's 
hopefully encouraging people to have things ready by the time the merge 
window opens, because it's too late to do anything later.

And yes, we could have some other way of enforcing that - allow the merge 
window to be longer, but have some other mechanism to make sure that I 
only merge old code. 

In fact, I'd personally *love* to have a hard rule that says "I will only 
pull from trees that were already 'done' by the time the window opened", 
and we've been kind-of moving in that direction.

But that wish is counteracted by the fact that the merges themselves do 
need some development, so expecting everything to be ready before-hand is 
simply not realistic. 

Also, while I'd like trees to be ready when the window opens, at the same 
time I do think that it's good to spread out some of it, and get *some* 
basic testing - even if it's just a nightly build and a few tens of 
developers.

> I rebuild the kernel once or even twice a day and there's no way I can 
> really test it. I can only check if it breaks right away.

And really, that's all that we'd expect during the merge window. We want 
to find the *obvious* problems - build issues, and the things that hit 
everybody, but let's face it, the subtle ones will take time to find 
regardless.

Then, the short merge window means that we have more time when we really 
don't have big changes going in to find the subtle ones.

(And making the release cycle longer would *not* help - that would just 
make the next merge window more painful, so while it can, and does, work 
for some individual release with particular problems, it's not a solution 
in the long run).

			Linus
