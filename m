Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbYD3UqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbYD3UqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbYD3UqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:46:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46332 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432AbYD3UqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:46:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Slow DOWN, please!!!
Date: Wed, 30 Apr 2008 22:45:49 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804302245.50817.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 of April 2008, Linus Torvalds wrote:
> 
> On Wed, 30 Apr 2008, Rafael J. Wysocki wrote:
> > 
> > IMO, the merge window is way too short for actually testing anything.
> 
> That is largely on purpose.
> 
> There's two choices:

Oh well, I don't think it's really that simple.

>  - have a longer and calmer merge window, spread out the joy, and have 
>    people test and fix their things during the merge window too. In other 
>    words, less black-and-white.
> 
>  - Really short merge window, and use the extra time *after* it to fix the 
>    issues.
> 
> and I've obviously gone for the latter. In fact, I'd personally like to 
> make it even shorter, because the problem with the long merge window can 
> be summed up very simply:
> 
>    Long merge windows don't work - because rather than test more, it just 
>    means that people will use them to make more changes!

And what do you think is happening _after_ the merge window closes, when
we're supposed to be fixing bugs?  People work on new code.  And, in fact, they
have to, if they want to be ready for the next merge window.

> So one of the major things about the short merge window is that it's 
> hopefully encouraging people to have things ready by the time the merge 
> window opens, because it's too late to do anything later.
> 
> And yes, we could have some other way of enforcing that - allow the merge 
> window to be longer, but have some other mechanism to make sure that I 
> only merge old code. 

How about, instead, putting limits on the amount of stuff that's going to be
merged during the next window?

> In fact, I'd personally *love* to have a hard rule that says "I will only 
> pull from trees that were already 'done' by the time the window opened", 
> and we've been kind-of moving in that direction.

Well, and when's the time for fixing bugs?  Surely not during the merge window
and also not after that, because otherwise people won't be ready for the next
merge window with the new code.

> But that wish is counteracted by the fact that the merges themselves do 
> need some development, so expecting everything to be ready before-hand is 
> simply not realistic. 
> 
> Also, while I'd like trees to be ready when the window opens, at the same 
> time I do think that it's good to spread out some of it, and get *some* 
> basic testing - even if it's just a nightly build and a few tens of 
> developers.
> 
> > I rebuild the kernel once or even twice a day and there's no way I can 
> > really test it. I can only check if it breaks right away.
> 
> And really, that's all that we'd expect during the merge window. We want 
> to find the *obvious* problems - build issues, and the things that hit 
> everybody, but let's face it, the subtle ones will take time to find 
> regardless.

Exactly.  Moreover, the code is now being merged at a pace that makes it
physically impossible to review it given the human resources we have.
 
> Then, the short merge window means that we have more time when we really 
> don't have big changes going in to find the subtle ones.

Sorry to say that, but I don't think this is realistic.  What happens after the merge
window is people go and develop new stuff.  They look at the already merged
code only if they have to.  Also, there are a _few_ people testing the kernel
carefully enough to see the more subtle problems, let alone debugging and
fixing them.

> (And making the release cycle longer would *not* help - that would just 
> make the next merge window more painful, so while it can, and does, work 
> for some individual release with particular problems, it's not a solution 
> in the long run).

My point is, given the width of the merge windown, there's too much stuff
going in during it.  As far as I'm concerned, the window can be a week long
or whatever, but let's make fewer commits over a unit of time.

Thanks,
Rafael
