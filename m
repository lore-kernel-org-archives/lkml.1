Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbYJPXqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbYJPXqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYJPXp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:45:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:29306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbYJPXp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:45:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,427,1220252400"; 
   d="scan'208";a="628112589"
Message-Id: <20081016233153.093366000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 16 Oct 2008 16:31:53 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, dwmw2@infradead.org, jbarnes@virtuousgeek.org
Cc: youquan.song@intel.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: [patch 0/4] dmar: queued invalidation patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reposting the patchset posted earlier on Oct 8th. This time against Linus's git.

As this patchset removes a temporary quirk (disabling dma-remapping
when intr-remapping is enabled) we would like to see it go in to Linus tree
in this merge window. I am not sure if David is ready with his iommu
git tree setup. As Ingo pushed the original pieces, I am ok with Ingo
picking this up and pushing it to Linus. Either way, I am fine and would
like to see go into some subsystem tree and to Linus before the merge window
is closed. Thanks.
---

This patchset enables queued invalidation for DMA-remapping. And as such
removes the quirk from the x2apic/interrupt-remapping patchset which
disables dma-remapping while enabling interrupt-remapping.

Patches are on top of -tip tree because of its interaction with
x2apic/interrupt-remapping patches in tip.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
-- 

