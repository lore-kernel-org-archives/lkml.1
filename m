Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbYJ2WwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbYJ2WwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbYJ2WpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:45:23 -0400
Received: from kroah.org ([198.145.64.141]:43802 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755717AbYJ2WpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:45:07 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/49] Staging: wlan-ng: Make wlan-ng use WEXT mode by default.
Date: Wed, 29 Oct 2008 15:39:52 -0700
Message-Id: <1225320016-21803-25-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Solomon Peachy <pizza@shaftnet.org>

As this is the kernel default mode.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/wlan-ng/p80211mod.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211mod.c b/drivers/staging/wlan-ng/p80211mod.c
index e2c3f63..605c11b 100644
--- a/drivers/staging/wlan-ng/p80211mod.c
+++ b/drivers/staging/wlan-ng/p80211mod.c
@@ -109,7 +109,7 @@ int wlan_watchdog = 5000;
 module_param(wlan_watchdog, int, 0644);
 MODULE_PARM_DESC(wlan_watchdog, "transmit timeout in milliseconds");
 
-int wlan_wext_write = 0;
+int wlan_wext_write = 1;
 #if WIRELESS_EXT > 12
 module_param(wlan_wext_write, int, 0644);
 MODULE_PARM_DESC(wlan_wext_write, "enable write wireless extensions");
-- 
1.6.0.2

