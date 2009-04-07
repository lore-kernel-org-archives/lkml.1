Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbZDGOoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbZDGOoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758185AbZDGOnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:43:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55930 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758141AbZDGOnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:43:51 -0400
From: Mike Frysinger <vapier.adi@gmail.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Apr 2009 16:42:51 +0100
Message-ID: <20090407154142.17182.93917.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090407153824.17182.81672.stgit@t61.ukuu.org.uk>
References: <20090407153824.17182.81672.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Kconfig check tighten

This is needed as it can be built as a module.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 1e2dd6f..1537e0d 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -707,7 +707,7 @@ choice
 
 config SERIAL_BFIN_DMA
 	bool "DMA mode"
-	depends on !DMA_UNCACHED_NONE && !KGDB_SERIAL_CONSOLE
+	depends on !DMA_UNCACHED_NONE && KGDB_SERIAL_CONSOLE=n
 	help
 	  This driver works under DMA mode. If this option is selected, the
 	  blackfin simple dma driver is also enabled.

