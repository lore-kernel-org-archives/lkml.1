Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbZHFL2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbZHFL2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZHFL2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:28:32 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:20205 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbZHFL2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:28:31 -0400
X-SourceIP: 213.93.53.227
Subject: Re: malloc() tracing in perf?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       acme <acme@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       roland <roland@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090806112059.GD18768@redhat.com>
References: <4A7A8ADD.4080208@cs.helsinki.fi>
	 <1249546610.32113.35.camel@twins>  <20090806112059.GD18768@redhat.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 13:28:14 +0200
Message-Id: <1249558094.32113.242.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 07:20 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Thu, Aug 06, 2009 at 10:16:50AM +0200, Peter Zijlstra wrote:
> > [...]
> > > But then it hit me, why can't I have kmemtrace + perf but for 
> > > user-space? Something like the "Malloc Trace" shown here:
> > > [...]
> 
> > I seem to have heard people are working on such a thing, but I can't
> > seem to find a single LKML post with 'uprobe' in the subject in the
> > past two years [...]
> 
> That work is ongoing, and being discussed on utrace-devel@redhat.com,
> since it is a prerequisite. 

Still hiding the discussion and the design never helped anybody.

You might think it ready and then post it to LKML only to have it ripped
apart -- have the discussion openly please.

> > Now doing probes on userspace is hard because you need to know more
> > about the userspace bits than a kernel really ought to be interested
> > in.  [...]  Anyway, like you say, it has uses (potentially very
> > powerful ones), Sun/Apple do it with Dtrace, Linux wants it but I
> > don't think we quite agreed on how to do it :-)
> 
> While these deliberations are ongoing, you can use systemtap.  Probing
> random places in userspace is about as casual as probing the kernel:

Right, but that still doesn't tell us anything on how you're doing that,
does it?



