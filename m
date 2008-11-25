Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbYKYJvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbYKYJvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 04:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbYKYJvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 04:51:41 -0500
Received: from host2.marvell.com ([65.219.4.2]:53348 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752307AbYKYJvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 04:51:40 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] drivers/video/backlight: rename da903x to da903x_bl
Date: Tue, 25 Nov 2008 01:51:38 -0800
Message-ID: <E913911567467945BBEB9277E27868B00153DC31@msiexch01.marvell.com>
In-Reply-To: <1227606164-12659-1-git-send-email-mike@compulab.co.il>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/video/backlight: rename da903x to da903x_bl
Thread-Index: AclO4jAmZSWP9a+9RwmXk00ss4cBYQAAB/Jw
References: <1227606164-12659-1-git-send-email-mike@compulab.co.il>
From: "Eric Miao" <ymiao3@marvell.com>
To: "Mike Rapoport" <mike@compulab.co.il>, <rpurdie@rpsys.net>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isn't modprobe supposed to be smart enough for things like this?

I'm afraid if modprobe isn't so capable, we may encounter the same
issue with other drivers and sometimes it is not so easy for
developers of aphasia like me to choose a better name :)

- eric

-----Original Message-----
From: Mike Rapoport [mailto:mike@compulab.co.il] 
Sent: Tuesday, November 25, 2008 5:43 PM
To: rpurdie@rpsys.net
Cc: Eric Miao; linux-kernel@vger.kernel.org; Mike Rapoport
Subject: [PATCH] drivers/video/backlight: rename da903x to da903x_bl

Currently both da903x backlight and voltage reulator drivers have the
same name. Rename the backlight driver to allow use of both drivers as
modules.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/video/backlight/Makefile                  |    2 +-
 drivers/video/backlight/{da903x.c => da903x_bl.c} |    0 
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename drivers/video/backlight/{da903x.c => da903x_bl.c} (100%)

diff --git a/drivers/video/backlight/Makefile
b/drivers/video/backlight/Makefile
index 103427d..2d8f7cb 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
 obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
 obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
-obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x.o
+obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
 obj-$(CONFIG_BACKLIGHT_MBP_NVIDIA) += mbp_nvidia_bl.o
 obj-$(CONFIG_BACKLIGHT_TOSA)	+= tosa_bl.o
 obj-$(CONFIG_BACKLIGHT_SAHARA)	+= kb3886_bl.o
diff --git a/drivers/video/backlight/da903x.c
b/drivers/video/backlight/da903x_bl.c
similarity index 100%
rename from drivers/video/backlight/da903x.c
rename to drivers/video/backlight/da903x_bl.c
-- 
1.5.6.4

