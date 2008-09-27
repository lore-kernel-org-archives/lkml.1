Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYI0AXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYI0AXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 20:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYI0AXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 20:23:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33318 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYI0AX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 20:23:29 -0400
Date: Fri, 26 Sep 2008 20:23:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v6] Unified trace buffer
In-Reply-To: <alpine.LFD.1.10.0809261707320.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0809262022000.21618@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <20080926223129.GF15446@ghostprotocols.net> <alpine.DEB.1.10.0809261957001.21618@gandalf.stny.rr.com> <alpine.LFD.1.10.0809261707320.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Sep 2008, Linus Torvalds wrote:
> > I started using the rb_ because I was constantly breaking the 80 character 
> > line limit with ring_buffer ;-)   OK, for v8, I'll rename all static 
> > internal functions to rb_ and keep the global ones ring_buffer_
> 
> It would probably be better to use something else than 'rb_', because that 
> prefix is already used by the red-black trees, and exported as such (eg 
> "rb_next()" etc).

Good point.

> 
> But at least as long as it's static, it's probably not _too_ noticeable if 
> the rest of the names don't overlap. We _do_ include <linux/rbtree.h>  
> almost everywhere, since we use those things in the VM, in timers etc, so 
> it comes in through pretty much all headers.

Well, I just compiled it and it didn't have any name collisions, but that 
doesn't mean that this wont change in the future.

What would you suggest?  buffer_ ? ringbuf_ ?

-- Steve

