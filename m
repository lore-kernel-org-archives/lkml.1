Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbXLDSxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbXLDSxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbXLDSvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:51:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbXLDSvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:51:43 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 5/8] remove unused macro
Date: Tue,  4 Dec 2007 14:06:25 -0200
Message-Id: <11967844123402-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11967844071346-git-send-email-gcosta@redhat.com>
References: <11967843881946-git-send-email-gcosta@redhat.com> <11967843943958-git-send-email-gcosta@redhat.com> <11967843983411-git-send-email-gcosta@redhat.com> <11967844032081-git-send-email-gcosta@redhat.com> <11967844071346-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mr. Grep says warn_if_not_ulong() is not used anymore anywhere
in the code. So, we remove it.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/system_64.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/system_64.h b/include/asm-x86/system_64.h
index 3da8ec2..bb058ad 100644
--- a/include/asm-x86/system_64.h
+++ b/include/asm-x86/system_64.h
@@ -66,8 +66,6 @@
 #define read_barrier_depends()	do {} while(0)
 #define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
 
-#define warn_if_not_ulong(x) do { unsigned long foo; (void) (&(x) == &foo); } while (0)
-
 #include <linux/irqflags.h>
 
 #endif
-- 
1.4.4.2

