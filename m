Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbZINVnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbZINVnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbZINVm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:42:59 -0400
Received: from kroah.org ([198.145.64.141]:51340 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbZINVm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:42:59 -0400
Date: Mon, 14 Sep 2009 14:24:13 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, arve@android.com,
       swetland@google.com, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Re: newer version of HTC Dream support
Message-ID: <20090914212413.GA10043@kroah.com>
References: <20090824092204.GB25591@elf.ucw.cz>
 <20090901131832.GA1835@ucw.cz>
 <20090904090303.024e981a.randy.dunlap@oracle.com>
 <20090911071155.GA1386@ucw.cz>
 <20090911075847.2fb7210a.randy.dunlap@oracle.com>
 <20090911161335.GA8137@elf.ucw.cz>
 <20090911092157.ba202b0a.randy.dunlap@oracle.com>
 <20090911212751.GA25544@elf.ucw.cz>
 <20090911153422.7d523a73.randy.dunlap@oracle.com>
 <20090913083719.GA6645@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090913083719.GA6645@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 13, 2009 at 10:37:19AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > Fix compilation of gpio_* input drivers on -next kernel. Adds needed
> > > headers and removes unprotected wakelock/earlysuspend dependencies.
> > >     
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > Still doesn't build for me, but if it builds for you, that's great.
> > (could be a tool chain problem on my side)
> 
> No, it does not look like toolchain problem :-(. I had parts disabled
> in Kconfig. This should make it _compile_ (but not link); somehow
> MSM_ADSP is neccessary for camera to link and I can't see how to
> enable it.
> 
> Thanks for the patience.

Ugh, what patch should be applied in what order?  Care to resend them
with the proper "x/y" and a valid Subject: line?

thanks,

greg k-h
