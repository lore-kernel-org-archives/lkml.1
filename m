Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbZBXWcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbZBXWcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbZBXWcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:32:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54379 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbZBXWb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:31:59 -0500
Date: Tue, 24 Feb 2009 17:31:56 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/4][RFC] event tracer
In-Reply-To: <49A473ED.4010001@redhat.com>
Message-ID: <alpine.DEB.2.00.0902241731020.12697@gandalf.stny.rr.com>
References: <20090224193344.638329210@goodmis.org> <1235504556.4645.2252.camel@laptop> <alpine.DEB.2.00.0902241706260.12697@gandalf.stny.rr.com> <49A473ED.4010001@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 24 Feb 2009, Masami Hiramatsu wrote:
> > 
> > #undef TPFMT
> > #define TPFMT(fmt, args...) \
> > 	"(%s)" fmt "\n", #call, ##args
> > 
> > and then I could do
> > 
> > 	event_printk(fmt);
> 
> Why don't you do as below? :)
> 	event_printk_line("(" #call ")" ##fmtandargs);

Still need to sneak that "\n" in ;-)

> 
> Anyway, your proposal is good for me, because it will recover
> an information which tracepoint has lost.

Thanks,

-- Steve

