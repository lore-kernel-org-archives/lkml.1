Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbYAKDYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbYAKDYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 22:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760477AbYAKDXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 22:23:13 -0500
Received: from ns.suse.de ([195.135.220.2]:51750 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760443AbYAKDXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 22:23:11 -0500
Subject: [PATCH 11/11 ] Change drm_ioctl as an unlocked_ioctl function : via
From: Nikanth Karthikesan <knikanth@suse.de>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       benh@kernel.crashing.org, paulus@samba.org, thomas@winischhofer.net,
       adaplas@gmail.com, sylvain.meyer@worldonline.fr
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain
Date: Fri, 11 Jan 2008 08:56:44 +0530
Message-Id: <1200022004.3844.20.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register drm_ioctl as an unlocked_ioctl function.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

--- 
diff --git a/drivers/char/drm/via_drv.c b/drivers/char/drm/via_drv.c
index 2d4957a..a8041c5 100644
--- a/drivers/char/drm/via_drv.c
+++ b/drivers/char/drm/via_drv.c
@@ -62,7 +62,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,


