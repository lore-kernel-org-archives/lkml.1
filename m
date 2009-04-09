Return-Path: <linux-kernel-owner+w=401wt.eu-S932516AbZDIMyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbZDIMyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761547AbZDIMyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:54:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:45763 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760909AbZDIMyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:54:39 -0400
Subject: [PATCH -tip] x86: process.c declare sys_fork and sys_vfork before
 they get used
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 18:24:19 +0530
Message-Id: <1239281659.11859.21.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix sparse warnings:
  arch/x86/kernel/process.c:230:5: warning: symbol 'sys_fork' was not declared. Should it be static?
  arch/x86/kernel/process.c:245:5: warning: symbol 'sys_vfork' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/process.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1d71442..4d397ce 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -15,6 +15,7 @@
 #include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/ds.h>
+#include <asm/syscalls.h>		/* sys_fork, sys_vfork */
 
 unsigned long idle_halt;
 EXPORT_SYMBOL(idle_halt);
-- 
1.6.0.6



