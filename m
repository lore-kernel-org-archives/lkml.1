Return-Path: <linux-kernel-owner+w=401wt.eu-S934465AbZJMWOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465AbZJMWOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934442AbZJMWOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:14:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:61023 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761545AbZJMWOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:14:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F2eZYRQt/78nqkC68yQ1G7lB7Noc3/l7ph6Iw8SgqE83CcUj8TTVIV0b18CrARSD63
         fIqSXL9vGHgR9WUEZuIyU8c7GDGegL8lFy5pomJ2AvlYjttaaJHvHC0jjViqe1JRaz2K
         yOJgqqpVAsEjzbQRBIEZUP8imr6xcrY25lbAQ=
From: Paul Fertser <fercerpav@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Nelson Castillo <arhuaco@freaks-unidos.net>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 3/7] mfd: pcf50633: move messages to appropriate log levels
Date: Wed, 14 Oct 2009 02:12:32 +0400
Message-Id: <1255471956-29201-3-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255471956-29201-2-git-send-email-fercerpav@gmail.com>
References: <1255471956-29201-1-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-2-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaud Patard <arnaud.patard@rtp-net.org>

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/mfd/pcf50633-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index a844445..48776d3 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -290,7 +290,7 @@ out:
 
 int pcf50633_irq_mask(struct pcf50633 *pcf, int irq)
 {
-	dev_info(pcf->dev, "Masking IRQ %d\n", irq);
+	dev_dbg(pcf->dev, "Masking IRQ %d\n", irq);
 
 	return __pcf50633_irq_mask_set(pcf, irq, 1);
 }
@@ -298,7 +298,7 @@ EXPORT_SYMBOL_GPL(pcf50633_irq_mask);
 
 int pcf50633_irq_unmask(struct pcf50633 *pcf, int irq)
 {
-	dev_info(pcf->dev, "Unmasking IRQ %d\n", irq);
+	dev_dbg(pcf->dev, "Unmasking IRQ %d\n", irq);
 
 	return __pcf50633_irq_mask_set(pcf, irq, 0);
 }
-- 
1.6.0.6

