Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbYH2GZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbYH2GZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYH2GQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:16:07 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59516 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYH2GPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:35 -0400
Date: Thu, 28 Aug 2008 23:47:42 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5lgii016145@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc5 released
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Added local APIC and IOAPIC register support.  Removed all volatile 
 declarations from the code.  Instrumented barrier() compiler 
 directives.  streamlined mdb-list parser.   Added hard
 NMI interrupt capability to generate a hard NMI to a target 
 processor for debugging a hung processor via the APIC ASSERT_INT
 command.
 
 ISSUES:
 
 remote read of another processors local APIC registers has been
 instrumented, but I am having problems with it working on all 
 systems.   I have tried both physical and logical command modes 
 and I note that smptboot.c also relies on it for error reporting.
 
 At present, it is insufficiently tested and some other eyes and 
 testing would be helpful. 
 
ChangesLog:
2.6.27-rc5 1/29 mdb:  export ioapic read routines and detected ioapic count
 
 export ioapic read routines and detected ioapic count.
 

2.6.27-rc5 2/29 mdb:  export genapic and machine_restart functions
 
 export genapic and machine_restart functions
 

2.6.27-rc5 3/29 mdb:  add makefile for Merkey's Linux Kernel Debugger module
 
 add makefile for Merkey's Linux Kernel Debugger module
 

2.6.27-rc5 4/29 mdb:  add local Makefile for Merkey's Linux Kernel Debugger module
 
 add local Makefile for Merkey's Linux Kernel Debugger module
 

2.6.27-rc5 5/29 mdb:  add mdb-base.c architecure independent functions
 
 add mdb-base.c architecure independent functions
 

2.6.27-rc5 6/29 mdb:  add mdb-base.h architecure indepedent include
 
 add mdb-base.h architecure indepedent include
 

2.6.27-rc5 7/29 mdb:  add mdb.h architecure main include
 
 add mdb.h architecure main include
 

2.6.27-rc5 8/29 mdb:  add mdb-ia32-apic.c Intel x86 architecure functions
 
 add mdb-ia32-apic.c Intel x86 architecure functions.
 add support to dump local APIC and IOAPIC registers.  
 Instrument support for remote read of local apic registers.
 
 Add support for hardware NMI assertion for debugging a hard 
 hung processor.  
 
 

2.6.27-rc5 9/29 mdb:  add mdb-ia32.c Intel x86 architecure routines
 
 add mdb-ia32.c Intel x86 architecure routines
 
 remove ALL volatile declarations
 

2.6.27-rc5 10/29 mdb:  add mdb-ia32.h Intel x86 architecure includes
 
 add mdb-ia32.h Intel x86 architecure includes
 
 

2.6.27-rc5 11/29 mdb:  add mdb-ia32-proc.h Intel x86 architecure function includes
 
 add mdb-ia32-proc.h Intel x86 architecure function includes
 
 

2.6.27-rc5 12/29 mdb:  add mdb-ia32-support.c disassembler support
 
 add mdb-ia32-support.c disassembler support
 

2.6.27-rc5 13/29 mdb:  add mdb-keyboard.h keyboard function includes
 
 add mdb-keyboard.h keyboard function includes
 

2.6.27-rc5 14/29 mdb:  add mdb-list.c debugger parser functions
 
 add mdb-list.c debugger parser functions

2.6.27-rc5 15/29 mdb:  add mdb-list.h debugger parser function includes
 
 add mdb-list.h debugger parser function includes

2.6.27-rc5 16/29 mdb:  add mdb-logic.c math parser for Merkey's Linux Kernel Debugger
 
 add mdb-logic.c math parser for Merkey's Linux Kernel Debugger
 

2.6.27-rc5 17/29 mdb:  add mdb-main.c linux debugger entry functions
 
 add mdb-main.c linux debugger entry functions
 
 remove ALL volatile declarations
 

2.6.27-rc5 18/29 mdb:  add mdb-os.c operating system specific functions
 
 add mdb-os.c operating system specific functions
 

2.6.27-rc5 19/29 mdb:  add mdb-os.h operating system specific functions
 
 add mdb-os.h operating system specific functions
 

2.6.27-rc5 20/29 mdb:  add mdb-proc.h function prototype includes
 
 add mdb-proc.h function prototype includes
 

2.6.27-rc5 21/29 mdb:  add MAGIC_SYSRQ support for mdb to documentation
 
 add MAGIC_SYSRQ support for mdb to documentation
 

2.6.27-rc5 22/29 mdb:  export kmsg_redirect printk for console redirection 
 
 export kmsg_redirect printk for console redirection 
 

2.6.27-rc5 23/29 mdb:  export __kernel_text_address 
 
 export __kernel_text_address 
 

2.6.27-rc5 24/29 mdb:  add mdb_kallsyms function and export kallsyms lookup functions
 
 add mdb_kallsyms function and export kallsyms lookup functions
 

2.6.27-rc5 25/29 mdb:  add mdb_modules function 
 
 add mdb_modules function 
 

2.6.27-rc5 26/29 mdb:  add notify_die handler to system panic 
 
 add notify_die handler to system panic 
 

2.6.27-rc5 27/29 mdb:  export clocksource watchdog function
 
 export clocksource watchdog function
 

2.6.27-rc5 28/29 mdb:  add Kconfig.debug sections and documentation 
 
 add Kconfig.debug sections and documentation 
 
 updated help sections for MAGIC_SYSRQ keyboard support.
 Added X86 option restruction for X86 only features.
 

2.6.27-rc5 29/29 mdb:  add /debug directory to main Makefile 
 
 add /debug directory to main Makefile 
 
 TO-DO
 
 Add nested task gates to ia32 IDT for Linux to enable switching to a 
   good stack during exceptions.
 X86_64 disssembler support
 X86_64 register display support
 ia64 disassembler support.
 ia64 breakpoint support.
 ia64 register display support.
 

Release Site : http://www.wolfmountaingroup.org
FTP Address  : ftp://www.wolfmountaingroup.org/pub/mdb/mdb-2.6.27-rc5-ia32-08-28-08.patch


