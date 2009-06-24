Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbZFXLih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbZFXLih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbZFXLgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:36:36 -0400
Received: from smtp.nokia.com ([192.100.105.134]:58175 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551AbZFXLge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:36:34 -0400
From: Imre Deak <imre.deak@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <Tomi.Valkeinen@nokia.com>
Subject: [PATCH 18/20] omapfb: Fix coding style / remove dead line
Date: Wed, 24 Jun 2009 14:33:43 +0300
Message-Id: <d724e13a36e386e87474ecc9f20fc8d07f22512d.1245842329.git.imre.deak@nokia.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <f9ed866c0fe8112e1b18f2b90a52e41b23413982.1245842329.git.imre.deak@nokia.com>
References: <1245843225-1036-1-git-send-email-imre.deak@nokia.com>
 <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
 <5cf7e298c3b70ad6e07d34034cc901689445e978.1245842329.git.imre.deak@nokia.com>
 <f2b49525146391a3d01b944bf4ebce045cb503d4.1245842329.git.imre.deak@nokia.com>
 <9cecdc5077b72042551eb8e3dc96911e9f4fa3fd.1245842329.git.imre.deak@nokia.com>
 <a3b6ef17cc694c350bc3a585a1697cf57cb0b1c1.1245842329.git.imre.deak@nokia.com>
 <0e2b7b0555c657a8eab00df0091b9828fb292f4c.1245842329.git.imre.deak@nokia.com>
 <af3d1e0dff22f0bb72f6ccee57dfa9a1e5f31abb.1245842329.git.imre.deak@nokia.com>
 <6881ca5b34fcf36c3f39b13de85857dcc20f568d.1245842329.git.imre.deak@nokia.com>
 <726d4af0547b42ec8a9af7c6f0079cf9b7fadf5c.1245842329.git.imre.deak@nokia.com>
 <742d96c9c8d6826eddd49a913b6adaa8f176edbe.1245842329.git.imre.deak@nokia.com>
 <279625bb9ea911185e017cdf8d18a46f263fbb5c.1245842329.git.imre.deak@nokia.com>
 <db880b91c36cbd5672f503e249d44411448533bd.1245842329.git.imre.deak@nokia.com>
 <1ad64c0995ee88d15ebce74dec4d1da9746367f0.1245842329.git.imre.deak@nokia.com>
 <cba1956a016f911d20cce07f38a33ebbf6c6186e.1245842329.git.imre.deak@nokia.com>
 <b11909c54018be72619164782fcf3d6743d0fddd.1245842329.git.imre.deak@nokia.com>
 <a9da40529f3dc3d0bf304c4d15cb45f1af8ae150.1245842329.git.imre.deak@nokia.com>
 <f9ed866c0fe8112e1b18f2b90a52e41b23413982.1245842329.git.imre.deak@nokia.com>
In-Reply-To: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
References: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
X-OriginalArrivalTime: 24 Jun 2009 11:36:22.0029 (UTC) FILETIME=[FF8F6BD0:01C9F4BF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: arun c <arunedarath@mistralsolutions.com>

- use __iomem type attribute where appropriate
- expand (a ? : b) to (a ? a : b)
As suggested by Russel King <linux@arm.linux.org.uk>

- remove a dead line from omapfb_main.c

Signed-off-by: Arun C <arunedarath@mistralsolutions.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
 arch/arm/plat-omap/include/mach/omapfb.h |    4 ++--
 drivers/video/omap/omapfb_main.c         |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm/plat-omap/include/mach/omapfb.h b/arch/arm/plat-omap/include/mach/omapfb.h
index 7b74d12..b226bdf 100644
--- a/arch/arm/plat-omap/include/mach/omapfb.h
+++ b/arch/arm/plat-omap/include/mach/omapfb.h
@@ -276,8 +276,8 @@ typedef int (*omapfb_notifier_callback_t)(struct notifier_block *,
 					  void *fbi);
 
 struct omapfb_mem_region {
-	dma_addr_t	paddr;
-	void		*vaddr;
+	u32		paddr;
+	void __iomem	*vaddr;
 	unsigned long	size;
 	u8		type;		/* OMAPFB_PLANE_MEM_* */
 	unsigned	alloc:1;	/* allocated by the driver */
diff --git a/drivers/video/omap/omapfb_main.c b/drivers/video/omap/omapfb_main.c
index 098177b..0df4523 100644
--- a/drivers/video/omap/omapfb_main.c
+++ b/drivers/video/omap/omapfb_main.c
@@ -562,7 +562,6 @@ static int set_fb_var(struct fb_info *fbi,
 		var->xoffset = var->xres_virtual - var->xres;
 	if (var->yres + var->yoffset > var->yres_virtual)
 		var->yoffset = var->yres_virtual - var->yres;
-	line_size = var->xres * bpp / 8;
 
 	if (plane->color_mode == OMAPFB_COLOR_RGB444) {
 		var->red.offset	  = 8; var->red.length	 = 4;
@@ -1719,8 +1718,8 @@ static int omapfb_do_probe(struct platform_device *pdev,
 
 	pr_info("omapfb: configured for panel %s\n", fbdev->panel->name);
 
-	def_vxres = def_vxres ? : fbdev->panel->x_res;
-	def_vyres = def_vyres ? : fbdev->panel->y_res;
+	def_vxres = def_vxres ? def_vxres : fbdev->panel->x_res;
+	def_vyres = def_vyres ? def_vyres : fbdev->panel->y_res;
 
 	init_state++;
 
-- 
1.6.3.2

