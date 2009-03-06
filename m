Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZCFGoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZCFGoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZCFGlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:41:04 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:33492 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbZCFGk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:40:57 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83883658"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 13/18] Blackfin Serial Driver: depend on KGDB_SERIAL_CONSOLE being set to N
Date: Fri,  6 Mar 2009 14:42:55 +0800
Message-Id: <1236321780-28718-14-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Depend on KGDB_SERIAL_CONSOLE being set to N rather than !Y,
since it can be built as a module.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 21936c1..87f41ed 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -700,7 +700,7 @@ choice
 
 config SERIAL_BFIN_DMA
 	bool "DMA mode"
-	depends on !DMA_UNCACHED_NONE && !KGDB_SERIAL_CONSOLE
+	depends on !DMA_UNCACHED_NONE && KGDB_SERIAL_CONSOLE=n
 	help
 	  This driver works under DMA mode. If this option is selected, the
 	  blackfin simple dma driver is also enabled.
-- 
1.5.6.3
