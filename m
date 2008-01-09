Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYAILgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYAILgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 06:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYAILgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 06:36:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbYAILgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 06:36:08 -0500
Date: Wed, 9 Jan 2008 12:35:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, discuss@LessWatts.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de, Arjan van de Ven <arjan@infradead.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Chanda Sethia <chanda.sethia@in.ibm.com>
Subject: Re: Analysis of sched_mc_power_savings
Message-ID: <20080109113507.GA29721@elte.hu>
References: <20080108173815.GA7793@dirshya.in.ibm.com> <20080108212400.GA8903@linux-os.sc.intel.com> <20080109111302.GC7793@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109111302.GC7793@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> How do we take this technique to the next step where we can 
> consolidate short running jobs as well?  Did you face any difficulty 
> biasing the CPU for short running jobs?

are you sure your measurement tasks do not impact the measurement 
workload? If you use something like 'top' then try running it reniced to 
+19. (or perhaps even bound to a particular CPU, say #3, to make its 
impact isolated)

	Ingo
