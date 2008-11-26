Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYKZIsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYKZIsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYKZIms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:42:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:9241 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbYKZImr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:42:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:from:date:message-id;
        b=qe7sTv3MrTe2Z1Mm+8C5MnqHatz3P8jOlZC32triYdORX4BnAoZa87F6hOeC0WKzRA
         3aiy9+pRbBSCuLRo38LO+v6a9PWN4cruTUUktYn4UTIzC6PuXaaEmjniXQof1JiPLaQO
         aSvM4impUDf4ENXl7IN98bi6Gk9mxPp0MZ8ho=
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: [patch 18/24] perfmon: X86 x86-64 32-bit syscall entries (x86)
From: eranian@googlemail.com
Date: Wed, 26 Nov 2008 00:42:45 -0800 (PST)
Message-ID: <492d0c05.170d660a.15ab.5657@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs adds the 32-bit perfmon system calls on x86-64 host kernel.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/arch/x86/ia32/ia32entry.S
===================================================================
--- o3.orig/arch/x86/ia32/ia32entry.S	2008-11-03 10:46:42.000000000 +0100
+++ o3/arch/x86/ia32/ia32entry.S	2008-11-03 11:18:03.000000000 +0100
@@ -826,4 +826,9 @@
 	.quad sys_dup3			/* 330 */
 	.quad sys_pipe2
 	.quad sys_inotify_init1
+	.quad sys_pfm_create
+	.quad sys_pfm_write
+	.quad sys_pfm_read		/* 335 */
+	.quad sys_pfm_attach
+	.quad sys_pfm_set_state
 ia32_syscall_end:

-- 

