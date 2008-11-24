Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207AbYKXI3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbYKXI3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 03:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYKXI3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 03:29:08 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:43518 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYKXI3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 03:29:07 -0500
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH] x86: correct link to HPET timer specification
Date: Mon, 24 Nov 2008 11:28:36 +0300
Message-Id: <1227515316-28274-1-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original link is dead.

Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 arch/x86/Kconfig    |    2 +-
 drivers/char/hpet.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac22bb7..19f0d97 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -482,7 +482,7 @@ config HPET_TIMER
          The HPET provides a stable time base on SMP
          systems, unlike the TSC, but it is more expensive to access,
          as it is off-chip.  You can find the HPET spec at
-         <http://www.intel.com/hardwaredesign/hpetspec.htm>.
+         <http://www.intel.com/hardwaredesign/hpetspec_1.pdf>.
 
          You can safely choose Y here.  However, HPET will only be
          activated if the platform and the BIOS support this feature.
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 53fdc7f..32b8bbf 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -46,7 +46,7 @@
 /*
  * The High Precision Event Timer driver.
  * This driver is closely modelled after the rtc.c driver.
- * http://www.intel.com/hardwaredesign/hpetspec.htm
+ * http://www.intel.com/hardwaredesign/hpetspec_1.pdf
  */
 #define	HPET_USER_FREQ	(64)
 #define	HPET_DRIFT	(500)
-- 
1.5.6.4

