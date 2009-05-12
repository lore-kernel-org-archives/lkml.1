Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZELN2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZELN2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZELN2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:28:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42505 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbZELN2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:28:34 -0400
Date: Tue, 12 May 2009 15:28:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       bharata@linux.vnet.ibm.com, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter
	batch values for stats counters
Message-ID: <20090512132805.GA9808@elte.hu>
References: <20090512102412.GG6351@balbir.in.ibm.com> <20090512102939.GB11714@elte.hu> <20090512193656.D647.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512193656.D647.A69D9226@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > or rather, to make cpuacct_batch have a sane value on UP too. 
> > (1? 0?)
> 
> umm..
> 
> I've reviewed my patch again.
> but sched_init() already has multiple #ifdef SMP. [...]

Patches are welcome to remove more of them.

> [...] Thus I don't think cosmetic changing improve readability 
> largely.

an avoidable #ifdef should aways be avoided.

	Ingo
