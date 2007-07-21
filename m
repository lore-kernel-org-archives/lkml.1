Return-Path: <linux-kernel-owner+w=401wt.eu-S940127AbXGUPJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940127AbXGUPJm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933401AbXGUPDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:03:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:40095 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939385AbXGUPDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:03:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=Enm6eNl0f39bVlymouimvVehIRQli7uAv0KBq95AEOqCSk486GTIFK6BX+whdRVt5MIhptv1OJlI5/+YV9UO59jIqs+2APDTzEZv1YiuqwqvUm0wYedYDQXv/tiIzJlBFJ81j1GO3sLOitOyJfjtwEaMTDMfpDQ9eaikAbafs9I=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][14/37] Clean up duplicate includes in drivers/spi/
Date: Sat, 21 Jul 2007 17:02:56 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net, Nicolas Pitre <nico@cam.org>,
       Aubrey Li <aubrey.li@analog.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211702.56466.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	drivers/spi/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
index e51311b..16bf66b 100644
--- a/drivers/spi/pxa2xx_spi.c
+++ b/drivers/spi/pxa2xx_spi.c
@@ -26,7 +26,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/spi/spi.h>
 #include <linux/workqueue.h>
-#include <linux/errno.h>
 #include <linux/delay.h>
 
 #include <asm/io.h>
diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 48587c2..88362b4 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -39,7 +39,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/spi/spi.h>
 #include <linux/workqueue.h>
-#include <linux/errno.h>
 #include <linux/delay.h>
 
 #include <asm/io.h>
