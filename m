Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbYEACO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbYEACO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbYEACOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:14:14 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37428 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbYEACON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:14:13 -0400
Date: Thu, 1 May 2008 05:13:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501021327.GS29330@cs181133002.pp.htv.fi>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org> <200805010023.32213.rjw@sisk.pl> <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org> <20080430154124.7ec08dd4.akpm@linux-foundation.org> <20080501005727.GO29330@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804301821380.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804301821380.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 06:25:50PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 1 May 2008, Adrian Bunk wrote:
> > 
> > One big problem I see is Linus wanting to merge all drivers regardless 
> > of the quality.
> 
> That's not what I said.
> 
> What I said was that I think we get *better* quality by merging early.
> 
> In other words, you're turning the whole argument on its head, and 
> incorrectly so.
> 
> I claim that you are the one that is arguing for *worse* quality, by 
> arguing for a process that is KNOWN to tend to generate bad code 
> (out-of-tree drivers) as opposed to one that tends to fix things over time 
> (and note the "tends" in both cases - there are counter-examples, but 
> the trend is so clear that anybody who disputes it would seem to be either 
> blind or lying).
>...

I am *not* saying it should have stayed out-of-tree.

I am saying that it was merged too early, and that there are points that 
should have been addressed before the driver got merged.

Get it submitted for review to linux-kernel.
Give the maintainers some time to incorporate all comments.
Even one month later it could still have made it into 2.6.25.

The only problem with my suggestion is that it's currently pretty random 
whether someone takes the time to review such a driver on linux-kernel.

And even if I'm getting fire for this again (and different from newbies 
running checkpatch on the kernel) for driver submissions it actually 
makes sense to tell the submitter to fix the checkpatch errors [1], and 
it would have made the driver better in this case (again, it could still 
have made it into 2.6.25).

People are actually more motivated to fix their code for getting it into 
the kernel than to fix their code after it went into the kernel, so we 
might get better quality when merging a bit later.

> 			Linus

cu
Adrian

[1] not necessarily all checkpatch warnings

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

