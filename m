Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbZDQIli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbZDQIli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 04:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbZDQIlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 04:41:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:41767 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756989AbZDQIlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 04:41:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,203,1239001200"; 
   d="scan'208";a="448762615"
From: Weidong Han <weidong.han@intel.com>
To: mingo@elte.hu, dwmw2@infradead.org, allen.m.kay@intel.com,
       fenghua.yu@intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Weidong Han <weidong.han@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 1/5] docs: add nox2apic back to kernel-parameters.txt
Date: Fri, 17 Apr 2009 16:42:12 +0800
Message-Id: <1239957736-6161-2-git-send-email-weidong.han@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"nox2apic" was removed from kernel-parameters.txt when Randy moved
entries to be in alpha order (commit 0cb55ad2). But this early
parameter is still there, add it back to kernel-parameters.txt.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6172e43..33989d2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1588,6 +1588,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nowb		[ARM]
 
+	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
+
 	nptcg=		[IA64] Override max number of concurrent global TLB
 			purges which is reported from either PAL_VM_SUMMARY or
 			SAL PALO.
-- 
1.6.0.4

