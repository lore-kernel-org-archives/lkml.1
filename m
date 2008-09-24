Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYIXHzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYIXHzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 03:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYIXHzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 03:55:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40277 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbYIXHzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 03:55:39 -0400
Date: Wed, 24 Sep 2008 09:55:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86: suppress trivial sparse signedness warnings
Message-ID: <20080924075529.GF3655@elte.hu>
References: <1222207546.16003.21.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222207546.16003.21.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Could just as easily change the three casts to cast to the correct
> type...this patch changes the type of ftrace_nop instead.
> 
> Supresses sparse warnings:
> arch/x86/kernel/ftrace.c:157:14: warning: incorrect type in assignment (different signedness)
> arch/x86/kernel/ftrace.c:157:14:    expected long *static [toplevel] ftrace_nop
> arch/x86/kernel/ftrace.c:157:14:    got unsigned long *<noident>
> arch/x86/kernel/ftrace.c:161:14: warning: incorrect type in assignment (different signedness)
> arch/x86/kernel/ftrace.c:161:14:    expected long *static [toplevel] ftrace_nop
> arch/x86/kernel/ftrace.c:161:14:    got unsigned long *<noident>
> arch/x86/kernel/ftrace.c:165:14: warning: incorrect type in assignment (different signedness)
> arch/x86/kernel/ftrace.c:165:14:    expected long *static [toplevel] ftrace_nop
> arch/x86/kernel/ftrace.c:165:14:    got unsigned long *<noident>
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

applied to tip/tracing/ftrace, thanks Harvey!

	Ingo
