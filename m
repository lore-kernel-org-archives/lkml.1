Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbYKSNRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbYKSNRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 08:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYKSNQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 08:16:37 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:52375 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbYKSNQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 08:16:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=iqfxDqT2wWDLTWEheVmrQ8G9OHMEleTfqJWLrvE2j6NDZ/GyGkmBzNk7aOOjjaMZ2j
         e0E3Jh+VNOfkBVTKd/dt4dwqXaU8fPqqTXVuyiZ86IddT6DKEcQKBBIlGhzgMmr6c5/Y
         G1oWoi0uHdXiDFurcTb7jwdnPmp0gBBKaFwp8=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>,
       Mike Lavender <mike@steroidmicros.com>,
       David Hinds <dahinds@users.sourceforge.net>
Subject: [PATCH 3/4] drivers/mtd/devices/m25p80.c: mark {__init|__exit} for
 {init|exit} functions
Date: Wed, 19 Nov 2008 21:16:27 +0800
User-Agent: sniper-patch-carrier/1.06
Message-ID: <492411b2.02066e0a.135c.4dde@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 76a7675..ff6a80e 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -768,13 +768,13 @@ static struct spi_driver m25p80_driver = {
 };
 
 
-static int m25p80_init(void)
+static int __init m25p80_init(void)
 {
 	return spi_register_driver(&m25p80_driver);
 }
 
 
-static void m25p80_exit(void)
+static void __exit m25p80_exit(void)
 {
 	spi_unregister_driver(&m25p80_driver);
 }

