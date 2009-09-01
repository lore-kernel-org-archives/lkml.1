Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZIAN7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZIAN7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbZIAN7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:59:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:56045 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805AbZIAN7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:59:01 -0400
Date: Tue, 1 Sep 2009 13:58:07 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: mingo@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, ehrhardt@linux.vnet.ibm.com, arnd@arndb.de,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
       zippel@linux-m68k.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com, paulus@samba.org, horsth@linux.vnet.ibm.com,
       davem@davemloft.net, benh@kernel.crashing.org, geert@linux-m68k.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, nickpiggin@yahoo.com.au
Reply-To: mingo@redhat.com, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
       ehrhardt@linux.vnet.ibm.com, arnd@arndb.de, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       horsth@linux.vnet.ibm.com, davem@davemloft.net,
       benh@kernel.crashing.org, geert@linux-m68k.org,
       linux-arch@vger.kernel.org, nickpiggin@yahoo.com.au, mingo@elte.hu
In-Reply-To: <20090831124416.998821502@de.ibm.com>
References: <20090831124416.998821502@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking, m68k/asm-offsets: Rename signal defines
Message-ID: <tip-96910b6dc8a4fdb75e69f09f47b62d41743d36ba@git.kernel.org>
Git-Commit-ID: 96910b6dc8a4fdb75e69f09f47b62d41743d36ba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 01 Sep 2009 13:58:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96910b6dc8a4fdb75e69f09f47b62d41743d36ba
Gitweb:     http://git.kernel.org/tip/96910b6dc8a4fdb75e69f09f47b62d41743d36ba
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Mon, 31 Aug 2009 14:43:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Sep 2009 09:38:03 +0200

locking, m68k/asm-offsets: Rename signal defines

In order to be able to use asm-offsets.h in C files the
existing namespace conflicts must be solved first. In
asm-offsets.h there are defines for signal constants, so they
can be used in assembler files.

Unfortunately the existing defines use a 1:1 mapping for the
macro names which results in name space conflicts if the header
file would also be used in C files. So rename the created
defines and add an "L" prefix to each one since that has
already been done for the SIGTRAP define in entry_mm.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Horst Hartmann <horsth@linux.vnet.ibm.com>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: <linux-arch@vger.kernel.org>
LKML-Reference: <20090831124416.998821502@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/m68k/include/asm/entry_mm.h |    1 -
 arch/m68k/kernel/asm-offsets.c   |    8 ++++----
 arch/m68k/math-emu/fp_entry.S    |    8 ++++----
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/m68k/include/asm/entry_mm.h b/arch/m68k/include/asm/entry_mm.h
index 4fcfc28..4741258 100644
--- a/arch/m68k/include/asm/entry_mm.h
+++ b/arch/m68k/include/asm/entry_mm.h
@@ -46,7 +46,6 @@
 #define curptr a2
 
 LFLUSH_I_AND_D = 0x00000808
-LSIGTRAP = 5
 
 /* process bits for task_struct.ptrace */
 PT_TRACESYS_OFF = 3
diff --git a/arch/m68k/kernel/asm-offsets.c b/arch/m68k/kernel/asm-offsets.c
index 25d6b72..73e5e58 100644
--- a/arch/m68k/kernel/asm-offsets.c
+++ b/arch/m68k/kernel/asm-offsets.c
@@ -89,10 +89,10 @@ int main(void)
 	DEFINE(FONT_DESC_PREF, offsetof(struct font_desc, pref));
 
 	/* signal defines */
-	DEFINE(SIGSEGV, SIGSEGV);
-	DEFINE(SEGV_MAPERR, SEGV_MAPERR);
-	DEFINE(SIGTRAP, SIGTRAP);
-	DEFINE(TRAP_TRACE, TRAP_TRACE);
+	DEFINE(LSIGSEGV, SIGSEGV);
+	DEFINE(LSEGV_MAPERR, SEGV_MAPERR);
+	DEFINE(LSIGTRAP, SIGTRAP);
+	DEFINE(LTRAP_TRACE, TRAP_TRACE);
 
 	/* offsets into the custom struct */
 	DEFINE(CUSTOMBASE, &amiga_custom);
diff --git a/arch/m68k/math-emu/fp_entry.S b/arch/m68k/math-emu/fp_entry.S
index 916c6f3..a3fe1f3 100644
--- a/arch/m68k/math-emu/fp_entry.S
+++ b/arch/m68k/math-emu/fp_entry.S
@@ -85,8 +85,8 @@ fp_err_ua2:
 fp_err_ua1:
 	addq.l	#4,%sp
 	move.l	%a0,-(%sp)
-	pea	SEGV_MAPERR
-	pea	SIGSEGV
+	pea	LSEGV_MAPERR
+	pea	LSIGSEGV
 	jsr	fpemu_signal
 	add.w	#12,%sp
 	jra	ret_from_exception
@@ -96,8 +96,8 @@ fp_err_ua1:
 	| it does not really belong here, but...
 fp_sendtrace060:
 	move.l	(FPS_PC,%sp),-(%sp)
-	pea	TRAP_TRACE
-	pea	SIGTRAP
+	pea	LTRAP_TRACE
+	pea	LSIGTRAP
 	jsr	fpemu_signal
 	add.w	#12,%sp
 	jra	ret_from_exception
