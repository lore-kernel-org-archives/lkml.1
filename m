Return-Path: <linux-kernel-owner+w=401wt.eu-S1761785AbYHEPnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761785AbYHEPnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757871AbYHEPnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:43:39 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35454 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759134AbYHEPni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:43:38 -0400
Subject: Re: [PATCH] hugetlb: call arch_prepare_hugepage() for surplus pages
From: Adam Litke <agl@us.ibm.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, Nishanth Aravamudan <nacc@us.ibm.com>
In-Reply-To: <1217950147.5032.15.camel@localhost.localdomain>
References: <1217950147.5032.15.camel@localhost.localdomain>
Content-Type: text/plain
Organization: IBM
Date: Tue, 05 Aug 2008 10:43:34 -0500
Message-Id: <1217951014.13182.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 17:29 +0200, Gerald Schaefer wrote:
> From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
> The s390 software large page emulation implements shared page tables
> by using page->index of the first tail page from a compound large page
> to store page table information. This is set up in arch_prepare_hugepage(),
> which is called from alloc_fresh_huge_page_node().
> 
> A similar call to arch_prepare_hugepage() is missing for surplus large
> pages that are allocated in alloc_buddy_huge_page(), which breaks the
> software emulation mode for (surplus) large pages on s390. This patch
> adds the missing call to arch_prepare_hugepage(). It will have no effect
> on other architectures where arch_prepare_hugepage() is a nop.
> 
> Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>

Seems fine.

Acked-by: Adam Litke <agl@us.ibm.com>

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

