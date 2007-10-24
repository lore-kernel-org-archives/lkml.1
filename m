Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbXJXMHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbXJXMHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbXJXMHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:07:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37294 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752754AbXJXMHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:07:03 -0400
Date: Wed, 24 Oct 2007 14:07:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>, bryan.wu@analog.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] blackfin: fix sg fallout
Message-ID: <20071024120732.GB30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
dc3f9077912fb66aabb61f336f7e2324ec2fa911 
diff --git a/arch/blackfin/kernel/dma-mapping.c b/arch/blackfin/kernel/dma-mapping.c
index a16cb03..d6b61d5 100644
--- a/arch/blackfin/kernel/dma-mapping.c
+++ b/arch/blackfin/kernel/dma-mapping.c
@@ -35,6 +35,7 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
+#include <linux/scatterlist.h>
 #include <asm/cacheflush.h>
 #include <asm/bfin-global.h>
 

