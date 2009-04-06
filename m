Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbZDFJVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbZDFJVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZDFJUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:20:39 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:43505 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbZDFJUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:20:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uDk+1t7Tm0gZnmGyRMQQ/5ywswys+W0j8FY8Zk+xnwvqGgQsoDOWfWVKVMsBpZ27ah
         kIiyPT/fvrbII2e7xSnKAnD2yXYIBASUoBE/z9xJjUDDyNzx6wfHTGenD7PFDnFbnd1P
         ppgmTahg7c8IPwnYbqRRaS24z3VRv1/OEku/c=
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 8/8] Staging: remove unused #include <linux/version.h>'s
Date: Mon,  6 Apr 2009 17:20:29 +0800
Message-Id: <1239009629-2532-1-git-send-email-weiyi.huang@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused #include <linux/version.h>'s.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/staging/b3dfg/b3dfg.c               |    1 -
 drivers/staging/frontier/alphatrack.c       |    1 -
 drivers/staging/frontier/tranzport.c        |    1 -
 drivers/staging/heci/heci.h                 |    1 -
 drivers/staging/heci/heci_data_structures.h |    1 -
 drivers/staging/heci/heci_interface.h       |    1 -
 drivers/staging/meilhaus/me0600_ext_irq.c   |    1 -
 drivers/staging/meilhaus/me0900_di.c        |    1 -
 drivers/staging/meilhaus/me1400_device.c    |    1 -
 drivers/staging/meilhaus/me1400_ext_irq.c   |    1 -
 drivers/staging/meilhaus/me4600_ai.h        |    1 -
 drivers/staging/meilhaus/me4600_ext_irq.c   |    1 -
 drivers/staging/meilhaus/me6000_ao.h        |    1 -
 drivers/staging/meilhaus/me8100_di.c        |    1 -
 drivers/staging/meilhaus/me8200_di.c        |    1 -
 drivers/staging/meilhaus/me8200_do.c        |    1 -
 drivers/staging/rt2860/rt_linux.h           |    1 -
 drivers/staging/serqt_usb/serqt_usb.c       |    1 -
 drivers/staging/wlan-ng/hfa384x_usb.c       |    1 -
 drivers/staging/wlan-ng/p80211netdev.c      |    1 -
 drivers/staging/wlan-ng/p80211wep.c         |    1 -
 drivers/staging/wlan-ng/prism2mib.c         |    1 -
 22 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/b3dfg/b3dfg.c b/drivers/staging/b3dfg/b3dfg.c
index 0348072..1451870 100644
--- a/drivers/staging/b3dfg/b3dfg.c
+++ b/drivers/staging/b3dfg/b3dfg.c
@@ -35,7 +35,6 @@
 #include <linux/poll.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
-#include <linux/version.h>
 #include <linux/uaccess.h>
 
 static unsigned int b3dfg_nbuf = 2;
diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index bcba17e..15aed87 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -39,7 +39,6 @@
 #include <linux/module.h>
 #include <linux/kobject.h>
 #include <linux/mutex.h>
-#include <linux/version.h>
 
 #include <linux/uaccess.h>
 #include <linux/input.h>
diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index 274b82b..ef8fcc8 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -38,7 +38,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/version.h>
 
 #include <linux/uaccess.h>
 #include <linux/input.h>
diff --git a/drivers/staging/heci/heci.h b/drivers/staging/heci/heci.h
index 14192e0..48f120d 100644
--- a/drivers/staging/heci/heci.h
+++ b/drivers/staging/heci/heci.h
@@ -41,7 +41,6 @@
 #ifndef _HECI_H_
 #define _HECI_H_
 
-#include <linux/version.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/pci.h>
diff --git a/drivers/staging/heci/heci_data_structures.h b/drivers/staging/heci/heci_data_structures.h
index 575e8f8..ff30386 100644
--- a/drivers/staging/heci/heci_data_structures.h
+++ b/drivers/staging/heci/heci_data_structures.h
@@ -41,7 +41,6 @@
 #ifndef _HECI_DATA_STRUCTURES_H_
 #define _HECI_DATA_STRUCTURES_H_
 
-#include <linux/version.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/pci.h>
diff --git a/drivers/staging/heci/heci_interface.h b/drivers/staging/heci/heci_interface.h
index 37336eb..d9193cf 100644
--- a/drivers/staging/heci/heci_interface.h
+++ b/drivers/staging/heci/heci_interface.h
@@ -42,7 +42,6 @@
 #ifndef _HECI_INTERFACE_H_
 #define _HECI_INTERFACE_H_
 
-#include <linux/version.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/pci.h>
diff --git a/drivers/staging/meilhaus/me0600_ext_irq.c b/drivers/staging/meilhaus/me0600_ext_irq.c
index 2f6fedc..dc84ab0 100644
--- a/drivers/staging/meilhaus/me0600_ext_irq.c
+++ b/drivers/staging/meilhaus/me0600_ext_irq.c
@@ -32,7 +32,6 @@
 /*
  * Includes
  */
-#include <linux/version.h>
 #include <linux/module.h>
 
 #include <linux/slab.h>
diff --git a/drivers/staging/meilhaus/me0900_di.c b/drivers/staging/meilhaus/me0900_di.c
index 4665b2a..b8c448f 100644
--- a/drivers/staging/meilhaus/me0900_di.c
+++ b/drivers/staging/meilhaus/me0900_di.c
@@ -38,7 +38,6 @@
 #include <linux/io.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
-#include <linux/version.h>
 
 #include "medefines.h"
 #include "meinternal.h"
