Return-Path: <linux-kernel-owner+w=401wt.eu-S1422631AbXBPOFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422631AbXBPOFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422632AbXBPOFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:05:19 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45768 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161023AbXBPOFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:05:17 -0500
Date: Fri, 16 Feb 2007 15:04:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: extend EV_LED
Message-ID: <20070216140451.GA8904@elf.ucw.cz>
References: <20070215174009.GA6535@ucw.cz> <freemail.20070115234756.58787@fm13.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <freemail.20070115234756.58787@fm13.freemail.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > >I do not know the LED subsystem in detail, but I do not 
> > > >know
> > > >any possibility to access the i8042 from different 
> > > >subsystem
> > > >than the input subsystem.
> > > >
> > > >What do you think and recommend?
> > > 
> > > I think you need to use leds framework for what you are 
> > > trying to do.
> > 
> > I'm actually not sure if led framework can do that. It was
> designed
> > for leds on gpios, and handles blinking itself.
> > 
> > But he could export two leds :-).
> 
> Hi,
> 
> what do you mean about two leds? The first one would be
> off/0.5Hz and the other off/1Hz?


Somethinglike that.

> I read in linux/Documentation/led-class.txt the following:
> 
> | Some leds can be programmed to flash in hardware. As this
> isn't a generic
> | LED device property, this should be exported as a device
> specific sysfs
> | attribute rather than part of the class if this
> functionality is required.
> 
> Does it mean that neither the input subsystem nor the led
> subsystem is designed for hardware acelerated blinking leds?

Seems so.



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
