Return-Path: <linux-kernel-owner+w=401wt.eu-S1759643AbYA1Isd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643AbYA1Isd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758123AbYA1Iq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:46:56 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:58281 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756205AbYA1Iqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:46:55 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 28 Jan 2008 08:45:47 +0000
Message-Id: <1201509949-3285-8-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201509949-3285-7-git-send-email-ijc@hellion.org.uk>
References: <1201509949-3285-1-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-2-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-3-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-4-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-5-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-6-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-7-git-send-email-ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCHv2 7/9] x86: Unify headers in arch/x86/boot/compressed/misc_??.c
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

size reports no change in arch/x86/boot/compressed/vmlinux.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/misc_32.c |    1 -
 arch/x86/boot/compressed/misc_64.c |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/compressed/misc_32.c b/arch/x86/boot/compressed/misc_32.c
index 52fc214..ad0528a 100644
--- a/arch/x86/boot/compressed/misc_32.c
+++ b/arch/x86/boot/compressed/misc_32.c
@@ -16,7 +16,6 @@
  */
 #undef CONFIG_PARAVIRT
 #include <linux/linkage.h>
-#include <linux/vmalloc.h>
 #include <linux/screen_info.h>
 #include <asm/io.h>
 #include <asm/page.h>
diff --git a/arch/x86/boot/compressed/misc_64.c b/arch/x86/boot/compressed/misc_64.c
index 5029fb3..ca760fb 100644
--- a/arch/x86/boot/compressed/misc_64.c
+++ b/arch/x86/boot/compressed/misc_64.c
@@ -22,6 +22,7 @@
 #include <linux/screen_info.h>
 #include <asm/io.h>
 #include <asm/page.h>
+#include <asm/boot.h>
 
 /* WARNING!!
  * This code is compiled with -fPIC and it is relocated dynamically
-- 
1.5.3.8

