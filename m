Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbYJQK7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbYJQK7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 06:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYJQK7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 06:59:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46541 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYJQK7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 06:59:06 -0400
Subject: Re: [PATCH]: Kill unused scheduler decl.
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20081016.211411.221093995.davem@davemloft.net>
References: <20081016.211411.221093995.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 12:59:22 +0200
Message-Id: <1224241162.28131.90.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 21:14 -0700, David Miller wrote:
> I noticed this while making investigations into the tbench
> regressions.  Please apply.
> 
> sched: Remove hrtick_resched() extern decl.
> 
> This function was removed by 31656519e132f6612584815f128c83976a9aaaef
> ("sched, x86: clean up hrtick implementation").
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks David!

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c226c7b..6eda6ad 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -287,7 +287,6 @@ extern void trap_init(void);
>  extern void account_process_tick(struct task_struct *task, int user);
>  extern void update_process_times(int user);
>  extern void scheduler_tick(void);
> -extern void hrtick_resched(void);
>  
>  extern void sched_show_task(struct task_struct *p);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

