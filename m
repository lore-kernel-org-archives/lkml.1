Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYKNHw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYKNHw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 02:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYKNHwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 02:52:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45520 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbYKNHwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 02:52:49 -0500
Date: Fri, 14 Nov 2008 08:52:48 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andres Salomon <dilinger@queued.net>
Cc: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Katz <katzj@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org,
       dsaxena@laptop.org
Subject: Re: [PATCH] ALSA: cs5535audio: only build OLPC support if	MGEODE_LX is defined
Message-ID: <20081114075248.GB8397@atrey.karlin.mff.cuni.cz>
References: <1226547898.13077.83.camel@aglarond.local> <s5h63msru7z.wl%tiwai@suse.de> <20081113153714.GA1520@ucw.cz> <s5h3ahvhb9w.wl%tiwai@suse.de> <20081113111428.59aa36cb@ephemeral> <20081113163802.GA1734@ucw.cz> <20081113120147.2ecde3c8@ephemeral> <20081113190339.GE17851@elte.hu> <s5hzlk3kxuf.wl%tiwai@suse.de> <20081113213852.16561ed2@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113213852.16561ed2@ephemeral>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI!

> > > i've zapped this patch meanwhile:
> > > 
> > >  1355c96: x86/olpc: make CONFIG_OLPC dependent on CONFIG_MGEODE_LX
> > > 
> > > because it cripples the ability to run distribution kernels on the 
> > > OLPC.
> > 
> > OK, I reverted also all relevant changes for cs5535audio driver now.
> > The patches are saved in topic/cs5535audio branch, though.
> > 
> > Let's fix OLPC-geode coupling first.
> 
> Hm, I'd really rather prefer this to be upstream.  The patch I sent adds
> no regressions, allows the driver to happily coexist with existing
> stuff, and *does* add support if you configure OLPC with MGEODE_LX
> (generic kernels don't get the additional benefits, but those configured
> specifically for OLPC do).

Yes, but the patch is also not a good way of going forward, so it
should not be in mainline.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
