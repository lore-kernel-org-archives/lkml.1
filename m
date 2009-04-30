Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbZD3Xoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbZD3Xoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758418AbZD3XoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:44:11 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58862 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758371AbZD3XoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:44:10 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 4/6] arm: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 19:40:06 -0400
Message-Id: <1241134808-7583-5-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241134808-7583-4-git-send-email-tabbott@mit.edu>
References: <1241134808-7583-1-git-send-email-tabbott@mit.edu>
 <1241134808-7583-2-git-send-email-tabbott@mit.edu>
 <1241134808-7583-3-git-send-email-tabbott@mit.edu>
 <1241134808-7583-4-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/kernel/vmlinux.lds.S |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 3e2f644..a9bd142 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -160,8 +160,7 @@ SECTIONS
 		/*
 		 * then the cacheline aligned data
 		 */
-		. = ALIGN(32);
-		*(.data.cacheline_aligned)
+		CACHELINE_ALIGNED_DATA(32)
 
 		/*
 		 * The exception fixup table (might need resorting at runtime)
-- 
1.6.2.1

