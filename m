Return-Path: <linux-kernel-owner+w=401wt.eu-S965592AbXA3PTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965592AbXA3PTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965598AbXA3PTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:19:37 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44641 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965592AbXA3PTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:19:36 -0500
Date: Tue, 30 Jan 2007 20:47:54 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: Tomasz Kvarsin <kvarsin@gmail.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, paulmck@in.ibm.com
Subject: Re: [-mm patch] rcu_trace build fix (was Re: 2.6.20-rc6-mm2 build failure)
Message-ID: <20070130151754.GA2197@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <5157576d0701291231j17c5c73we8aa4419d22c01b9@mail.gmail.com> <20070129230552.GB10257@slug>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129230552.GB10257@slug>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 11:05:52PM +0000, Frederik Deweerdt wrote:
> On Mon, Jan 29, 2007 at 11:31:08PM +0300, Tomasz Kvarsin wrote:
> > I try to compile and got:
> Frederik
> 
> Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
> 
> diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
> index f8962a7..9b7d66b 100644
> --- a/kernel/rcupreempt.c
> +++ b/kernel/rcupreempt.c
> @@ -619,7 +619,7 @@ void synchronize_kernel(void)
>  	synchronize_rcu();
>  }
> 
> -#ifdef RCU_TRACE
> +#ifdef CONFIG_RCU_TRACE
>  int *rcupreempt_flipctr(int cpu)
>  {
>  	return &per_cpu(rcu_flipctr, cpu)[0];
> @@ -649,7 +649,7 @@ EXPORT_SYMBOL_GPL(rcupreempt_data_completed);
>  EXPORT_SYMBOL_GPL(rcupreempt_flip_flag);
>  EXPORT_SYMBOL_GPL(rcupreempt_mb_flag);
>  EXPORT_SYMBOL_GPL(rcupreempt_try_flip_state_name);
> -#endif /* #ifdef RCU_TRACE */
> +#endif /* #ifdef CONFIG_RCU_TRACE */
> 
>  EXPORT_SYMBOL_GPL(call_rcu);
>  EXPORT_SYMBOL_GPL(rcu_batches_completed);

Looks good. Sorry about missing this and the late response. I am
online only periodically while I am out of town (until 10th Feb).

Acked-by : Dipankar Sarma <dipankar@in.ibm.com>

Thanks
Dipankar
