Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbZCPQ7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbZCPQ7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbZCPQ6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:58:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50551 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbZCPQ6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:58:51 -0400
Date: Mon, 16 Mar 2009 16:58:48 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 23/35] Update NR_FREE_PAGES only as necessary
Message-ID: <20090316165848.GQ24293@csn.ul.ie>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-24-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903161214080.32577@qirst.com> <20090316164238.GK24293@csn.ul.ie> <alpine.DEB.1.10.0903161248130.13534@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903161248130.13534@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 12:48:25PM -0400, Christoph Lameter wrote:
> On Mon, 16 Mar 2009, Mel Gorman wrote:
> 
> > Replaced with
> >
> > __mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
> 
> A later patch does that also.
> 

Silly of me. That later patch is in the "controversial" pile but the
change is now moved back here where it belongs.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
