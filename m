Return-Path: <linux-kernel-owner+w=401wt.eu-S1765022AbXEXAoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765022AbXEXAoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762135AbXEXAhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:37:34 -0400
Received: from critter.phunnypharm.org ([67.97.251.11]:3352 "EHLO critter"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761627AbXEXAhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:37:15 -0400
X-Greylist: delayed 1460 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 May 2007 20:37:15 EDT
To: linux-kernel@vger.kernel.org
Cc: Phil Dibowitz <phil@ipom.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net
Message-Id: <317339ef5cb48f652b8eb33c3a1a44d8a2b31493.1179964369.git.bcollins@ubuntu.com>
In-Reply-To: <98cd38b5.git.bcollins@ubuntu.com>
References: <98cd38b5.git.bcollins@ubuntu.com>
From: Ben Collins <bcollins@ubuntu.com>
Date: Wed, 23 May 2007 18:39:24 -0400
Subject: [PATCH 6/6] UNUSUAL_DEV: Sync up some reported devices from Ubuntu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Various unusual dev entries accumulated from Ubuntu bug reports.

CC: Phil Dibowitz <phil@ipom.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb-devel@lists.sourceforge.net
Signed-off-by: Ben Collins <bcollins@ubuntu.com>
---
 drivers/usb/storage/unusual_devs.h |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index d230ee7..8a24f1c 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1179,8 +1179,8 @@ UNUSUAL_DEV( 0x0a17, 0x006, 0x0000, 0xffff,
                 US_SC_DEVICE, US_PR_DEVICE, NULL,
                 US_FL_FIX_INQUIRY ),
 
-/* These are virtual windows driver CDs, which the zd1211rw driver automatically
- * converts into a WLAN devices. */
+/* These are virtual windows driver CDs, which the zd1211rw driver
+ * automatically converts into WLAN devices. */
 UNUSUAL_DEV( 0x0ace, 0x2011, 0x0101, 0x0101,
                 "ZyXEL",
                 "G-220F USB-WLAN Install",
@@ -1193,6 +1193,14 @@ UNUSUAL_DEV( 0x0ace, 0x20ff, 0x0101, 0x0101,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_IGNORE_DEVICE ),
 
+/* SanDisk that has a second LUN for a driver ISO, reported by
+ * Ben Collins <bcollins@ubuntu.com> */
+UNUSUAL_DEV( 0x0781, 0x5406, 0x0000, 0xffff,
+		"SanDisk",
+		"U3 Cruzer Micro driver ISO",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_SINGLE_LUN ),
+
 #ifdef CONFIG_USB_STORAGE_ISD200
 UNUSUAL_DEV(  0x0bf6, 0xa001, 0x0100, 0x0110,
 		"ATI",
@@ -1271,6 +1279,15 @@ UNUSUAL_DEV( 0x0dd8, 0x1060, 0x0000, 0xffff,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY ),
 
+/* Reported by Edward Chapman <[EMAIL PROTECTED]>
+   Netac OnlyDisk Mini U2CV2 512MB USB 2.0 Flash Drive */
+UNUSUAL_DEV( 0x0dd8, 0xd202, 0x0000, 0x9999,
+		"Netac",
+		"USB Flash Disk",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_IGNORE_RESIDUE ),
+
+
 /* Patch by Stephan Walter <stephan.walter@epfl.ch>
  * I don't know why, but it works... */
 UNUSUAL_DEV( 0x0dda, 0x0001, 0x0012, 0x0012,
-- 
1.5.1.4

