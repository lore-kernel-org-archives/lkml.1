Return-Path: <linux-kernel-owner+w=401wt.eu-S964870AbXHHDjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964870AbXHHDjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 23:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935943AbXHHDg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 23:36:26 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:13539 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934532AbXHHDfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 23:35:52 -0400
X-IronPort-AV: i="4.19,233,1183348800"; 
   d="scan'208"; a="36639273:sNHT1037687532"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: dbrownell@users.sourceforge.net,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 06/12] Blackfin arch: Add PORT_J.High (needed for BF548-EZkit Touchscreen interrupts) - remove PORT_C.H
Date: Wed,  8 Aug 2007 11:35:31 +0800
Message-Id: <1186544140363-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11865441373719-git-send-email-bryan.wu@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf548/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf548/Kconfig b/arch/blackfin/mach-bf548/Kconfig
index e78b03d..3976b7f 100644
--- a/arch/blackfin/mach-bf548/Kconfig
+++ b/arch/blackfin/mach-bf548/Kconfig
@@ -282,7 +282,7 @@ menu "Assignment"
 
 config PINTx_REASSIGN
 	bool "Reprogram PINT Assignment"
-	default n
+	default y
 	help
 	  The interrupt assignment registers controls the pin-to-interrupt
 	  assignment in a byte-wide manner. Each option allows you to select
@@ -303,7 +303,7 @@ config PINT1_ASSIGN
 config PINT2_ASSIGN
 	hex "PINT2_ASSIGN"
 	depends on PINTx_REASSIGN
-	default 0x00000101
+	default 0x07000101
 config PINT3_ASSIGN
 	hex "PINT3_ASSIGN"
 	depends on PINTx_REASSIGN
-- 
1.5.2
