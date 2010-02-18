Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414Ab0BRP7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:59:20 -0500
Received: from www.linuxtv.org ([130.149.80.248]:42251 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab0BRP7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:59:19 -0500
Subject: [git:v4l-dvb/master] V4L/DVB: timberdale: fix mfd build
From: Patch from Randy Dunlap <linuxtv-commits-bounces@linuxtv.org>
To: linuxtv-commits@linuxtv.org
Data: Fri, 12 Feb 2010 12:30:55 -0300
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
       Mauro Carvalho Chehab <mchehab@redhat.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1Ni8UK-000871-37@www.linuxtv.org>
Date: Thu, 18 Feb 2010 16:40:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mfd/timberdale build error -- add depends GPIOLIB.

include/linux/spi/max7301.h:14: error: field 'chip' has incomplete type
build-r7353.out:make[3]: *** [drivers/mfd/timberdale.o] Error 1

Repairs

commit ff7a26e08a16bb31158d830dbf60db2ff47019ab
Author:     Richard R<C3><B6>jfors <richard.rojfors@pelagicore.com>
AuthorDate: Thu Feb 4 08:18:52 2010 -0300
Commit:     Mauro Carvalho Chehab <mchehab@redhat.com>
CommitDate: Fri Feb 5 12:25:37 2010 -0200

    V4L/DVB: mfd: Add support for the timberdale FPGA

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Richard Rojfors <richard.rojfors@pelagicore.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

---

http://git.linuxtv.org/v4l-dvb.git?a=commit;h=0cb788768e977cad2ca977702248d1cb029b85f6

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index eb22dee..413576a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -351,7 +351,7 @@ config AB4500_CORE
 config MFD_TIMBERDALE
 	tristate "Support for the Timberdale FPGA"
 	select MFD_CORE
-	depends on PCI
+	depends on PCI && GPIOLIB
 	---help---
 	This is the core driver for the timberdale FPGA. This device is a
 	multifunction device which exposes numerous platform devices.
