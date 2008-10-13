Return-Path: <linux-kernel-owner+w=401wt.eu-S1765736AbYJMKPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765736AbYJMKPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbYJMKFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:05:15 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:58437 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762714AbYJMKFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:05:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=content-disposition:subject:to:date:mime-version:cc:content-type
         :content-transfer-encoding:message-id:from;
        b=B+0l5HXlFtj3le+wyrktHfAP9wvPd1X3B66py+4rVfs8XZ1/z46hCcWvYcB/yyfwKz
         IF//UDKxvcFShoWmnr35DyUZ/bghA4hk74IoJRxSGzFw6Zd2LGL2M9wuzPM21IkChnyQ
         o1AkaZmPe1HJqtUVf+hyW4eBMTyxP+cBG/2Fs=
Content-Disposition: inline
Subject: [PATCH]drivers/base/sys.c:  update comments
To: gregkh@suse.de
Date: Mon, 13 Oct 2008 18:05:04 +0800
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200810131805.04985.qhfeng.kernel@gmail.com>
From: Qinghuang Feng <s3c24xx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no functions named sys_device_shutdown or sys_device_suspend in the
kernel.
They should be fixed to sysdev_shutdown and sysdev_suspend respectively.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
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
