Return-Path: <linux-kernel-owner+w=401wt.eu-S1031474AbXEDSE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031474AbXEDSE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031470AbXEDSE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:04:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46198 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031425AbXEDSE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:04:57 -0400
Date: Fri, 4 May 2007 11:04:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 08/40] mm: kmem_cache_objsize
In-Reply-To: <1178301545.24217.56.camel@twins>
Message-ID: <Pine.LNX.4.64.0705041104110.23539@schroedinger.engr.sgi.com>
References: <20070504102651.923946304@chello.nl>  <20070504103157.215424767@chello.nl>
  <Pine.LNX.4.64.0705040932200.22033@schroedinger.engr.sgi.com>
 <1178301545.24217.56.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Peter Zijlstra wrote:

> > I could add a function that tells you how many object you could allocate 
> > from a slab without the page allocator becoming involved? It would count 
> > the object slots available on the partial slabs.
> 
> I need to know how many pages to reserve to allocate a given number of
> items from a given slab; assuming the partial slabs are empty. That is,
> I need a worst case upper bound.

Ok so you really need the number of objects per page? If you know the 
number of objects then you can calculate the pages needed which would be 
the maximum memory needed?
