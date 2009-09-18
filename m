Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbZIRMpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbZIRMpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZIRMpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:45:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60848 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbZIRMpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:45:40 -0400
Date: Fri, 18 Sep 2009 14:45:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kill markers
Message-ID: <20090918124531.GA10877@elte.hu>
References: <20090917173527.GA1699@lst.de> <20090918102334.GA24638@elte.hu> <20090918121329.GA1173@Krystal> <20090918123846.GB24391@elte.hu> <20090918124109.GE1173@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090918124109.GE1173@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > * Ingo Molnar (mingo@elte.hu) wrote:
> > > > 
> > > > * Christoph Hellwig <hch@lst.de> wrote:
> > > > 
> > > > > Now that the last users of markers have migrated to the event tracer 
> > > > > we can kill off the support code.
> > > > 
> > > > Applied, thanks Christoph!
> > > > 
> > > > Btw., there's some more marker related bits in the kernel, such as 
> > > > scripts/mod/modpost.c - mostly the effects of:
> > > > 
> > > >   b2e3e65: Linux Kernel Markers: create modpost file
> > > > 
> > > > I think we want to keep those bits, for those who want to use new 
> > > > modpost with an older kernel - but mark them for deprecation.
> > > 
> > > Just to confirm: this means having a printk-style infrastructure to 
> > > prototype tracepoints is not considered useful ?
> > 
> > trace_printk()?
> 
> OK, sounds good !
> 
> No objection then :)

Thanks! :-)

I've added your:

 Acked-by: Mathieu Desnoyer <mathieu.desnoyers@polymtl.ca>

to the commit.

	Ingo
