Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbYCSTsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbYCSTsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbYCSTcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:32:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53753 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698AbYCSTcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:32:42 -0400
Date: Tue, 18 Mar 2008 17:01:36 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [5/18] Expand the hugetlbfs sysctls to handle arrays for all hstates
Message-ID: <20080318170136.GP23866@csn.ul.ie>
References: <20080317258.659191058@firstfloor.org> <20080317015818.E30041B41E0@basil.firstfloor.org> <20080318143438.GE23866@csn.ul.ie> <20080318164903.GG11966@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080318164903.GG11966@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (18/03/08 17:49), Andi Kleen didst pronounce:
> > Also, offhand it's not super-clear why max_huge_pages is not part of
> > hstate as we only expect one hstate per pagesize anyway.
> 
> They need to be an separate array for the sysctl parsing function.
> 

D'oh, of course. Pointing that out answers my other questions in relation to
how writing single values to a proc entry affects multiple pools as well. I
was still thinking of max_huge_pages as as a single value instead of an array.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
