Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbXEKRqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbXEKRqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 13:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762216AbXEKRqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 13:46:31 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60063 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758371AbXEKRqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 13:46:30 -0400
Date: Fri, 11 May 2007 10:46:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
Subject: Re: [Bug 8464] New: autoreconf: page allocation failure. order:2,
 mode:0x84020
In-Reply-To: <20070511173811.GA8529@skynet.ie>
Message-ID: <Pine.LNX.4.64.0705111041080.8731@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705101510500.13404@schroedinger.engr.sgi.com>
 <20070510221607.GA15084@skynet.ie> <Pine.LNX.4.64.0705101522250.13504@schroedinger.engr.sgi.com>
 <20070510224441.GA15332@skynet.ie> <Pine.LNX.4.64.0705101547020.14064@schroedinger.engr.sgi.com>
 <20070510230044.GB15332@skynet.ie> <Pine.LNX.4.64.0705101601220.14471@schroedinger.engr.sgi.com>
 <1178863002.24635.4.camel@rousalka.dyndns.org> <20070511090823.GA29273@skynet.ie>
 <1178884283.27195.1.camel@rousalka.dyndns.org> <20070511173811.GA8529@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, Mel Gorman wrote:

> Excellent. I am somewhat suprised by the result so I'd like to look at the
> alternative option with kswapd as well. Could you put that patch back in again
> please and try the following patch instead? The patch causes kswapd to reclaim
> at higher orders if it's requested to.  Christoph, can you look at the patch
> as well and make sure it's doing the right thing with respect to SLUB please?

Well this gives the impression that SLUB depends on larger orders. It 
*can* take advantage of higher order allocations. No must. It may be a 
performance benefit to be able to do higher order allocs though (it is not 
really established yet what kind of tradeoffs there are).

Looks fine to me. If this is stable then I want this to be merged ASAP 
(deal with the issues later???) .... Good stuff.
