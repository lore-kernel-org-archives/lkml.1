Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbZBLQrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbZBLQrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 11:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757122AbZBLQr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 11:47:27 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:55071 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076AbZBLQr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:47:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mUhLOGoOVSJEIJYb7SyTym9JDi65Gy+9GEMV/N8ivGdrGyaQ/y1asAmoWIrLuAbQCW
         WhHqVKZ4cO8UT8+uoFesJd5fHQPFtartYRzG5rr3ogR2c9vG2AKU9sNhqzAFJiMRqFbJ
         ckgAZWzT0e+kvKOoGiz74J+IYex7UNRsILqtk=
Date: Thu, 12 Feb 2009 17:47:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/7][RFC] function graph tracer port to PowerPC
Message-ID: <20090212164720.GA4868@nowhere>
References: <20090212011051.265346435@goodmis.org> <20090212015503.GA4697@nowhere> <alpine.DEB.1.10.0902121131150.15469@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902121131150.15469@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 11:31:44AM -0500, Steven Rostedt wrote:
> 
> On Thu, 12 Feb 2009, Frederic Weisbecker wrote:
> 
> > On Wed, Feb 11, 2009 at 08:10:51PM -0500, Steven Rostedt wrote:
> > > 
> > > The following set of patches are RFC and not for inclusion
> > > (unless everyone is fine with them as is).
> > > 
> > > This is the port to PowerPC of the function graph tracer that was written
> > > by Frederic Weisbecker for the x86 architecture.  It is broken up
> > > into a series of logical steps.
> > > 
> > > 1) get generic code ready for other archs
> > > 2) get PowerPC 64-bit working with just static function tracing
> > > 3) get PowerPC 64-bit working with dynamic function tracing
> > > 4) get PowerPC 32-bit working with just static function tracing
> > > 5) get PowerPC 32-bit working with dynamic function tracing
> > > 
> > > (with some clean ups in between)
> > > 
> > 
> > 
> > Thanks a lot Steven!
> > I'm sad to not having a Power Pc to test it...
> 
> BTW, Can I count that as an Acked-by: for the first patch. Since the first 
> patch does modify your code.
> 
> -- Steve
> 


Yes of course, I knew most of it was architecture independant but I delayed
this TODO for future ports, and you've done it.

Thanks.

Just a micro detail: the ftrace_push/pop_return_trace are parts of
the core of the entry/return probe, something that could be used
by other users than the function graph tracer itself.

Perhaps it would be better to put them in kernel/trace/ftrace.c
What do you think?

Anyway, Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

