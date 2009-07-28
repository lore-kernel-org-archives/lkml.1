Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbZG1Vpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbZG1Vpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbZG1Vpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:45:36 -0400
Received: from kroah.org ([198.145.64.141]:55431 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbZG1Vpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:45:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lgrijincu@ixiacom.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/5] driver core: documentation: make it clear that sysfs is optional
Date: Tue, 28 Jul 2009 14:44:41 -0700
Message-Id: <1248817481-13372-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090728213826.GC13090@kroah.com>
References: <20090728213826.GC13090@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucian Adrian Grijincu <lgrijincu@ixiacom.com>

The original text suggested that sysfs is mandatory and always
compiled in the kernel.

Signed-off-by: Lucian Adrian Grijincu <lgrijincu@ixiacom.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/filesystems/sysfs.txt |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index 7e81e37..b245d52 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -23,7 +23,8 @@ interface.
 Using sysfs
 ~~~~~~~~~~~
 
-sysfs is always compiled in. You can access it by doing:
+sysfs is always compiled in if CONFIG_SYSFS is defined. You can access
+it by doing:
 
     mount -t sysfs sysfs /sys 
 
-- 
1.6.3.2

