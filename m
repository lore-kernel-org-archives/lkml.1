Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbZEKMfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbZEKMfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZEKMfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:35:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49238 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbZEKMfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:35:40 -0400
Date: Mon, 11 May 2009 14:35:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       svaidy@linux.vnet.ibm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH][REPOST] Don't export sched_mc_power_savings on
	multi-socket single core system
Message-ID: <20090511123529.GH13954@elte.hu>
References: <4A081A4B.1000204@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A081A4B.1000204@linux.vnet.ibm.com>
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


* Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com> wrote:

> My previous post got lost somewhere in lkml list. Hence reposting 
> this patch again.

no, it did not get lost, i gave you the feedback below more than a 
month ago. FYI, this resubmission has the same corrupted-patch 
problem.

	Ingo

----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----

Date: Wed, 8 Apr 2009 13:42:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
Subject: Re: [PATCH] Don't export sched_mc_power_savings on multi-socket
	single core system
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	svaidy@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
	dipankar@in.ibm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>


* Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com> wrote:

> Fix to prevent sched_mc_power_saving from being exported through 
> sysfs for multi-scoket single core system. Max cores should be 
> always greater than one (1). My earlier patch that introduced fix 
> for not exporting 'sched_mc_power_saving' on laptops broke it on 
> multi-socket single core system. This fix addresses issue on both 
> laptop and multi-socket single core system. Below are the Test 
> results:

> +#define mc_capable()   (boot_cpu_data.x86_max_cores > 1) && \
> +                       (cpumask_weight(cpu_core_mask(0)) != nr_cpu_ids)
> #define smt_capable()                  (smp_num_siblings > 1)

patch looks good but is whitespace damaged (all tabs were converted 
to spaces). See Documentation/email-clients.txt about how to set up 
your client.

	Ingo

----- End forwarded message -----
