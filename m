Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbYGKVjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbYGKVjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbYGKVjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 17:39:36 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:51028 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbYGKVje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 17:39:34 -0400
Date: Fri, 11 Jul 2008 23:41:05 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dmitry <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [patch 4/4] MFD: Change mfd platform device usage to wrapper
	platform_device
Message-ID: <20080711214103.GB2561@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20080709104916.200210922@fluff.org> <20080709104933.101610936@fluff.org> <bc64b4640807090415w781507fetfe332271ad158112@mail.gmail.com> <1215603916.3295.57.camel@wirenth> <bc64b4640807090452vc923216gfb14bb2c5974a61@mail.gmail.com> <20080709210314.GF26734@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709210314.GF26734@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 10:03:14PM +0100, Russell King - ARM Linux wrote:
> On Wed, Jul 09, 2008 at 03:52:08PM +0400, Dmitry wrote:
> > 2008/7/9 ian <spyro@f2s.com>:
> > > On Wed, 2008-07-09 at 15:15 +0400, Dmitry wrote:
> > >> NAK.
> > >> 0) It was discussed yesterday on the list and the decision was to go
> > >> in a different way.
> > >
> > > It was?
> > >
> > > I prefer the wrapped way personally...
> > 
> > In any case IMO it's better to call platform_device_register() rather than
> >  device_initialise()/platform_device_add().
> > 
> > Samuel? Russell?
> 
> WTF???  That's just completely wrong - assuming the internals of how the
> platform device alloc API works...
> 
> What it's clear from my *brief* read of this thread is that the MFD
> support doesn't seem to be ready for mainline yet - there's clearly issues
> here that need further work.
I think the main issue at the moment is that it's not passing generic
platform data if we ever want to use an existing driver as a cell driver.
I'd say this is more of a lack of feature rather than broken code, so please
dont drop the mfd-core patch.

Cheers,
Samuel.


> Given that, and where we are (there's maybe two of *my* days left until
> the merge window opens) I'm *very* tempted to drop the MFD support out
> of my tree for this merge window - which basically means removing
> 5127/1, 5128/1 and 5129/1.
> 
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
