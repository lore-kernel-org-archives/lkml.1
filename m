Return-Path: <linux-kernel-owner+w=401wt.eu-S933076AbXH0Vbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076AbXH0Vbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765324AbXH0V16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:27:58 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58810 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765309AbXH0V14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:27:56 -0400
Date: Mon, 27 Aug 2007 23:27:56 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>
Subject: [2.6 patch] fix SERIAL_CORE_CONSOLE driver dependencies
Message-ID: <20070827212756.GQ4121@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SERIAL_BFIN=m or SERIAL_MUX=m shouldn't allow SERIAL_CORE_CONSOLE=y.

Additionally, this patch fixes whitespaceinstead of tabs at the 
SERIAL_MUX_CONSOLE option.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/serial/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

d07b60e6784eb178d4ba7dd8ff9923f2e54d3ef1 
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 4e28992..7780d76 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -611,7 +611,7 @@ config SERIAL_BFIN
 
 config SERIAL_BFIN_CONSOLE
 	bool "Console on Blackfin serial port"
-	depends on SERIAL_BFIN
+	depends on SERIAL_BFIN=y
 	select SERIAL_CORE_CONSOLE
 
 choice
@@ -832,10 +832,10 @@ config SERIAL_MUX
 	    4. Change the kernel command console parameter to: console=ttyB0
 
 config SERIAL_MUX_CONSOLE
-        bool "Support for console on serial MUX"
-        depends on SERIAL_MUX
+	bool "Support for console on serial MUX"
+	depends on SERIAL_MUX=y
 	select SERIAL_CORE_CONSOLE
-        default y
+	default y
 
 config PDC_CONSOLE
 	bool "PDC software console support"

