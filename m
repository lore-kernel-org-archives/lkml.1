Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbXLKVVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbXLKVVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 16:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbXLKVVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 16:21:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43603 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbXLKVU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 16:20:59 -0500
Date: Tue, 11 Dec 2007 22:20:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Bligh <mbligh@google.com>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, netdev@vger.kernel.org,
       Auke Kok <auke-jan.h.kok@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>
Subject: Re: 2.6.24-rc4-mm1
Message-ID: <20071211212032.GE6902@elte.hu>
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <33307c790712110813h23def95dvd068b7226e9fcd36@mail.gmail.com> <20071211123705.844aac24.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211123705.844aac24.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > I can't see this compile failure posted anywhere:
> > http://test.kernel.org/results/IBM/126049/build/debug/stderr
> > 
> > arch/x86/vdso/vdso32/sigreturn.S: Assembler messages:
> > arch/x86/vdso/vdso32/sigreturn.S:23: Error: suffix or operands invalid for `pop'
> > arch/x86/vdso/vdso32/syscall.S:25: Error: suffix or operands invalid for `pop'
> > make[1]: *** [arch/x86/vdso/vdso32/syscall.o] Error 1
> > make: *** [arch/x86/vdso] Error 2
> 
> (cc Ingo and Thomas)

Roland says:

| That seems like it must be a tool problem.  The V=1 output would show 
| if those compiles missed -m32 or something.  But even in the wrong 
| mode, this error does not make sense.  The assembly code it's citing 
| is identical to the old arch/x86/ia32/vsyscall-syscall.S code.

	Ingo
