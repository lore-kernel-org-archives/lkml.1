Return-Path: <linux-kernel-owner+w=401wt.eu-S1751371AbZHSJIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbZHSJIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbZHSJIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:08:41 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52821 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZHSJIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:08:41 -0400
Date: Wed, 19 Aug 2009 10:08:44 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] Reduce searching in the page allocator
	fast-path
Message-ID: <20090819090843.GB24809@csn.ul.ie>
References: <1250594162-17322-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0908181019130.32284@gentwo.org> <20090818165340.GB13435@csn.ul.ie> <alpine.DEB.1.10.0908181357100.3840@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0908181357100.3840@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 03:05:25PM -0400, Christoph Lameter wrote:
> On Tue, 18 Aug 2009, Mel Gorman wrote:
> 
> > Can you point me to which patchset you are talking about specifically that
> > uses per-cpu atomics in the hot path? There are a lot of per-cpu patches
> > related to you that have been posted in the last few months and I'm not sure
> > what any of their merge status' is.
> 
> The following patch just moved the page allocator to use the new per cpu
> allocator. It does not use per cpu atomic yet but its possible then.
> 
> http://marc.info/?l=linux-mm&m=124527414206546&w=2
> 

Ok, I don't see this particular patch merged, is it in a merge queue somewhere?

After glancing through, I can see how it might help.  I'm going to drop patch
3 of this set that shuffles data from the PCP to the zone and take a closer
look at those patches. Patch 1 and 2 of this set should still go ahead. Do
you agree?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
