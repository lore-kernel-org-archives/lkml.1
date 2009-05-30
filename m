Return-Path: <linux-kernel-owner+w=401wt.eu-S932504AbZE3OiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbZE3OiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 10:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbZE3OiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 10:38:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36335 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbZE3OiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 10:38:05 -0400
Message-ID: <4A2144FA.6080508@redhat.com>
Date: Sat, 30 May 2009 10:38:50 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH -tip v8 7/7] tracing: add kprobe-based event tracer
References: <20090529000326.17532.70868.stgit@localhost.localdomain> <20090529000353.17532.71995.stgit@localhost.localdomain> <20090530081526.GC15755@infradead.org>
In-Reply-To: <20090530081526.GC15755@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, May 28, 2009 at 08:03:53PM -0400, Masami Hiramatsu wrote:
>> Add kprobes-based event tracer on ftrace.
> 
> Wouldn't it make more sense to call this the dynamic event tracer?
> 
> The use of kprobes is more an implementation detail than something
> the user cares about.

Hmm, I don't think so, because other tracers (e.g. hw breakpoint tracer)
can also add their events dynamically by trace_add/remove_event_call.
It's more flexible than this tracer includes those events.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

