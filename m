Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYHUErv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYHUErv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 00:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYHUErI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 00:47:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:60659 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbYHUErG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 00:47:06 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 3/9] netdev: drop CONFIG_PPC_MERGE from Kconfig
Date: Wed, 20 Aug 2008 23:46:52 -0500
Message-Id: <1219294018-12557-4-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1219294018-12557-3-git-send-email-galak@kernel.crashing.org>
References: <1219294018-12557-1-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-2-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-3-git-send-email-galak@kernel.crashing.org>
CC: netdev@vger.kernel.org
CC: jgarzik@pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that arch/ppc is dead CONFIG_PPC_MERGE is always defined for all
powerpc platforms so we don't need to depend on it.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/net/Kconfig             |    2 +-
 drivers/net/ibm_newemac/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index a5c141c..dd2cafb 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -1813,7 +1813,7 @@ config FEC2
 
 config FEC_MPC52xx
 	tristate "MPC52xx FEC driver"
-	depends on PPC_MERGE && PPC_MPC52xx && PPC_BESTCOMM_FEC
+	depends on PPC_MPC52xx && PPC_BESTCOMM_FEC
 	select CRC32
 	select PHYLIB
 	---help---
diff --git a/drivers/net/ibm_newemac/Kconfig b/drivers/net/ibm_newemac/Kconfig
index 70a3272..bcec732 100644
--- a/drivers/net/ibm_newemac/Kconfig
+++ b/drivers/net/ibm_newemac/Kconfig
@@ -1,6 +1,6 @@
 config IBM_NEW_EMAC
 	tristate "IBM EMAC Ethernet support"
-	depends on PPC_DCR && PPC_MERGE
+	depends on PPC_DCR
 	select CRC32
 	help
 	  This driver supports the IBM EMAC family of Ethernet controllers
-- 
1.5.5.1

