Return-Path: <linux-kernel-owner+w=401wt.eu-S935608AbXG2VRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935608AbXG2VRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936419AbXG2VRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:17:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56075 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936353AbXG2VQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:16:59 -0400
Date: Sun, 29 Jul 2007 23:16:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] sched: introduce SD_BALANCE_FORK for ht/mc/smp domains
Message-ID: <20070729211644.GC6808@elte.hu>
References: <20070726183225.GJ3318@linux-os.sc.intel.com> <20070726221830.GA4113@elte.hu> <20070726223455.GK3318@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726223455.GK3318@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> They might be doing more exec's and probably covered by exec balance.
> 
> There was a small pthread test case which was calculating the time to 
> create all the threads and how much time each thread took to start 
> running. It appeared as if the threads ran sequentially one after 
> another on a DP system with four cores leading to this SD_BALANCE_FORK 
> observation.

would be nice to dig out that testcase i suspect and quantify the 
benefits of your patch. Another workload which might perform better 
would be linpack: it benefits from fast and immediate 'spreading' of 
freshly forked threads.

	Ingo
