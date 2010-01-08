Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098Ab0AHVSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0AHVSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 16:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081Ab0AHVSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 16:18:09 -0500
Received: from [206.15.93.42] ([206.15.93.42]:32566 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754080Ab0AHVSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 16:18:07 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/gpu/drm/i915/i915_debugfs.c: remove unnecessary casts
Date: Fri, 8 Jan 2010 14:18:01 -0700
Cc: dri-devel@lists.sourceforge.net, airlied@linux.ie
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001081418.01471.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpu/drm/i915/i915_debugfs.c: Remove unnecessary casts.

The struct seq_file 'private' member is a void *, the casts are not needed.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Airlie <airlied@linux.ie>

---

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 9c9998c..94d8fac 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -64,7 +64,7 @@ static const char *get_tiling_flag(struct drm_i915_gem_object *obj_priv)
 
 static int i915_gem_object_list_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	uintptr_t list = (uintptr_t) node->info_ent->data;
 	struct list_head *head;
 	struct drm_device *dev = node->minor->dev;
@@ -123,7 +123,7 @@ static int i915_gem_object_list_info(struct seq_file *m, void *data)
 
 static int i915_gem_request_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct drm_i915_gem_request *gem_request;
@@ -139,7 +139,7 @@ static int i915_gem_request_info(struct seq_file *m, void *data)
 
 static int i915_gem_seqno_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
 
@@ -158,7 +158,7 @@ static int i915_gem_seqno_info(struct seq_file *m, void *data)
 
 static int i915_interrupt_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
 
@@ -210,7 +210,7 @@ static int i915_interrupt_info(struct seq_file *m, void *data)
 
 static int i915_gem_fence_regs_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	int i;
@@ -245,7 +245,7 @@ static int i915_gem_fence_regs_info(struct seq_file *m, void *data)
 
 static int i915_hws_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	int i;
@@ -278,7 +278,7 @@ static void i915_dump_pages(struct seq_file *m, struct page **pages, int page_co
 
 static int i915_batchbuffer_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct drm_gem_object *obj;
@@ -311,7 +311,7 @@ static int i915_batchbuffer_info(struct seq_file *m, void *data)
 
 static int i915_ringbuffer_data(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	u8 *virt;
@@ -334,7 +334,7 @@ static int i915_ringbuffer_data(struct seq_file *m, void *data)
 
 static int i915_ringbuffer_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	unsigned int head, tail;
@@ -352,7 +352,7 @@ static int i915_ringbuffer_info(struct seq_file *m, void *data)
 
 static int i915_error_state(struct seq_file *m, void *unused)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct drm_i915_error_state *error;
