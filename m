Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbXD2HMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbXD2HMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbXD2HMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:12:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34252 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbXD2HMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:12:45 -0400
Date: Sun, 29 Apr 2007 09:11:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, Kasper Sandberg <lkml@metanurb.dk>,
       buddabrod <buddabrod@gmail.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [patch] CFS scheduler, -v7
Message-ID: <20070429071117.GA3612@elte.hu>
References: <20070428152539.GA21601@elte.hu> <200704282220.17689.caglar@pardus.org.tr> <20070428192446.GA18822@elte.hu> <200704290242.43741.caglar@pardus.org.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704290242.43741.caglar@pardus.org.tr>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=ADVANCE_FEE_1,BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 ADVANCE_FEE_1          Appears to be advance fee fraud (Nigerian 419)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> Ingo, please ignore my first report until i found a proper way to 
> reproduce the slowness cause currently CFS-v7, CFS-v7 + "renice 
> patch", CFS-v7 + renice + your private mail suggestions and CFS-v6 + 
> "PI support for futexes patch" seems works equally (which is a good 
> thing so X renicing seems really not needed, [...]

oh, good!

> [...] and there were no regression instead of my daydreams) or im too 
> tired to understand the differences.

could the CPU have dropped speed for that bootup (some CPUs do that 
automatically upon overheating), or perhaps if you are using some RAID 
array, could it have done a background resync? Especially the bootup 
slowdown you saw seemed significant, and because bootup speed is 90% IO 
dominated, the CPU scheduler seems an unlikely candidate.

	Ingo
