Return-Path: <linux-kernel-owner+w=401wt.eu-S1763220AbZDHORy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763220AbZDHORy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933593AbZDHONt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:13:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40998 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580AbZDHONr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:13:47 -0400
Date: Wed, 8 Apr 2009 10:13:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, axboe@kernel.dk
Subject: Re: Multiple Tracers
In-Reply-To: <20090408135312.GR18581@elte.hu>
Message-ID: <alpine.DEB.2.00.0904081008230.2183@gandalf.stny.rr.com>
References: <1239197703.3359.25.camel@localhost.localdomain> <20090408135312.GR18581@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 8 Apr 2009, Ingo Molnar wrote:

> 
> * Steven Whitehouse <swhiteho@redhat.com> wrote:
> 
> > Hi,
> > 
> > A little while back I posted a RFC patch which added gfs2 glock 
> > tracing to blktrace. There was a suggestion that I should look 
> > instead at the generic tracing code and add a new tracer, but I've 
> > come up with a couple of issues along the way.
> > 
> > I think from what I can see that its only possible to run a single 
> > tracer at once, so running blktrace (for example) would preclude 
> > me from also tracing gfs2's glocks at the same time. Also, I can 
> > see no mechanism by which I could ensure the sequencing between 
> > the blktrace and glock traces other than exporting the blktrace 
> > sequence number, even if running multiple tracers at the same time 
> > was possible.
> 
> There's a recent addition: the EVENT_TRACE() facility. Would that 
> suit your purposes?
> 

A while ago I've been playing with the idea of alloing multple tracers. 
I've even kept the plugins to keep track of their own buffers, even though 
the real design only used one buffer.

After the creation of the EVENT_TRACE facility, I no longer see a true 
need for that feature.  Note, anything event enabled will be recorded by 
all tracers.

-- Steve

P.S. I'm currently traveling, and my Hotel has horrible internet service. 
The kind you have to wait 5 seconds to see what you typed :-(

So do not expect quick responses from me.
