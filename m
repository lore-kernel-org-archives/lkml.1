Return-Path: <linux-kernel-owner+w=401wt.eu-S1162066AbXECOt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162066AbXECOt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162064AbXECOt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:49:26 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:49755 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162067AbXECOtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:49:25 -0400
Date: Thu, 3 May 2007 10:49:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070503144925.GB26864@Krystal>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal> <20070502104413.GC4392@one.firstfloor.org> <20070502094707.4197ab7a.akpm@linux-foundation.org> <20070502172934.GA17782@infradead.org> <20070502203627.GA18733@Krystal> <20070502135336.6d6d3569.akpm@linux-foundation.org> <20070502231104.GA26045@Krystal> <20070503103148.GA18822@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070503103148.GA18822@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 10:43:30 up 90 days,  4:50,  4 users,  load average: 2.43, 2.29, 1.85
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

This plan makes sense. I will split the "patched in enabled/disable
flags" part into a separate piece (good idea!) and then submit the LTTng
core to Andrew. Christoph's has a good point about wanting a usable
infrastructure to go ini. Regarding your plan, I must argue that
blktrace is not a general purpose tracing infrastructure, but one
dedicated to block io tracing.  Therefore, it makes sense to bring in
the generic infrastructure first and then convert blktrace to it.

Mathieu

* Andi Kleen (andi@firstfloor.org) wrote:
> > If we are looking at current "potential users" that are already in
> > mainline, we could change blktrace to make it use the markers.
> 
> Ok, but do it step by step:
> - split out useful pieces like the "patched in enable/disable flags" 
> and submit them separate with an example user or two 
> [I got a couple of candidates e.g. with some of the sysctls in VM or 
> networking] 
> - post and merge that.
> - don't implement anything initially that is not needed by blktrace
> - post a minimal marker patch together with the blktrace
> conversion for review again on linux-kernel
> - await review comments. This review would not cover the basic
> need of markers, just the specific implementation.
> - then potentially merge incorporate review comments
> - then merge
> - later add features with individual review/discussion as new users in the 
> kernel are added.
> 
> -Andi

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
