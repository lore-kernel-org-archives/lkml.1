Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYE0R4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYE0R4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYE0R4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:56:24 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41816 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351AbYE0R4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:56:24 -0400
Date: Tue, 27 May 2008 20:53:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC: 2.6 patch] let GROUP_SCHED depend on BROKEN
Message-ID: <20080527175336.GA11310@cs181133002.pp.htv.fi>
References: <20080527085830.GA20938@cs181133002.pp.htv.fi> <20080527142212.GA9076@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080527142212.GA9076@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 04:22:12PM +0200, Ingo Molnar wrote:
>...
> To make sure i'm accurate about this i just spent 15 minutes
> reviewing all your past commits to the Linux kernel using
> "git-shortlog --author=Bunk", and the rather sobering truth
> appears to be that:
> 
>   - you've _never_ before fixed a complex Linux kernel bug/problem

What is a "complex kernel problem"?

Just looking a bit through the last month:

E.g. http://lkml.org/lkml/2008/5/14/498 was not horribly complex, but 
for 3 days noone else had bothered to answer the request of the driver 
maintainer for help with this regression.

As you yourself said http://article.gmane.org/gmane.linux.kernel/676733
is something where I spotted a real bug just by reading through patches 
on linux-kernel. The bug might or might not have been complex, but since 
someone spotted it just when reading through patches (it's entirly 
possible someone else might have spotted it as well, but we will never 
know for sure) it never became a bug in any tree.

And for me stuff like http://lkml.org/lkml/2008/4/28/561 isn't complex, 
but quite frankly my impression is that I'm currently one out of only 
two people understanding our Kconfig files good enough for fixing such 
stuff.

>   - you've never before written a _single_ Linux kernel feature
>   - you've never before written a _single_ Linux driver

True.

I am not a coder.
I am just a cleanup and QA guy.

I know that this makes me a persona non grata for some people on this 
list, but I prefer doing what I'm good at (bugfixes and cleanup
patches, aiming at not introducing new bugs) over doing what I'm
bad at (writing code).

>   - you've never before done any true self-driven functional 
>     changes/improvements to Linux

I'd claim having started regression tracking (which was 100% self-driven)
was a functional improvement for Linux kernel development - and I don't 
care that you disagree on this.

>...
> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

