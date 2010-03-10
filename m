Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab0CJLdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:33:14 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59926 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab0CJLdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:33:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=SlRELFS/QJVt9ZOvw/qz5R9KhAqXQu/NI4O33IxKxg0lqD35mzTTsz5QGnjmDAzsVz
         nOawuL7xQCiqhotINrQjawAGvG+olxbgV1P2fakoktNd8DHmSHaDxBfprBVl5+fAc17+
         T9cmGo4Zqck+ayuSyrM5VhABuzpubhW3jvlis=
From: Magnus Damm <magnus.damm@gmail.com>
To: lethal@linux-sh.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
Date: Wed, 10 Mar 2010 20:33:10 +0900
Message-Id: <20100310113310.20654.18555.sendpatchset@t400s>
Subject: [PATCH] video: enable sh_mobile_lcdc on SH-Mobile ARM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch enables the sh_mobile_lcdc driver on
SH-Mobile ARM.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 0001/drivers/video/Kconfig
+++ work/drivers/video/Kconfig	2010-03-10 20:12:42.000000000 +0900
@@ -1867,7 +1867,7 @@ config FB_W100
 
 config FB_SH_MOBILE_LCDC
 	tristate "SuperH Mobile LCDC framebuffer support"
-	depends on FB && SUPERH && HAVE_CLK
+	depends on FB && (SUPERH || ARCH_SHMOBILE) && HAVE_CLK
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
