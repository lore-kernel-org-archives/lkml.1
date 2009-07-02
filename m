Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZGBF13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZGBF13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbZGBF1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:27:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:54601 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750713AbZGBF1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:27:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Z99VG4bEZ/9sP7djcICeg9yFF3v+Cbkok8z2L+t
	8hv4he6UXUV05W
Subject: [patch] x86: add missing annotation to
 arch/x86/lib/copy_user_64.S::copy_to_user
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 07:27:20 +0200
Message-Id: <1246512440.13293.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


x86: add missing annotation to arch/x86/lib/copy_user_64.S::copy_to_user

While examining symbol generation in perf_counter tools, I noticed that
copy_to_user() had no size in vmlinux's symtab.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <new-submission>

---
 arch/x86/lib/copy_user_64.S |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/arch/x86/lib/copy_user_64.S
===================================================================
--- linux-2.6.orig/arch/x86/lib/copy_user_64.S
+++ linux-2.6/arch/x86/lib/copy_user_64.S
@@ -75,6 +75,7 @@ ENTRY(copy_to_user)
 	jae bad_to_user
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
+ENDPROC(copy_to_user)
 
 /* Standard copy_from_user with segment limit checking */
 ENTRY(copy_from_user)


