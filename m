Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbZCMFlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbZCMFlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZCMFlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:41:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:49548 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZCMFlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:41:31 -0400
Subject: Re: [PATCH 4/4] softirq: no need to have SOFTIRQ in softirq name
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090313050521.766183674@goodmis.org>
References: <20090313050446.277065036@goodmis.org>
	 <20090313050521.766183674@goodmis.org>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 11:10:11 +0530
Message-Id: <1236922811.2553.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 01:04 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0004-softirq-no-need-to-have-SOFTIRQ-in-softirq-name.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: clean up
> 
> It is redundant to have 'SOFTIRQ' in the softirq names.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/softirq.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index a5e8123..65ff3e3 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -55,9 +55,8 @@ static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp
>  static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
>  
>  char *softirq_to_name[NR_SOFTIRQS] = {
> -	"HI_SOFTIRQ", "TIMER_SOFTIRQ", "NET_TX_SOFTIRQ", "NET_RX_SOFTIRQ",
> -	"BLOCK_SOFTIRQ", "TASKLET_SOFTIRQ", "SCHED_SOFTIRQ", "HRTIMER_SOFTIRQ",
> -	"RCU_SOFTIRQ"
> +	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK",
> +	"TASKLET", "SCHED", "HRTIMER",	"RCU"
>  };
>  

This will look more better:

+	"HI",		"TIMER",	"NET_TX",
+	"NET_RX",	"BLOCK",	"TASKLET",
+	"SCHED",	"HRTIMER",	"RCU"

--
JSR

