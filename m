Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbYHUKbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbYHUKbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYHUKbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:31:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36209 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbYHUKbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:31:38 -0400
Date: Thu, 21 Aug 2008 12:31:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] ftrace: x86 use copy to and from user functions
Message-ID: <20080821103117.GB19452@elte.hu>
References: <alpine.DEB.1.10.0808201253330.494@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808201253330.494@gandalf.stny.rr.com>
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

> The modification of code is performed either by kstop_machine, before 
> SMP starts, or on module code before the module is executed. There is 
> no reason to do the modifications from assembly. The copy to and from 
> user functions are sufficient and produces cleaner and easier to read 
> code.
> 
> Thanks to Benjamin Herrenschmidt for suggesting the idea.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

applied to tip/tracing/ftrace - thanks Steve!

	Ingo
