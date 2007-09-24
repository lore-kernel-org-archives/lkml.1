Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbXIXTFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbXIXTFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756138AbXIXTEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:04:55 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:36920 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755845AbXIXTEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:04:54 -0400
Date: Mon, 24 Sep 2007 15:04:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] Linux Kernel Markers (redux)
Message-ID: <20070924190452.GE28347@Krystal>
References: <20070924164950.006047409@polymtl.ca> <20070924181148.GA3285@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070924181148.GA3285@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:02:19 up 56 days, 19:21,  6 users,  load average: 0.38, 0.82, 1.01
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Mon, Sep 24, 2007 at 12:49:50PM -0400, Mathieu Desnoyers wrote:
> > Hi Andrew,
> > 
> > Following Christoph Hellwig's suggestion, aiming at a Linux Kernel Markers
> > inclusion for 2.6.24, I made a simplified version of the Linux Kernel Markers.
> > There are no more dependencies on any other patchset.
> > 
> > The modification only involved turning the immediate values into static
> > variables and adapting the documentation accordingly. It will have a little more
> > data cache impact when disabled than the version based on the immediate values,
> > but it is far less complex.
> > 
> > Since things have not moved much in the markers area recently (most of the
> > concerns were about the immediate values), I expect it to be ready for 2.6.24.
> 
> I've done a quick review and except for my usual nitpicking it looks
> very good to me.  I'll try my sputrace code with this version and will
> report on how it works.
> 
> I'd really love to see markers in 2.6.24.  The impact to core code of
> the actual markers is minimal with some more struct fields in functions
> in the module code, although we'll want Mathieu's fix for the modules
> list aswell which is a little more invasive.  But I think we want that
> one anyway.
> 

Well, since I just moved the marker iterators down in my patchset, I can
move down the module list fix altogether and keep it for later. It will
make the patchset as unintrusive as possible.

> I'd say we probably don't want the blktrace conversion that late in the
> game, though - but we can queue that once together with the optimizations
> from Mathieu's earlier patches in -mm.
> 

I provided blktrace as a first user of the markers, but I agree that it
may be a little late for merging. I can keep it for later too.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
