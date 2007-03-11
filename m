Return-Path: <linux-kernel-owner+w=401wt.eu-S934003AbXCKTLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003AbXCKTLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934012AbXCKTLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:11:13 -0400
Received: from mxl144v77.mxlogic.net ([208.65.144.77]:40317 "EHLO
	p02c11o144.mxlogic.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934003AbXCKTLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:11:12 -0400
X-Greylist: delayed 2069 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Mar 2007 15:11:12 EDT
Date: Sun, 11 Mar 2007 20:37:09 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
Message-ID: <20070311183709.GB19601@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <20070311180342.GE24475@mellanox.co.il> <m1mz2jws83.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1mz2jws83.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 11 Mar 2007 18:39:24.0408 (UTC) FILETIME=[974C1780:01C7640C]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15044.001
X-TM-AS-Result: No--14.776200-4.000000-31
X-Spam: [F=0.4928922100; S=0.492(2007030701)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Eric W. Biederman <ebiederm@xmission.com>:
> Subject: Re: SATA resume slowness, e1000 MSI warning
> 
> "Michael S. Tsirkin" <mst@mellanox.co.il> writes:
> 
> >> Rumor has it that some pci devices can't tolerate < 32bit accesses.
> >> Although I have never met one.
> >
> > hopefully not bridge devices?
> >
> >> The two factors together suggest that
> >> for generic code it probably makes sense to operate on 32bit
> >> quantities, and just to ignore the read-only portion.
> >
> > The code for regular devices seems to use 16-bit accesses, so
> > I think it's best to stay consistent. Or do you want to change this too?
> 
> If we are stomping rare probabilities we might as well change that too.
> The code to save pci-x state is relatively recent.  So it probably just
> hasn't met a problem device yet (assuming they exist).

OK I guess. I gather we assume writing read-only registers has no side effects?
Are there rumors circulating wrt to these?

-- 
MST
