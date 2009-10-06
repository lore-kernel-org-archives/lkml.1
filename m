Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbZJFAOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbZJFAOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbZJFAOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:14:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61254 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbZJFAOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:14:53 -0400
Subject: Re: [PATCH tracing/kprobes v2 1/5] tracing/kprobes: Rename special
 variables syntax
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20091005192609.GB6071@nowhere>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com>
	 <4ACA25D5.10703@redhat.com>  <20091005192609.GB6071@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 05 Oct 2009 20:12:53 -0400
Message-Id: <1254787973.13160.195.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 21:26 +0200, Frederic Weisbecker wrote:
> On Mon, Oct 05, 2009 at 12:59:01PM -0400, Masami Hiramatsu wrote:
> > As far as I can see in arch/*/include/asm/ptrace.h, all registers start with
> > alphabets :-). So, I'd like to suggest renaming sp-vars to '_sp-vars'.
> >
> > Then, we will have;
> > - $local-vars
> 
> 
> There is a risk of bash collision.

I actually prefer the "$" notation. As for bash collision, it is common
for shell script writers to be able to distinguish a variable from bash.
Yes we can backslash it, or quote it. But when I see a $var it sticks
out to me that it is a variable. It's not hard to get around. For
example, type:

$ echo "hello $DISPLAY"' or $DISPLAY'

and see what you get.

Makefiles and Perl use '$' for variables those that need to handle it
with bash can easily cope with it.

So my vote is to keep the '$'. It is the most intuitive to what it
means.

Just my 0.02¤

-- Steve



