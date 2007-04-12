Return-Path: <linux-kernel-owner+w=401wt.eu-S1030824AbXDLWbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030824AbXDLWbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 18:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030825AbXDLWbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 18:31:46 -0400
Received: from holomorphy.com ([66.93.40.71]:42172 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030835AbXDLWbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 18:31:45 -0400
Date: Thu, 12 Apr 2007 15:32:01 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] get_unmapped_area doesn't need hugetlbfs hacks anymore
Message-ID: <20070412223201.GM2986@holomorphy.com>
References: <1176344427.242579.337989891532.qpush@grosgo> <20070412022035.4BD9CDDF32@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412022035.4BD9CDDF32@ozlabs.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 12:20:33PM +1000, Benjamin Herrenschmidt wrote:
> Remove the hugetlbfs specific hacks in toplevel get_unmapped_area() now
> that all archs and hugetlbfs itself do the right thing for both cases.
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>  mm/mmap.c |   16 ----------------
>  1 file changed, 16 deletions(-)

Acked-by: William Irwin <bill.irwin@oracle.com>


-- wli
