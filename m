Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbXLROA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbXLROA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 09:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbXLROAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 09:00:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34016 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763AbXLROAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 09:00:49 -0500
Date: Tue, 18 Dec 2007 14:58:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/4] x86: add kprobe-booster to X86_64
Message-ID: <20071218135856.GC17470@elte.hu>
References: <1197930464.23402.112.camel@brick> <20071218112936.GE9002@elte.hu> <1197978160.7734.31.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197978160.7734.31.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Tue, 2007-12-18 at 12:29 +0100, Ingo Molnar wrote:
> > * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > 
> > > Sorry I missed an ifdef in this patch in the following hunk:
> > 
> > could you resend your kprobes cleanups against current x86.git? They
> > have been conceptually acked by Masami. This cuts out the unification
> > part of your queue which is bad luck but the effort has been duplicated
> > already so there's not much we can do about it i guess.
> > 
> > Your other 17 cleanup and unification patches are still queued up in
> > x86.git and passed a lot of testing, so they will likely go into
> > v2.6.25. Nice work!
> > 
> > 	Ingo
> 
> Ingo,
> 
> I'd suggest just tossing my kprobes cleanups.  I just sent you a rollup
> of anything I saw that was left in mine that was still worthwhile
> after Masami's, included below for reference.  It didn't amount to much
> left so I rolled it all together:
> 
> Subject: [PATCH] x86: kprobes leftover cleanups
> 
> Eliminate __always_inline, all of these static functions are
> only called once.  Minor whitespace cleanup.  Eliminate one
> supefluous return at end of void function.  Reverse sense of
> #ifndef to be #ifdef to show the case only affects X86_32.

thanks, i've applied them.

	Ingo
