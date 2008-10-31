Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbYJaJ3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbYJaJ3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYJaJ3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:29:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55107 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbYJaJ3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:29:31 -0400
Date: Fri, 31 Oct 2008 10:28:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH] ftrace: nmi safe code clean ups
Message-ID: <20081031092856.GB30317@elte.hu>
References: <20081030200831.467420488@goodmis.org> <20081030201127.820600693@goodmis.org> <20081030133228.824e3f69.akpm@linux-foundation.org> <alpine.DEB.1.10.0810301645100.21031@gandalf.stny.rr.com> <20081030141048.904c82e1.akpm@linux-foundation.org> <alpine.DEB.1.10.0810310002320.28140@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810310002320.28140@gandalf.stny.rr.com>
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

> 
> This patch cleans up the NMI safe code for dynamic ftrace as suggested
> by Andrew Morton.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/arm/include/asm/ftrace.h     |    4 ++--
>  arch/powerpc/include/asm/ftrace.h |    4 ++--
>  arch/sh/include/asm/ftrace.h      |    4 ++--
>  arch/sparc/include/asm/ftrace.h   |    4 ++--
>  arch/x86/include/asm/ftrace.h     |   10 +++++-----
>  arch/x86/kernel/ftrace.c          |   16 ++++++++--------
>  include/linux/ftrace.h            |    3 +++
>  kernel/trace/trace.c              |    9 ++++-----
>  8 files changed, 28 insertions(+), 26 deletions(-)

applied to tip/tracing/nmisafe, thanks Steve!

	Ingo
