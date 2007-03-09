Return-Path: <linux-kernel-owner+w=401wt.eu-S1767169AbXCILBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767169AbXCILBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767167AbXCILBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:01:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37145 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767166AbXCILBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:01:03 -0500
Date: Fri, 9 Mar 2007 11:56:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael S. Tsirkin" <mst@mellanox.co.il>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, pavel@suse.cz,
       linux-pm@lists.osdl.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
       luming.yu@intel.com, Arkadiusz Miskiewicz <arekm@maven.pl>,
       Konstantin Karasyov <konstantin.a.karasyov@intel.com>,
       Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net,
       Thomas Meyer <thomas.mey@web.de>, Meelis Roos <mroos@linux.ee>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Janosch Machowinski <jmachowinski@gmx.de>, vladimir.p.lebedev@intel.com,
       Ash Milsted <thatistosayiseenem@gawab.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Message-ID: <20070309105635.GA11635@elte.hu>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il> <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org> <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu> <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > disabling the following radeonfb options in the .config made resume 
> > work again:
> 
> In general, don't even *try* to use radeonfb for suspend/resume.
> 
> I don't think it has ever worked, except on some very rare laptops 
> (largely PPC Macs) where people had enough information to set up the 
> PLL's.
> 
> I don't think the other framebuffer drivers are much better.
> 
> You're better off using the VGA console, and lettign X re-initialize 
> the graphics device. That generally at least has a reasonably good 
> chance of working.
> 
> Re-initializing graphics modes really is very hard. You can try with 
> the BIOS video hack (I forget the kernel command line to turn it on), 
> but we really do end up depending on X doing it better.

it's the s3_sleep boot option and /proc/sys/kernel/acpi_video_mode, but 
that didnt make a difference.

> Some day we may have modesetting support in the kernel for some 
> graphics hw, right now it's pretty damn spotty.

having no video is what i'd have expected - but getting a /hang/ is not 
what i'd have expected.

	Ingo
