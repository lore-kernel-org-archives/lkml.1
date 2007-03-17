Return-Path: <linux-kernel-owner+w=401wt.eu-S1751523AbXCQIyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbXCQIyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 04:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933364AbXCQIyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 04:54:52 -0400
Received: from ozlabs.org ([203.10.76.45]:39260 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbXCQIyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 04:54:50 -0400
Subject: Re: CONFIG_REORDER Kconfig help strange sentence.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       arjan@infradead.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070315183421.5b1cf51b.rdunlap@xenotime.net>
References: <1173741484.10618.25.camel@localhost.localdomain>
	 <20070312235605.GA14444@muc.de>
	 <1173767855.10618.46.camel@localhost.localdomain>
	 <20070315183421.5b1cf51b.rdunlap@xenotime.net>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 19:54:30 +1100
Message-Id: <1174121670.8897.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 18:34 -0700, Randy Dunlap wrote:
> On Tue, 13 Mar 2007 17:37:35 +1100 Rusty Russell wrote:
> > diff -r de5618b5e562 arch/x86_64/Kconfig
> > --- a/arch/x86_64/Kconfig	Tue Mar 13 11:41:55 2007 +1100
> > +++ b/arch/x86_64/Kconfig	Tue Mar 13 17:27:05 2007 +1100
> > @@ -632,8 +632,8 @@ config REORDER
> >  	default n
> >  	help
> >           This option enables the toolchain to reorder functions for a more 
> > -         optimal TLB usage. If you have pretty much any version of binutils, 
> > -	 this can increase your kernel build time by roughly one minute.
> > +         optimal TLB usage.  This will slow your kernel build by
> > +	 roughly one minute.
> 
> Please consistently use <tab><space><space> for help text.
> Yes, it was already mucked up.

Erm, OK, this applies after previous patch if it's wanted.

After Randy spotted an errant TAB, this is a cleanup of
arch/x86_64/Kconfig.

1) clean up all the trailing whitespace,
2) make sure we use tabs instead of spaces,
3) ensure all help messages use tab & two spaces,
4) make sure all help messages are < 80 cols.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r af971625bda6 arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig	Sat Mar 17 19:50:28 2007 +1100
+++ b/arch/x86_64/Kconfig	Sat Mar 17 19:51:01 2007 +1100
@@ -138,10 +138,10 @@ config X86_VSMP
 config X86_VSMP
 	bool "Support for ScaleMP vSMP"
 	depends on PCI
-	 help
+	help
 	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
-	  supposed to run on these EM64T-based machines.  Only choose this option
-	  if you have one of these machines.
+	  supposed to run on these EM64T-based machines.  Only choose this
+	  option if you have one of these machines.
 
 endchoice
 
@@ -155,13 +155,13 @@ config MK8
 	  Optimize for AMD Opteron/Athlon64/Hammer/K8 CPUs.
 
 config MPSC
-       bool "Intel P4 / older Netburst based Xeon"
-       help
+	bool "Intel P4 / older Netburst based Xeon"
+	help
 	  Optimize for Intel Pentium 4 and older Nocona/Dempsey Xeon CPUs
 	  with Intel Extended Memory 64 Technology(EM64T). For details see
 	  <http://www.intel.com/technology/64bitextensions/>.
 	  Note that the latest Xeons (Xeon 51xx and 53xx) are not based on the
-          Netburst core and shouldn't use this option. You can distinguish them
+	  Netburst core and shouldn't use this option. You can distinguish them
 	  using the cpu family field
 	  in /proc/cpuinfo. Family 15 is an older Xeon, Family 6 a newer one
 	  (this rule only applies to systems that support EM64T)
@@ -333,26 +333,26 @@ source "kernel/Kconfig.preempt"
 source "kernel/Kconfig.preempt"
 
 config NUMA
-       bool "Non Uniform Memory Access (NUMA) Support"
-       depends on SMP
-       help
-	 Enable NUMA (Non Uniform Memory Access) support. The kernel 
-	 will try to allocate memory used by a CPU on the local memory 
-	 controller of the CPU and add some more NUMA awareness to the kernel.
-	 This code is recommended on all multiprocessor Opteron systems.
-	 If the system is EM64T, you should say N unless your system is EM64T 
-	 NUMA. 
+	bool "Non Uniform Memory Access (NUMA) Support"
+	depends on SMP
+	help
+	  Enable NUMA (Non Uniform Memory Access) support. The kernel
+	  will try to allocate memory used by a CPU on the local memory
+	  controller of the CPU and add some more NUMA awareness to the kernel.
+	  This code is recommended on all multiprocessor Opteron systems.
+	  If the system is EM64T, you should say N unless your system is EM64T
+	  NUMA.
 
 config K8_NUMA
