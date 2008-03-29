Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbYC2VVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbYC2VVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 17:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbYC2VVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 17:21:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59980 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbYC2VVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 17:21:23 -0400
Date: Sat, 29 Mar 2008 22:22:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Michael Meyer <mike65134@yahoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 >
	/sys/devices/system/cpu/cpu1/online"
Message-ID: <20080329212203.GB2153@elf.ucw.cz>
References: <20080328135946.GB4404@ucw.cz> <954006.94043.qm@web25815.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <954006.94043.qm@web25815.mail.ukl.yahoo.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > what is the difference between booting a dual core
> > > machine with "maxcpus=1" or by deactivating the second
> > > core at run time with "echo 0 >
> > > /sys/devices/system/cpu/cpu1/online"?
> > 
> > maxcpus=1 : core stays powered off
> > 0 > online : core enters halt.
> > 
> > > I observed a funny behaviour of apache ant: although
> > > it uses javac which is single threaded, a compile run
> > > with "maxcpus=1" is actually faster than a compile run
> > > with both cores activated. But with the second core
> > > deactivated using "echo 0 >
> > > /sys/devices/system/cpu/cpu1/online" it is even slower
> > > than with both cores.
> > 
> > Thermal fun? Check cooling.
> 
> I have an extremely well cooled case and a Thermaltake Typhoon sitting
> on the E6600 (Intel TDP 65 Watt). At a room temperature of 20°C both
> cores idle at 21°C and after one hour of two instances of prime95
> running they are both at 28-33°C. As the E6600 is specified until 60°C
> (I believe), this should prevent any thermal throttling?

Ok, and your chip is too old to have "Enhanced Dynamic Acceleration
Technology" (Intel, can't you use some reasonable names?!)... both
would explain effects you see, and it is neither...

You could try implementing deep sleep (C4) state for cpu hotplug....
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
