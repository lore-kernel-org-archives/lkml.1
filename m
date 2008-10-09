Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbYJIX5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbYJIX5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYJIXzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:55:01 -0400
Received: from xenotime.net ([66.160.160.81]:43576 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752901AbYJIXy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:54:57 -0400
Date: Thu, 09 Oct 2008 16:52:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] docs: fix Doc/x86/ subdir references
Message-ID: <12235963551913@xenotime.net>
In-Reply-To: <12235963551043@xenotime.net>
X-Mailer: gregkh_patchbomb
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

--- linux-2.6.27-rc9-git2.orig/Documentation/00-INDEX
+++ linux-2.6.27-rc9-git2/Documentation/00-INDEX
@@ -171,7 +171,7 @@ i2c/
 	- directory with info about the I2C bus/protocol (2 wire, kHz speed).
 i2o/
 	- directory with info about the Linux I2O subsystem.
-i386/
+x86/i386/
 	- directory with info about Linux on Intel 32 bit architecture.
 ia64/
 	- directory with info about Linux on Intel 64 bit architecture.
@@ -383,7 +383,7 @@ w1/
 	- directory with documents regarding the 1-wire (w1) subsystem.
 watchdog/
 	- how to auto-reboot Linux if it has "fallen and can't get up". ;-)
-x86_64/
+x86/x86_64/
 	- directory with info on Linux support for AMD x86-64 (Hammer) machines.
 zorro.txt
 	- info on writing drivers for Zorro bus devices found on Amigas.
--- linux-2.6.27-rc9-git2.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.27-rc9-git2/Documentation/kernel-parameters.txt
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
@@ -1187,7 +1187,7 @@ and is between 256 and 4096 characters. 
 
 	mce		[X86-32] Machine Check Exception
 
-	mce=option	[X86-64] See Documentation/x86_64/boot-options.txt
+	mce=option	[X86-64] See Documentation/x86/x86_64/boot-options.txt
 
 	md=		[HW] RAID subsystems devices and level
 			See Documentation/md.txt.
@@ -1650,7 +1650,7 @@ and is between 256 and 4096 characters. 
 			See Documentation/paride.txt.
 
 	pirq=		[SMP,APIC] Manual mp-table setup
-			See Documentation/i386/IO-APIC.txt.
+			See Documentation/x86/i386/IO-APIC.txt.
 
 	plip=		[PPT,NET] Parallel port network link
 			Format: { parport<nr> | timid | 0 }
@@ -2231,7 +2231,7 @@ and is between 256 and 4096 characters. 
 			See Documentation/fb/modedb.txt.
 
 	vga=		[BOOT,X86-32] Select a particular video mode
-			See Documentation/i386/boot.txt and
+			See Documentation/x86/i386/boot.txt and
 			Documentation/svga.txt.
 			Use vga=ask for menu.
 			This is actually a boot loader parameter; the value is
--- linux-2.6.27-rc9-git2.orig/Documentation/lguest/lguest.c
+++ linux-2.6.27-rc9-git2/Documentation/lguest/lguest.c
@@ -402,7 +402,7 @@ static unsigned long load_bzimage(int fd
 	void *p = from_guest_phys(0x100000);
 
 	/* Go back to the start of the file and read the header.  It should be
-	 * a Linux boot header (see Documentation/i386/boot.txt) */
+	 * a Linux boot header (see Documentation/x86/i386/boot.txt) */
 	lseek(fd, 0, SEEK_SET);
 	read(fd, &boot, sizeof(boot));
 
--- linux-2.6.27-rc9-git2.orig/Documentation/x86/x86_64/boot-options.txt
+++ linux-2.6.27-rc9-git2/Documentation/x86/x86_64/boot-options.txt
@@ -35,7 +35,7 @@ APICs
 
    nolapic	 Don't use the local APIC (alias for i386 compatibility)
 
-   pirq=...	 See Documentation/i386/IO-APIC.txt
+   pirq=...	 See Documentation/x86/i386/IO-APIC.txt
 
    noapictimer	 Don't set up the APIC timer
 
@@ -143,7 +143,7 @@ Non Executable Mappings
 SMP
 
   additional_cpus=NUM Allow NUM more CPUs for hotplug
-		 (defaults are specified by the BIOS, see Documentation/x86_64/cpu-hotplug-spec)
+		 (defaults are specified by the BIOS, see Documentation/x86/x86_64/cpu-hotplug-spec)
 
 NUMA
 
--- linux-2.6.27-rc9-git2.orig/Documentation/x86/x86_64/fake-numa-for-cpusets
+++ linux-2.6.27-rc9-git2/Documentation/x86/x86_64/fake-numa-for-cpusets
@@ -10,7 +10,7 @@ amount of system memory that are availab
 For more information on the features of cpusets, see Documentation/cpusets.txt.
 There are a number of different configurations you can use for your needs.  For
 more information on the numa=fake command line option and its various ways of
-configuring fake nodes, see Documentation/x86_64/boot-options.txt.
+configuring fake nodes, see Documentation/x86/x86_64/boot-options.txt.
 
 For the purposes of this introduction, we'll assume a very primitive NUMA
 emulation setup of "numa=fake=4*512,".  This will split our system memory into


-- 

