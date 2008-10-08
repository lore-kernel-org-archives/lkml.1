Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYJHTBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYJHTBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYJHTAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:00:54 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:12938 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYJHTAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:00:54 -0400
Message-ID: <48ED032F.4020304@oracle.com>
Date: Wed, 08 Oct 2008 11:59:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
CC: andi@firstfloor.org
Subject: [PATCH -mm] taint: fix kernel-doc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Move print_tainted() kernel-doc to avoid the following error:

Error(/var/linsrc/mmotm-2008-1002-1617//kernel/panic.c:155): cannot understand prototype: 'struct tnt '

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andi Kleen <andi@firstfloor.org>
---
 kernel/panic.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- mmotm-2008-1002-1617.orig/kernel/panic.c
+++ mmotm-2008-1002-1617/kernel/panic.c
@@ -136,21 +136,6 @@ NORET_TYPE void panic(const char * fmt, 
 
 EXPORT_SYMBOL(panic);
 
-/**
- *	print_tainted - return a string to represent the kernel taint state.
- *
- *  'P' - Proprietary module has been loaded.
- *  'F' - Module has been forcibly loaded.
- *  'S' - SMP with CPUs not designed for SMP.
- *  'R' - User forced a module unload.
- *  'M' - System experienced a machine check exception.
- *  'B' - System has hit bad_page.
- *  'U' - Userspace-defined naughtiness.
- *  'A' - ACPI table overridden.
- *  'W' - Taint on warning.
- *
- *	The string is overwritten by the next call to print_taint().
- */
 
 struct tnt {
 	u8 bit;
@@ -171,6 +156,21 @@ static const struct tnt tnts[] = {
 	{ TAINT_WARN, 'W', ' ' },
 };
 
+/**
+ *	print_tainted - return a string to represent the kernel taint state.
+ *
+ *  'P' - Proprietary module has been loaded.
+ *  'F' - Module has been forcibly loaded.
+ *  'S' - SMP with CPUs not designed for SMP.
+ *  'R' - User forced a module unload.
+ *  'M' - System experienced a machine check exception.
+ *  'B' - System has hit bad_page.
+ *  'U' - Userspace-defined naughtiness.
+ *  'A' - ACPI table overridden.
+ *  'W' - Taint on warning.
+ *
+ *	The string is overwritten by the next call to print_taint().
+ */
 const char *print_tainted(void)
 {
 	static char buf[ARRAY_SIZE(tnts) + sizeof("Tainted: ") + 1];
