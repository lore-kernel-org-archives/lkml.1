Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbYELEK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbYELEK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbYELEKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:10:12 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:20381 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYELEKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:10:09 -0400
X-IronPort-AV: E=Sophos;i="4.27,470,1204520400"; 
   d="scan'208";a="68119600"
From: Bryan Wu <cooloney@kernel.org>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/3] Blackfin SPORTS UART Driver: converting BFIN->BLACKFIN
Date: Mon, 12 May 2008 12:10:07 +0800
Message-Id: <1210565409-3655-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1210565409-3655-1-git-send-email-cooloney@kernel.org>
References: <1210565409-3655-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 36acbcc..c88cd1d 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1357,7 +1357,7 @@ config SERIAL_SC26XX_CONSOLE
 
 config SERIAL_BFIN_SPORT
 	tristate "Blackfin SPORT emulate UART (EXPERIMENTAL)"
-	depends on BFIN && EXPERIMENTAL
+	depends on BLACKFIN && EXPERIMENTAL
 	select SERIAL_CORE
 	help
 	  Enble support SPORT emulate UART on Blackfin series.
-- 
1.5.5
