Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbZGQTph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbZGQTph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 15:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZGQTpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 15:45:36 -0400
Received: from www.tglx.de ([62.245.132.106]:52376 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbZGQTpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 15:45:36 -0400
Date: Fri, 17 Jul 2009 21:43:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <clark.williams@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, srostedt@redhat.com
Subject: Re: [ANNOUNCE][RFC] trace-cmd - command line reader for ftrace
In-Reply-To: <alpine.DEB.2.00.0907171009050.9337@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0907172140230.11571@localhost.localdomain>
References: <alpine.DEB.2.00.0907171009050.9337@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, Steven Rostedt wrote:
> Since using echo and cat can sometimes be annoying to set up the tracer, 
> I've been asked several times if I could come up with a tool to do it for 
> you. For the last few weeks I've been working on one. The most difficult 
> job was to parse out the "print_fmt" of the format files in the event.
> 
> This code is somewhat a proof of concept and is in alpha form. Although it 
> is still very functional and useful. I can imagine that this could also be 
> sucked into Ingo Molnar's "perf" utility.

That would be the first thing to do. Please integrate it with perf so
we have one "look into the kernel" tool instead of N different ones
with separate command line syntax and output style.

Thanks,

	tglx
