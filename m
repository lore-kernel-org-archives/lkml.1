Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbYJWQlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbYJWQlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYJWQl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:41:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51230 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbYJWQl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:41:27 -0400
Date: Thu, 23 Oct 2008 18:40:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 08/13 v2] ftrace: do not trace init sections
Message-ID: <20081023164032.GA19070@elte.hu>
References: <20081022212721.167005680@goodmis.org> <20081022213552.440512191@goodmis.org> <49005CD0.2070807@siemens.com> <alpine.DEB.1.10.0810230732100.31839@gandalf.stny.rr.com> <49008A9B.8040905@siemens.com> <alpine.DEB.1.10.0810231202310.1765@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810231202310.1765@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > I don't know if this feature is already considered for / part of 
> > mainline, but oops backtraces based on mcount instrumentation used 
> > to be quite helpful for me to understand the wider context of 
> > several faults. The more you have to mask out of this picture, the 
> > harder it gets to match the trace to your model of the kernel 
> > activities. At least you have to know more in advance about the 
> > limitation of the tracer...
> 
> The ftrace buffer can be dumped out on oops. I'm not sure if it is 
> always on. If it is, I need to make it default off and add a command 
> line and sysctl to turn it on. Otherwise, we will have people 
> complaining about the extra output to the console on oops.

it dumps currently if a tracer is enabled. I saw it a couple of times 
already during crashes.

	Ingo
