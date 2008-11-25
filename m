Return-Path: <linux-kernel-owner+w=401wt.eu-S1753053AbYKYVL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbYKYVL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYKYVLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:11:17 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:52571 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYKYVLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:11:16 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Rodolfo Giometti <giometti@linux.it>
Date: Tue, 25 Nov 2008 22:11:09 +0100
Message-Id: <1227647470-4816-4-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227647470-4816-3-git-send-email-giometti@linux.it>
References: <>
 <1227647470-4816-1-git-send-email-giometti@linux.it>
 <1227647470-4816-2-git-send-email-giometti@linux.it>
 <1227647470-4816-3-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] ldisc: new N_PPS (Pulse Per Second) line discipine.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 include/linux/tty.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 019c10b..50656a0 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -24,7 +24,7 @@
  */
 #define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 ptys */
 #define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
-#define NR_LDISCS		17
+#define NR_LDISCS		18
 
 /* line disciplines */
 #define N_TTY		0
@@ -45,6 +45,7 @@
 #define N_SYNC_PPP	14	/* synchronous PPP */
 #define N_HCI		15	/* Bluetooth HCI UART */
 #define N_GIGASET_M101	16	/* Siemens Gigaset M101 serial DECT adapter */
+#define N_PPS		17	/* Pulse per Second */
 
 /*
  * This character is the same as _POSIX_VDISABLE: it cannot be used as
-- 
1.5.4.3

