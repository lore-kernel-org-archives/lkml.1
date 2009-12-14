Return-Path: <linux-kernel-owner+w=401wt.eu-S933018AbZLNVSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbZLNVSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932994AbZLNVSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:18:16 -0500
Received: from exprod6og108.obsmtp.com ([64.18.1.21]:36661 "EHLO
	exprod6og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979AbZLNVSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:18:15 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] excite_nandflash.c: user resource_size()
Date: Mon, 14 Dec 2009 16:18:15 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA4A@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] excite_nandflash.c: user resource_size()
Thread-Index: Acp9AvLJj5tFqik7TsKLA1AzisKEHg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 21:18:13.0557 (UTC) FILETIME=[F1EA9650:01CA7D02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/nand/excite_nandflash.c b/drivers/mtd/nand/excite_nandflash.c
index 72446fb..bd323e4 100644
--- a/drivers/mtd/nand/excite_nandflash.c
+++ b/drivers/mtd/nand/excite_nandflash.c
@@ -79,7 +79,7 @@ excite_nand_map_regs(struct platform_device *d, const char *basename)
 	    excite_nand_get_resource(d, IORESOURCE_MEM, basename);
 
 	if (r)
-		result = ioremap_nocache(r->start, r->end + 1 - r->start);
+		result = ioremap_nocache(r->start, resource_size(r));
 	return result;
 }
  
