Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYAWV3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYAWV3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 16:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbYAWV3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 16:29:37 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:52381 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814AbYAWV3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 16:29:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAPI/l0dMQWYq/2dsb2JhbACBV5AZnD4
Date: Wed, 23 Jan 2008 16:29:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, Jan Kiszka <jan.kiszka@siemens.com>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 19/20 -v5] Trace irq disabled critical timings
Message-ID: <20080123212933.GA2282@Krystal>
References: <20080123160236.969334052@goodmis.org> <20080123160444.197366580@goodmis.org> <20080123165353.GA12598@goodmis.org> <20080123171107.GB12598@goodmis.org> <20080123172712.GE18698@redhat.com> <1201111103.6341.73.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1201111103.6341.73.camel@lappy>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:28:23 up 81 days,  2:33,  5 users,  load average: 0.52, 0.25,
	0.13
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> 
> On Wed, 2008-01-23 at 12:27 -0500, Frank Ch. Eigler wrote:
> > Hi -
> > 
> > On Wed, Jan 23, 2008 at 12:11:07PM -0500, Steven Rostedt wrote:
> > > This patch adds latency tracing for critical timings
> > > (how long interrupts are disabled for).
> > > [...]
> > 
> > Is there an opportunity here to share effort with latencytop, and
> > ideally to use markers as much as possible for these event hooks?
> 
> I'm still thinking latencytop should only record stack traces and do the
> rest in user-space. 
> 
> Also, the things the latency tracer and latecytop measure are quite
> different. the latency tracer measures how long a non-schedulable
> section is, latencytop measures how a task was scheduled away.

Hrm, if it's really the only thing latencytop is doing.. ever thought
about trying LTTng ? ;) A simple plugin could be written in lttv to
perform this kind of analysis.

Mathieu

> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
