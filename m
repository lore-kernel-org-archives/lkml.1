Return-Path: <linux-kernel-owner+w=401wt.eu-S1762253AbXHWKjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762253AbXHWKjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 06:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760574AbXHWKiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 06:38:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52992 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760299AbXHWKiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 06:38:51 -0400
Date: Thu, 23 Aug 2007 12:38:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch] sched: skip updating  rq's next_balance under null SD
Message-ID: <20070823103846.GB10435@elte.hu>
References: <20070816010426.GH10033@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816010426.GH10033@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> Was playing with sched_smt_power_savings/sched_mc_power_savings and 
> found out that while the scheduler domains are reconstructed when 
> sysfs settings change, rebalance_domains() can get triggered with null 
> domain on other cpus, which is setting next_balance to jiffies + 
> 60*HZ. Resulting in no idle/busy balancing for 60 seconds.
> 
> Fix this.

thanks, applied.

	Ingo
