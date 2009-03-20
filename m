Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbZCTLvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbZCTLvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 07:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbZCTLvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 07:51:41 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:59023 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZCTLvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 07:51:41 -0400
X-Greylist: delayed 2697 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Mar 2009 07:51:41 EDT
From: Ilya Yanok <yanok@emcraft.com>
To: heiko.carstens@de.ibm.com
Cc: sfr@canb.auug.org.au, davem@davemloft.net, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ilya Yanok <yanok@emcraft.com>
Subject: [PATCH] dnet: DNET should depend on HAS_IOMEM
Date: Fri, 20 Mar 2009 14:06:25 +0300
Message-Id: <1237547185-20088-1-git-send-email-yanok@emcraft.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090320101401.6ea261ea@osiris.boeblingen.de.ibm.com>
References: <20090320101401.6ea261ea@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ilya Yanok <yanok@emcraft.com>
---
 drivers/net/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 435e2e3..62d732a 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -1042,7 +1042,7 @@ config NI65
 
 config DNET
 	tristate "Dave ethernet support (DNET)"
-	depends on NET_ETHERNET
+	depends on NET_ETHERNET && HAS_IOMEM
 	select PHYLIB
 	help
 	  The Dave ethernet interface (DNET) is found on Qong Board FPGA.
-- 
1.6.2

