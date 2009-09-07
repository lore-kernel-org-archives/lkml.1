Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZIGRip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZIGRip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 13:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZIGRip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 13:38:45 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52915 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbZIGRio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 13:38:44 -0400
Date: Mon, 7 Sep 2009 19:38:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907173846.GB18599@kernel.dk>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk> <20090907141458.GD24507@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907141458.GD24507@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Mon, Sep 07 2009, Jens Axboe wrote:
> > > Scheduler       Runtime         Max lat     Avg lat     Std dev
> > > ----------------------------------------------------------------
> > > CFS             100             951         462         267
> > > CFS-x2          100             983         484         308
> > > BFS
> > > BFS-x2
> > 
> > Those numbers are buggy, btw, it's not nearly as bad. But 
> > responsiveness under compile load IS bad though, the test app just 
> > didn't quantify it correctly. I'll see if I can get it working 
> > properly.
> 
> What's the default latency target on your box:
> 
>   cat /proc/sys/kernel/sched_latency_ns
> 
> ?

It's off right now, but it is set to whatever is the default. I don't
touch it.

> And yes, it would be wonderful to get a test-app from you that would 
> express the kind of pain you are seeing during compile jobs.

I was hoping this one would, but it's not showing anything. I even added
support for doing the ping and wakeup over a socket, to see if the pipe
test was doing well because of the sync wakeup we do there. The net
latency is a little worse, but still good. So no luck in making that app
so far.

-- 
Jens Axboe

