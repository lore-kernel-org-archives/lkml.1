Return-Path: <linux-kernel-owner+w=401wt.eu-S1763524AbYDPNvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763524AbYDPNvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYDPNvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:51:01 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34248 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762962AbYDPNvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:51:00 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org
Cc: Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu, linux-kernel@vger.kernel.org
Message-Id: <20080416135058.1346.65546.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 0/4] [RFC] Verification and debugging of memory initialisation
Date: Wed, 16 Apr 2008 14:50:58 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boot initialisation has always been a bit of a mess with a number
of ugly points. While significant amounts of the initialisation
is architecture-independent, it trusts of the data received from the
architecture layer. This was a mistake in retrospect as it has resulted in
a number of difficult-to-diagnose bugs.

This patchset is an RFC to add some validation and tracing to memory
initialisation. It also introduces a few basic defencive measures and
depending on a boot parameter, will perform additional tests for errors
"that should never occur". I think this would have reduced debugging time
for some boot-related problems. The last part of the patchset is a similar
fix for the patch "[patch] mm: sparsemem memory_present() memory corruption"
that corrects a few more areas where similar errors were made.

I'm not looking to merge this as-is obviously but are there opinions on
whether this is a good idea in principal? Should it be done differently or
not at all?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
