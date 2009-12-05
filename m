Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZLELWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZLELWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 06:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbZLELWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 06:22:36 -0500
Received: from smtprelay02.ispgateway.de ([80.67.18.14]:39409 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbZLELWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 06:22:35 -0500
Date: Sat, 5 Dec 2009 12:19:05 +0100
From: Peter Feuerer <peter@piie.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>,
       lenb@kernel.org, Andreas Mohr <andi@lisas.de>,
       Peter Feuerer <peter@piie.net>
Subject: [PATCH -mm] acerhdf: Added new BIOS versions
Message-Id: <20091205121905.a71a6c56.peter@piie.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: 650477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

please apply to your -mm tree.

thank you very much,
--peter

--
Added new BIOS versions for following netbooks: Aspire 1810xx, Packard
  Bell DOTMU

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/platform/x86/acerhdf.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 007bc55..a97fc4a 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -52,7 +52,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.20"
+#define DRV_VER "0.5.21"
 
 /*
  * According to the Atom N270 datasheet,
@@ -156,7 +156,13 @@ static const struct bios_settings_t bios_tbl[] = {
 	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x20, 0x00} },
 	/* Acer 1410 */
 	{"Acer", "Aspire 1410", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	/* special BIOS / other */
+	{"Acer", "Aspire 1410", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	/* Acer 1810xx */
+	{"Acer", "Aspire 1810TZ", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1810T", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1810T", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	/* Gateway */
 	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x21, 0x00} },
 	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x20, 0x00} },
 	{"Gateway         ", "LT31            ", "v1.3103 ", 0x55, 0x58,
@@ -165,10 +171,13 @@ static const struct bios_settings_t bios_tbl[] = {
 		{0x10, 0x0f, 0x00} },
 	{"Gateway         ", "LT31            ", "v1.3302 ", 0x55, 0x58,
 		{0x10, 0x0f, 0x00} },
+	/* Packard Bell */
 	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x21, 0x00} },
 	{"Packard Bell", "DOA150", "v0.3105", 0x55, 0x58, {0x20, 0x20, 0x00} },
 	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x21, 0x00} },
 	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	{"Packard Bell", "DOTMU", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Packard Bell", "DOTMU", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
 	/* pewpew-terminator */
 	{"", "", "", 0, 0, {0, 0, 0} }
 };
@@ -641,9 +650,13 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Peter Feuerer");
 MODULE_DESCRIPTION("Aspire One temperature and fan driver");
 MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAspire 1410*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAspire 1810*:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Gateway*:pnLT31*:");
 MODULE_ALIAS("dmi:*:*Packard Bell*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOA*:");
+MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOTMU*:");
 
 module_init(acerhdf_init);
 module_exit(acerhdf_exit);
-- 
1.6.5.4
