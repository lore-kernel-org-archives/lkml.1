Return-Path: <linux-kernel-owner+w=401wt.eu-S2992456AbXDELMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992456AbXDELMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 07:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992481AbXDELMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 07:12:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:52563 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S2992456AbXDELMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 07:12:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18oAfc8iDUoSU0qjVk0fLSvZ8kHp+8tWlLQxSJ6oE
	4dlJ42WaZEB5gu
Subject: Re: [PATCH] sched: staircase deadline misc fixes
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <20070405110911.GA14803@elte.hu>
References: <200703290237.38777.kernel@kolivas.org>
	 <200703290944.45888.kernel@kolivas.org>
	 <1175147455.6430.91.camel@Homer.simpson.net>
	 <200704031237.21946.kernel@kolivas.org>
	 <1175578270.6342.12.camel@Homer.simpson.net>
	 <20070403060109.GA6708@elte.hu>
	 <1175770950.6609.16.camel@Homer.simpson.net>
	 <20070405110911.GA14803@elte.hu>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 13:12:35 +0200
Message-Id: <1175771555.6609.17.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 13:09 +0200, Ingo Molnar wrote:
> find a whitespace fix below.
> 
> 	Ingo
> 
> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -1034,7 +1034,7 @@ static int recalc_task_prio(struct task_
>  	/*
>  	 * Migration timestamp adjustment may induce negative time.
>  	 * Ignore unquantifiable values as well as SCHED_BATCH tasks.
> -	 */ 
> +	 */
>  	if (now < p->timestamp || batch_task(p))
>  		sleep_time = 0;
>  

Thanks.

(dang, i need to find that fifty "make it red" thingie for vi again)

	-Mike

