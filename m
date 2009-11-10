Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbZKJIXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbZKJIXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 03:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZKJIXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 03:23:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33651 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZKJIXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 03:23:12 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 1/2] regulator/mc13783: rename source file to match other drivers
Date: Tue, 10 Nov 2009 09:18:06 +0100
Message-Id: <1257841087-23662-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091106002847.GC22366@sortiz.org>
References: <20091106002847.GC22366@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One annoying thing about the old name was that the module was just
called mc13783 which caused wrong expectations (at least for me).

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
Hello,

I split that from the following patch mainly for review because if I
squash them together git's rename detection doesn't trigger any more.

Best regards
Uwe

 drivers/regulator/Makefile                         |    2 +-
 .../regulator/{mc13783.c => mc13783-regulator.c}   |    0
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename drivers/regulator/{mc13783.c => mc13783-regulator.c} (100%)

diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 4257a86..8891767 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
-obj-$(CONFIG_REGULATOR_MC13783) += mc13783.o
+obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
 obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
 
 obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
diff --git a/drivers/regulator/mc13783.c b/drivers/regulator/mc13783-regulator.c
similarity index 100%
rename from drivers/regulator/mc13783.c
rename to drivers/regulator/mc13783-regulator.c
-- 
1.6.5.2

