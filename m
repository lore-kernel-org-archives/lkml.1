Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbZAHAWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbZAHAWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 19:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZAHAWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 19:22:40 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:21732 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbZAHAWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 19:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=xKQWNYUiIE02lqS2Y9QeQrkaO+1oXvpnTfDiGCjuTZrt/N9/kXMTDaN7sWgpXuLNKN
         ssrMaK4Di/EwPFZ/r3mYvOmFcivpfl6r/bMR0spj40urDJaki8AHiqeIdPLIIhi83KGR
         gq2x2j3zm8k2NCoxTWhqHFWJxusJ4rHDS5SvM=
Subject: [PATCH] pci: __FUNCTION__ is gcc-specific, use __func__
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 16:22:37 -0800
Message-Id: <1231374157.5586.32.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
I guess checkpatch isn't a string enough warning :-/

 drivers/pci/pci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index c12f6c7..779f749 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -651,7 +651,7 @@ static int pci_save_pcie_state(struct pci_dev *dev)
 
 	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
 	if (!save_state) {
-		dev_err(&dev->dev, "buffer not found in %s\n", __FUNCTION__);
+		dev_err(&dev->dev, "buffer not found in %s\n", __func__);
 		return -ENOMEM;
 	}
 	cap = (u16 *)&save_state->data[0];
@@ -694,7 +694,7 @@ static int pci_save_pcix_state(struct pci_dev *dev)
 
 	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_PCIX);
 	if (!save_state) {
-		dev_err(&dev->dev, "buffer not found in %s\n", __FUNCTION__);
+		dev_err(&dev->dev, "buffer not found in %s\n", __func__);
 		return -ENOMEM;
 	}
 
-- 
1.6.1.94.g9388