-       bool "Old style AMD Opteron NUMA detection"
-       depends on NUMA && PCI
-       default y
-       help
-	 Enable K8 NUMA node topology detection.  You should say Y here if
-	 you have a multi processor AMD K8 system. This uses an old
-	 method to read the NUMA configuration directly from the builtin
-	 Northbridge of Opteron. It is recommended to use X86_64_ACPI_NUMA
-	 instead, which also takes priority if both are compiled in.   
+	bool "Old style AMD Opteron NUMA detection"
+	depends on NUMA && PCI
+	default y
+	help
+	  Enable K8 NUMA node topology detection.  You should say Y here if
+	  you have a multi processor AMD K8 system. This uses an old
+	  method to read the NUMA configuration directly from the builtin
+	  Northbridge of Opteron. It is recommended to use X86_64_ACPI_NUMA
+	  instead, which also takes priority if both are compiled in.
 
 config NODES_SHIFT
 	int
@@ -362,14 +362,14 @@ config NODES_SHIFT
 # Dummy CONFIG option to select ACPI_NUMA from drivers/acpi/Kconfig.
 
 config X86_64_ACPI_NUMA
-       bool "ACPI NUMA detection"
-       depends on NUMA
-       select ACPI 
+	bool "ACPI NUMA detection"
+	depends on NUMA
+	select ACPI
 	select PCI
-       select ACPI_NUMA
-       default y
-       help
-	 Enable ACPI SRAT based node topology detection.
+	select ACPI_NUMA
+	default y
+	help
+	  Enable ACPI SRAT based node topology detection.
 
 config NUMA_EMU
 	bool "NUMA emulation"
@@ -380,9 +380,9 @@ config NUMA_EMU
 	  number of nodes. This is only useful for debugging.
 
 config ARCH_DISCONTIGMEM_ENABLE
-       bool
-       depends on NUMA
-       default y
+	bool
+	depends on NUMA
+	default y
 
 config ARCH_DISCONTIGMEM_DEFAULT
 	def_bool y
@@ -556,14 +556,14 @@ config CRASH_DUMP
 	bool "kernel crash dumps (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	help
-          Generate crash dump after being started by kexec.
-          This should be normally only set in special crash dump kernels
-          which are loaded in the main kernel with kexec-tools into
-          a specially reserved region and then later executed after
-          a crash by kdump/kexec. The crash dump kernel must be compiled
+	  Generate crash dump after being started by kexec.
+	  This should be normally only set in special crash dump kernels
+	  which are loaded in the main kernel with kexec-tools into
+	  a specially reserved region and then later executed after
+	  a crash by kdump/kexec. The crash dump kernel must be compiled
 	  to a memory address not used by the main kernel or BIOS using
 	  PHYSICAL_START.
-          For more details see Documentation/kdump/kdump.txt
+	  For more details see Documentation/kdump/kdump.txt
 
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
@@ -605,7 +605,7 @@ config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	help
-         This option turns on the -fstack-protector GCC feature. This
+	  This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of critical functions, a canary
 	  value on the stack just before the return address, and validates
 	  the value just before actually returning.  Stack based buffer
@@ -631,9 +631,9 @@ config REORDER
 	bool "Function reordering"
 	default n
 	help
-         This option enables the toolchain to reorder functions for a more 
-         optimal TLB usage.  This will slow your kernel build by
-	 roughly one minute.
+	  This option enables the toolchain to reorder functions for a more
+	  optimal TLB usage.  This will slow your kernel build by
+	  roughly one minute.
 
 config K8_NB
 	def_bool y
@@ -705,15 +705,15 @@ config IA32_EMULATION
 config IA32_EMULATION
 	bool "IA32 Emulation"
 	help
-	  Include code to run 32-bit programs under a 64-bit kernel. You should likely
-	  turn this on, unless you're 100% sure that you don't have any 32-bit programs
-	  left.
+	  Include code to run 32-bit programs under a 64-bit kernel. You
+	  should likely turn this on, unless you're 100% sure that you don't
+	  have any 32-bit programs left.
 
 config IA32_AOUT
-       tristate "IA32 a.out support"
-       depends on IA32_EMULATION
-       help
-         Support old a.out binaries in the 32bit emulation.
+	tristate "IA32 a.out support"
+	depends on IA32_EMULATION
+	help
+	  Support old a.out binaries in the 32bit emulation.
 
 config COMPAT
 	bool
@@ -736,7 +736,7 @@ source fs/Kconfig
 source fs/Kconfig
 
 menu "Instrumentation Support"
-        depends on EXPERIMENTAL
+	depends on EXPERIMENTAL
 
 source "arch/x86_64/oprofile/Kconfig"
 


