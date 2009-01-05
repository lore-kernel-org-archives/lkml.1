Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZAEPRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZAEPRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZAEPRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:17:24 -0500
Received: from sh.osrg.net ([192.16.179.4]:47305 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbZAEPRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:17:24 -0500
Date: Tue, 6 Jan 2009 00:17:09 +0900
To: mingo@elte.hu, joerg.roedel@amd.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] AMD IOMMU: remove unnecessary ifdef
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090106001704O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, why do we need this ifdef? We should avoid it, I think.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] AMD IOMMU: remove unnecessary ifdef

We try to avoid this type of ifdef and we can safely remove this
ifdef.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/amd_iommu.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 5113c08..d7a7c4c 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -23,9 +23,7 @@
 #include <linux/debugfs.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
-#ifdef CONFIG_IOMMU_API
 #include <linux/iommu.h>
-#endif
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
-- 
1.6.0.6

