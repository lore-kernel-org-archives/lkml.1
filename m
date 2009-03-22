Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZCVPH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZCVPH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 11:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbZCVPHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 11:07:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54506 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbZCVPHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 11:07:16 -0400
Date: Sun, 22 Mar 2009 16:06:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090322150657.GA17415@elte.hu>
References: <20090320195414.GA24129@elte.hu> <20090320204848.GA6044@nowhere> <alpine.DEB.2.00.0903201705380.13615@gandalf.stny.rr.com> <20090321100129.GC7201@elte.hu> <20090321165804.GA21366@elte.hu> <alpine.DEB.2.00.0903211323560.13615@gandalf.stny.rr.com> <20090321190746.GC7148@linux.vnet.ibm.com> <20090321200919.GA23992@elte.hu> <20090321210154.GD7148@linux.vnet.ibm.com> <20090322142409.GA3279@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090322142409.GA3279@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


one thing to note is:

 <EOI>  [<ffffffff802b78ad>] ? ftrace_likely_update+0x1f/0x27
 [<ffffffff8022cf88>] ? prepare_ftrace_return+0x3c/0x158
 [<ffffffff8022d070>] ? prepare_ftrace_return+0x124/0x158
 [<ffffffff8020c776>] ? ftrace_graph_caller+0x46/0x6d
 [<ffffffff802a2cd8>] ? jhash+0x9/0x1e6
 [<ffffffff802a30d9>] ? get_tracepoint+0x30/0x7f
 [<ffffffff8020c79d>] ? return_to_handler+0x0/0x73
 [<ffffffff8020db1c>] call_softirq+0x1c/0x28

the branch profiler should be disabled inside ftrace ...

	Ingo
