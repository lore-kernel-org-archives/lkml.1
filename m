Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZIHMmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZIHMmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 08:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZIHMmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 08:42:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:52584 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751075AbZIHMmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 08:42:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18/Sk4Lciw/shSLlpqr2LZzs8s3YXeVEZSSBxrYTz
	fSHPBSnKnRgdNT
Subject: Re: [tip:sched/core] sched: Ensure that a child can't gain time
 over it's parent after fork()
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20090908115300.GW18599@kernel.dk>
References: <tip-b5d9d734a53e0204aab0089079cbde2a1285a38f@git.kernel.org>
	 <20090908114927.GA1649@elte.hu>  <20090908115300.GW18599@kernel.dk>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 14:42:13 +0200
Message-Id: <1252413733.11445.0.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 13:53 +0200, Jens Axboe wrote:
> On Tue, Sep 08 2009, Ingo Molnar wrote:
> > 
> > * tip-bot for Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > Commit-ID:  b5d9d734a53e0204aab0089079cbde2a1285a38f
> > > Gitweb:     http://git.kernel.org/tip/b5d9d734a53e0204aab0089079cbde2a1285a38f
> > > Author:     Mike Galbraith <efault@gmx.de>
> > > AuthorDate: Tue, 8 Sep 2009 11:12:28 +0200
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Tue, 8 Sep 2009 13:15:34 +0200
> > > 
> > > sched: Ensure that a child can't gain time over it's parent after fork()
> > 
> > > This improves latencies of make -j<n> kernel build workloads.
> > > 
> > > Reported-by: Jens Axboe <jens.axboe@oracle.com>
> > 
> > Jens, mind trying this patch (or latest tip:master) with your make 
> > -j4 workload, does it improve in any way?
> 
> Already booted it, makes no real difference... I'm trying with NO_HZ
> disabled now to see if that changes the picture.

Oh well, BTTODB.  Thanks for trying it out.

	-Mike

