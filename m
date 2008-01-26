Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYAZL4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYAZL4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 06:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYAZLzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 06:55:07 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:40143 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbYAZLzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 06:55:04 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 26 Jan 2008 11:54:06 +0000
Message-Id: <6a16d4a8c094a684aa76e898adf1d3e127daeedf.1201348185.git.ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
In-Reply-To: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH 2/9] x86: Unify whitespace in arch/x86/boot/compressed/vmlinux_??.scr
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

