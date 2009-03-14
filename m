Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbZCNJiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbZCNJiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 05:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZCNJhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 05:37:55 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:55531 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZCNJhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 05:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gwWqWkbTgcHaNhJbACW532zihVhXy/ZygTBC43koFlGhYMydrPALBOpl0m3Ooag1uj
         jh0t6ZTwaPAiWem9ccGKJuUE94IJIVB1zt2wt99kmfRQr8ZAT9KhrKDruIeefSmAbMcD
         5DFWNr/QGVT2k6QuIyYeb+9HQtQnrBStq8IE4=
Date: Sat, 14 Mar 2009 12:37:47 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
Subject: [PATCH] MMC: tmio_mmc.h: fix build problem
Message-ID: <20090314093747.GA4995@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/mmc/host/tmio_mmc.h: In function 'tmio_mmc_kmap_atomic':
drivers/mmc/host/tmio_mmc.h:147: error: implicit declaration of function 'kmap_atomic'
drivers/mmc/host/tmio_mmc.h:147: error: 'KM_BIO_SRC_IRQ' undeclared (first use in this function)
drivers/mmc/host/tmio_mmc.h: In function 'tmio_mmc_kunmap_atomic':
drivers/mmc/host/tmio_mmc.h:153: error: implicit declaration of function 'kunmap_atomic'
drivers/mmc/host/tmio_mmc.h:153: error: 'KM_BIO_SRC_IRQ' undeclared (first use in this function)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/mmc/host/tmio_mmc.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index ba2b424..9c831ab 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -8,6 +8,9 @@
  * published by the Free Software Foundation.
  *
  */
+
+#include <linux/highmem.h>
+
 #define CNF_CMD     0x04
 #define CNF_CTL_BASE   0x10
 #define CNF_INT_PIN  0x3d
