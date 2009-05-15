Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbZEOXwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbZEOXwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 19:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbZEOXw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 19:52:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33739 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbZEOXw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 19:52:26 -0400
Date: Fri, 15 May 2009 19:52:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/3] tracing: add flag output for kmem events
In-Reply-To: <20090515234040.GB3645@localhost>
Message-ID: <alpine.DEB.2.00.0905151952081.3647@gandalf.stny.rr.com>
References: <20090515210342.488025506@goodmis.org> <20090515210718.211132919@goodmis.org> <20090515234040.GB3645@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 May 2009, Eduard - Gabriel Munteanu wrote:

> On Fri, May 15, 2009 at 05:03:45PM -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > This patch changes the output for gfp_flags from being a simple hex value
> > to the actual names.
> > 
> >   gfp_flags=GFP_ATOMIC  instead of gfp_flags=00000020
> > 
> > And even
> > 
> >   gfp_flags=GFP_KERNEL instead of gfp_flags=000000d0
> > 
> > [ Impact: more human readable output from tracer ]
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  include/trace/events/kmem.h |   43 +++++++++++++++++++++++++++++++++++--------
> >  1 files changed, 35 insertions(+), 8 deletions(-)
> 
> As long as it doesn't touch (and I see it doesn't) the raw kmemtrace
> output for kmemtrace-user, I'm okay with this sort of changes.
> 
> Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

Thanks!

I'll add you Ack to my next spin.

-- Steve

