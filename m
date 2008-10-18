Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbYJRNh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbYJRNh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 09:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYJRNhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 09:37:18 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:48411 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbYJRNhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 09:37:17 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix comile error of hdpuftrs
Date: Sat, 18 Oct 2008 15:37:12 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810181537.13653.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

drivers/misc/hdpuftrs/hdpu_nexus.c:118: error: expected identifier or '(' before 'return'
drivers/misc/hdpuftrs/hdpu_nexus.c:119: error: expected identifier or '(' before '}' token

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

--- a/drivers/misc/hdpuftrs/hdpu_nexus.c
+++ b/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -113,7 +113,6 @@ static int hdpu_nexus_probe(struct platform_device *pdev)
 	if (!hdpu_chassis_id)
 		printk(KERN_WARNING "sky_nexus: "
 		       "Unable to create proc dir entry: sky_chassis_id\n");
-	}

 	return 0;
 }
