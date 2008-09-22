Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbYIVDL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbYIVDL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 23:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYIVDLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 23:11:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35548 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYIVDLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 23:11:17 -0400
Date: Mon, 22 Sep 2008 12:09:37 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: Unified tracing buffer
Cc: kosaki.motohiro@jp.fujitsu.com, Steven Rostedt <rostedt@goodmis.org>,
       Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
In-Reply-To: <20080920135548.GB23215@Krystal>
References: <alpine.DEB.1.10.0809200451420.9362@gandalf.stny.rr.com> <20080920135548.GB23215@Krystal>
Message-Id: <20080922120656.13D1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > CONTROL
> > > -------
> > > 
> > > Sysfs style tree under debugfs
> > > 
> > > /debugfs/tracing/<name>/buffers/enabed         <--- binary value
> > > 
> > > /debugfs/tracing/<name>/<event1>
> > > /debugfs/tracing/<name>/<event2>
> > >     etc ...
> > 
> > I wonder if we should make this another sub dir:
> > 
> >  /debugfs/tracing/buffers/events/<event-name>
> > 
> 
> Sure.
> 
> If needed, we could change the markers to take two separate parameters :
> 
> trace_mark(tracer_name, event_name, "format", args)

Sorry, disagreed.

I believe any marker point should be independent to tracer.
Otherwise, number of trace_mark() will blow up easily.



