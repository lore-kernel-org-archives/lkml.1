Return-Path: <linux-kernel-owner+w=401wt.eu-S934347AbXGSXYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347AbXGSXYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbXGSXYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:24:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42244 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbXGSXYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:24:23 -0400
Date: Fri, 20 Jul 2007 00:24:22 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] more isa/eisa/pci-only drivers marked as such
Message-ID: <20070719232422.GZ21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 7685c8a..00bec9a 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -185,7 +185,7 @@ config ESPSERIAL
 
 config MOXA_INTELLIO
 	tristate "Moxa Intellio support"
-	depends on SERIAL_NONSTANDARD
+	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
 	help
 	  Say Y here if you have a Moxa Intellio multiport serial card.
 
@@ -241,7 +241,7 @@ config SYNCLINK
 
 config SYNCLINKMP
 	tristate "SyncLink Multiport support"
-	depends on SERIAL_NONSTANDARD
+	depends on SERIAL_NONSTANDARD && PCI
 	help
 	  Enable support for the SyncLink Multiport (2 or 4 ports)
 	  serial adapter, running asynchronous and HDLC communications up
