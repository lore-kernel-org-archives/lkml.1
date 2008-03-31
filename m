Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYCaJLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYCaJLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbYCaJIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:08:20 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:51847 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187AbYCaJIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:08:18 -0400
Date: Mon, 31 Mar 2008 12:08:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [2.6.25 patch] ide/legacy/macide: add MODULE_LICENSE
Message-ID: <20080331090803.GO28445@cs181133002.pp.htv.fi>
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
dddf696c7717b48663dab4feb2b599c8f6d05553 diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index 9a79098..eaf5dbe 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -137,3 +137,5 @@ static int __init macide_init(void)
 }
 
 module_init(macide_init);
+
+MODULE_LICENSE("GPL");

