Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYHEGtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYHEGtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 02:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYHEGr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:47:26 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:46581 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbYHEGrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:47:20 -0400
Date: Tue, 5 Aug 2008 00:26:35 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808050626.m756QZak003764@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc1-git5 7/26] mdb: strip down mdb.h and move to includes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralized external definitions into include files and corrected 
the file to conform to Linux coding practices.  fixed word wrap
problems with patches.

move relevant sections to the include/linux directory.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/debug/mdb.h	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb.h	2008-08-04 15:49:51.000000000 -0600
@@ -0,0 +1,42 @@
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
+*   DESCRIP  :  Merkey's NetWare Debugger
+*
+***************************************************************************/
+
+#ifndef _MDB_H
+#define _MDB_H
+
+extern int mdb_printf(char *s, ...);
+#define DBGPrint   mdb_printf
+
+#endif
+
