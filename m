Return-Path: <linux-kernel-owner+w=401wt.eu-S1751362AbZCFGnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbZCFGnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZCFGlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:41:02 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:33492 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbZCFGk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:40:56 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83883651"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 07/18] Blackfin Serial Driver: BF538/9 Linux kernel Support
Date: Fri,  6 Mar 2009 14:42:49 +0800
Message-Id: <1236321780-28718-8-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Enable third UART on BF538/9

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 7d7f576..d2082fd 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -770,7 +770,7 @@ config UART1_RTS_PIN
 
 config SERIAL_BFIN_UART2
 	bool "Enable UART2"
-	depends on SERIAL_BFIN && (BF54x)
+	depends on SERIAL_BFIN && (BF54x || BF538 || BF539)
 	help
 	  Enable UART2
 
-- 
1.5.6.3
