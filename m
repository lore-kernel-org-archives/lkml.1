Return-Path: <linux-kernel-owner+w=401wt.eu-S933174AbXCHTrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbXCHTrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933231AbXCHTrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:47:09 -0500
Received: from p02c11o144.mxlogic.net ([208.65.145.67]:55268 "EHLO
	p02c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933144AbXCHTrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:47:06 -0500
Date: Thu, 8 Mar 2007 21:47:23 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20070308194723.GF17114@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il> <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org> <20070308190642.GA30517@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308190642.GA30517@elte.hu>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 08 Mar 2007 19:49:33.0951 (UTC) FILETIME=[E52420F0:01C761BA]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15042.000
X-TM-AS-Result: No--13.358200-4.000000-31
X-Spam: [F=0.2815231650; S=0.281(2007030701)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Ingo Molnar <mingo@elte.hu>:
> Subject: Re: [2/6] 2.6.21-rc2: known regressions
> 
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > 3. When I switch to X (CTRL-ALT-F7), X hangs after drawing a couple of windows
> > >    after waiting for some 10 min, I rebooted. no new messages showed 
> > >    up in /var/log/messages
> > 
> > I think this is likely just more of the disk being buggered, but it 
> > could again be related to NO_HZ (people report time not advancing, and 
> > that would make any X timeout taking forever, and you'd see exactly 
> > your behaviour).
> 
> Michael - does your 'date' output advance after resume? If not then i'd 
> say it's a NO_HZ related problem. If yes then i'd guess it's the SATA 
> problem.

I'll test, but I have NO_HZ off for now.

-- 
MST
