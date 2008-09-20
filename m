Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbYITIaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbYITIaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 04:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbYITI35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 04:29:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49739 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYITI34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 04:29:56 -0400
Date: Sat, 20 Sep 2008 04:29:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Martin Bligh <mbligh@google.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "od Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
In-Reply-To: <33307c790809191519k7c1bcce7y3fa37efc23b0f9c@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0809200427070.9362@gandalf.stny.rr.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>  <20080919144258.ac787fdf.randy.dunlap@oracle.com>  <33307c790809191457y3ebffa28xa6d9ab6431554618@mail.gmail.com>  <20080919224109.GB4491@suse.de>
 <33307c790809191519k7c1bcce7y3fa37efc23b0f9c@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 19 Sep 2008, Martin Bligh wrote:

> >> Sorry, probably lots of implicit assumptions in there that I forgot to explain
> >
> > Ids for event types. Either allocated dynamically, if the tracer needs
> > new ids on each use, or statically assigned for others (like my fctrace
> > or Steven's ftrace, I believe). Should we have a reserved range / registry
> > for static allocation, maybe something like a very simple version of
> > devices.txt?
> 
> Sure, but it's per-tracer, so hopefully won't be a big problem (eg fctrace
> would have a different event-id namespace from blktrace)
> 

Right!

 We stated in our little meeting that the true event id association is 
buffer id / event id tuple. We will not be assigning ranges for events 
for specific tracers. Ftrace will not have its own range. The static ids 
are reserved for the static trace points and some various static trace 
types that the average kernel developer may use.

Think "string event type" for a event type that will simply hold an ASCII 
string.

-- Steve

