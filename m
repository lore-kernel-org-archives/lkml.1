Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbYJQPLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbYJQPLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbYJQPF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:05:56 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:60658 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbYJQPFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:05:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=ktYn6d49v6+3ELGS0sK+f6Tb1vc6hmzMHBb9LdNScgiZDHGfN9+CoqF3A7rFAEj44t
         jKsb390x/dyVU7RVgOrnqOIfoz0eFLLm9vuRa17M25Q1IfmaqWwVU4eXkchBS+BltnWB
         HBpS5tnwIsRqOOhpf3rhmBMUNU0VZ6619Q4Nw=
To: linux-kernel@vger.kernel.org
Subject: [patch 18/24] perfmon3:  X86 x86-64 32-bit syscall entries
From: eranian@googlemail.com
Date: Fri, 17 Oct 2008 08:05:53 -0700 (PDT)
Message-ID: <48f8a9d1.0d135e0a.6e31.2184@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs adds the 32-bit perfmon system calls on x86-64 host kernel.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/arch/x86/ia32/ia32entry.S
===================================================================
--- o3.orig/arch/x86/ia32/ia32entry.S	2008-10-10 11:06:59.000000000 +0200
+++ o3/arch/x86/ia32/ia32entry.S	2008-10-10 11:32:20.000000000 +0200
@@ -832,4 +832,9 @@
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

