Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbXFFJjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbXFFJjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXFFJjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:39:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48342 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbXFFJjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:39:44 -0400
Subject: [PATCH] frv: build fix
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 11:39:40 +0200
Message-Id: <1181122780.7348.192.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In file included from /usr/src/linux-2.6-2/net/ipv4/ip_input.c:118:
include2/asm/system.h:245: error: parse error before "__cmpxchg_32"
include2/asm/system.h:245: error: parse error before '*' token
include2/asm/system.h:245: warning: type defaults to `int' in declaration of `__cmpxchg_32'
include2/asm/system.h:245: warning: function declaration isn't a prototype
include2/asm/system.h:245: warning: data definition has no type or storage class


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/include/asm-frv/system.h b/include/asm-frv/system.h
index be303b3..6931af5 100644
--- a/include/asm-frv/system.h
+++ b/include/asm-frv/system.h
@@ -12,6 +12,7 @@
 #ifndef _ASM_SYSTEM_H
 #define _ASM_SYSTEM_H
 
+#include <linux/types.h>
 #include <linux/linkage.h>
 
 struct thread_struct;


