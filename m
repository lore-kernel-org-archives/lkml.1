Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbXJDScU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbXJDScU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757665AbXJDScG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:32:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43634 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbXJDScE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:32:04 -0400
Subject: Re: SLUB performance regression vs SLAB
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Matthew Wilcox <willy@linux.intel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20071004105046.7b019fe8@laptopd505.fenrus.org>
References: <20070919033605.785839297@sgi.com>
	 <200709280742.38262.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
	 <200709281514.48293.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0710011343020.19779@schroedinger.engr.sgi.com>
	 <20071004161621.GO12049@parisc-linux.org>
	 <Pine.LNX.4.64.0710041034550.10854@schroedinger.engr.sgi.com>
	 <20071004105046.7b019fe8@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Thu, 04 Oct 2007 20:26:12 +0200
Message-Id: <1191522372.5574.39.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-10-04 at 10:50 -0700, Arjan van de Ven wrote:
> On Thu, 4 Oct 2007 10:38:15 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> 
> > Yeah the fastpath vs. slow path is not the issue as Siddha and I
> > concluded earlier. Seems that we are mainly seeing cacheline bouncing
> > due to two cpus accessing meta data in the same page struct. The
> > patches in MM that are scheduled to be merged for .24 address 
> 
> 
> Ok every time something says anything not 100% positive about SLUB you
> come back with "but it's fixed in the next patch set"... *every time*.
> 
> To be honest, to me that sounds that SLUB isn't ready for prime time
> yet, or at least not ready to be the only one in town...
> 
> The day that the answer is "the kernel.org slub is fixing all the
> issues" is when it's ready..

Arjan, to be honest, there has been some confusion on _what_ code has
been tested with what results. And with Christoph not able to reproduce
these results locally, it is very hard for him to fix it proper.



