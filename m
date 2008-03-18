Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbYCSV5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbYCSV5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932671AbYCSUWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:22:46 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59726 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249AbYCSUWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:22:43 -0400
Date: Tue, 18 Mar 2008 16:46:10 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [13/18] Add support to allocate hugepages of different size with hugepages=...
Message-ID: <20080318164610.GO23866@csn.ul.ie>
References: <20080317258.659191058@firstfloor.org> <20080317015827.15E811B41E0@basil.firstfloor.org> <20080318163225.GM23866@csn.ul.ie> <20080318164550.GF11966@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080318164550.GF11966@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (18/03/08 17:45), Andi Kleen didst pronounce:
> > hmm, it's not very clear to me how hugetlb_init_hstate() would get
> > called twice for the same hstate. Should it be VM_BUG_ON() if a hstate
>
> It is called from a __setup function and the user can specify them multiple
> times.  Also when the user specified the HPAGE_SIZE already and it got set up
> it should not be called again.
> 

Ok, that is a fair explanation. Thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
