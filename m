Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab0BTAFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:05:47 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51255 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab0BTAFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:05:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=g0M40SIQZVSJZx4arQv/ox6daVG7RZffoArmB+ZlMpze8DUIMx4nxFGINg5SniAVB4
         Y/ff3npkJH74MktHpF05tkjG4Kw7S6CKoUXuo/3lR7K0O8q9kByYcuFSSHd+3vDs34DU
         yqUDJ7irRDuHvDYFtRa+VyzefZTRGKyJdRbS0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Wesen <bjornw@axis.com>,
       Tim Bird <tim.bird@am.sony.com>, Tim Abbott <tabbott@ksplice.com>,
       Anders Kaseorg <andersk@ksplice.com>, Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 24/24] Rename .text.start to .text..start.
Date: Sat, 20 Feb 2010 01:03:57 +0100
Message-Id: <1266624237-22372-25-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/mips/lasat/image/head.S           |    2 +-
 arch/mips/lasat/image/romscript.normal |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/lasat/image/head.S b/arch/mips/lasat/image/head.S
index efb95f2..e0ecda9 100644
--- a/arch/mips/lasat/image/head.S
+++ b/arch/mips/lasat/image/head.S
@@ -1,7 +1,7 @@
 #include <asm/lasat/head.h>
 
 	.text
-	.section .text.start, "ax"
+	.section .text..start, "ax"
 	.set noreorder
 	.set mips3
 
diff --git a/arch/mips/lasat/image/romscript.normal b/arch/mips/lasat/image/romscript.normal
index 988f8ad..0864c96 100644
--- a/arch/mips/lasat/image/romscript.normal
+++ b/arch/mips/lasat/image/romscript.normal
@@ -4,7 +4,7 @@ SECTIONS
 {
   .text :
   {
-    *(.text.start)
+    *(.text..start)
   }
 
   /* Data in ROM */
-- 
1.6.2.4

