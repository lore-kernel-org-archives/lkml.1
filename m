Return-Path: <linux-kernel-owner+w=401wt.eu-S1763164AbZFPFvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763164AbZFPFvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZFPFuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:50:50 -0400
Received: from kroah.org ([198.145.64.141]:48285 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZFPFuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:50:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/64] driver core: set default SYSFS_DEPRECATED=n
Date: Mon, 15 Jun 2009 22:45:50 -0700
Message-Id: <1245131213-24168-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

All recent distros depend on the non-deprecated sysfs layout, so
change the default value of the option to reflect that.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 init/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index fed6dc3..c4b3c6d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -616,13 +616,13 @@ config SYSFS_DEPRECATED
 	bool
 
 config SYSFS_DEPRECATED_V2
-	bool "Create deprecated sysfs layout for older userspace tools"
+	bool "remove sysfs features which may confuse old userspace tools"
 	depends on SYSFS
-	default y
+	default n
 	select SYSFS_DEPRECATED
 	help
 	  This option switches the layout of sysfs to the deprecated
-	  version.
+	  version. Do not use it on recent distributions.
 
 	  The current sysfs layout features a unified device tree at
 	  /sys/devices/, which is able to express a hierarchy between
-- 
1.6.3.2

