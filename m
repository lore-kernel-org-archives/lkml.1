Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbZA1Xaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbZA1Xaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbZA1X2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:28:14 -0500
Received: from kroah.org ([198.145.64.141]:56984 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756889AbZA1X2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:28:13 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Mike Lockwood <lockwood@android.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/10] Staging: android: timed_gpio: Fix build to build on kernels after 2.6.25.
Date: Wed, 28 Jan 2009 15:26:44 -0800
Message-Id: <1233185210-23098-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090128232319.GA23009@kroah.com>
References: <20090128232319.GA23009@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mike Lockwood <lockwood@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/android/timed_gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/timed_gpio.c b/drivers/staging/android/timed_gpio.c
index bea68c9..b41b20e 100644
--- a/drivers/staging/android/timed_gpio.c
+++ b/drivers/staging/android/timed_gpio.c
@@ -18,7 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/hrtimer.h>
 #include <linux/err.h>
-#include <asm/arch/gpio.h>
+#include <linux/gpio.h>
 
 #include "timed_gpio.h"
 
-- 
1.6.0.2

