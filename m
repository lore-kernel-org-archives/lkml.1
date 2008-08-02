Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbYHBTYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbYHBTYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbYHBTYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:24:13 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:21641 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbYHBTYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:24:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=OM3g5SF+v8qHgStyKt8cQrLg35YSGeTLZ0oCZgy3ZP0MvGCQ70nqfoXS5L/zIM6ang
         adIagsAIYn1TVKIc2mCNnDar+Ge1dod5U8t+xVoOAG7rL6gNHrDC2izYDNGHj1tAPJUZ
         /L718jXSn+kbzxlcEUOSflMuVVz1qEQdRynwI=
Date: Sat, 2 Aug 2008 21:24:06 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa <hpa@zytor.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       tglx <tglx@linutronix.de>
Subject: [PATCH 2/5] x86: Coding style fixes to arch/x86/kernel/bios_uv.c
Message-ID: <20080802212406.047e8ae6@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 5 errors, 0 warnings, 48 lines checked

After:
total: 0 errors, 0 warnings, 58 lines checked

paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/bios_uv.o.*
9afe794594831166704744184e192ed8  /tmp/bios_uv.o.after
9afe794594831166704744184e192ed8  /tmp/bios_uv.o.before

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/bios_uv.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/bios_uv.c b/arch/x86/kernel/bios_uv.c
index c639bd5..100e759 100644
--- a/arch/x86/kernel/bios_uv.c
+++ b/arch/x86/kernel/bios_uv.c
@@ -25,11 +25,21 @@ x86_bios_strerror(long status)
 {
 	const char *str;
 	switch (status) {
-	case  0: str = "Call completed without error"; break;
-	case -1: str = "Not implemented"; break;
-	case -2: str = "Invalid argument"; break;
-	case -3: str = "Call completed with error"; break;
-	default: str = "Unknown BIOS status code"; break;
+	case  0:
+		str = "Call completed without error";
+		break;
+	case -1:
+		str = "Not implemented";
+		break;
+	case -2:
+		str = "Invalid argument";
+		break;
+	case -3:
+		str = "Call completed with error";
+		break;
+	default:
+		str = "Unknown BIOS status code";
+		break;
 	}
 	return str;
 }
-- 
1.5.6.rc1.21.g03300

