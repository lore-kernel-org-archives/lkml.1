Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbZIHLw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbZIHLw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 07:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZIHLw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 07:52:58 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46026 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbZIHLw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 07:52:58 -0400
Date: Tue, 8 Sep 2009 13:53:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Ensure that a child can't gain time
	over it's parent after fork()
Message-ID: <20090908115300.GW18599@kernel.dk>
References: <tip-b5d9d734a53e0204aab0089079cbde2a1285a38f@git.kernel.org> <20090908114927.GA1649@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908114927.GA1649@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08 2009, Ingo Molnar wrote:
> 
> * tip-bot for Mike Galbraith <efault@gmx.de> wrote:
> 
> > Commit-ID:  b5d9d734a53e0204aab0089079cbde2a1285a38f
> > Gitweb:     http://git.kernel.org/tip/b5d9d734a53e0204aab0089079cbde2a1285a38f
> > Author:     Mike Galbraith <efault@gmx.de>
> > AuthorDate: Tue, 8 Sep 2009 11:12:28 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Tue, 8 Sep 2009 13:15:34 +0200
> > 
> > sched: Ensure that a child can't gain time over it's parent after fork()
> 
> > This improves latencies of make -j<n> kernel build workloads.
> > 
> > Reported-by: Jens Axboe <jens.axboe@oracle.com>
> 
> Jens, mind trying this patch (or latest tip:master) with your make 
> -j4 workload, does it improve in any way?

Already booted it, makes no real difference... I'm trying with NO_HZ
disabled now to see if that changes the picture.

-- 
Jens Axboe

