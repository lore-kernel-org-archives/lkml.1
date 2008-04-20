Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbYDTKk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbYDTKk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYDTKjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:39:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56243 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbYDTKjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:39:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Denis Cheng <crquan@gmail.com>, "Hans J. Koch" <hjk@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/36] uio: Kconfig improvements
Date: Sun, 20 Apr 2008 03:45:32 -0700
Message-Id: <1208688366-9252-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/Kconfig |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index b778ed7..d8ab7e6 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -1,8 +1,6 @@
-menu "Userspace I/O"
-	depends on !S390
-
-config UIO
+menuconfig UIO
 	tristate "Userspace I/O drivers"
+	depends on !S390
 	default n
 	help
 	  Enable this to allow the userspace driver core code to be
@@ -13,6 +11,8 @@ config UIO
 
 	  If you don't know what to do here, say N.
 
+if UIO
+
 config UIO_CIF
 	tristate "generic Hilscher CIF Card driver"
 	depends on UIO && PCI
@@ -26,4 +26,4 @@ config UIO_CIF
 	  To compile this driver as a module, choose M here: the module
 	  will be called uio_cif.
 
-endmenu
+endif
-- 
1.5.4.5

