Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbZAEXvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbZAEXvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZAEXuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:50:54 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63384 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZAEXuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:50:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i0aHzOzb1Y9SzeoPjtIu3KpUHkFiUaSnqYUEnkh2zDnmZZLZXmFqfokC4rHoDMpgzy
         U4h72REVTB5l/wPojfnhdJYspfT1PRlmkHqaIfQT4UoEahdLN7FDgSjvVo4ICm2itrPY
         qCg6kMH0qAKWgk9/bboGNG4/03dLzxQx8O/wY=
Date: Tue, 6 Jan 2009 00:50:48 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
Message-ID: <20090105235047.GA6531@nowhere>
References: <4959443f.09a1660a.44f3.2686@mx.google.com> <20081230074543.GA5102@elte.hu> <alpine.DEB.1.10.0901051146470.27085@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901051146470.27085@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 11:48:56AM -0500, Steven Rostedt wrote:
> 
> On Tue, 30 Dec 2008, Ingo Molnar wrote:
> 
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > >  kernel/trace/trace_kmemtrace.c |  345 ++++++++++++++++++++++++++++++++++++++++
> > 
> > btw., i renamed this to kernel/trace/kmemtrace.c. Mentioning 'trace' twice 
> > is enough already ;-)
> 
> Should we rename all the kernel/trace/trace_(.*)\.c to kernel/trace/\1.c ?
> 
> Although I do like the trace in the function name, because it groups them
> nicely together, and keeps ftrace.c and ring_buffer.c stand out from the
> rest.
> 
> -- Steve
> 

Or why not a subdirectory called "tracers" inside kernel/trace to store
the tracers files. This way, the core of tracing (ftrace.c/ring_buffer.c/trace_output.c/
/trace.c/trace_stat.c) can be found easily against the rest. Moreover, there is a risk that
the number of tracers will tend to increase by the time.

