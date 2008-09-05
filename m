Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbYIEOij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbYIEOij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYIEOi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:38:28 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:33298 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbYIEOi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:38:27 -0400
From: Hannes Hering <hannes.hering@gmx.de>
Subject: [PATCH 2/2] ehea: Enable DLPAR memory remove
Date: Fri, 5 Sep 2008 16:38:22 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Disposition: inline
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       osstklei@de.ibm.com
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200809051638.22160.hannes.hering@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the capability flag to the capability list for dynamic LPAR
memory remove to enable this feature.

Signed-off-by: Hannes Hering <hering2@de.ibm.com>
---

diff -Nurp -X dontdiff linux-2.6.27-rc5/drivers/net/ehea/ehea.h patched_kernel/drivers/net/ehea/ehea.h
--- linux-2.6.27-rc5/drivers/net/ehea/ehea.h	2008-08-29 00:52:02.000000000 +0200
+++ patched_kernel/drivers/net/ehea/ehea.h	2008-09-05 15:33:12.000000000 +0200
@@ -40,13 +40,13 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0092"
+#define DRV_VERSION	"EHEA_0093"
 
 /* eHEA capability flags */
 #define DLPAR_PORT_ADD_REM 1
 #define DLPAR_MEM_ADD      2
 #define DLPAR_MEM_REM      4
-#define EHEA_CAPABILITIES  (DLPAR_PORT_ADD_REM | DLPAR_MEM_ADD)
+#define EHEA_CAPABILITIES  (DLPAR_PORT_ADD_REM | DLPAR_MEM_ADD | DLPAR_MEM_REM)
 
 #define EHEA_MSG_DEFAULT (NETIF_MSG_LINK | NETIF_MSG_TIMER \
 	| NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
