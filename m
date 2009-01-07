Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbZAGI7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbZAGI7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 03:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZAGI7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 03:59:21 -0500
Received: from mail.gmx.net ([213.165.64.20]:54076 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752388AbZAGI7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 03:59:20 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Htr46yLtH8vrAwaR0eQ12CrEywHnU1dazGCmil2
	9Fti8U1yjCsMZI
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
From: Mike Galbraith <efault@gmx.de>
To: balbir@linux.vnet.ibm.com
Cc: svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090106184552.GI17198@balbir.in.ibm.com>
References: <1231081200.17224.44.camel@marge.simson.net>
	 <20090104181946.GC4301@dirshya.in.ibm.com>
	 <1231098769.5757.43.camel@marge.simson.net>
	 <20090105032029.GE4301@dirshya.in.ibm.com>
	 <1231130416.5479.8.camel@marge.simson.net>
	 <1231137413.10471.23.camel@marge.simson.net>
	 <1231168786.9120.26.camel@marge.simson.net>
	 <1231234297.3806.50.camel@marge.simson.net>
	 <20090106150709.GG4574@dirshya.in.ibm.com>
	 <1231264117.5254.23.camel@marge.simson.net>
	 <20090106184552.GI17198@balbir.in.ibm.com>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 09:59:15 +0100
Message-Id: <1231318755.3899.57.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a couple questions if you don't mind.

In wake_idle() there's an odd looking check for kthreads.  Why does it
matter if a kbuild task wakes kernel or userland helper thread?

I also don't see why sched_mc overrides domain tunings.  You can turn
NEWIDLE off and sched_mc remains as set, so it's a one-way override.  If
NEWIDLE is a requirement for sched_mc > 0, it seems only logical to set
sched_mc to 0 if the user explicitly disables NEWIDLE.

	-Mike

