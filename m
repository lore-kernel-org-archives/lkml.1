Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbZI3BDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbZI3BDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 21:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbZI3BDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 21:03:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbZI3BDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 21:03:07 -0400
Message-ID: <4AC2AF01.9090202@redhat.com>
Date: Tue, 29 Sep 2009 21:06:09 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [RFC PATCH tracing/kprobes 0/5] tracing/kprobes, 	perf: perf
 kprobe support
References: <20090925191424.12939.91503.stgit@omoto>
In-Reply-To: <20090925191424.12939.91503.stgit@omoto>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
>
> Hi,
>
> These patches introduce perf kprobe command and update kprobe-tracer.
> perf kprobe command allows you to add new probe points by C line number
> and local variable names.

Last week, Arnaldo and I talked about this command, and he suggested that
the command would be better 'perf probe', because it would be able to
cover both of kernel space (by kprobes) and user space (by uprobes).

Basically, I agree with his idea. But I think we may need to consider
more flexible syntax for that purpose before we support uprobes.
In this area, SystemTap has done big advance, we can see how many
varieties of syntax it has by 'man stapprobes'.

And also, it's hard to decide it without real uprobe-tracer (and uprobes
too!) implementation on ftrace. So, I think it is better to continue
using 'perf kprobe' in this time.

But it's worth to add to todo list. :)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

