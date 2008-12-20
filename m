Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYLTISW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYLTISW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 03:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYLTISO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 03:18:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48433 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbYLTISM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 03:18:12 -0500
Date: Sat, 20 Dec 2008 09:17:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com
Subject: Re: [patch 1/2] x86, bts: fork and exit handling
Message-ID: <20081220081755.GA5581@elte.hu>
References: <20081219151024.A4960@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219151024.A4960@sedona.ch.intel.com>
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


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> Add arch_ptrace_untrace() function that is called when the tracer
> detaches (either voluntarily or when the tracing task dies);
> ptrace_disable() is only called on a voluntary detach.
> 
> Add ptrace_fork() and arch_ptrace_fork(). They are called when a
> traced task is forked.
> 
> Clear DS and BTS related fields on fork.
> 
> Release DS resources and reclaim memory in ptrace_untrace(). This
> releases resources already when the tracing task dies. We used to do
> that when the traced task dies.
> 
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>

applied to tip/tracing/hw-branch-tracer, thanks Markus! It's a nice 
cleanup too - to tear down any arch-level ptrace state that might come 
around.

	Ingo
