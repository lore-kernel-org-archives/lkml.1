Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXJWEmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXJWEmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXJWEj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:39:26 -0400
Received: from rex.snapgear.com ([203.143.235.140]:58897 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752895AbXJWEjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:39:24 -0400
Date: Tue, 23 Oct 2007 14:37:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710230437.l9N4bsko001776@goober>
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
