Return-Path: <linux-kernel-owner+w=401wt.eu-S935884AbYD1PnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935884AbYD1PnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964929AbYD1Pji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:39:38 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49116 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964924AbYD1Pjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:39:37 -0400
Date: Mon, 28 Apr 2008 18:39:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] make drm_minors_cleanup() static
Message-ID: <20080428153903.GJ2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global drm_minors_cleanup() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
33cfc2c40ea8449f0e36af7107778a2bdaffae19 diff --git a/drivers/char/drm/drm_drv.c b/drivers/char/drm/drm_drv.c
index fc54140..7166a55 100644
--- a/drivers/char/drm/drm_drv.c
+++ b/drivers/char/drm/drm_drv.c
@@ -318,7 +318,7 @@ static void drm_cleanup(struct drm_device * dev)
 		DRM_ERROR("Cannot unload module\n");
 }
 
-int drm_minors_cleanup(int id, void *ptr, void *data)
+static int drm_minors_cleanup(int id, void *ptr, void *data)
 {
 	struct drm_minor *minor = ptr;
 	struct drm_device *dev;

