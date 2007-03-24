Return-Path: <linux-kernel-owner+w=401wt.eu-S1751037AbXCXNG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037AbXCXNG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 09:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbXCXNG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 09:06:57 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33358 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751037AbXCXNGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 09:06:41 -0400
Date: Sat, 24 Mar 2007 14:06:44 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] #if 0 dmi_name_in_vendors()
Message-ID: <20070324130644.GH752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dmi_name_in_vendors() is no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/firmware/dmi_scan.c |    2 ++
 include/linux/dmi.h         |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.21-rc4-mm1/include/linux/dmi.h.old	2007-03-23 23:22:41.000000000 +0100
+++ linux-2.6.21-rc4-mm1/include/linux/dmi.h	2007-03-23 23:22:48.000000000 +0100
@@ -69,7 +69,6 @@
 	struct dmi_device *from);
 extern void dmi_scan_machine(void);
 extern int dmi_get_year(int field);
-extern int dmi_name_in_vendors(char *str);
 
 #else
 
@@ -78,7 +77,6 @@
 static inline struct dmi_device * dmi_find_device(int type, const char *name,
 	struct dmi_device *from) { return NULL; }
 static inline int dmi_get_year(int year) { return 0; }
-static inline int dmi_name_in_vendors(char *s) { return 0; }
 
 #endif
 
--- linux-2.6.21-rc4-mm1/drivers/firmware/dmi_scan.c.old	2007-03-23 23:22:59.000000000 +0100
+++ linux-2.6.21-rc4-mm1/drivers/firmware/dmi_scan.c	2007-03-23 23:23:12.000000000 +0100
@@ -327,6 +327,7 @@
 EXPORT_SYMBOL(dmi_get_system_info);
 
 
+#if 0
 /**
  *	dmi_name_in_vendors - Check if string is anywhere in the DMI vendor information.
  *	@str: 	Case sensitive Name
@@ -345,6 +346,7 @@
 	return 0;
 }
 EXPORT_SYMBOL(dmi_name_in_vendors);
+#endif  /*  0  */
 
 /**
  *	dmi_find_device - find onboard device by type/name

