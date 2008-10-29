Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbYJ2Ble@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbYJ2Ble (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 21:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYJ2Bl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 21:41:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:16878 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYJ2BlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 21:41:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=j4sn5cqtmi7sggG0dhLdMEhPwAujeWFZoCHHY6a858X89GLGM7DB74O0H1ySQDIA8A
         n/2PjvAPxRGioWWuEdIvg1FB166BUjB4WHAyWM+ycD9O4SNdaciLuhSmHPu/WuDGYLyE
         rOT21u34AGskvZaQ2m6cxgHGMR//alemp6CZg=
Subject: [PATCH] pci: annotate return value of pci_ioremap_bar with __iomem
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 18:41:17 -0700
Message-Id: <1225244477.11483.69.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Arjan, when you added this helper I think you omitted the iomem
annotation.

 include/linux/pci.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index c75b82b..feb4657 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1136,7 +1136,7 @@ static inline void pci_mmcfg_late_init(void) { }
 #endif
 
 #ifdef CONFIG_HAS_IOMEM
-static inline void * pci_ioremap_bar(struct pci_dev *pdev, int bar)
+static inline void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)
 {
 	/*
 	 * Make sure the BAR is actually a memory resource, not an IO resource
-- 
1.6.0.3.756.gb776d



