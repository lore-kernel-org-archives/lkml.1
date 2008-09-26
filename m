Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYIZKri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYIZKri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbYIZKra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:47:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55017 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYIZKra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:47:30 -0400
Date: Fri, 26 Sep 2008 06:47:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH v4] Unified trace buffer
In-Reply-To: <1222413507.16700.235.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0809260646200.17102@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org>  <20080925185236.244343232@goodmis.org>  <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>  <48DC406D.1050508@redhat.com>  <alpine.DEB.1.10.0809252206260.8454@gandalf.stny.rr.com>  <20080926032045.GA28771@Krystal>
 <1222413507.16700.235.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Sep 2008, Peter Zijlstra wrote:
> > 
> > You could also fallback on a 2-level page array when buffer size is >
> > 64MB. The cost is mainly a supplementary pointer dereference, but one
> > more should not make sure a big difference overall.
> 
> I'm still not sure why we don't just link the pages using the page
> frames, we don't need the random access, do we?


Hmm, but this does make changing the buffer size much easier. I'll think 
about it  and perhaps try it out. If I can tidy it up nicer than the 
ftrace code, then I may include it for v1.

-- Steve

