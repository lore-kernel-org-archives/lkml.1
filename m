Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZKEALw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZKEALw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZKEALN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:11:13 -0500
Received: from xenotime.net ([72.52.64.118]:55605 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751601AbZKEALM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:11:12 -0500
Date: Wed, 04 Nov 2009 16:04:52 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Marin Mitov <mitov@issp.bas.bg>
Subject: [PATCH 3/8] docs: use DMA_BIT_MASK
Message-ID: <12573794921038@xenotime.net>
In-Reply-To: <1257379492822@xenotime.net>
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

