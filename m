Return-Path: <linux-kernel-owner+w=401wt.eu-S1946148AbXBBXRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946148AbXBBXRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 18:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946151AbXBBXR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 18:17:29 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:49666 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946148AbXBBXR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 18:17:29 -0500
Date: Sat, 3 Feb 2007 10:16:47 +1100
From: David Chinner <dgc@sgi.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>,
       Andrew Morton <akpm@osdl.org>, "Martin J. Bligh" <mbligh@mbligh.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] mm: remove global locks from mm/highmem.c
Message-ID: <20070202231646.GB33919298@melbourne.sgi.com>
References: <1170063848.6189.121.camel@twins> <45BE9FE8.4080603@mbligh.org> <20070129174118.0e922ab3.akpm@osdl.org> <45BEA41A.6020209@mbligh.org> <20070129181557.d4d17dd0.akpm@osdl.org> <20070131004436.GS44411608@melbourne.sgi.com> <20070130171132.7be3b054.akpm@osdl.org> <20070131032224.GV44411608@melbourne.sgi.com> <20070202120511.GA25714@infradead.org> <20070202192440.GE16722@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202192440.GE16722@waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 01:24:40PM -0600, Matt Mackall wrote:
> On Fri, Feb 02, 2007 at 12:05:11PM +0000, Christoph Hellwig wrote:
> > On Wed, Jan 31, 2007 at 02:22:24PM +1100, David Chinner wrote:
> > > > Yup.  Even better, use clear_highpage().
> > > 
> > > For even more goodness, clearmem_highpage_flush() does exactly
> > > the right thing for partial page zeroing ;)
> > 
> > Note that there are tons of places in buffer.c that could use
> > clearmem_highpage_flush().  See the so far untested patch below:
> > 
> 
> You probably need s/memclear/clearmem/g..

Not needed - as usual, the code is right and the comments
are wrong. ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
