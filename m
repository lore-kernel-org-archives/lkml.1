Return-Path: <linux-kernel-owner+w=401wt.eu-S1764722AbYEFJFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764722AbYEFJFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764018AbYEFJBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:01:45 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45538 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764310AbYEFJBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:01:42 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix vdso_enabled type on x86_64
Date: Tue, 06 May 2008 18:01:35 +0900
Message-ID: <871w4fst5c.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes type of "vdso_enabled" on X86_64 to match extern in asm/elf.h.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 arch/x86/vdso/vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/vdso/vma.c~fix-vdso_enabled arch/x86/vdso/vma.c
--- linux-2.6/arch/x86/vdso/vma.c~fix-vdso_enabled	2008-05-06 16:47:14.000000000 +0900
+++ linux-2.6-hirofumi/arch/x86/vdso/vma.c	2008-05-06 16:47:20.000000000 +0900
@@ -16,7 +16,7 @@
 #include "vextern.h"		/* Just for VMAGIC.  */
 #undef VEXTERN
 
-int vdso_enabled = 1;
+unsigned int __read_mostly vdso_enabled = 1;
 
 extern char vdso_start[], vdso_end[];
 extern unsigned short vdso_sync_cpuid;
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
