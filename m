Return-Path: <linux-kernel-owner+w=401wt.eu-S1763703AbZDHITE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763703AbZDHITE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763028AbZDHIOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:14:30 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:47898 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761156AbZDHIOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:14:19 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 10/11] w35und: remove MODULE_AUTHOR
Date: Wed,  8 Apr 2009 11:14:05 +0300
Message-Id: <1239178446-12893-10-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

The contact details in MODULE_AUTHOR do not reflect current state of
affairs so remove it.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbusb.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 526aac5..cffd732 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -2,6 +2,12 @@
  * Copyright 2008 Pavel Machek <pavel@suse.cz>
  *
  * Distribute under GPLv2.
+ *
+ * The original driver was written by:
+ *     Jeff Lee <YY_Lee@issc.com.tw>
+ *
+ * and was adapted to the 2.6 kernel by:
+ *     Costantino Leandro (Rxart Desktop) <le_costantino@pixartargentina.com.ar>
  */
 #include <net/mac80211.h>
 #include <linux/usb.h>
@@ -13,7 +19,6 @@
 #include "wbhal_f.h"
 #include "wblinux_f.h"
 
-MODULE_AUTHOR("Original by: Jeff Lee<YY_Lee@issc.com.tw> Adapted to 2.6.x by Costantino Leandro (Rxart Desktop) <le_costantino@pixartargentina.com.ar>");
 MODULE_DESCRIPTION("IS89C35 802.11bg WLAN USB Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.1");
-- 
1.5.6.3

