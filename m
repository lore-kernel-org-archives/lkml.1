Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZBYOK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZBYOK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZBYOKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:10:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40728 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZBYOKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:10:12 -0500
Date: Wed, 25 Feb 2009 09:10:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Theodore Tso <tytso@mit.edu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
In-Reply-To: <20090225133740.GF7064@mit.edu>
Message-ID: <alpine.DEB.2.00.0902250909330.12697@gandalf.stny.rr.com>
References: <20090225025608.956691460@goodmis.org> <20090225025753.798204550@goodmis.org> <20090224194548.3effb746.akpm@linux-foundation.org> <20090225133740.GF7064@mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Feb 2009, Theodore Tso wrote:

> On Tue, Feb 24, 2009 at 07:45:48PM -0800, Andrew Morton wrote:
> > echo sched_wakeup > /debug/tracing/set_event
> > echo sched_wakeup > /debug/tracing/clear_event
> > echo 1 > /debug/tracing/clear_all_events
> 
> >From a usability point of view, I'd prefer this as well.  It's only
> two extra files, but it means that filenames in /deb/tracing is
> self-documenting, which is a good thing.  Otherwise, it's really not
> obvious that "echo !event > /debug/tracing/set_event" will disable the
> event, and it's *especially* not obvious "echo > /debug/tracing/set_event"
> will disable all events.
> 
> It's also a tad bit too easy to typo "echo > /debug/tracing/set_event"
> by editing command history, and hitting return a bit too soon after
> clearing out the previous event name but before you manage to type the
> new event name.

OK, then I guess I can add a clear_event file. And to clear all events 
simply do:

 # cat set_event > clear_event

-- Steve

