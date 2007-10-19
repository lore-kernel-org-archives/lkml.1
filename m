Return-Path: <linux-kernel-owner+w=401wt.eu-S965788AbXJSCEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965788AbXJSCEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 22:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965485AbXJSCDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 22:03:47 -0400
Received: from rex.snapgear.com ([203.143.235.140]:42734 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965477AbXJSCDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 22:03:46 -0400
Date: Fri, 19 Oct 2007 12:03:03 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710190203.l9J233cp003969@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: fix make archclean
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove build reference to arch/m68knommu/boot directory, it doesn't
exist.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/arch/m68knommu/Makefile linux-2.6.23-uc0/arch/m68knommu/Makefile
--- linux-2.6.23/arch/m68knommu/Makefile	2007-10-19 10:30:58.000000000 +1000
+++ linux-2.6.23-uc0/arch/m68knommu/Makefile	2007-10-19 10:35:41.000000000 +1000
@@ -117,4 +118,4 @@ core-y	+= arch/m68knommu/kernel/ \
 libs-y	+= arch/m68knommu/lib/
 
 archclean:
-	$(Q)$(MAKE) $(clean)=arch/m68knommu/boot
+
