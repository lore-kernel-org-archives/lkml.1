Return-Path: <linux-kernel-owner+w=401wt.eu-S933190AbZJLTaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbZJLTaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933145AbZJLTaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:30:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933135AbZJLTaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:30:10 -0400
Message-ID: <4AD38476.9070306@redhat.com>
Date: Mon, 12 Oct 2009 15:33:10 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v3 1/7] tracing/kprobes: Add $ prefix
 to	special variables
References: <20091007222733.1684.32035.stgit@dhcp-100-2-132.bos.redhat.com> <20091007222740.1684.91170.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091007222740.1684.91170.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Add $ prefix to the special variables(e.g. sa, rv) of kprobe-tracer.
> This resolves consistency issue between kprobe_events and perf-kprobe.
>
> Signed-off-by: Masami Hiramatsu<mhiramat@redhat.com>
> Cc: Frederic Weisbecker<fweisbec@gmail.com>
> Cc: Ingo Molnar<mingo@elte.hu>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Arnaldo Carvalho de Melo<acme@redhat.com>
> Cc: Steven Rostedt<rostedt@goodmis.org>
> Cc: Mike Galbraith<efault@gmx.de>
> Cc: Paul Mackerras<paulus@samba.org>
> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Cc: Christoph Hellwig<hch@infradead.org>
> Cc: Ananth N Mavinakayanahalli<ananth@in.ibm.com>
> Cc: Jim Keniston<jkenisto@us.ibm.com>
> Cc: Frank Ch. Eigler<fche@redhat.com>
> ---
>
>   Documentation/trace/kprobetrace.txt |   20 ++++++------
>   kernel/trace/trace_kprobe.c         |   60 ++++++++++++++++++++++-------------
>   2 files changed, 47 insertions(+), 33 deletions(-)


Oops, I've forgotten to update self-test code...

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

