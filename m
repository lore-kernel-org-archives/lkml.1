Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYKHIc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYKHIc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 03:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYKHIcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 03:32:17 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:57011 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbYKHIcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 03:32:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=R/InXvdgUu/1X5uG9WCfrKR7d/qramjeXWsWTlkvfqwehi82WeQdEyvxYA2C/a3K3k
         sXUNeyw+g1QXoNBVUt02vFWl9ZyKktF8Q8hzfKbMtPD9EnZ9+jaBPuwAMxnvewynmycA
         IJQ9V0380IaGcmqY7pVmuvL469zmjANcCbaQo=
Date: Sat, 8 Nov 2008 16:32:02 +0800
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] /drivers/ata/pata_cs553*.c: cleanup kerneldoc
Message-ID: <20081108163202.031b2a94@ubuntu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no arguments named @deadline in cs5535_cable_detect() and cs5536_cable_detect(), 
remove them.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index 1b2d4a0..8b236af 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -72,7 +72,6 @@
 /**
  *	cs5535_cable_detect	-	detect cable type
  *	@ap: Port to detect on
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection for ATA66 capable cable. Return a libata
  *	cable type.
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 73f8332..afed929 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -110,7 +110,6 @@ static inline int cs5536_write(struct pci_dev *pdev, int reg, int val)
 /**
  *	cs5536_cable_detect	-	detect cable type
  *	@ap: Port to detect on
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection for ATA66 capable cable. Return a libata
  *	cable type.
