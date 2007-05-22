Return-Path: <linux-kernel-owner+w=401wt.eu-S965440AbXEVPSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440AbXEVPSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbXEVPSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:18:17 -0400
Received: from ns.suse.de ([195.135.220.2]:55474 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289AbXEVPSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:18:16 -0400
Date: Tue, 22 May 2007 17:18:14 +0200
From: Karsten Keil <kkeil@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, kai.germaschewski@gmx.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ISDN: move card state init to separate function
Message-ID: <20070522151814.GA4280@pingi.kke.suse.de>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	Andrew Morton <akpm@linux-foundation.org>, kai.germaschewski@gmx.de,
	LKML <linux-kernel@vger.kernel.org>
References: <20070522124458.GA25591@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522124458.GA25591@havoc.gtf.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jeff,

thank you for this effort.

On Tue, May 22, 2007 at 08:44:58AM -0400, Jeff Garzik wrote:
> 
> The follow is the first baby step towards moving the HiSax drivers to
> the new PCI API.  The HiSax PCI initialization code is ass-backwards and
> an incredible pain, so this will take many steps.  If anybody is
> motivated to assist, help is more than welcome!
> 

So what is the reason to do this now, does this block some changes in
other places ? I did not change this code for long time because I know
that this is a nightmare, the code was grown and grown (supporting more and
more cards/chipsets) and is really nothing which should be used in future.
So I would say it maybe better, if it doesn't block anything else, to
replace HiSax completely with a new modular design. I know that here was not
so much effort in the past years, but now I got some time to push mISDN
forward and it looks not so bad to get the first parts ready for mainline
in June.

Neverless, if you still think that we should get rid of the old HiSax
code, I'll help as much as I can, I still have most of the cards available
in my lab, so I can also test all changes.

> The first step just moves some code into a separate function, with the
> general direction being the isolation of card-generic code away from all
> the heavily #ifdef'd card-specific code.
> 
> This patch should not change any behavior at all.  It only includes very
> trivial code modifications, like s/kmalloc/kzalloc/, use of gfp_mask,
> and the allocation of cs->rcvbuf was moved up to be with the rest of the
> memory allocations.
> 
> Further changes will be checked into this git branch:
> 
> The 'isdn-pci' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git
> 

...
-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
