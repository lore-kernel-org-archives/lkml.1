Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbYAQUxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbYAQUxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYAQUxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:53:44 -0500
Received: from homer.mvista.com ([63.81.120.158]:3087 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751993AbYAQUxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:53:44 -0500
Message-Id: <20080117205205.878723737@mvista.com>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jan 2008 12:52:05 -0800
From: Daniel Walker <dwalker@mvista.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix wrong sized spinlock flags argument
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct wrong sized spinlock flags, form int to unsigned long.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/media/video/saa7134/saa7134-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/drivers/media/video/saa7134/saa7134-core.c
===================================================================
--- linux-2.6.23.orig/drivers/media/video/saa7134/saa7134-core.c
+++ linux-2.6.23/drivers/media/video/saa7134/saa7134-core.c
@@ -1212,7 +1212,7 @@ static int saa7134_resume(struct pci_dev
 {
 
 	struct saa7134_dev *dev = pci_get_drvdata(pci_dev);
-	unsigned int flags;
+	unsigned long flags;
 
 	pci_set_power_state(pci_dev, PCI_D0);
 	pci_restore_state(pci_dev);
-- 

-- 
