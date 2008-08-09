Return-Path: <linux-kernel-owner+w=401wt.eu-S1763124AbYHIBps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763124AbYHIBps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbYHIBoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:44:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52136 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbYHIBoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:44:05 -0400
Date: Fri, 8 Aug 2008 18:40:12 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [03/03] USB: remove CONFIG_USB_DEBUG
Message-ID: <20080809014011.GD10910@kroah.com>
References: <20080809013820.GA10910@kroah.com> <20080809013917.GB10910@kroah.com> <20080809013946.GC10910@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809013946.GC10910@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

It's no longer needed, so remove it from the system.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/Kconfig  |    8 --------
 drivers/usb/core/Makefile |    4 ----
 2 files changed, 12 deletions(-)

--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -1,14 +1,6 @@
 #
 # USB Core configuration
 #
-config USB_DEBUG
-	bool "USB verbose debug messages"
-	depends on USB
-	help
-	  Say Y here if you want the USB core & hub drivers to produce a bunch
-	  of debug messages to the system log. Select this if you are having a
-	  problem with USB support and want to see more of what is going on.
-
 config USB_DEBUG_MESSAGES
 	default y
 	bool "USB debugging messages" if EMBEDDED
--- a/drivers/usb/core/Makefile
+++ b/drivers/usb/core/Makefile
@@ -15,7 +15,3 @@ ifeq ($(CONFIG_USB_DEVICEFS),y)
 endif
 
 obj-$(CONFIG_USB)	+= usbcore.o
-
-ifeq ($(CONFIG_USB_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
