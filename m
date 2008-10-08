Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbYJHJeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbYJHJeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 05:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYJHJd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 05:33:57 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:44474 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYJHJd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 05:33:56 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Jon Tollefson <kniht@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 0/1] gigantic compound pages part 2
Date: Wed,  8 Oct 2008 10:33:50 +0100
Message-Id: <1223458431-12640-1-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Full stress testing of 2.6.27-rc7 with the patch below threw up some
more places where we assume the mem_map is contigious:

	handle initialising compound pages at orders greater than MAX_ORDER

Following this email is an additional patch to fix up those places.
With this patch the libhugetlbfs functional tests pass, as do our stress
test loads.

Thanks to Jon Tollefson for his help testing these patches.

Please consider this patch for merge for 2.6.27.

-apw
