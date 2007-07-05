Return-Path: <linux-kernel-owner+w=401wt.eu-S1761577AbXGER72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbXGER72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758475AbXGER7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:59:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:38649 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbXGER7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:59:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=fKVX0TCQx4vHU9douXvM8Dqd9n5N29ShPelEJRio2B6QKBtiMht4BkApXARWOqcFR5ntFBgi/AII28q9MFHAwreoXWj8+obs/36p5PFTMITvBxz2cyqS3McXxhKOB1s2l2fBWsZs1fTo8J2QlOgkZqrCzVh7HM3oWX/AFVU4pbE=
Date: Thu, 5 Jul 2007 21:59:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminge <shemminger@linux-foundation.org>
Subject: [PATCH] Sky Cpu: use C99 style for struct init
Message-ID: <20070705175910.GG7180@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch change structure item init
format to C99.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

The patch is over my prev patch named:

	[PATCH 1/4] Sky Cpu and Nexus: code style improvement

 drivers/misc/hdpuftrs/hdpu_cpustate.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/misc/hdpuftrs/hdpu_cpustate.c b/drivers/misc/hdpuftrs/hdpu_cpustate.c
index 51e4963..cc33f24 100644
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c
+++ b/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -171,21 +171,21 @@ static struct platform_driver hdpu_cpustate_driver = {
  *	The various file operations we support.
  */
 static const struct file_operations cpustate_fops = {
-      owner:	THIS_MODULE,
-      open:	cpustate_open,
-      release:	cpustate_release,
-      read:	cpustate_read,
-      write:	cpustate_write,
-      fasync:	NULL,
-      poll:	NULL,
-      ioctl:	NULL,
-      llseek:	no_llseek,
+      .owner	= THIS_MODULE,
+      .open	= cpustate_open,
+      .release	= cpustate_release,
+      .read	= cpustate_read,
+      .write	= cpustate_write,
+      .fasync	= NULL,
+      .poll	= NULL,
+      .ioctl	= NULL,
+      .llseek	= no_llseek,
 };
 
 static struct miscdevice cpustate_dev = {
-	MISC_DYNAMIC_MINOR,
-	"sky_cpustate",
-	&cpustate_fops,
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "sky_cpustate",
+	.fops	= &cpustate_fops,
 };
 
 static int hdpu_cpustate_probe(struct platform_device *pdev)
