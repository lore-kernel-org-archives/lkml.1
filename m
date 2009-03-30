Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbZC3PcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbZC3PcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZC3PcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:32:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54140 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZC3PcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:32:09 -0400
Message-ID: <49D0E600.7050204@redhat.com>
Date: Mon, 30 Mar 2009 11:32:16 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip 3/4 V3] tracing: kprobe-tracer plugin supports	arguments
References: <49CC08D2.30608@redhat.com> <20090330045813.GB6411@in.ibm.com>
In-Reply-To: <20090330045813.GB6411@in.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli wrote:
> On Thu, Mar 26, 2009 at 06:59:30PM -0400, Masami Hiramatsu wrote:
> 
>> +/* TODO: Move these functions to arch/XXX/include/asm/debugger.h */
>> +
> 
> Maybe arch/xxx/lib/<>.c too?
> 
> I know its on your list of TODOs but I'd prefer to have an
> arch_fetch_func_args() or somesuch in arch specific code, to start with.
> It is trivial to implement the argument extraction code on certain
> architectures and such a helper would be great.

Hmm, I think fetch_* functions are more general framework, but
it's true that some of their implementation depend on architecture.
Thus, I'd prefer to separate some of basic implementaions(get_stack_nth,
get_argument_nth) from fetch_* and move it to arch/xxx/include/asm/ptrace.h,
because there are similar inline functions.
What would you think about this?

Thank you!

> 
> Ananth

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

