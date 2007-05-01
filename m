Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbXEAIzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbXEAIzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbXEAIzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:55:16 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714AbXEAIzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:55:13 -0400
Date: Tue, 1 May 2007 01:54:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>, Andrea Arcangeli <andrea@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.22 -mm merge plans -- vm bugfixes
Message-Id: <20070501015422.4b54a5d0.akpm@linux-foundation.org>
In-Reply-To: <4636FDD7.9080401@yahoo.com.au>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<4636FDD7.9080401@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2007 18:44:07 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> >  mm-simplify-filemap_nopage.patch
> >  mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
> >  mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
> >  mm-merge-nopfn-into-fault.patch
> >  convert-hugetlbfs-to-use-vm_ops-fault.patch
> >  mm-remove-legacy-cruft.patch
> >  mm-debug-check-for-the-fault-vs-invalidate-race.patch
> 
> >  mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
> 
> > Miscish MM changes.  Will merge, dependent upon what still applies and works
> > if the moveable-zone patches get stalled.
> 
> These fix some bugs in the core vm, at least the former one we have
> seen numerous people hitting in production...
> 
> I don't suppose you mean these are logically dependant on new features
> sitting below them in your patch stack, just that you don't want to
> spend time fixing a lot of rejects?

It'll probably be OK - I just haven't checked yet.  I'm fairly handy at
fixing rejects nowadays ;)


Nobody seems to be taking up this opportunity to provide us with review
and test results on the antifrag patches.

