Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbXIYP5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbXIYP5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbXIYP52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:57:28 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44739 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670AbXIYP51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:57:27 -0400
Date: Tue, 25 Sep 2007 21:38:05 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925160805.GA26993@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070925144443.GA17858@elte.hu> <20070925160420.GQ26289@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925160420.GQ26289@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 09:34:20PM +0530, Srivatsa Vaddagiri wrote:
> On Tue, Sep 25, 2007 at 04:44:43PM +0200, Ingo Molnar wrote:
> > 
> > The latest sched-devel.git tree can be pulled from:
> >   
> >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
> > 
> 
> This is required for it to compile.
> 
> ---
>  include/linux/sched.h |    1 +
>  1 files changed, 1 insertion(+)
> 
> Index: current/include/linux/sched.h
> ===================================================================
> --- current.orig/include/linux/sched.h
> +++ current/include/linux/sched.h
> @@ -1404,6 +1404,7 @@ extern unsigned int sysctl_sched_wakeup_
>  extern unsigned int sysctl_sched_batch_wakeup_granularity;
>  extern unsigned int sysctl_sched_child_runs_first;
>  extern unsigned int sysctl_sched_features;
> +extern unsigned int sysctl_sched_nr_latency;
>  #endif
>  
>  extern unsigned int sysctl_sched_compat_yield;

and this:

---
 kernel/sched_debug.c |    1 -
 1 files changed, 1 deletion(-)

Index: current/kernel/sched_debug.c
===================================================================
--- current.orig/kernel/sched_debug.c
+++ current/kernel/sched_debug.c
@@ -210,7 +210,6 @@ static int sched_debug_show(struct seq_f
 #define PN(x) \
 	SEQ_printf(m, "  .%-40s: %Ld.%06ld\n", #x, SPLIT_NS(x))
 	PN(sysctl_sched_latency);
-	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
 	PN(sysctl_sched_batch_wakeup_granularity);
 	PN(sysctl_sched_child_runs_first);

-- 
Regards,
vatsa
