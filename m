Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbZGLA0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbZGLA0u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 20:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZGLA0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 20:26:41 -0400
Received: from kroah.org ([198.145.64.141]:40405 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbZGLA0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 20:26:40 -0400
Date: Sat, 11 Jul 2009 17:25:36 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc0-git: lsusb stopped working?
Message-ID: <20090712002536.GC9308@kroah.com>
References: <20090623135529.GA2668@elf.ucw.cz>
 <20090623150114.GA30413@kroah.com>
 <20090711091039.GE16955@elf.ucw.cz>
 <20090711174305.GA5542@kroah.com>
 <20090710161336.GA1350@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710161336.GA1350@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 06:13:37PM +0200, Pavel Machek wrote:
> Hi!
> > > > > 
> > > > > On thinkpad x60. Otherwise usb seems to work, including btusb dongle.
> > > > > 
> > > > > /proc/bus/usb does not seem to exists.
> > > > 
> > > > Newer (as in the past 2 years) versions of lsusb should not need
> > > > /proc/bus/usb/
> > > > 
> > > > What version of usbutils are you using?
> > > 
> > > root@amd:/home/pavel# lsusb --version
> > > lsusb (usbutils) 0.73
> > > root@amd:/home/pavel# 
> > > 
> > > I may have done something stupid with not runing udev and linking
> > > /proc/bus/usb to /dev, instead...
> > 
> > the opensuse FACTORY tree now has a more modern version of usbutils in
> > it, which works just fine without usbfs mounted.
> 
> Well, this is heavily hacked debian :-)

Take it up with the Debian maintainers then, there are newer usbutils
packages availble somewhere...

> > > But it is not only usbutils that is broken, I first noticed breakage
> > > on android fastboot.
> > 
> > Android needs it?  That's crazy, given that they don't have any usb host
> > controllers in their devices.  Very wierd...
> 
> fastboot  runs on PC and uploads kernels to Android device(s).

Oh, that program.  That sounds like a Debian configuration issue.

good luck,

greg k-h
