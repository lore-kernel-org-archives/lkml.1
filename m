Return-Path: <linux-kernel-owner+w=401wt.eu-S1763183AbYJMJpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763183AbYJMJpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760920AbYJMJhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:37:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48643 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759569AbYJMJhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:37:20 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 34/80] pps: Reserve a line discipline number for PPS
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:37:17 +0100
Message-ID: <20081013093713.21645.46781.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Add a new line discipline for "pulse per second" devices connected to
a serial port.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 include/linux/tty.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/include/linux/tty.h b/include/linux/tty.h
index 7271c62..e3612c3 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -23,7 +23,7 @@
  */
 #define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 ptys */
 #define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
-#define NR_LDISCS		18
+#define NR_LDISCS		19
 
 /* line disciplines */
 #define N_TTY		0
@@ -45,6 +45,7 @@
 #define N_HCI		15	/* Bluetooth HCI UART */
 #define N_GIGASET_M101	16	/* Siemens Gigaset M101 serial DECT adapter */
 #define N_SLCAN		17	/* Serial / USB serial CAN Adaptors */
+#define N_PPS		18	/* Pulse per Second */
 
 /*
  * This character is the same as _POSIX_VDISABLE: it cannot be used as

