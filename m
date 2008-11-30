Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYK3NJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYK3NJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 08:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYK3NJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 08:09:41 -0500
Received: from senator.holtmann.net ([87.106.208.187]:45357 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbYK3NJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 08:09:40 -0500
Subject: [PATCH] driver core: add newlines to debugging enabled/disabled
 messages
From: Marcel Holtmann <marcel@holtmann.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-QMIQXDTrejkocp/86rgh"
Date: Sun, 30 Nov 2008 14:09:36 +0100
Message-Id: <1228050576.9176.14.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QMIQXDTrejkocp/86rgh
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Greg,

the dynamic_printk interface is missing some newlines. Attached patch
fixes it.

Regards

Marcel


--=-QMIQXDTrejkocp/86rgh
Content-Disposition: attachment; filename="patch"
Content-Type: application/mbox; name="patch"
Content-Transfer-Encoding: 7bit

>From 27160f1920f0218def61fc66a7c9f0c15f2c91be Mon Sep 17 00:00:00 2001
From: Marcel Holtmann <marcel@holtmann.org>
Date: Sun, 30 Nov 2008 14:01:26 +0100
Subject: [PATCH] driver core: add newlines to debugging enabled/disabled messages

Both messages are missing the newline and thus dmesg output gets
scrambled.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 lib/dynamic_printk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_printk.c b/lib/dynamic_printk.c
index d83660f..3070ab3 100644
--- a/lib/dynamic_printk.c
+++ b/lib/dynamic_printk.c
@@ -289,7 +289,7 @@ static ssize_t pr_debug_write(struct file *file, const char __user *buf,
 					dynamic_enabled = DYNAMIC_ENABLED_SOME;
 					err = 0;
 					printk(KERN_DEBUG
-					       "debugging enabled for module %s",
+					       "debugging enabled for module %s\n",
 					       elem->name);
 				} else if (!value && (elem->enable == 1)) {
 					elem->enable = 0;
@@ -309,7 +309,7 @@ static ssize_t pr_debug_write(struct file *file, const char __user *buf,
 					err = 0;
 					printk(KERN_DEBUG
 					       "debugging disabled for module "
-					       "%s", elem->name);
+					       "%s\n", elem->name);
 				}
 			}
 		}
-- 
1.5.6.3


--=-QMIQXDTrejkocp/86rgh--