diff --git a/drivers/staging/meilhaus/me1400_device.c b/drivers/staging/meilhaus/me1400_device.c
index ca7498b..a018b5f 100644
--- a/drivers/staging/meilhaus/me1400_device.c
+++ b/drivers/staging/meilhaus/me1400_device.c
@@ -47,7 +47,6 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
-#include <linux/version.h>
 
 #include "meids.h"
 #include "meerror.h"
diff --git a/drivers/staging/meilhaus/me1400_ext_irq.c b/drivers/staging/meilhaus/me1400_ext_irq.c
index 0dc6b45..4fbc085 100644
--- a/drivers/staging/meilhaus/me1400_ext_irq.c
+++ b/drivers/staging/meilhaus/me1400_ext_irq.c
@@ -32,7 +32,6 @@
 /*
  * Includes
  */
-#include <linux/version.h>
 #include <linux/module.h>
 
 #include <linux/slab.h>
diff --git a/drivers/staging/meilhaus/me4600_ai.h b/drivers/staging/meilhaus/me4600_ai.h
index 106e195..7055e44 100644
--- a/drivers/staging/meilhaus/me4600_ai.h
+++ b/drivers/staging/meilhaus/me4600_ai.h
@@ -28,7 +28,6 @@
 #ifndef _ME4600_AI_H_
 #define _ME4600_AI_H_
 
-#include <linux/version.h>
 #include "mesubdevice.h"
 #include "meioctl.h"
 #include "mecirc_buf.h"
diff --git a/drivers/staging/meilhaus/me4600_ext_irq.c b/drivers/staging/meilhaus/me4600_ext_irq.c
index 6b33cba..42bfd9b 100644
--- a/drivers/staging/meilhaus/me4600_ext_irq.c
+++ b/drivers/staging/meilhaus/me4600_ext_irq.c
@@ -39,7 +39,6 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/types.h>
-#include <linux/version.h>
 
 #include "medefines.h"
 #include "meinternal.h"
diff --git a/drivers/staging/meilhaus/me6000_ao.h b/drivers/staging/meilhaus/me6000_ao.h
index ef4d018..d86fb29 100644
--- a/drivers/staging/meilhaus/me6000_ao.h
+++ b/drivers/staging/meilhaus/me6000_ao.h
@@ -27,7 +27,6 @@
 #ifndef _ME6000_AO_H_
 #define _ME6000_AO_H_
 
-#include <linux/version.h>
 #include "mesubdevice.h"
 #include "mecirc_buf.h"
 #include "meioctl.h"
diff --git a/drivers/staging/meilhaus/me8100_di.c b/drivers/staging/meilhaus/me8100_di.c
index 301dbd8..80e6536 100644
--- a/drivers/staging/meilhaus/me8100_di.c
+++ b/drivers/staging/meilhaus/me8100_di.c
@@ -39,7 +39,6 @@
 #include <linux/io.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
-#include <linux/version.h>
 
 #include "medefines.h"
 #include "meerror.h"
diff --git a/drivers/staging/meilhaus/me8200_di.c b/drivers/staging/meilhaus/me8200_di.c
index a931fb8..9fc2c75 100644
--- a/drivers/staging/meilhaus/me8200_di.c
+++ b/drivers/staging/meilhaus/me8200_di.c
@@ -37,7 +37,6 @@
 #include <linux/io.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
-#include <linux/version.h>
 
 #include "medefines.h"
 #include "meerror.h"
diff --git a/drivers/staging/meilhaus/me8200_do.c b/drivers/staging/meilhaus/me8200_do.c
index 40d536c..3508b0e 100644
--- a/drivers/staging/meilhaus/me8200_do.c
+++ b/drivers/staging/meilhaus/me8200_do.c
@@ -39,7 +39,6 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/types.h>
-#include <linux/version.h>
 
 #include "medefines.h"
 #include "meinternal.h"
diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
index 708923c..4756479 100644
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -42,7 +42,6 @@
 
 #include "rtmp_type.h"
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 
 #include <linux/spinlock.h>
diff --git a/drivers/staging/serqt_usb/serqt_usb.c b/drivers/staging/serqt_usb/serqt_usb.c
index 1781510..cc52c00 100644
--- a/drivers/staging/serqt_usb/serqt_usb.c
+++ b/drivers/staging/serqt_usb/serqt_usb.c
@@ -12,7 +12,6 @@
 #include <linux/usb.h>
 #include <linux/wait.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/uaccess.h>
 
 /* Use our own dbg macro */
diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 888198c..2dc6eb6 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -110,7 +110,6 @@
 * --------------------------------------------------------------------
 */
 
-#include <linux/version.h>
 
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index b2a606a..ff38f29 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -49,7 +49,6 @@
 * --------------------------------------------------------------------
 */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
diff --git a/drivers/staging/wlan-ng/p80211wep.c b/drivers/staging/wlan-ng/p80211wep.c
index 405ce89..ad05237 100644
--- a/drivers/staging/wlan-ng/p80211wep.c
+++ b/drivers/staging/wlan-ng/p80211wep.c
@@ -49,7 +49,6 @@
 /* System Includes */
 
 
-#include <linux/version.h>
 
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
index 5a6ba86..7a082c1 100644
--- a/drivers/staging/wlan-ng/prism2mib.c
+++ b/drivers/staging/wlan-ng/prism2mib.c
@@ -50,7 +50,6 @@
 * --------------------------------------------------------------------
 */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-- 
1.6.1.3

