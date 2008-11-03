Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbYKCIOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbYKCIOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 03:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbYKCIO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 03:14:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38303 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbYKCIO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 03:14:26 -0500
Date: Mon, 3 Nov 2008 09:14:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: ftrace_dump_on_oops=[tracer]
Message-ID: <20081103081416.GB28771@elte.hu>
References: <1225544744.21456.38.camel@lappy.programming.kicks-ass.net> <alpine.DEB.1.10.0811011441210.13362@gandalf.stny.rr.com> <1225565857.21456.51.camel@lappy.programming.kicks-ass.net> <alpine.DEB.1.10.0811011513120.13528@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811011513120.13528@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Sat, 1 Nov 2008, Peter Zijlstra wrote:
> 
> > On Sat, 2008-11-01 at 14:43 -0400, Steven Rostedt wrote:
> > > On Sat, 1 Nov 2008, Peter Zijlstra wrote:
> > > 
> > > > seems useful to debug crashes that happen before I read userspace.
> > > 
> > > Hmm, I think it might be better to separate this from the dump_on_oops.
> > > How about a ftrace_default_tracer parameter?
> > > 
> > > If one is defined, it is activated as soon as it is initialized. This way 
> > > we decouple the dump_on_oops, which we may not always want, and a way to 
> > > start tracers before the switch to user space.
> > 
> > Like so?
> 
> Sure.
> 
> > 
> > ---
> > Subject: ftrace: enable setting an ftrace tracer on boot
> > 
> > In order to facilitate early boot trouble, allow one to specify a tracer
> > on the kernel boot line.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>

applied to tip/tracing/ftrace, thanks guys!

	Ingo
