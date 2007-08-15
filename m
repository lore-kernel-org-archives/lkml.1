Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbXHOJzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbXHOJzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757083AbXHOJuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:50:35 -0400
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:58730 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181AbXHOJt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:49:59 -0400
Message-Id: <20070815094850.869999871@mail.of.borg>
References: <20070815094539.181979221@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 15 Aug 2007 11:45:48 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org
Subject: [patch 09/10] m68k: Fix a few hickups in drivers/scsi/Kconfig
Content-Disposition: inline; filename=m68k-scsi-Kconfig-hickups.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

m68k: Fix a few hickups in drivers/scsi/Kconfig

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1561,7 +1561,7 @@ config A3000_SCSI
 	  built-in SCSI controller, say Y. Otherwise, say N.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called wd33c93.
+	  module will be called a3000.
 
 config A2091_SCSI
 	tristate "A2091/A590 WD33C93A support"
@@ -1571,7 +1571,7 @@ config A2091_SCSI
 	  say N.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called wd33c93.
+	  module will be called a2091.
 
 config GVP11_SCSI
 	tristate "GVP Series II WD33C93A support"

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

