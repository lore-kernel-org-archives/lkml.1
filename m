Return-Path: <linux-kernel-owner+w=401wt.eu-S967846AbXG3TCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967846AbXG3TCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967137AbXG3TCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:02:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53761 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967113AbXG3TCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:02:01 -0400
Date: Mon, 30 Jul 2007 21:01:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: david@lang.hm
Cc: John <darknessenvelops@gmail.com>, Kasper Sandberg <lkml@metanurb.dk>,
       ck@vds.kolivas.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Message-ID: <20070730190147.GC20901@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com> <20070729204716.GB1578@elte.hu> <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com> <20070730114649.GB19186@elte.hu> <Pine.LNX.4.64.0707300914160.11330@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707300914160.11330@asgard.lang.hm>
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


* david@lang.hm <david@lang.hm> wrote:

> > Would you be interested in trying CFS and doing some numers perhaps? 
> > It requires some work: you have to start up your favorite game in a 
> > way that gives a reliable framerate number. (many games allow the 
> > display of FPS in-game) In Quake3 i simply started the game and did 
> > not move the player - that is something easy to reproduce.
> 
> the one report that I saw said that the FPS numbers were overall the 
> same, but what the reporter was seeing was that CFS was doing it in 
> bursts of activity while SD was smoother. [...]

which report is that, precisely? I'm not aware of any such report past 
CFS v14 or so.

> IIRC Linus responded with thoughts on granularity and the fact that 
> changing from Hz 1000 to Hz 100 will increase the timeslices in CFS by 
> 10x (which could be enough to trigger this sort of issue)

ah, you mean Kasper Sandberg's report? That turned out to be based on an 
older CFS version, not v2.6.23-rc1. Kasper said he'll redo his tests, 
and if there's still any regression left we'll fix it.

	Ingo
