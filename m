Return-Path: <linux-kernel-owner+w=401wt.eu-S1764240AbXGPAcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764240AbXGPAcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760245AbXGPAcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:32:43 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:43301 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762841AbXGPAcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:32:42 -0400
Date: Sun, 15 Jul 2007 20:32:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/8] Immediate Value - Add kconfig menus
Message-ID: <20070716003234.GA26411@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012623.839969254@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012623.839969254@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:31:27 up 8 days, 14:36,  3 users,  load average: 0.61, 0.35, 0.32
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Should be dropped,
replaced by :
immediate-values-kconfig-embedded.patch

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Immediate values provide a way to use dynamic code patching to update variables
> sitting within the instruction stream. It saves caches lines normally used by
> static read mostly variables.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Adrian Bunk <bunk@stusta.de>
> CC: Andi Kleen <andi@firstfloor.org>
> ---
> 
>  arch/alpha/Kconfig       |    6 ++++++
>  arch/arm/Kconfig         |    6 ++++++
>  arch/arm26/Kconfig       |    6 ++++++
>  arch/avr32/Kconfig.debug |    7 +++++++
>  arch/cris/Kconfig        |    6 ++++++
>  arch/frv/Kconfig         |    6 ++++++
>  arch/h8300/Kconfig       |    6 ++++++
>  arch/i386/Kconfig        |    2 ++
>  arch/ia64/Kconfig        |    3 +++
>  arch/m32r/Kconfig        |    6 ++++++
>  arch/m68k/Kconfig        |    6 ++++++
>  arch/m68knommu/Kconfig   |    6 ++++++
>  arch/mips/Kconfig        |    6 ++++++
>  arch/parisc/Kconfig      |    6 ++++++
>  arch/powerpc/Kconfig     |    3 +++
>  arch/ppc/Kconfig         |    6 ++++++
>  arch/s390/Kconfig        |    2 ++
>  arch/sh/Kconfig          |    6 ++++++
>  arch/sh64/Kconfig        |    6 ++++++
>  arch/sparc/Kconfig       |    2 ++
>  arch/sparc64/Kconfig     |    3 +++
>  arch/um/Kconfig          |    6 ++++++
>  arch/v850/Kconfig        |    6 ++++++
>  arch/x86_64/Kconfig      |    3 +++
>  arch/xtensa/Kconfig      |    6 ++++++
>  kernel/Kconfig.immediate |   11 +++++++++++
>  26 files changed, 138 insertions(+)
> 
> Index: linux-2.6-lttng/arch/alpha/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/alpha/Kconfig	2007-07-13 14:17:59.000000000 -0400
> +++ linux-2.6-lttng/arch/alpha/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -653,6 +653,12 @@
>  
>  source "arch/alpha/oprofile/Kconfig"
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/alpha/Kconfig.debug"
>  
>  # DUMMY_CONSOLE may be defined in drivers/video/console/Kconfig
> Index: linux-2.6-lttng/arch/arm/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/arm/Kconfig	2007-07-13 14:17:59.000000000 -0400
> +++ linux-2.6-lttng/arch/arm/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -1046,6 +1046,12 @@
>  
>  source "arch/arm/oprofile/Kconfig"
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/arm/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/arch/arm26/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/arm26/Kconfig	2007-07-13 14:17:59.000000000 -0400
> +++ linux-2.6-lttng/arch/arm26/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -244,6 +244,12 @@
>  
>  source "drivers/usb/Kconfig"
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/arm26/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/arch/cris/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/cris/Kconfig	2007-07-13 14:17:59.000000000 -0400
> +++ linux-2.6-lttng/arch/cris/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -198,6 +198,12 @@
>  
>  source "drivers/usb/Kconfig"
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/cris/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/arch/frv/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/frv/Kconfig	2007-07-13 14:17:59.000000000 -0400
> +++ linux-2.6-lttng/arch/frv/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -375,6 +375,12 @@
>  
>  source "fs/Kconfig"
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/frv/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/arch/h8300/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/h8300/Kconfig	2007-07-13 14:17:59.000000000 -0400
> +++ linux-2.6-lttng/arch/h8300/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -223,6 +223,12 @@
>  
>  source "fs/Kconfig"
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/h8300/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/arch/i386/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/i386/Kconfig	2007-07-13 14:17:59.000000000 -0400
> +++ linux-2.6-lttng/arch/i386/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -1249,6 +1249,8 @@
>  	  for kernel debugging, non-intrusive instrumentation and testing.
>  	  If in doubt, say "N".
>  
> +source "kernel/Kconfig.immediate"
> +
>  endif # INSTRUMENTATION
>  
>  source "arch/i386/Kconfig.debug"
> Index: linux-2.6-lttng/arch/ia64/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/ia64/Kconfig	2007-07-13 14:17:59.000000000 -0400
> +++ linux-2.6-lttng/arch/ia64/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -593,6 +593,9 @@
>  	  a probepoint and specifies the callback.  Kprobes is useful
>  	  for kernel debugging, non-intrusive instrumentation and testing.
>  	  If in doubt, say "N".
> +
> +source "kernel/Kconfig.immediate"
> +
>  endmenu
>  
>  source "arch/ia64/Kconfig.debug"
> Index: linux-2.6-lttng/arch/m32r/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/m32r/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/m32r/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -408,6 +408,12 @@
>  
>  source "arch/m32r/oprofile/Kconfig"
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/m32r/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/arch/m68k/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/m68k/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/m68k/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -676,6 +676,12 @@
>  
>  source "fs/Kconfig"
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/m68k/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/arch/m68knommu/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/m68knommu/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/m68knommu/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -668,6 +668,12 @@
>  
>  source "fs/Kconfig"
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/m68knommu/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/arch/mips/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/mips/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/mips/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -1946,6 +1946,12 @@
>  
>  source "arch/mips/oprofile/Kconfig"
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/mips/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/arch/parisc/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/parisc/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/parisc/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -269,6 +269,12 @@
>  
>  source "arch/parisc/oprofile/Kconfig"
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/parisc/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/arch/powerpc/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/powerpc/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -655,6 +655,9 @@
>  	  a probepoint and specifies the callback.  Kprobes is useful
>  	  for kernel debugging, non-intrusive instrumentation and testing.
>  	  If in doubt, say "N".
> +
> +source "kernel/Kconfig.immediate"
> +
>  endmenu
>  
>  source "arch/powerpc/Kconfig.debug"
> Index: linux-2.6-lttng/arch/ppc/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/ppc/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/ppc/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -1451,8 +1451,14 @@
>  
>  source "lib/Kconfig"
>  
> +menu "Instrumentation Support"
> +
>  source "arch/powerpc/oprofile/Kconfig"
>  
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/ppc/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/arch/s390/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/s390/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/s390/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -547,6 +547,8 @@
>  	  for kernel debugging, non-intrusive instrumentation and testing.
>  	  If in doubt, say "N".
>  
> +source "kernel/Kconfig.immediate"
> +
>  endmenu
>  
>  source "arch/s390/Kconfig.debug"
> Index: linux-2.6-lttng/arch/sh/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/sh/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/sh/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -721,6 +721,12 @@
>  
>  source "arch/sh/oprofile/Kconfig"
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/sh/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/arch/sh64/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/sh64/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/sh64/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -284,6 +284,12 @@
>  
>  source "arch/sh64/oprofile/Kconfig"
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/sh64/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/arch/sparc/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/sparc/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/sparc/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -313,6 +313,8 @@
>  
>  source "arch/sparc/oprofile/Kconfig"
>  
> +source "kernel/Kconfig.immediate"
> +
>  endmenu
>  
>  source "arch/sparc/Kconfig.debug"
> Index: linux-2.6-lttng/arch/sparc64/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/sparc64/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -451,6 +451,9 @@
>  	  a probepoint and specifies the callback.  Kprobes is useful
>  	  for kernel debugging, non-intrusive instrumentation and testing.
>  	  If in doubt, say "N".
> +
> +source "kernel/Kconfig.immediate"
> +
>  endmenu
>  
>  source "arch/sparc64/Kconfig.debug"
> Index: linux-2.6-lttng/arch/um/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/um/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/um/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -335,4 +335,10 @@
>  	bool
>  	default n
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/um/Kconfig.debug"
> Index: linux-2.6-lttng/arch/v850/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/v850/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/v850/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -331,6 +331,12 @@
>  
>  source "drivers/usb/Kconfig"
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/v850/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/arch/x86_64/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/x86_64/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/x86_64/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -842,6 +842,9 @@
>  	  a probepoint and specifies the callback.  Kprobes is useful
>  	  for kernel debugging, non-intrusive instrumentation and testing.
>  	  If in doubt, say "N".
> +
> +source "kernel/Kconfig.immediate"
> +
>  endmenu
>  
>  source "arch/x86_64/Kconfig.debug"
> Index: linux-2.6-lttng/arch/xtensa/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/xtensa/Kconfig	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/xtensa/Kconfig	2007-07-13 14:33:51.000000000 -0400
> @@ -251,6 +251,12 @@
>  	  provide one yourself.
>  endmenu
>  
> +menu "Instrumentation Support"
> +
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  source "arch/xtensa/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng/kernel/Kconfig.immediate
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/kernel/Kconfig.immediate	2007-07-13 14:33:47.000000000 -0400
> @@ -0,0 +1,11 @@
> +# Immediate values configuration
> +
> +config IMMEDIATE
> +	bool "Enable immediate values"
> +	depends on X86_32 || PPC
> +	default y if !EMBEDDED
> +	help
> +	  Immediate values are used as read mostly variables that are rarely
> +	  updated. They use code patching to modify the values inscribed in the
> +	  instruction stream. It provides a way to save precious cache lines
> +	  that would otherwise have to be used by these variables.
> Index: linux-2.6-lttng/arch/avr32/Kconfig.debug
> ===================================================================
> --- linux-2.6-lttng.orig/arch/avr32/Kconfig.debug	2007-07-13 14:18:00.000000000 -0400
> +++ linux-2.6-lttng/arch/avr32/Kconfig.debug	2007-07-13 14:33:51.000000000 -0400
> @@ -6,6 +6,9 @@
>  
>  source "lib/Kconfig.debug"
>  
> +menu "Instrumentation Support"
> +	depends on EXPERIMENTAL
> +
>  config KPROBES
>  	bool "Kprobes"
>  	depends on DEBUG_KERNEL
> @@ -16,4 +19,8 @@
>            for kernel debugging, non-intrusive instrumentation and testing.
>            If in doubt, say "N".
>  
> +source "kernel/Kconfig.immediate"
> +
> +endmenu
> +
>  endmenu
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
