Return-Path: <linux-kernel-owner+w=401wt.eu-S1763314AbXHNPg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763314AbXHNPg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761609AbXHNPfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:35:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52194 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758598AbXHNPfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:35:05 -0400
Message-Id: <20070814153021.446917377@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Aug 2007 08:30:21 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 0/9] Reclaim during GFP_ATOMIC allocs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the extended version of the reclaim patchset. It enables reclaim from
clean file backed pages during GFP_ATOMIC allocs. A bit invasive since
may locks must now be taken with saving flags. But it works.

Tested by repeatedly allocating 12MB of memory from the timer interrupt.

-- 
