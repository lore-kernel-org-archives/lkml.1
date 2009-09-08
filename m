Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbZIHLtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbZIHLtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 07:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZIHLtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 07:49:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42538 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbZIHLtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 07:49:41 -0400
Date: Tue, 8 Sep 2009 13:49:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, jens.axboe@oracle.com,
       tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Ensure that a child can't gain time
	over it's parent after fork()
Message-ID: <20090908114927.GA1649@elte.hu>
References: <tip-b5d9d734a53e0204aab0089079cbde2a1285a38f@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-b5d9d734a53e0204aab0089079cbde2a1285a38f@git.kernel.org>
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


* tip-bot for Mike Galbraith <efault@gmx.de> wrote:

> Commit-ID:  b5d9d734a53e0204aab0089079cbde2a1285a38f
> Gitweb:     http://git.kernel.org/tip/b5d9d734a53e0204aab0089079cbde2a1285a38f
> Author:     Mike Galbraith <efault@gmx.de>
> AuthorDate: Tue, 8 Sep 2009 11:12:28 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 8 Sep 2009 13:15:34 +0200
> 
> sched: Ensure that a child can't gain time over it's parent after fork()

> This improves latencies of make -j<n> kernel build workloads.
> 
> Reported-by: Jens Axboe <jens.axboe@oracle.com>

Jens, mind trying this patch (or latest tip:master) with your make 
-j4 workload, does it improve in any way?

	Ingo
