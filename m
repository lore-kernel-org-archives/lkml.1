Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbXFJKM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbXFJKM2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 06:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXFJKMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 06:12:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39011 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752467AbXFJKMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 06:12:20 -0400
Date: Sun, 10 Jun 2007 12:11:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: Richard Purdie <rpurdie@openedhand.com>,
       Richard Hughes <hughsient@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "kay.sievers" <kay.sievers@vrfy.org>,
       "Bryn M. Reeves" <breeves@redhat.com>, John Lenz <lenz@cs.wisc.edu>
Subject: Re: [patch] Move led attributes out of device name and into sysfs attributes, was Re: LED devices
Message-ID: <20070610101155.GA25070@elf.ucw.cz>
References: <1180710270.3782.5.camel@localhost.localdomain> <1180712592.6390.139.camel@localhost.localdomain> <1180713579.12843.8.camel@localhost.localdomain> <1180715004.6390.169.camel@localhost.localdomain> <20070608185710.GB14372@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608185710.GB14372@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > My other concerns with this patch are that it exports incorrect
> > information on spitz (which I had warned about and I will get bug
> > reports about) and that "description" is not really a suitable name for
> > a sysfs attribute, "function" might give a better idea of what it
> > represents to developers.
> > 
> > I still question whether either colour or function properties are
> > actually particularly useful to userspace other than for naming purposes
> > which is why they were part of the device name.
> > 
> > Anyhow, I'm trying not to say too much more as it will just go in
> > circles. I'll await a reply from Greg.
> 
> Hm, I thought I made my opinion pretty clear in the beginning.
> 
> Why not just do a simple:
> 	led01
> 	led02
> 	led03
> 	...
> 
> and so on?
> 
> And use the 'name' field to put the name of your device (disk,
> bluetooth, etc.)  This is the way all other busses and devices work, and
> I don't think that LEDs are anything more "special" than anything else
> in the kernel, right?

Can we keep the original naming? spitz:disk is as unique as led02, and
it is _way_ easier to use.

Come on, I want to use the led subsystem from the scripts... 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
