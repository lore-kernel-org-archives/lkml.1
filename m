Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbZIPEyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbZIPEyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZIPEyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:54:21 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44979 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbZIPEyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:54:21 -0400
Date: Wed, 16 Sep 2009 10:24:20 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH tracing/kprobes 3/6] ftrace: Fix
	trace_remove_event_call() to lock trace_event_mutex
Message-ID: <20090916045420.GA11510@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com> <20090914204912.18779.68734.stgit@dhcp-100-2-132.bos.redhat.com> <1253071051.20020.177.camel@gandalf.stny.rr.com> <20090916040511.GB5121@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916040511.GB5121@nowhere>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 06:05:12AM +0200, Frederic Weisbecker wrote:
> On Tue, Sep 15, 2009 at 11:17:30PM -0400, Steven Rostedt wrote:
> > On Mon, 2009-09-14 at 16:49 -0400, Masami Hiramatsu wrote:

...
 
> It's in tip:/tracing/kprobes, which is not merged into tip/master.
> I have some pending updates in my tracing/kprobes tree:
> 
> Frederic Weisbecker (1):
>       Merge commit 'tracing/core' into tracing/kprobes
> 
> Masami Hiramatsu (16):
>       kprobes/x86: Call BUG() when reentering probe into KPROBES_HIT_SS
>       kprobes/x86-64: Allow to reenter probe on post_handler
>       kprobes/x86: Fix to add __kprobes to in-kernel fault handing functions
>       kprobes: Fix to add __kprobes to notify_die
>       kprobes/x86-64: Fix to move common_interrupt to .kprobes.text
>       kprobes: Prohibit to probe native_get_debugreg
>       x86: Allow x86-32 instruction decoder selftest on x86-64
>       x86: Remove unused config macros from instruction decoder selftest
>       x86: Add MMX support for instruction decoder
>       kprobes/x86-32: Move irq-exit functions to kprobes section
>       x86/ptrace: Fix regs_get_argument_nth() to add correct offset
>       tracing/kprobes: Fix probe offset to be unsigned
>       tracing/kprobes: Cleanup kprobe tracer code.
>       tracing/kprobes: Add event profiling support
>       tracing/kprobes: Add argument name support
>       tracing/kprobes: Show event name in trace output
> 
> Plus the current set that I'm about to apply, if no problem arises.
> I should also merge one more time tip:tracing/core into it because
> it has developed another conflicts against it since then.
> 
> Ingo, if you are fine with it, I'll send you a pull request
> soon.

Frederic,

Could you please add http://lkml.org/lkml/2009/9/15/13 too?

Ananth
