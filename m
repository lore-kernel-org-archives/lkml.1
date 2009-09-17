Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbZIQCjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbZIQCjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758068AbZIQCjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:39:18 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:37277 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbZIQCjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:39:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qHERblBT76ksNdMzq2voySV4Wu3SzJaxsuFR7bdN9cnShc3izblMB+rOwBX5VU5DHN
         ptpfGeh1mSFUL7Oy/vdHS7hlG1YjI+nZNl3AZYsozFvkFcv26JDovpjk56xrGq+iPoeG
         SoUZPUwhcPoNYS0zB57gmUYJR4S9e+UGpntV8=
Date: Thu, 17 Sep 2009 04:39:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH tracing/kprobes 0/6] tracing/kprobes: kprobe-based
	event tracer update and perf support
Message-ID: <20090917023914.GA5140@nowhere>
References: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 04:48:47PM -0400, Masami Hiramatsu wrote:
> Hi,
> 
> Here are bugfixes for kprobe-based event tracer. Thank you for review
> and reporting bugs! I fixed it. And also I decided to disable
> kprobe event when defining, since the events outputs may suddenly
> mess up the ftrace ring_buffer.
> 
> Frederic, could you see the patch 4/6? which is what I said on the
> previous threads.
> 
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (6):
>       tracing/kprobes: Disable kprobe events by default
>       tracing/kprobes: Fix profiling alignment for perf_counter buffer
>       tracing/kprobes: Add probe handler dispatcher for support perf and ftrace
>       ftrace: Fix trace_remove_event_call() to lock trace_event_mutex
>       ftrace: Fix trace_add_event_call() to initialize list
>       tracing/kprobes: Fix trace_probe registration order



Applied in

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/kprobes

I've included Ananth fix too.

This time it looks like I haven't lost the last patch.
But I should double-check each morning as I suspect I become
a sleepwalker who does random git-reset in midnight...

