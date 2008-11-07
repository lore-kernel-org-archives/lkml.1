Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYKGEZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYKGEZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 23:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYKGEY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 23:24:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:59055 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbYKGEYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 23:24:55 -0500
Date: Thu, 6 Nov 2008 20:25:22 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, alan@redhat.com, jbaron@redhat.com
Subject: Re: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081106202522.4be6bf75@infradead.org>
In-Reply-To: <20081106232506.GF20928@redhat.com>
References: <20081106063108.02b4813d@infradead.org>
	<1225983052.7803.4623.camel@twins>
	<20081106070157.065b2dcc@infradead.org>
	<alpine.DEB.1.10.0811061020311.31011@gandalf.stny.rr.com>
	<20081106094558.50d94bcc@infradead.org>
	<y0mej1ofvyz.fsf@ton.toronto.redhat.com>
	<1226003343.31966.43.camel@lappy.programming.kicks-ass.net>
	<20081106215310.GA15163@Krystal>
	<20081106221426.GD20928@redhat.com>
	<20081106222529.GA17528@Krystal>
	<20081106232506.GF20928@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008 18:25:06 -0500
"Frank Ch. Eigler" <fche@redhat.com> wrote:

> Hi -
> 
> On Thu, Nov 06, 2008 at 05:25:29PM -0500, Mathieu Desnoyers wrote:
> > [...]
> > > Arjan asked for something to send formatted strings to tracing
> > > buffers that are consumed by user space.  Whether internally that
> > > is done by markers, or by tracepoints converted to markers, or by
> > > tracepoints with custom ftrace_printf-y code, is
> > > indistinguishable to the user.
> > > 
> > > Can you be specific in what way any of that is exposing an "API
> > > directly to userspace"?
> > 
> > The tracepoint declaration is linked to the kernel code that is
> > meant to be traced. Given this code will change over time, it will
> > be more difficult to perform those changes if it is in any way
> > coupled with format strings exported to userspace via traced.  [...]
> 
> The userspace interface to all the various tracing widgets consists of
> the textual formatted trace data stream.  ** IF ** these streams are
> to represent a long-term interface, can you elaborate why you believe

tracepoints are not and cannot be a stable interface, and users of
these points, preferably scripts that are part of the kernel source,
need to learn to adapt to a changing environment.
At least if we make the formatting function a *function*, we can even do
very minor things to deal with some changes, but even then.

And this is ok. You're talking about deep internals, and for
tracepoints to be useful they HAVE to be about these internals.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
