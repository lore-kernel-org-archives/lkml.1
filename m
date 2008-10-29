Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbYJ2WoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbYJ2WoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYJ2Wnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:43:42 -0400
Received: from kroah.org ([198.145.64.141]:43730 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754462AbYJ2Wnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:43:41 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/49] Staging: make usbip depend on CONFIG_NET
Date: Wed, 29 Oct 2008 15:39:29 -0700
Message-Id: <1225320016-21803-2-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

Thanks to Randy Dunlap for finding this problem.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/usbip/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/usbip/Kconfig b/drivers/staging/usbip/Kconfig
index 7426235..217fb7e 100644
--- a/drivers/staging/usbip/Kconfig
+++ b/drivers/staging/usbip/Kconfig
@@ -1,6 +1,6 @@
 config USB_IP_COMMON
 	tristate "USB IP support (EXPERIMENTAL)"
-	depends on USB && EXPERIMENTAL
+	depends on USB && NET && EXPERIMENTAL
 	default N
 	---help---
 	  This enables pushing USB packets over IP to allow remote
-- 
1.6.0.2

