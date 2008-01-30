Return-Path: <linux-kernel-owner+w=401wt.eu-S1761204AbYA3JgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204AbYA3JgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758459AbYA3Jaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:30:46 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:40738 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756908AbYA3JaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:30:23 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47624092"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 11/12] [Blackfin] serial driver: ADSP-BF52x arch/mach support
Date: Wed, 30 Jan 2008 17:30:11 +0800
Message-Id: <1201685412-29095-12-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
References: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index d7e1996..27fffa4 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -667,7 +667,7 @@ config UART0_RTS_PIN
 
 config SERIAL_BFIN_UART1
 	bool "Enable UART1"
-	depends on SERIAL_BFIN && (BF534 || BF536 || BF537 || BF54x)
+	depends on SERIAL_BFIN && (BF52x || BF53x || BF54x)
 	help
 	  Enable UART1
 
-- 
1.5.3.4
