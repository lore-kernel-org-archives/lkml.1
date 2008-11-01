Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYKATNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYKATNl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 15:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYKATNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 15:13:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43930 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYKATNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 15:13:33 -0400
Date: Sat, 1 Nov 2008 15:13:32 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: ftrace_dump_on_oops=[tracer]
In-Reply-To: <1225565857.21456.51.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0811011513120.13528@gandalf.stny.rr.com>
References: <1225544744.21456.38.camel@lappy.programming.kicks-ass.net>  <alpine.DEB.1.10.0811011441210.13362@gandalf.stny.rr.com> <1225565857.21456.51.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 1 Nov 2008, Peter Zijlstra wrote:

> On Sat, 2008-11-01 at 14:43 -0400, Steven Rostedt wrote:
> > On Sat, 1 Nov 2008, Peter Zijlstra wrote:
> > 
> > > seems useful to debug crashes that happen before I read userspace.
> > 
> > Hmm, I think it might be better to separate this from the dump_on_oops.
> > How about a ftrace_default_tracer parameter?
> > 
> > If one is defined, it is activated as soon as it is initialized. This way 
> > we decouple the dump_on_oops, which we may not always want, and a way to 
> > start tracers before the switch to user space.
> 
> Like so?

Sure.

> 
> ---
> Subject: ftrace: enable setting an ftrace tracer on boot
> 
> In order to facilitate early boot trouble, allow one to specify a tracer
> on the kernel boot line.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve
