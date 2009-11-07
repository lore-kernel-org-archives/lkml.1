Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbZKGRvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbZKGRvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 12:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZKGRvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 12:51:03 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:35496 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbZKGRvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 12:51:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HupqUofbOruAIFRoXUhHCZHtYBDqLFEFXfXQibIk+Tr6oIgl2HntNe8kd7UvfiIMID
         es3/0MezKfT9pb7ywSZ6H7jsiS10+fX9Y3pRYapAp9YzZcfQMMaVVeQnAGmZxnaET6tz
         pv6ZuajEzXBquQdO4Tul4lUg4WrilBCLjplvQ=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rpurdie@rpsys.net, gregkh@suse.de, yuasa@linux-mips.org,
       ralf@linux-mips.org, Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH] leds: add exit function to cobalt-raq led.
Date: Sat,  7 Nov 2009 12:50:35 -0500
Message-Id: <1257616235-7840-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.5.2.150.g1b52a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/leds/leds-cobalt-raq.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-cobalt-raq.c b/drivers/leds/leds-cobalt-raq.c
index defc212..e43fcb2 100644
--- a/drivers/leds/leds-cobalt-raq.c
+++ b/drivers/leds/leds-cobalt-raq.c
@@ -135,4 +135,15 @@ static int __init cobalt_raq_led_init(void)
 	return platform_driver_register(&cobalt_raq_led_driver);
 }
 
+static void __exit cobalt_raq_led_exit(void)
+{
+	platform_driver_unregister(&cobalt_raq_led_driver);
+}
+
 module_init(cobalt_raq_led_init);
+module_exit(cobalt_raq_led_exit);
+
+MODULE_AUTHOR("Yoichi Yuasa <yuasa@linux-mips.org>");
+MODULE_DESCRIPTION("LEDs driver for the Cobalt Raq series.");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:cobalt-raq-leds");
-- 
1.6.5.2.150.g1b52a

