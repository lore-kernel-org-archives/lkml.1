Return-Path: <linux-kernel-owner+w=401wt.eu-S1760612AbZAFWcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612AbZAFWcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbZAFWOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:14 -0500
Received: from kroah.org ([198.145.64.141]:51330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754078AbZAFWOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:10 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 51/60] chris: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:10 -0800
Message-Id: <1231279939-32728-51-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/cris/arch-v32/drivers/iop_fw_load.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/iop_fw_load.c b/arch/cris/arch-v32/drivers/iop_fw_load.c
index 3b3857e..2f8ea0f 100644
--- a/arch/cris/arch-v32/drivers/iop_fw_load.c
+++ b/arch/cris/arch-v32/drivers/iop_fw_load.c
@@ -24,12 +24,12 @@
 #error "Please contact <greg@kroah.com> for details on how to fix it properly."
 
 static struct device iop_spu_device[2] = {
-	{ .bus_id =     "iop-spu0", },
-	{ .bus_id =     "iop-spu1", },
+	{ .init_name =     "iop-spu0", },
+	{ .init_name =     "iop-spu1", },
 };
 
 static struct device iop_mpu_device = {
-	.bus_id =       "iop-mpu",
+	.init_name =       "iop-mpu",
 };
 
 static int wait_mpu_idle(void)
-- 
1.6.0.4

