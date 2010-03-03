Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0CCShh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:37:37 -0500
Received: from sirius.lasnet.de ([78.47.116.19]:60649 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490Ab0CCShg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:37:36 -0500
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefan Schmidt <stefan@datenfreihafen.org>
Date: Wed,  3 Mar 2010 19:37:12 +0100
Message-Id: <1267641432-17774-1-git-send-email-stefan@datenfreihafen.org>
X-Mailer: git-send-email 1.7.0
Subject: [PATCH] usb/serial: Fix module name typo for qcaux Kconfig entry.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The module is called qcaux and not moto_modem. Also use help instead of
---help-- to be in sync with the other Kconfig entries.

Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
---
 drivers/usb/serial/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index c78b255..a0ecb42 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -474,14 +474,14 @@ config USB_SERIAL_OTI6858
 
 config USB_SERIAL_QCAUX
 	tristate "USB Qualcomm Auxiliary Serial Port Driver"
-	---help---
+	help
 	  Say Y here if you want to use the auxiliary serial ports provided
 	  by many modems based on Qualcomm chipsets.  These ports often use
 	  a proprietary protocol called DM and cannot be used for AT- or
 	  PPP-based communication.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called moto_modem.  If unsure, choose N.
+	  module will be called qcaux.  If unsure, choose N.
 
 config USB_SERIAL_QUALCOMM
 	tristate "USB Qualcomm Serial modem"
-- 
1.7.0

