Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYKWR03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYKWR03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 12:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbYKWR0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 12:26:19 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57036 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750885AbYKWR0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 12:26:18 -0500
Date: Sun, 23 Nov 2008 18:24:26 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: processors core stuck in full throttle after waking up from
	s2ram
Message-ID: <20081123172426.GA7447@ucw.cz>
References: <1227168699.4276.24.camel@LiNuX> <200811222151.49273.rjw@sisk.pl> <1227389306.3171.14.camel@LiNuX>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227389306.3171.14.camel@LiNuX>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > > the processor is full throttle on one of the cores.
> > 
> > Surely not.  The first core shows 2.16 GHz.
> > 
> > Anyway, it certainly is not related to the s2ram program in any way.
> 
> 
> Normally I would see cpu MHz: 1000 under both entries,
> this time upon wakeup theres 1000 and 2167.00. the 2167.00 doesn't move
> down to 1000 i.g. example of system normally:
>  cat /proc/cpuinfo <below>


> will move between 2167.00 to 1000 simultaneously under load with both
> cores, but then back down to 1000, for both when settled down.
> in this situation as I reported, the 2167.00 just
> stays at that number for one of the cores(if thats what I'm seeing) when
> waking up from suspend for some reason or another. 

Can you check with top that no process is running/eating time?

If you change cpufreq governor to powersave, will it react?

Can you check with powertop if the cpu is idle (C2/C3)or if it is
running something?

Actually, booting with nosmp might be useful. Is it always same core?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
