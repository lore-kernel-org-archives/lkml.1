Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbXIZCGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbXIZCGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 22:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbXIZCGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 22:06:37 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:60895 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbXIZCGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 22:06:36 -0400
Date: Wed, 26 Sep 2007 07:33:07 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: vatsa@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, randy.dunlap@oracle.com
Subject: Re: [PATCH 1/3] Fix coding style
Message-ID: <20070926020307.GA14473@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20070925144443.GA17858@elte.hu> <20070925162502.GA3231@linux.vnet.ibm.com> <20070925162807.GB3231@linux.vnet.ibm.com> <200709252116.22541.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709252116.22541.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 09:16:20PM +0200, Ingo Oeser wrote:
> On Tuesday 25 September 2007, Srivatsa Vaddagiri wrote:
> > Index: current/kernel/sched_debug.c
> > ===================================================================
> > --- current.orig/kernel/sched_debug.c
> > +++ current/kernel/sched_debug.c
> > @@ -239,11 +239,7 @@ static int
> >  root_user_share_read_proc(char *page, char **start, off_t off, int count,
> >  				 int *eof, void *data)
> >  {
> > -	int len;
> > -
> > -	len = sprintf(page, "%d\n", init_task_grp_load);
> > -
> > -	return len;
> > +	return sprintf(page, "%d\n", init_task_grp_load);
> >  }
> >  
> >  static int
> > @@ -297,7 +293,7 @@ static int __init init_sched_debug_procf
> >  	pe->proc_fops = &sched_debug_fops;
> >  
> >  #ifdef CONFIG_FAIR_USER_SCHED
> > -	pe = create_proc_entry("root_user_share", 0644, NULL);
> > +	pe = create_proc_entry("root_user_cpu_share", 0644, NULL);
> >  	if (!pe)
> >  		return -ENOMEM;
> 
> What about moving this debug stuff under debugfs?
> Please consider using the functions in <linux/debugfs.h> .
> They compile into nothing, if DEBUGFS is not compiled in
> and have already useful functions for reading/writing integers
> and booleans.
> 
Hi Ingo,

This is not debug stuff. It is a tunable to give the root user more
weight with respect to the other users.

-- 
regards,
Dhaval
