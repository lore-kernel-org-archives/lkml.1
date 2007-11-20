Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbXKTByM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbXKTByM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbXKTBtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:16 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2063 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753AbXKTBtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:01 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Minyard <minyard@acm.org>, David Airlie <airlied@linux.ie>,
       openipmi-developer@lists.sourceforge.net
Subject: [PATCH 13/59] drivers/char: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:05 -0800
Message-Id: <1195523331-15303-14-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-13-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
Message-Id: <552e08f56ca307c471834197a8e880045b4f024e.1195454434.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/agp/generic.c        |    4 ++--
 drivers/char/agp/intel-agp.c      |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c |    2 +-
 drivers/char/snsc.c               |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 64b2f6d..9d73933 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -485,12 +485,12 @@ static void agp_v2_parse_one(u32 *requested_mode, u32 *bridge_agpstat, u32 *vga_
 	switch (*bridge_agpstat & 7) {
 	case 4:
 		*bridge_agpstat |= (AGPSTAT2_2X | AGPSTAT2_1X);
-		printk(KERN_INFO PFX "BIOS bug. AGP bridge claims to only support x4 rate"
+		printk(KERN_INFO PFX "BIOS bug. AGP bridge claims to only support x4 rate. "
 			"Fixing up support for x2 & x1\n");
 		break;
 	case 2:
 		*bridge_agpstat |= AGPSTAT2_1X;
-		printk(KERN_INFO PFX "BIOS bug. AGP bridge claims to only support x2 rate"
+		printk(KERN_INFO PFX "BIOS bug. AGP bridge claims to only support x2 rate. "
 			"Fixing up support for x1\n");
 		break;
 	default:
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index d879619..fb621cc 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -1922,7 +1922,7 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
 
 	if (intel_agp_chipsets[i].name == NULL) {
 		if (cap_ptr)
-			printk(KERN_WARNING PFX "Unsupported Intel chipset"
+			printk(KERN_WARNING PFX "Unsupported Intel chipset "
                                "(device id: %04x)\n", pdev->device);
 		agp_put_bridge(bridge);
 		return -ENODEV;
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index e686fc9..ee62617 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -293,7 +293,7 @@ MODULE_PARM_DESC(preop, "Pretimeout driver operation.  One of: "
 		 "preop_none, preop_panic, preop_give_data.");
 
 module_param(start_now, int, 0444);
-MODULE_PARM_DESC(start_now, "Set to 1 to start the watchdog as"
+MODULE_PARM_DESC(start_now, "Set to 1 to start the watchdog as "
 		 "soon as the driver is loaded.");
 
 module_param(nowayout, int, 0644);
diff --git a/drivers/char/snsc.c b/drivers/char/snsc.c
index b9c1dba..a9681d0 100644
--- a/drivers/char/snsc.c
+++ b/drivers/char/snsc.c
@@ -402,7 +402,7 @@ scdrv_init(void)
 			scd = kzalloc(sizeof (struct sysctl_data_s),
 				      GFP_KERNEL);
 			if (!scd) {
-				printk("%s: failed to allocate device info"
+				printk("%s: failed to allocate device info "
 				       "for %s/%s\n", __FUNCTION__,
 				       SYSCTL_BASENAME, devname);
 				continue;
-- 
1.5.3.5.652.gf192c

