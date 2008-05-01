Return-Path: <linux-kernel-owner+w=401wt.eu-S1764966AbYEASzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764966AbYEASzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbYEASzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:55:09 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50440 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792AbYEASzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:55:08 -0400
Date: Thu, 1 May 2008 21:54:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501185419.GL29330@cs181133002.pp.htv.fi>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org> <200805010023.32213.rjw@sisk.pl> <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org> <20080430154124.7ec08dd4.akpm@linux-foundation.org> <20080501005727.GO29330@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804301821380.5994@woody.linux-foundation.org> <20080501021327.GS29330@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804301919080.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804301919080.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 07:30:13PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 1 May 2008, Adrian Bunk wrote:
> > 
> > I am saying that it was merged too early, and that there are points that 
> > should have been addressed before the driver got merged.
> > 
> > Get it submitted for review to linux-kernel.
> > Give the maintainers some time to incorporate all comments.
> > Even one month later it could still have made it into 2.6.25.
> > 
> > The only problem with my suggestion is that it's currently pretty random 
> > whether someone takes the time to review such a driver on linux-kernel.
> 
> Now, I do agree that we could/should have some more process in general. I 
> really _would_ like to have a process in place that basically says:
> 
>  - everything must have gone through lkml at least once
> 
>  - after that point, it should have been in linux-next or the -mm queue
> 
>  - and then it can get merged (and if it didn't get any review by then, 
>    maybe it was because nobody was interested, and it simply won't be 
>    getting any until it oopses or catches peoples interest some other way)
> 
> HOWEVER.
> 
> That process doesn't actually work for everything anyway (a lot of trivial 
> fixes are really best not being so noisy, and various patches that are 
> specific to some subsystem really _are_ better off just discussed on that 
> subsystem mailing lists).

Cc linux-kernel on 3 patches "specific to some subsystem" that add the 
word "select" to Kconfig files and I'll catch at least one bug before it 
enters your tree...

> And perhaps more pertinently, right now that kind of process is very 
> inconvenient (to the point of effectively being impossible) for me to 
> check. Obviously, if the patch comes from Andrew, I know it was in -mm, 
> and I seldom drop those patches for obvious reasons anyway, but the last 
> thing we want is some process that depends even _more_ on Andrew being a 
> burnt-out-excuse-for-a-man in a few years (*).
> 
> So I could ask for people to always have pointers to "it was discussed 
> here" on patches they send (and I'd likely mostly trust them without even 
> bothering to verify), the same way -git maintainers often talk about "most 
> of this has been in -mm for the last two months".

It should be enough to trust maintainers that they follow the rules.

And in the unlikely case someone didn't follow them you know whom you 
have to watch closely during his next merge requests...

> That might work. But then there would still be the patches that are 
> obvious and don't need them.
> 
> And then even the obvious patches do break. And people will complain. Even 
> though requiring that kind of process for the stupid stuff would just slow 
> everybody down, and would be really painful.

There's a middle way.

Requiring the submission of bigger changes and new drivers to be Cc'ed 
to linux-kernel can help and shouldn't cause real problems.

And requiring this kind of patches to be in linux-next for some time
should also be possible.

Both can improve the quality of the kernel.

Trivial patches and bugfixes might not have to follow these rules, but 
that's similar to e.g. the current merge window process also having 
exceptions for new drivers. 

>...
> 			Linus
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

