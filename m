Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbYESM3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbYESM3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYESM3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:29:38 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45228 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbYESM3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:29:37 -0400
Date: Mon, 19 May 2008 05:29:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: remove used member(struct rcu_data::rcu_tasklet)
Message-ID: <20080519122919.GA7515@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48313277.1030105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48313277.1030105@cn.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 03:55:35PM +0800, Lai Jiangshan wrote:
> 	Since softirq works for rcu reclaimer, rcu_tasklet is unused now.

good catch!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
> index e1cdf19..4270de6 100644
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
> 
