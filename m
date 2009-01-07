Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbZAGLka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbZAGLka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 06:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZAGLkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 06:40:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32962 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750776AbZAGLkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 06:40:21 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] touchscreen: Fix build of da9034
To: fengwei.yin@marvell.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Wed, 07 Jan 2009 11:40:03 +0000
Message-ID: <20090107113932.2465.18134.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Missing an include and thus breaks the x86-64 build.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/input/touchscreen/da9034-ts.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/input/touchscreen/da9034-ts.c b/drivers/input/touchscreen/da9034-ts.c
index 4342e77..fa67d78 100644
--- a/drivers/input/touchscreen/da9034-ts.c
+++ b/drivers/input/touchscreen/da9034-ts.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
+#include <linux/workqueue.h>
 #include <linux/mfd/da903x.h>
 
 #define DA9034_MANUAL_CTRL	0x50

