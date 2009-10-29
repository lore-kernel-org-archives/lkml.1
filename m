Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbZJ2OKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbZJ2OKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbZJ2OKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:10:22 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60696 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbZJ2OKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:10:21 -0400
Date: Thu, 29 Oct 2009 07:10:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/2] RCU force_quiescent_state() fix and
	dyntick cleanup
Message-ID: <20091029141018.GA6897@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091028151419.GA7838@linux.vnet.ibm.com> <20091029090537.GB22963@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029090537.GB22963@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 10:05:37AM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > This patch series contains a cleanup and a fix:
> > 
> > o	Code cleanup from Lai Jiangshan that makes the calls to
> > 	rcu_irq_enter() and rcu_irq_exit() more obviously correct.
> > 	The previous code worked because rcu_irq_exit() is always
> > 	an empty function if !NO_HZ.
> 
> Can go via tip:core/rcu, agreed?

Agreed.

> > o	Fix a low-probability race in the TREE_RCU infrastructure
> > 	that can be triggered by extremely long grace periods.
> 
> Should go via tip:core/urgent as it's a fix for .32, agreed?

Also agreed.

							Thanx, Paul
