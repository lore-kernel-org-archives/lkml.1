Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZCMES5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZCMES5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbZCMESr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:18:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950AbZCMESr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:18:47 -0400
Date: Thu, 12 Mar 2009 21:12:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 12/16] tracing: tracepoints for softirq entry/exit - add
 softirq-to-name array
Message-Id: <20090312211258.6ed5b6d0.akpm@linux-foundation.org>
In-Reply-To: <20090313023827.379165780@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
	<20090313023827.379165780@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 22:37:16 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> +char *softirq_to_name[NR_SOFTIRQS] = {
> +	"HI_SOFTIRQ", "TIMER_SOFTIRQ", "NET_TX_SOFTIRQ", "NET_RX_SOFTIRQ",
> +	"BLOCK_SOFTIRQ", "TASKLET_SOFTIRQ", "SCHED_SOFTIRQ", "HRTIMER_SOFTIRQ",
> +	"RCU_SOFTIRQ"
> +};

	"HI", "TIMER", "NET_TX", "NET_RX",
	"BLOCK", "TASKLET", "SCHED", "HRTIMER",
	"RCU"

would suffice.
