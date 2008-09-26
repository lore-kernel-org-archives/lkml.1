Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbYIZROd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbYIZROd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 13:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYIZRO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 13:14:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54775 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbYIZROZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 13:14:25 -0400
Date: Fri, 26 Sep 2008 13:14:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH v4] Unified trace buffer
In-Reply-To: <48DD1475.1090109@redhat.com>
Message-ID: <alpine.DEB.1.10.0809261312310.21618@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org>  <20080925185236.244343232@goodmis.org>  <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>  <48DC406D.1050508@redhat.com>  <alpine.DEB.1.10.0809252206260.8454@gandalf.stny.rr.com>  <20080926032045.GA28771@Krystal>
  <1222413507.16700.235.camel@lappy.programming.kicks-ass.net>  <alpine.DEB.1.10.0809260641590.17102@gandalf.stny.rr.com> <1222426855.16700.264.camel@lappy.programming.kicks-ass.net> <48DD1475.1090109@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Sep 2008, Masami Hiramatsu wrote:
> Peter Zijlstra wrote:
> >> I was going to reply to Masami with this answer, but it makes things more 
> >> complex.  For v1 (non RFC v1) I wanted to start simple. v2 can have this 
> >> enhancement.
> > 
> > Right - I just object to having anything vmalloc.
> 
> I just requested that the expansion of buffer size limitation too. :)
> 
> I don't stick with vmalloc. If that (page frame chain?) can
> achieve better performance, I agree that trace buffer uses it.
> 

v5 is out with this implementation. It may or may not be better 
performance, but the difference is most likely negligible.

Anyway, I'm happing with this last release, and hopefully it can get into
2.6.28.  This would mean I can start basing ftrace on top of it.

-- Steve

