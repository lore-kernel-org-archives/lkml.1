Return-Path: <linux-kernel-owner+w=401wt.eu-S1751247AbYANP3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbYANP3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYANP24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:28:56 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52645 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYANP2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:28:55 -0500
Date: Mon, 14 Jan 2008 15:28:53 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <clameter@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch 09/19] (NEW) more aggressively use lumpy reclaim
Message-ID: <20080114152853.GB20551@csn.ul.ie>
References: <20080108205939.323955454@redhat.com> <20080108210007.257424941@redhat.com> <Pine.LNX.4.64.0801081429150.4678@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801081429150.4678@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/01/08 14:30), Christoph Lameter didst pronounce:
> On Tue, 8 Jan 2008, Rik van Riel wrote:
> 
> > If normal pageout does not result in contiguous free pages for
> > kernel stacks, fall back to lumpy reclaim instead of failing fork
> > or doing excessive pageout IO.
> 
> Good. Ccing Mel. This is going to help higher order pages which is useful 
> for a couple of other projects.
> 

Well, the patch only has any impact when the order you are reclaiming is
less than PAGE_ALLOC_COSTLY_ORDER so I would not have considered it of major
impact to other projects interested in high order allocations.  However, in
isolation I have no problem with this patch and I can see how it makes sense
for the problem scenario described. I rebased just this patch to 2.6.24-rc7
and found no problems but I have not had the chance to review the whole set.

> Reviewed-by: Christoph Lameter <clameter@sgi.com>
> 

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
