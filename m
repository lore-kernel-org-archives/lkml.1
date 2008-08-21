Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbYHUDQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbYHUDQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbYHUDQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:16:05 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50075 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbYHUDQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:16:04 -0400
Date: Wed, 20 Aug 2008 20:50:35 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808210250.m7L2oZav028313@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc4 1/27] mdb: export genapic and machine_restart functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export genapic and machine_restart functions


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/arch/x86/kernel/reboot.c	2008-08-18 23:39:25.000000000 -0600
+++ b/arch/x86/kernel/reboot.c	2008-08-18 23:40:26.000000000 -0600
@@ -502,7 +502,10 @@
 {
 	machine_ops.restart(cmd);
 }
-
+EXPORT_SYMBOL_GPL(machine_restart);
+#if defined(CONFIG_SMP)
+EXPORT_SYMBOL(genapic);
+#endif
 void machine_halt(void)
 {
 	machine_ops.halt();
