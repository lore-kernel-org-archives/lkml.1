Return-Path: <linux-kernel-owner+w=401wt.eu-S1751559AbXCaUs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbXCaUs6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 16:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXCaUs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 16:48:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39463 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751218AbXCaUs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 16:48:56 -0400
Date: Sat, 31 Mar 2007 22:48:56 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [-mm patch] make drivers/ata/pata_ali.c:ali_tf_load() static
Message-ID: <20070331204856.GY14134@stusta.de>
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070330010559.2a232d9a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 01:05:59AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc5-mm2:
>...
> +testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
> 
>  pata experiment
>...


This patch makes the needlesly global ali_tf_load() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc5-mm3/drivers/ata/pata_ali.c.old	2007-03-31 21:06:19.000000000 +0200
+++ linux-2.6.21-rc5-mm3/drivers/ata/pata_ali.c	2007-03-31 21:06:33.000000000 +0200
@@ -288,7 +288,7 @@
  *	Inherited from caller.
  */
 
-void ali_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
+static void ali_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 	unsigned int is_addr = tf->flags & ATA_TFLAG_ISADDR;


