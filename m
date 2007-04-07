Return-Path: <linux-kernel-owner+w=401wt.eu-S966221AbXDGSIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966221AbXDGSIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 14:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966231AbXDGSIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 14:08:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44617 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966221AbXDGSId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 14:08:33 -0400
Date: Sat, 7 Apr 2007 20:08:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: Ten percent test
Message-ID: <20070407180818.GB23861@elte.hu>
References: <200703290237.38777.kernel@kolivas.org> <20070406100333.GA19855@elte.hu> <200704071650.43905.kernel@kolivas.org> <200704071212.57401.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704071212.57401.gene.heskett@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gene Heskett <gene.heskett@gmail.com> wrote:

> To be expected, there are after all, only so many cpu cycles to go 
> around.  Here I sit, running 2.6.21-rc6 ATM, and since there is not an 
> SD patch that applies cleanly to rc6, I am back to typing half or more 
> of a sentence blind while I answer a posting such as this because of x 
> starvation while kmail is sorting incoming stuff.

it would be really nice to analyze this. Does the latest -rt patch boot 
on your box so that we could trace this regression? (I can send you a 
standalone tracing patch if it doesnt.) IIRC you reported that one of 
the early patches from Mike made your system behave good (but still not 
as good as SD) - it would be nice to try a later patch too.

basically, the current unfairness in the scheduler should be solved, one 
way or another. Good testcases were posted and there's progress.

> (who the hell runs a 'make -j 200' or 50 while(1)'s in the real world?

not many - and i dont think Mike tested any of these - Mike tested 
pretty low make -j values (Mike, can you confirm?).

(I personally routinely run 'make -j 200' build jobs on my box [because
 it's the central server of a build cluster and high parallelism is
 needed to overcome network latencies], but i'm pretty special in that
 regard and i didnt use that workload as a test against any of these
 schedulers.)

	Ingo
