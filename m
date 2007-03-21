Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbXCUObV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbXCUObV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbXCUObV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:31:21 -0400
Received: from av1.karneval.cz ([81.27.192.123]:7644 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbXCUObU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:31:20 -0400
Message-id: <406898712076012596@karneval.cz>
In-reply-to: <9101217248700@karneval.cz>
Subject: [PATCH 2/2] Char: cs5535_gpio, add MODULE_DEVICE_TABLE
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Ben Gardner <bgardner@wabtec.com>
Date: Wed, 21 Mar 2007 15:31:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cs5535_gpio, add MODULE_DEVICE_TABLE

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 5c1471a017fdf505ae98b930a928753111661375
tree e54b3d338ea2bf7878620148f2bfd56196f8d2c3
parent c0854f5f8b3912aa8f31d329be14306349fb9a27
author Jiri Slaby <jirislaby@gmail.com> Wed, 21 Mar 2007 15:23:34 +0100
committer Jiri Slaby <jirislaby@gmail.com> Wed, 21 Mar 2007 15:23:34 +0100

 drivers/char/cs5535_gpio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/cs5535_gpio.c b/drivers/char/cs5535_gpio.c
index c02d9e9..fe6d240 100644
--- a/drivers/char/cs5535_gpio.c
+++ b/drivers/char/cs5535_gpio.c
@@ -44,6 +44,7 @@ static struct pci_device_id divil_pci[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
 	{ } /* NULL entry */
 };
+MODULE_DEVICE_TABLE(pci, divil_pci);
 
 static struct cdev cs5535_gpio_cdev;
 
