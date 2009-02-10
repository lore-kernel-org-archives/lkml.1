Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZBJLKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZBJLKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 06:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZBJLKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 06:10:44 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:7936 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZBJLKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 06:10:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:bcc:subject:date:user-agent;
        b=MF4TyiTLDXGXBo309UDgOrgMs/KKmblUHyAhKUaPw0cFhllc0BoKgRPbFkYUbPWF7t
         Qyr0DkiU60ZII+/QRuDVYG2X4AQPCfQhPnwbRDjY6W7Z6Pb6nPZn7hK4ec9fWi2G94ck
         GUA6MGUTA/CZ5uI+TBFJsesQUvWuYJPWHuKQo=
Message-ID: <499160b0.0e1b6e0a.4589.6461@mx.google.com>
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] : kernel/irq/devres.c:fix kernel-doc
Date: Tue, 10 Feb 2009 19:10:37 +0800
User-Agent: sniper-patch-carrier/1.06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo, change dev_{free|request}_irq to devm_{free|request}_irq.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
index 38a25b8..30b17de 100644
--- a/kernel/irq/devres.c
+++ b/kernel/irq/devres.c
@@ -40,7 +40,7 @@ static int devm_irq_match(struct device *dev, void *res, void *data)
  *	automatically freed on driver detach.
  *
  *	If an IRQ allocated with this function needs to be freed
- *	separately, dev_free_irq() must be used.
+ *	separately, devm_free_irq() must be used.
  */
 int devm_request_irq(struct device *dev, unsigned int irq,
 		     irq_handler_t handler, unsigned long irqflags,
@@ -77,7 +77,7 @@ EXPORT_SYMBOL(devm_request_irq);
  *	Except for the extra @dev argument, this function takes the
  *	same arguments and performs the same function as free_irq().
  *	This function instead of free_irq() should be used to manually
- *	free IRQs allocated with dev_request_irq().
+ *	free IRQs allocated with devm_request_irq().
  */
 void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id)
 {

