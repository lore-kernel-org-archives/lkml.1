Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbZHYSTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbZHYSTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbZHYSTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:19:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59837 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbZHYSTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:19:48 -0400
Date: Tue, 25 Aug 2009 20:19:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH -tip 0/2] Temporary RCU fixes for notrace and hotplug
	CPU
Message-ID: <20090825181907.GC3277@elte.hu>
References: <20090824164112.GA13693@linux.vnet.ibm.com> <20090825065501.GA29162@elte.hu> <20090825154025.GD6616@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825154025.GD6616@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, Aug 25, 2009 at 08:55:01AM +0200, Ingo Molnar wrote:
> > 
> > FYI, -tip testing found a new build warning on SH caused by the RCU 
> > tree (i suspect this warning triggers on other architectures as 
> > well):
> > 
> > /home/mingo/tip/kernel/rcutree.c:88: warning: '__rcu_offline_cpu' 
> > declared 'static' but never defined
> 
> <red face>
> 
> > it's harmless, but since we are generally trying to fix all warnings 
> > and gravitate towards more and more -Werror subsystems, it would be 
> > nice to fix this.
> 
> Indeed, and I have updated my build-output-check script to alert 
> me to warning messages from my multiple-configuration test runs.  
> Please see below for patch.

btw., you can unset CONFIG_ALLOW_WARNINGS in -tip kernels to turn 
build warnings into build failures - and those are harder to miss.

	Ingo
