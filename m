Return-Path: <linux-kernel-owner+w=401wt.eu-S934194AbZLFUq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934194AbZLFUq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757969AbZLFUqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:46:51 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:60050 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757872AbZLFUqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:46:32 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: airlied@redhat.com, Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 5/5] drm: Export symbols needed for the vmwgfx driver.
Date: Sun,  6 Dec 2009 21:46:28 +0100
Message-Id: <1260132388-28414-6-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.5.3.2
In-Reply-To: <1260132388-28414-5-git-send-email-thellstrom@vmware.com>
References: <1260132388-28414-1-git-send-email-thellstrom@vmware.com>
 <1260132388-28414-2-git-send-email-thellstrom@vmware.com>
 <1260132388-28414-3-git-send-email-thellstrom@vmware.com>
 <1260132388-28414-4-git-send-email-thellstrom@vmware.com>
 <1260132388-28414-5-git-send-email-thellstrom@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/gpu/drm/drm_stub.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 2c1b528..ad73e14 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -128,6 +128,7 @@ struct drm_master *drm_master_get(struct drm_master *master)
 	kref_get(&master->refcount);
 	return master;
 }
+EXPORT_SYMBOL(drm_master_get);
 
 static void drm_master_destroy(struct kref *kref)
 {
@@ -170,6 +171,7 @@ void drm_master_put(struct drm_master **master)
 	kref_put(&(*master)->refcount, drm_master_destroy);
 	*master = NULL;
 }
+EXPORT_SYMBOL(drm_master_put);
 
 int drm_setmaster_ioctl(struct drm_device *dev, void *data,
 			struct drm_file *file_priv)
-- 
1.5.3.2

