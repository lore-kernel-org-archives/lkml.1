Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbZHFLIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbZHFLIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZHFLID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:08:03 -0400
Received: from d1.icnet.pl ([212.160.220.21]:42292 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbZHFLIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:08:02 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] TTY: Rename N_AMSDELTA line discipline to N_V253
Date: Thu, 6 Aug 2009 13:07:32 +0200
User-Agent: KMail/1.9.10
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       e3-hacking@earth.li,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908061307.33772.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch changes the line discipline name registered in include/linux/tty.h

Signed-off-by: Janusz Krzysztofik

---
--- linux-2.6.31-rc5/include/linux/tty.h.orig	2009-08-05 21:44:33.000000000 +0200
+++ linux-2.6.31-rc5/include/linux/tty.h	2009-08-05 22:54:12.000000000 +0200
@@ -47,7 +47,7 @@
 #define N_SLCAN		17	/* Serial / USB serial CAN Adaptors */
 #define N_PPS		18	/* Pulse per Second */
 
-#define N_AMSDELTA	19	/* codec control over modem, board specific */
+#define N_V253		19	/* Codec control over voice modem */
 
 /*
  * This character is the same as _POSIX_VDISABLE: it cannot be used as

