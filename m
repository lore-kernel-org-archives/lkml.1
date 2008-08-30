Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbYH3JdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbYH3JdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 05:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbYH3JdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 05:33:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53880 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYH3JdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 05:33:10 -0400
Subject: Re: [PATCH, RFC, tip/core/rcu] v3 scalable classic RCU
	implementation
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <20080830004935.GA28548@linux.vnet.ibm.com>
References: <20080821234318.GA1754@linux.vnet.ibm.com>
	 <20080825000738.GA24339@linux.vnet.ibm.com>
	 <20080830004935.GA28548@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Sat, 30 Aug 2008 11:33:00 +0200
Message-Id: <1220088780.8426.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-29 at 17:49 -0700, Paul E. McKenney wrote:

> Some shortcomings:
> 
> o	Entering and leaving dynticks idle mode is a quiescent state,
> 	but the current patch doesn't take advantage of this (noted
> 	by Manfred).  It appears that it should be possible to make
> 	nmi_enter() and nmi_exit() provide an in_nmi(), which would make
> 	it possible for rcu_irq_enter() and rcu_irq_exit() to figure
> 	out whether it is safe to tell RCU about the quiescent state --
> 	and also greatly simplify the code.

Already done and available in the -tip tree, curtesy of Mathieu.


