Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYKHFqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYKHFqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 00:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYKHFpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 00:45:52 -0500
Received: from kroah.org ([198.145.64.141]:37129 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751113AbYKHFps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 00:45:48 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/2] Staging: make usbip depend on CONFIG_NET
Date: Fri,  7 Nov 2008 21:45:43 -0800
Message-Id: <1226123143-28859-2-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081108054511.GA28846@kroah.com>
References: <20081108054511.GA28846@kroah.com>
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
1.5.6

