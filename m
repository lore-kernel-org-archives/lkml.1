Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbYFTRip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbYFTRip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYFTRih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:38:37 -0400
Received: from mail.queued.net ([207.210.101.209]:2208 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbYFTRig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:38:36 -0400
Date: Fri, 20 Jun 2008 13:41:11 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adaplas@gmail.com, jordan.crouse@amd.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] lxfb: drop dead declarations from header
Message-ID: <20080620134111.67038f21@xo-debian>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We never sent the gamma stuff upstream, and don't really care about it.
However, lx_[gs]_et_gamma prototypes snuck into lxfb.h anyways; there
are no definitions for them.  Drop the dead code.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/geode/lxfb.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/geode/lxfb.h b/drivers/video/geode/lxfb.h
index 3b9416f..6a51448 100644
--- a/drivers/video/geode/lxfb.h
+++ b/drivers/video/geode/lxfb.h
@@ -51,8 +51,6 @@ static inline unsigned int lx_get_pitch(unsigned int xres, int bpp)
 }
 
 void lx_set_mode(struct fb_info *);
-void lx_get_gamma(struct fb_info *, unsigned int *, int);
-void lx_set_gamma(struct fb_info *, unsigned int *, int);
 unsigned int lx_framebuffer_size(void);
 int lx_blank_display(struct fb_info *, int);
 void lx_set_palette_reg(struct fb_info *, unsigned int, unsigned int,
-- 
1.5.5.3

