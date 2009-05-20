Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbZETMt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbZETMt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbZETMtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:49:49 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60780 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580AbZETMts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:49:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCH] Revert "USB: Correct Makefile to make isp1760 buildable"
Date: Wed, 20 May 2009 08:49:48 -0400
Message-Id: <1242823788-21001-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 26e1287594864169577327fef233befc9739be3b.

A larger patch (f7e7aa585) a few days after this one added the same line
to the Makefile, but in a different place.  While it'd be more correct to
revert that one, it's easier to revert this one because this is a
one-liner.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-usb@vger.kernel.org
---
 drivers/usb/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index 0716cdb..0a3dc5e 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -11,7 +11,6 @@ obj-$(CONFIG_USB_MON)		+= mon/
 obj-$(CONFIG_PCI)		+= host/
 obj-$(CONFIG_USB_EHCI_HCD)	+= host/
 obj-$(CONFIG_USB_ISP116X_HCD)	+= host/
-obj-$(CONFIG_USB_ISP1760_HCD)	+= host/
 obj-$(CONFIG_USB_OHCI_HCD)	+= host/
 obj-$(CONFIG_USB_UHCI_HCD)	+= host/
 obj-$(CONFIG_USB_FHCI_HCD)	+= host/
-- 
1.6.3

