Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbZFTP5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbZFTP5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 11:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZFTP5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 11:57:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:37154 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916AbZFTP5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 11:57:24 -0400
Date: Sat, 20 Jun 2009 15:55:59 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, jaswinderrajput@gmail.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1245494740.8613.12.camel@localhost.localdomain>
References: <1245494740.8613.12.camel@localhost.localdomain>
Subject: [tip:x86/cleanups] x86: ds.c fix invalid assignment
Message-ID: <tip-feaa0457ec8351cae855edc9a3052ac49322538e@git.kernel.org>
Git-Commit-ID: feaa0457ec8351cae855edc9a3052ac49322538e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 20 Jun 2009 15:56:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  feaa0457ec8351cae855edc9a3052ac49322538e
Gitweb:     http://git.kernel.org/tip/feaa0457ec8351cae855edc9a3052ac49322538e
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 20 Jun 2009 16:15:40 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 20 Jun 2009 17:53:13 +0200

x86: ds.c fix invalid assignment

Fixes the type mixups that cause the following sparse warnings:

  CHECK   arch/x86/kernel/ds.c
arch/x86/kernel/ds.c:549:19: warning: incorrect type in argument 2 (invalid types)
arch/x86/kernel/ds.c:549:19:    expected bad type enum bts_field field
arch/x86/kernel/ds.c:549:19:    got int
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:520:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:520:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:520:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:520:7: error: invalid assignment
arch/x86/kernel/ds.c:520:35: error: incompatible types for operation (*)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Markus Metzger <markus.t.metzger@intel.com>
LKML-Reference: <1245494740.8613.12.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 48bfe13..ef42a03 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -509,15 +509,15 @@ enum bts_field {
 	bts_escape		= ((unsigned long)-1 & ~bts_qual_mask)
 };
 
-static inline unsigned long bts_get(const char *base, enum bts_field field)
+static inline unsigned long bts_get(const char *base, unsigned long field)
 {
 	base += (ds_cfg.sizeof_ptr_field * field);
 	return *(unsigned long *)base;
 }
 
-static inline void bts_set(char *base, enum bts_field field, unsigned long val)
+static inline void bts_set(char *base, unsigned long field, unsigned long val)
 {
-	base += (ds_cfg.sizeof_ptr_field * field);;
+	base += (ds_cfg.sizeof_ptr_field * field);
 	(*(unsigned long *)base) = val;
 }
 
