Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbZC3PhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbZC3PhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbZC3PhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:37:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39996 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZC3PhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:37:07 -0400
Date: Mon, 30 Mar 2009 21:06:56 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip 3/4 V3] tracing: kprobe-tracer plugin supports
	arguments
Message-ID: <20090330153656.GF6411@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <49CC08D2.30608@redhat.com> <20090330045813.GB6411@in.ibm.com> <49D0E600.7050204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D0E600.7050204@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 11:32:16AM -0400, Masami Hiramatsu wrote:
> Ananth N Mavinakayanahalli wrote:
> > On Thu, Mar 26, 2009 at 06:59:30PM -0400, Masami Hiramatsu wrote:
> > 
> >> +/* TODO: Move these functions to arch/XXX/include/asm/debugger.h */
> >> +
> > 
> > Maybe arch/xxx/lib/<>.c too?
> > 
> > I know its on your list of TODOs but I'd prefer to have an
> > arch_fetch_func_args() or somesuch in arch specific code, to start with.
> > It is trivial to implement the argument extraction code on certain
> > architectures and such a helper would be great.
> 
> Hmm, I think fetch_* functions are more general framework, but
> it's true that some of their implementation depend on architecture.
> Thus, I'd prefer to separate some of basic implementaions(get_stack_nth,
> get_argument_nth) from fetch_* and move it to arch/xxx/include/asm/ptrace.h,
> because there are similar inline functions.
> What would you think about this?

I don't really have an opinion on the nomenclature as long as there is a
clear arch specific callout that doesn't need to touch arch agnostic
files.

Ananth
