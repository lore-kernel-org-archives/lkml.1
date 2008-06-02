Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYFBKmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYFBKmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYFBKmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:42:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56316 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbYFBKmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:42:01 -0400
Date: Mon, 2 Jun 2008 12:41:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Abhishek Sagar <sagar.abhishek@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: distinguish kretprobe'd functions in trace logs
Message-ID: <20080602104150.GB898@elte.hu>
References: <483C53EE.2060602@gmail.com> <Pine.LNX.4.58.0805271442090.396@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0805271442090.396@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 28 May 2008, Abhishek Sagar wrote:
> >
> > But if irq_enter() has a kretprobe installed on it, the return value stored on the stack at each invocation is modified to divert the return to a kprobe trampoline function called kretprobe_trampoline(). So with this the trace would (currently) look like:
> >
> > <idle>-0     [00] 4154504455.781616: irq_enter <- kretprobe_trampoline
> >
> > Now this is quite misleading to the end user, as it suggests something that didn't actually happen. So just to avoid such misinterpretations, the inlined patch aims to output such a log as:
> >
> > <idle>-0     [00] 4154504455.781616: irq_enter <- [unknown/kretprobe'd]
> >
> >
> > Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
> 
> Thanks Abhishek,
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>

applied to tip/tracing/ftrace, thanks.

	Ingo
