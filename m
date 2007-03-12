Return-Path: <linux-kernel-owner+w=401wt.eu-S1030619AbXCLQqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030619AbXCLQqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030626AbXCLQqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:46:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53991 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030619AbXCLQqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:46:50 -0400
Date: Mon, 12 Mar 2007 17:46:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -rt] fix preempt count underflow in user_trace_stop
Message-ID: <20070312164600.GA25139@elte.hu>
References: <45F579D9.7090307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F579D9.7090307@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Schmidt <mschmidt@redhat.com> wrote:

> When playing with trace_user_trigger_irq in order to trace 
> IRQ->userspace latencies, I encountered a bug in the latency tracer. 
> If I have wakeup_timing enabled and attempt to stop the trace in my 
> userspace program, the system crashes. This is caused by an unbalanced 
> preempt_enable() which underflows the preempt count.

good catch! I've applied it,

	Ingo
