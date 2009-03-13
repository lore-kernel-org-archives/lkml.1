Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbZCMEWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbZCMEWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZCMEWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:22:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58534 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZCMEWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:22:32 -0400
Date: Fri, 13 Mar 2009 00:22:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 12/16] tracing: tracepoints for softirq entry/exit - add
 softirq-to-name array
In-Reply-To: <20090312211258.6ed5b6d0.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0903130022190.18396@gandalf.stny.rr.com>
References: <20090313023704.971438367@goodmis.org> <20090313023827.379165780@goodmis.org> <20090312211258.6ed5b6d0.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Mar 2009, Andrew Morton wrote:

> On Thu, 12 Mar 2009 22:37:16 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +char *softirq_to_name[NR_SOFTIRQS] = {
> > +	"HI_SOFTIRQ", "TIMER_SOFTIRQ", "NET_TX_SOFTIRQ", "NET_RX_SOFTIRQ",
> > +	"BLOCK_SOFTIRQ", "TASKLET_SOFTIRQ", "SCHED_SOFTIRQ", "HRTIMER_SOFTIRQ",
> > +	"RCU_SOFTIRQ"
> > +};
> 
> 	"HI", "TIMER", "NET_TX", "NET_RX",
> 	"BLOCK", "TASKLET", "SCHED", "HRTIMER",
> 	"RCU"
> 
> would suffice.


OK, will update.

Thanks,

-- Steve

