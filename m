Return-Path: <linux-kernel-owner+w=401wt.eu-S932151AbXB1Liz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbXB1Liz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 06:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932142AbXB1Liy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 06:38:54 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:44106 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbXB1Liy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 06:38:54 -0500
Subject: [PATCH] export device_rename
From: Johannes Berg <johannes@sipsolutions.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 28 Feb 2007 12:38:31 +0100
Message-Id: <1172662711.3681.51.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In wireless we'd like to allow renaming of the phy devices we surface in
sysfs. The base wireless code, however, can be built modular and thus we
need device_rename exported.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Is this acceptable? For testing reasons we want the cfg80211 code
buildable as a module.

 drivers/base/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-dev.orig/drivers/base/core.c	2007-02-28 12:35:37.123956566 +0100
+++ wireless-dev/drivers/base/core.c	2007-02-28 12:35:51.763956566 +0100
@@ -1029,7 +1029,7 @@ int device_rename(struct device *dev, ch
 
 	return error;
 }
-
+EXPORT_SYMBOL_GPL(device_rename);
 
 static int device_move_class_links(struct device *dev,
 				   struct device *old_parent,


