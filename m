Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbXGWNqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbXGWNqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbXGWNqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:46:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42497 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750905AbXGWNqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:46:24 -0400
Date: Mon, 23 Jul 2007 14:53:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net
Subject: [PATCH] asus-laptop: ASUS laptop no longer compiles. I think this
 is the right fix ?
Message-ID: <20070723145310.7e0503ea@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1/drivers/misc/asus-laptop.c linux-2.6.23rc1/drivers/misc/asus-laptop.c
--- linux.vanilla-2.6.23rc1/drivers/misc/asus-laptop.c	2007-07-23 12:56:12.000000000 +0100
+++ linux-2.6.23rc1/drivers/misc/asus-laptop.c	2007-07-23 13:39:55.000000000 +0100
@@ -1067,8 +1067,8 @@
 }
 
 #define  ASUS_LED_UNREGISTER(object)				\
-	if(object##_led.class_dev				\
-	   && !IS_ERR(object##_led.class_dev))			\
+	if(object##_led.dev				\
+	   && !IS_ERR(object##_led.dev))			\
 		led_classdev_unregister(&object##_led)
 
 static void asus_led_exit(void)
