Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbYIHEaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbYIHEaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 00:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYIHEa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 00:30:27 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:42626 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbYIHEa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 00:30:26 -0400
Message-ID: <1870.166.70.238.45.1220846439.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 7 Sep 2008 22:00:39 -0600 (MDT)
Subject: [ANNOUNCE] mdb:  Merkey's Linux Kernel Debugger Release 2.6.27-rc6
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am tired of waiting for rc6, so if there are ground shaking changes over
rc6-git9, I will update the patches.

ChangeLog, 09/07/2008

Corrected dword, word, and byte dereference in the mdb-logic.c
documentation to match the disassembly display.

Changed oops_in_progress entry point to a counter variable to preserve
state when mdb is called from exceptions where it may have been previously
set.

Cleaned up several hundred more checkpatch.pl messages.

Cleanup error check cases in mdb-logic.c

back ported modularization, and use of notify_die handlers, sysrq handler
to previous Linux kernel mdb patch versions 2.6.18 up through 2.6.27-rc6.

removed dependencies on broken thread migration routines in reboot.c  with
processor migration during reboot request.  It's busted if multiple
processors are in the debugger.

TO-DO

x86_64 systems received, merge in process
IA64 systems slated for receipt in November for testing. code merge in
process with software simulator.
Nested TSS gates for X86 and X86_64 in process

MDB repositories

http://sourceforge.net/projects/merkeydebugger
http://code.google.com/p/merkeydebugger
http://www.wolfmountaingroup.org

mdb-2.6.27-rc6 patches
ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.27-rc6-ia32-09-07-08.patch

back ports of mdb linux kernel patches
ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.18-ia32-09-07-08.patch
ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.19-ia32-09-07-08.patch
ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.20-ia32-09-07-08.patch
ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.21-ia32-09-07-08.patch
ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.22-ia32-09-07-08.patch
ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.23-ia32-09-07-08.patch
ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.24-ia32-09-07-08.patch
ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.25-ia32-09-07-08.patch
ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.26-ia32-09-07-08.patch

Jeffrey Vernon Merkey
Wolf Mountain Group, Inc.









































