Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab0BTAEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:04:33 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:46309 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab0BTAE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SbmZSr+YuTXLKVWxRSa21Mh+r0SKZ2kzdNB9o8jTBqJahn1hrR1hyhI0BgkaTkJG6J
         UiP8Zrrs2GCddQkT/5RieR77o9zMKMx+b+tN5zEyrk1pU4Fvy8theIw4hedjJXG67HPC
         Xx354vZLwxeAntaXxy7WCfAWxlSp3lPYlypzM=
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
Subject: [PATCH 06/24] Rename .bss.stack to .bss..stack.
Date: Sat, 20 Feb 2010 01:03:39 +0100
Message-Id: <1266624237-22372-7-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/frv/kernel/break.S       |    2 +-
 arch/frv/kernel/vmlinux.lds.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/frv/kernel/break.S b/arch/frv/kernel/break.S
index bd0bdf9..c5388b7 100644
--- a/arch/frv/kernel/break.S
+++ b/arch/frv/kernel/break.S
@@ -21,7 +21,7 @@
 #
 # the break handler has its own stack
 #
-	.section	.bss.stack
+	.section	.bss..stack
 	.globl		__break_user_context
 	.balign		THREAD_SIZE
 __break_stack:
diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index cbe811f..472eb8c 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -114,7 +114,7 @@ SECTIONS
 
   .sbss		: { *(.sbss .sbss.*) }
   .bss		: { *(.bss .bss.*) }
-  .bss.stack	: { *(.bss) }
+  .bss..stack	: { *(.bss) }
 
   __bss_stop = .;
   _end = . ;
-- 
1.6.2.4

