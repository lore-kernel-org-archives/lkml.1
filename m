Return-Path: <linux-kernel-owner+w=401wt.eu-S933988AbXGLQbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988AbXGLQbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759548AbXGLQbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:31:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:56336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759086AbXGLQbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:31:40 -0400
Date: Thu, 12 Jul 2007 18:31:23 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070712163123.GL28613@v2.random>
References: <20070706222651.GG5777@v2.random> <20070708232031.GF12413810@sgi.com> <20070710101148.GJ1482@v2.random> <20070712001256.GI31489@sgi.com> <20070712111436.GG28613@v2.random> <20070712144449.GZ31489@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712144449.GZ31489@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 12:44:49AM +1000, David Chinner wrote:
> That's crap. Just because a machine has lots of memory does not
> make it OK to waste lots of memory.

It's not just wasted, it lowers overhead all over the place. Yes, the
benefit of wasting less pagecache may largely outweight the benefit of
having a larger page size, but if you've a lot of memory perhaps your
working set already fits in the cache, or perhaps you don't fit in the
cache regardless of the page size.
