Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbZDPQkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbZDPQkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbZDPQk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:40:28 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:38819 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755040AbZDPQk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:40:28 -0400
Subject: driver-core: set default SYSFS_DEPRECATED=n
From: Kay Sievers <kay.sievers@suse.de>
To: gregkh <gregkh@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 18:40:23 +0200
Message-Id: <1239900023.17211.19.camel@poy>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: driver-core: set default SYSFS_DEPRECATED=n

All recent distros depend on the non-deprecated sysfs layout, so
change the default value of the option to reflect that.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 init/Kconfig |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -612,16 +612,12 @@ config MM_OWNER
 	bool
 
 config SYSFS_DEPRECATED
-	bool
-
-config SYSFS_DEPRECATED_V2
-	bool "Create deprecated sysfs layout for older userspace tools"
+	bool "remove sysfs features which may confuse old userspace tools"
 	depends on SYSFS
-	default y
-	select SYSFS_DEPRECATED
+	default n
 	help
 	  This option switches the layout of sysfs to the deprecated
-	  version.
+	  version. Do not use it on recent distributions.
 
 	  The current sysfs layout features a unified device tree at
 	  /sys/devices/, which is able to express a hierarchy between


