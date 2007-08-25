Return-Path: <linux-kernel-owner+w=401wt.eu-S964777AbXHYJJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964777AbXHYJJL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 05:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933172AbXHYJI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 05:08:59 -0400
Received: from 240.37.78.83.cust.bluewin.ch ([83.78.37.240]:59202 "EHLO
	spock.one.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933141AbXHYJI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 05:08:58 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Aug 2007 05:08:58 EDT
Date: Sat, 25 Aug 2007 10:59:31 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] uvesafb: select connector in Kconfig
Message-ID: <20070825085931.GA9318@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make uvesafb select connector instead of depending on it being already selected.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index f1cc899..e152eed 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -594,7 +594,8 @@ config FB_TGA
 
 config FB_UVESA
 	tristate "Userspace VESA VGA graphics support"
-	depends on FB && CONNECTOR
+	depends on FB
+	select CONNECTOR
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
