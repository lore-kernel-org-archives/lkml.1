Return-Path: <linux-kernel-owner+w=401wt.eu-S1761615AbXHHWGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615AbXHHWGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbXHHWGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:06:17 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54202 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbXHHWGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:06:16 -0400
Date: Wed, 8 Aug 2007 15:06:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] RCU: Remove prototype for nonexistent function synchronize_idle()
Message-ID: <20070808220614.GC8909@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1186609973.2699.57.camel@josh-work.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186609973.2699.57.camel@josh-work.beaverton.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 02:52:53PM -0700, Josh Triplett wrote:
> synchronize_idle() sounds like an interesting function, but we don't
> actually have it, so don't prototype it.  Introduced in commit
> 9b06e818985d139fd9e82c28297f7744e1b484e1, in 2005.

My bad.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Josh Triplett <josh@kernel.org>
> ---
>  include/linux/rcupdate.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index c6b7485..fe17d7d 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -281,7 +281,6 @@ extern void FASTCALL(call_rcu(struct rcu_head *head,
>  extern void FASTCALL(call_rcu_bh(struct rcu_head *head,
>  				void (*func)(struct rcu_head *head)));
>  extern void synchronize_rcu(void);
> -void synchronize_idle(void);
>  extern void rcu_barrier(void);
> 
>  #endif /* __KERNEL__ */
> -- 
> 1.5.2.1
> 
> 
