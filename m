Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbYI3ADV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbYI3ADV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 20:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYI3ADM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 20:03:12 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:62876 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYI3ADM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 20:03:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYEAKYE4UhMQWq+/2dsb2JhbACBZLslgWc
Date: Mon, 29 Sep 2008 20:03:07 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v10 Golden] Unified trace buffer
Message-ID: <20080930000307.GA2929@Krystal>
References: <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com> <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com> <20080929233539.GA31143@Krystal> <alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:02:17 up 117 days,  4:42,  9 users,  load average: 0.55, 0.75,
	0.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Mon, 29 Sep 2008, Mathieu Desnoyers wrote:
> 
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > You should have a look at mm/slob.c free_slob_page(). I think your page
> > free will generate a "bad_page" call due to mapping != NULL and mapcount
> > != 0. I just ran into this in my own code. :)
> 
> 
> Hi Mathieu!
> 
> Thanks! I must have been lucky some how not to trigger this :-/
> 

My guess is that you never free your buffers in your test cases. I don't
know if it was expected; probably not if your code is built into the
kernel.

Mathieu

> I'll add an update patch for this.
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
