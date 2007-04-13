Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbXDMOIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbXDMOIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 10:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbXDMOIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 10:08:46 -0400
Received: from thunk.org ([69.25.196.29]:46119 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbXDMOIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 10:08:46 -0400
Date: Fri, 13 Apr 2007 10:08:27 -0400
From: Theodore Tso <tytso@mit.edu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413140827.GA8864@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	William Lee Irwin III <wli@holomorphy.com>,
	Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
References: <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EFB98.8050408@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461EFB98.8050408@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 01:40:08PM +1000, Nick Piggin wrote:
> With systemtap scripts, you could walk pagetables and print *the exact
> page information you want*, or you could walk pfns, or LRU, or page_tree,
> or walk the page tree then the rmap structures. And you can selectively
> cull out items you don't care about if you only care about a subset of
> items, based on arbitrary criteria. And you can most likely do all that
> more efficiently than with a conglomeration of various /proc files
> (assuming they even provide what you want in the first place).

Yes, but maintaining the systemtap scripts will be a nightmare, since
they would be outside the kernel, and as we change our internal data
structure, the scripts would become useless.

This is a fundamental problem with systemtap that we haven't been able
to solve yet, because solving it would freeze various internal data
structures or kernel functions.  I agree that's not acceptable; which
is why I don't think systemtap would be a good match for the problem
we're trying to solve here.

						- Ted
