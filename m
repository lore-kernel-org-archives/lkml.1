Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbZBYFQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbZBYFQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 00:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbZBYFQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 00:16:43 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:49853 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbZBYFQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 00:16:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhQFAGpepElMQWWY/2dsb2JhbACBb9VphBEG
Date: Wed, 25 Feb 2009 00:16:38 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Message-ID: <20090225051638.GA27634@Krystal>
References: <20090225025608.956691460@goodmis.org> <20090225025753.798204550@goodmis.org> <20090224194548.3effb746.akpm@linux-foundation.org> <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com> <20090224203308.8d623e0b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090224203308.8d623e0b.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:15:12 up 3 days, 20:49,  2 users,  load average: 0.18, 0.37,
	0.38
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Tue, 24 Feb 2009 23:08:56 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > Gad, what a lot of stuff.
> > > 
> > > Use strncpy_from_user()?
> > > 
> > > Use strstrip()?
> > > 
> > > Why do we care about leading and trailing whitespace - user error!
> > 
> > This is because i want:
> > 
> >  cat available_events > set_event
> > 
> > to work.
> 
> :(
> 
> Why on earth do we keep on putting all these pretty-printers and
> pretty-parsers into the kernel?  I mean, how hard is it for userspace
> to read a text file, do some basic substitutions and print it out again?
> 

... or to read a binary buffer and format it in text, which is much more
efficient... :) If that's the kind of feature you are looking for, you
will probably like this aspect of the LTTng patchset. I should really,
really post it soon.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
