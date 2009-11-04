Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbZKDMLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbZKDMLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZKDMLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:11:09 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:61929 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbZKDMLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:11:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=VoZJtYQBBD+dWmfK3HiMaTgGrOsTBDu3WikRE4ZEE3ydYEwmQxWOrFyjvWvGm/VaA7
         TfGfOUObp05I2eLsjX09ADmNKWDwV3YyEtz49bmT34oNet8zWAEp3FbUJJL+ncMd88Ip
         DAQzeWuiZMrbrUEP45bQywf8TRAvquGh0e6jI=
Date: Wed, 4 Nov 2009 20:11:05 +0800
From: "Liuweni" <qingshenlwy@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "qingshenlwy" <qingshenlwy@tom.com>, "xgr178" <xgr178@163.com>
Subject: [PATCH]kernel/irq/chip.c:Modify the code note
Message-ID: <200911042011027500109@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the origin, the code notes are not fit for set_irq_msi. 
The function name is set_irq_data.

And, I change function note "handle_percpu_IRQ" to "handle_percpu_irq".


Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>

------------------------------------------
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index c166019..ba566c2 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -166,11 +166,11 @@ int set_irq_data(unsigned int irq, void *data)
 EXPORT_SYMBOL(set_irq_data);
 
 /**
- *	set_irq_data - set irq type data for an irq
+ *	set_irq_msi - set MSI descriptor data for an irq
  *	@irq:	Interrupt number
  *	@entry:	Pointer to MSI descriptor data
  *
- *	Set the hardware irq controller data for an irq
+ *	Set the MSI descriptor entry for an irq
  */
 int set_irq_msi(unsigned int irq, struct msi_desc *entry)
 {
@@ -590,7 +590,7 @@ out_unlock:
 }
 
 /**
- *	handle_percpu_IRQ - Per CPU local irq handler
+ *	handle_percpu_irq - Per CPU local irq handler
  *	@irq:	the interrupt number
  *	@desc:	the interrupt description structure for this irq
  *

 				
--------------
Liuweni
2009-11-04

