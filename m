Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbZFAL7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbZFAL7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 07:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbZFAL7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 07:59:12 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:29743 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbZFAL7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 07:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:to
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=L2SNXTTlbq5VoD4ZEVMcFH8hR4tfRCvA2iykO0t1QlxkRYh1rtnNf5lwZ4jXyD/PqT
         wPJ2vR4WRSbaRn2Fln/7gyKLSYwaKULQQNdc/hLncIFIxhj7kYuGiriWpqJag02NbGba
         S92TCC1EG3gj5poXVDa/41PDC6ORFHb2iZoNI=
From: Florian Fainelli <florian@openwrt.org>
Date: Mon, 1 Jun 2009 13:59:08 +0200
Subject: [PATCH 3/9] drivers: wire in vlynq bus support
MIME-Version: 1.0
X-Length: 1589
To: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       akpm <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906011359.09622.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the VLYNQ bus support
to be selected and compiled.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 00cf955..a442c8f 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -104,6 +104,8 @@ source "drivers/auxdisplay/Kconfig"
 
 source "drivers/uio/Kconfig"
 
+source "drivers/vlynq/Kconfig"
+
 source "drivers/xen/Kconfig"
 
 source "drivers/staging/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 1266ead..0d39303 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -105,5 +105,6 @@ obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_OF)		+= of/
 obj-$(CONFIG_SSB)		+= ssb/
 obj-$(CONFIG_VIRTIO)		+= virtio/
+obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
 obj-y				+= platform/
