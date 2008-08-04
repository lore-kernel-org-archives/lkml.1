Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbYHDGwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbYHDGwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759194AbYHDGwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:52:06 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:48547 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186AbYHDGwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:52:05 -0400
Message-ID: <37448.166.70.238.45.1217831500.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:31:40 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 7/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware style debugger for Linux written by Jeffrey Vernon Merkey

--- a/debug/mdb.h	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb.h	2008-08-03 16:15:00.000000000 -0600
@@ -0,0 +1,104 @@
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
+*   Free Software Foundation, version 3.
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
+*   FILE     :  MDB.H
+*   DESCRIP  :  Merkey's NetWare Debugger
+*   DATE     :  April 8, 2008
+*
+***************************************************************************/
+
+#ifndef _MDB_H
+#define _MDB_H
+
+extern int mdb_printf(char *s, ...);
+#define DBGPrint   mdb_printf
+
+#define  TRUE               1
+#define  FALSE              0
+
+#ifndef LONGLONG
+typedef long long LONGLONG;
+#endif
+typedef unsigned long  ULONG;
+typedef unsigned short WORD;
+typedef unsigned char  BYTE;
+
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/stat.h>
+#include <linux/errno.h>
+#include <linux/fcntl.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/genhd.h>
+#include <linux/hdreg.h>
+#include <linux/fs.h>
+#include <linux/major.h>
+#include <linux/mm.h>
+#include <linux/cdrom.h>
+#include <linux/pagemap.h>
+#include <linux/swap.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/ctype.h>
+//#include <linux/pc_keyb.h>
+#include <linux/keyboard.h>
+#include <linux/console.h>
+#include <linux/serial_reg.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+#include <asm/segment.h>
+#include <asm/atomic.h>
+#include <asm/msr.h>
+#include <asm/io.h>
+
+#ifdef CONFIG_SMP
+#include <mach_apic.h>
+#include <mach_ipi.h>
+#endif
+
+#define __KERNEL_SYSCALLS__
+#include <linux/unistd.h>
+#include <linux/kallsyms.h>
+
+#include "mdb-ia32.h"
+#include "mdb-list.h"
+#include "mdb-ia32-proc.h"
+#include "mdb-base.h"
+#include "mdb-proc.h"
+#include "mdb-os.h"
+#include "mdb-keyboard.h"
+
+#endif
+


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



