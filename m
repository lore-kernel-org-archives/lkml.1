Return-Path: <linux-kernel-owner+w=401wt.eu-S1759828AbXGCMKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828AbXGCMKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 08:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbXGCMKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 08:10:16 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:31287 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbXGCMKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 08:10:14 -0400
Message-Id: <20070703111822.418649776@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 13:18:22 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: akpm@linux-foundation.org, hugh@veritas.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 0/5] some mm improvements + s390 tlb flush.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have updated my mm patch set. The diff:

 - The tlb gather restart patch has been changed as discussed with Hugh.
 - The ptep_establish patch now really removes all traces of the call.
 - The mm_struct / vm_area_struct move to mm_types.h has been test
   compiled on a number of architectures.
 - The page_mkclean_one patch has been dropped because it doesn't seem
   to have any effect.
 - There is a new patch to fix a theoretical architectural problem on
   s390. The patch is required for the 1K/2K page tables for KVM as well.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

