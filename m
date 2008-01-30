Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbYA3XZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbYA3XZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 18:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbYA3XZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 18:25:34 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:56644 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbYA3XZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 18:25:33 -0500
Date: Wed, 30 Jan 2008 15:25:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Patrick McHardy <kaber@trash.net>
Cc: dipankar@in.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RCU]: preemptible RCU: sparse annotations
Message-ID: <20080130232528.GA18206@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <47A0D3AA.1010504@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A0D3AA.1010504@trash.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 08:44:42PM +0100, Patrick McHardy wrote:
> Annotate rcu_read_lock/rcu_read_unlock for sparse.
> 
> 

> [RCU]: preemptible RCU: sparse annotations

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
> index ece8eb3..60c2a03 100644
> --- a/include/linux/rcupreempt.h
> +++ b/include/linux/rcupreempt.h
> @@ -46,8 +46,8 @@
>  #define rcu_bh_qsctr_inc(cpu)
>  #define call_rcu_bh(head, rcu) call_rcu(head, rcu)
> 
> -extern void __rcu_read_lock(void);
> -extern void __rcu_read_unlock(void);
> +extern void __rcu_read_lock(void)	__acquires(RCU);
> +extern void __rcu_read_unlock(void)	__releases(RCU);
>  extern int rcu_pending(int cpu);
>  extern int rcu_needs_cpu(int cpu);
> 

