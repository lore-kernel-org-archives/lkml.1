Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbYI0RSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbYI0RSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYI0RSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:18:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47146 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbYI0RSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:18:05 -0400
Date: Sat, 27 Sep 2008 13:18:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v5] Unified trace buffer
In-Reply-To: <20080927170225.GJ4600@elte.hu>
Message-ID: <alpine.DEB.1.10.0809271314160.10238@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
 <20080926173130.GE15446@ghostprotocols.net> <alpine.LFD.1.10.0809261036420.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809261346040.21618@gandalf.stny.rr.com> <20080927170225.GJ4600@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 27 Sep 2008, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Subject: [RFC PATCH 2/2 v3] ftrace: make work with new ring buffer
> >
> > Note: This patch is a proof of concept, and breaks a lot of 
> > functionality of ftrace.
> >
> > This patch simply makes ftrace work with the developmental ring 
> > buffer.
> 
> ... to not have known bugs, so that we could try it in tip/ftrace and 
> make sure it works well in practice?
> 
> it's a ton of changes already, it would be nice to get to some stable 
> known-working state and do delta patches from that point on, and keep 
> its 'works well' quality.

OK, the patch that I was using was against Linus's tree. I'll port it over 
to linux-tip on Monday and get it past the "proof of concept" stage. 
Actually, the verison I have on my desk works pretty well. The main issues 
to solve is that some other tracers and the self test stick their noses 
into the buffering system, which would need to be fixed.

There's also some bugs in the status numbers printed in the latency_trace 
header. But I have not hit any bugs with the buffering itself.

I'll clean all this up and send out a patch on Monday. My wife is 
mandating that I do not do anymore work over the weekend ;-)

-- Steve

