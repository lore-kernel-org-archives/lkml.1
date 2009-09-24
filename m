Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbZIXLQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbZIXLQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbZIXLQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:16:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:51966 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbZIXLQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:16:01 -0400
Subject: [PATCH] video: includecheck fix: msm, mddi.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Pavel Machek <pavel@ucw.cz>, Brian Swetland <swetland@google.com>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Rebecca Schultz Zavin <rebecca@android.com>,
       Dima Zavin <dima@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 16:44:32 +0530
Message-Id: <1253790872.5860.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/video/msm/mddi.c: linux/delay.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Rebecca Schultz Zavin <rebecca@android.com>
Cc: Dima Zavin <dima@android.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/msm/mddi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
index f2de5a1..5c5a1ad 100644
--- a/drivers/video/msm/mddi.c
+++ b/drivers/video/msm/mddi.c
@@ -27,8 +27,6 @@
 #include <mach/msm_iomap.h>
 #include <mach/irqs.h>
 #include <mach/board.h>
-#include <linux/delay.h>
-
 #include <mach/msm_fb.h>
 #include "mddi_hw.h"
 
-- 
1.6.0.6


