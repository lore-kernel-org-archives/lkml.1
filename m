Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbZIGOPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbZIGOPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 10:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZIGOPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 10:15:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51211 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbZIGOPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 10:15:11 -0400
Date: Mon, 7 Sep 2009 16:14:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907141458.GD24507@elte.hu>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907115750.GW18599@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Mon, Sep 07 2009, Jens Axboe wrote:
> > Scheduler       Runtime         Max lat     Avg lat     Std dev
> > ----------------------------------------------------------------
> > CFS             100             951         462         267
> > CFS-x2          100             983         484         308
> > BFS
> > BFS-x2
> 
> Those numbers are buggy, btw, it's not nearly as bad. But 
> responsiveness under compile load IS bad though, the test app just 
> didn't quantify it correctly. I'll see if I can get it working 
> properly.

What's the default latency target on your box:

  cat /proc/sys/kernel/sched_latency_ns

?

And yes, it would be wonderful to get a test-app from you that would 
express the kind of pain you are seeing during compile jobs.

	Ingo
