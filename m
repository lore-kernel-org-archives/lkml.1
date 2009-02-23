Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbZBWUEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbZBWUEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbZBWUCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:02:22 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:54532 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893AbZBWUCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:02:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=tlQ1NRE5ISJVAVdx2KwEaqavwNOMl6H0t4tsqiR2QRGmOD5VIeZWpg4uzA0ggw5DlZ
         JThvSWoTt1+cmfJAubE9AWcWo47ZW9gXguhTGOjaYwfxUfFEDCjfG8gwochecasVXfN+
         Z6cDDal4sMP0qf0F1EI7r9nuR7xlsdDQRQeqQ=
Message-Id: <20090223200227.458712506@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 23 Feb 2009 22:57:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: heukelum@fastmail.fm, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 6/6] x86: efi_stub_32,64 - add missing ENDPROCs
References: <20090223195656.512422509@openvz.org>
Content-Disposition: inline; filename=x86-efi-stub
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/efi_stub_32.S |    1 +
 arch/x86/kernel/efi_stub_64.S |    7 +++++++
 2 files changed, 8 insertions(+)

Index: linux-2.6.git/arch/x86/kernel/efi_stub_32.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/efi_stub_32.S
+++ linux-2.6.git/arch/x86/kernel/efi_stub_32.S
@@ -113,6 +113,7 @@ ENTRY(efi_call_phys)
 	movl	(%edx), %ecx
 	pushl	%ecx
 	ret
+ENDPROC(efi_call_phys)
 .previous
 
 .data
Index: linux-2.6.git/arch/x86/kernel/efi_stub_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/efi_stub_64.S
+++ linux-2.6.git/arch/x86/kernel/efi_stub_64.S
@@ -41,6 +41,7 @@ ENTRY(efi_call0)
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
+ENDPROC(efi_call0)
 
 ENTRY(efi_call1)
 	SAVE_XMM
@@ -50,6 +51,7 @@ ENTRY(efi_call1)
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
+ENDPROC(efi_call1)
 
 ENTRY(efi_call2)
 	SAVE_XMM
@@ -59,6 +61,7 @@ ENTRY(efi_call2)
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
+ENDPROC(efi_call2)
 
 ENTRY(efi_call3)
 	SAVE_XMM
@@ -69,6 +72,7 @@ ENTRY(efi_call3)
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
+ENDPROC(efi_call3)
 
 ENTRY(efi_call4)
 	SAVE_XMM
@@ -80,6 +84,7 @@ ENTRY(efi_call4)
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
+ENDPROC(efi_call4)
 
 ENTRY(efi_call5)
 	SAVE_XMM
@@ -92,6 +97,7 @@ ENTRY(efi_call5)
 	addq $48, %rsp
 	RESTORE_XMM
 	ret
+ENDPROC(efi_call5)
 
 ENTRY(efi_call6)
 	SAVE_XMM
@@ -107,3 +113,4 @@ ENTRY(efi_call6)
 	addq $48, %rsp
 	RESTORE_XMM
 	ret
+ENDPROC(efi_call6)

