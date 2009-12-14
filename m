Return-Path: <linux-kernel-owner+w=401wt.eu-S933061AbZLNVXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbZLNVXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933037AbZLNVXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:23:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43762 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048AbZLNVXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:23:05 -0500
Date: Mon, 14 Dec 2009 22:22:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, cbou@mail.ru,
       dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org, Brian Swetland <swetland@google.com>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: Re: [POWER] battery calibration parameters from sysfs
Message-ID: <20091214212257.GA9213@elf.ucw.cz>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
 <20091204104930.GA28625@sirena.org.uk>
 <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>
 <20091207114825.GA26965@rakim.wolfsonmicro.main>
 <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>
 <20091207165628.GA24981@rakim.wolfsonmicro.main>
 <20091213132413.GB1437@ucw.cz>
 <20091214121247.GB22388@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214121247.GB22388@rakim.wolfsonmicro.main>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I'm not sure how familiar you are with the issues surrounding trying to
> > > do a voltage to charge mapping for a battery but it's much more complex
> > > than a simple table if you want to get it accurate.  There's a lot
> > > of
> 
> > Well... current zaurus kernels use _huge_ table that maps voltage to
> > battery %... and that table is linear function :-(.
> 
> > Do you have some papers on that?
> 
> Something like "Measure Battery Capacity Precisely in Medical Design"
> by Bernd Krafthoefer in Power Electronics Technology Jan 2005 might be
> useful here.

Well, that would really require extensive hardware modifications: it
needs _way_ more accurate ADCs on battery for a start, and a way to
generate huge load.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
