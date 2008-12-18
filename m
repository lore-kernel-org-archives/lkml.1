Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752663AbYLRQ6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbYLRQ6V (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYLRQ6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:58:10 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:61767 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304AbYLRQ6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:58:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYEAP0OSklMROB9/2dsb2JhbACBbL1uWJBlgwY
Date: Thu, 18 Dec 2008 11:58:02 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ltt-dev@lists.casi.polymtl.ca, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ltt-dev] [PATCH] Simple LTTng userspace events through debugfs
Message-ID: <20081218165802.GA16072@Krystal>
References: <20081215231040.GA5936@Krystal> <20081216194201.GE843@elte.hu> <20081217041628.GA5409@Krystal> <20081217173223.GA32699@Krystal> <20081218085018.8bd1fd92.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081218085018.8bd1fd92.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:57:29 up 31 days, 17:37,  2 users,  load average: 2.53, 1.09,
	0.75
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> On Wed, 17 Dec 2008 12:32:24 -0500 Mathieu Desnoyers wrote:
> 
> > Index: linux-2.6-lttng/ltt/ltt-userspace-event.c
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6-lttng/ltt/ltt-userspace-event.c	2008-12-17 12:03:43.000000000 -0500
> > @@ -0,0 +1,129 @@
> > +
> > +/**
> > + * write_event: write a userspace string into the trace stream
> 
> Hi Mathieu,
> 
> Please make above line:
> 
>  * write_event - write a userspace string into the trace system
> 

That for the review,

I'll have to go through all the LTTng tree and fix the kerneldoc.

Mathieu

> Thanks.
> 
> > + * @file: file pointer
> > + * @user_buf: user string
> > + * @count: length to copy, including the final NULL
> > + * @ppos: unused
> > + *
> > + * Copy a string into a trace event, in channel "userspace", event "event".
> > + * Copies until either \n or \0 is reached.
> > + * On success, returns the number of bytes copied from the source, including the
> > + * \n or \0 character (if there was one in the count range). It cannot return
> > + * more than count.
> > + * Inspired from tracing_mark_write implementation from Steven Rostedt and
> > + * Ingo Molnar.
> > + */
> > +static ssize_t write_event(struct file *file, const char __user *user_buf,
> > +		size_t count, loff_t *ppos)
> > +{
> 
> 
> ---
> ~Randy
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
