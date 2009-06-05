Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbZFESmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbZFESmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZFESmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:42:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55904 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbZFESmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:42:14 -0400
Date: Fri, 5 Jun 2009 20:42:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Subject: Re: [tip:perfcounters/core] perf_counter tools: Build with native
	optimization
Message-ID: <20090605184202.GA21154@elte.hu>
References: <tip-af794b94ae8a16fb4a9da6ce640c122efb44e2a0@git.kernel.org> <18984.28387.116533.597438@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18984.28387.116533.597438@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> tip-bot for Ingo Molnar writes:
> 
> > perf_counter tools: Build with native optimization
> > 
> > Build the tools with -march=native by default.
> 
> On powerpc (RHEL5.2 on POWER5+, gcc 4.1.2), I get:
> 
>     CC perf.o
> cc1: error: unrecognized command line option "-march=native"
> make: *** [perf.o] Error 1

ok, i removed that.

> Is there a way to make the default CFLAGS depend on the architecture?
> We need -m64 on powerpc as well.

Would be nice to add a Makefile rule to add -m64 on all 64-bit 
architectures. That would avoid having to do PowerPC-specific magic.

(But, PowerPC-specific rules would be fine too, of course.)

	Ingo
