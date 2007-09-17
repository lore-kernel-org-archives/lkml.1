Return-Path: <linux-kernel-owner+w=401wt.eu-S932216AbXIQW2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbXIQW2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbXIQW20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:28:26 -0400
Received: from ns2.suse.de ([195.135.220.15]:43732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbXIQW20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:28:26 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH]  2.6.23-rc6:  Fix NUMA Memory Policy Reference Counting
Date: Tue, 18 Sep 2007 00:28:19 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       clameter@sgi.com, eric.whitney@hp.com, Mel Gorman <mel@csn.ul.ie>
References: <20070830185053.22619.96398.sendpatchset@localhost> <1190057534.5460.131.camel@localhost>
In-Reply-To: <1190057534.5460.131.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709180028.19462.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Handling policy ref counts for hugepages is a bit trickier.
> huge_zonelist() returns a zone list that might come from a 
> shared or vma 'BIND policy.  In this case, we should hold the
> reference until after the huge page allocation in 
> dequeue_hugepage().  The patch modifies huge_zonelist() to
> return a pointer to the mempolicy if it needs to be unref'd
> after allocation.

Acked-by: Andi Kleen <ak@suse.de>

Andrew, can you please queue that for .23?

-Andi
