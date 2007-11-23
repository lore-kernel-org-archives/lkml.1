Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbXKWKD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbXKWKD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbXKWKDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:03:20 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:9354 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbXKWKDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:03:19 -0500
X-IronPort-AV: i="4.21,455,1188792000"; 
   d="scan'208"; a="44106781:sNHT281693139"
From: Bryan Wu <bryan.wu@analog.com>
To: dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/1] [INPUT/KEYPAD] Blackfin BF54x keypad driver: keypad does not exist on BF544 parts
Date: Fri, 23 Nov 2007 18:03:13 +0800
Message-Id: <1195812193-25553-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/input/keyboard/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 2316a01..dfa6592 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -286,7 +286,7 @@ config KEYBOARD_MAPLE
 
 config KEYBOARD_BFIN
 	tristate "Blackfin BF54x keypad support"
-	depends on BF54x
+	depends on (BF54x && !BF544)
 	help
 	  Say Y here if you want to use the BF54x keypad.
 
-- 
1.5.3.4
