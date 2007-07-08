Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbXGHWoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbXGHWoX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 18:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbXGHWoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 18:44:14 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54945 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756210AbXGHWoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 18:44:13 -0400
Date: Mon, 9 Jul 2007 00:44:44 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Please revert 21564fd2a3deb48200b595332f9ed4c9f311f2a7
Message-ID: <20070708224444.GU3492@stusta.de>
References: <20070617214231.GA3588@stusta.de> <46760D87.2000502@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46760D87.2000502@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 09:43:51PM -0700, Jeremy Fitzhardinge wrote:
> Adrian Bunk wrote:
>...
> > Andi forwarded it although the following people had already NAK'ed it:
> > - Christoph Hellwig [1]
> > - Peter Zijlstra [2]
> > - Alan Cox [3]
> >
> > Considering that Andi forwarded it 2 days after he himself said a 
> > different solution was pending [4] I assume he mistakenly sent it for 
> > inclusion in your tree.
> >   
> 
> We played with some ideas, but they all turned out way too ugly to live. 

Andi got some NAK's, said himself it will be solved differently, and
two days later he submits the NAK'ed patch into Linus' tree.

Was this a mistake that should be reverted at least for now because of 
this, or is silently doing the opposite of what you said you'd do how
Linux development is expected to work today?

> > Reverting is safe since it simply re-establishes the 2.6.21 status quo.
> 
> Well, not really.  It breaks any non-GPL module when CONFIG_PARAVIRT is
> enabled, even though the same module would work fine otherwise.  That's
> a pretty large regression.
>...

The 2.6.21 status quo can by definition not be a regression compared
to 2.6.21.

>     J

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

