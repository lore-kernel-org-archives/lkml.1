Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbYAHQsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbYAHQsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:48:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbYAHQrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:47:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbYAHQrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:47:51 -0500
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, Andre Haupt <andre@bitwigglers.org>
Subject: [PATCH][KJ] input: remove duplicate includes
Date: Tue,  8 Jan 2008 17:47:38 +0100
Message-Id: <1199810858233-git-send-email-andre@bitwigglers.org>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: n
References: n
X-Provags-ID: V01U2FsdGVkX19nzoRU7RiYai2H/PX/TwpUSNKO9/Zm+Ahdr8a
 rbapIWGCGv10i/PaQGGeU4thBRxO7LrgIAAVeEODiSKZWbopFw
 uC0YdnKoJewyUN0QpQWi07CUAq/Wrz0MoyjCddi4q0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
---
 drivers/input/gameport/gameport.c       |    1 -
 drivers/input/keyboard/bf54x-keys.c     |    1 -
 drivers/input/keyboard/jornada720_kbd.c |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index bfc6061..682a70e 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -17,7 +17,6 @@
 #include <linux/init.h>
 #include <linux/gameport.h>
 #include <linux/wait.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
index e5f4da9..05e3494 100644
--- a/drivers/input/keyboard/bf54x-keys.c
+++ b/drivers/input/keyboard/bf54x-keys.c
@@ -42,7 +42,6 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
-#include <linux/irq.h>
 
 #include <asm/portmux.h>
 #include <asm/mach/bf54x_keys.h>
diff --git a/drivers/input/keyboard/jornada720_kbd.c b/drivers/input/keyboard/jornada720_kbd.c
index e6696b3..986f93c 100644
--- a/drivers/input/keyboard/jornada720_kbd.c
+++ b/drivers/input/keyboard/jornada720_kbd.c
@@ -17,7 +17,6 @@
  */
 #include <linux/device.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/input.h>
-- 
1.4.4.4

