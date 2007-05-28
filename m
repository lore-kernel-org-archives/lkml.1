Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbXE1IkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbXE1IkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761449AbXE1Igp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:45 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:49098 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759314AbXE1Ige (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:34 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="31069466:sNHT22074416"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 10/20] Blackfin arch: scrub old console defines
Date: Mon, 28 May 2007 16:37:45 +0800
Message-Id: <1180341479747-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

since they arent respected anymore (use console=) and just confuse people

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/Kconfig |   35 -----------------------------------
 1 files changed, 0 insertions(+), 35 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index b1b111b..1fad856 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -394,41 +394,6 @@ config BFIN_IDLE_LED_PIN
 	default 0x08 if (BFIN533_STAMP && BFIN_IDLE_LED_NUM = 2)
 	default 0x10 if (BFIN533_STAMP && BFIN_IDLE_LED_NUM = 3)
 
-comment "Console UART Setup"
-
-choice
-	prompt "Baud Rate"
-	default BAUD_57600
-config BAUD_9600
-	bool "9600"
-config BAUD_19200
-	bool "19200"
-config BAUD_38400
-	bool "38400"
-config BAUD_57600
-	bool "57600"
-config BAUD_115200
-	bool "115200"
-endchoice
-
-choice
-	prompt "Parity"
-	default BAUD_NO_PARITY
-config  BAUD_NO_PARITY
-	bool "No Parity"
-config  BAUD_PARITY
-	bool "Parity"
-endchoice
-
-choice
-	prompt "Stop Bits"
-	default BAUD_1_STOPBIT
-config  BAUD_1_STOPBIT
-	bool "1"
-config  BAUD_2_STOPBIT
-	bool "2"
-endchoice
-
 endmenu
 
 
-- 
1.5.2
