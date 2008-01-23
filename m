Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbYAWRzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbYAWRzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbYAWRy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:54:57 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:44882 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756507AbYAWRyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:54:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAIIOl0dMQWYq/2dsb2JhbACBV5AZnFE
Date: Wed, 23 Jan 2008 12:54:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, Jan Kiszka <jan.kiszka@siemens.com>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 19/20 -v5] Trace irq disabled critical timings
Message-ID: <20080123175446.GA24602@Krystal>
References: <20080123160236.969334052@goodmis.org> <20080123160444.197366580@goodmis.org> <20080123165353.GA12598@goodmis.org> <20080123171107.GB12598@goodmis.org> <20080123172712.GE18698@redhat.com> <Pine.LNX.4.58.0801231241090.13236@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801231241090.13236@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:54:14 up 80 days, 22:59,  5 users,  load average: 5.07, 4.16,
	2.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Wed, 23 Jan 2008, Frank Ch. Eigler wrote:
> > On Wed, Jan 23, 2008 at 12:11:07PM -0500, Steven Rostedt wrote:
> > > This patch adds latency tracing for critical timings
> > > (how long interrupts are disabled for).
> > > [...]
> >
> > Is there an opportunity here to share effort with latencytop, and
> > ideally to use markers as much as possible for these event hooks?
> 
> Well, I just found out about latencytop a couple of days ago when Arjan
> announced it. I took a quick look and it seems to be more of a general
> collection of information. This tracer pinpoints out specific maxes.
> Although I may be wrong (I have to admit, I haven't had the time to really
> look at what LatencyTop does, but I have been using this tracer in -rt for
> a number of years).
> 
> As for using markers, I just piggied back on top of lockdep, since it has
> the same hooks that I needed. If we were to replace them with markers,
> then I would say lockdep should use the markers too.
> 
> One thing about markers, only one probe may be allowed at a time. Perhaps
> we should fix this by using something like I did with the mcount hook.
> 

It's already in my -mm patches (multiple probes support). It's also in
my current LTTng patchset.

Mathieu

> -- Steve
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
