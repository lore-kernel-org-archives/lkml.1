Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbXGOUBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbXGOUBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbXGOUA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:00:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39922 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbXGOUAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:00:24 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] zd1211rw: too early inclusion of asm/unaligned.h
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Message-Id: <E1IAAGT-00054x-VI@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 21:00:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 740a219..ca24299 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -15,7 +15,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
-#include <asm/unaligned.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -26,6 +25,7 @@
 #include <linux/usb.h>
 #include <linux/workqueue.h>
 #include <net/ieee80211.h>
+#include <asm/unaligned.h>
 
 #include "zd_def.h"
 #include "zd_netdev.h"
-- 
1.5.3.GIT


