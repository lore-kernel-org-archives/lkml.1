Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110Ab0AVRup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab0AVRup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100Ab0AVRum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:50:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:18183 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab0AVRuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:50:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="235792358"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH] Patch 3 of 5 for rar_register - provide better explanation in Kconfig
Date: Fri, 22 Jan 2010 09:54:27 -0800
Message-Id: <1264182867-29036-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/rar_register/Kconfig |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rar_register/Kconfig b/drivers/staging/rar_register/Kconfig
index 17f8bf3..b1427d4 100644
--- a/drivers/staging/rar_register/Kconfig
+++ b/drivers/staging/rar_register/Kconfig
@@ -14,4 +14,17 @@ config RAR_REGISTER
 		contents of the restricted access region control
 		registers.
 
+		The restricted access region control registers
+		(rar_registers) are used to pass address and
+		locking information on restricted access regions
+		to other drivers that use restricted access regions
+
+		The restricted access regions are regions of memory
+		on the Intel MID Platform that are not accessible to
+		the x86 processor, but are accessible to dedicated
+		processors on board peripheral devices.
+
+		The purpose of the restricted access regions is to
+		protect sensitive data from compromise by unauthorized
+		programs running on the x86 processor.
 endmenu
-- 
1.6.0.6

