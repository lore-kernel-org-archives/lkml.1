Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbYFYQ2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbYFYQ2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759935AbYFYQ1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:27:32 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42934 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759853AbYFYQ1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:27:31 -0400
Date: Wed, 25 Jun 2008 19:25:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [2.6 patch] remove the unused ADB_KEYBOARD option
Message-ID: <20080625162527.GG10285@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the driver was removed back in 2002 the option was forgotten.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
7698eb0f092f61d2f1d4d99cd7150018d4ddb6fe diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 55ea52f..8012ff7 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -578,18 +578,6 @@ config MAC_HID
 	depends on INPUT_ADBHID
 	default y
 
-config ADB_KEYBOARD
-	bool "Support for ADB keyboard (old driver)"
-	depends on MAC && !INPUT_ADBHID
-	help
-	  This option allows you to use an ADB keyboard attached to your
-	  machine. Note that this disables any other (ie. PS/2) keyboard
-	  support, even if your machine is physically capable of using both at
-	  the same time.
-
-	  If you use an ADB keyboard (4 pin connector), say Y here.
-	  If you use a PS/2 keyboard (6 pin connector), say N here.
-
 config HPDCA
 	tristate "HP DCA serial support"
 	depends on DIO && SERIAL_8250

