Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbZAFSqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbZAFSqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZAFSpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:45:55 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:44476 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbZAFSpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:45:55 -0500
Date: Wed, 7 Jan 2009 00:15:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20090106184552.GI17198@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1231081200.17224.44.camel@marge.simson.net> <20090104181946.GC4301@dirshya.in.ibm.com> <1231098769.5757.43.camel@marge.simson.net> <20090105032029.GE4301@dirshya.in.ibm.com> <1231130416.5479.8.camel@marge.simson.net> <1231137413.10471.23.camel@marge.simson.net> <1231168786.9120.26.camel@marge.simson.net> <1231234297.3806.50.camel@marge.simson.net> <20090106150709.GG4574@dirshya.in.ibm.com> <1231264117.5254.23.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1231264117.5254.23.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2009-01-06 18:48:37]:

> On Tue, 2009-01-06 at 20:37 +0530, Vaidyanathan Srinivasan wrote:
> 
> > Hi Mike,
> > 
> > Thanks for the detailed benchmark reports.  Glad to hear that
> > sched_mc=2 is helping in most scenarios.  Though we would be tempted to
> > make it default, I would still like to default to zero in order to
> > provide base line performance.  I would expect end users to flip the
> > settings to sched_mc=2 if it helps their workload in terms of
> > performance and/or power savings.
> 
> The mysql+oltp peak loss is there either way, but with 2, mid range
> throughput is ~28 baseline.  High end (yawn) is better, and the nfs
> kbuild performs better than baseline.
> 
> Baseline performance, at least wrt mysql+oltp doesn't seem to be an
> option.  Not my call.  More testing and more testers required I suppose.

Yes, more testing is definitely due. I'd like to hear from people
with larger and newer boxes as well before I would be comfortable making
sched_mc=2 as default.

-- 
	Balbir
