Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbZILHqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbZILHqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZILHqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:46:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54016 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbZILHqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:46:19 -0400
Date: Sat, 12 Sep 2009 09:46:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josht@linux.vnet.ibm.com,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org
Subject: Re: [PATCH tip/core/rcu 0/3] increase rcutorture intensity and fix
	a couple resulting bugs
Message-ID: <20090912074600.GB25519@elte.hu>
References: <20090908225349.GA19524@linux.vnet.ibm.com> <21629.1252518239@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21629.1252518239@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Tue, 08 Sep 2009 15:53:49 PDT, "Paul E. McKenney" said:
> > This patch series increases the intensity of rcutorture testing for
> > TREE_PREEMPT_RCU and provides fixes for a couple resulting bugs.
> 
> Minor bisection nit - should patch 1/3 be renumbered to 3/3, so 
> the two bugfix patches go in before the patch that makes the 
> unpatched bugs visible? Otherwise if a bisect waypoint happens to 
> land on 1/3, oddness can happen...

Makes perfect sense - i've queued them up like that.

Thanks,

	Ingo
