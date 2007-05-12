Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbXELSYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbXELSYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXELSYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:24:36 -0400
Received: from brick.kernel.dk ([80.160.20.94]:5425 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbXELSYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:24:36 -0400
Date: Sat, 12 May 2007 20:23:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: mchehab@infradead.org, jengelh@linux01.gwdg.de
Subject: default y idiocy
Message-ID: <20070512182343.GO4629@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This has bothered me for a long time, and it just seems to be getting
worse. Can people please STOP defaulting non-essential stuff to 'y'?
Grrr.

diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index 58926da..adbb5ca 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -2,7 +2,6 @@
 menuconfig MACINTOSH_DRIVERS
 	bool "Macintosh device drivers"
 	depends on PPC || MAC || X86
-	default y
 
 if MACINTOSH_DRIVERS
 
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 624b21c..986dcbc 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -89,7 +89,6 @@ config VIDEO_TVEEPROM
 
 config DAB
 	boolean "DAB adapters"
-	default y
 	---help---
 	  Allow selecting support for for Digital Audio Broadcasting (DAB)
 	  Receiver adapters.

-- 
Jens Axboe

