Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbYA1MQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbYA1MQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbYA1MQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:16:06 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:35216 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbYA1MQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:16:04 -0500
Date: Mon, 28 Jan 2008 07:15:50 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 06/20 -v5] add notrace annotations for NMI routines
In-Reply-To: <479DC1AB.1060304@siemens.com>
Message-ID: <Pine.LNX.4.58.0801280714480.6930@gandalf.stny.rr.com>
References: <20080123160236.969334052@goodmis.org> <20080123160442.063076557@goodmis.org>
 <20080123213139.GB2282@Krystal> <Pine.LNX.4.58.0801260024270.11589@gandalf.stny.rr.com>
 <479DC1AB.1060304@siemens.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 28 Jan 2008, Jan Kiszka wrote:
> Steven Rostedt wrote:
> > On Wed, 23 Jan 2008, Mathieu Desnoyers wrote:
> >
> >> * Steven Rostedt (rostedt@goodmis.org) wrote:
> >>> This annotates NMI functions with notrace. Some tracers may be able
> >>> to live with this, but some cannot. So we turn off NMI tracing.
> >>>
> >>> One solution might be to make a notrace_nmi which would only turn
> >>> off NMI tracing if a trace utility needed it off.
> >>>
> >> Is this still needed with the atomic clocksource read ?
> >>
> >
> > Before you ask again, I've still included this in -v6, simply because I
> > didn't get a chance to test it without this patch. I'll try to remember to
> > do that on Monday.
>
> Only in case you finally have to keep the annotations for the posted
> tracer: Then please make it a Kconfig selectable restriction, because
> there are use cases of the mcount hook where you are interested in NMI
> invocations.

I've thought about adding a notrace_nmi which would do precisely that.
This week I'll take this patch out and turn on a bunch of nmi profiling
and see how it holds up.

Thanks,

-- Steve

