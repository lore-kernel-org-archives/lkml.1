Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555Ab0AQNHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab0AQNHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 08:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930Ab0AQNHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 08:07:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60863 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab0AQNHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 08:07:50 -0500
Date: Sun, 17 Jan 2010 14:07:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stanislav Brabec <utx@penguin.cz>, Eric Miao <eric.y.miao@gmail.com>,
       Bart?omiej Zimo? <uzi18@o2.pl>, Andy Walls <awalls@radix.net>,
       Daniel Borkmann <danborkmann@googlemail.com>,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com,
       zaurus-devel@www.linuxtogo.org
Subject: Re: [suspend/resume] Re: userspace notification from module
Message-ID: <20100117130739.GA2035@ucw.cz>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001162305.56972.rjw@sisk.pl> <20100116221929.GB8425@elf.ucw.cz> <201001162326.09092.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001162326.09092.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > That was not the point I was trying to discuss. Yes, we need
> > kernel<->user notification of battery critical. 
> > 
> > But on zaurus, correct action is to suspend (not hibernate and not
> > poweroff) when battery is no longer able to supply enough power to
> > keep system alive.
> 
> Why not to poweroff (just asking, I don't know that hardware)?

Those machines basically have no poweroff.

> I guess we should at least do our best to keep filesystems in a consistent
> state and suspend doesn't really guarantee this if the system remains on
> battery power afterwards.

I'm not sure if I ever had battery run so low that it could not keep
RAM running. Collie has even separate (small) battery just for
RAM. (And it also has all the filesystems in ramdisk -- you really do
not want to power it off, even if it could.)

AFAICT following message would be nice.

1) battery is critical, userspace please do something

On zaurus and similar, you could add

2) oh and btw we had power failure so we suspended (or maybe -- so
hardware suspended itself -- rmk's examples and old apm systems); we
are now back and running

notification... but... ideally those power failures should never
happen anyway, so... having this notification is in no way neccessary.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
