Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZDLPIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZDLPIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 11:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZDLPIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 11:08:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:48755 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbZDLPIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 11:08:01 -0400
Subject: [PATCH -tip] x86: vdso/vma.c declare vdso_enabled and
 arch_setup_additional_pages before they get used
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 12 Apr 2009 20:37:25 +0530
Message-Id: <1239548845.4170.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, address sparse warnings

Addresses the problem pointed out by these sparse warning:
  arch/x86/vdso/vma.c:19:28: warning: symbol 'vdso_enabled' was not declared. Should it be static?
  arch/x86/vdso/vma.c:101:5: warning: symbol 'arch_setup_additional_pages' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/vdso/vma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 7133cdf..cac0833 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -8,6 +8,7 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/random.h>
+#include <linux/elf.h>
 #include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
-- 
1.6.0.6



