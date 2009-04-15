Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbZDOCUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbZDOCUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZDOCTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:19:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37810 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZDOCTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:19:54 -0400
Date: Tue, 14 Apr 2009 22:19:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 3/8] tracing: make trace_seq operations available for
 core kernel
In-Reply-To: <1239736327.22720.239.camel@laptop>
Message-ID: <alpine.DEB.2.00.0904142217300.31421@gandalf.stny.rr.com>
References: <20090414172337.280621613@goodmis.org>  <20090414172640.993528505@goodmis.org> <1239736327.22720.239.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Apr 2009, Peter Zijlstra wrote:

> On Tue, 2009-04-14 at 13:23 -0400, Steven Rostedt wrote:
> > +struct trace_seq {
> > +       unsigned char           buffer[PAGE_SIZE];
> > +       unsigned int            len;
> > +       unsigned int            readpos;
> > +};
> 
> Would not PAGE_SIZE-2*sizeof(int) be enough? That would make the struct
> fit into a single page and avoid an order-1 allocation.

That may be an option. I've even thought about doing that before. Not sure 
why I did not. But we could give it a try.

-- Steve

