Return-Path: <linux-kernel-owner+w=401wt.eu-S933399AbXF2ONe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399AbXF2ONe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932118AbXF2ONZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:13:25 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:3692 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761427AbXF2ONY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:13:24 -0400
Message-Id: <20070629135530.912094590@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jun 2007 15:55:30 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 0/5] Various mm improvements.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While working on 1K/2K page tables for s390 I noticed room for
improvement in regard to some common mm code:
 - unnecessary tlb flushing in unmap_vmas
 - ptep_establish has fallen into disuse
 - ptep_test_and_clear_dirty / ptep_clear_flush_dirty are not used either
 - the definitions of mm_struct and vm_area_struct should be moved to
   mm_types.h
 - page_mkclean_one is giving false positives

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

