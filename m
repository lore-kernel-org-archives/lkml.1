Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbYA1Iqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbYA1Iqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbYA1IqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:46:12 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:55943 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753496AbYA1IqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:46:09 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 28 Jan 2008 08:45:41 +0000
Message-Id: <1201509949-3285-2-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201509949-3285-1-git-send-email-ijc@hellion.org.uk>
References: <1201509949-3285-1-git-send-email-ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCHv2 1/9] x86: Unify whitespace and comments in arch/x86/boot/compressed/vmlinux_??.lds
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
 arch/x86/boot/compressed/vmlinux_32.lds |    6 +++---
 arch/x86/boot/compressed/vmlinux_64.lds |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/boot/compressed/vmlinux_32.lds b/arch/x86/boot/compressed/vmlinux_32.lds
index cc4854f..d98ab69 100644
--- a/arch/x86/boot/compressed/vmlinux_32.lds
+++ b/arch/x86/boot/compressed/vmlinux_32.lds
@@ -3,10 +3,10 @@ OUTPUT_ARCH(i386)
 ENTRY(startup_32)
 SECTIONS
 {
-        /* Be careful parts of head.S assume startup_32 is at
-         * address 0.
+	/* Be careful parts of head_32.S assume startup_32 is at
+	 * address 0.
 	 */
-	. =  0 	;
+	. = 0;
 	.text.head : {
 		_head = . ;
 		*(.text.head)
diff --git a/arch/x86/boot/compressed/vmlinux_64.lds b/arch/x86/boot/compressed/vmlinux_64.lds
index 94c13e5..8d63b3a 100644
--- a/arch/x86/boot/compressed/vmlinux_64.lds
+++ b/arch/x86/boot/compressed/vmlinux_64.lds
@@ -3,8 +3,8 @@ OUTPUT_ARCH(i386:x86-64)
 ENTRY(startup_64)
 SECTIONS
 {
-	/* Be careful parts of head.S assume startup_32 is at
- 	 * address 0.
+	/* Be careful parts of head_64.S assume startup_64 is at
+	 * address 0.
 	 */
 	. = 0;
 	.text :	{
-- 
1.5.3.8

