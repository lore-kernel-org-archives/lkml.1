Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbYJDIc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbYJDIc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 04:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYJDIct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 04:32:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46067 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYJDIcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 04:32:48 -0400
Date: Sat, 4 Oct 2008 10:32:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Add a C-state tracer to help power optimization
Message-ID: <20081004083242.GD27624@elte.hu>
References: <20081003165533.249261b1@infradead.org> <alpine.DEB.1.10.0810032003140.17863@gandalf.stny.rr.com> <20081003223347.27aa25ba@infradead.org> <alpine.DEB.1.10.0810040141440.30107@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810040141440.30107@gandalf.stny.rr.com>
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
> On Fri, 3 Oct 2008, Arjan van de Ven wrote:
> 
> > On Fri, 3 Oct 2008 20:32:51 -0400 (EDT)
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > 
> > > Hi Arjan,
> > > 
> > > Very nice! I just have a few comments below.
> > 
> > since this is my first tracer.... I would suggest having a "golden
> > example" one that people can copy (it seems I copied a less than
> > perfect one ;-)... maybe a trace_example.c ?
> 
> Yeah, that would make sense to have.  People are starting to come
> up with so many different tracers, I'm not sure what a golden
> example would look like :-/

i think starting with kernel/trace/trace_nop.c is the simplest: copy 
that into a new plugin and make it show up in make oldconfig and make it 
build. Then add ftrace_printk() lines initially - only specialize the 
trace entries to that plugin later on.

	Ingo
