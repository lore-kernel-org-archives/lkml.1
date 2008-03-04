Return-Path: <linux-kernel-owner+w=401wt.eu-S935294AbYCDXYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935294AbYCDXYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:24:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935009AbYCDXS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:18:58 -0500
Received: from ns2.suse.de ([195.135.220.15]:42775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934251AbYCDXS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:18:56 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/8] driver core: fix up Kconfig text for CONFIG_SYSFS_DEPRECATED
Date: Tue,  4 Mar 2008 15:18:45 -0800
Message-Id: <1204672732-3127-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080304231519.GC3073@suse.de>
References: <20080304231519.GC3073@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As things get moved into this config option, the hard date of 2006 does
not work anymore, so update the text to be more descriptive.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 init/Kconfig |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index f698a5a..e6606e6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -382,10 +382,11 @@ config SYSFS_DEPRECATED
 
 	  If enabled, this option will also move any device structures
 	  that belong to a class, back into the /sys/class hierarchy, in
-	  order to support older versions of udev.
+	  order to support older versions of udev and some userspace
+	  programs.
 
-	  If you are using a distro that was released in 2006 or later,
-	  it should be safe to say N here.
+	  If you are using a distro with the most recent userspace
+	  packages, it should be safe to say N here.
 
 config CGROUP_MEM_CONT
 	bool "Memory controller for cgroups"
-- 
1.5.4.3

