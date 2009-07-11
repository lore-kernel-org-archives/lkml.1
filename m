Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbZGKJK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbZGKJK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 05:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZGKJKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 05:10:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44457 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZGKJKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 05:10:47 -0400
Date: Sat, 11 Jul 2009 11:10:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc0-git: lsusb stopped working?
Message-ID: <20090711091039.GE16955@elf.ucw.cz>
References: <20090623135529.GA2668@elf.ucw.cz> <20090623150114.GA30413@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623150114.GA30413@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-06-23 08:01:14, Greg KH wrote:
> On Tue, Jun 23, 2009 at 03:55:29PM +0200, Pavel Machek wrote:
> > 
> > On thinkpad x60. Otherwise usb seems to work, including btusb dongle.
> > 
> > /proc/bus/usb does not seem to exists.
> 
> Newer (as in the past 2 years) versions of lsusb should not need
> /proc/bus/usb/
> 
> What version of usbutils are you using?

root@amd:/home/pavel# lsusb --version
lsusb (usbutils) 0.73
root@amd:/home/pavel# 

I may have done something stupid with not runing udev and linking
/proc/bus/usb to /dev, instead...

But it is not only usbutils that is broken, I first noticed breakage
on android fastboot.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
