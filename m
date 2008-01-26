Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbYAZL4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbYAZL4h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 06:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYAZLzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 06:55:09 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:15020 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752397AbYAZLzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 06:55:06 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 26 Jan 2008 11:54:11 +0000
Message-Id: <5c9a53dfa2ac6835d88bbdde15eb54f0b68d126e.1201348185.git.ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <f6e06e6103414914cd9e198abb69dc206d3deed9.1201348185.git.ijc@hellion.org.uk>
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
 <6a16d4a8c094a684aa76e898adf1d3e127daeedf.1201348185.git.ijc@hellion.org.uk>
 <d4158549e6497ee261ed220d9cbc8ca8fced8ba7.1201348185.git.ijc@hellion.org.uk>
 <b639de14dbe3cf77f61a9ec0f9e23c50f179c18d.1201348185.git.ijc@hellion.org.uk>
 <25c98f11d5811cdee328b2e6c400a36c875bc9b8.1201348185.git.ijc@hellion.org.uk>
 <f6e06e6103414914cd9e198abb69dc206d3deed9.1201348185.git.ijc@hellion.org.uk>
In-Reply-To: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH 7/9] x86: Unify headers in arch/x86/boot/compressed/misc_??.c
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
index b659776..7522b64 100644
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
index b627e00..04f5435 100644
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

