Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYHUDX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYHUDX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbYHUDQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:16:42 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50111 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbYHUDQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:16:10 -0400
Date: Wed, 20 Aug 2008 20:50:37 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808210250.m7L2obNX028353@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc4 released
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangesLog:

 added MAGIC_SYSRQ support.  removed notify_die handler and changes
 to drivers/char/keyboard.c.  save or restrive pt_regs for cases where
 panic is called from non-exception context.  handled cases 
 where the per_cpu registers and context are not valid/saved
 when panic is called from non-exception contexts. 
 
 removed more checkpatch.pl messages.  lots more messages to still
 work on.  volatiles left in the code due to the previously stated
 (and still present) severe breakage of the GNU compiler with SMP 
 shared data.  most of the barrier() functions are just plain broken
 and do not result in proper compiler behavior in this tree.  it 
 helps having a working debugger to actually see these compiler problems.  

 
2.6.27-rc4 1/27 mdb:  export genapic and machine_restart functions
 
 export genapic and machine_restart functions
 

2.6.27-rc4 2/27 mdb:  add makefile for Merkey's Linux Kernel Debugger module
 
 add makefile for Merkey's Linux Kernel Debugger module
 

2.6.27-rc4 3/27 mdb:  add local Makefile for Merkey's Linux Kernel Debugger module
 
 add local Makefile for Merkey's Linux Kernel Debugger module
 

2.6.27-rc4 4/27 mdb:  add mdb-base.c architecure independent functions
 
 add mdb-base.c architecure independent functions
 

2.6.27-rc4 5/27 mdb:  add mdb-base.h architecure indepedent include
 
 add mdb-base.h architecure indepedent include
 

2.6.27-rc4 6/27 mdb:  add mdb.h architecure main include
 
 add mdb.h architecure main include
 

2.6.27-rc4 7/27 mdb:  add mdb-ia32.c Intel x86 architecure functions
 
 add mdb-ia32.c Intel x86 architecure functions
 
 

2.6.27-rc4 8/27 mdb:  add mdb-ia32.h Intel x86 architecure includes
 
 add mdb-ia32.h Intel x86 architecure includes
 
 

2.6.27-rc4 9/27 mdb:  add mdb-ia32.c Intel x86 architecure function includes
 
 add mdb-ia32.c Intel x86 architecure function includes
 
 

2.6.27-rc4 10/27 mdb:  add mdb-ia32-support.c disassembler support
 
 add mdb-ia32-support.c disassembler support
 

2.6.27-rc4 11/27 mdb:  add mdb-keyboard.h keyboard function includes
 
 add mdb-keyboard.h keyboard function includes
 

2.6.27-rc4 12/27 mdb:  add mdb-list.c debugger parser functions
 
 add mdb-list.c debugger parser functions

2.6.27-rc4 13/27 mdb:  add mdb-list.h debugger parser function includes
 
 add mdb-list.h debugger parser function includes

2.6.27-rc4 14/27 mdb:  add mdb-logic.c math parser for Merkey's Linux Kernel Debugger
 
 add mdb-logic.c math parser for Merkey's Linux Kernel Debugger
 

2.6.27-rc4 15/27 mdb:  add mdb-main.c linux debugger entry functions
 
 add mdb-main.c linux debugger entry functions
 
 add MAGIC_SYSRQ keyboard support.  add support for panic notify_die
 callback.
 

2.6.27-rc4 16/27 mdb:  add mdb-os.c operating system specific functions
 
 add mdb-os.c operating system specific functions
 

2.6.27-rc4 17/27 mdb:  add mdb-os.h operating system specific functions
 
 add mdb-os.h operating system specific functions
 

2.6.27-rc4 18/27 mdb:  add mdb-proc.h function prototype includes
 
 add mdb-proc.h function prototype includes
 

2.6.27-rc4 19/27 mdb:  add MAGIC_SYSRQ support for mdb to documentation
 
 add MAGIC_SYSRQ support for mdb to documentation
 

2.6.27-rc4 20/27 mdb:  export kmsg_redirect printk for console redirection 
 
 export kmsg_redirect printk for console redirection 
 

2.6.27-rc4 21/27 mdb:  export __kernel_text_address 
 
 export __kernel_text_address 
 

2.6.27-rc4 22/27 mdb:  add mdb_kallsyms function and export kallsyms lookup functions
 
 add mdb_kallsyms function and export kallsyms lookup functions
 

2.6.27-rc4 23/27 mdb:  add mdb_modules function 
 
 add mdb_modules function 
 

2.6.27-rc4 24/27 mdb:  add notify_die handler to system panic 
 
 add notify_die handler to system panic 
 

2.6.27-rc4 25/27 mdb:  export clocksource watchdog function
 
 export clocksource watchdog function
 

2.6.27-rc4 26/27 mdb:  add Kconfig.debug sections and documentation 
 
 add Kconfig.debug sections and documentation 
 
 add help sections for MAGIC_SYSRQ keyboard support.
 

2.6.27-rc4 27/27 mdb:  add /debug directory to main Makefile 
 
 add /debug directory to main Makefile 
 
TO-DO
 
 Add nested task gates to ia32 IDT for Linux to enable switching to a 
 good stack during exceptions.
 X86_64 disssembler support
 ia64 disassembler support.
 
Release Site : http://www.wolfmountaingroup.org
FTP Address  : ftp://www.wolfmountaingroup.org/pub/mdb/mdb-2.6.27-rc4-ia32-08-20-08.patch


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)
