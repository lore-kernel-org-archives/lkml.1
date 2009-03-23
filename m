Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbZCWO7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbZCWO7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZCWO7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:59:25 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45486 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbZCWO7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:59:24 -0400
Date: Mon, 23 Mar 2009 14:59:21 +0000
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
Message-ID: <20090323145921.GC15416@csn.ul.ie>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903201059240.3740@qirst.com> <20090320153723.GO24586@csn.ul.ie> <alpine.DEB.1.10.0903201205260.18010@qirst.com> <20090320162716.GP24586@csn.ul.ie> <alpine.DEB.1.10.0903201503040.11746@qirst.com> <20090323115213.GC6484@csn.ul.ie> <alpine.DEB.1.10.0903230929440.7254@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903230929440.7254@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 09:30:26AM -0400, Christoph Lameter wrote:
> On Mon, 23 Mar 2009, Mel Gorman wrote:
> 
> > This came up again. There was some evidence when it was introduced that
> > it worked and micro-benchmarks can show it to be of some use. It's
> > not-obvious-enough that I'd be wary of deleting it.
> 
> Certainly there is some minimal benefit. But maybe that benefit will
> vanish if you drop the doubly linked list?
> 

Extremely difficult to tell. It only makes a difference if you are not
over a cache-line boundary using a singly linked list. If the structure
is within a cache-line boundary with either single or double linked
lists, it probably makes no measurable difference.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
