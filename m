Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbYGGWES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbYGGWES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbYGGWBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:01:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:6550 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758683AbYGGWAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=UJLVJlgQjYQB+S2B7i9gJbFsJIOkKm7O1yEN4aA5UGDb9wM0My5G+VYk3ro2xjxc/o
         Ph2C/sV2PPbHCqs+PpZBBtqNDNvUULga9VBynByqv7V8ViBO20KorJf0FrKFYCyBCfpB
         idgECFBV/L4v/3ekhEGyeFgOJmErp9IKj+j9o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 7/10] ide-generic: remove broken PPC_PREP support
Date: Mon, 7 Jul 2008 23:55:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807072355.27868.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PPC_PREP has been depending on BROKEN for some time now.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/asm-powerpc/ide.h |   18 ------------------
 1 file changed, 18 deletions(-)

Index: b/include/asm-powerpc/ide.h
===================================================================
--- a/include/asm-powerpc/ide.h
+++ b/include/asm-powerpc/ide.h
@@ -32,16 +32,6 @@ static __inline__ int ide_default_irq(un
 	case 0x170:	return 15;
 	}
 #endif
-#ifdef CONFIG_PPC_PREP
-	switch (base) {
-	case 0x1f0:	return 13;
-	case 0x170:	return 13;
-	case 0x1e8:	return 11;
-	case 0x168:	return 10;
-	case 0xfff0:	return 14;	/* MCP(N)750 ide0 */
-	case 0xffe0:	return 15;	/* MCP(N)750 ide1 */
-	}
-#endif
 	return 0;
 }
 
@@ -54,14 +44,6 @@ static __inline__ unsigned long ide_defa
 	case 1:		return 0x170;
 	}
 #endif
-#ifdef CONFIG_PPC_PREP
-	switch (index) {
-	case 0:		return 0x1f0;
-	case 1:		return 0x170;
-	case 2:		return 0x1e8;
-	case 3:		return 0x168;
-	}
-#endif
 	return 0;
 }
 
