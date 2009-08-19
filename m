Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZHSQYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZHSQYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZHSQYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:24:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42852 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753170AbZHSQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:24:47 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/2] altpciechdma: 64bit type warning fix
To: linux-kernel@vger.kernel.org
Date: Wed, 19 Aug 2009 17:20:20 +0100
Message-ID: <20090819162019.8342.82358.stgit@localhost.localdomain>
In-Reply-To: <20090819162011.8342.89107.stgit@localhost.localdomain>
References: <20090819162011.8342.89107.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/altpciechdma/altpciechdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/altpciechdma/altpciechdma.c b/drivers/staging/altpciechdma/altpciechdma.c
index 3724b8a..e0c5ba4 100644
--- a/drivers/staging/altpciechdma/altpciechdma.c
+++ b/drivers/staging/altpciechdma/altpciechdma.c
@@ -550,7 +550,7 @@ static int __devinit dma_test(struct ape_dev *ape, struct pci_dev *dev)
 #if 0
 		*(u32 *)(buffer_virt + i) = i / PAGE_SIZE + 1;
 #else
-		*(u32 *)(buffer_virt + i) = (buffer_virt + i);
+		*(u32 *)(buffer_virt + i) = (u32)(unsigned long)(buffer_virt + i);
 #endif
 #if 0
   compare((u32 *)buffer_virt, (u32 *)(buffer_virt + 2 * PAGE_SIZE), 8192);

