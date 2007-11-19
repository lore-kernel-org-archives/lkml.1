Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbXKSPX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbXKSPX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbXKSPXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:23:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36570 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbXKSPXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:23:18 -0500
Date: Mon, 19 Nov 2007 16:22:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 2/2] sched: Improve fairness of cpu allocation for task
	groups
Message-ID: <20071119152258.GB31426@elte.hu>
References: <20071119122713.GA28777@linux.vnet.ibm.com> <20071119123051.GC28777@linux.vnet.ibm.com> <20071119131201.GB31491@elte.hu> <20071119150312.GA2365@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119150312.GA2365@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> - inc/dec_load() takes a load input instead of task pointer input as their
>   2nd arg
> - inc/dec_nr_running don't call inc/dec_load. Instead,
> - enqueue/dequeue_task class callbacks call inc/dec_load
> - [Unintended/will-fix change] min/max tunables added in
>   /proc/sys/kernel
> 
> All of above changes (except last, which I will fix) should have zero 
> functional+runtime effect for !CONFIG_FAIR_GROUP_SCHED case. So I 
> don't see how I can split Patch 2/2 further.

ok, as long as it's NOP for the CONFIG_FAIR_GROUP_SCHED, we could try 
it.

	Ingo
