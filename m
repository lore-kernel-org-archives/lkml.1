Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbXEBEaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbXEBEaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbXEBE3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:29:47 -0400
Received: from smtp-out.google.com ([216.239.45.13]:25212 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992715AbXEBE3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:29:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=c9w3iuZa1/lXWs9zd3a45lvtlvxIDEQkaEHZuT2ctB0n05LwcL+S7QI2fMUQEBQ8X
	tOFsf5sJN6lJpBm6yAZyg==
Date: Tue, 1 May 2007 21:28:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [patch 05/10] frv: gdb: use __attribute_unused__
In-Reply-To: <Pine.LNX.4.64.0705012120470.19277@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705012121350.19277@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012120130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012120470.19277@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace function instances of __attribute__((unused)) with
__attribute_unused__ to suppress warnings.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/frv/kernel/gdb-stub.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/frv/kernel/gdb-stub.c b/arch/frv/kernel/gdb-stub.c
--- a/arch/frv/kernel/gdb-stub.c
+++ b/arch/frv/kernel/gdb-stub.c
@@ -1195,7 +1195,7 @@ static void gdbstub_check_breakpoint(void)
 /*
  *
  */
-static void __attribute__((unused)) gdbstub_show_regs(void)
+static void __attribute_unused__ gdbstub_show_regs(void)
 {
 	unsigned long *reg;
 	int loop;
@@ -1223,7 +1223,7 @@ static void __attribute__((unused)) gdbstub_show_regs(void)
 /*
  * dump debugging regs
  */
-static void __attribute__((unused)) gdbstub_dump_debugregs(void)
+static void __attribute_unused__ gdbstub_dump_debugregs(void)
 {
 	gdbstub_printk("DCR    %08lx  ", __debug_status.dcr);
 	gdbstub_printk("BRR    %08lx\n", __debug_status.brr);
@@ -2079,25 +2079,25 @@ void gdbstub_exit(int status)
  * GDB wants to call malloc() and free() to allocate memory for calling kernel
  * functions directly from its command line
  */
-static void *malloc(size_t size) __attribute__((unused));
+static void *malloc(size_t size) __attribute_unused__;
 static void *malloc(size_t size)
 {
 	return kmalloc(size, GFP_ATOMIC);
 }
 
-static void free(void *p) __attribute__((unused));
+static void free(void *p) __attribute_unused__;
 static void free(void *p)
 {
 	kfree(p);
 }
 
-static uint32_t ___get_HSR0(void) __attribute__((unused));
+static uint32_t ___get_HSR0(void) __attribute_unused__;
 static uint32_t ___get_HSR0(void)
 {
 	return __get_HSR(0);
 }
 
-static uint32_t ___set_HSR0(uint32_t x) __attribute__((unused));
+static uint32_t ___set_HSR0(uint32_t x) __attribute_unused__;
 static uint32_t ___set_HSR0(uint32_t x)
 {
 	__set_HSR(0, x);
