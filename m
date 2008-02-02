Return-Path: <linux-kernel-owner+w=401wt.eu-S932134AbYBBJvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbYBBJvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYBBJvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:51:31 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:43498 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYBBJva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:51:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Zxa8EftifDpaggk+XnWCEtE8un+pDC7OG1ZGyGZHeN6WErXtifk07sOVOSMN74dc/CkRR1/FrdQXw7tNSzd9hKUsce8Lrd9Dbt5myAzLeOvCltNZ5cRJ1XMf9MSfrTU6syK+SG1LKlFuxPYLzjE54hORSLvsJNsg5ODjM2bBiM0=
From: Denis Cheng <crquan@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: [PATCH 1/3] uio: Kconfig improvements
Date: Sat,  2 Feb 2008 17:51:35 +0800
Message-Id: <1201945897-32297-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
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
1.5.3.8

