Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbYCaJMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbYCaJMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbYCaJIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:08:32 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:51868 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575AbYCaJIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:08:31 -0400
Date: Mon, 31 Mar 2008 12:08:16 +0300
From: Adrian Bunk <bunk@kernel.org>
To: rmk@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [2.6.25 patch] arm/kernel/arthur.c: add MODULE_LICENSE
Message-ID: <20080331090816.GS28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing MODULE_LICENSE("GPL").

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
0507dfe6516b470b02ce32689a25864ba70b50ca diff --git a/arch/arm/kernel/arthur.c b/arch/arm/kernel/arthur.c
index 0ee2e98..321c529 100644
--- a/arch/arm/kernel/arthur.c
+++ b/arch/arm/kernel/arthur.c
@@ -90,3 +90,5 @@ static void __exit arthur_exit(void)
 
 module_init(arthur_init);
 module_exit(arthur_exit);
+
+MODULE_LICENSE("GPL");

