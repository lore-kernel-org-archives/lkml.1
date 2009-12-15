Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbZLOB7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbZLOB7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758197AbZLOB7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:59:32 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46254 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758180AbZLOB7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:59:31 -0500
Date: Tue, 15 Dec 2009 12:59:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: linux-next: manual merge of the voltage tree with Linus' tree
Message-Id: <20091215125929.51e236a2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam,

Today's linux-next merge of the voltage tree got a conflict in
drivers/regulator/Makefile between commit
b07682b6056eb6701f8cb86aa5800e6f2ea7919b ("mfd: Rename twl4030* driver
files to enable re-use") from Linus' tree and commit
9c4d460f13b7d81abb26449a3920638889a3e5ed ("regulator: add driver for
MAX8660/8661") from the voltage tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/regulator/Makefile
index 9ae3cc4,2cf98a7..0000000
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@@ -11,7 -11,8 +11,8 @@@ obj-$(CONFIG_REGULATOR_USERSPACE_CONSUM
  obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
  obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
  obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
+ obj-$(CONFIG_REGULATOR_MAX8660) += max8660.o
 -obj-$(CONFIG_REGULATOR_TWL4030) += twl4030-regulator.o
 +obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
  obj-$(CONFIG_REGULATOR_WM831X) += wm831x-dcdc.o
  obj-$(CONFIG_REGULATOR_WM831X) += wm831x-isink.o
  obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
