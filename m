Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZGVDYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZGVDYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756467AbZGVDYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:24:06 -0400
Received: from d1.icnet.pl ([212.160.220.21]:39135 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456AbZGVDYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:24:04 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: jkrzyszt@tis.icnet.pl, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC] [PATCH 2/3] TTY: Add definition of a new line discipline required by Amstrad E3 (Delta) ASoC driver
Date: Wed, 22 Jul 2009 05:22:37 +0200
User-Agent: KMail/1.9.10
Cc: alsa-devel@alsa-project.org,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, e3-hacking@earth.li,
       Jonathan McDowell <noodles@earth.li>,
       Jarkko Nikula <jhnikula@gmail.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>, Arun KS <arunks@mistralsolutions.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907220522.39272.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new line discipline name an number to include/linux/tty.h. The
line discipline will be used by the Amstrad E3 (Delta) sound driver that will
come next in this series of patches.

Created against linux-2.6.31-rc3.
Applies to linux-omap-2.6 commit 7c5cb7862d32cb344be7831d466535d5255e35ac as
well.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
The line discipline is named after the board name as its code will be board
specific.

--- linux-2.6.31-rc1/include/linux/tty.h.orig	2009-07-04 16:39:56.000000000 +0200
+++ linux-2.6.31-rc1/include/linux/tty.h	2009-07-06 16:14:31.000000000 +0200
@@ -23,7 +23,7 @@
  */
 #define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 ptys */
 #define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
-#define NR_LDISCS		19
+#define NR_LDISCS		20
 
 /* line disciplines */
 #define N_TTY		0
@@ -47,6 +47,8 @@
 #define N_SLCAN		17	/* Serial / USB serial CAN Adaptors */
 #define N_PPS		18	/* Pulse per Second */
 
+#define N_AMSDELTA	19	/* codec control over modem, board specific */
+
 /*
  * This character is the same as _POSIX_VDISABLE: it cannot be used as
  * a c_cc[] character, but indicates that a particular special character
