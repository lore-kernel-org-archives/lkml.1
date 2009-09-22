Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbZIVOwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbZIVOwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbZIVOwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:52:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:53859 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593AbZIVOwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:52:41 -0400
Subject: [PATCH] STAGING: includecheck fix: dream, smd_rpcrouter.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>,
       San Mehat <san@android.com>, Iliyan Malchev <ibm@android.com>,
       Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 20:22:29 +0530
Message-Id: <1253631149.3784.29.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/staging/dream/smd/smd_rpcrouter.c: asm/byteorder.h is included more than once.

And <asm/uaccess.h> is not required if we include <linux/uaccess.h>
as it will be automatically included from <linux/uaccess.h>

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/staging/dream/smd/smd_rpcrouter.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dream/smd/smd_rpcrouter.c b/drivers/staging/dream/smd/smd_rpcrouter.c
index d4a4a88..4c6457c 100644
--- a/drivers/staging/dream/smd/smd_rpcrouter.c
+++ b/drivers/staging/dream/smd/smd_rpcrouter.c
@@ -34,12 +34,9 @@
 #include <linux/sched.h>
 #include <linux/poll.h>
 #include <linux/wakelock.h>
-#include <asm/uaccess.h>
-#include <asm/byteorder.h>
-#include <linux/platform_device.h>
 #include <linux/uaccess.h>
-
 #include <asm/byteorder.h>
+#include <linux/platform_device.h>
 
 #include <mach/msm_smd.h>
 #include "smd_rpcrouter.h"
-- 
1.6.0.6


