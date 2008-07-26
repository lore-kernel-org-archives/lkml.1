Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYGZMnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYGZMnX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 08:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYGZMnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 08:43:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49526 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbYGZMnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 08:43:14 -0400
Date: Sat, 26 Jul 2008 14:42:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] ftrace: disable tracing on acpi idle calls
Message-ID: <20080726124230.GE20713@elte.hu>
References: <20080725220040.911370182@goodmis.org> <20080725220334.931959350@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725220334.931959350@goodmis.org>
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

> The acpi idle waits calls local_irq_save and then uses mwait to go 
> into idle. The tracer gets reenabled at local_irq_save but does not 
> detect that the idle allows for wake ups.
> 
> This patch adds code to disable the tracing when acpi puts the CPU to 
> idle.

applied to tip/tracing/urgent - thanks Steve.

	Ingo
