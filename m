Return-Path: <linux-kernel-owner+w=401wt.eu-S965426AbXCUXHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426AbXCUXHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965410AbXCUXHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:07:12 -0400
Received: from waste.org ([66.93.16.53]:58314 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965426AbXCUXHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:07:10 -0400
Date: Wed, 21 Mar 2007 17:53:48 -0500
From: Matt Mackall <mpm@selenic.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Valdis.Kletnieks@vt.edu, Adam Litke <agl@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: pagetable_ops: Hugetlb character device example
Message-ID: <20070321225348.GO10459@waste.org>
References: <20070319200502.17168.17175.stgit@localhost.localdomain> <1174506228.21684.41.camel@localhost.localdomain> <200703211951.l2LJpVPS020364@turing-police.cc.vt.edu> <20070321222659.GJ2986@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321222659.GJ2986@holomorphy.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 03:26:59PM -0700, William Lee Irwin III wrote:
> On Wed, 21 Mar 2007 14:43:48 CDT, Adam Litke said:
> >> The main reason I am advocating a set of pagetable_operations is to
> >> enable the development of a new hugetlb interface.
> 
> On Wed, Mar 21, 2007 at 03:51:31PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > Do you have an exit strategy for the *old* interface?
> 
> Hello.
> 
> My exit strategy was to make hugetlbfs an alias for ramfs when ramfs
> acquired the necessary functionality until expand-on-mmap() was merged.
> That would've allowed rm -rf fs/hugetlbfs/ outright. A compatibility
> wrapper for expand-on-mmap() around ramfs once ramfs acquires the
> necessary functionality is now the exit strategy.

Can you describe what ramfs needs here in a bit more detail?

If it's non-trivial, I'd rather see any new functionality go into
shmfs/tmpfs, as ramfs has done a good job at staying a minimal fs thus
far.

-- 
Mathematics is the supreme nostalgia of our time.
