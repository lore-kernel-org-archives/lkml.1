Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760Ab0BESsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 13:48:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:24071 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933738Ab0BESsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 13:48:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,414,1262592000"; 
   d="scan'208";a="538199582"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com, greg@kroah.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH 3/6] staging:rar_register: provide better explanation in Kconfig
Date: Fri,  5 Feb 2010 10:52:46 -0800
Message-Id: <1265395966-16001-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides a better explanation of what this
driver is for in the Kconfig file

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/rar_register/Kconfig |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rar_register/Kconfig b/drivers/staging/rar_register/Kconfig
index 17f8bf3..3f73839 100644
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

