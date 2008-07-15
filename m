Return-Path: <linux-kernel-owner+w=401wt.eu-S1762832AbYGOTwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762832AbYGOTwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbYGOTvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:51:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbYGOTvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:51:52 -0400
Subject: Re: [patch 01/15] Kernel Tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20080715190211.GA6664@Krystal>
References: <20080709145929.352201601@polymtl.ca>
	 <20080709150043.693920317@polymtl.ca> <1216108237.12595.122.camel@twins>
	 <20080715132543.GB20037@Krystal> <1216130593.12595.189.camel@twins>
	 <20080715190211.GA6664@Krystal>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 21:52:00 +0200
Message-Id: <1216151520.12595.236.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 15:02 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:

> > Would it make sense to add:
> > 
> > rcu_read_sched_lock()
> > rcu_read_sched_unlock()
> > 
> > to match:
> > 
> > call_rcu_sched()
> > rcu_barrier_sched()
> > synchronize_sched()
> > 
> > ?
> > 
> 
> Actually I think it's better to call them
> rcu_read_lock_sched() and rcu_read_unlock_sched() to match the _bh()
> equivalent already in rcupdate.h.

Sure,.

