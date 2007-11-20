Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbXKTBzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbXKTBzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbXKTBtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:23 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2071 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756963AbXKTBtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:04 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, i2c@lm-sensors.org
Subject: [PATCH 16/59] drivers/i2c: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:08 -0800
Message-Id: <1195523331-15303-17-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-16-git-send-email-joe@perches.com>
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
 <1195523331-15303-14-git-send-email-joe@perches.com>
 <1195523331-15303-15-git-send-email-joe@perches.com>
 <1195523331-15303-16-git-send-email-joe@perches.com>
Message-Id: <239a2d17c4e7f18b0aa0f34e1856f4d72a38e0d8.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/i2c/busses/i2c-davinci.c |    4 ++--
 drivers/i2c/busses/i2c-omap.c    |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index bd7aaff..6767988 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -404,7 +404,7 @@ static irqreturn_t i2c_davinci_isr(int this_irq, void *dev_id)
 						      DAVINCI_I2C_STR_REG,
 						      w);
 			} else
-				dev_err(dev->dev, "RDR IRQ while no"
+				dev_err(dev->dev, "RDR IRQ while no "
 					"data requested\n");
 			break;
 
@@ -423,7 +423,7 @@ static irqreturn_t i2c_davinci_isr(int this_irq, void *dev_id)
 						      DAVINCI_I2C_IMR_REG,
 						      w);
 			} else
-				dev_err(dev->dev, "TDR IRQ while no data to"
+				dev_err(dev->dev, "TDR IRQ while no data to "
 					"send\n");
 			break;
 
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 89a3002..cb55cf2 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -203,7 +203,7 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 		while (!(omap_i2c_read_reg(dev, OMAP_I2C_SYSS_REG) &
 			 OMAP_I2C_SYSS_RDONE)) {
 			if (time_after(jiffies, timeout)) {
-				dev_warn(dev->dev, "timeout waiting"
+				dev_warn(dev->dev, "timeout waiting "
 						"for controller reset\n");
 				return -ETIMEDOUT;
 			}
@@ -483,7 +483,7 @@ omap_i2c_isr(int this_irq, void *dev_id)
 					dev->buf_len--;
 				}
 			} else
-				dev_err(dev->dev, "RRDY IRQ while no data"
+				dev_err(dev->dev, "RRDY IRQ while no data "
 						"requested\n");
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_RRDY);
 			continue;
@@ -498,7 +498,7 @@ omap_i2c_isr(int this_irq, void *dev_id)
 					dev->buf_len--;
 				}
 			} else
-				dev_err(dev->dev, "XRDY IRQ while no"
+				dev_err(dev->dev, "XRDY IRQ while no "
 					"data to send\n");
 			omap_i2c_write_reg(dev, OMAP_I2C_DATA_REG, w);
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XRDY);
-- 
1.5.3.5.652.gf192c

