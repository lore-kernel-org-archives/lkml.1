Return-Path: <linux-kernel-owner+w=401wt.eu-S1763070AbYHEHLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763070AbYHEHLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758911AbYHEGr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:47:57 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44147 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbYHEGrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:47:24 -0400
Date: Tue, 5 Aug 2008 00:26:36 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808050626.m756QaCH003781@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc1-git5 21/26] mdb: add minimal mdb.h file for arch stuff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralized external definitions into include files and corrected 
the file to conform to Linux coding practices.  fixed word wrap
problems with patches.

add just a minimal mdb.h file for arch code that calls the mdb core.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/include/linux/mdb.h	1969-12-31 17:00:00.000000000 -0700
+++ b/include/linux/mdb.h	2008-08-04 16:05:47.000000000 -0600
@@ -0,0 +1,49 @@
+
+/***************************************************************************
+*
+*   Copyright (c) 1997, 2008 Jeff V. Merkey  All Rights Reserved.
+*   1058 East 50 South
+*   Lindon, Utah  84042
+*   jmerkey@wolfmountaingroup.com
+*
+*   This program is free software; you can redistribute it and/or modify it
+*   under the terms of the GNU General Public License as published by the
+*   Free Software Foundation, version 2, or any later version.
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
+*   jmerkey@utah-nac.org is the official maintainer of
+*   this code.  You are encouraged to report any bugs, problems, fixes,
+*   suggestions, and comments about this software to jmerkey@utah-nac.org
+*   or linux-kernel@vger.kernel.org.  New releases, patches, bug fixes, and
+*   technical documentation can be found at www.kernel.org.  I will
+*   periodically post new releases of this software to www.kernel.org
+*   that contain bug fixes and enhanced capabilities.
+*
+*
+*   AUTHOR   :  Jeff V. Merkey
+*   DESCRIP  :  Merkey's NetWare Debugger
+*
+***************************************************************************/
+
+#define DEBUGGER_EXCEPTION        1
+#define NMI_EXCEPTION             2
+#define BREAKPOINT_EXCEPTION      3
+#define KEYBOARD_ENTRY           19
+#define SOFTWARE_EXCEPTION       22
+
+extern atomic_t inmdb;
+extern unsigned char *mdb_oops;
+extern int mdb(int reason, int error, struct pt_regs *regs);
+
