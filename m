Return-Path: <linux-kernel-owner+w=401wt.eu-S932144AbZKDRc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbZKDRc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbZKDRcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:32:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129AbZKDRcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:32:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jPjxN6V+tqo3Jr9FbzVYUUQ193IA99pzskrVisvQtV/wIBWp3N2JfC9YSpQ32SAA+1
         tRQayQeqGq8fYqjyyz3CVfo1tCPMBPRyKtmBrPUgV0PRhlBNctl3DqUQaT62vbDzuf2z
         eR6So44TTPxRoVt/L8S2/xz2TwrOoib8+cftQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:32:32 +0100
Message-Id: <20091104173232.28463.47998.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/41] rt2800pci: fix comment about register access
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800pci: fix comment about register access

Registers used for indirect BBP and RF registers access are
respectively BBPCSR and RFCSR, also make it clear that all CSR
registers access goes through rt2x00pci_register_[read,write]()
methods.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -56,8 +56,10 @@ MODULE_PARM_DESC(nohwcrypt, "Disable har
 
 /*
  * Register access.
+ * All access to the CSR registers will go through the methods
+ * rt2x00pci_register_read and rt2x00pci_register_write.
  * BBP and RF register require indirect register access,
- * and use the CSR registers PHY_CSR3 and PHY_CSR4 to achieve this.
+ * and use the CSR registers BBPCSR and RFCSR to achieve this.
  * These indirect registers work with busy bits,
  * and we will try maximal REGISTER_BUSY_COUNT times to access
  * the register while taking a REGISTER_BUSY_DELAY us delay
