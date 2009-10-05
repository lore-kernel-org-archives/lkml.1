Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZJEOze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZJEOze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 10:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZJEOzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 10:55:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbZJEOzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 10:55:33 -0400
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH tracing/kprobes v2 0/5] tracing/kprobes, 	perf: perf probe support take 2
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 05 Oct 2009 10:54:06 -0400
In-Reply-To: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> (Masami Hiramatsu's message of "Fri, 02 Oct 2009 17:48:34 -0400")
Message-ID: <y0mocolj3ht.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <mhiramat@redhat.com> writes:

> [...]
> These patches introduce 'perf probe' command and update kprobe-tracer. [...]
> Usage
> -----
>  perf probe [<options>] -P 'PROBEDEF' [-P 'PROBEDEF' ...]
> [...]
>     -k, --vmlinux <file>  vmlinux/module pathname
>     -r, --release <rel>   kernel release
> [...]

Can you outline a reason for the -r flag?  We use it in systemtap for
cross-compiling purposes, but I didn't think perf was interested in that.

- FChE
