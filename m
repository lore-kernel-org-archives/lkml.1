Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbXGPUzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbXGPUzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXGPUz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:55:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39393 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbXGPUz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:55:27 -0400
Date: Mon, 16 Jul 2007 22:53:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       Jonathan Corbet <corbet@lwn.net>,
       Arjan van de Ven <arjan@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH 1/8] Convert the RCU tasklet into a softirq
Message-ID: <20070716205323.GA15220@elte.hu>
References: <20070627193633.025544061@goodmis.org> <20070627194327.241131609@goodmis.org> <20070716201251.GB12458@linux.vnet.ibm.com> <alpine.LFD.0.999.0707161322440.20061@woody.linux-foundation.org> <Pine.LNX.4.58.0707161638460.18244@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0707161638460.18244@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> But to answer your question.  No, I didn't take any actual 
> measurements. The changes just seemed obvious to me (and others).

btw., does anyone know about some reliable way to stress and measure RCU 
completion performance, via some real userspace app? I think there used 
to be an open-tons-of-files thing that unearthed the 
RCU-completion-single-threadness bottleneck a year or two ago? Anyone 
got a link to it (or to some other performance tool for RCU)?

	Ingo
