Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbZDPSXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbZDPSXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 14:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbZDPSXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 14:23:40 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:52814 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824AbZDPSXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 14:23:40 -0400
Date: Thu, 16 Apr 2009 20:25:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 4/4] tracing/events: add trace-events-sample
Message-ID: <20090416182543.GD5377@uranus.ravnborg.org>
References: <20090415031511.128139334@goodmis.org> <20090415031605.445499740@goodmis.org> <20090416165849.GF5933@lst.de> <alpine.DEB.2.00.0904161331050.20429@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904161331050.20429@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 01:34:46PM -0400, Steven Rostedt wrote:
> 
> On Thu, 16 Apr 2009, Christoph Hellwig wrote:
> 
> > On Tue, Apr 14, 2009 at 11:15:15PM -0400, Steven Rostedt wrote:
> > > +++ b/samples/trace_events/Makefile
> > > @@ -0,0 +1,8 @@
> > > +# builds the trace events example kernel modules;
> > > +# then to use one (as root):  insmod <module_name.ko>
> > > +
> > > +PWD := $(shell pwd)
> > > +
> > > +CFLAGS_trace-events-sample.o := -I$(PWD)/samples/trace_events/
> > 
> > CFLAGS_trace-events-sample.o += -I$(src)
> 
> Is $(src) defined to be where the object is compiled?

$(src) is the path to the directory where the source files are
located. $(obj) is the path to the directory where the output
is located.
They are both relative to the root of the kernel tree and thus
they are equal. We have $(src) and $(obj) only for documentation
purposes today.

In this case $(src) is correct as we want to point at where the
source files are located.

	Sam
