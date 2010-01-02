Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821Ab0ABT2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab0ABT2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 14:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542Ab0ABT2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 14:28:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39174 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab0ABT2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 14:28:22 -0500
Date: Sat, 2 Jan 2010 14:56:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       linux-input@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 32-rc1 aka 32-rc2: warning at manage.c:361 (set_irq_wake),
	matrix-keypad related?
Message-ID: <20100102135608.GA5872@ucw.cz>
References: <20090930200746.GA1384@ucw.cz> <20091006050649.GH27881@core.coreip.homeip.net> <20091006075816.GA1362@ucw.cz> <20091007043603.GC10204@core.coreip.homeip.net> <f17812d70910070742y5e27f9c3u38e3299b94f33613@mail.gmail.com> <20091007163327.GA12053@core.coreip.homeip.net> <20091007211225.GB17805@elf.ucw.cz> <20091203031709.GE9121@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203031709.GE9121@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > We ignore the failure right now in the mainline but that causes stack
> > > traces on resume as we trying to disable not enabled wakeup GPIOs. That
> > > was original Pavel's complaint.
> > 
> > Yep...
> > 
> > I'd say that BUG() simply should not trigger if wakeup can not be
> > enabled/disabled for particular source...?
> 
> Pavel,
> 
> Could you please try the patch below and let me know if it fixes the
> problem for you?

(sorry for long delay).

With 33-rc1+your patch, warnings are no longer there. 

I still have one on irq191, but that's gpio button driver.

But please, hold the patch for few more days. I may have cleaner/nicer
solution. It seems that zaurus is doing something very stupid in low layers.

Thanks,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
