Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbZCNPdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbZCNPdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 11:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZCNPdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 11:33:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:59540 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZCNPdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 11:33:01 -0400
Subject: [PATCH -tip] x86: io_delay.c cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 21:02:25 +0530
Message-Id: <1237044745.4546.19.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86: io_delay.c cleanup

Impact: cleanup

 - fix header file issues

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/io_delay.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/io_delay.c b/arch/x86/kernel/io_delay.c
index 720d260..f222215 100644
--- a/arch/x86/kernel/io_delay.c
+++ b/arch/x86/kernel/io_delay.c
@@ -7,10 +7,10 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/init.h>
 #include <linux/dmi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 int io_delay_type __read_mostly = CONFIG_DEFAULT_IO_DELAY_TYPE;
 
@@ -126,7 +126,7 @@ static int __init io_delay_param(char *s)
 		return -EINVAL;
 
 	io_delay_override = 1;
+
 	return 0;
 }
-
 early_param("io_delay", io_delay_param);
-- 
1.6.0.6



