Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbZJLTVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbZJLTVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933128AbZJLTVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:21:36 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:39322 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933085AbZJLTVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:21:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dNJKdVxTjAalZfXD2tkm3txnn24VRGKGjvkIsuk+mCqMoe9uHq90OzS2jP5jwULy3A
         kHK+DOLS8x5Th4HM1Kls9dx/6/dZJbFluXZuEk8VISmLgWNyvBeudTG6fY14of8/LgVO
         n/83tVZbLzhIqeDYm4BQKCiFel8mBaI2+YM48=
Date: Mon, 12 Oct 2009 12:20:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work
	anymore
Message-ID: <20091012192046.GD8345@core.coreip.homeip.net>
References: <4AD120F2.3020606@tremplin-utc.net> <20091011030029.GA6526@suse.de> <200910112135.29384.dmitry.torokhov@gmail.com> <4AD31709.4000103@tremplin-utc.net> <20091012154846.GB7996@core.coreip.homeip.net> <20091012173551.GC10557@suse.de> <20091012183313.GC8345@core.coreip.homeip.net> <20091012185417.GA30342@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012185417.GA30342@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 11:54:17AM -0700, Greg KH wrote:
> On Mon, Oct 12, 2009 at 11:33:13AM -0700, Dmitry Torokhov wrote:
> > On Mon, Oct 12, 2009 at 10:35:51AM -0700, Greg KH wrote:
> > > On Mon, Oct 12, 2009 at 08:48:46AM -0700, Dmitry Torokhov wrote:
> > > > > So at least, unbind should fail as well as bind.
> > > > >
> > > > 
> > > > That would be Greg's domain s it is driver core decision whether to
> > > > allow unbinding platform devices registered with
> > > > platform_driver_probe().
> > > 
> > > No, I do not see why that should not be allowed.
> > > 
> > 
> > Because once you did unbind the device you are stuck (unless the driver
> > is compiled as a module, but then you could just unload the module
> > instead of unbinding). Disallowing unbind would allow discarding not
> > only __devinit but __devexit sections when driver is built in which
> > would make ebedded people happy[^Hier].
> 
> Yeah, good point.
> 
> Does anyone do bind/unbind with platform devices today?
> 

Greg, meet Eric ;)

Although I'd really want to fix the resume issue so it works out of the
box without needing to bind/unbind or reload i8042.

-- 
Dmitry
