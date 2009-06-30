Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbZF3KyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbZF3KyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 06:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZF3KyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 06:54:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:39037 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752687AbZF3KyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 06:54:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19IoYYnsVRIEf3gIh1U8Ixlo8mjLKh5TW8h5NxLYI
	TEAHr4dGqn4mpQ
Subject: [patch] x86: fix arch/x86/lib/clear_page_64.S::clear_page_c
 annotation
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 12:54:00 +0200
Message-Id: <1246359240.6103.34.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: fix arch/x86/lib/clear_page_64.S::clear_page_c annotation.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
LKML-Reference: <new-submission>

---
 arch/x86/lib/clear_page_64.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/lib/clear_page_64.S
===================================================================
--- linux-2.6.orig/arch/x86/lib/clear_page_64.S
+++ linux-2.6/arch/x86/lib/clear_page_64.S
@@ -6,14 +6,14 @@
  * rdi	page
  */			
 	ALIGN
-clear_page_c:
+ENTRY(clear_page_c)
 	CFI_STARTPROC
 	movl $4096/8,%ecx
 	xorl %eax,%eax
 	rep stosq
 	ret
 	CFI_ENDPROC
-ENDPROC(clear_page)
+ENDPROC(clear_page_c)
 
 ENTRY(clear_page)
 	CFI_STARTPROC


