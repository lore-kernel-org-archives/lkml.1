Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab0BXTIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 14:08:47 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:42831 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527Ab0BXTIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:08:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=YeFFIdbAWcMLl4adpSVctxvDbxmBGZ1+NaoxFOGg4fDg6MttdOPkLfYof6pMVJg0aa
         zvG90dGiphfZ7PpVJx3DGr/p2tQsplfIv4pIiKIdi2XwNSyUYF1Ma//Hu0JmBAHTmZBS
         rBYa7/Kr2L3PfL3IpHjzPGF+k6RIsMthvcmok=
From: Alessio Igor Bogani <abogani@texware.it>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alessio Igor Bogani <abogani@texware.it>, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: Cleanup useless headers
Date: Wed, 24 Feb 2010 20:08:15 +0100
Message-Id: <1267038495-13961-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL isn't anymore present into these files thus it is no necessary still include smp_lock.h.
---
 drivers/staging/comedi/comedi_compat32.c    |    1 -
 drivers/staging/comedi/drivers/usbdux.c     |    1 -
 drivers/staging/comedi/drivers/usbduxfast.c |    1 -
 drivers/staging/panel/panel.c               |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/comedi_compat32.c b/drivers/staging/comedi/comedi_compat32.c
index a9fdcda..581aa5f 100644
--- a/drivers/staging/comedi/comedi_compat32.c
+++ b/drivers/staging/comedi/comedi_compat32.c
@@ -26,7 +26,6 @@
 
 #define __NO_VERSION__
 #include "comedi.h"
-#include <linux/smp_lock.h>
 #include <linux/uaccess.h>
 
 #include "comedi_compat32.h"
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 9a1b559..d400d43 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -95,7 +95,6 @@ sampling rate. If you sample two channels you get 4kHz and so on.
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/usb.h>
-#include <linux/smp_lock.h>
 #include <linux/fcntl.h>
 #include <linux/compiler.h>
 #include <linux/firmware.h>
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 2e675cc..40512f5 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -44,7 +44,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/usb.h>
-#include <linux/smp_lock.h>
 #include <linux/fcntl.h>
 #include <linux/compiler.h>
 #include "comedi_fc.h"
diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 95c93e8..377884f 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -41,7 +41,6 @@
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
-- 
1.6.3.3

