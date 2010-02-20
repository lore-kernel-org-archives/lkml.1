Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab0BTAGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:06:30 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50004 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab0BTAEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gY/4xcWPPSlnU7qTV/v5RQ2+nzQuecgmDH0/iN8HNe3IFjb23OTeXI9chk5mnS8FDO
         fHbtF9kFlmPCf9H1hAL2u7QdCrCN70/FaPZebo5Ty/J/OcslMHp/uNwpkEHCljYzSONP
         oIdN7SbeiwHoOif+j8j8ODNegV1YBAVxXfe90=
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
Subject: [PATCH 18/24] Rename .text.startup to .text..startup.
Date: Sat, 20 Feb 2010 01:03:51 +0100
Message-Id: <1266624237-22372-19-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/h8300/boot/compressed/head.S      |    2 +-
 arch/h8300/boot/compressed/vmlinux.lds |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/h8300/boot/compressed/head.S b/arch/h8300/boot/compressed/head.S
index 985a81a..10e9a2d 100644
--- a/arch/h8300/boot/compressed/head.S
+++ b/arch/h8300/boot/compressed/head.S
@@ -9,7 +9,7 @@
 
 #define SRAM_START 0xff4000
 
-	.section	.text.startup
+	.section	.text..startup
 	.global	startup
 startup:
 	mov.l	#SRAM_START+0x8000, sp
diff --git a/arch/h8300/boot/compressed/vmlinux.lds b/arch/h8300/boot/compressed/vmlinux.lds
index 65e2a0d..a0a3a0e 100644
--- a/arch/h8300/boot/compressed/vmlinux.lds
+++ b/arch/h8300/boot/compressed/vmlinux.lds
@@ -4,7 +4,7 @@ SECTIONS
         {
         __stext = . ;
 	__text = .;
-	       *(.text.startup)
+	       *(.text..startup)
 	       *(.text)
         __etext = . ;
         }
-- 
1.6.2.4

