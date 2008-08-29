Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbYH2GQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbYH2GQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYH2GP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:15:29 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59510 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbYH2GP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:27 -0400
Date: Thu, 28 Aug 2008 23:47:41 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5lfP7016122@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5 7/29] mdb: add mdb.h architecure main include
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add mdb.h architecure main include


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/debug/mdb/mdb.h	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb/mdb.h	2008-08-28 14:20:04.000000000 -0600
@@ -0,0 +1,54 @@
+
+/***************************************************************************
+*
+*   Copyright (c) 2008 Jeff V. Merkey  All Rights Reserved.
+*   1058 East 50 South
+*   Lindon, Utah 84042
+*   jmerkey@wolfmountaingroup.com
+*
+*   This program is free software; you can redistribute it and/or modify it
+*   under the terms of the GNU General Public License as published by the
+*   Free Software Foundation, version 2.
+*
+*   This program is distributed in the hope that it will be useful, but
+*   WITHOUT ANY WARRANTY; without even the implied warranty of
+*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+*   General Public License for more details.
+*
+*   You are free to modify and re-distribute this program in accordance
+*   with the terms specified in the GNU Public License.  The copyright
+*   contained in this code is required to be present in any derivative
+*   works and you are required to provide the source code for this
+*   program as part of any commercial or non-commercial distribution.
+*   You are required to respect the rights of the Copyright holders
+*   named within this code.
+*
+*   jmerkey@wolfmountaingroup.com is the official maintainer of
+*   this code.  You are encouraged to report any bugs, problems, fixes,
+*   suggestions, and comments about this software.
+*
+*   AUTHOR   :  Jeff V. Merkey
+*   DESCRIP  :  Merkey's Linux Debugger
+*
+***************************************************************************/
+
+#ifndef _MDB_H
+#define _MDB_H
+
+/* screen output function */
+extern int mdb_printf(char *s, ...);
+#define DBGPrint   mdb_printf
+
+/* external entry points used by linux */
+#define DEBUGGER_EXCEPTION        1
+#define NMI_EXCEPTION             2
+#define BREAKPOINT_EXCEPTION      3
+#define GENERAL_PROTECTION       13
+#define PAGE_FAULT_EXCEPTION     14
+#define KEYBOARD_ENTRY           19
+#define SOFTWARE_EXCEPTION       22
+
+/* internal trace messages */
+#define MDB_DEBUG_DEBUGGER       0
+
+#endif
