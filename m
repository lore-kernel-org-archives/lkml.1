Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZBCNPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZBCNPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZBCNP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:15:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40857 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbZBCNPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:15:25 -0500
Date: Tue, 3 Feb 2009 11:15:08 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/3] trace: better manage the context info for
	events
Message-ID: <20090203131508.GD17781@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090202222921.GB12082@ghostprotocols.net> <20090203020746.GB22718@nowhere> <alpine.DEB.1.10.0902022128130.2192@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902022128130.2192@gandalf.stny.rr.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 02, 2009 at 09:32:51PM -0500, Steven Rostedt escreveu:
> On Tue, 3 Feb 2009, Frederic Weisbecker wrote:
> > Now that I see the practical case, I'm not sure the design of my patch was valuable.
> > A tracer has to play with the flag if it wants to override the context info in
> > the bin/raw/hex cases. And I don't think this is a good way to proceed.
> > 
> > In my opinion, the ITER_CONTEXT_INFO flag should mostly be set by the user.
> 
> I think it should _only_ be set by user.

So we need a trace_event->binary_and_I_mean_it() callback that even if
the user wants, doesn't prints an ascii formatted context, as, for
tracers such as blkftrace, the binary trace has the context... in binary
:-)

- Arnaldo
