Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYJBHne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYJBHne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 03:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYJBHmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 03:42:35 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:60921 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYJBHme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 03:42:34 -0400
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Rodolfo Giometti <giometti@linux.it>
Date: Thu,  2 Oct 2008 09:41:46 +0200
Message-Id: <1222933309-2524-8-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1222933309-2524-7-git-send-email-giometti@linux.it>
References: <>
 <1222933309-2524-1-git-send-email-giometti@linux.it>
 <1222933309-2524-2-git-send-email-giometti@linux.it>
 <1222933309-2524-3-git-send-email-giometti@linux.it>
 <1222933309-2524-4-git-send-email-giometti@linux.it>
 <1222933309-2524-5-git-send-email-giometti@linux.it>
 <1222933309-2524-6-git-send-email-giometti@linux.it>
 <1222933309-2524-7-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 07/10] tty: new PPS line discipline.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new line discipline for "pulse per second" devices connected to
a serial port.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 include/linux/tty.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 826d695..1857db2 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -24,7 +24,7 @@
  */
 #define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 ptys */
 #define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
-#define NR_LDISCS		18
+#define NR_LDISCS		19
 
 /* line disciplines */
 #define N_TTY		0
@@ -46,6 +46,7 @@
 #define N_HCI		15	/* Bluetooth HCI UART */
 #define N_GIGASET_M101	16	/* Siemens Gigaset M101 serial DECT adapter */
 #define N_SLCAN		17	/* Serial / USB serial CAN Adaptors */
+#define N_PPS		18	/* Pulse per Second */
 
 /*
  * This character is the same as _POSIX_VDISABLE: it cannot be used as
-- 
1.5.4.3

