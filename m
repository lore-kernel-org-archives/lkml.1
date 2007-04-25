Return-Path: <linux-kernel-owner+w=401wt.eu-S2992855AbXDYRJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992855AbXDYRJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 13:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992856AbXDYRJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 13:09:49 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4661 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992855AbXDYRJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 13:09:49 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 0/2] Lumpy Reclaim V6 cleanups
Message-ID: <exportbomb.1177520981@pinky>
Date: Wed, 25 Apr 2007 18:09:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following this email are two cleanup patches against lumpy V6
(as contained in v2.6.21-rc7-mm1).  These address the review feedback
from Andrew Morton, thanks for reviewing.

introduce-HIGH_ORDER-delineating-easily-reclaimable-orders-fix:
  changes the name of the constant to PAGE_ALLOC_COSTLY_ORDER and
  updates the commentary to better describe it.

lumpy-increase-pressure-at-the-end-of-the-inactive-list-cleanups:
  a large number of cleanups including fully expressing the
  isolations modes symbolically.

Andrew please apply.

-apw
