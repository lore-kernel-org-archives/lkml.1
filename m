Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbZFDOU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbZFDOU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbZFDOUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:20:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:40241 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbZFDOUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:20:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:to
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=n1Ml/beAqnhVQ6XOHYMOwuxayhAJ1XHMY5mHccd9O9HH2Ol4LEjEbZ9v0dbWN8TM/e
         4DRBIAOBaUVSPaFVOZT113u1zCvkhtpVVFVq5T3PrJ/bXr/p2V3zbznt75W0H4hhutkM
         Jh5iSdxAHuBvOBHbqDeWirXW29vA3HwzTO6Lk=
From: Florian Fainelli <florian@openwrt.org>
Date: Thu, 4 Jun 2009 16:20:39 +0200
Subject: [PATCH 7/8] ar7_wdt: fix path to ar7 header files
MIME-Version: 1.0
X-Length: 1325
To: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041620.39752.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While resubmitting AR7, we changed the machine specific
headers from ar7 to mach-ar7, fix the watchdog driver
accordingly.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 55dcbfe..bfce332 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -37,7 +37,7 @@
 #include <linux/uaccess.h>
 
 #include <asm/addrspace.h>
-#include <asm/ar7/ar7.h>
+#include <asm/mach-ar7/ar7.h>
 
 #define DRVNAME "ar7_wdt"
 #define LONGNAME "TI AR7 Watchdog Timer"
