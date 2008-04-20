Return-Path: <linux-kernel-owner+w=401wt.eu-S1763842AbYDTKwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763842AbYDTKwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759116AbYDTKlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:41:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56386 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056AbYDTKlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:41:15 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, David Airlie <airlied@linux.ie>,
       Tony Jones <tonyj@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 35/36] DRM: remove unused dev_class
Date: Sun, 20 Apr 2008 03:46:05 -0700
Message-Id: <1208688366-9252-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct class_device *dev_class is not used in the struct drm_head
structure at all, so remove it as class_device is being removed entirely
from the kernel.


Cc: David Airlie <airlied@linux.ie>
Cc: Tony Jones <tonyj@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/drm/drmP.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/drm/drmP.h b/drivers/char/drm/drmP.h
index 8ea9dd1..6540948 100644
--- a/drivers/char/drm/drmP.h
+++ b/drivers/char/drm/drmP.h
@@ -640,7 +640,6 @@ struct drm_head {
 	struct drm_device *dev;
 	struct proc_dir_entry *dev_root;  /**< proc directory entry */
 	dev_t device;			/**< Device number for mknod */
-	struct class_device *dev_class;
 };
 
 /**
-- 
1.5.4.5

