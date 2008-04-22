Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbYDVGpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbYDVGpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 02:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYDVGpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 02:45:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:45489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbYDVGpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 02:45:20 -0400
Date: Tue, 22 Apr 2008 08:45:16 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, pj@sgi.com,
       andi@firstfloor.org
Subject: Re: [patch 01/17] hugetlb: modular state
Message-ID: <20080422064516.GA23770@wotan.suse.de>
References: <20080410170232.015351000@nick.local0.net> <20080410171100.425293000@nick.local0.net> <1208811084.11866.10.camel@skynet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208811084.11866.10.camel@skynet>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 03:51:24PM -0500, Jon Tollefson wrote:
> 
> On Fri, 2008-04-11 at 03:02 +1000, npiggin@suse.de wrote:
> 
> <snip>
> 
> > Index: linux-2.6/include/linux/hugetlb.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/hugetlb.h
> > +++ linux-2.6/include/linux/hugetlb.h
> > @@ -40,7 +40,7 @@ extern int sysctl_hugetlb_shm_group;
> > 
> >  /* arch callbacks */
> > 
> > -pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr);
> > +pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr, int sz);
> 
> <snip>
> 
> The sz here needs to be a long to handle sizes such as 16G on powerpc.
> 
> There are other places in hugetlb.c where the size also needs to be a
> long, but this one affects the arch code too since it is public.

Thanks, I've fixed that and found (hopefully) the rest of the ones
in the hugetlb.c code.

Thanks,
Nick

