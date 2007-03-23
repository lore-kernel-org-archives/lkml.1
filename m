Return-Path: <linux-kernel-owner+w=401wt.eu-S2992452AbXCWPE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992452AbXCWPE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 11:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992454AbXCWPE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 11:04:29 -0400
Received: from holomorphy.com ([66.93.40.71]:53712 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992452AbXCWPE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 11:04:28 -0400
Date: Fri, 23 Mar 2007 08:03:46 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ken Chen <kenchen@google.com>
Cc: Adam Litke <agl@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] rfc: introduce /dev/hugetlb
Message-ID: <20070323150346.GU2986@holomorphy.com>
References: <b040c32a0703230144r635d7902g2c36ecd7f412be31@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0703230144r635d7902g2c36ecd7f412be31@mail.gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 01:44:38AM -0700, Ken Chen wrote:
> I think we have enough infrastructure currently in hugetlbfs to
> implement what Adam wants for something like a /dev/hugetlb char
> device (except we can't afford to have a zero hugetlb page since it
> will be too costly on some arch).
> I really like the idea of having something similar to /dev/zero for
> hugetlb page.  So I coded it up on top of existing hugetlbfs.  The
> core change is really small and half of the patch is really just
> moving things around.  I think this at least can partially fulfill the
> goal.
> Signed-off-by: Ken Chen <kenchen@google.com>

I like this patch a lot, though I'm not likely to get around to testing
it today. If userspace testcode is available that would be great to see
posted so I can just boot into things and run that.


-- wli
