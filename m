Return-Path: <linux-kernel-owner+w=401wt.eu-S1030823AbXDLW3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030823AbXDLW3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 18:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030824AbXDLW3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 18:29:30 -0400
Received: from holomorphy.com ([66.93.40.71]:50101 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030823AbXDLW3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 18:29:30 -0400
Date: Thu, 12 Apr 2007 15:29:45 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/12] get_unmapped_area handles MAP_FIXED on ia64
Message-ID: <20070412222945.GJ2986@holomorphy.com>
References: <1176344427.242579.337989891532.qpush@grosgo> <20070412022032.2CDA1DDF2D@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412022032.2CDA1DDF2D@ozlabs.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 12:20:30PM +1000, Benjamin Herrenschmidt wrote:
> Handle MAP_FIXED in ia64 arch_get_unmapped_area and
> hugetlb_get_unmapped_area(), just call prepare_hugepage_range
> in the later and is_hugepage_only_range() in the former.
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>  arch/ia64/kernel/sys_ia64.c |    7 +++++++
>  arch/ia64/mm/hugetlbpage.c  |    8 ++++++++
>  2 files changed, 15 insertions(+)

Acked-by: William Irwin <bill.irwin@oracle.com>


-- wli
