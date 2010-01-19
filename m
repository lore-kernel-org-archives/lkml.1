Return-Path: <linux-kernel-owner+w=401wt.eu-S1751668Ab0ASFP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab0ASFP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 00:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793Ab0ASFP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 00:15:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34882 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab0ASFP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 00:15:56 -0500
Date: Tue, 19 Jan 2010 06:15:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andy Walls <awalls@radix.net>,
       Eric Miao <eric.y.miao@gmail.com>, omegamoon@gmail.com,
       dbaryshkov@gmail.com, Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       linux-kernel@vger.kernel.org, Dirk@opfer-online.de,
       Stanislav Brabec <utx@penguin.cz>, lenz@cs.wisc.edu, rpurdie@rpsys.net,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Bart?omiej Zimo? <uzi18@o2.pl>, zaurus-devel@www.linuxtogo.org,
       Daniel Borkmann <danborkmann@googlemail.com>, thommycheck@gmail.com
Subject: Re: [suspend/resume] Re: userspace notification from module
Message-ID: <20100119051537.GA22153@elf.ucw.cz>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl>
 <201001162305.56972.rjw@sisk.pl>
 <20100116221929.GB8425@elf.ucw.cz>
 <201001162326.09092.rjw@sisk.pl>
 <20100117130739.GA2035@ucw.cz>
 <20100117132618.GA742@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100117132618.GA742@n2100.arm.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-01-17 13:26:18, Russell King - ARM Linux wrote:
> On Sun, Jan 17, 2010 at 02:07:39PM +0100, Pavel Machek wrote:
> > AFAICT following message would be nice.
> > 
> > 1) battery is critical, userspace please do something
> > 
> > On zaurus and similar, you could add
> > 
> > 2) oh and btw we had power failure so we suspended (or maybe -- so
> > hardware suspended itself -- rmk's examples and old apm systems); we
> > are now back and running
> > 
> > notification... but... ideally those power failures should never
> > happen anyway, so... having this notification is in no way neccessary.
> 
> There's another consideration here: the more complex the emergency
> procedure, the higher the chance of _something_ causing it to fail,
> and if it does fail, the result is data loss.

That's why I propose to only send notification after we resume from
emergency suspend :-).

> In a properly running system, this isn't something that's going to
> get a lot of testing, so there's a higher chance that there will be
> bugs, so the simpler the solution, the better.

Unfortunately, with old battery in zaurus, I tested it rather a lot. I
have new one now, but I can still use old one for testing.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
