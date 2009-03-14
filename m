Return-Path: <linux-kernel-owner+w=401wt.eu-S1751765AbZCNOoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbZCNOoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 10:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZCNOoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 10:44:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:39590 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbZCNOoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 10:44:11 -0400
Subject: [PATCH -tip] x86: i8257.c cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 20:13:35 +0530
Message-Id: <1237041815.4546.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86: i8257.c cleanup

Impact: cleanup

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/i8237.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/i8237.c b/arch/x86/kernel/i8237.c
index b42ca69..044ca09 100644
--- a/arch/x86/kernel/i8237.c
+++ b/arch/x86/kernel/i8237.c
@@ -9,9 +9,8 @@
  * your option) any later version.
  */
 
-#include <linux/init.h>
 #include <linux/sysdev.h>
-
+#include <linux/init.h>
 #include <asm/dma.h>
 
 /*
@@ -64,8 +63,10 @@ static struct sys_device device_i8237A = {
 static int __init i8237A_init_sysfs(void)
 {
 	int error = sysdev_class_register(&i8237_sysdev_class);
+
 	if (!error)
 		error = sysdev_register(&device_i8237A);
+
 	return error;
 }
 device_initcall(i8237A_init_sysfs);
-- 
1.6.0.6



