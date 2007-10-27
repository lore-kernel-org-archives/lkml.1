Return-Path: <linux-kernel-owner+w=401wt.eu-S1765001AbXJ0BGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765001AbXJ0BGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 21:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbXJ0BG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 21:06:27 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33034 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758305AbXJ0BG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 21:06:26 -0400
Date: Sat, 27 Oct 2007 03:06:47 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Michael Buesch <mb@bu3sch.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [2.6 patch] fix USB_OHCI_HCD_SSB dependencies
Message-ID: <20071027010647.GN30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug introduced by
commit b22817b3c81cdb18ffe3d2debfee968731a8b5f4.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
155ad66379582067ef2ce73d28e3cf6eedf21b14 
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 177e78e..49a91c5 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -156,7 +156,7 @@ config USB_OHCI_HCD_PCI
 
 config USB_OHCI_HCD_SSB
 	bool "OHCI support for Broadcom SSB OHCI core"
-	depends on USB_OHCI_HCD && (SSB = y || SSB = CONFIG_USB_OHCI_HCD) && EXPERIMENTAL
+	depends on USB_OHCI_HCD && (SSB = y || SSB = USB_OHCI_HCD) && EXPERIMENTAL
 	default n
 	---help---
 	  Support for the Sonics Silicon Backplane (SSB) attached

