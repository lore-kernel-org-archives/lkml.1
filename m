Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbYKASU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbYKASU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 14:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYKASUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 14:20:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58320 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbYKASUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 14:20:00 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] missing dependencies on HAS_CLK in drivers/mfd
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Message-Id: <E1KwL4p-0000TA-Ef@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 01 Nov 2008 18:19:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/mfd/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index a0e8451..39c78a0 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -82,7 +82,7 @@ config MFD_TMIO
 
 config MFD_T7L66XB
 	bool "Support Toshiba T7L66XB"
-	depends on ARM
+	depends on ARM && HAVE_CLK
 	select MFD_CORE
 	select MFD_TMIO
 	help
@@ -90,7 +90,7 @@ config MFD_T7L66XB
 
 config MFD_TC6387XB
 	bool "Support Toshiba TC6387XB"
-	depends on ARM
+	depends on ARM && HAVE_CLK
 	select MFD_CORE
 	select MFD_TMIO
 	help
-- 
1.5.6.5


