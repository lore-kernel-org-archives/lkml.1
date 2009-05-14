Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbZENJwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbZENJwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759488AbZENJvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:51:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:52078 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbZENJvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:51:18 -0400
Subject: Re: [PATCH 2/3] perf_counter: allow arch to supply event misc
 flags and instruction pointer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18955.59546.713452.302649@cargo.ozlabs.ibm.com>
References: <18955.36913.304477.712583@drongo.ozlabs.ibm.com>
	 <1242283534.26820.42.camel@twins>
	 <18955.59546.713452.302649@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 11:51:04 +0200
Message-Id: <1242294664.6642.1000.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 19:47 +1000, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > On Thu, 2009-05-14 at 13:29 +1000, Paul Mackerras wrote:
> 
> > >  #define PERF_EVENT_MISC_KERNEL		(1 << 0)
> > >  #define PERF_EVENT_MISC_USER		(1 << 1)
> > >  #define PERF_EVENT_MISC_OVERFLOW	(1 << 2)
> > > +#define PERF_EVENT_MISC_HYPERVISOR	(1 << 3)
> > 
> > Ah, I think I've taught userspace that either !USER && !KERNEL or USER
> > && KERNEL is HV information, since neither really makes sense :-)
> 
> OK, should we do something like this?
> 
> #define PERF_EVENT_MISC_CPUMODE_MASK	(3 << 0)
> #define PERF_EVENT_MISC_CPUMODE_UNKNOWN	(0 << 0)
> #define PERF_EVENT_MISC_USER		(1 << 0)
> #define PERF_EVENT_MISC_KERNEL		(2 << 0)
> #define PERF_EVENT_MISC_HYPERVISOR	(3 << 0)

Yep, that reads nicer :-)



