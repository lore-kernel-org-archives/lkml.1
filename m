Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbYJ0OEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbYJ0OEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 10:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYJ0OEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 10:04:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36458 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbYJ0OEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 10:04:22 -0400
Date: Mon, 27 Oct 2008 15:03:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] ftrace: ftrace dump on oops control
Message-ID: <20081027140358.GC5704@elte.hu>
References: <alpine.DEB.1.10.0810231514140.8986@gandalf.stny.rr.com> <20081023155440.3b90e129.randy.dunlap@oracle.com> <alpine.DEB.1.10.0810231924400.4182@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810231924400.4182@gandalf.stny.rr.com>
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

> [
>   Changes since v1:
> 
>    Replaced /** with /* as Randy explained that kernel-doc does
>     not yet handle variables.
> ]
> 
> Currently, ftrace is set up to dump its contents to the console if the
> kernel panics or oops. This can be annoying if you have trace data in
> the buffers and you experience an oops, but the trace data is old or
> static.
> 
> Usually when you want ftrace to dump its contents is when you are debugging
> your system and you have set up ftrace to trace the events leading to
> an oops.
> 
> This patch adds a control variable called "ftrace_dump_on_oops" that will
> enable the ftrace dump to console on oops. This variable is default off
> but a developer can enable it either through the kernel command line
> by adding "ftrace_dump_on_oops" or at run time by setting (or disabling)
> /proc/sys/kernel/ftrace_dump_on_oops.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/linux/ftrace.h |    2 ++
>  kernel/sysctl.c        |   10 ++++++++++
>  kernel/trace/trace.c   |   29 ++++++++++++++++++++++++++---
>  3 files changed, 38 insertions(+), 3 deletions(-)

applied to tip/tracing/ftrace, thanks Steve!

	Ingo
