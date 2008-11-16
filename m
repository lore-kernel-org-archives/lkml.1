Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbYKPGk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbYKPGk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 01:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYKPGkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 01:40:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYKPGkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 01:40:14 -0500
Date: Sun, 16 Nov 2008 07:39:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 0/5] ftrace updates for tip, and ground work for other
	architectures
Message-ID: <20081116063949.GB32215@elte.hu>
References: <20081115214705.363808961@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081115214705.363808961@goodmis.org>
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

> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Steven Rostedt (5):
>       ftrace: replace raw_local_irq_save with local_irq_save
>       ftrace: pass module struct to arch dynamic ftrace functions
>       ftrace: allow NULL pointers in mcount_loc
>       ftrace: fix dyn ftrace filter
>       ftrace: make filtered functions effective on setting

I have pulled these:

 ee02a2e: ftrace: make filtered functions effective on setting
 982c350: ftrace: fix dyn ftrace filter
 20e5227: ftrace: allow NULL pointers in mcount_loc
 31e8890: ftrace: pass module struct to arch dynamic ftrace functions
 d51ad7a: ftrace: replace raw_local_irq_save with local_irq_save
 918c115: ftrace: do not process freed records
 b17e8a3: ftrace: disable ftrace on anomalies in trace start and stop
 f3c7ac4: ftrace: remove condition from ftrace_record_ip

thanks Steve,

	Ingo
