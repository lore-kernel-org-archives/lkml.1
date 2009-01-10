Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbZAJSIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbZAJSIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZAJSIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:08:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:50809 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZAJSIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:08:10 -0500
Subject: [PATCH -tip] x86: msr.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 23:35:58 +0530
Message-Id: <1231610758.3994.3.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Fix:

 WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

 total: 0 errors, 1 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/msr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 7262666..3cf3413 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -35,10 +35,10 @@
 #include <linux/device.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
+#include <linux/uaccess.h>
 
 #include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static struct class *msr_class;
-- 
1.5.6.6



