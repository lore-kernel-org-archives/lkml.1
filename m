Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbZCDOv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbZCDOv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZCDOvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 09:51:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47361 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbZCDOvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 09:51:38 -0500
Date: Wed, 4 Mar 2009 09:51:34 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Subject: Re: [PATCH 0/5] [RFC] binary reading of ftrace ring buffers
In-Reply-To: <20090304102640.GB31239@elte.hu>
Message-ID: <alpine.DEB.2.00.0903040949070.7995@gandalf.stny.rr.com>
References: <20090304024921.153061228@goodmis.org> <20090304102640.GB31239@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009, Ingo Molnar wrote:
> > 
> >  The splice C code:
> >    http://www.kernel.org/pub/linux/kernel/people/rostedt/splice.c
> > 
> >  The perl script to parse:
> >    http://www.kernel.org/pub/linux/kernel/people/rostedt/rb-read.pl
> > 
> >  And yes I know, they are both ugly :-p
> 
> Any chance of merging them into a single perl script? I.e. the 
> perl script would embedd the .c code and build it on every 
> invocation (into /tmp), so that one can do single-tool tracing 
> with no immediate binary components. Such self-sufficiency is 
> very handy when probing systems in a minimally invasive way.
> 
> And we could also have twice the ugliness for the same price.
> 

Gag, that would really be ugly code ;-)

If anything I might actually want to break up the perl script. This was 
just made to be an example. Any serious user would most likely write their 
own user apps. This was more of a proof of concept.

I could clean up that code, and then have one big file that does all the 
ugliness for those that just want to tinker with it. But that is low on 
the totem pole ;-)

-- Steve

