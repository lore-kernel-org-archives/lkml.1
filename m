Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab0BBHWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:22:31 -0500
Received: from mail.perches.com ([173.55.12.10]:1769 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab0BBHWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:22:22 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Roger Lucas <vt8231@hiddenengine.co.uk>, lm-sensors@lm-sensors.org
Subject: [PATCH 04/10] drivers/hwmon/vt8231.c: Fix continuation line formats
Date: Mon,  1 Feb 2010 23:22:10 -0800
Message-Id: <4a6cb6ef5a33d29220f021e2f28c7d676fff5e09.1265095094.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1265095093.git.joe@perches.com>
References: <cover.1265095093.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hwmon/vt8231.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/vt8231.c b/drivers/hwmon/vt8231.c
index d47b4c9..e6078c9 100644
--- a/drivers/hwmon/vt8231.c
+++ b/drivers/hwmon/vt8231.c
@@ -948,8 +948,7 @@ static int __devinit vt8231_pci_probe(struct pci_dev *dev,
 
 	address = val & ~(VT8231_EXTENT - 1);
 	if (address == 0) {
-		dev_err(&dev->dev, "base address not set -\
-				 upgrade BIOS or use force_addr=0xaddr\n");
+		dev_err(&dev->dev, "base address not set - upgrade BIOS or use force_addr=0xaddr\n");
 		return -ENODEV;
 	}
 
-- 
1.6.6.rc0.57.gad7a

