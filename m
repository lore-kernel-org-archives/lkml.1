Return-Path: <linux-kernel-owner+w=401wt.eu-S1763136AbZBYWV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763136AbZBYWV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbZBYWVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:21:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34991 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757554AbZBYWVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:21:49 -0500
Date: Wed, 25 Feb 2009 17:21:47 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com
Subject: Re: [PATCH] new irq tracer
In-Reply-To: <20090225221210.GA20133@Krystal>
Message-ID: <alpine.DEB.2.00.0902251721170.12697@gandalf.stny.rr.com>
References: <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com> <20090222123543.359C.A69D9226@jp.fujitsu.com> <49A5765C.2020001@redhat.com> <20090225165747.GC3123@redhat.com> <20090225173412.GA14269@Krystal> <alpine.DEB.2.00.0902251250110.12697@gandalf.stny.rr.com>
 <20090225221210.GA20133@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Feb 2009, Mathieu Desnoyers wrote:
> > > The main thing I dislike about only tracing action->handler() calls is
> > > that you are not tracing an IRQ per se, but rather the invocation of a
> > > given handler within the interrupt. For instance, it would be difficult
> > > to calculate the maximum interrupt latency for a given interrupt line,
> > > because you don't have the "real" irq entry/exit events, just the
> > > individual handler() calls.
> > 
> > Then use the function_graph tracer.
> > 
> 
> Sadly, the function tracer cannot be enabled on production systems.
> Therefore it's not a usable solution in the context where I need this.

And why not? It has zero overhead when disabled.

-- Steve
