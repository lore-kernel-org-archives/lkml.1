Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbZAYNOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbZAYNOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 08:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbZAYNNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 08:13:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35935 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbZAYNNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 08:13:49 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, Ben Dooks <ben-linux@fluff.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] [ARM] S3C24XX: Add gpio_to_irq() facility
Date: Sun, 25 Jan 2009 14:13:46 +0100
Message-Id: <1232889227-20887-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1232889227-20887-2-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090125123023.GA12248@pengutronix.de>
 <1232889227-20887-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1232889227-20887-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben-linux@fluff.org>

Add gpio_to_irq() by re-directing the call to the
generic __gpio_to_irq() code in the gpiolib.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
(cherry picked from commit 4d316fc5a34b073da4145a203101ec5b9553a634 to
fix compile error in drivers/gpio/gpiolib.c with CONFIG_DEBUG_FS=y)
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mach-s3c2410/include/mach/gpio.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2410/include/mach/gpio.h b/arch/arm/mach-s3c2410/include/mach/gpio.h
index 3b52b86..fd8b326 100644
--- a/arch/arm/mach-s3c2410/include/mach/gpio.h
+++ b/arch/arm/mach-s3c2410/include/mach/gpio.h
@@ -14,5 +14,6 @@
 #define gpio_get_value	__gpio_get_value
 #define gpio_set_value	__gpio_set_value
 #define gpio_cansleep	__gpio_cansleep
+#define gpio_to_irq	__gpio_to_irq
 
 #include <asm-generic/gpio.h>
-- 
1.5.6.5

