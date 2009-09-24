Return-Path: <linux-kernel-owner+w=401wt.eu-S1751611AbZIXLJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbZIXLJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbZIXLI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:08:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:42536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbZIXLI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:08:58 -0400
Subject: [PATCH] video: includecheck fix: da8xx-fb.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Kevin Hilman <khilman@deeprootsystems.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Pavel Kiryukhin <pkiryukhin@ru.mvista.com>,
       Steve Chen <schen@mvista.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       davinci <davinci-linux-open-source@linux.davincidsp.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 16:37:10 +0530
Message-Id: <1253790430.5860.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/video/da8xx-fb.c: linux/device.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Pavel Kiryukhin <pkiryukhin@ru.mvista.com>
Cc: Steve Chen <schen@mvista.com>
Cc: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/da8xx-fb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 42e1005..d065894 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -26,7 +26,6 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
-#include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/clk.h>
 #include <video/da8xx-fb.h>
-- 
1.6.0.6


