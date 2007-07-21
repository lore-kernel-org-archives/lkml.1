Return-Path: <linux-kernel-owner+w=401wt.eu-S935358AbXGUPHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935358AbXGUPHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938651AbXGUPDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:03:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764703AbXGUPDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:03:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=bfogNGQ1FsV0raEzGY8ZnmqsY0oh3K9tcFmsUJRJfRCrjF9SIA4NEsSttCQjDmmCaJTK1VAoTkPD5bpDGX9CIhH0Qf63vjkzHaEdztaMR05etWXIlpzdJGqwqoxq+VWcfz1jvB5xPT1nbCeucVVE0GK3dxfvJIFUKD46TSLVSaM=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][08/37] Clean up duplicate includes in drivers/input/
Date: Sat, 21 Jul 2007 17:02:25 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, dtor@mail.ru,
       linux-input@atrey.karlin.mff.cuni.cz, Philip Blundell <philb@gnu.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211702.25926.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	drivers/input/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 7392122..f0b22b8 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -22,7 +22,6 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
-#include <linux/irq.h>
 #include <linux/gpio_keys.h>
 
 #include <asm/gpio.h>
