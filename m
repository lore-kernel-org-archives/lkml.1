Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbZCUQqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbZCUQqp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbZCUQqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:46:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51109 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131AbZCUQqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:46:35 -0400
Date: Sat, 21 Mar 2009 17:46:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Steven Rostedt <srostedt@redhat.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: Fix TRACING_SUPPORT dependency
Message-ID: <20090321164604.GL11183@elte.hu>
References: <20090320150914.GA22769@oksana.dev.rtsoft.ru> <20090320190428.GD6224@elte.hu> <20090320193904.GA13707@oksana.dev.rtsoft.ru> <20090320195743.GA25147@elte.hu> <20090320202247.GA30654@oksana.dev.rtsoft.ru> <20090321161814.GC11183@elte.hu> <alpine.DEB.2.00.0903211230580.13615@gandalf.stny.rr.com> <20090321163328.GH11183@elte.hu> <alpine.DEB.2.00.0903211239170.13615@gandalf.stny.rr.com> <alpine.DEB.2.00.0903211242530.13615@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903211242530.13615@gandalf.stny.rr.com>
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

> 
> On Sat, 21 Mar 2009, Steven Rostedt wrote:
> > 
> > Since we know that's not an issue with PPC32, perhaps we should add (I 
> > hate to do this)...
> > 
> > 
> > 	depends on TRACE_IRQFLAGS_SUPPORT || PPC32
> > 
> > And document that the "|| PPC32" should go when PowerPC32 gets its act
> > together.  :-/
> 
> Note, the only tracer broken on PPC32 is the IRQSOFF tracer, and 
> that already depends on TRACE_IRQFLAGS_SUPPORT.

Ok, that's fine with me too. Perhaps we could add a TRACING_SUPPORT 
thing that architectures can enable - but it's probably overkill in 
this case.

	Ingo
