Return-Path: <linux-kernel-owner+w=401wt.eu-S932305AbZHLJXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbZHLJXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932269AbZHLJXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:23:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41576 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237AbZHLJXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:23:10 -0400
Date: Wed, 12 Aug 2009 11:22:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: CONFIG_PREEMPT_RCU in next/mmotm
Message-ID: <20090812092250.GD21655@elte.hu>
References: <Pine.LNX.4.64.0908090414320.18096@sister.anvils> <20090809053308.GD6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908091209150.23855@sister.anvils> <Pine.LNX.4.64.0908091346450.27358@sister.anvils> <20090809185753.GG6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908092139090.3194@sister.anvils> <20090809211629.GJ6866@linux.vnet.ibm.com> <20090810033907.GA1530@linux.vnet.ibm.com> <20090810224345.GA17730@linux.vnet.ibm.com> <20090812013422.GA23187@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812013422.GA23187@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Should these tests pass...
> 
> Unless someone tells me otherwise, I will make a patch series 
> intended to replace tip/core/rcu commits 7fe616c5d ("Simplify RCU 
> CPU-hotplug notification"), 04b06256c ("Fix RCU & CPU hotplug 
> hang"), and 7256cf0e83b ("Add diagnostic check for a possible 
> CPU-hotplug race"), re-run all tests on that patchset, and submit 
> the series.  I expect the resulting patch set to have three 
> patches, one to split out boot-time initialization for RCU_TREE, a 
> second to create the cpu_notifier() API, and the third to make RCU 
> use it.

Sure - we can reasonably rebase portions of that stack of commits:

 earth4:~/tip> gll linus..core/rcu
 7256cf0: rcu: Add diagnostic check for a possible CPU-hotplug race
 04b0625: rcu: Fix RCU & CPU hotplug hang
 7fe616c: rcu: Simplify RCU CPU-hotplug notification
 240ebbf: rcu: Add synchronize_sched_expedited() rcutorture doc + updates
 0acc512: rcu: Add synchronize_sched_expedited() torture tests
 03b042b: rcu: Add synchronize_sched_expedited() primitive
 c17ef45: rcu: Remove Classic RCU

Please mention the magic words "please reset core/rcu to 240ebbf 
before applying these patches" in the mail to me, should i forget in 
the days to come.

(hm, what was i supposed to not forget? Weird.)

	Ingo
