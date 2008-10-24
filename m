Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbYJXL4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbYJXL4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYJXL4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:56:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62880 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbYJXL4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:56:09 -0400
Date: Fri, 24 Oct 2008 07:56:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH] trace: add the MMIO-tracer to the tracer menu
In-Reply-To: <20081024112535.GA19786@elte.hu>
Message-ID: <alpine.DEB.1.10.0810240755290.25677@gandalf.stny.rr.com>
References: <1224845357.4075.0.camel@twins> <20081024112535.GA19786@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Oct 2008, Ingo Molnar wrote:
> >  #
> >  # IO delay types:
> > Index: linux-2.6/kernel/trace/Kconfig
> > ===================================================================
> > --- linux-2.6.orig/kernel/trace/Kconfig
> > +++ linux-2.6/kernel/trace/Kconfig
> > @@ -194,4 +194,32 @@ config FTRACE_STARTUP_TEST
> >  	  functioning properly. It will do tests on all the configured
> >  	  tracers of ftrace.
> >  
> > +config MMIOTRACE_HOOKS
> > +	bool
> > +
> > +config MMIOTRACE
> > +	bool "Memory mapped IO tracing"
> > +	depends on HAVE_MMIOTRACE_SUPPORT && DEBUG_KERNEL && PCI
> > +	select TRACING
> > +	select MMIOTRACE_HOOKS
> 
> change makes sense, but isnt MMIOTRACE_HOOKS basically overlapping 
> HAVE_MMIOTRACE_SUPPORT? So i think we could get rid of MMIOTRACE_HOOKS 
> altogether and just use HAVE_MMIOTRACE_SUPPORT.

And doing this will remove the need about my question on depends on X86.

-- Steve

