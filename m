Return-Path: <linux-kernel-owner+w=401wt.eu-S934750AbXEVR2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934750AbXEVR2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758000AbXEVR2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:28:30 -0400
Received: from mail.suse.de ([195.135.220.2]:37194 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757726AbXEVR23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:28:29 -0400
Date: Tue, 22 May 2007 19:28:27 +0200
From: Karsten Keil <kkeil@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, kai.germaschewski@gmx.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ISDN: move card state init to separate function
Message-ID: <20070522172827.GA8821@pingi.kke.suse.de>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	Andrew Morton <akpm@linux-foundation.org>, kai.germaschewski@gmx.de,
	LKML <linux-kernel@vger.kernel.org>
References: <20070522124458.GA25591@havoc.gtf.org> <20070522151814.GA4280@pingi.kke.suse.de> <46531E58.6030506@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46531E58.6030506@garzik.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 12:46:16PM -0400, Jeff Garzik wrote:
> Karsten Keil wrote:
> >So what is the reason to do this now, does this block some changes in
> >other places ? I did not change this code for long time because I know
> >that this is a nightmare, the code was grown and grown (supporting more and
> >more cards/chipsets) and is really nothing which should be used in future.
> >So I would say it maybe better, if it doesn't block anything else, to
> >replace HiSax completely with a new modular design. I know that here was 
> >not
> >so much effort in the past years, but now I got some time to push mISDN
> >forward and it looks not so bad to get the first parts ready for mainline
> >in June.
> 
> ISDN is the biggest chunk of code blocking removal of some deprecated 
> PCI interfaces.
> 

OK then this should be done of course, since I fear that we will not
move all supported cards (since they are not longer sold) to the new driver.

> If you want to replace the code completely with a newfangled modular 
> design, I will gladly step out of the way and let that happen :)  I only 
> know what I see right now, which is code that has sat around for a while 
> not getting updated to the new PCI API.
> 
> Since I do not have any ISDN hardware, my plan was to do equivalent 
> transformations of the code.  Each patch just shuffles code, but 
> maintains a working state at all time, making it trivial to prove 
> (mathematically, or with testing, or with git-bisect) that the code 
> continues to work.

So maybe it could be a good start point to do the transition for one
card first, maybe nj_s.c is OK to start.


> 
> So, just tell me which you would prefer.  If you are going to fix all 
> this stuff, there is plenty of other stuff on my list to work on. 
> Otherwise I will create equivalent-transform patches that take the 
> existing code and modify it just enough to be correct for the new PCI API.
> 

If you do that for one card, I will test it and change the rest.

Thanks for your help.

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
