Return-Path: <linux-kernel-owner+w=401wt.eu-S1752129AbXLERzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbXLERzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbXLERxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:53:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbXLERxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:53:33 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 6/9] remove unused macro
Date: Wed,  5 Dec 2007 13:08:30 -0200
Message-Id: <1196867342420-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11968673383347-git-send-email-gcosta@redhat.com>
References: 20071204204931.GC32018@elte.hu <1196867313972-git-send-email-gcosta@redhat.com> <1196867319253-git-send-email-gcosta@redhat.com> <11968673241599-git-send-email-gcosta@redhat.com> <11968673291072-git-send-email-gcosta@redhat.com> <1196867333728-git-send-email-gcosta@redhat.com> <11968673383347-git-send-email-gcosta@redhat.com>
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
index 2757258..621e0b8 100644
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

