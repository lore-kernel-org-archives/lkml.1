Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbXIYTON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbXIYTON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 15:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbXIYTN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 15:13:59 -0400
Received: from smtprelay12.ispgateway.de ([80.67.29.29]:36229 "EHLO
	smtprelay12.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbXIYTN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 15:13:58 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [PATCH 1/3] Fix coding style
Date: Tue, 25 Sep 2007 21:16:20 +0200
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, randy.dunlap@oracle.com
References: <20070925144443.GA17858@elte.hu> <20070925162502.GA3231@linux.vnet.ibm.com> <20070925162807.GB3231@linux.vnet.ibm.com>
In-Reply-To: <20070925162807.GB3231@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709252116.22541.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 September 2007, Srivatsa Vaddagiri wrote:
> Index: current/kernel/sched_debug.c
> ===================================================================
> --- current.orig/kernel/sched_debug.c
> +++ current/kernel/sched_debug.c
> @@ -239,11 +239,7 @@ static int
>  root_user_share_read_proc(char *page, char **start, off_t off, int count,
>  				 int *eof, void *data)
>  {
> -	int len;
> -
> -	len = sprintf(page, "%d\n", init_task_grp_load);
> -
> -	return len;
> +	return sprintf(page, "%d\n", init_task_grp_load);
>  }
>  
>  static int
> @@ -297,7 +293,7 @@ static int __init init_sched_debug_procf
>  	pe->proc_fops = &sched_debug_fops;
>  
>  #ifdef CONFIG_FAIR_USER_SCHED
> -	pe = create_proc_entry("root_user_share", 0644, NULL);
> +	pe = create_proc_entry("root_user_cpu_share", 0644, NULL);
>  	if (!pe)
>  		return -ENOMEM;

What about moving this debug stuff under debugfs?
Please consider using the functions in <linux/debugfs.h> .
They compile into nothing, if DEBUGFS is not compiled in
and have already useful functions for reading/writing integers
and booleans.

Best Regards

Ingo Oeser
