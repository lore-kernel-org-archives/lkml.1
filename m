Return-Path: <linux-kernel-owner+w=401wt.eu-S1767789AbXCJEKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767789AbXCJEKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767785AbXCJEJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:09:40 -0500
Received: from ns.suse.de ([195.135.220.2]:36292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767778AbXCJEJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:09:20 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/5] driver core: export device_rename
Date: Fri,  9 Mar 2007 20:07:31 -0800
Message-Id: <11734996612279-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <1173499658766-git-send-email-gregkh@suse.de>
References: <20070310040405.GC30638@kroah.com> <11734996523796-git-send-email-gregkh@suse.de> <11734996551193-git-send-email-gregkh@suse.de> <1173499658766-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

In wireless we'd like to allow renaming of the phy devices we surface in
sysfs. The base wireless code, however, can be built modular and thus we
need device_rename exported.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index fb16f29..f191afe 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1065,7 +1065,7 @@ int device_rename(struct device *dev, char *new_name)
 
 	return error;
 }
-
+EXPORT_SYMBOL_GPL(device_rename);
 
 static int device_move_class_links(struct device *dev,
 				   struct device *old_parent,
-- 
1.5.0.2

