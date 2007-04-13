Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbXDMGzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbXDMGzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 02:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbXDMGzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 02:55:33 -0400
Received: from holomorphy.com ([66.93.40.71]:37373 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbXDMGzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 02:55:32 -0400
Date: Thu, 12 Apr 2007 23:55:45 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413065545.GQ2986@holomorphy.com>
References: <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EFB98.8050408@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461EFB98.8050408@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> Do a full pagetable walk, with all the associated locking from within
>> a systemtap script?  I'd be surprised.  Maybe if it's mostly hand-coded
>> in C, perhaps.  Then you just end up with the same thing, don't you?

On Fri, Apr 13, 2007 at 01:40:08PM +1000, Nick Piggin wrote:
> And my problem isn't with the hardcoded pagetable walker. Yeah, we'd
> probably still keep the pagetable callback walker thingy with Matt's
> associated cleanups (and my subsequent ones to clean it up more and
> move it to mm/): there are other in-kernel users for that anyway.
> The point is the proc API, and exposing random little parts of deep
> kernel internals that some people happen to find useful at the time.
> (which is why we have an incredible proliferation of these things).
> With systemtap scripts, you could walk pagetables and print *the exact
> page information you want*, or you could walk pfns, or LRU, or page_tree,
> or walk the page tree then the rmap structures. And you can selectively
> cull out items you don't care about if you only care about a subset of
> items, based on arbitrary criteria. And you can most likely do all that
> more efficiently than with a conglomeration of various /proc files
> (assuming they even provide what you want in the first place).

The EM guys are unwilling or unable for support-oriented reasons to
deal with anything but unmodified kernels as shipped by distros.


-- wli
