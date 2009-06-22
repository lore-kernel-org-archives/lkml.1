Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZFVT6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZFVT6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZFVT6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:58:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49938 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbZFVT6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:58:44 -0400
Date: Mon, 22 Jun 2009 20:58:45 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] profile: Suppress warning about large allocations when
	profile=1 is specified
Message-ID: <20090622195845.GF3981@csn.ul.ie>
References: <20090616223649.719ea378.akpm@linux-foundation.org> <20090617111800.GA15261@elte.hu> <20090617113120.GA5061@elte.hu> <20090617113534.GA21276@elte.hu> <20090617121913.GC28529@csn.ul.ie> <20090620100932.GA5863@fancy-poultry.org> <20090620195000.GC10878@csn.ul.ie> <20090620214835.GA6528@fancy-poultry.org> <20090622113104.GD3981@csn.ul.ie> <20090622135014.GA7776@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090622135014.GA7776@fancy-poultry.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 03:50:14PM +0200, Heinz Diehl wrote:
> On 22.06.2009, Mel Gorman wrote: 
> 
> > I have no idea why the stack trace is so badly managed but the problem appears
> > to be in DCCP so can you try the patch below please? It applies on top of the
> > profile=1 patch fix. If it works for you, I'll split out the patch properly
> > into three separate patches and repost.
> 
> This patch, on top of your "profile=1" fix and applied to -git17, 
> does indeed fix the problem for me.
> 

Thanks for testing. I've posted a split-out set so this should get
ironed out over the next while.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
