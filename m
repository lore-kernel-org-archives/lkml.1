Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbZGHWhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbZGHWhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZGHWhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:37:08 -0400
Received: from xenotime.net ([72.52.64.118]:34471 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755171AbZGHWhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:37:07 -0400
Date: Wed, 8 Jul 2009 15:37:03 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh <greg@kroah.com>, vibi sreenivasan <vibi_sreenivasan@cms.com>
Subject: [PATCH driver model: fix show/store prototypes in doc.
Message-Id: <20090708153703.01fef7e0.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: vibi sreenivasan <vibi_sreenivasan@cms.com>

FIX prototypes for show & store method in struct driver_attribute

Signed-off-by: vibi sreenivasan <vibi_sreenivasan@cms.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/driver-model/driver.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.31-rc2-git2.orig/Documentation/driver-model/driver.txt
+++ linux-2.6.31-rc2-git2/Documentation/driver-model/driver.txt
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
