Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbXAVVmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbXAVVmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 16:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096AbXAVVmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 16:42:33 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:53205 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbXAVVmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 16:42:32 -0500
X-Originating-Ip: 74.109.98.130
Date: Mon, 22 Jan 2007 16:42:00 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: dtor@mail.ru, vojtech@ucw.cz
Subject: [PATCH] Change incorrect "CONFIG_INPUT_ATIXL" to "CONFIG_MOUSE_ATIXL".
Message-ID: <Pine.LNX.4.64.0701221637560.26403@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Change the apparently incorrect check for CONFIG_INPUT_ATIXL in a
source file to be consistent with the kernel config option
CONFIG_MOUSE_ATIXL.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  this *looks* like a bug.


diff --git a/drivers/input/mouse/inport.c b/drivers/input/mouse/inport.c
index 13dd967..701ebd5 100644
--- a/drivers/input/mouse/inport.c
+++ b/drivers/input/mouse/inport.c
@@ -61,7 +61,7 @@ MODULE_LICENSE("GPL");
 #define INPORT_REG_MODE		0x07
 #define INPORT_RESET		0x80

-#ifdef CONFIG_INPUT_ATIXL
+#ifdef CONFIG_MOUSE_ATIXL
 #define INPORT_NAME		"ATI XL Mouse"
 #define INPORT_VENDOR		0x0002
 #define INPORT_SPEED_30HZ	0x01
