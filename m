Return-Path: <linux-kernel-owner+w=401wt.eu-S936355AbYEURlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936355AbYEURlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936132AbYEURk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:40:58 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53452 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbYEURky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:40:54 -0400
Date: Wed, 21 May 2008 20:38:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] remove some more tipar bits
Message-ID: <20080521173839.GC15355@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bits were missed when the tipar driver was removed.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/00-INDEX              |    2 --
 Documentation/kernel-parameters.txt |    7 -------
 drivers/char/Makefile               |    1 -
 3 files changed, 10 deletions(-)

144d2868af6e355ef15a831b82dda80b8d2cc31e diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 1977fab..6de7130 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -361,8 +361,6 @@ telephony/
 	- directory with info on telephony (e.g. voice over IP) support.
 time_interpolators.txt
 	- info on time interpolators.
-tipar.txt
-	- information about Parallel link cable for Texas Instruments handhelds.
 tty.txt
 	- guide to the locking policies of the tty layer.
 uml/
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e07c432..91a34e7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2062,13 +2062,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			<deci-seconds>: poll all this frequency
 			0: no polling (default)
 
-	tipar.timeout=	[HW,PPT]
-			Set communications timeout in tenths of a second
-			(default 15).
-
-	tipar.delay=	[HW,PPT]
-			Set inter-bit delay in microseconds (default 10).
-
 	tmscsim=	[HW,SCSI]
 			See comment before function dc390_setup() in
 			drivers/scsi/tmscsim.c.
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 4c1c584..ba81190 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -62,7 +62,6 @@ obj-$(CONFIG_BRIQ_PANEL)	+= briq_panel.o
 obj-$(CONFIG_BFIN_OTP)		+= bfin-otp.o
 
 obj-$(CONFIG_PRINTER)		+= lp.o
-obj-$(CONFIG_TIPAR)		+= tipar.o
 
 obj-$(CONFIG_APM_EMULATION)	+= apm-emulation.o
 

