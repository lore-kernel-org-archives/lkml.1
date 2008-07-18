Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbYGRWcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbYGRWcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYGRWco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:32:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48216 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbYGRWcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:32:43 -0400
Date: Sat, 19 Jul 2008 00:32:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH ftrace.git] Immedate Values Optimized Jump Fix
Message-ID: <20080718223229.GH31073@elte.hu>
References: <20080717031721.GA24504@Krystal> <20080718161523.GY6875@elte.hu> <20080718183124.GA31768@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718183124.GA31768@Krystal>
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


* Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> > 
> > > Hi Ingo,
> > > 
> > > This fix would apply to the ftrace tree which contains the jump-based 
> > > immediate values. I don't know if this tree is still under active 
> > > development, but I guess that it wouldn't hurt to fix it.
> > > 
> > > Caused a kernel OOPS when loading the tracepoint probes once in a 
> > > while on a 8-way x86_64.
> > 
> > We've still got tip/tracing/immediates, with these commits from you:
> > 
> >  $ git-log-line linus.. arch/x86/kernel/immediate.c
> >  ee563d6: immediate values: jump liveliness
> >  e26875a: Immediate Values - Jump
> >  3fc8d03: Immediate Values - x86 Optimization NMI and MCE support
> > 
> > ... but the topic is stalled right now, due to hpa having had 
> > objections. Have those concerns been resolved? (Peter Cc:-ed)
> > 
> > i'd have applied this fix, but it does not apply. The first chunk seems 
> > already be present (in a different form), the second chunk looks much 
> > different.
> > 
> > 	Ingo
> > 
> 
> Hrm, I've edited directly the immediate values: jump liveliness patches,
> which explains why it does not apply. I'll try to unapply/reapply/fold
> the patches and see what it gives.
> 
> Plus, I've noticed that the "Text Edit Lock" patches are not in the 
> immediates branch, thus it fails to compile. Immediate values depends 
> on the Text Edit Lock patches.

feel free to git-cherry-pick the commits together into a coherent unit 
(preferrably all -git based), and we can give it a whirl in tip/master.

	Ingo
