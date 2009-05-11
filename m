Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZEKO4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZEKO4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZEKO4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:56:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53117 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbZEKO4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:56:32 -0400
Date: Mon, 11 May 2009 10:56:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Tom Zanussi <zanussi@comcast.net>
Subject: Re: [PATCH -tip v5 0/7] tracing: kprobe-based event tracer and x86
 instruction decoder
In-Reply-To: <4A0838E6.2000309@redhat.com>
Message-ID: <alpine.DEB.2.00.0905111054490.2492@gandalf.stny.rr.com>
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509044302.GH8007@elte.hu> <4A0838E6.2000309@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 11 May 2009, Masami Hiramatsu wrote:
> > 
> > Two high-level comments:
> > 
> >  - There's no self-test - would it be possible to add one? See 
> >    trace_selftest* in kernel/trace/
> 
> I'm not so sure. Currently, it seems that those self-tests are
> only for tracers which define new event-entry on ring-buffer.
> Since this tracer just use ftrace_bprintk, it might need
> another kind of selftest. e.g. comparing outputs with
> expected patterns.
> In that case, would it be better to make a user-space self test
> including filters and tracepoints?

Or have the workings in the selftest in kernel. As if a user started it. 
It does not need to write to the ring buffer, that is just what I did. The 
event selftests don't check if anything was written to the ring buffer, 
they just make sure that the tests don't crash the system.

-- Steve

