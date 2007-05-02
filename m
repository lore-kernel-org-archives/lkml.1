Return-Path: <linux-kernel-owner+w=401wt.eu-S1767025AbXEBUli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767025AbXEBUli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767026AbXEBUli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:41:38 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:38169 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767025AbXEBUlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:41:37 -0400
Date: Wed, 2 May 2007 16:36:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070502203627.GA18733@Krystal>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal> <20070502104413.GC4392@one.firstfloor.org> <20070502094707.4197ab7a.akpm@linux-foundation.org> <20070502172934.GA17782@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070502172934.GA17782@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 16:24:25 up 89 days, 10:31,  4 users,  load average: 1.22, 1.27, 1.55
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Wed, May 02, 2007 at 09:47:07AM -0700, Andrew Morton wrote:
> > > That doesn't constitute using it.
> > 
> > Andi, there was a huge amount of discussion about all this in September last
> > year (subjects: *markers* and *LTTng*). The outcome of all that was, I
> > believe, that the kernel should have a static marker infrastructure.
> 
> Only when it's actually useable.  A prerequisite for merging it is
> having an actual trace transport infrastructure aswell as a few actually
> useful tracing modules in the kernel tree.
> 
> Let this count as a vote to merge the markers once we have the infrastructure
> above ready, it'll be very useful then.

Hi Christoph,

The idea is the following : either we integrate the infrastructure for
instrumentation / data serialization / buffer management / extraction of
data to user space in multiple different steps, which makes code review
easier for you guys, or we bring the main pieces of the LTTng project
altogether with the Linux Kernel Markers, which would result in a bigger
change.

Based on the premise that discussing about logically distinct pieces of
infrastructure is easier and can be done more thoroughly when done
separately, we decided to submit the markers first, with the other
pieces planned in a near future.

I agree that it would be very useful to have the full tracing stack
available in the Linux kernel, but we inevitably face the argument :
"this change is too big" if we submit all LTTng modules at once or
the argument : "we want the whole tracing stack, not just part of it"
if we don't.

This is why we chose to push the tracing infrastructure chunk by chunk :
to make code review and criticism more efficient.

Regards,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
