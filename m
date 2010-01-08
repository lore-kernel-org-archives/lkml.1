Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109Ab0AHVUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0AHVUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 16:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083Ab0AHVUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 16:20:38 -0500
Received: from [206.15.93.42] ([206.15.93.42]:32630 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754071Ab0AHVUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 16:20:37 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/gpu/drm/nouveau/nouveau_debugfs.c: remove unnecessary casts
Date: Fri, 8 Jan 2010 14:20:32 -0700
Cc: dri-devel@lists.sourceforge.net, airlied@linux.ie
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001081420.32778.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpu/drm/nouveau/nouveau_debugfs.c: Remove unnecessary casts.

The struct seq_file 'private' member is a void *, the casts are not needed.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Airlie <airlied@linux.ie>

---

diff --git a/drivers/gpu/drm/nouveau/nouveau_debugfs.c b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
index d79db36..4971d8f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_debugfs.c
+++ b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
@@ -36,7 +36,7 @@
 static int
 nouveau_debugfs_channel_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct nouveau_channel *chan = node->info_ent->data;
 
 	seq_printf(m, "channel id    : %d\n", chan->id);
@@ -107,7 +107,7 @@ nouveau_debugfs_channel_fini(struct nouveau_channel *chan)
 static int
 nouveau_debugfs_chipset_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_minor *minor = node->minor;
 	struct drm_device *dev = minor->dev;
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
@@ -124,7 +124,7 @@ nouveau_debugfs_chipset_info(struct seq_file *m, void *data)
 static int
 nouveau_debugfs_memory_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_minor *minor = node->minor;
 	struct drm_device *dev = minor->dev;
 
