Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbZBKHHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbZBKHHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 02:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZBKHHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 02:07:16 -0500
Received: from harmaja.edelkey.net ([213.138.147.141]:51292 "EHLO
	harmaja.edelkey.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbZBKHHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 02:07:11 -0500
From: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
To: david-b@pacbell.net
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
       jouni.hogander@nokia.com, broonie@sirena.org.uk,
       Kalle Jokiniemi <kalle.jokiniemi@digia.com>
Subject: [PATCH 2/2] USB: OTG: Twl4030 depends on REGULATOR_TWL4030
Date: Wed, 11 Feb 2009 09:06:42 +0200
Message-Id: <1234336002-26372-3-git-send-email-kalle.jokiniemi@digia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1234336002-26372-2-git-send-email-kalle.jokiniemi@digia.com>
References: <>
 <1234336002-26372-1-git-send-email-kalle.jokiniemi@digia.com>
 <1234336002-26372-2-git-send-email-kalle.jokiniemi@digia.com>
X-OriginalArrivalTime: 11 Feb 2009 07:06:45.0253 (UTC) FILETIME=[4C828B50:01C98C17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jouni Hogander <jouni.hogander@nokia.com>

Twl4030 doesn't work without twl4030-regulator so it should depend on
that.

Signed-off-by: Jouni Hogander <jouni.hogander@nokia.com>
Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
---
 drivers/usb/otg/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/otg/Kconfig b/drivers/usb/otg/Kconfig
index ee55b44..5790a5b 100644
--- a/drivers/usb/otg/Kconfig
+++ b/drivers/usb/otg/Kconfig
@@ -43,7 +43,7 @@ config ISP1301_OMAP
 
 config TWL4030_USB
 	tristate "TWL4030 USB Transceiver Driver"
-	depends on TWL4030_CORE
+	depends on TWL4030_CORE && REGULATOR_TWL4030
 	select USB_OTG_UTILS
 	help
 	  Enable this to support the USB OTG transceiver on TWL4030
-- 
1.5.4.3

