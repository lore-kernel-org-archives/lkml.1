Return-Path: <linux-kernel-owner+w=401wt.eu-S935769AbXG2Urg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935769AbXG2Urg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 16:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763427AbXG2Ur2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 16:47:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43762 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbXG2Ur1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 16:47:27 -0400
Date: Sun, 29 Jul 2007 22:47:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John <darknessenvelops@gmail.com>
Cc: Kasper Sandberg <lkml@metanurb.dk>, ck@vds.kolivas.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Message-ID: <20070729204716.GB1578@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* John <darknessenvelops@gmail.com> wrote:

> Ingo-
> 
> Why not perform the same test using the native linux Q3 client to 
> compare numbers to wine? [...]

I regularly test native Linux games on CFS, and they all behave well. 
While waiting for more detailed data from Kasper i was looking for 
atypical stuff in Kasper's description about what his workload involves, 
and what looked a bit atypical was that Kasper's workload also involved 
gaming under Wine:

> > > my test subjects are quake(s), world of warcraft via wine, unreal 
> > > tournament 2004. [...]

and Wine is a more complex server/client scenario instead of a single 
(and simple) standalone Quake3 binary that the Linux binary does. So it 
looked more interesting from a scheduler workload (and scheduler 
regression) POV. In any case i'll need more info from Kasper.

	Ingo
