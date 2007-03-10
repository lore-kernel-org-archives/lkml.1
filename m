Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbXCJWFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbXCJWFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbXCJWFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:05:17 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51097 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751200AbXCJWFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:05:13 -0500
Date: Sat, 10 Mar 2007 23:04:40 +0100
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Stezenbach <js@linuxtv.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, linux-pm@lists.osdl.org,
       lenb@kernel.org, linux-acpi@vger.kernel.org, luming.yu@intel.com,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Konstantin Karasyov <konstantin.a.karasyov@intel.com>,
       Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net,
       Thomas Meyer <thomas.mey@web.de>, Meelis Roos <mroos@linux.ee>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Janosch Machowinski <jmachowinski@gmx.de>, vladimir.p.lebedev@intel.com,
       Ash Milsted <thatistosayiseenem@gawab.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz,
       "Eric W. Biederman" <ebiederm@xmission.com>, seife@suse.de
Subject: s2ram (was Re: [2/6] 2.6.21-rc2: known regressions)
Message-ID: <20070310220440.GE2758@elf.ucw.cz>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il> <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org> <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu> <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org> <20070309174821.GA31754@linuxtv.org> <20070309233508.GB2197@elf.ucw.cz> <20070310090121.GB15647@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310090121.GB15647@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Even if one doesn't use the fb console at all, radeonfb apparently 
> > > is still required on some ThinkPad models to work around BIOS bugs:
> > > 
> > > http://www.thinkwiki.org/wiki/Problem_with_high_power_drain_in_ACPI_sleep#Radeon_GPU_not_powered_off
> > 
> > 
> > s2ram should be able to work around this, it has parts from 
> > radeontool. (suspend.sf.net).
> 
> i'm wondering, do you have any idea how Windows handles the 
> suspend/resume quirks problem area? Do they "curse BIOS vendors and 

Windows actually have (kernel) graphics drivers that know how to
resume the video. If you boot save mode, they go w/o graphics drivers,
and have similar problems to us.

> btw., the s2ram database seems quite a bit spotty:
> 
>  $ ./s2ram -n
>  Machine is unknown.
>  This machine can be identified by:
>      sys_vendor   = "System manufacturer"
>      sys_product  = "System Product Name"
>      sys_version  = "System Version"
>      bios_version = "ASUS A8N-E ACPI BIOS Revision 1008"
> 
>  $ ./s2ram -n
>  Machine is unknown.
>  This machine can be identified by:
>     sys_vendor   = "Hewlett-Packard "
>     sys_product  = "compaq nx9030 (PG630ET#ABD)       "
>     sys_version  = "Rev 1           "
>     bios_version = "F.15    "
>  See http://en.opensuse.org/S2ram for details.

Desktops are the problem; but that nx9030 should be reasonably easy to
add.

> even at the link above i didnt find any clear algorithm about how to 
> extend the quirks-list and the white-list - while i expect that most 
> people experience what i did: that s2ram doesnt know their boxes. 
> (otherwise they would not visit that URL at all i suspect)

Did you get options for s2ram that work on your systems? Mail them to
seife@suse.de, and he'll extend the whitelist ;-). In the meantime,
just use -f <whatever>
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
