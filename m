Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbZHHRVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbZHHRVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 13:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZHHRV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 13:21:29 -0400
Received: from kroah.org ([198.145.64.141]:37743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbZHHRV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 13:21:29 -0400
Date: Sat, 8 Aug 2009 10:11:24 -0700
From: Greg KH <greg@kroah.com>
To: Al Boldi <a1426z@gawab.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090808171124.GA357@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <200908080017.31376.a1426z@gawab.com>
 <20090807222449.GA31416@kroah.com>
 <200908081214.39456.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908081214.39456.a1426z@gawab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 08, 2009 at 12:14:39PM +0300, Al Boldi wrote:
> Greg KH wrote:
> > On Sat, Aug 08, 2009 at 12:17:31AM +0300, Al Boldi wrote:
> > > For devtmpfs to be a realistic replacement for static /dev, it has to
> > > be comparable to static /dev in both speed and size.
> >
> > Since when is this requirement necessary?  You want something for free
> > in both speed and size?  Well, you got it in speed, but not size, it
> > will take up memory that is swapable, and a tiny ammount of non-swapable
> > kernel memory for the code.
> 
> Not so tiny when you count in the hotplug dependency.

devtmpfs does not rely on hotplug at all.

> > > WRT speed, there should be no  slowdown and it should be just as fast
> > > as a "tar -xp < dev.tar".
> >
> > Again, where is this requirement coming from?
> >
> > Have you timed devtmpfs?
> 
> Not yet, I am still waiting for the latest patch against .30.

I already pointed you at it.

> > > WRT size, it should not be dependent on hotplug, and instead offer
> > > hotplug as an option.
> >
> > Um, again, who made up such a requirement?  Are you running systems
> > today with CONFIG_HOTPLUG disabled?  If so, how well is that working for
> > you?
> 
> It's working out quite well.  I don't like hotplug, it's too slow.  I always 
> turn it and module-autoloading off, to achieve a much more responsive system.

What becomes "more responsive"?  What is too slow?

Anyway, this is quite off-topic for the original patch.  If you have
problems/issues with udev and CONFIG_HOTPLUG, let's take that to the
linux-hotplug@vger.kernel.org list.

thanks,

greg k-h
