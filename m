Return-Path: <linux-kernel-owner+w=401wt.eu-S934076AbXCWPP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934076AbXCWPP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 11:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934081AbXCWPP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 11:15:58 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:54597 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934076AbXCWPP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 11:15:58 -0400
Date: Fri, 23 Mar 2007 15:15:55 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Ken Chen <kenchen@google.com>, Adam Litke <agl@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] rfc: introduce /dev/hugetlb
In-Reply-To: <20070323150924.GV2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0703231514370.4133@skynet.skynet.ie>
References: <b040c32a0703230144r635d7902g2c36ecd7f412be31@mail.gmail.com>
 <Pine.LNX.4.64.0703231457360.4133@skynet.skynet.ie> <20070323150924.GV2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007, William Lee Irwin III wrote:

> On Fri, 23 Mar 2007, Ken Chen wrote:
>>> -#ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
>>> -unsigned long hugetlb_get_unmapped_area(struct file *file, unsigned long
>>> addr,
>>> -		unsigned long len, unsigned long pgoff, unsigned long flags);
>>> -#else
>>> -static unsigned long
>>> +unsigned long
>>> hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
>>> 		unsigned long len, unsigned long pgoff, unsigned long flags)
>>
> On Fri, Mar 23, 2007 at 03:03:57PM +0000, Mel Gorman wrote:
>> What is going on here? Why do arches not get to specify a
>> get_unmapped_area any more?
>
> Lack of compiletesting beyond x86-64 in all probability.
>

Ok, this will go kablamo on Power then even if it compiles. I don't 
consider it a fundamental problem though. For the purposes of an RFC, it's 
grand and something that can be worked with.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
