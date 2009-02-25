Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZBYSQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZBYSQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 13:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZBYSP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 13:15:56 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:46228 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbZBYSPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 13:15:55 -0500
Date: Wed, 25 Feb 2009 19:15:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] DRM: drm_crtc_helper.h doesn't actually need i2c.h
Message-ID: <20090225191541.572c3b3b@hyperion.delvare>
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
