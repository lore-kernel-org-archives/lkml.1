Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYKBVc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYKBVc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYKBVct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:32:49 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:64160 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbYKBVct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:32:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=vJf0t++mFwEG4ipHJbH2nXNXw2QDiZSP0eTx9ZALiUR+YIlGbi3kdymonVM97v9h4g
         NZfB4/iXRrmueMyiuIDDo7zOkqXjvKkqYRKWZI9xe1K6KjIoHI8NK0WQc9qn2LreGVgQ
         46MCuYk+TMHo3hbXFUwdwvg0plKpwq1E4mAgE=
Subject: [PATCH] pci: annotate return value of pci_ioremap_bar with __iomem
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 02 Nov 2008 13:32:43 -0800
Message-Id: <1225661563.5496.65.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/pci.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9194adf..03b0b8c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1142,7 +1142,7 @@ static inline void pci_mmcfg_late_init(void) { }
 #endif
 
 #ifdef CONFIG_HAS_IOMEM
-static inline void * pci_ioremap_bar(struct pci_dev *pdev, int bar)
+static inline void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)
 {
 	/*
 	 * Make sure the BAR is actually a memory resource, not an IO resource
-- 
1.6.0.3.756.gb776d



