Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab0BTAE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:04:57 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:33964 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab0BTAEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dB8Odv2SGrUSqn7nslqSP0uZYhrGyyDwQKp507BU0ynjqNVxZ2AF7P66uJAdLNyhka
         V4qrfcvTjEcjB2f2Vgql3eKKhfwpQZ8S2O5fmSC9QI8E9YOCiHQsxxrAtSpScnkDvcVB
         fGEpqcYv5azuy0QE44JDw4XYt5NwCW0m8cqxk=
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
Subject: [PATCH 16/24] Rename .text.page_aligned to .text..page_aligned.
Date: Sat, 20 Feb 2010 01:03:49 +0100
Message-Id: <1266624237-22372-17-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/x86/kernel/acpi/wakeup_32.S |    2 +-
 arch/x86/kernel/vmlinux.lds.S    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index 8ded418..13ab720 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -1,4 +1,4 @@
-	.section .text.page_aligned
+	.section .text..page_aligned
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 8b6bb4e..f3d77d7 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -97,7 +97,7 @@ SECTIONS
 		HEAD_TEXT
 #ifdef CONFIG_X86_32
 		. = ALIGN(PAGE_SIZE);
-		*(.text.page_aligned)
+		*(.text..page_aligned)
 #endif
 		. = ALIGN(8);
 		_stext = .;
-- 
1.6.2.4

