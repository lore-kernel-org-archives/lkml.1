Return-Path: <linux-kernel-owner+w=401wt.eu-S1030794AbXCNJTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030794AbXCNJTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030764AbXCNJSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:18:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60484 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030744AbXCNJSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:18:40 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 5/17] pasemi trivial iomem annotations
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1HRPd2-0003RH-0Y@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:18:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/platforms/pasemi/iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pasemi/iommu.c b/arch/powerpc/platforms/pasemi/iommu.c
index 459a53b..71dbf1a 100644
--- a/arch/powerpc/platforms/pasemi/iommu.c
+++ b/arch/powerpc/platforms/pasemi/iommu.c
@@ -77,7 +77,7 @@
 #define IOBMAP_L2E_V		0x80000000
 #define IOBMAP_L2E_V_CACHED	0xc0000000
 
-static u32 *iob;
+static u32 __iomem *iob;
 static u32 iob_l1_emptyval;
 static u32 iob_l2_emptyval;
 static u32 *iob_l2_base;
-- 
1.5.0-rc2.GIT


