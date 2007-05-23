Return-Path: <linux-kernel-owner+w=401wt.eu-S1762695AbXEWNXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695AbXEWNXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbXEWNXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:23:39 -0400
Received: from www.osadl.org ([213.239.205.134]:48599 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755664AbXEWNXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:23:38 -0400
Subject: [PATCH] Add select PHYLIB to the UCC_GETH Kconfig option
From: Jan Altenberg <jan.altenberg@linutronix.de>
To: jeff@garzik.org
Cc: kim.phillips@freescale.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain
Date: Wed, 23 May 2007 15:23:22 +0200
Message-Id: <1179926613.3839.47.camel@bender>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ucc_geth has been migrated to use the common phylib code. So lets add a
'select PHYLIB' to the UCC_GETH Kconfig entry.

Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>

---
 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/net/Kconfig
===================================================================
--- linux-2.6.orig/drivers/net/Kconfig
+++ linux-2.6/drivers/net/Kconfig
@@ -2280,6 +2280,7 @@ config GFAR_NAPI
 config UCC_GETH
 	tristate "Freescale QE Gigabit Ethernet"
 	depends on QUICC_ENGINE
+	select PHYLIB
 	select UCC_FAST
 	help
 	  This driver supports the Gigabit Ethernet mode of the QUICC Engine,


