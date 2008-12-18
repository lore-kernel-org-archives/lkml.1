Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752124AbYLRRSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbYLRRSu (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYLRRSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:18:37 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:23415 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYLRRSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:18:36 -0500
Message-ID: <494A85EB.9010505@ct.jp.nec.com>
Date: Thu, 18 Dec 2008 09:18:35 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: sigframe.h: add guard macro
References: <4949B9B5.2050701@ct.jp.nec.com> <20081218102934.GC10513@elte.hu>
In-Reply-To: <20081218102934.GC10513@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Add missing guard macro _ASM_X86_SIGFRAME_H.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
I forgot include guard:)

 arch/x86/include/asm/sigframe.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/sigframe.h b/arch/x86/include/asm/sigframe.h
index 491a087..3bd0f42 100644
--- a/arch/x86/include/asm/sigframe.h
+++ b/arch/x86/include/asm/sigframe.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_X86_SIGFRAME_H
+#define _ASM_X86_SIGFRAME_H
+
 #ifdef CONFIG_X86_32
 #define sigframe_ia32		sigframe
 #define rt_sigframe_ia32	rt_sigframe
@@ -59,3 +62,5 @@ struct rt_sigframe {
 	/* fp state follows here */
 };
 #endif /* CONFIG_X86_64 */
+
+#endif /* _ASM_X86_SIGFRAME_H */
-- 
1.6.0.4

