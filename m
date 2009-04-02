Return-Path: <linux-kernel-owner+w=401wt.eu-S932512AbZDBJwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbZDBJwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbZDBJwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:52:38 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:1595 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbZDBJwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:52:37 -0400
Date: Thu, 2 Apr 2009 11:52:24 +0200
From: Jean Delvare <khali@linux-fr.org>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] DRM: drm_crtc_helper.h doesn't actually need i2c.h
Message-ID: <20090402115224.069b0f23@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an include that isn't actually needed to prevent needless
rebuilds.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
Patch already sent on:
 * 2009-01-13
 * 2009-02-25
David, are you going to apply this patch or should I push it upstream
myself?

 include/drm/drm_crtc_helper.h |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.29-rc1.orig/include/drm/drm_crtc_helper.h	2009-01-11 10:57:58.000000000 +0100
+++ linux-2.6.29-rc1/include/drm/drm_crtc_helper.h	2009-01-13 16:50:20.000000000 +0100
@@ -33,7 +33,6 @@
 #ifndef __DRM_CRTC_HELPER_H__
 #define __DRM_CRTC_HELPER_H__
 
-#include <linux/i2c.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/idr.h>


-- 
Jean Delvare
