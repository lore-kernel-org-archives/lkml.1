Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752839AbYLQTao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYLQTao (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYLQT3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:29:17 -0500
Received: from kroah.org ([198.145.64.141]:54239 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751632AbYLQT3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:29:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/4] driver core: add newlines to debugging enabled/disabled messages
Date: Wed, 17 Dec 2008 11:28:22 -0800
Message-Id: <1229542103-24678-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20081217192737.GA24641@kroah.com>
References: <20081217192737.GA24641@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

Both messages are missing the newline and thus dmesg output gets
scrambled.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/dynamic_printk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_printk.c b/lib/dynamic_printk.c
index d0fd0e4..8e30295 100644
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
1.6.0.4

