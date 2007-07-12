Return-Path: <linux-kernel-owner+w=401wt.eu-S935390AbXGLQgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935390AbXGLQgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765718AbXGLQfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:35:17 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46945 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764545AbXGLQfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:35:14 -0400
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       David Kleikamp <shaggy@us.ibm.com>
In-Reply-To: <20070712163123.GL28613@v2.random>
References: <20070706222651.GG5777@v2.random>
	 <20070708232031.GF12413810@sgi.com> <20070710101148.GJ1482@v2.random>
	 <20070712001256.GI31489@sgi.com> <20070712111436.GG28613@v2.random>
	 <20070712144449.GZ31489@sgi.com>  <20070712163123.GL28613@v2.random>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 09:34:57 -0700
Message-Id: <1184258097.26210.75.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 18:31 +0200, Andrea Arcangeli wrote:
> On Fri, Jul 13, 2007 at 12:44:49AM +1000, David Chinner wrote:
> > That's crap. Just because a machine has lots of memory does not
> > make it OK to waste lots of memory.
> 
> It's not just wasted, it lowers overhead all over the place. Yes, the
> benefit of wasting less pagecache may largely outweight the benefit of
> having a larger page size, but if you've a lot of memory perhaps your
> working set already fits in the cache, or perhaps you don't fit in the
> cache regardless of the page size.

Have you guys seen Shaggy's page cache tails?

http://kernel.org/pub/linux/kernel/people/shaggy/OLS-2006/kleikamp.pdf

We've had the same memory waste issue on ppc64 with 64k hardware
pages.  

-- Dave

