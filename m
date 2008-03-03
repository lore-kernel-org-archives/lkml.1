Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbYCCMwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbYCCMwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbYCCMwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:52:10 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:9153 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbYCCMwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:52:09 -0500
From: Thomas Klein <osstklei@de.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] ehea: Fix missing Kconfig dependency
Date: Mon, 3 Mar 2008 13:52:06 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, netdev <netdev@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031352.06322.osstklei@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed Kconfig: ehea driver requires sparse mem

Signed-off-by: Thomas Klein <tklein@de.ibm.com>

---
diff -Nurp linux-2.6.25-rc3.org/drivers/net/Kconfig linux-2.6.25-rc3/drivers/net/Kconfig
--- linux-2.6.25-rc3.org/drivers/net/Kconfig	2008-02-24 22:25:54.000000000 +0100
+++ linux-2.6.25-rc3/drivers/net/Kconfig	2008-03-03 13:36:48.000000000 +0100
@@ -2513,7 +2513,7 @@ config CHELSIO_T3
 
 config EHEA
 	tristate "eHEA Ethernet support"
-	depends on IBMEBUS && INET
+	depends on IBMEBUS && INET && SPARSEMEM
 	select INET_LRO
 	---help---
 	  This driver supports the IBM pSeries eHEA ethernet adapter.
