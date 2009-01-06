Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbZAFW1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbZAFW1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbZAFWN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:58 -0500
Received: from kroah.org ([198.145.64.141]:51282 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755623AbZAFWNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:55 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Ralf Baechle <ralf@linux-mips.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/60] mips: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:56 -0800
Message-Id: <1231279939-32728-37-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/mips/kernel/vpe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 010b27e..3ca5f42 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -1454,7 +1454,7 @@ static int __init vpe_module_init(void)
 	device_initialize(&vpe_device);
 	vpe_device.class	= &vpe_class,
 	vpe_device.parent	= NULL,
-	strlcpy(vpe_device.bus_id, "vpe1", BUS_ID_SIZE);
+	dev_set_name(&vpe_device, "vpe1");
 	vpe_device.devt = MKDEV(major, minor);
 	err = device_add(&vpe_device);
 	if (err) {
-- 
1.6.0.4

