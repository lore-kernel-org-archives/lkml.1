Return-Path: <linux-kernel-owner+w=401wt.eu-S1761064AbYHAVMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064AbYHAVMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760808AbYHAVJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:09:42 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38973 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760794AbYHAVJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:09:40 -0400
Date: Fri, 1 Aug 2008 14:09:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PREEMPT_RCU: remove unused rcu_tasklet
Message-ID: <20080801210939.GH14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080710120227.GA32491@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710120227.GA32491@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 04:02:27PM +0400, Alexey Dobriyan wrote:

Good catch, but Lai Jiangshan <laijs@cn.fujitsu.com> beat you to it.

Commit 906d882cacecd37ad2fdd03ed2a9b232bcb9507e in Ingo's linux-2.6-tip
tree.

							Thanx, Paul

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  kernel/rcupreempt.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- a/kernel/rcupreempt.c
> +++ b/kernel/rcupreempt.c
> @@ -82,7 +82,6 @@ struct rcu_data {
>  	spinlock_t	lock;		/* Protect rcu_data fields. */
>  	long		completed;	/* Number of last completed batch. */
>  	int		waitlistcount;
> -	struct tasklet_struct rcu_tasklet;
>  	struct rcu_head *nextlist;
>  	struct rcu_head **nexttail;
>  	struct rcu_head *waitlist[GP_STAGES];
> 
