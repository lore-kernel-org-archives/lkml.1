Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbZIQR3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbZIQR3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZIQR3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:29:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbZIQR3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:29:46 -0400
Message-ID: <4AB272C9.3070906@redhat.com>
Date: Thu, 17 Sep 2009 13:32:57 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [PATCH tracing/kprobes 0/6] tracing/kprobes: kprobe-based	event
 tracer update and perf support
References: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com> <20090917023914.GA5140@nowhere>
In-Reply-To: <20090917023914.GA5140@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Sep 14, 2009 at 04:48:47PM -0400, Masami Hiramatsu wrote:
>> Hi,
>>
>> Here are bugfixes for kprobe-based event tracer. Thank you for review
>> and reporting bugs! I fixed it. And also I decided to disable
>> kprobe event when defining, since the events outputs may suddenly
>> mess up the ftrace ring_buffer.
>>
>> Frederic, could you see the patch 4/6? which is what I said on the
>> previous threads.
>>
>>
>> Thank you,
>>
>> ---
>>
>> Masami Hiramatsu (6):
>>        tracing/kprobes: Disable kprobe events by default
>>        tracing/kprobes: Fix profiling alignment for perf_counter buffer
>>        tracing/kprobes: Add probe handler dispatcher for support perf and ftrace
>>        ftrace: Fix trace_remove_event_call() to lock trace_event_mutex
>>        ftrace: Fix trace_add_event_call() to initialize list
>>        tracing/kprobes: Fix trace_probe registration order
>
>
>
> Applied in
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/kprobes
>
> I've included Ananth fix too.
>
> This time it looks like I haven't lost the last patch.
> But I should double-check each morning as I suspect I become
> a sleepwalker who does random git-reset in midnight...

Thanks!
I've double checked. Please sleep in peace :-)


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

