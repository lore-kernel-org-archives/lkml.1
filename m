Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYJ2Wvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYJ2Wvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbYJ2WpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:45:22 -0400
Received: from kroah.org ([198.145.64.141]:43794 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755620AbYJ2Wo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:44:58 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/49] Staging: wlan-ng: Update Help text to mention prism3 devices.
Date: Wed, 29 Oct 2008 15:39:50 -0700
Message-Id: <1225320016-21803-23-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Solomon Peachy <pizza@shaftnet.org>

The driver also supports prism3 devices

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/wlan-ng/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/Kconfig b/drivers/staging/wlan-ng/Kconfig
index 2425d86..a401bdb 100644
--- a/drivers/staging/wlan-ng/Kconfig
+++ b/drivers/staging/wlan-ng/Kconfig
@@ -1,9 +1,9 @@
 config PRISM2_USB
-	tristate "Prism2.5 USB driver"
+	tristate "Prism2.5/3 USB driver"
 	depends on WLAN_80211 && USB
 	default n
 	---help---
-	  This is the wlan-ng prism 2.5 USB driver for a wide range of
+	  This is the wlan-ng prism 2.5/3 USB driver for a wide range of
 	  old USB wireless devices.
 
 	  To compile this driver as a module, choose M here: the module
-- 
1.6.0.2

