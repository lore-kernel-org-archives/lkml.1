Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbYHOP4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbYHOP4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760542AbYHOPzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:55:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45606 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760501AbYHOPzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:55:43 -0400
Date: Fri, 15 Aug 2008 17:55:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] rcu: trace fix possible mem-leak
Message-ID: <20080815155514.GH27955@elte.hu>
References: <20080730182053.872043059@goodmis.org> <20080730182239.523848312@goodmis.org> <20080801211128.GF14851@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801211128.GF14851@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Wed, Jul 30, 2008 at 02:20:55PM -0400, Steven Rostedt wrote:
> > In the initialization of the RCU trace module, if
> > rcupreempt_debugfs_init() fails, we never free the the trace buffer.
> > 
> > This patch frees the trace buffer in case the debugfs fails.
> 
> Looks good as well!
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

applied to tip/core/rcu - thanks.

	Ingo
