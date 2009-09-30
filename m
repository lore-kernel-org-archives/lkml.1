Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbZI3O6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbZI3O6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbZI3O6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:58:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbZI3O6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:58:36 -0400
Date: Wed, 30 Sep 2009 11:57:58 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
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
Message-ID: <20090930145758.GL3361@ghostprotocols.net>
References: <20090925191424.12939.91503.stgit@omoto> <4AC2AF01.9090202@redhat.com> <20090930120418.GB7618@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930120418.GB7618@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 30, 2009 at 02:04:18PM +0200, Ingo Molnar escreveu:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > Masami Hiramatsu wrote:
> >>
> >> Hi,
> >>
> >> These patches introduce perf kprobe command and update kprobe-tracer.
> >> perf kprobe command allows you to add new probe points by C line number
> >> and local variable names.
> >
> > Last week, Arnaldo and I talked about this command, and he suggested 
> > that the command would be better 'perf probe', because it would be 
> > able to cover both of kernel space (by kprobes) and user space (by 
> > uprobes).
> 
> Agreed.
> 
> > Basically, I agree with his idea. But I think we may need to consider 
> > more flexible syntax for that purpose before we support uprobes. In 
> > this area, SystemTap has done big advance, we can see how many 
> > varieties of syntax it has by 'man stapprobes'.
> >
> > And also, it's hard to decide it without real uprobe-tracer (and 
> > uprobes too!) implementation on ftrace. So, I think it is better to 
> > continue using 'perf kprobe' in this time.
> >
> > But it's worth to add to todo list. :)
> 
> I'd still name it 'perf probe', even if initially it supports kprobes.

Agreed.

- Arnaldo
