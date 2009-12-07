Return-Path: <linux-kernel-owner+w=401wt.eu-S934631AbZLGD4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934631AbZLGD4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbZLGDwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:52:55 -0500
Received: from xenotime.net ([72.52.64.118]:40688 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934489AbZLGDwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:52:54 -0500
Date: Sun, 06 Dec 2009 18:30:44 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Marin Mitov <mitov@issp.bas.bg>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/6] docs: use DMA_BIT_MASK instead of inline constant
Message-ID: <1260153044407@xenotime.net>
In-Reply-To: <12601530442994@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marin Mitov <mitov@issp.bas.bg>
Subject: use DMA_BIT_MASK instead of inline constant

Use DMA_BIT_MASK(24) instead of 0x00ffffff in DMA-mapping.txt

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DMA-mapping.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2632-rc6.orig/Documentation/DMA-mapping.txt
+++ lnx-2632-rc6/Documentation/DMA-mapping.txt
@@ -214,7 +214,7 @@ most specific mask.
 Here is pseudo-code showing how this might be done:
 
 	#define PLAYBACK_ADDRESS_BITS	DMA_BIT_MASK(32)
-	#define RECORD_ADDRESS_BITS	0x00ffffff
+	#define RECORD_ADDRESS_BITS	DMA_BIT_MASK(24)
 
 	struct my_sound_card *card;
 	struct pci_dev *pdev;


-- 

