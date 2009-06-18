Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbZFRIpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbZFRIpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 04:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbZFRIoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 04:44:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:46684 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbZFRIob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 04:44:31 -0400
Subject: [PATCH 3/5 -tip] x86: asm/unistd.h common for kernel and user space
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1245314484.31204.10.camel@ht.satnam>
References: <1245314365.31204.7.camel@ht.satnam>
	 <1245314443.31204.9.camel@ht.satnam>  <1245314484.31204.10.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 14:11:59 +0530
Message-Id: <1245314519.31204.11.camel@ht.satnam>
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



