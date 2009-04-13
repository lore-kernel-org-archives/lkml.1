Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbZDMXvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbZDMXvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZDMXvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:51:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37779 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbZDMXvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:51:18 -0400
Date: Mon, 13 Apr 2009 19:51:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing, boottrace: Move include/trace/boot.h to
 include/linux/boottrace.h
In-Reply-To: <20090413234027.GH817@elte.hu>
Message-ID: <alpine.DEB.2.00.0904131950580.3041@gandalf.stny.rr.com>
References: <49E2B763.8060706@cn.fujitsu.com> <20090413142531.GC5977@nowhere> <20090413222436.GF8514@elte.hu> <alpine.DEB.2.00.0904131907020.3041@gandalf.stny.rr.com> <20090413232807.GE817@elte.hu> <alpine.DEB.2.00.0904131933110.3041@gandalf.stny.rr.com>
 <20090413234027.GH817@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 14 Apr 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Tue, 14 Apr 2009, Ingo Molnar wrote:
> > > 
> > > The sane thing would be to put event headers into 
> > > include/trace/events/ and put more generic/utility headers into 
> > > include/trace/.
> > > 
> > > Reserving a full subdirectory for one singular purpose is a needless 
> > > waste of a nice (and unique) name-space resource.
> > 
> > That's fine with me too. I just want the trace points to be easily 
> > seen. But by making a sub directory, wont we need to have all 
> > users of tracepoints do something like:
> > 
> > #include <trace/events/sched.h>
> > 
> > That might be fine too.
> 
> Yes - it would allow the dropping of the annoyingly repetitive 
> _event string from those definition files as well?

The coming patches for modules already does that ;-)

-- Steve

