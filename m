Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYAAQeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYAAQeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbYAAQdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:33:52 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:32913 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787AbYAAQdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:33:52 -0500
Date: Tue, 1 Jan 2008 18:33:38 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20080101163337.GX2360@does.not.exist>
References: <20080101134809.GK2360@does.not.exist> <20080101142344.769f16c7@the-village.bc.nu> <20080101151751.GW2360@does.not.exist> <20080101160708.5bb5cc2a@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080101160708.5bb5cc2a@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 04:07:08PM +0000, Alan Cox wrote:
> On Tue, 1 Jan 2008 17:17:51 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Tue, Jan 01, 2008 at 02:23:44PM +0000, Alan Cox wrote:
> > > On Tue, 1 Jan 2008 15:48:09 +0200
> > > Adrian Bunk <bunk@kernel.org> wrote:
> > > 
> > > > This patch removes the EXPERIMENTAL option and all dependencies on
> > > > EXPERIMENTAL since they are pointless.
> > > 
> > > NAK
> > > 
> > > Experimental is an important guide to driver and code quality. 
> > >...
> > 
> > History has shown that EXPERIMENTAL tags in many areas of the kernel 
> > have not been maintained in a way that they would be usable as a guide.
> 
> Repeatedly posting crud does not make it right. As far as I can see the
> tags are pretty honest for the most part - some have been experimental
> for ten years but the 3c507 driver *has* always been a beta grade driver.

So smbfs is still considered rock solid while no serious distribution 
would be crazy enough to ship the EXPERIMENTAL NFSv4 support to their 
customers?

I'm not claiming that all EXPERIMENTAL tags were wrong [1], but many 
were wrong.

Plus the fact that CONFIG_EXPERIMENTAL controlled so many different 
things with one switch that CONFIG_EXPERIMENTAL=n .config's are really 
rare.

> > And as soon as you need _one_ driver or feature depending on 
> >> That's not about consensus,
> 
> It should be.

You removed the context.

The fact that Andrew has not applied a three times sent patch does not 
necessarily imply there was any problem with a patch - "no answer" on 
linux-kernel always translates to "continue patchbombing".

> Alan

cu
Adrian

[1] after all, even with a random distribution many of them
    were right  ;-)

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

