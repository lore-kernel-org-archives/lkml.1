Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZJ2JGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZJ2JGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 05:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbZJ2JGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 05:06:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbZJ2JGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 05:06:20 -0400
Date: Thu, 29 Oct 2009 10:05:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/2] RCU force_quiescent_state() fix and
	dyntick cleanup
Message-ID: <20091029090537.GB22963@elte.hu>
References: <20091028151419.GA7838@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028151419.GA7838@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> This patch series contains a cleanup and a fix:
> 
> o	Code cleanup from Lai Jiangshan that makes the calls to
> 	rcu_irq_enter() and rcu_irq_exit() more obviously correct.
> 	The previous code worked because rcu_irq_exit() is always
> 	an empty function if !NO_HZ.

Can go via tip:core/rcu, agreed?

> 
> o	Fix a low-probability race in the TREE_RCU infrastructure
> 	that can be triggered by extremely long grace periods.

Should go via tip:core/urgent as it's a fix for .32, agreed?

	Ingo
