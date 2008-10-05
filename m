Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbYJEQNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbYJEQNl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbYJEQIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:08:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54882 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756268AbYJEQIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:08:06 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 25/76] pps: Reserve a line discipline number for PPS
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:08:06 +0100
Message-ID: <20081005160804.1997.49156.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

