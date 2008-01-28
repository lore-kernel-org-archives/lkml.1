Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbYA1Iqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbYA1Iqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbYA1IqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:46:11 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:41923 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753454AbYA1IqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:46:09 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 28 Jan 2008 08:45:42 +0000
Message-Id: <1201509949-3285-3-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201509949-3285-2-git-send-email-ijc@hellion.org.uk>
References: <1201509949-3285-1-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-2-git-send-email-ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCHv2 2/9] x86: Unify whitespace in arch/x86/boot/compressed/vmlinux_??.scr
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
 arch/x86/boot/compressed/vmlinux_32.scr |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/vmlinux_32.scr b/arch/x86/boot/compressed/vmlinux_32.scr
index 707a88f..a549526 100644
--- a/arch/x86/boot/compressed/vmlinux_32.scr
+++ b/arch/x86/boot/compressed/vmlinux_32.scr
@@ -2,9 +2,9 @@ SECTIONS
 {
   .data.compressed : {
 	input_len = .;
-	LONG(input_data_end - input_data) input_data = .; 
-	*(.data) 
+	LONG(input_data_end - input_data) input_data = .;
+	*(.data)
 	output_len = . - 4;
-	input_data_end = .; 
+	input_data_end = .;
 	}
 }
-- 
1.5.3.8

