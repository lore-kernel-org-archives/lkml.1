Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853Ab0ADWs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab0ADWs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374Ab0ADWs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:48:26 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52207 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab0ADWsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:48:25 -0500
Date: Mon, 4 Jan 2010 23:48:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       krzysztof.h1@wp.pl, Andrew Morton <akpm@linux-foundation.org>,
       linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] Logitech G13 driver (fixed cc list --- ignore others)
Message-ID: <20100104224817.GA21695@elf.ucw.cz>
References: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
 <20091216103423.GE1377@ucw.cz>
 <alpine.LNX.2.00.0912161504360.3755@pobox.suse.cz>
 <7f9100aac5f9b06ec78efff25c7a5a71.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f9100aac5f9b06ec78efff25c7a5a71.squirrel@intranet.cs.nmsu.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Well, the device is still primarily HID device in its nature, so either
> > keeping the whole driver in drivers/hid, or separating it into two
> > drivers, one for the HID part and second for the framebuffer part should
> > be acceptable.
> 
> The framebuffer part uses the same interrupt endpoint for both HID and
> display. IIRC there were issues with two drivers using the same interrupt
> endpoint.

Ok, but I guess you should cc auxdisplay people in future.

> >> I'd prefer to go without another logo. Just make sure default penguin
> >> gets
> >> there or something.
> >
> > What logo is this, BTW? :)
> 
> It's similar to the default G13 load image, but with tux on the left and
> the GNU gnu on the right.
> 
> I tried to particularly clean up tux a bit since the default monochrome
> logo is 80x80 and the display is 160x43.
> 
> The only alternatives I could think of were to use the default logo and
> load it at 80x43 which cuts off Tux at the nipples, resample in the
> driver, or leave the logo off.

Or put something simple&stupid there like checkerboard?

Or just resample penguin -- skipping every second line should not be
particulary hard...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
