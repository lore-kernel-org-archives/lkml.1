Return-Path: <linux-kernel-owner+w=401wt.eu-S2992462AbXCWPNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992462AbXCWPNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 11:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992463AbXCWPNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 11:13:14 -0400
Received: from holomorphy.com ([66.93.40.71]:37468 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992462AbXCWPNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 11:13:13 -0400
Date: Fri, 23 Mar 2007 08:09:24 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Ken Chen <kenchen@google.com>, Adam Litke <agl@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] rfc: introduce /dev/hugetlb
Message-ID: <20070323150924.GV2986@holomorphy.com>
References: <b040c32a0703230144r635d7902g2c36ecd7f412be31@mail.gmail.com> <Pine.LNX.4.64.0703231457360.4133@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703231457360.4133@skynet.skynet.ie>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007, Ken Chen wrote:
> >-#ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
> >-unsigned long hugetlb_get_unmapped_area(struct file *file, unsigned long 
> >addr,
> >-		unsigned long len, unsigned long pgoff, unsigned long flags);
> >-#else
> >-static unsigned long
> >+unsigned long
> >hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
> >		unsigned long len, unsigned long pgoff, unsigned long flags)
> 
On Fri, Mar 23, 2007 at 03:03:57PM +0000, Mel Gorman wrote:
> What is going on here? Why do arches not get to specify a 
> get_unmapped_area any more?

Lack of compiletesting beyond x86-64 in all probability.


-- wli
