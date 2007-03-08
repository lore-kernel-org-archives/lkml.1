Return-Path: <linux-kernel-owner+w=401wt.eu-S933245AbXCHT5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbXCHT5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933242AbXCHT5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:57:16 -0500
Received: from p02c11o143.mxlogic.net ([208.65.145.66]:43335 "EHLO
	p02c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236AbXCHT5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:57:14 -0500
Date: Thu, 8 Mar 2007 21:57:35 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
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
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Message-ID: <20070308195735.GG17114@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il> <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 08 Mar 2007 19:59:45.0689 (UTC) FILETIME=[51C3F090:01C761BC]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15042.000
X-TM-AS-Result: No--8.101200-4.000000-4
X-Spam: [F=0.4550880124; S=0.455(2007030701)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 2. First disk access after resume takes a couple of minutes
> >    (seemed instant with 2.6.20) during this time no new messages show on console
> 
> Yeah, there is some problem with SATA resume. It would be beautiful if the 
> people who actually see this could narrow it down with bisection. "It 
> works for me" is clearly the case for many people, but not all.

Problem is, there seem to be multiple problems some of which got
fixed between rc2 and rc3.
With rc2 I didn't get as far as getting to console.

-- 
MST
