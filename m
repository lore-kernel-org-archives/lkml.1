Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbZFRIoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbZFRIoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 04:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZFRIoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 04:44:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:46671 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbZFRIoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 04:44:11 -0400
Subject: [PATCH 1/5 -tip] x86: asm/posix_types.h common for kernel and user
 space
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1245314365.31204.7.camel@ht.satnam>
References: <1245314365.31204.7.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 14:10:43 +0530
Message-Id: <1245314443.31204.9.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make asm/posix_types.h common for kernel and user space.

Also defined _ASM_X86_POSIX_TYPES_H

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/posix_types.h |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/posix_types.h b/arch/x86/include/asm/posix_types.h
index bb7133d..cb0a581 100644
--- a/arch/x86/include/asm/posix_types.h
+++ b/arch/x86/include/asm/posix_types.h
@@ -1,13 +1,10 @@
-#ifdef __KERNEL__
-# ifdef CONFIG_X86_32
+#ifndef _ASM_X86_POSIX_TYPES_H
+#define _ASM_X86_POSIX_TYPES_H
+
+# if defined(CONFIG_X86_32) || defined(__i386__)
 #  include "posix_types_32.h"
 # else
 #  include "posix_types_64.h"
 # endif
-#else
-# ifdef __i386__
-#  include "posix_types_32.h"
-# else
-#  include "posix_types_64.h"
-# endif
-#endif
+
+#endif /* _ASM_X86_POSIX_TYPES_H */
-- 
1.6.0.6



