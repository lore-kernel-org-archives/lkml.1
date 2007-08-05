Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbXHEG5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbXHEG5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 02:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbXHEG5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 02:57:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56244 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbXHEG5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 02:57:11 -0400
Date: Sun, 5 Aug 2007 08:56:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [BUG RT] WARNING: at kernel/sched.c:5071 2.6.23-rc1-rt7
Message-ID: <20070805065646.GA515@elte.hu>
References: <1186290816.636.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186290816.636.14.camel@localhost.localdomain>
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

> Ingo,
> 
> The below ifndef, shouldn't that be ifndef CONFIG_PREEMPT_SOFTIRQS ? I 
> hit that warning while I was running !PREEMPT_RT but with both hard 
> and softiqs as threads.

yeah, indeed - fixed.

> P.S. I really found out that the system becomes VERY non-responsive 
> when you run with both hard and softirqs as threads, but with 
> PREEMPT_NONE ;-)

hm. That's not supposed to happen. Could there be some wakeup or softirq 
processing problem?

	Ingo
