Return-Path: <linux-kernel-owner+w=401wt.eu-S1161024AbXD2Uzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161024AbXD2Uzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161151AbXD2Uzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:55:32 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:49411 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161113AbXD2Uyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:54:50 -0400
Message-id: <213961181486726912@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 3/21] Char: cyclades, depends on PCI or ISA
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 22:54:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, depends on PCI or ISA

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 3441ca636014ff919d5b2b2e920b76dbe7ed9686
tree ce47d830269c31d539649d2e270eb1cce765e546
parent c5c2e708444ec573636733bb28ecd66d1753aa8f
author Jiri Slaby <jirislaby@gmail.com> Wed, 25 Apr 2007 11:33:32 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 27 Apr 2007 13:14:57 +0200

 drivers/char/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index cf72828..73442e0 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -127,7 +127,7 @@ config ROCKETPORT
 
 config CYCLADES
 	tristate "Cyclades async mux support"
-	depends on SERIAL_NONSTANDARD
+	depends on SERIAL_NONSTANDARD && (PCI || ISA)
 	---help---
 	  This driver supports Cyclades Z and Y multiserial boards.
 	  You would need something like this to connect more than two modems to
