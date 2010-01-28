Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529Ab0A1SE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0A1SE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 13:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459Ab0A1SEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 13:04:25 -0500
Received: from kroah.org ([198.145.64.141]:44997 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab0A1SEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 13:04:13 -0500
Date: Thu, 28 Jan 2010 10:02:36 -0800
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register:  warn if probe is in
 .init.text
Message-ID: <20100128180235.GE19871@kroah.com>
References: <20090619141128.GA11506@suse.de>
 <20090619144354.GA20985@pengutronix.de>
 <20090629075535.GA20155@pengutronix.de>
 <20090711033459.GC1344@suse.de>
 <20090711100014.GA9540@pengutronix.de>
 <20090711170548.GC5205@suse.de>
 <20090907141941.GA19380@pengutronix.de>
 <20100122170641.GD13718@pengutronix.de>
 <20100122173846.GA11057@suse.de>
 <20100126085928.GD20792@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100126085928.GD20792@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 09:59:28AM +0100, Uwe Kleine-König wrote:
> Hello Greg,
> 
> On Fri, Jan 22, 2010 at 09:38:46AM -0800, Greg KH wrote:
> > On Fri, Jan 22, 2010 at 06:06:41PM +0100, Uwe Kleine-König wrote:
> > > Hello,
> > > 
> > > On Mon, Sep 07, 2009 at 04:19:41PM +0200, Uwe Kleine-König wrote:
> > > > Hi Greg,
> > > > 
> > > > On Sat, Jul 11, 2009 at 10:05:48AM -0700, Greg KH wrote:
> > > > > On Sat, Jul 11, 2009 at 12:00:14PM +0200, Uwe Kleine-König wrote:
> > > > > > Hi Greg,
> > > > > > 
> > > > > > > > Are you conviced and took the patch or did you give up to convince me?
> > > > > > > 
> > > > > > > Heh, no, sorry, it got burried in my queue.
> > > > > > > 
> > > > > > > > I still think the patch is correct and I'd like to have it applied.
> > > > > > > 
> > > > > > > Ok, let's test it out in the linux-next tree for a while to make sure it
> > > > > > > works properly.  Care to send me an updated version?
> > > > > > I updated to latest Linus' master.  It applies to linux-next from
> > > > > > Fri Jul 10 14:44:30 2009 +1000 as is.
> > > > > 
> > > > > Thanks, I'll apply it later today to my trees.
> > > > ping?!
> > > > 
> > > > > > Back some time I sent a series that fixes many of these bugs.  I will
> > > > > > update it later today and resend.
> > > > > 
> > > > > Thanks, that would be good to have, to keep the noise down for devices
> > > > > we already know about.
> > > ping?  I assume you don't have the original mails anymore, so should I
> > > resend?
> > 
> > Yes, sorry.
> I would really appreciate if you'd take the patches as it is quite some
> work to update and verify the patches are still needed as changing
> platform_driver_register to platform_driver_probe doesn't conflict with
> this series.
> 
> So can you please look into that before they are swapped out of your
> inbox the third(?) time?

I think the video ones can be all in one patch, that makes it easier for
me to track and apply.  Same goes for any others you can merge together.

thanks,

greg k-h
