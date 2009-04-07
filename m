Return-Path: <linux-kernel-owner+w=401wt.eu-S1760791AbZDGSk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791AbZDGSk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760730AbZDGSkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:40:08 -0400
Received: from kroah.org ([198.145.64.141]:52831 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758323AbZDGSkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:40:05 -0400
Subject: patch staging-stlc45xx-should-depend-on-generic_hardirqs.patch added to gregkh-2.6 tree
To: geert@linux-m68k.org, gregkh@suse.de, kalle.valo@nokia.com,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Tue, 07 Apr 2009 11:36:40 -0700
In-Reply-To: <Pine.LNX.4.64.0904061515001.13923@anakin>
Message-ID: <12391294002943@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: STLC45XX should depend on GENERIC_HARDIRQS

to my gregkh-2.6 tree.  Its filename is

    staging-stlc45xx-should-depend-on-generic_hardirqs.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From geert@linux-m68k.org  Tue Apr  7 11:18:56 2009
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 6 Apr 2009 15:15:55 +0200 (CEST)
Subject: Staging: STLC45XX should depend on GENERIC_HARDIRQS
To: Kalle Valo <kalle.valo@nokia.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Message-ID: <Pine.LNX.4.64.0904061515001.13923@anakin>


m68k allmodconfig:
| drivers/staging/stlc45xx/stlc45xx.c: In function 'stlc45xx_probe':
| drivers/staging/stlc45xx/stlc45xx.c:2456: error: implicit declaration of function 'set_irq_type'
| make[6]: *** [drivers/staging/stlc45xx/stlc45xx.o] Error 1

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/stlc45xx/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/stlc45xx/Kconfig
+++ b/drivers/staging/stlc45xx/Kconfig
@@ -1,6 +1,6 @@
 config STLC45XX
 	tristate "stlc4550/4560 support"
-	depends on MAC80211 && WLAN_80211 && SPI_MASTER
+	depends on MAC80211 && WLAN_80211 && SPI_MASTER && GENERIC_HARDIRQS
 	---help---
 	  This is a driver for stlc4550 and stlc4560 chipsets.
 

