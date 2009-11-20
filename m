Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbZKTLjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbZKTLjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 06:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbZKTLjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 06:39:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33143 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbZKTLjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 06:39:17 -0500
Date: Fri, 20 Nov 2009 12:39:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: linux-fbdev-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Arve Hj?nnev?g <arve@android.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>, San Mehat <san@google.com>,
       Daniel Walker <dwalker@fifo99.com>, Iliyan Malchev <malchev@google.com>
Subject: Allow selecting MSM framebuffer in Kconfig
Message-ID: <20091120113915.GA5154@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allow user to select MSM framebuffer support in Kconfig.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 188e1ba..b3e05e4 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2127,7 +2127,7 @@ config FB_PRE_INIT_FB
 	  the bootloader.
 
 config FB_MSM
-	tristate
+	tristate "MSM Framebuffer support"
 	depends on FB && ARCH_MSM
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
