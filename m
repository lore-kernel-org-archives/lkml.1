Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbXCUXfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbXCUXfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbXCUXfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:35:34 -0400
Received: from holomorphy.com ([66.93.40.71]:60732 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbXCUXfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:35:34 -0400
Date: Wed, 21 Mar 2007 16:35:28 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Valdis.Kletnieks@vt.edu, Adam Litke <agl@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: pagetable_ops: Hugetlb character device example
Message-ID: <20070321233528.GL2986@holomorphy.com>
References: <20070319200502.17168.17175.stgit@localhost.localdomain> <1174506228.21684.41.camel@localhost.localdomain> <200703211951.l2LJpVPS020364@turing-police.cc.vt.edu> <20070321222659.GJ2986@holomorphy.com> <20070321225348.GO10459@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321225348.GO10459@waste.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 03:26:59PM -0700, William Lee Irwin III wrote:
>> My exit strategy was to make hugetlbfs an alias for ramfs when ramfs
>> acquired the necessary functionality until expand-on-mmap() was merged.
>> That would've allowed rm -rf fs/hugetlbfs/ outright. A compatibility
>> wrapper for expand-on-mmap() around ramfs once ramfs acquires the
>> necessary functionality is now the exit strategy.

On Wed, Mar 21, 2007 at 05:53:48PM -0500, Matt Mackall wrote:
> Can you describe what ramfs needs here in a bit more detail?
> If it's non-trivial, I'd rather see any new functionality go into
> shmfs/tmpfs, as ramfs has done a good job at staying a minimal fs thus
> far.

I was referring to fully-general multiple pagesize support. ramfs
would inherit the functionality by virtue of generic pagecache and TLB
handling in such an arrangement. It doesn't make sense to modify ramfs
as a special case; hugetlb is as it stands a ramfs special-cased for
such purposes.


-- wli
