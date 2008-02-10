Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYBJXFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYBJXFf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYBJXF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:05:26 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:37827 "EHLO
	mk-filter-2-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751930AbYBJXFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:05:25 -0500
X-Trace: 670483242/mk-filter-2.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAGISr0dRAVlC/2dsb2JhbACBWaRVgXQ
Subject: [PATCH 2/2] SH/Dreamcast - joystick (controlpad)
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: dtor@insightbb.com
Cc: Paul Mundt <lethal@users.sourceforge.net>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1202684222.6237.9.camel@localhost.localdomain>
References: <1202684222.6237.9.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 10 Feb 2008 23:05:09 +0000
Message-Id: <1202684709.6237.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to the Kconfig and Makefile needed to build the Maple controlpad
code.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
======

diff --combined drivers/input/joystick/Kconfig
index 7c662ee,7c662ee..3566fa2
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@@ -282,4 -282,4 +282,17 @@@ config JOYSTICK_XPAD_LED
  	  This option enables support for the LED which surrounds the Big X on
  	  XBox 360 controller.
  
+config JOYSTICK_MAPLE
+	tristate "Dreamcast control pad"
+	depends on SH_DREAMCAST
+	select MAPLE
+	help
+	 Say Y here if you have a SEGA Dreamcast and want to use your
+	 controller.
+
+	 Most Dreamcast users will say Y.
+
+	 To compile this as a module choose M here: the
+	 module will be called maplecontrol.
+
  endif
diff --combined drivers/input/joystick/Makefile
index e855abb,e855abb..62929ef
--- a/drivers/input/joystick/Makefile
+++ b/drivers/input/joystick/Makefile
@@@ -27,5 -27,5 +27,6 @@@ obj-$(CONFIG_JOYSTICK_TURBOGRAFX)	+= tu
  obj-$(CONFIG_JOYSTICK_TWIDJOY)		+= twidjoy.o
  obj-$(CONFIG_JOYSTICK_WARRIOR)		+= warrior.o
  obj-$(CONFIG_JOYSTICK_XPAD)		+= xpad.o
+ obj-$(CONFIG_JOYSTICK_MAPLE)		+= maplecontrol.o
  
  obj-$(CONFIG_JOYSTICK_IFORCE)		+= iforce/





