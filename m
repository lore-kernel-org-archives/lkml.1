Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbZCFACR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbZCFACR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 19:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbZCFACA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 19:02:00 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:53632 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754371AbZCFAB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 19:01:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAFPyr0lMQW1W/2dsb2JhbACBTtZihAgG
Date: Thu, 5 Mar 2009 19:01:55 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: mrubin@google.com, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       "H. Peter Anvin" <hpa@zytor.com>, md@google.com,
       Tom Zanussi <tzanussi@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, ltt-dev@lists.casi.polymtl.ca,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Martin Bligh <mbligh@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ltt-dev] [RFC patch 29/41] LTTng menus
Message-ID: <20090306000155.GA17881@Krystal>
References: <20090305224728.947235917@polymtl.ca> <20090305225518.148142886@polymtl.ca> <49B061DA.1010908@oracle.com> <20090305234700.GA17212@Krystal> <49B0658D.1090706@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49B0658D.1090706@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:54:11 up 5 days, 20:20,  2 users,  load average: 1.09, 0.93,
	1.46
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> Mathieu Desnoyers wrote:
> > * Randy Dunlap (randy.dunlap@oracle.com) wrote:
> >> Mathieu Desnoyers wrote:
> >>
> >> <<attachment :(>>
> >>
> >>
> >> +menuconfig LTT
> >> +	bool "Linux Trace Toolkit Next Generation (LTTng)"
> >> +	depends on EXPERIMENTAL
> >> +	select MARKERS
> >> +	select TRACEPOINTS
> >> +	default y
> >>
> >> Not default 'y', please.
> >>
> > 
> > OK, so default n it is. But I plan to leave the main menu "sub-features" as
> > default y, given that people get the standard features when they choose
> > to enable the tracer. Hopefully this is ok ?
> 
> Sure, as long as it just enables viewing the menu and not adding
> code to a growing kernel.
> 

I want to be sure to understand your point. Would be following be OK ?

Menu [ ] Linux Trace Toolkit Next Generation (LTTng)  --->  (default n)

Within this menu, the following options enable various tracer modules,
some of which are typically needed, except in some very specific tracer
use :

< >   Linux Trace Toolkit Lock-Protected Data Relay (default n)
               (default y is planned to be used for the lockless data
               relay module, which is not posted as part of this patchset)
[ ]   Debug check for random access in ltt relay buffers (default n)
<*>   Linux Trace Toolkit Serializer (default y)
-*-   Linux Trace Toolkit Custom Serializer (default y)
-*-   Linux Trace Toolkit Trace Controller (default m)
<*>   Linux Trace Toolkit Tracer (default y)
[ ]   Align Linux Trace Toolkit Traces (default n, selected of
        !HAVE_EFFICIENT_UNALIGNED_ACCESS)
[ ]   Add event size field to LTT events for tracer debugging (default n)
<M>   Support logging events from userspace (default m)
[*]   Support trace extraction from crash dump (default y)
[*]   Linux Trace Toolkit Kprobes Support (default y)

I understand from your answer above that just enabling the "LTTng"
submenu should not activate any of these items, am I correct ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
