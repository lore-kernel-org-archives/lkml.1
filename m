Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab0BRP7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:59:52 -0500
Received: from www.linuxtv.org ([130.149.80.248]:42268 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758564Ab0BRP72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:59:28 -0500
Subject: [git:v4l-dvb/master] V4L/DVB: Kbuild addition for TVP7002 driver
From: Patch from Santiago Nunez-Corrales 
	<linuxtv-commits-bounces@linuxtv.org>
To: linuxtv-commits@linuxtv.org
Data: Fri, 18 Dec 2009 14:07:57 -0300
Cc: Mocean Laboratories <info@mocean-labs.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       linux-kernel@vger.kernel.org, Kang Yong <kangyong@telegent.com>,
       Huang Shijie <shijie8@gmail.com>, Zhang Xiaobing <xbzhang@telegent.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Richard Rojfors <richard.rojfors@pelagicore.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1Ni8UK-00087R-Gn@www.linuxtv.org>
Date: Thu, 18 Feb 2010 16:40:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>

This patch provides menu configuration options for the TVP7002
decoder driver in DM365. Includes only TVP7002.

Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/video/Kconfig  |    9 +++++++++
 drivers/media/video/Makefile |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

---

http://git.linuxtv.org/v4l-dvb.git?a=commit;h=467e2a73ed39e9a570fd1e37add29f3a05fe880e

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 2f9c57d..7978afa 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -388,6 +388,15 @@ config VIDEO_TVP5150
 	  To compile this driver as a module, choose M here: the
 	  module will be called tvp5150.
 
+config VIDEO_TVP7002
+	tristate "Texas Instruments TVP7002 video decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Texas Instruments TVP7002 video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tvp7002.
+
 config VIDEO_VPX3220
 	tristate "vpx3220a, vpx3216b & vpx3214c video decoders"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 5163289..b88b617 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
 obj-$(CONFIG_VIDEO_VINO) += indycam.o
 obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
 obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
+obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
 obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
 obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
 obj-$(CONFIG_VIDEO_CS53L32A) += cs53l32a.o
