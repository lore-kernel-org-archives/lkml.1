Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbZJZGus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbZJZGus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 02:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbZJZGur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 02:50:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50771 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbZJZGur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 02:50:47 -0400
Date: Mon, 26 Oct 2009 07:50:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
       mtosatti@redhat.com
Subject: Re: [PATCH tip/core/rcu 6/6] rcu: Simplify creating of lockdep
	class for root rcu_node
Message-ID: <20091026065007.GA24908@elte.hu>
References: <20091026020253.GA11350@linux.vnet.ibm.com> <12565226351797-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12565226351797-git-send-email->
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Use lockdep_set_class() to simplify the code and to avoid any additional
> overhead in the !LOCKDEP case.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This signoff order is wrong - first signoff line must be the author of 
the patch. (which is a pretty general rule with only rare exceptions) 

This patch was from Peter originally, right? In such cases please add:

  From: Peter Zijlstra <peterz@infradead.org>

To the head of the patch. Or, if Peter acked it, add:

  Acked-by: Peter Zijlstra <peterz@infradead.org>

SOB lines are strictly only added by people who send patches to you - 
i.e. it records the patch handling pathway.

Thanks,

	Ingo
