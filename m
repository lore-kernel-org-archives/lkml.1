Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZLCIyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZLCIyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbZLCIyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:54:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50914 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbZLCIyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:54:03 -0500
Message-ID: <4B177C79.1040407@cn.fujitsu.com>
Date: Thu, 03 Dec 2009 16:53:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/4] rcu: preemptible expedited grace periods
 and cleanups
References: <20091202200955.GA12950@linux.vnet.ibm.com>
In-Reply-To: <20091202200955.GA12950@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> This patchset includes some cleanups, improved diagnostics, and an
> implementation of expedited preemptible RCU grace periods that is
> actually expedited:
> 
> 1.	Rename the "quiet" functions.  The name rcu_quiet_cpu() was
> 	clear enough, but now that we have four flavors of quietness
> 	with more on the way, we need more meaningful names.
> 
> 2.	Enable a fourth level of the rcu_node hierarchy.  No, we really
> 	don't need the ability to run on million-CPU SMP systems at the
> 	moment, but the additional level allows more vigorous
> 	stress-testing on 16-CPU systems.
> 
> 3.	Add an implementation of synchronize_rcu_expedited() that
> 	actually expedites preemptible-RCU grace periods.
> 
> 4.	Make RCU_CPU_STALL_DETECTOR be on by default.  If this works
> 	well, the #ifdefs will eventually be removed to reduce testing
> 	load.
> 
> This patchset is intended for 2.6.34, but has passed sufficient testing
> that it could safely be included in 2.6.33, if desired.
> 

Ack for the whole patchset except [PATCH 3/4]

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
