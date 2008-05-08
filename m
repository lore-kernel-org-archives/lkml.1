Return-Path: <linux-kernel-owner+w=401wt.eu-S1761664AbYEHTn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761664AbYEHTn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYEHTnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:43:46 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47669 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbYEHTno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:43:44 -0400
Date: Thu, 8 May 2008 22:42:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080508194220.GB22887@cs181133002.pp.htv.fi>
References: <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080508153343.GD7718@cs181133002.pp.htv.fi> <20080508154116.GA17338@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080508154116.GA17338@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 05:41:16PM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > Can we get that verified and the description updated before it hits 
> > Linus' tree?
> 
> that's not needed. Mike's fix is correct, regardless of whether it fixes 
> the other regression or not.

Then scrap the part about it possibly fixing a regression and the
Reported-by: line.

> > Otherwise this "could be related" will become unchangable metadata 
> > that will stay forever - no matter whether there's any relation at 
> > all.
> 
> ... and the problem with that is exactly what?

It is important that our metadata is as complete and correct as 
reasonably possible. Our code is not as well documented as it should be, 
and in my experience often the only way to understand what happens and 
why it happens is to ask git for the metadata (and I'm actually doing 
this even for most of my "trivial" patches).

In 3 hours or 3 years someone might look at this commit trying to 
understand what it does and why it does this.

And there's a big difference between "we do it because it's correct from 
a theoretical point of view" and "it is supposed to fix a huge 
performance regression".

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

