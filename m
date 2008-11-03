Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYKCKEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYKCKEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 05:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYKCKEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 05:04:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50661 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbYKCKEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 05:04:36 -0500
Date: Mon, 3 Nov 2008 11:04:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH] ftrace: fix hardirq header for non ftrace archs
Message-ID: <20081103100401.GD13671@elte.hu>
References: <20081030200831.467420488@goodmis.org> <20081030201127.820600693@goodmis.org> <20081030133228.824e3f69.akpm@linux-foundation.org> <alpine.DEB.1.10.0810301645100.21031@gandalf.stny.rr.com> <20081030141048.904c82e1.akpm@linux-foundation.org> <alpine.DEB.1.10.0810310002320.28140@gandalf.stny.rr.com> <alpine.DEB.1.10.0810310016230.28140@gandalf.stny.rr.com> <20081031093030.GC30317@elte.hu> <alpine.DEB.1.10.0810310934010.13290@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810310934010.13290@gandalf.stny.rr.com>
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
> Not all archs implement ftrace, and therefore do not have an asm/ftrace.h.
> This patch corrects the problem.
> 
> The ftrace_nmi_enter/exit now must be defined for all archs that implement
> dynamic ftrace. Currently, only x86 does.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/arm/include/asm/ftrace.h     |    5 -----
>  arch/powerpc/include/asm/ftrace.h |    5 -----
>  arch/sh/include/asm/ftrace.h      |    5 -----
>  arch/sparc/include/asm/ftrace.h   |    5 -----
>  arch/x86/include/asm/ftrace.h     |   16 ----------------
>  include/linux/ftrace.h            |    5 ++++-
>  include/linux/hardirq.h           |    2 +-
>  7 files changed, 5 insertions(+), 38 deletions(-)

applied to tip/tracing/nmisafe, thanks Steve!

	Ingo
