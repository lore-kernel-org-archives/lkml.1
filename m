Return-Path: <linux-kernel-owner+w=401wt.eu-S935341AbZJOTqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935341AbZJOTqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935295AbZJOTqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:46:14 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:38488
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935280AbZJOTqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:46:12 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: jayalk@intworks.biz, lethal@linux-sh.org, damm@igel.co.jp,
       akpm@linux-foundation.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 2/8] trivial: fix typo s/complied-in/compiled-in/
Date: Thu, 15 Oct 2009 16:45:25 -0300
Message-Id: <1255635925-5738-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/video/fb_defio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
index c27ab1e..e59c083 100644
--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -71,7 +71,7 @@ int fb_deferred_io_fsync(struct file *file, struct dentry *dentry, int datasync)
 {
 	struct fb_info *info = file->private_data;
 
-	/* Skip if deferred io is complied-in but disabled on this fbdev */
+	/* Skip if deferred io is compiled-in but disabled on this fbdev */
 	if (!info->fbdefio)
 		return 0;
 
-- 
1.6.3.3

