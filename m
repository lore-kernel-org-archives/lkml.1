Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817Ab0COKUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 06:20:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24226 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964792Ab0COKU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 06:20:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 15 Mar 2010 11:10:23 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: g_mass_storage: fixed module name in Kconfig
To: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <6c04e7ae998c9bb5ea8ecb9c2e96bfe8fb4d7da3.1268220008.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig help message for Mass Storage Gadget claimed the
module will be named "g_file_storage" whereas it should be
"g_mass_storage".

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 7460cd7..11a3e0f 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -747,7 +747,7 @@ config USB_MASS_STORAGE
 	  which may be used with composite framework.
 
 	  Say "y" to link the driver statically, or "m" to build
-	  a dynamically linked module called "g_file_storage".  If unsure,
+	  a dynamically linked module called "g_mass_storage".  If unsure,
 	  consider File-backed Storage Gadget.
 
 config USB_G_SERIAL
-- 
1.7.0

