Return-Path: <linux-kernel-owner+w=401wt.eu-S936932AbXG3Pzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936932AbXG3Pzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 11:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936407AbXG3PyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 11:54:19 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:50534 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936307AbXG3PyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 11:54:11 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
Subject: [PATCH 4/4][RFC] ehea: Kconfig
Date: Mon, 30 Jul 2007 17:24:55 +0200
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Disposition: inline
To: netdev <netdev@vger.kernel.org>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       David Miller <davem@davemloft.net>, Andrew Gallatin <gallatin@myri.com>,
       Jeff Garzik <jeff@garzik.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707301724.55804.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig changes for LRO

Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

---
 drivers/net/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index f8a602c..fec4004 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2399,6 +2399,7 @@ config CHELSIO_T3
 config EHEA
 	tristate "eHEA Ethernet support"
 	depends on IBMEBUS
+	select INET_LRO
 	---help---
 	  This driver supports the IBM pSeries eHEA ethernet adapter.
 
-- 
1.5.2

