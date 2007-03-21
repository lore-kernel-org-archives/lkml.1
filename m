Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbXCUGtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbXCUGtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXCUGtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:49:16 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:16036 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbXCUGtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:49:15 -0400
Message-ID: <d4cf37a60703202349l5abef5fdoda02bd17193711f1@mail.gmail.com>
Date: Tue, 20 Mar 2007 23:49:14 -0700
From: "Wink Saville" <wink@saville.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] Initialize trec early so it may be used early
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wink Saville <wink@saville.com>
---
 init/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/init/main.c b/init/main.c
index a92989e..46bc440 100644
--- a/init/main.c
+++ b/init/main.c
@@ -54,6 +54,7 @@
 #include <linux/lockdep.h>
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
+#include <linux/trec.h>

 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -517,6 +518,9 @@ asmlinkage void __init start_kernel(void)
 	early_boot_irqs_off();
 	early_init_irq_lock_class();

+	trec_init();
+	TREC0();
+
 /*
  * Interrupts are still disabled. Do necessary setups, then
  * enable them
-- 
1.5.0.rc2
