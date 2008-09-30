Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbYI3N0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbYI3N0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 09:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYI3N0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 09:26:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59278 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYI3N0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 09:26:30 -0400
Date: Tue, 30 Sep 2008 15:26:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH][resubmit] sched: minor optimizations in wake_affine
	and select_task_rq_fair
Message-ID: <20080930132609.GA19233@elte.hu>
References: <20080929100227.GA21129@amitarora.in.ibm.com> <20080930114539.GB14977@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930114539.GB14977@amitarora.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Amit K. Arora <aarora@linux.vnet.ibm.com> wrote:

> As mentioned in http://lkml.org/lkml/2008/9/30/141 , this is the new
> patch.
> 
> sched: Minor optimizations in wake_affine and select_task_rq_fair
> 
> This patch does following:
> o Removes unused variable and argument "rq".
> o Optimizes one of the "if" conditions in wake_affine() - i.e.  if
>   "balanced" is true, we need not do rest of the calculations in the
>   condition.
> o If this cpu is same as the previous cpu (on which woken up task
>   was running when it went to sleep), no need to call wake_affine at all.
> 
> Signed-off-by: Amit K Arora <aarora@linux.vnet.ibm.com>
> CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Ingo Molnar <mingo@elte.hu>

applied to tip/sched/devel, thanks Amit!

	Ingo
