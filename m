Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbXD0NiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbXD0NiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbXD0NiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:38:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42673 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbXD0NiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:38:09 -0400
Date: Fri, 27 Apr 2007 14:37:54 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427133754.GA4152@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Christoph Lameter <clameter@sgi.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
	Mel Gorman <mel@skynet.ie>,
	William Lee Irwin III <wli@holomorphy.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Badari Pulavarty <pbadari@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <20070426190438.3a856220.akpm@linux-foundation.org> <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org> <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com> <20070426235542.bad7035a.akpm@linux-foundation.org> <17969.55533.59287.509889@cargo.ozlabs.ibm.com> <4631E173.7000204@yahoo.com.au> <Pine.LNX.4.64.0704270507110.21003@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704270507110.21003@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 05:12:05AM -0700, Christoph Lameter wrote:
> Powerpc supports multiple pagesizes. Maybe we could make mmap use those 
> page sizes some day if we had a variable order page cache. Your stands on 
> the issue means that powerpc will be forever crippled and not be able to 
> use its full potential.

You can already mmap using different pagesize on ppc64.  A certain
infinibad adapter with interesting design choices requires 4k mappings
even on 64k kernels, and for some spu-related mappings on Cell we
want the same.  I'm no expert on the powerpc mmu, but I'd be surprised
if 64k pagecache mappings wouldn't work on 4k base page size kernels.

