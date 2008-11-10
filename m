Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbYKJJwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbYKJJwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbYKJJwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:52:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55276 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbYKJJwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:52:18 -0500
Date: Mon, 10 Nov 2008 10:52:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: cleanup debug info
Message-ID: <20081110095209.GB15237@elte.hu>
References: <20081110092350.GA3679@in.ibm.com> <1226310392.2697.4054.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226310392.2697.4054.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Subject: sched: cleanup debug info
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Oct 30 23:57:11 CET 2008
> 
> While looking over the sched_debug code I noticed that we printed the rq
> schedstats for every cfs_rq, ammend this.
> 
> Also change nr_spead_over into an int, and fix a little buglet in
> min_vruntime printing.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c       |    2 +-
>  kernel/sched_debug.c |   41 +++++++++++++++++++++--------------------
>  2 files changed, 22 insertions(+), 21 deletions(-)

applied to tip/sched/urgent, thanks Peter!

	Ingo
