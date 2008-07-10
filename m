Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbYGJRaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbYGJRaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbYGJRaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:30:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59008 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221AbYGJRaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:30:04 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: apw@shadowen.org, Mel Gorman <mel@csn.ul.ie>, agl@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Message-Id: <20080710173001.16433.87538.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 0/2] Fix two bugs in hugetlbfs MAP_PRIVATE page reservation
Date: Thu, 10 Jul 2008 18:30:01 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches fix minor issues with the MAP_PRIVATE-reservation
support for hugetlbfs that showed up during testing. The first patch fixes a
problem whereby a check is made for MAP_SHARED mappings that is intended for
MAP_PRIVATE mappings only. The second fixes a BUG_ON that is triggered due to
an unaligned address.

Both patches are fixes for
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch.
Credit goes to Adam Litke for spotting the problems during regression testing.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
