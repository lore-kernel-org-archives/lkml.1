Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbZKJWi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbZKJWi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758306AbZKJWi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:38:27 -0500
Received: from mail.perches.com ([173.55.12.10]:1316 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757305AbZKJWi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:38:26 -0500
Subject: Re: [tip:core/rcu] rcu: Remove inline from forward-referenced
 functions
From: Joe Perches <joe@perches.com>
To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-dbe01350fa8ce0c11948ab7d6be71a4d901be151@git.kernel.org>
References: <12578890422402-git-send-email->
	 <tip-dbe01350fa8ce0c11948ab7d6be71a4d901be151@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 14:38:30 -0800
Message-ID: <1257892710.25443.9.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 22:27 +0000, tip-bot for Paul E. McKenney wrote:
> rcu: Remove inline from forward-referenced functions
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index ef2a58c..c03edf7 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -33,7 +33,7 @@ DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
>  /*
>   * Tell them what RCU they are running.
>   */
> -static inline void rcu_bootup_announce(void)
> +static void rcu_bootup_announce(void)
>  {
>  	printk(KERN_INFO
>  	       "Experimental preemptable hierarchical RCU implementation.\n");
> @@ -481,7 +481,7 @@ void exit_rcu(void)
>  /*
>   * Tell them what RCU they are running.
>   */
> -static inline void rcu_bootup_announce(void)
> +static void rcu_bootup_announce(void)
>  {
>  	printk(KERN_INFO "Hierarchical RCU implementation.\n");
>  }

non-inline functions in .h files probably aren't a good idea.

