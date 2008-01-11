Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbYAKDYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbYAKDYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 22:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbYAKDW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 22:22:56 -0500
Received: from ns2.suse.de ([195.135.220.15]:53320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760291AbYAKDWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 22:22:52 -0500
Subject: [PATCH 9/11 ] Change drm_ioctl as an unlocked_ioctl function : sis
From: Nikanth Karthikesan <knikanth@suse.de>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       benh@kernel.crashing.org, paulus@samba.org, thomas@winischhofer.net,
       adaplas@gmail.com, sylvain.meyer@worldonline.fr
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain
Date: Fri, 11 Jan 2008 08:56:33 +0530
Message-Id: <1200021993.3844.16.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register drm_ioctl as an unlocked_ioctl function.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

--- 
diff --git a/drivers/char/drm/sis_drv.c b/drivers/char/drm/sis_drv.c
index 7dacc64..1bbde29 100644
--- a/drivers/char/drm/sis_drv.c
+++ b/drivers/char/drm/sis_drv.c
@@ -80,7 +80,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,


