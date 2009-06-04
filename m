Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbZFDMnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbZFDMnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbZFDMnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:43:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:49830 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221AbZFDMnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:43:08 -0400
Subject: [PATCH 6/6] headers_check fix: mn10300, setup.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, yasutake.koichi@jp.panasonic.com,
       linux-am33-list@redhat.com
In-Reply-To: <1244119039.5172.39.camel@ht.satnam>
References: <1244118232.5172.26.camel@ht.satnam>
	 <1244118476.5172.29.camel@ht.satnam>  <1244118599.5172.31.camel@ht.satnam>
	 <1244118714.5172.33.camel@ht.satnam>  <1244118949.5172.37.camel@ht.satnam>
	 <1244119039.5172.39.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 18:08:18 +0530
Message-Id: <1244119098.5172.40.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make headers_check' warnings:

  usr/include/asm-mn10300/setup.h:14: extern's make no sense in userspace
  usr/include/asm-mn10300/setup.h:15: extern's make no sense in userspace

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/mn10300/include/asm/setup.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/mn10300/include/asm/setup.h b/arch/mn10300/include/asm/setup.h
index 08356c8..c229d1e 100644
--- a/arch/mn10300/include/asm/setup.h
+++ b/arch/mn10300/include/asm/setup.h
@@ -11,7 +11,8 @@
 #ifndef _ASM_SETUP_H
 #define _ASM_SETUP_H
 
+#ifdef __KERNEL__
 extern void __init unit_setup(void);
 extern void __init unit_init_IRQ(void);
-
+#endif
 #endif /* _ASM_SETUP_H */
-- 
1.6.0.6



