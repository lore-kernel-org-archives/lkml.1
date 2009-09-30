Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbZI3MEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbZI3MEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZI3MEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:04:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54121 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbZI3MEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:04:50 -0400
Date: Wed, 30 Sep 2009 14:04:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [RFC PATCH tracing/kprobes 0/5] tracing/kprobes,  perf: perf
	kprobe support
Message-ID: <20090930120418.GB7618@elte.hu>
References: <20090925191424.12939.91503.stgit@omoto> <4AC2AF01.9090202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC2AF01.9090202@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Masami Hiramatsu wrote:
>>
>> Hi,
>>
>> These patches introduce perf kprobe command and update kprobe-tracer.
>> perf kprobe command allows you to add new probe points by C line number
>> and local variable names.
>
> Last week, Arnaldo and I talked about this command, and he suggested 
> that the command would be better 'perf probe', because it would be 
> able to cover both of kernel space (by kprobes) and user space (by 
> uprobes).

Agreed.

> Basically, I agree with his idea. But I think we may need to consider 
> more flexible syntax for that purpose before we support uprobes. In 
> this area, SystemTap has done big advance, we can see how many 
> varieties of syntax it has by 'man stapprobes'.
>
> And also, it's hard to decide it without real uprobe-tracer (and 
> uprobes too!) implementation on ftrace. So, I think it is better to 
> continue using 'perf kprobe' in this time.
>
> But it's worth to add to todo list. :)

I'd still name it 'perf probe', even if initially it supports kprobes.

	Ingo
