Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012Ab0APWZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab0APWZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 17:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970Ab0APWZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 17:25:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38090 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab0APWZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 17:25:36 -0500
Date: Sat, 16 Jan 2010 23:25:29 +0100
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
Message-ID: <20100116222529.GA8618@elf.ucw.cz>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl>
 <1263661258.6596.10.camel@utx.utx.cz>
 <20100116181253.GC1603@ucw.cz>
 <201001162305.56972.rjw@sisk.pl>
 <20100116221929.GB8425@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100116221929.GB8425@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > IMHO it should just plain shutdown in that case.  Suspending doesn't really
> > solve the problem, because the battery is going to drain still.  Unless you
> > mean suspend=hibernate, but I guess you don't.

BTW I was talking spitz before, but there's collie, too. It was
shipped in configuration where all user data was in RAM and RAMdisk --
no writable flash. On such machine, shutdown is never option. (And
yes, such design was very common in windowsCE days).

Spitz got disk, but inherited that powermanagement design; and it
works very well.

And now, if you want collie for a year (or two), you can have
mine... it still works and battery still lasted for 5 hours 2 years
ago -- not bad for 10 year old battery. You'll note that it is very
different design from PC.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
