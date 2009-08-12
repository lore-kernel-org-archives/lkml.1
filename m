Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZHLQ7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZHLQ7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZHLQ7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:59:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39569 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360AbZHLQ7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:59:30 -0400
Message-ID: <4A82F5A0.2090603@redhat.com>
Date: Wed, 12 Aug 2009 13:02:24 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [GIT PULL] tracing: Syscalls trace events + perf support
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <4A82EEC5.8000603@redhat.com>
In-Reply-To: <4A82EEC5.8000603@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Masami Hiramatsu wrote:
> Hi Frederic and Jason,
> 
> Frederic Weisbecker wrote:
>> Frederic Weisbecker (3):
>>         tracing: Add ftrace event call parameter to its field descriptor handler
> 
>> Jason Baron (12):
>>         tracing: Add ftrace_event_call void * 'data' field
> 
> Both of you added a parameter to ftrace_event_call for passing
> sycall name (call->data) to handlers, but one passes 'ftrace_event_call *'
> and another passes 'void *'. It seems not enough unified.
> 
> And also, I'm now updating my patch for 'dynamic ftrace_event_call'
> http://lkml.org/lkml/2009/7/24/234
> which adds 'ftrace_event_call *' for all handlers.
> 
> I think passing 'ftrace_event_call *' is more generic way
> to do that. What would you think about that?

Hmm, I changed my mind that passing 'void *' is enough, since
all other fields of ftrace_event_call will be handled in
trace_events.c.

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

