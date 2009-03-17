Return-Path: <linux-kernel-owner+w=401wt.eu-S1763458AbZCQNJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763458AbZCQNJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 09:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZCQNJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:09:24 -0400
Received: from www.tglx.de ([62.245.132.106]:56145 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbZCQNJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:09:23 -0400
Date: Tue, 17 Mar 2009 14:07:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v3 PATCH 2/4] timers: Identifying the existing pinned timers
In-Reply-To: <20090316111337.GC4686@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.0903171401190.29264@localhost.localdomain>
References: <20090316111045.GA4686@linux.vnet.ibm.com> <20090316111337.GC4686@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, Arun R Bharadwaj wrote:
> * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-03-16 16:40:45]:
> 
> The following pinned hrtimers have been identified and marked:
> 1)sched_rt_period_timer
> 2)tick_sched_timer
> 3)stack_trace_timer_fn

How did you verify that these are the only timers which need to be
pinned ?

Can we be sure that there is no code which relies on the current
behaviour to keep functionality tied together ? Networking and block
layer comes to mind.

Thanks,

	tglx
