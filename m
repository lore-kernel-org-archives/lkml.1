Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbZAEEks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbZAEEks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 23:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZAEEk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 23:40:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:46581 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752173AbZAEEk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 23:40:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18FUG87ws0FnG11BLknzEXWy/rR7VBivft9BWIcnf
	u3losdRHUS8TX2
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
From: Mike Galbraith <efault@gmx.de>
To: svaidy@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090105032029.GE4301@dirshya.in.ibm.com>
References: <20081230062139.GA30038@elte.hu>
	 <20081230180722.GA29060@dirshya.in.ibm.com>
	 <20090102072600.GA13412@dirshya.in.ibm.com>
	 <20090102221630.GF17240@elte.hu> <1230967765.5257.6.camel@marge.simson.net>
	 <20090103101626.GA4301@dirshya.in.ibm.com>
	 <1230981761.27180.10.camel@marge.simson.net>
	 <1231081200.17224.44.camel@marge.simson.net>
	 <20090104181946.GC4301@dirshya.in.ibm.com>
	 <1231098769.5757.43.camel@marge.simson.net>
	 <20090105032029.GE4301@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 05:40:16 +0100
Message-Id: <1231130416.5479.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 08:50 +0530, Vaidyanathan Srinivasan wrote: 
> When CONFIG_SCHED_DEBUG is enabled, the sched domain tree is dumped
> (dmesg)

Oh, that.  I'm dense <thwack>

[    0.476050] CPU0 attaching sched-domain:
[    0.476052]  domain 0: span 0-1 level MC
[    0.476054]   groups: 0 1
[    0.476057]   domain 1: span 0-3 level CPU
[    0.476058]    groups: 0-1 2-3
[    0.476062] CPU1 attaching sched-domain:
[    0.476064]  domain 0: span 0-1 level MC
[    0.476065]   groups: 1 0
[    0.476067]   domain 1: span 0-3 level CPU
[    0.476069]    groups: 0-1 2-3
[    0.476072] CPU2 attaching sched-domain:
[    0.476073]  domain 0: span 2-3 level MC
[    0.476075]   groups: 2 3
[    0.476077]   domain 1: span 0-3 level CPU
[    0.476078]    groups: 2-3 0-1
[    0.476081] CPU3 attaching sched-domain:
[    0.476083]  domain 0: span 2-3 level MC
[    0.476084]   groups: 3 2
[    0.476086]   domain 1: span 0-3 level CPU
[    0.476088]    groups: 2-3 0-1

2.6.26.8
[    0.524043] CPU0 attaching sched-domain:
[    0.524045]  domain 0: span 0-1
[    0.524046]   groups: 0 1
[    0.524049]   domain 1: span 0-3
[    0.524051]    groups: 0-1 2-3
[    0.524054] CPU1 attaching sched-domain:
[    0.524055]  domain 0: span 0-1
[    0.524056]   groups: 1 0
[    0.524059]   domain 1: span 0-3
[    0.524060]    groups: 0-1 2-3
[    0.524063] CPU2 attaching sched-domain:
[    0.524064]  domain 0: span 2-3
[    0.524065]   groups: 2 3
[    0.524068]   domain 1: span 0-3
[    0.524069]    groups: 2-3 0-1
[    0.524072] CPU3 attaching sched-domain:
[    0.524073]  domain 0: span 2-3
[    0.524075]   groups: 3 2
[    0.524077]   domain 1: span 0-3
[    0.524078]    groups: 2-3 0-1

> I was actually asking about software threads specified in the sysbench
> benchmark.  Your have run almost 256 clients on a 4 core box, does
> that mean sysbench had 256 worker threads?

Yes.

	-Mike

