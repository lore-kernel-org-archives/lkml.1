Return-Path: <linux-kernel-owner+w=401wt.eu-S1762862AbXGYUsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862AbXGYUsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762494AbXGYUr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:47:56 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:31570 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762497AbXGYUrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:47:55 -0400
Date: Wed, 25 Jul 2007 14:55:21 -0600
From: dougthompson@xmission.com
To: greg@kroah.com, ralf@linux-mips.org, egor@pasemi.com,
       dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 4/4] drivers edac fix pasemi kconfig depends
Message-ID: <46a7b8b9.eCfpRPp+WuNBtm5V%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Doug Thompson <dougthompson@xmission.com>

Fixed  'depends on PPC_PASEMI' in EDAC Kconfig.
Module PASEMI depends ONLY on the PASEMI on PPC. 

Was previously enabled for ALL PPC 

Cc:             Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc:		Egor N. Martovetsky <egor@pasemi.com>
Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
---
 Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-rc1/drivers/edac/Kconfig
===================================================================
--- linux-2.6.23-rc1.orig/drivers/edac/Kconfig
+++ linux-2.6.23-rc1/drivers/edac/Kconfig
@@ -126,7 +126,7 @@ config EDAC_I5000
 config EDAC_PASEMI
 	tristate "PA Semi PWRficient"
 	depends on EDAC_MM_EDAC && PCI
-	depends on PPC
+	depends on PPC_PASEMI
 	help
 	  Support for error detection and correction on PA Semi
 	  PWRficient.
