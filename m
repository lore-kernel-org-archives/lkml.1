Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbYHPXvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbYHPXvn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 19:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYHPXvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 19:51:22 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:14173 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbYHPXvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 19:51:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=gsW4wOp+XvEX8HjwXnQmv/I2AfDx3XSmU964aPHkxXMbl4ipjwseV/VnCJJNHmK5xI
         g9gUNy+CkIzOeEHw1n3laquKiMJoR18slxkhY1cISnu94IqBx0rjed3WqsuffCW6La4t
         6CxloXhBds/pqv2NQnjEfke0nvfJT3Z3Xac/0=
Date: Sun, 17 Aug 2008 07:51:10 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: drzeus-mmc@drzeus.cx
Subject: [MMC] removed unused #include <version.h>
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080817070801.1622.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
  drivers/mmc/host/sdricoh_cs.c

This patch removes the said #include <version.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index f99e9f7..1df44d9 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -29,7 +29,6 @@
 #include <linux/pci.h>
 #include <linux/ioport.h>
 #include <linux/scatterlist.h>
-#include <linux/version.h>
 
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>

