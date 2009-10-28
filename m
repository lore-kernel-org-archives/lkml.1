Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbZJ1EjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbZJ1EjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 00:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbZJ1EjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 00:39:13 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:46407 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZJ1EjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 00:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=G2mWcP6gza2ixETxH9+KwieFv3LnS5rKKmfWeeMd1g0bTNeZ9zGGXRbXG+vgz+Qoh6
         9M1K2H/BOvMAL9Gg3yUsVrUWbhZjFnd8R+fRaKE7AEM5U3a2jpVG5ZfuWNiTt3EB5/aD
         aruL1c1rkbQOMFOcWs/91Cy00xqBBIa6Scl60=
MIME-Version: 1.0
Date: Wed, 28 Oct 2009 12:39:17 +0800
Message-ID: <b3657a100910272139r65de6538rd80f7ff02877f7e6@mail.gmail.com>
Subject: Re: [PATCH]kernel/irq/chip.c:The code notes is not fit for the 
	function.
From: liu weni <qingshenlwy@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: qingshenlwy@tom.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Liuweni <qingshenlwy@gmail.com>


In the origin, the code notes are not fit for set_irq_msi.
I modify the code notes, and no any changes for the code.
Is it OK?? thanks!



diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index c166019..da2f254 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -166,11 +166,11 @@ int set_irq_data(unsigned int irq, void *data)
 EXPORT_SYMBOL(set_irq_data);

 /**
- * set_irq_data - set irq type data for an irq
+ * set_irq_msi - set MSI descriptor data for an irq
  * @irq: Interrupt number
  * @entry: Pointer to MSI descriptor data
  *
- * Set the hardware irq controller data for an irq
+ * Set the MSI descriptor entry for an irq
  */
 int set_irq_msi(unsigned int irq, struct msi_desc *entry)
 {





Best Regards

Liuweni
