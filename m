Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbZCCQ0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbZCCQ0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbZCCQ0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:26:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44586 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbZCCQ0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:26:32 -0500
Date: Tue, 3 Mar 2009 17:26:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: svaidy@linux.vnet.ibm.com, Gautham R Shenoy <ego@in.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, efault@gmx.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2 2/3] sched: Fix the wakeup nomination for
	sched_mc/smt_power_savings.
Message-ID: <20090303162612.GA11208@elte.hu>
References: <20090303114648.605.86920.stgit@sofia.in.ibm.com> <20090303115149.605.92140.stgit@sofia.in.ibm.com> <1236083033.5330.4204.camel@laptop> <20090303135907.GA23822@elte.hu> <20090303154537.GI4708@dirshya.in.ibm.com> <1236095306.5330.4777.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236095306.5330.4777.camel@laptop>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-03-03 at 21:15 +0530, Vaidyanathan Srinivasan wrote:
> 
> > I had earlier posted cleanup for find_busiest_group(), but 
> > Peter mentioned that he is changing the cpu_power 
> > infrastructure and I can rework the cleanup after that.
> 
> Right, I need to get back to pondering that problem. The whole 
> 1/x thing doesn't really work.

well, the cleanups are needed in any case before we add more 
changes to it - that function is a monster.

	Ingo
