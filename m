Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbYBXNtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbYBXNtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 08:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYBXNtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 08:49:32 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:30698 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120AbYBXNtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 08:49:31 -0500
X-Trace: 670183636/mk-filter-4.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FABIFwUdRAVlC/2dsb2JhbACBVag+gXo
Subject: [PATCH 1/3] input: support maple mouse on Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-sh <linux-sh@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 13:47:08 +0000
Message-Id: <1203860828.6474.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

input: support maple mouse on Dreamcast

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index 7bbea09..d171336 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -232,4 +232,16 @@ config MOUSE_GPIO
 	  To compile this driver as a module, choose M here: the
 	  module will be called gpio_mouse.
 
+config MOUSE_MAPLE
+	tristate "Dreamcast mouse"
+	depends on SH_DREAMCAST
+	select MAPLE
+	help
+	  This driver supports the Maple bus mouse on a SEGA Dreamcast.
+
+	  Most Dreamcast users (with a mouse) will want to say Y here.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called maplemouse.
+
 endif

