Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbYEACtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbYEACtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbYEACt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:49:28 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41400 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbYEACt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:49:28 -0400
Date: Thu, 1 May 2008 05:48:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       tglx@linutronix.de
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501024843.GV29330@cs181133002.pp.htv.fi>
References: <20080430.142137.236846072.davem@davemloft.net> <20080430221936.GA27292@elte.hu> <20080430223509.GA31547@elte.hu> <20080430.155149.210532797.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080430.155149.210532797.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 03:51:49PM -0700, David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu, 1 May 2008 00:35:09 +0200
> 
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > What we need is not 'negative reinforcement'. That is just nasty, open 
> > > warfare between isolated parties, expressed in a politically correct 
> > > way.
> > 
> > in more detail: any "negative reinforcement" should be on the 
> > _technical_ level, i.e. when changes are handled - not at the broad tree 
> > level.
> 
> Sure, and I'll provide some right here.
> 
> Ingo, let me know what I need to do to change your behavior in
> situations like the one I'm about to describe, ok?
> 
> Today, you merged in this bogus "regression fix".
> 
> commit ae3a0064e6d69068b1c9fd075095da062430bda9
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Apr 30 00:15:31 2008 +0200
> 
>     inlining: do not allow gcc below version 4 to optimize inlining
>     
>     fix the condition to match intention: always use the old inlining
>     behavior on all gcc versions below 4.
>     
>     this should solve the UML build problem.
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Did you actually read the UML build failure report?
> 
> Adrian Bunk specifically stated that the UML build failure regression
> occurs with GCC version 4.3
> 
> Next, did you test this regression fix?
> 
> Next, if you could not test this regression fix, did you wait
> patiently for the bug reporter to validate your fix?  Adrian
> responded that it didn't fix the problem, but that was after
> you queued this up to Linus already.
>...

You got the facts wrong, it is even worse:

It was Ingo himself who reported this bug. [1]

Ingo managed to send an untested and not working patch for a bug he 
reported himself...

cu
Adrian

BTW: I finally figured out what is behind the problems on UML, and this
     is not related to any recent kernel changes.
     Patch comes when I'm awake again.

[1] http://lkml.org/lkml/2008/4/26/151

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

