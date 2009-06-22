Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbZFVT7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbZFVT7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbZFVT6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:58:46 -0400
Received: from nox.protox.org ([88.191.38.29]:49963 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbZFVT6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:58:46 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm: fix edid interlaced bit position
Date: Mon, 22 Jun 2009 21:58:38 +0200
Message-Id: <1245700718-2015-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 include/drm/drm_edid.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
index c263e4d..83ea6c9 100644
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -51,7 +51,7 @@ struct std_timing {
 #define DRM_EDID_PT_VSYNC_POSITIVE (1 << 5)
 #define DRM_EDID_PT_SEPARATE_SYNC  (3 << 3)
 #define DRM_EDID_PT_STEREO         (1 << 2)
-#define DRM_EDID_PT_INTERLACED     (1 << 1)
+#define DRM_EDID_PT_INTERLACED     (1 << 7)
 
 /* If detailed data is pixel timing */
 struct detailed_pixel_timing {
-- 
1.6.2.2

