Return-Path: <linux-kernel-owner+w=401wt.eu-S1767657AbXCIXfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767657AbXCIXfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767654AbXCIXfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:35:36 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43572 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767656AbXCIXff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:35:35 -0500
Date: Sat, 10 Mar 2007 00:35:08 +0100
From: Pavel Machek <pavel@suse.cz>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
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
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Message-ID: <20070309233508.GB2197@elf.ucw.cz>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il> <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org> <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu> <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org> <20070309174821.GA31754@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309174821.GA31754@linuxtv.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > You're better off using the VGA console, and lettign X re-initialize the 
> > graphics device. That generally at least has a reasonably good chance of 
> > working.
> > 
> > Re-initializing graphics modes really is very hard. You can try with the 
> > BIOS video hack (I forget the kernel command line to turn it on), but we 
> > really do end up depending on X doing it better.
> 
> acpi_sleep=s3_bios has always worked for me on my ThinkPad T42p.
> 
> Even if one doesn't use the fb console at all, radeonfb apparently
> is still required on some ThinkPad models to work around BIOS bugs:
> 
> http://www.thinkwiki.org/wiki/Problem_with_high_power_drain_in_ACPI_sleep#Radeon_GPU_not_powered_off


s2ram should be able to work around this, it has parts from
radeontool. (suspend.sf.net).


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
