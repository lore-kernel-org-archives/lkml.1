Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbZHLVY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbZHLVY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZHLVYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:24:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48363 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbZHLVYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:24:23 -0400
Message-ID: <4A8333B4.7020301@redhat.com>
Date: Wed, 12 Aug 2009 17:27:16 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [RFD] Kprobes/Kretprobes perf support
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>	 <4A82EEC5.8000603@redhat.com> <4A82F5A0.2090603@redhat.com>	 <20090812191305.GB5974@nowhere> <1250111397.7035.1.camel@laptop>
In-Reply-To: <1250111397.7035.1.camel@laptop>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2009-08-12 at 21:13 +0200, Frederic Weisbecker wrote:
> 
>> Ingo, Peter do you have an idea on how we could do that?
> 
> Wouldn't it be easiest to use ftrace to create dynamic tracepoints in
> the ftrace way such that they become available in
> debugfs://tracing/events/kprobes/*/ and then have them interfaced the
> same way as all other tracepoints?

Yes, almost same. One big difference is that they are sharing
same event-id(TRACE_KPROBE and TRACE_KRETPROBE).
But I can make each kprobe events to have different ids, if you need.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

