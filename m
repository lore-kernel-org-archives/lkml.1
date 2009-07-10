Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZGKUpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZGKUpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 16:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbZGKUpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 16:45:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50534 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbZGKUpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 16:45:46 -0400
Date: Fri, 10 Jul 2009 18:13:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc0-git: lsusb stopped working?
Message-ID: <20090710161336.GA1350@ucw.cz>
References: <20090623135529.GA2668@elf.ucw.cz> <20090623150114.GA30413@kroah.com> <20090711091039.GE16955@elf.ucw.cz> <20090711174305.GA5542@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090711174305.GA5542@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > > > 
> > > > On thinkpad x60. Otherwise usb seems to work, including btusb dongle.
> > > > 
> > > > /proc/bus/usb does not seem to exists.
> > > 
> > > Newer (as in the past 2 years) versions of lsusb should not need
> > > /proc/bus/usb/
> > > 
> > > What version of usbutils are you using?
> > 
> > root@amd:/home/pavel# lsusb --version
> > lsusb (usbutils) 0.73
> > root@amd:/home/pavel# 
> > 
> > I may have done something stupid with not runing udev and linking
> > /proc/bus/usb to /dev, instead...
> 
> the opensuse FACTORY tree now has a more modern version of usbutils in
> it, which works just fine without usbfs mounted.

Well, this is heavily hacked debian :-)

> > But it is not only usbutils that is broken, I first noticed breakage
> > on android fastboot.
> 
> Android needs it?  That's crazy, given that they don't have any usb host
> controllers in their devices.  Very wierd...

fastboot  runs on PC and uploads kernels to Android device(s).

> Anyway, this change is going to be reverted, it is already queued up to
> go to Linus early next week.  Just need to test some other pending
> patches as well.

Thanks!
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
