Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbXLTMDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbXLTMDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760960AbXLTMAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:00:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760717AbXLTMAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 37/43] x86 CORE_DUMP_USE_REGSET
Message-Id: <20071220120005.DE21526F98E@magilla.localdomain>
Date: Thu, 20 Dec 2007 04:00:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches x86 to the user_regset-based code for ELF core dumps.
The core dumps come out exactly the same as before.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-x86/elf.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/elf.h b/include/asm-x86/elf.h
index 5e5705b..123e2d5 100644
--- a/include/asm-x86/elf.h
+++ b/include/asm-x86/elf.h
@@ -201,6 +201,7 @@ extern int vdso_enabled;
 
 #endif /* !CONFIG_X86_32 */
 
+#define CORE_DUMP_USE_REGSET
 #define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	4096
 
-- 
1.5.3.6

