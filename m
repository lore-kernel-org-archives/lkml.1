Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYCaJJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYCaJJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbYCaJII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:08:08 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54045 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001AbYCaJIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:08:05 -0400
Date: Mon, 31 Mar 2008 12:07:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [2.6.25 patch] ide/arm/ide_arm.c: add MODULE_LICENSE
Message-ID: <20080331090750.GI28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that it can be built modular it needs a MODULE_LICENSE.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
f8cbcd76a93a50b78880b52134636db07102889f diff --git a/drivers/ide/arm/ide_arm.c b/drivers/ide/arm/ide_arm.c
index 43a70e9..be9ff73 100644
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -46,3 +46,5 @@ static int __init ide_arm_init(void)
 }
 
 module_init(ide_arm_init);
+
+MODULE_LICENSE("GPL");

