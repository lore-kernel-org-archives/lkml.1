Return-Path: <linux-kernel-owner+w=401wt.eu-S1758439AbZFRRtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbZFRRtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZFRRsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:48:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:52277 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000AbZFRRsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:48:50 -0400
Subject: [PATCH 2/4 -tip V2] x86: asm/unistd.h common for kernel and user
 space
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <1245347082.2481.12.camel@ht.satnam>
References: <1245314365.31204.7.camel@ht.satnam>
	 <1245346986.2481.10.camel@ht.satnam>  <1245347082.2481.12.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 23:15:18 +0530
Message-Id: <1245347118.2481.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make asm/unistd.h common for kernel and user space.

Also defined _ASM_X86_UNISTD_H

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/unistd.h |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index 2a58ed3..0de8cb3 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -1,13 +1,10 @@
-#ifdef __KERNEL__
-# ifdef CONFIG_X86_32
+#ifndef _ASM_X86_UNISTD_H
+#define _ASM_X86_UNISTD_H
+
+# if defined(CONFIG_X86_32) || defined(__i386__)
 #  include "unistd_32.h"
 # else
 #  include "unistd_64.h"
 # endif
-#else
-# ifdef __i386__
-#  include "unistd_32.h"
-# else
-#  include "unistd_64.h"
-# endif
-#endif
+
+#endif /* _ASM_X86_UNISTD_H */
-- 
1.6.0.6



