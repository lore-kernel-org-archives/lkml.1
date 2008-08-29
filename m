Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbYH2GPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbYH2GPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYH2GP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:15:26 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59505 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbYH2GP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:26 -0400
Date: Thu, 28 Aug 2008 23:47:40 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5lewc016113@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5 2/29] mdb: export genapic and machine_restart functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export genapic and machine_restart functions


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/arch/x86/kernel/reboot.c	2008-08-28 14:19:19.000000000 -0600
+++ b/arch/x86/kernel/reboot.c	2008-08-28 14:20:04.000000000 -0600
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
