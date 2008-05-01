Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYEAA6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYEAA6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYEAA6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:58:13 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34949 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbYEAA6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:58:12 -0400
Date: Thu, 1 May 2008 03:57:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501005727.GO29330@cs181133002.pp.htv.fi>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org> <200805010023.32213.rjw@sisk.pl> <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org> <20080430154124.7ec08dd4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080430154124.7ec08dd4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 03:41:24PM -0700, Andrew Morton wrote:
> On Wed, 30 Apr 2008 15:31:22 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Any suggestions on how to convince people that their code is not worth 
> > merging?
> 
> Raise the quality.  Then the volume will automatically decrease.

100% ACK to "Raise the quality" (no matter whether it influences the volume).

> Which leads us to...  the volume isn't a problem per-se.  The problem is
> quality.  It's the fact that they vary inversely which makes us say "slow
> down".
> 
> So David's Subject: should have been "Do Better, please".  Slowing down is
> just a side-effect.  And, we expect, a tool.
> 
> 
> We should be discussing how to raise the quality of our work.

One big problem I see is Linus wanting to merge all drivers regardless 
of the quality.

Linus said in [1]:
"I'd really rather have the driver merged, and then *other* people can 
 send patches!"

The problem is that such "other people" do not exist (except perhaps Al) 
for non-trivial stuff.

My favorite gem from this driver we merged in 2.6.25 is:
  grep -C4 volatile drivers/infiniband/hw/nes/nes_nic.c

Fixing such stuff aren't "janitorial kind of things", and people are 
actually more motivated to fix their code for getting it into the kernel 
than to fix their code after it went into the kernel.

I am not saying we shouldn't merge such a driver at all or set 
unrealistic high quality goals - I'm for merging all code of good 
quality that provides functionality not yet into the kernel.

But we need some minimum quality level.

cu
Adrian

[1] http://lkml.org/lkml/2008/2/21/334

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

