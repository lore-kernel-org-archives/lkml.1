Return-Path: <linux-kernel-owner+w=401wt.eu-S1752421AbYKLLqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbYKLLqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 06:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYKLLqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 06:46:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59429 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYKLLq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:46:29 -0500
Date: Wed, 12 Nov 2008 12:46:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Vaidyanathan S <svaidyan@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, efault@gmx.de
Subject: Re: [PATCH][mmotm] Sched fix stale value in average load per task
Message-ID: <20081112114614.GA11352@elte.hu>
References: <20081112104900.GA13896@balbir.in.ibm.com> <20081112113852.GA26884@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112113852.GA26884@balbir.in.ibm.com>
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Balbir Singh <balbir@linux.vnet.ibm.com> [2008-11-12 16:19:00]:
> 
> > +	else
> > +		rq->avg_load_per_task = 0;
> >  
> >  	return rq->avg_load_per_task;
> 
> On second thoughts, does this look better? (Based on Mike 
> Galbraith's suggestion)

yes - but could you send it as a delta patch against your previous 
patch please? We want the simpler patch for tip/sched/urgent, as a 
v2.6.28 fix - the removal of rq->avg_load_per_task can wait until 
v2.6.29. (Please also include Mike's Ack in the patch if he acks the 
patch.)

	Ingo
