Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935557Ab0CODGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 23:06:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53181 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935459Ab0CODGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 23:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LEatSAwHYeyNhHorLj4ca6Hr2e0Qq0BNgQ/VvbFqElr3QzE2/wzWS1x7R2ToXia/5l
         VX2jFUxvJhjqBMCPaJeyJDnXtBx20n20AIBLBlMb/WaafShmZMIaTIBqnKQXsgRP2Gpn
         jVnAppq8QIogjz2bowXMI7QMuYwKqdFAWOfHk=
From: Chihau Chau <chihau@gmail.com>
To: gregkh@suse.de
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Staging: dream:  generic_gpio: Use linux instead of asm uaccess.h
Date: Mon, 15 Mar 2010 00:05:55 -0300
Message-Id: <1268622355-9966-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This is moving toward using <linux/uaccess.h> instead of the old
<asm/uaccess.h> file.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/dream/generic_gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dream/generic_gpio.c b/drivers/staging/dream/generic_gpio.c
index fe24d38..bf19b85 100644
--- a/drivers/staging/dream/generic_gpio.c
+++ b/drivers/staging/dream/generic_gpio.c
@@ -18,7 +18,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <asm/gpio.h>
+#include <linux/gpio.h>
 #include "gpio_chip.h"
 
 #define GPIO_NUM_TO_CHIP_INDEX(gpio) ((gpio)>>5)
-- 
1.5.6.3

