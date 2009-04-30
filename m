Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbZD3Xk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbZD3Xk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZD3Xk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:40:29 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58213 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756654AbZD3Xk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:40:28 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 1/6] arm: use _AC(1, UL) when defining PAGE_SIZE.
Date: Thu, 30 Apr 2009 19:40:03 -0400
Message-Id: <1241134808-7583-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241134808-7583-1-git-send-email-tabbott@mit.edu>
References: <1241134808-7583-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it so that we can use PAGE_SIZE in the linker script.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 arch/arm/include/asm/page.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/page.h b/arch/arm/include/asm/page.h
index e6eb8a6..185c833 100644
--- a/arch/arm/include/asm/page.h
+++ b/arch/arm/include/asm/page.h
@@ -10,9 +10,11 @@
 #ifndef _ASMARM_PAGE_H
 #define _ASMARM_PAGE_H
 
+#include <linux/const.h>
+
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT		12
-#define PAGE_SIZE		(1UL << PAGE_SHIFT)
+#define PAGE_SIZE		(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
 
 #ifndef __ASSEMBLY__
-- 
1.6.2.1

