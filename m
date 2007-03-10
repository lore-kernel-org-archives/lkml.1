Return-Path: <linux-kernel-owner+w=401wt.eu-S1767839AbXCJPU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767839AbXCJPU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 10:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767841AbXCJPU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 10:20:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49133 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767839AbXCJPU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 10:20:26 -0500
Date: Sat, 10 Mar 2007 16:18:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Seyfried <seife@suse.de>
Cc: Pavel Machek <pavel@suse.cz>, Johannes Stezenbach <js@linuxtv.org>,
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
Message-ID: <20070310151804.GA10627@elte.hu>
References: <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il> <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org> <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu> <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org> <20070309174821.GA31754@linuxtv.org> <20070309233508.GB2197@elf.ucw.cz> <20070310090121.GB15647@elte.hu> <20070310114301.GA30554@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310114301.GA30554@suse.de>
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


* Stefan Seyfried <seife@suse.de> wrote:

> > btw., the s2ram database seems quite a bit spotty:
> > 
> >  $ ./s2ram -n
> >  Machine is unknown.
> >  This machine can be identified by:
> >      sys_vendor   = "System manufacturer"
> >      sys_product  = "System Product Name"
> >      sys_version  = "System Version"
> >      bios_version = "ASUS A8N-E ACPI BIOS Revision 1008"
> > 
> >  $ ./s2ram -n
> >  Machine is unknown.
> >  This machine can be identified by:
> >     sys_vendor   = "Hewlett-Packard "
> >     sys_product  = "compaq nx9030 (PG630ET#ABD)       "
> >     sys_version  = "Rev 1           "
> >     bios_version = "F.15    "
> >  See http://en.opensuse.org/S2ram for details.
> > 
> > even at the link above i didnt find any clear algorithm about how to 
> > extend the quirks-list and the white-list - while i expect that most 
> > people experience what i did: that s2ram doesnt know their boxes. 
> > (otherwise they would not visit that URL at all i suspect)
> 
> Ok. To be honest, you are the first reporter that seems to have read 
> the documentation above, but not understood what to do.

thanks for the compliment ;-) _I_ very much know what to do (i mailed 
the right person after all ;), but i dont really count and on the 6 
systems i tried s2ram said on 5 that it's 'unknown', i assumed it could 
possibly be due to the visible lack of clear instructions on that 
webpage ;-)

> i might consider reworking the documentation if there are more reports 
> about problems with the procedure.

Probably tweaking the webpage doesnt help because people dont get there 
- as the results plainly show it. Maybe some more automation would be 
useful too, a tool that detects failed resume and tries all those 
options that makes sense on that box or something? It's not like that 
people dont _try_ suspend/resume on Linux, it's just that they find it 
doesnt work and there is no clear mortal-usable (end-user-) way of 
fixing it and submitting the result of that fixing.

	Ingo
