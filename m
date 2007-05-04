Return-Path: <linux-kernel-owner+w=401wt.eu-S1031508AbXEDS0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031508AbXEDS0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031509AbXEDS0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:26:45 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:8212 "EHLO
	amsfep14-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031508AbXEDS0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:26:43 -0400
Subject: Re: [PATCH 08/40] mm: kmem_cache_objsize
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0705041104110.23539@schroedinger.engr.sgi.com>
References: <20070504102651.923946304@chello.nl>
	 <20070504103157.215424767@chello.nl>
	 <Pine.LNX.4.64.0705040932200.22033@schroedinger.engr.sgi.com>
	 <1178301545.24217.56.camel@twins>
	 <Pine.LNX.4.64.0705041104110.23539@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 04 May 2007 20:21:44 +0200
Message-Id: <1178302904.2767.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 11:04 -0700, Christoph Lameter wrote:
> On Fri, 4 May 2007, Peter Zijlstra wrote:
> 
> > > I could add a function that tells you how many object you could allocate 
> > > from a slab without the page allocator becoming involved? It would count 
> > > the object slots available on the partial slabs.
> > 
> > I need to know how many pages to reserve to allocate a given number of
> > items from a given slab; assuming the partial slabs are empty. That is,
> > I need a worst case upper bound.
> 
> Ok so you really need the number of objects per page? If you know the 
> number of objects then you can calculate the pages needed which would be 
> the maximum memory needed?

Yes, that would work.



