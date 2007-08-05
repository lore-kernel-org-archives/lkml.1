Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbXHEHAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbXHEHAR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 03:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXHEHAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 03:00:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51979 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbXHEHAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 03:00:04 -0400
Date: Sun, 5 Aug 2007 08:59:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG  RT] - rcupreempt.c:133 on 2.6.23-rc1-rt7
Message-ID: <20070805065948.GB515@elte.hu>
References: <1186289484.636.5.camel@localhost.localdomain> <1186290332.636.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186290332.636.8.camel@localhost.localdomain>
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

> > I don't have time to look further now, and it's something that isn't 
> > easily reproducible (Well, it happened once out of two boots). If 
> > you need me to look further, or need a config or dmesg (I have 
> > both), then just give me a holler.
> 
> Silly me. FYI, I was running with !PREEMPT_RT, but with Hard and 
> Softirqs as threads.  Must have copied the wrong config over :-/

it's still not supposed to happen ... rcu read lock nesting that deep?

	Ingo
