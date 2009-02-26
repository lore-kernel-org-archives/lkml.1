Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbZBZQhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbZBZQhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbZBZQh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:37:28 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:58806 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754958AbZBZQh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:37:28 -0500
Date: Thu, 26 Feb 2009 11:28:03 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Mel Gorman <mel@csn.ul.ie>, Lin Ming <ming.m.lin@intel.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 00/19] Cleanup and optimise the page allocator V2
In-Reply-To: <1235647139.16552.34.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0902261127230.17756@qirst.com>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie>  <1235639427.11390.11.camel@minggr>  <20090226110336.GC32756@csn.ul.ie> <1235647139.16552.34.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009, Pekka Enberg wrote:

> > > UDP-U-4k	-2%		0%		-2%
> >
> > Pekka, for this test was SLUB or the page allocator handling the 4K
> > allocations?
>
> The page allocator. The pass-through revert is not in 2.6.29-rc6 and I
> won't be sending it until 2.6.30 opens up.

The page allocator will handle allocs >4k. 4k itself is already buffered
since we saw tbench regressions if we passed 4k through.

