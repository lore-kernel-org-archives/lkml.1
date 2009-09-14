Return-Path: <linux-kernel-owner+w=401wt.eu-S933216AbZINWBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbZINWBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932373AbZINWBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:01:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52081 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbZINWBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:01:09 -0400
Date: Tue, 15 Sep 2009 00:01:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>, arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 6/6] unneccessary camera flash support breaks compilation
Message-ID: <20090914220106.GF11667@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


HTC Dream hardware has no camera flash, and current arm/mach-msm does
not have flash support. Disable flash support for now.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/dream/camera/Kconfig b/drivers/staging/dream/camera/Kconfig
index 0a3e903..bfb6d24 100644
--- a/drivers/staging/dream/camera/Kconfig
+++ b/drivers/staging/dream/camera/Kconfig
@@ -15,7 +15,7 @@ config MSM_CAMERA_DEBUG
 
 config MSM_CAMERA_FLASH
 	bool "Qualcomm MSM camera flash support"
-	depends on MSM_CAMERA
+	depends on MSM_CAMERA && BROKEN
 	---help---
 	  Enable support for LED flash for msm camera
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

----- End forwarded message -----

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
