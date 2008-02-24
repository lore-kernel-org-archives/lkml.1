Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbYBXNvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbYBXNvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 08:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYBXNvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 08:51:12 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:47761 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753199AbYBXNvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 08:51:10 -0500
X-Trace: 687394765/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FACIEwUdRAVlC/2dsb2JhbACBVahAgXo
Subject: [PATCH 2/3] input: support maple mouse on Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1203860828.6474.6.camel@localhost.localdomain>
References: <1203860828.6474.6.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 13:49:14 +0000
Message-Id: <1203860954.6474.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


input: update Makefile to support maple mouse on Dreamcast

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index 9e6e363..5d35939 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_MOUSE_SERIAL)	+= sermouse.o
 obj-$(CONFIG_MOUSE_HIL)		+= hil_ptr.o
 obj-$(CONFIG_MOUSE_VSXXXAA)	+= vsxxxaa.o
 obj-$(CONFIG_MOUSE_GPIO)	+= gpio_mouse.o
+obj-$(CONFIG_MOUSE_MAPLE)	+= maplemouse.o
 
 psmouse-objs := psmouse-base.o synaptics.o

