Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZAFRsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZAFRsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZAFRsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:48:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:58233 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752443AbZAFRsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:48:43 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX185axJMbIY5H8AMyjthQBkKbLkZnuGZPShSJkZz0m
	kWlJFF7bs8QPQp
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
From: Mike Galbraith <efault@gmx.de>
To: svaidy@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090106150709.GG4574@dirshya.in.ibm.com>
References: <20090103101626.GA4301@dirshya.in.ibm.com>
	 <1230981761.27180.10.camel@marge.simson.net>
	 <1231081200.17224.44.camel@marge.simson.net>
	 <20090104181946.GC4301@dirshya.in.ibm.com>
	 <1231098769.5757.43.camel@marge.simson.net>
	 <20090105032029.GE4301@dirshya.in.ibm.com>
	 <1231130416.5479.8.camel@marge.simson.net>
	 <1231137413.10471.23.camel@marge.simson.net>
	 <1231168786.9120.26.camel@marge.simson.net>
	 <1231234297.3806.50.camel@marge.simson.net>
	 <20090106150709.GG4574@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 18:48:37 +0100
Message-Id: <1231264117.5254.23.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 20:37 +0530, Vaidyanathan Srinivasan wrote:

> Hi Mike,
> 
> Thanks for the detailed benchmark reports.  Glad to hear that
> sched_mc=2 is helping in most scenarios.  Though we would be tempted to
> make it default, I would still like to default to zero in order to
> provide base line performance.  I would expect end users to flip the
> settings to sched_mc=2 if it helps their workload in terms of
> performance and/or power savings.

The mysql+oltp peak loss is there either way, but with 2, mid range
throughput is ~28 baseline.  High end (yawn) is better, and the nfs
kbuild performs better than baseline.

Baseline performance, at least wrt mysql+oltp doesn't seem to be an
option.  Not my call.  More testing and more testers required I suppose.

	-Mike

