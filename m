Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZJZNWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZJZNWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbZJZNWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:22:18 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:47142 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbZJZNWR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=UoCETzNalcCAdFonvjH6CFW1QZJgFOqjfAdGci9l23OlTMZr79aPgyhTz2dX92Yb8+
         xOhpGCgTYokPKpXyNJVZ0TDPilPBfGeCN9Riq4qXf/JnUrCSPB4hFu1CVeO5j7HoExCR
         FKl8VthatdV6nluE74jFBfvc94XPsidweanaY=
MIME-Version: 1.0
Date: Mon, 26 Oct 2009 21:22:22 +0800
Message-ID: <b3657a100910260622w37cc2ab6nc0b52ce6e1a19f37@mail.gmail.com>
Subject: [PATCH]kernel/irq/chip.c:The code notes is not fit for the function.
From: liu weni <qingshenlwy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the origin, the code notes are not fit for set_irq_msi.
I modify the code notes, and no any changes for the code.


diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index c166019..da2f254 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -166,11 +166,11 @@ int set_irq_data(unsigned int irq, void *data)
 EXPORT_SYMBOL(set_irq_data);

 /**
- * set_irq_data - set irq type data for an irq
+ * set_irq_msi - set MSI descriptor data for an irq
  * @irq: Interrupt number
  * @entry: Pointer to MSI descriptor data
  *
- * Set the hardware irq controller data for an irq
+ * Set the MSI descriptor entry for an irq
  */
 int set_irq_msi(unsigned int irq, struct msi_desc *entry)
 {





Best Regards

Liuweni
