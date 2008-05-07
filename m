Return-Path: <linux-kernel-owner+w=401wt.eu-S1759949AbYEGMok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949AbYEGMok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 08:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbYEGMnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 08:43:40 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:9449 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759101AbYEGMnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 08:43:37 -0400
Subject: [PATCH 2/3] [2.6.26] ehea: Add dependency to Kconfig
Content-Disposition: inline
From: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
Date: Wed, 7 May 2008 14:43:20 +0200
MIME-Version: 1.0
Organization: IBM
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       tklein@de.ibm.com
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200805071443.20192.hannes.hering@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new ehea memory hot plug implementation depends on MEMORY_HOTPLUG.

Signed-off-by: Hannes Hering <hering2@de.ibm.com>
---

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index f90a86b..181cd86 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2440,7 +2440,7 @@ config CHELSIO_T3
 
 config EHEA
 	tristate "eHEA Ethernet support"
-	depends on IBMEBUS && INET && SPARSEMEM
+	depends on IBMEBUS && INET && SPARSEMEM && MEMORY_HOTPLUG
 	select INET_LRO
 	---help---
 	  This driver supports the IBM pSeries eHEA ethernet adapter.
-- 
1.5.5.1
