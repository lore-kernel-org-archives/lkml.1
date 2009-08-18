Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbZHRQxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbZHRQxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759465AbZHRQxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:53:48 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60892 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759453AbZHRQxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:53:38 -0400
Date: Tue, 18 Aug 2009 17:53:41 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] Reduce searching in the page allocator
	fast-path
Message-ID: <20090818165340.GB13435@csn.ul.ie>
References: <1250594162-17322-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0908181019130.32284@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0908181019130.32284@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 10:22:01AM -0400, Christoph Lameter wrote:
> 
> This could be combined with the per cpu ops patch that makes the page
> allocator use alloc_percpu for its per cpu data needs. That in turn would
> allow the use of per cpu atomics in the hot paths, maybe we can
> get to a point where we can drop the irq disable there.
> 

It would appear that getting rid of IRQ disabling and using per-cpu-atomics
would be a problem independent of searching the free lists. Either would
be good, both would be better or am I missing something that makes them
mutually exclusive?

Can you point me to which patchset you are talking about specifically that
uses per-cpu atomics in the hot path? There are a lot of per-cpu patches
related to you that have been posted in the last few months and I'm not sure
what any of their merge status' is.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
