Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbZBDXoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbZBDXoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbZBDXoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:44:05 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:40340 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbZBDXoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:44:04 -0500
Date: Wed, 4 Feb 2009 16:44:01 -0700
From: Alex Chiang <achiang@hp.com>
To: mingo@elte.hu
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix grammar in user-visible BIOS warning
Message-ID: <20090204234401.GA19517@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, mingo@elte.hu,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix user-visible grammo.

Impact: cleanup

Signed-off-by: Alex Chiang <achiang@hp.com>
---
This is obviously (to me) .30 material, thanks.

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ae0d804..c461f6d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -607,7 +607,7 @@ struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
-		"%s detected: BIOS may corrupt low RAM, working it around.\n",
+		"%s detected: BIOS may corrupt low RAM, working around it.\n",
 		d->ident);
 
 	e820_update_range(0, 0x10000, E820_RAM, E820_RESERVED);
