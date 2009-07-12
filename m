Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZGLWrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZGLWrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbZGLWqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:46:35 -0400
Received: from kroah.org ([198.145.64.141]:33508 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbZGLWqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:46:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: vibi sreenivasan <vibi_sreenivasan@cms.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/9] driver model: fix show/store prototypes in doc.
Date: Sun, 12 Jul 2009 15:46:03 -0700
Message-Id: <1247438766-17266-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090712223717.GB16600@kroah.com>
References: <20090712223717.GB16600@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: vibi sreenivasan <vibi_sreenivasan@cms.com>

FIX prototypes for show & store method in struct driver_attribute

Signed-off-by: vibi sreenivasan <vibi_sreenivasan@cms.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/driver-model/driver.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/driver-model/driver.txt b/Documentation/driver-model/driver.txt
index 8213216..60120fb 100644
--- a/Documentation/driver-model/driver.txt
+++ b/Documentation/driver-model/driver.txt
@@ -207,8 +207,8 @@ Attributes
 ~~~~~~~~~~
 struct driver_attribute {
         struct attribute        attr;
-        ssize_t (*show)(struct device_driver *, char * buf, size_t count, loff_t off);
-        ssize_t (*store)(struct device_driver *, const char * buf, size_t count, loff_t off);
+        ssize_t (*show)(struct device_driver *driver, char *buf);
+        ssize_t (*store)(struct device_driver *, const char * buf, size_t count);
 };
 
 Device drivers can export attributes via their sysfs directories. 
-- 
1.6.3.2

