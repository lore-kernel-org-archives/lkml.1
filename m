Return-Path: <linux-kernel-owner+w=401wt.eu-S1767232AbXEBXWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767232AbXEBXWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767231AbXEBXWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:22:00 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767223AbXEBXV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 19:21:59 -0400
Date: Wed, 2 May 2007 16:21:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-Id: <20070502162135.f949e371.akpm@linux-foundation.org>
In-Reply-To: <20070502231104.GA26045@Krystal>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<p733b2gzqkg.fsf@bingen.suse.de>
	<20070501220803.GA27698@Krystal>
	<20070502104413.GC4392@one.firstfloor.org>
	<20070502094707.4197ab7a.akpm@linux-foundation.org>
	<20070502172934.GA17782@infradead.org>
	<20070502203627.GA18733@Krystal>
	<20070502135336.6d6d3569.akpm@linux-foundation.org>
	<20070502231104.GA26045@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 19:11:04 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > I didn't know that this was the plan.
> > 
> > The problem I have with this is that once we've merged one part, we're
> > committed to merging the other parts even though we haven't seen them yet.
> > 
> > What happens if there's a revolt over the next set of patches?  Do we
> > remove the core markers patches again?  We end up in a cant-go-forward,
> > cant-go-backward situation.
> > 
> > I thought the existing code was useful as-is for several projects, without
> > requiring additional patching to core kernel.  If such additional patching
> > _is_ needed to make the markers code useful then I agree that we should
> > continue to buffer the markers code in -mm until the
> > use-markers-for-something patches have been eyeballed.
> > 
> 
> My statement was probably not clear enough. The actual marker code is
> useful as-is without any further kernel patching required : SystemTAP is
> an example where they use external modules to load probes that can
> connect either to markers or through kprobes. LTTng, in its current state,
> has a mostly modular core that also uses the markers.

OK, that's what I thought.

> Although some, like Christoph and myself, think that it would benefit to
> the kernel community to have a common infrastructure for more than just
> markers (meaning common serialization and buffering mechanism), it does
> not change the fact that the markers, being in mainline, are usable by
> projects through additional kernel modules.
> 
> If we are looking at current "potential users" that are already in
> mainline, we could change blktrace to make it use the markers.

That'd be a useful demonstration.
