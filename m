Return-Path: <linux-kernel-owner+w=401wt.eu-S933382AbYEUV06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbYEUV06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYEUV0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:26:48 -0400
Received: from 1wt.eu ([62.212.114.60]:4742 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839AbYEUV0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:26:47 -0400
Date: Wed, 21 May 2008 23:25:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, gorcunov@gmail.com, tytso@mit.edu,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: CFD: linux-wanking@vger.kernel.org
Message-ID: <20080521212547.GB6749@1wt.eu>
References: <20080521104644.5b6f4e63.akpm@linux-foundation.org> <20080521185725.GD6932@cvg> <20080521123127.3b3b66af.akpm@linux-foundation.org> <20080521.131046.242739198.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521.131046.242739198.davem@davemloft.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 01:10:46PM -0700, David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Wed, 21 May 2008 12:31:27 -0700
> 
> > The #1 project for all kernel beginners should surely be "make sure
> > that the kernel runs perfectly at all times on all machines which you
> > can lay your hands on".  Usually the way to do this is to work with
> > others on getting things fixed up (this can require persistence!) but
> > that's fine - it's a part of kernel development.
> 
> Indeed.  A lot of the time I see new people, or people making
> suggestions to them, so fixated on wanting to implement new features.

I think that they are often young and want to get their name associated
to something their friends can touch.

> To me that is absolutely the wrong way to go about this.
> 
> It's so much more useful, for both the community and the individual,
> to fix bugs.  Fixing a bug forces you to learn how the kernel works at
> least on some level, and fixing a bug always makes Linux better.
> 
> Implementing a new feature does not necessarily have either of those
> two important qualities, so it is never the place for new people to
> start.
> 
> Fixing bugs will give someone a real identity and place in the
> community.
> 
> You want real Linux kernel "street cred"?  Fix a lot of bugs, then you
> can implement a thousand new features and people will take you
> seriously because you've shown that you can and will fix things.

Not that much for newbies. Linux is thought^Wknown to be bug-free. People
don't get a name by claiming everywhere "hey, I found bug X which I could
trigger by doing stupid thing Y, and I could fix it, I've contributed".

On the opposite, they have the ability to say "hey friends, now you can
buy webcam XX, I have implemented support for it" (often meaning
"I send a PCI ID update"). This is a lot more rewarding for them.
I've encountered a lot of them. There is a general culture of visible
and measurable results, and that's why people focus more on creating
than fixing.

Speaking for myself, I clearly prefer being responsible of getting
something to work very well and have happy users than to have a ton
of users whine about my bugs. But I know this is not common, and I
often see people asking what motivates me in stabilizing things and
even if I get paid for this ! On the other side, when the same people
see my name on some doc, they suddenly look at me as someone very
clever, which is completely stupid, given the fact that I'm probably
one of the smallest contributors of new code. But that's the way
people compare themselves and judge their fellow men, and it's not
going to change :-(

Git certainly has made things worse. We're not as careful as we used
to be about credits in the files since everything is in the changelogs.
And since it's easier to post 3 whitespace patches than 1 bug fix,
there are people posting stupid patches to get their name in a shortlog
and tell their friends.

If we want to get more manpower on bug hunting, we should really
think about what type of work we need, and simply assign credit
to people. Let's maintain scores for people doing painful bisect,
posting fixes for real bugs, etc... and get this file directly
linked to from kernel.org.

I'm really really sure we'd suddenly get more people working on
regressions and provide a fix for their oopses (or even their
friends'). Also attribute "tested-by" credits. We need people
to test the fixes. Let's incitate them.

I don't know what workflow we could use for this, as it is probably
not easy and will require more manual work (or maybe have scripts
look for particular tags ?). But I'm sure it works. We should not
try to change contributors, just take what is good in them and bring
them what they seek.

Willy

