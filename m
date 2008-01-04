Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYADGp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYADGp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 01:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYADGpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 01:45:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbYADGpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 01:45:15 -0500
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>
Subject: Re: [RFC PATCH 00/11] mcount tracing utility
References: <20080103071609.478486470@goodmis.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 04 Jan 2008 01:42:32 -0500
In-Reply-To: <20080103071609.478486470@goodmis.org> (Steven Rostedt's message of "Thu, 03 Jan 2008 02:16:09 -0500")
Message-ID: <y0mbq82um5j.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> The following patch series brings to vanilla Linux a bit of the RT kernel
> trace facility. This incorporates the "-pg" profiling option of gcc
> that will call the "mcount" function for all functions called in
> the kernel.
> [...]
> [Future:] SystemTap:
> ----------
> One thing that Arnaldo and I discussed last year was using systemtap to
> add hooks into the kernel to start and stop tracing.  

Sure.  The dual of this makes sense too: letting systemtap scripts
hook up to the mcount callback itself, for purposes beyond just
tracing the function calls.

> kprobes is too heavy to do on all funtion calls, but it would be
> perfect to add to non hot paths to start the tracer and stop the
> tracer.

(Note that kprobes are not the only event sources systemtap can use:
markers, timers, procfs control files, and some others.  Any
combination of these can be used in a script to express start/stop
decisions.)


- FChE
