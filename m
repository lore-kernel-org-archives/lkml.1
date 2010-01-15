Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab0AOUDW (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 15:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709Ab0AOUDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 15:03:20 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58781 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab0AOUDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 15:03:19 -0500
Date: Fri, 15 Jan 2010 21:03:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bart?omiej Zimo? <uzi18@o2.pl>, Andy Walls <awalls@radix.net>,
        Daniel Borkmann <danborkmann@googlemail.com>,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        Dirk@Opfer-Online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: Re: [suspend/resume] Re: userspace notification from module
Message-ID: <20100115200310.GG1345@ucw.cz>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001022201.04281.rjw@sisk.pl> <20100109103212.GA1429@ucw.cz> <201001091440.46434.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001091440.46434.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-01-09 14:40:46, Rafael J. Wysocki wrote:
> On Saturday 09 January 2010, Pavel Machek wrote:

> > > Perhaps I don't understand correctly what you're trying to achieve, but at the
> > > moment suspend is always started from user space, this way or another, and on
> > 
> > At least zaurus (arm) suspends from kernel on battery critical.
> 
> I wasn't aware of this.
> 
> That may be a good reason for adding kernel-based suspend notification,
> although I'd prefer ARM to notify the user space about the critical battery
> status allowing it to decide what to do.

Hard to do, without breaking compatibility that goes down to 2.4.X.

> IMhO automatic suspend without something like the Android's wakelocks hurts
> more than it helps.

It really makes sense on zaurus. Those machines are simple, no
smartbattery and no embedded controller subsystems. Battery will not
protect itself, and its kernel job. (Should work on init=/bin/bash).

As power-off consumption is same as suspend power consumption (I
beleive zaurus simply does not have true power off), suspend on
critical makes some sense. (Note that it is set lower than on pcs, and
that we declare battery critical sooner than that.)
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
