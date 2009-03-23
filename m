Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZCWLw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZCWLw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 07:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZCWLwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 07:52:17 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53813 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbZCWLwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 07:52:17 -0400
Date: Mon, 23 Mar 2009 11:52:14 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/25] Cleanup and optimise the page allocator V5
Message-ID: <20090323115213.GC6484@csn.ul.ie>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903201059240.3740@qirst.com> <20090320153723.GO24586@csn.ul.ie> <alpine.DEB.1.10.0903201205260.18010@qirst.com> <20090320162716.GP24586@csn.ul.ie> <alpine.DEB.1.10.0903201503040.11746@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903201503040.11746@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 03:43:23PM -0400, Christoph Lameter wrote:
> On Fri, 20 Mar 2009, Mel Gorman wrote:
> 
> > > Is it possible to go to a simple
> > > linked list (one cacheline to be touched)?
> >
> > I considered it but it breaks the hot/cold allocation/freeing logic and
> > the search code became weird enough looking fast enough that I dropped
> > it.
> 
> Maybe it would be workable if we drop the cold queue stuff (dubious
> anyways)?
> 

This came up again. There was some evidence when it was introduced that
it worked and micro-benchmarks can show it to be of some use. It's
not-obvious-enough that I'd be wary of deleting it.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
