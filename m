Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab0CJUuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 15:50:40 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35400 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757118Ab0CJUuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 15:50:39 -0500
Date: Wed, 10 Mar 2010 21:46:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
Message-ID: <20100310204626.GB1394@ucw.cz>
References: <4B8C1867.7040201@cam.ac.uk> <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com> <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain> <20100303184132.GA11471@core.coreip.homeip.net> <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain> <20100303190753.GB11471@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303190753.GB11471@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Because in general ambient light sensor may have nothing to do with the
> > > screen brightness. The fact that all current uses are tied to
> > > controlling screen brightness is coincidential. You could use it as well
> > > to turn on the lights in the kitchen if it is getting too dark...
> > 
> > But my point is, it acts pretty much like a key on a keyboard 
> > _regardless_. 
> > 
> > Sure, you migth use it to turn up the lights too. But how is that 
> > different from having a switch to do the same? Again, it doesn't sound 
> > that different from a key to me.
> 
> I guess for me the distinction is that the event was not caused by an
> action of a human being but by change in environment.

Well, I seen people covering light sensor by hand to change screen
brightness :-).

> Also, if we decide that input layer is the best place for such devices,
> it should not be a key but absolute event, ABS_LIGHT_LEVEL or something.

Yep.

> > I agree that that's not true in many other situations. A cable insertion 
> > event is about the networking, not about some independent input. The kind 
> > of application that cares about network cable presense is _not_ the kind 
> > of app that would care about keyboard input. Same goes for voltage.
> 
> What about magnetometers, accelerometers and so forth? I still do not
> think they are pure input layer devices although it is possible to build
> a bridge modules so they could plug into input framework if desired.

At least on android, accelerometers are primarily human interaction
device -- for screen rotation. And biggest use of
magnetometer+accelerometer on android is actually looking around in
streetview...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
