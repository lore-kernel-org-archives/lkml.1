Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbYJRFYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbYJRFYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 01:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYJRFYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 01:24:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64363 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYJRFYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 01:24:04 -0400
Message-ID: <48F972E4.4020204@oracle.com>
Date: Fri, 17 Oct 2008 22:23:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Uwe Hermann <uwe@hermann-uwe.de>
Subject: [PATCH 2/3] docs: fix Doc/x86/ subdir references
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Hermann <uwe@hermann-uwe.de>

The Documentation/i386 and Documentation/x86_64 directories and their
contents have been moved into Documentation/x86. Fix references to
those files accordingly.

Signed-off-by: Uwe Hermann <uwe@hermann-uwe.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/00-INDEX                         |    4 ++--
 Documentation/kernel-parameters.txt            |   12 ++++++------
 Documentation/lguest/lguest.c                  |    2 +-
 Documentation/x86/x86_64/boot-options.txt      |    4 ++--
 Documentation/x86/x86_64/fake-numa-for-cpusets |    2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

--- lin2627-git8.orig/Documentation/00-INDEX
+++ lin2627-git8/Documentation/00-INDEX
@@ -172,7 +172,7 @@ i2c/
 	- directory with info about the I2C bus/protocol (2 wire, kHz speed).
 i2o/
 	- directory with info about the Linux I2O subsystem.
-i386/
+x86/i386/
 	- directory with info about Linux on Intel 32 bit architecture.
 ia64/
 	- directory with info about Linux on Intel 64 bit architecture.
@@ -382,7 +382,7 @@ w1/
 	- directory with documents regarding the 1-wire (w1) subsystem.
 watchdog/
 	- how to auto-reboot Linux if it has "fallen and can't get up". ;-)
-x86_64/
+x86/x86_64/
 	- directory with info on Linux support for AMD x86-64 (Hammer) machines.
 zorro.txt
 	- info on writing drivers for Zorro bus devices found on Amigas.
--- lin2627-git8.orig/Documentation/kernel-parameters.txt
+++ lin2627-git8/Documentation/kernel-parameters.txt
@@ -100,7 +100,7 @@ parameter is applicable:
 	X86-32	X86-32, aka i386 architecture is enabled.
 	X86-64	X86-64 architecture is enabled.
 			More X86-64 boot options can be found in
-			Documentation/x86_64/boot-options.txt .
+			Documentation/x86/x86_64/boot-options.txt .
 
 In addition, the following text indicates that the option:
 
@@ -111,10 +111,10 @@ In addition, the following text indicate
 Parameters denoted with BOOT are actually interpreted by the boot
 loader, and have no meaning to the kernel directly.
 Do not modify the syntax of boot loader parameters without extreme
-need or coordination with <Documentation/i386/boot.txt>.
+need or coordination with <Documentation/x86/i386/boot.txt>.
 
 There are also arch-specific kernel-parameters not documented here.
-See for example <Documentation/x86_64/boot-options.txt>.
+See for example <Documentation/x86/x86_64/boot-options.txt>.
 
 Note that ALL kernel parameters listed below are CASE SENSITIVE, and that
 a trailing = on the name of any parameter states that that parameter will
@@ -1192,7 +1192,7 @@ and is between 256 and 4096 characters. 
 
 	mce		[X86-32] Machine Check Exception
 
-	mce=option	[X86-64] See Documentation/x86_64/boot-options.txt
+	mce=option	[X86-64] See Documentation/x86/x86_64/boot-options.txt
 
 	md=		[HW] RAID subsystems devices and level
 			See Documentation/md.txt.
@@ -1684,7 +1684,7 @@ and is between 256 and 4096 characters. 
 			See Documentation/paride.txt.
 
 	pirq=		[SMP,APIC] Manual mp-table setup
-			See Documentation/i386/IO-APIC.txt.
+			See Documentation/x86/i386/IO-APIC.txt.
 
 	plip=		[PPT,NET] Parallel port network link
 			Format: { parport<nr> | timid | 0 }
@@ -2295,7 +2295,7 @@ and is between 256 and 4096 characters. 
 			See Documentation/fb/modedb.txt.
 
 	vga=		[BOOT,X86-32] Select a particular video mode
-			See Documentation/i386/boot.txt and
+			See Documentation/x86/i386/boot.txt and
 			Documentation/svga.txt.
 			Use vga=ask for menu.
 			This is actually a boot loader parameter; the value is
--- lin2627-git8.orig/Documentation/lguest/lguest.c
+++ lin2627-git8/Documentation/lguest/lguest.c
@@ -402,7 +402,7 @@ static unsigned long load_bzimage(int fd
 	void *p = from_guest_phys(0x100000);
 
 	/* Go back to the start of the file and read the header.  It should be
-	 * a Linux boot header (see Documentation/i386/boot.txt) */
+	 * a Linux boot header (see Documentation/x86/i386/boot.txt) */
 	lseek(fd, 0, SEEK_SET);
 	read(fd, &boot, sizeof(boot));
 
--- lin2627-git8.orig/Documentation/x86/x86_64/boot-options.txt
+++ lin2627-git8/Documentation/x86/x86_64/boot-options.txt
@@ -35,7 +35,7 @@ APICs
 
    nolapic	 Don't use the local APIC (alias for i386 compatibility)
 
-   pirq=...	 See Documentation/i386/IO-APIC.txt
+   pirq=...	 See Documentation/x86/i386/IO-APIC.txt
 
    noapictimer	 Don't set up the APIC timer
 
@@ -139,7 +139,7 @@ Non Executable Mappings
 SMP
 
   additional_cpus=NUM Allow NUM more CPUs for hotplug
-		 (defaults are specified by the BIOS, see Documentation/x86_64/cpu-hotplug-spec)
+		 (defaults are specified by the BIOS, see Documentation/x86/x86_64/cpu-hotplug-spec)
 
 NUMA
 
--- lin2627-git8.orig/Documentation/x86/x86_64/fake-numa-for-cpusets
+++ lin2627-git8/Documentation/x86/x86_64/fake-numa-for-cpusets
@@ -10,7 +10,7 @@ amount of system memory that are availab
 For more information on the features of cpusets, see Documentation/cpusets.txt.
 There are a number of different configurations you can use for your needs.  For
 more information on the numa=fake command line option and its various ways of
-configuring fake nodes, see Documentation/x86_64/boot-options.txt.
+configuring fake nodes, see Documentation/x86/x86_64/boot-options.txt.
 
 For the purposes of this introduction, we'll assume a very primitive NUMA
 emulation setup of "numa=fake=4*512,".  This will split our system memory into
