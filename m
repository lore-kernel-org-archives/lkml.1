Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbYIZVhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbYIZVhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYIZVhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:37:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61848 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbYIZVhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:37:15 -0400
Date: Fri, 26 Sep 2008 17:37:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Martin Bligh <mbligh@google.com>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v6] Unified trace buffer
In-Reply-To: <33307c790809261246o47148443j49fee9197d18a3f1@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0809261735230.21618@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org>  <20080925185236.244343232@goodmis.org>  <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>  <48DC406D.1050508@redhat.com>  <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> 
 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>  <1222455557.16700.285.camel@lappy.programming.kicks-ass.net> <33307c790809261246o47148443j49fee9197d18a3f1@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Sep 2008, Martin Bligh wrote:
> 
> What did you guys think of Mathieu's idea of sticking the buffer length
> in the header here, rather than using padding events? Seemed cleaner
> to me.
> 

OK, I just implemented the size field in the page struct. Seems to work 
well. I'm still keeping the padded event, so in the future, if we ever 
map these pages to userspace or files, these holes will have a type.

Will post later today, need to actually enter a real life for a bit.

-- Steve
