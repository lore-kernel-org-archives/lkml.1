Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbXHEP1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbXHEP1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 11:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbXHEP0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 11:26:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35691 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbXHEP0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 11:26:54 -0400
Date: Sun, 5 Aug 2007 17:26:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG  RT] - rcupreempt.c:133 on 2.6.23-rc1-rt7
Message-ID: <20070805152627.GA14029@elte.hu>
References: <1186289484.636.5.camel@localhost.localdomain> <1186290332.636.8.camel@localhost.localdomain> <20070805065948.GB515@elte.hu> <Pine.LNX.4.58.0708051019560.8421@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0708051019560.8421@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> The code on line 133 is:
> 
> 	WARN_ON_ONCE(current->rcu_read_lock_nesting > NR_CPUS);
> 
> I have NR_CPUS set to 2 since the box I'm running this on only has 2 
> cpus and I see no reason to waste more data structures.
> 
> Is rcu read lock nesting deeper than 2?

ah, silly me - that should indeed be something fixed like 128.

	Ingo
