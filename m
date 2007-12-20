Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbXLTUMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbXLTUMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbXLTUK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:10:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758600AbXLTUK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:10:56 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 11/15] cleanup CLI_STRING, STI_STRING and friends
Date: Thu, 20 Dec 2007 18:04:06 -0200
Message-Id: <11981813384090-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981813292926-git-send-email-gcosta@redhat.com>
References: <11981810504172-git-send-email-gcosta@redhat.com> <11981811293763-git-send-email-gcosta@redhat.com> <11981811852758-git-send-email-gcosta@redhat.com> <11981812041672-git-send-email-gcosta@redhat.com> <1198181215625-git-send-email-gcosta@redhat.com> <1198181224677-git-send-email-gcosta@redhat.com> <11981812412879-git-send-email-gcosta@redhat.com> <11981812771615-git-send-email-gcosta@redhat.com> <1198181309285-git-send-email-gcosta@redhat.com> <11981813192341-git-send-email-gcosta@redhat.com> <11981813292926-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the advent of ticket locking, CLI_STRING, STI_STRING, and friends
are not used anymore. They can now be safely deleted.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/spinlock.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

Index: linux-2.6-x86/include/asm-x86/spinlock.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/spinlock.h	2007-12-20 19:06:59.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/spinlock.h	2007-12-20 19:08:09.000000000 -0800
@@ -19,15 +19,6 @@
  * (the type definitions are in asm/spinlock_types.h)
  */
 
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define CLI_STRING	"cli"
-#define STI_STRING	"sti"
-#define CLI_STI_CLOBBERS
-#define CLI_STI_INPUT_ARGS
-#endif /* CONFIG_PARAVIRT */
-
 #ifdef CONFIG_X86_32
 typedef char _slock_t;
 # define LOCK_INS_DEC "decb"
