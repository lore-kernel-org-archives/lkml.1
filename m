Return-Path: <linux-kernel-owner+w=401wt.eu-S934240AbZD3R4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240AbZD3R4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933124AbZD3RcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:32:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:53647 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933158AbZD3RcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:32:24 -0400
Date: Thu, 30 Apr 2009 17:30:33 GMT
From: tip-bot for Remis Lima Baima <remis.developer@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, hpa@zytor.com,
       mingo@redhat.com, remis.developer@googlemail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       remis.developer@googlemail.com, mingo@elte.hu
In-Reply-To: <200904301836.23885.arnd@arndb.de>
References: <200904301836.23885.arnd@arndb.de>
Subject: [tip:x86/cleanups] x86: added 'ifndef _ASM_X86_IOMAP_H' to iomap.h
Message-ID: <tip-bf293c17b26b8854241df08b9b63f7270cbde012@git.kernel.org>
Git-Commit-ID: bf293c17b26b8854241df08b9b63f7270cbde012
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 17:30:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf293c17b26b8854241df08b9b63f7270cbde012
Gitweb:     http://git.kernel.org/tip/bf293c17b26b8854241df08b9b63f7270cbde012
Author:     Remis Lima Baima <remis.developer@googlemail.com>
AuthorDate: Thu, 30 Apr 2009 18:36:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 30 Apr 2009 19:26:11 +0200

x86: added 'ifndef _ASM_X86_IOMAP_H' to iomap.h

iomap.h misses the include guards.

[ Impact: cleanup ]

Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
LKML-Reference: <200904301836.23885.arnd@arndb.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/iomap.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/iomap.h b/arch/x86/include/asm/iomap.h
index 86af260..0e9fe1d 100644
--- a/arch/x86/include/asm/iomap.h
+++ b/arch/x86/include/asm/iomap.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_X86_IOMAP_H
+#define _ASM_X86_IOMAP_H
+
 /*
  * Copyright © 2008 Ingo Molnar
  *
@@ -31,3 +34,5 @@ iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
 
 void
 iounmap_atomic(void *kvaddr, enum km_type type);
+
+#endif /* _ASM_X86_IOMAP_H */
