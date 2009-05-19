Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZESXOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZESXOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 19:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZESXOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 19:14:24 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:39808 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbZESXOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 19:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BuInZnsFT7CTZnjm4DCLdBQ5t7uJpQ8rzM617KMyEpxmIOcx2Bvu4qo4DQbFhuvi8B
         tlNXEzvkbZsq4agQCqCneercloTDGPSC0/UES15oE9+VRre0Z3t8mcNcyblOVQ/czhd0
         r+cKBJjAedGMd8OYZrOaNyXeRrrLO7Zn5Er6E=
Date: Wed, 20 May 2009 01:14:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch 2/2] Fix the style issue seen in ksym tracer ftrace
	plugin
Message-ID: <20090519231418.GA6066@nowhere>
References: <20090519161720.374172804@prasadkr_t60p.in.ibm.com> <20090519162558.GC26009@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519162558.GC26009@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 09:55:58PM +0530, K.Prasad wrote:
> Fix the style issue seen in ksym tracer ftrace plugin
> 
> Move the extern 'process_new_ksym_entry' declaration from
> trace_selftest.c to trace.h file due to a reported style issue.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
>  kernel/trace/trace.h          |    1 +
>  kernel/trace/trace_selftest.c |    1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-tip.hbkpt/kernel/trace/trace.h
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/kernel/trace/trace.h
> +++ linux-2.6-tip.hbkpt/kernel/trace/trace.h
> @@ -213,6 +213,7 @@ struct syscall_trace_exit {
>  };
>  
>  #define KSYM_SELFTEST_ENTRY "ksym_selftest_dummy"
> +extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
>  
>  struct trace_ksym {
>  	struct trace_entry	ent;
> Index: linux-2.6-tip.hbkpt/kernel/trace/trace_selftest.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_selftest.c
> +++ linux-2.6-tip.hbkpt/kernel/trace/trace_selftest.c
> @@ -810,7 +810,6 @@ trace_selftest_startup_hw_branches(struc
>  #endif /* CONFIG_HW_BRANCH_TRACER */
>  
>  #ifdef CONFIG_KSYM_TRACER
> -extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
>  static int ksym_selftest_dummy;
>  
>  int
> 

