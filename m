Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbYJ2XEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbYJ2XEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbYJ2XCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:02:48 -0400
Received: from kroah.org ([198.145.64.141]:35890 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753278AbYJ2XC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:02:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Qinghuang Feng <s3c24xx@gmail.com>,
       Qinghuang Feng <qhfeng.kernel@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/6] driver core: drivers/base/sys.c: update comments
Date: Wed, 29 Oct 2008 15:58:08 -0700
Message-Id: <1225321092-21933-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223824.GB21657@kroah.com>
References: <20081029223824.GB21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qinghuang Feng <s3c24xx@gmail.com>

There are no functions named sys_device_shutdown or sys_device_suspend
in the kernel.
They should be fixed to sysdev_shutdown and sysdev_suspend respectively.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 75dd6e2..3ca9c5e 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -355,7 +355,7 @@ static void __sysdev_resume(struct sys_device *dev)
  *	sysdev_suspend - Suspend all system devices.
  *	@state:		Power state to enter.
  *
- *	We perform an almost identical operation as sys_device_shutdown()
+ *	We perform an almost identical operation as sysdev_shutdown()
  *	above, though calling ->suspend() instead. Interrupts are disabled
  *	when this called. Devices are responsible for both saving state and
  *	quiescing or powering down the device.
@@ -437,7 +437,7 @@ aux_driver:
 /**
  *	sysdev_resume - Bring system devices back to life.
  *
- *	Similar to sys_device_suspend(), but we iterate the list forwards
+ *	Similar to sysdev_suspend(), but we iterate the list forwards
  *	to guarantee that parent devices are resumed before their children.
  *
  *	Note: Interrupts are disabled when called.
-- 
1.6.0.2

