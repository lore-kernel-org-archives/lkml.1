Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbZJSQTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbZJSQTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 12:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbZJSQTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 12:19:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbZJSQTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 12:19:13 -0400
Date: Mon, 19 Oct 2009 14:18:24 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf
	probe and kprobe-tracer bugfixes
Message-ID: <20091019161824.GA10449@ghostprotocols.net>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com> <20091019075103.GF17960@elte.hu> <20091019110055.GA5549@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019110055.GA5549@nowhere>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 19, 2009 at 01:00:57PM +0200, Frederic Weisbecker escreveu:
> On Mon, Oct 19, 2009 at 09:51:03AM +0200, Ingo Molnar wrote:
> > > So, what would you think about using -D (def) and -U (undef) ?
> > The simpest case should be no extra character at all:
> >   perf probe schedule
> Yeah, I really prefer that too.

/me too
 
> If you want more precision, it also means you have you code editor opened
> and want to set a precise point. Since you also have the absolute
> line directly displayed by your editor, you don't want to calculate the relative
> line but rather the absolute one.

Perhaps this should come with vim/emacs key bindings so that all this
gets hidden by just opening the source code and pressing
control+SOMEKEY?

- Arnaldo
