Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbYBMW3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbYBMW3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758467AbYBMW26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:28:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:3110 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764375AbYBMW24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:28:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=NF2Uq8NbPCBoRq7wEx0Dit7NFGO5JiJsExCFYnAP+Wen0ihNTVA4qjTCeQuXXPYONwjn51qBOJctz4PhsgB+zK7HenVrXvtrVqjVJzWrO1q3rcIq3Aby6iyZBi3/l8irCFdjLGWKEysRLrXleTSvqDVB+9eA/1YAHx+ozX0EWqI=
From: Alessandro Guido <alessandro.guido@gmail.com>
To: hjk@linutronix.de
Subject: [PATCH] Use menuconfig for CONFIG_UIO
Date: Wed, 13 Feb 2008 23:28:19 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200802132328.19310.alessandro.guido@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessandro Guido <alessandro.guido@gmail.com>

---

 drivers/uio/Kconfig |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index b778ed7..dce4cae 100644
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
@@ -25,5 +23,3 @@ config UIO_CIF
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called uio_cif.
-
-endmenu
