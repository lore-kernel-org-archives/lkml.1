Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYKYVmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYKYVmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbYKYVgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:36:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:62506 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbYKYVgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:36:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=FqQBoywxb4tBjzRnWCua78brN2st79BUgmlak9ZxEUDw3pCieftcdAAcl8lOTMtm2Y
         YhsFFpkBiwseeYmnEjG8Na/pUhgJ+d9qIphTm0mUlm1r+XZIRfXuvNPREQMWbDBqceCg
         zj9C/qBZSzrXbgQryu2KIyzyF8upfmBxTL1kM=
To: linux-kernel@vger.kernel.org
Subject: [patch 18/24] perfmon: X86 x86-64 32-bit syscall entries (x86)
From: eranian@googlemail.com
Date: Tue, 25 Nov 2008 13:36:34 -0800 (PST)
Message-ID: <492c6fe2.15185e0a.156e.196a@mx.google.com>
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

