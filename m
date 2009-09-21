Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbZIUHyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbZIUHyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZIUHym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:54:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50334 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbZIUHym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:54:42 -0400
Date: Mon, 21 Sep 2009 09:54:45 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register:  warn if probe is in
	.init.text
Message-ID: <20090921075445.GA15833@pengutronix.de>
References: <20090616182310.GC13048@pengutronix.de> <1245418939-20758-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090619141128.GA11506@suse.de> <20090619144354.GA20985@pengutronix.de> <20090629075535.GA20155@pengutronix.de> <20090711033459.GC1344@suse.de> <20090711100014.GA9540@pengutronix.de> <20090711170548.GC5205@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090711170548.GC5205@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Sat, Jul 11, 2009 at 10:05:48AM -0700, Greg KH wrote:
> On Sat, Jul 11, 2009 at 12:00:14PM +0200, Uwe Kleine-König wrote:
> > Hi Greg,
> > 
> > > > Are you conviced and took the patch or did you give up to convince me?
> > > 
> > > Heh, no, sorry, it got burried in my queue.
I assume this is normal for you? :-)

> > > > I still think the patch is correct and I'd like to have it applied.
> > > 
> > > Ok, let's test it out in the linux-next tree for a while to make sure it
> > > works properly.  Care to send me an updated version?
> > I updated to latest Linus' master.  It applies to linux-next from
> > Fri Jul 10 14:44:30 2009 +1000 as is.
> 
> Thanks, I'll apply it later today to my trees.
>
> > Back some time I sent a series that fixes many of these bugs.  I will
> > update it later today and resend.
> 
> Thanks, that would be good to have, to keep the noise down for devices
> we already know about.
As of today I don't see my patches in linux-next.  Are you still
interested?  Can I ease taking the patches for you somehow?  E.g. by
sending a tar containing a quilt series?

Do you think it would be more sensible to convert the drivers to use
platform_driver_probe as this is what some commentors request.
The downside is that these can result in regressions (i.e. no driver
binding if the device is created after the driver is registered).
So this would be merge-window material.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
