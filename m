Return-Path: <linux-kernel-owner+w=401wt.eu-S1765631AbZEAAG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765631AbZEAAG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764930AbZEAAAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:00:43 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61165 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764272AbZEAAAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:00:41 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Chris Zankel <chris@zankel.net>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 2/3] xtensa: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 20:00:26 -0400
Message-Id: <1241136027-10244-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136027-10244-2-git-send-email-tabbott@mit.edu>
References: <1241136027-10244-1-git-send-email-tabbott@mit.edu>
 <1241136027-10244-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/kernel/vmlinux.lds.S |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index f96f354..165a980 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -123,8 +123,7 @@ SECTIONS
   {
     DATA_DATA
     CONSTRUCTORS
-    . = ALIGN(XCHAL_ICACHE_LINESIZE);
-    *(.data.cacheline_aligned)
+    CACHELINE_ALIGNED_DATA(XCHAL_ICACHE_LINESIZE)
   }
 
   _edata = .;
-- 
1.6.2.1

