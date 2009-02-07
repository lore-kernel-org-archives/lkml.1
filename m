Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZBGAO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZBGAO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZBGAOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:14:21 -0500
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:44494 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751014AbZBGAOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:14:20 -0500
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Feb 2009 19:14:20 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] auxdisplay: remove PARPORT dependency
Date: Fri, 6 Feb 2009 19:06:51 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090120BD69@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] auxdisplay: remove PARPORT dependency
Thread-Index: AcmIt/oTa83XPsF5S/OA+cma8qzc5g==
From: "hartleys" <hartleys@visionengravers.com>
To: "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Feb 2009 00:07:09.0997 (UTC) FILETIME=[053C55D0:01C988B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove PARPORT dependency for Auxiliary Display support.

This is not needed since the dependency for the KS0108 driver is
PARPORT_PC.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/auxdisplay/Kconfig b/drivers/auxdisplay/Kconfig
index 14b9d5f..c07e725 100644
--- a/drivers/auxdisplay/Kconfig
+++ b/drivers/auxdisplay/Kconfig
@@ -6,7 +6,6 @@
 #
 
 menuconfig AUXDISPLAY
-	depends on PARPORT
 	bool "Auxiliary Display support"
 	---help---
 	  Say Y here to get to see options for auxiliary display
drivers.
@@ -14,7 +13,7 @@ menuconfig AUXDISPLAY
 
 	  If you say N, all options in this submenu will be skipped and
disabled.
 
-if AUXDISPLAY && PARPORT
+if AUXDISPLAY
 
 config KS0108
 	tristate "KS0108 LCD Controller" 
