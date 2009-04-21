Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZDURWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZDURWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZDURVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:21:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbZDURVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:21:53 -0400
Date: Tue, 21 Apr 2009 13:21:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka@firstfloor.org
Subject: Re: [PATCH 2/8] tracing: create automated trace defines
In-Reply-To: <49EDFFE6.1080401@goop.org>
Message-ID: <alpine.DEB.2.00.0904211320440.10097@gandalf.stny.rr.com>
References: <20090414172337.280621613@goodmis.org> <20090414172640.796858018@goodmis.org> <49E51FC1.8090306@goop.org> <20090415014548.GA7984@Krystal> <49E6065B.7080409@goop.org> <20090416023456.GC22378@Krystal> <49E69E76.9030608@goop.org> <20090416234410.GA20513@Krystal>
 <87zlebpzmk.fsf@basil.nowhere.org> <20090421155106.GE3792@Krystal> <49EDFFE6.1080401@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Apr 2009, Jeremy Fitzhardinge wrote:

> Mathieu Desnoyers wrote:
> > * Andi Kleen (andi@firstfloor.org) wrote:
> >   
> > > Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:
> > > 
> > >     
> > > > Given how slow function calls are, at least on x86,
> > > >       
> > > That was with frame pointers right? Frame pointers tend to make
> > > function calls slow.
> > > 
> > >     
> > 
> > Looking at my .config, CONFIG_FRAME_POINTER is disabled here. So we
> > should probably expect an even worse performance impact if we enable
> > them.
> 
> I tried disabling frame pointers, but it looked to me like tracing selects
> them.  Did I misread, or perhaps it was some other config option doing it...

It is needed for the function tracer (gcc -pg wont work without it). It is 
the only tracer that selects it.

-- Steve

