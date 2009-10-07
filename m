Return-Path: <linux-kernel-owner+w=401wt.eu-S933630AbZJGARf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbZJGARf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 20:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933327AbZJGARf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 20:17:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37440 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933302AbZJGARe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 20:17:34 -0400
Subject: Re: [PATCH tracing/kprobes v2 1/5] tracing/kprobes: Rename special
 variables syntax
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <4ACB52F6.7020106@redhat.com>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com>
	 <4ACA25D5.10703@redhat.com>  <20091005192609.GB6071@nowhere>
	 <1254787973.13160.195.camel@gandalf.stny.rr.com>
	 <4ACB52F6.7020106@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 06 Oct 2009 20:15:34 -0400
Message-Id: <1254874534.1696.43.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 10:23 -0400, Masami Hiramatsu wrote:
> Steven Rostedt wrote:
> > 
> 
> OK, so here are syntax ideas
> 
> * current syntax
> <Ftrace>
> - $sp_var
> - %regs
> - @symbol
> <Perf>
> - local_var
> 
> * $local syntax
> <Ftrace>
> - sp_var
> - %regs
> - @symbol
> <Perf>
> - $local_var
> 

I'm fine with either of the above. I don't like either of the below.

-- Steve

> * non $ syntax 1
> <Ftrace>
> - %sp_var
> - %regs
> - @symbol
> <Perf>
> - local_var
> 
> * non $ syntax 2
> <Ftrace>
> - %%sp_var or %@sp_var
> - %regs
> - @symbol
> <Perf>
> - local_var
> 
> So, which one do you like to use? :-)
> 
> Thank you,
> 

