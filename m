Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbXH0MHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbXH0MHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbXH0MHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:07:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47627 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751042AbXH0MHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:07:46 -0400
Date: Mon, 27 Aug 2007 10:28:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Yan Burman <burman.yan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23-rc2]  hwmon: HP Mobile Data Protection System 3D ACPI driver (resend)
Message-ID: <20070827082845.GI2060@elf.ucw.cz>
References: <1186831562.6452.10.camel@localhost> <20070825102512.GA5850@ucw.cz> <46D01420.3070400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D01420.3070400@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-08-25 13:36:00, Yan Burman wrote:
> Pavel Machek wrote:
> >On Sat 2007-08-11 14:26:02, Yan Burman wrote:
> >  
> >>HP Mobile Data Protection System 3D ACPI driver. Similar to hdaps in 
> >>functionality.
> >>This driver provides 4 kinds of functionality:
> >>1) Creates a misc device /dev/accel that acts similar to /dev/rtc and 
> >>unblocks
> >>the process reading from it when the device detects free-fall interrupt
> >>2) Functions as an input class device to provide similar functionality to
> >>hdaps, in order to be able to use the laptop as a joystick
> >>3) Provides an interface similar to hdaps, so that hdapsd could work with 
> >>it
> >>4) Makes it possible to power the device off.
> >>    
> >
> >I assume this means 'power the sensor down'? What is interface for
> >that?
> >
> >Aha, /sys. Could we simply power off the device when its input device
> >is not opened?
> >
> >  
> No, we can't since the sys interface provides the position info and some 
> applications (hdaps apps for example) use this interface.

One more reason not to use /sys to access the position data.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
