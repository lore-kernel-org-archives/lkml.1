Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZAHIHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZAHIHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 03:07:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZAHIGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 03:06:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:46059 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752542AbZAHIGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:06:53 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19fBQBR9lJfrfyBnfxHzcd3Oi3TZIqmwi5qzsk05D
	HXbzbLBo8YlDHP
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
From: Mike Galbraith <efault@gmx.de>
To: svaidy@linux.vnet.ibm.com
Cc: balbir@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090107153510.GN4574@dirshya.in.ibm.com>
References: <1231130416.5479.8.camel@marge.simson.net>
	 <1231137413.10471.23.camel@marge.simson.net>
	 <1231168786.9120.26.camel@marge.simson.net>
	 <1231234297.3806.50.camel@marge.simson.net>
	 <20090106150709.GG4574@dirshya.in.ibm.com>
	 <1231264117.5254.23.camel@marge.simson.net>
	 <20090106184552.GI17198@balbir.in.ibm.com>
	 <1231318755.3899.57.camel@marge.simson.net>
	 <20090107112639.GI4574@dirshya.in.ibm.com>
	 <1231338985.5709.22.camel@marge.simson.net>
	 <20090107153510.GN4574@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 09:06:48 +0100
Message-Id: <1231402008.5721.37.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 21:05 +0530, Vaidyanathan Srinivasan wrote:

> sched_mc=2 depends on NEWIDLE but the wakeup biasing part will be
> enabled even without this flag.  The power savings will be marginally
> better than sched_mc=1 without NEWIDLE.  But the end user can have
> that setup if they want to.

That implies to me that there should exist a flag SD_WAKEUP_BIAS or
whatnot.  All settings should be visible.  Currently, sched_mc > 0 turns
on NEWIDLE, which is visible, but 2 turns on this 'invisible to the
ultimate low-level control interface' thing.

	-Mike

