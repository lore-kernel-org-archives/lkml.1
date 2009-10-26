Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZJZIe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZJZIe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 04:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZJZIe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 04:34:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51456 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755329AbZJZIe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 04:34:56 -0400
Message-ID: <4AE55F02.3030803@cn.fujitsu.com>
Date: Mon, 26 Oct 2009 16:34:10 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, mingo@elte.hu
CC: linux-kernel@vger.kernel.org, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
       mtosatti@redhat.com
Subject: Re: [PATCH tip/core/rcu 6/6] rcu: Simplify creating of lockdep class
 for root rcu_node
References: <20091026020253.GA11350@linux.vnet.ibm.com> <12565226351797-git-send-email->
In-Reply-To: <12565226351797-git-send-email->
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 599161f..e091b30 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -296,6 +296,8 @@ DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
>  
>  #else /* #ifdef RCU_TREE_NONCORE */
>  
> +static struct lock_class_key rcu_root_class;
> +

I think this line needs to be moved into rcutree.c.

>  /* Forward declarations for rcutree_plugin.h */
>  static inline void rcu_bootup_announce(void);
>  long rcu_batches_completed(void);

For all 6 patches:
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
