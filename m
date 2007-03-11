Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbXCKIWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbXCKIWA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 04:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXCKIWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 04:22:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47786 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbXCKIV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 04:21:58 -0400
Date: Sun, 11 Mar 2007 09:20:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: Stefan Seyfried <seife@suse.de>, Johannes Stezenbach <js@linuxtv.org>,
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
       Ash Milsted <thatistosayiseenem@gawab.com>, dmitry.torokhov@gmail.com
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Message-ID: <20070311082002.GA4013@elte.hu>
References: <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org> <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu> <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org> <20070309174821.GA31754@linuxtv.org> <20070309233508.GB2197@elf.ucw.cz> <20070310090121.GB15647@elte.hu> <20070310114301.GA30554@suse.de> <20070310151804.GA10627@elte.hu> <20070310220810.GF2758@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310220810.GF2758@elf.ucw.cz>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> > Probably tweaking the webpage doesnt help because people dont get 
> > there - as the results plainly show it. Maybe some more automation 
> > would be useful too, a tool that detects failed resume and tries all 
> > those options that makes sense on that box or something? It's not 
> > like that
> 
> Unfortunately, these tend to crash the box when you pass wrong 
> options, and I do not see easy way to test "can user see whats on 
> display" automatically.

you could perhaps try what X's modesetting utility does: display a 
dialog box that times out if it does not get clicked on, and reboot if 
it did not get clicked on. Likewise, detect upon the next bootup that a 
suspend-test was in progress (and didnt get back via normal resume), via 
some temporary file. That way both the 'did not resume and i had to 
power-cycle' and the 'resume did not restore my X' problems can be 
handled.

Finally, when the correct options have been established (worse-case with 
a small number of reboots and "yes, indeed the resume did not work fine" 
clicks done upon bootup by the user), automatically fill in a webform in 
firefox and ask the user to do a single click to submit that form.

techniques like that have more chance i think to get Linux 
suspend/resume anywhere near to working. The current 'rely on the 
developer' technique apparently does not work.

	Ingo
