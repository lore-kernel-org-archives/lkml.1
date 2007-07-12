Return-Path: <linux-kernel-owner+w=401wt.eu-S1760377AbXGLTbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377AbXGLTbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbXGLTbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:31:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753488AbXGLTbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:31:23 -0400
Date: Thu, 12 Jul 2007 12:29:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mel@skynet.ie (Mel Gorman)
Cc: npiggin@suse.de, kenchen@google.com, jschopp@austin.ibm.com,
       apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com,
       a.p.zijlstra@chello.nl, y-goto@jp.fujitsu.com, clameter@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans -- anti-fragmentation
Message-Id: <20070712122925.192a6601.akpm@linux-foundation.org>
In-Reply-To: <20070710102043.GA20303@skynet.ie>
References: <20070710102043.GA20303@skynet.ie>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 11:20:43 +0100
mel@skynet.ie (Mel Gorman) wrote:

> > create-the-zone_movable-zone.patch
> > allow-huge-page-allocations-to-use-gfp_high_movable.patch
> > handle-kernelcore=-generic.patch
> > 
> >  Mel's moveable-zone work.  In a similar situation.  We need to stop whatever
> >  we're doing and get down and work out what we're going to do with all this
> >  stuff.
> > 
> 
> Whatever about grouping pages by mobility, I would like to see these go
> through. They have a real application for hugetlb pool resizing where the
> administrator knows the range of hugepages that will be required but doesn't
> want to waste memory when the required number of hugepages is small. I've
> cc'd Kenneth Chen as I believe he has run into this problem recently where
> I believe partitioning memory would have helped. He'll either confirm or deny.

Still no decision here, really.

Should we at least go for

add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
handle-kernelcore=-generic.patch

in 2.6.23?
