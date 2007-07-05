Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbXGEQy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbXGEQy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761466AbXGEQyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:54:46 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:28041 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761420AbXGEQyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=f9KdBzO1TiiyRiSDXZ8B+tOgxNtuXYkeb/KQdbFrDp3wc7T+cjuzh8lg6dRgmz9EFg6Y6R2gCTKw63QfTSs4Rv3LwYpxsP1dDoeIhoCEr9q10m8YmXoGir5zP3Vc8UC8vXcrx4Rq9Q6RTUsIaorPTLlEKC3SYnees9Np/tAknRk=
Date: Thu, 5 Jul 2007 20:54:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/4] Sky Cpu and Nexus: include io.h
Message-ID: <20070705165437.GC7180@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds #include <asm/io.h> directive
to properly declare ioremap() and writel().

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |    1 +
 drivers/misc/hdpuftrs/hdpu_nexus.c    |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/hdpuftrs/hdpu_cpustate.c b/drivers/misc/hdpuftrs/hdpu_cpustate.c
index 556f90d..fdd9e2e 100644
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c
+++ b/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <asm/uaccess.h>
 #include <linux/hdpu_features.h>
+#include <asm/io.h>
 
 #define SKY_CPUSTATE_VERSION		"1.1"
 
diff --git a/drivers/misc/hdpuftrs/hdpu_nexus.c b/drivers/misc/hdpuftrs/hdpu_nexus.c
index fd3f3c2..fda9998 100644
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c
+++ b/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -20,6 +20,7 @@
 #include <linux/hdpu_features.h>
 
 #include <linux/platform_device.h>
+#include <asm/io.h>
 
 static int hdpu_nexus_probe(struct platform_device *pdev);
 static int hdpu_nexus_remove(struct platform_device *pdev);
