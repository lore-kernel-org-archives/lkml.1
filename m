Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbYCaJL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbYCaJL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbYCaJIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:08:18 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55944 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177AbYCaJIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:08:16 -0400
Date: Mon, 31 Mar 2008 12:08:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [2.6.25 patch] ide/legacy/falconide.c: add MODULE_LICENSE
Message-ID: <20080331090801.GN28445@cs181133002.pp.htv.fi>
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
b93638a40e3e3d7286c7cfb3254caa9dfe6a0e40 diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index 8949ce7..e950afa 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -93,3 +93,5 @@ static int __init falconide_init(void)
 }
 
 module_init(falconide_init);
+
+MODULE_LICENSE("GPL");

