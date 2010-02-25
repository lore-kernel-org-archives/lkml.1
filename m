Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab0BYFHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 00:07:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab0BYFHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 00:07:45 -0500
From: Dave Airlie <airlied@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@redhat.com>
Subject: [PATCH 1/2] fb: for framebuffer handover don't exit the loop early.
Date: Thu, 25 Feb 2010 15:07:55 +1000
Message-Id: <1267074476-28347-2-git-send-email-airlied@gmail.com>
In-Reply-To: <1267074476-28347-1-git-send-email-airlied@gmail.com>
References: <1267074476-28347-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

An offb machine has been seen in the fields which adds two
offb nodes, so continue scanning the list after removing one.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/video/fbmem.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 99bbd28..a15b44e 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1513,7 +1513,6 @@ register_framebuffer(struct fb_info *fb_info)
 				       fb_info->fix.id,
 				       registered_fb[i]->fix.id);
 				unregister_framebuffer(registered_fb[i]);
-				break;
 			}
 		}
 	}
-- 
1.6.5.2

