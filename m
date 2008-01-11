Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbYAKADf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbYAKADf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 19:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYAKAD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 19:03:29 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:54736 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbYAKAD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 19:03:28 -0500
Subject: Re: [x86] list of style offenders
From: Daniel Walker <dwalker@mvista.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4d8e3fd30801101540l264068f1i2475f53d6ea11f70@mail.gmail.com>
References: <1199995391.29897.26.camel@imap.mvista.com>
	 <4d8e3fd30801101435l228a0d0ydd0174e4073400e6@mail.gmail.com>
	 <1200006481.29897.48.camel@imap.mvista.com>
	 <4d8e3fd30801101540l264068f1i2475f53d6ea11f70@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 16:01:48 -0800
Message-Id: <1200009708.29897.55.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 00:40 +0100, Paolo Ciarrocchi wrote:
> On Jan 11, 2008 12:08 AM, Daniel Walker <dwalker@mvista.com> wrote:
> 
> > The git logs also show that arch/x86/math-emu/fpu_trig.c hasn't been
> > modified since it was pull in on Oct. 11 ..
> 
> Daniel,
> are we looking at the same tree?
> fpu_trig.c has been modified (and cleaned up) by Ingo 35 hours ago:
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=history;f=arch/x86/math-emu/fpu_trig.c;h=ecd06680581c51cbb7631cd0240708e92d9ef919;hb=mm

Here's another set of, which shows significant improvement over the last
one..

./arch/x86/kernel/cpu/centaur.c
		total: 152 errors, 11 warnings, 471 lines checked
./arch/x86/crypto/aes_32.c
		total: 113 errors, 0 warnings, 515 lines checked
./arch/x86/kernel/traps_64.c
		total: 103 errors, 24 warnings, 1211 lines checked
./arch/x86/kernel/io_apic_32.c
		total: 97 errors, 69 warnings, 2889 lines checked
./arch/x86/kernel/traps_32.c
		total: 86 errors, 21 warnings, 1200 lines checked
./arch/x86/oprofile/op_model_p4.c
		total: 86 errors, 10 warnings, 722 lines checked
./arch/x86/kernel/process_64.c
		total: 70 errors, 19 warnings, 902 lines checked
./arch/x86/kernel/mpparse_32.c
		total: 69 errors, 36 warnings, 1137 lines checked
./arch/x86/kernel/mpparse_64.c
		total: 69 errors, 27 warnings, 865 lines checked
./arch/x86/lib/mmx_32.c
		total: 68 errors, 3 warnings, 403 lines checked
./arch/x86/mm/init_64.c
		total: 67 errors, 18 warnings, 763 lines checked
./arch/x86/kernel/vm86_32.c
		total: 64 errors, 16 warnings, 840 lines checked
./arch/x86/lib/usercopy_32.c
		total: 63 errors, 2 warnings, 882 lines checked
./arch/x86/pci/irq.c
		total: 61 errors, 83 warnings, 1224 lines checked
./arch/x86/boot/compressed/misc_32.c
		total: 61 errors, 8 warnings, 383 lines checked
./arch/x86/boot/compressed/misc_64.c
		total: 60 errors, 8 warnings, 378 lines checked
./arch/x86/kernel/cpu/common.c
		total: 57 errors, 15 warnings, 729 lines checked
./arch/x86/kernel/signal_64.c
		total: 55 errors, 14 warnings, 489 lines checked
./arch/x86/kernel/cpu/mtrr/main.c
		total: 53 errors, 23 warnings, 762 lines checked
./arch/x86/lib/csum-wrappers_64.c
		total: 51 errors, 6 warnings, 135 lines checked
./arch/x86/kernel/io_apic_64.c
		total: 49 errors, 50 warnings, 2384 lines checked
./arch/x86/kernel/cpu/cyrix.c
		total: 49 errors, 11 warnings, 461 lines checked
./arch/x86/mach-voyager/voyager_cat.c
		total: 46 errors, 49 warnings, 1199 lines checked
./arch/x86/lib/string_32.c
		total: 45 errors, 0 warnings, 237 lines checked
./arch/x86/kernel/setup64.c
		total: 43 errors, 16 warnings, 300 lines checked
./arch/x86/kernel/cpu/amd.c
		total: 42 errors, 26 warnings, 350 lines checked
./arch/x86/kernel/mca_32.c
		total: 42 errors, 3 warnings, 469 lines checked
./arch/x86/kernel/i8259_64.c
		total: 38 errors, 2 warnings, 510 lines checked
./arch/x86/kernel/cpu/intel.c
		total: 37 errors, 16 warnings, 368 lines checked
./arch/x86/kernel/cpu/intel_cacheinfo.c
		total: 36 errors, 49 warnings, 832 lines checked
./arch/x86/oprofile/op_model_ppro.c
		total: 34 errors, 3 warnings, 192 lines checked
./arch/x86/oprofile/op_model_athlon.c
		total: 33 errors, 4 warnings, 190 lines checked
./arch/x86/kernel/cpu/mcheck/mce_64.c
		total: 32 errors, 3 warnings, 899 lines checked
./arch/x86/boot/cpucheck.c
		total: 30 errors, 0 warnings, 262 lines checked
./arch/x86/kernel/smpboot_32.c
		total: 29 errors, 46 warnings, 1338 lines checked
./arch/x86/boot/compressed/relocs.c
		total: 28 errors, 48 warnings, 626 lines checked
./arch/x86/kernel/cpu/cpufreq/longhaul.h
		total: 28 errors, 0 warnings, 353 lines checked
./arch/x86/kernel/vmi_32.c
		total: 27 errors, 30 warnings, 1014 lines checked
./arch/x86/kernel/signal_32.c
		total: 27 errors, 10 warnings, 669 lines checked
./arch/x86/math-emu/errors.c
		total: 26 errors, 36 warnings, 689 lines checked
./arch/x86/math-emu/fpu_emu.h
		total: 25 errors, 3 warnings, 217 lines checked
./arch/x86/kernel/e820_32.c
		total: 24 errors, 34 warnings, 751 lines checked
./arch/x86/kernel/smpboot_64.c
		total: 24 errors, 30 warnings, 1119 lines checked
./arch/x86/kernel/cpu/cpufreq/powernow-k7.c
		total: 23 errors, 88 warnings, 701 lines checked
./arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
		total: 23 errors, 20 warnings, 633 lines checked
./arch/x86/kernel/cpu/cpufreq/powernow-k7.h
		total: 23 errors, 0 warnings, 44 lines checked
./arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
		total: 22 errors, 8 warnings, 440 lines checked
./arch/x86/kernel/cpu/cpufreq/longhaul.c
		total: 21 errors, 36 warnings, 1027 lines checked
./arch/x86/kernel/smp_32.c
		total: 21 errors, 6 warnings, 712 lines checked
./arch/x86/kernel/pci-dma_64.c
		total: 21 errors, 3 warnings, 349 lines checked
./arch/x86/pci/fixup.c
		total: 20 errors, 35 warnings, 493 lines checked
./arch/x86/kernel/summit_32.c
		total: 20 errors, 11 warnings, 180 lines checked
./arch/x86/mm/ioremap_32.c
		total: 20 errors, 7 warnings, 274 lines checked
./arch/x86/mach-generic/probe.c
		total: 20 errors, 7 warnings, 125 lines checked
./arch/x86/kernel/sys_i386_32.c
		total: 18 errors, 23 warnings, 263 lines checked
./arch/x86/kernel/cpu/mcheck/p4.c
		total: 17 errors, 34 warnings, 257 lines checked
./arch/x86/kernel/irq_32.c
		total: 17 errors, 5 warnings, 376 lines checked
./arch/x86/kernel/early_printk.c
		total: 17 errors, 3 warnings, 254 lines checked
./arch/x86/lib/csum-partial_64.c
		total: 17 errors, 1 warnings, 150 lines checked
./arch/x86/kernel/cpu/mtrr/generic.c
		total: 16 errors, 19 warnings, 508 lines checked
./arch/x86/kernel/cpu/mcheck/p6.c
		total: 16 errors, 13 warnings, 122 lines checked
./arch/x86/power/cpu.c
		total: 16 errors, 3 warnings, 133 lines checked
./arch/x86/kernel/cpu/perfctr-watchdog.c
		total: 15 errors, 7 warnings, 722 lines checked
./arch/x86/kernel/pci-calgary_64.c
		total: 15 errors, 6 warnings, 1586 lines checked
./arch/x86/kernel/sys_x86_64.c
		total: 15 errors, 3 warnings, 253 lines checked
./arch/x86/math-emu/fpu_system.h
		total: 15 errors, 2 warnings, 90 lines checked
./arch/x86/kernel/cpu/cpufreq/powernow-k8.c
		total: 14 errors, 104 warnings, 1316 lines checked
./arch/x86/kernel/microcode.c
		total: 14 errors, 15 warnings, 850 lines checked
./arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
		total: 14 errors, 5 warnings, 798 lines checked
./arch/x86/kernel/vsyscall_64.c
		total: 14 errors, 4 warnings, 346 lines checked
./arch/x86/kernel/cpu/transmeta.c
		total: 14 errors, 3 warnings, 116 lines checked
./arch/x86/kernel/cpu/cpufreq/elanfreq.c
		total: 13 errors, 7 warnings, 308 lines checked
./arch/x86/kernel/irq_64.c
		total: 13 errors, 5 warnings, 266 lines checked
./arch/x86/kernel/ptrace.c
		total: 13 errors, 4 warnings, 1546 lines checked
./arch/x86/kernel/module_64.c
		total: 13 errors, 2 warnings, 185 lines checked
./arch/x86/kernel/cpu/mcheck/mce_amd_64.c
		total: 13 errors, 1 warnings, 690 lines checked
./arch/x86/kernel/suspend_64.c
		total: 12 errors, 7 warnings, 316 lines checked
./arch/x86/kernel/nmi_64.c
		total: 12 errors, 4 warnings, 481 lines checked
./arch/x86/lib/bitstr_64.c
		total: 12 errors, 1 warnings, 28 lines checked
./arch/x86/kernel/cpu/proc.c
		total: 12 errors, 1 warnings, 196 lines checked
./arch/x86/boot/boot.h
		total: 12 errors, 1 warnings, 296 lines checked
./arch/x86/kernel/x8664_ksyms_64.c
		total: 11 errors, 31 warnings, 61 lines checked
./arch/x86/kernel/process_32.c
		total: 11 errors, 28 warnings, 871 lines checked
./arch/x86/kernel/acpi/boot.c
		total: 11 errors, 27 warnings, 1358 lines checked
./arch/x86/pci/mmconfig_64.c
		total: 11 errors, 2 warnings, 157 lines checked
./arch/x86/mm/hugetlbpage.c
		total: 11 errors, 0 warnings, 391 lines checked
./arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
		total: 10 errors, 33 warnings, 494 lines checked
./arch/x86/kernel/cpu/cpufreq/powernow-k6.c
		total: 10 errors, 13 warnings, 255 lines checked
./arch/x86/kernel/cpu/mtrr/centaur.c
		total: 10 errors, 4 warnings, 224 lines checked
./arch/x86/kernel/cpu/mcheck/p5.c
		total: 10 errors, 4 warnings, 53 lines checked
./arch/x86/mm/pgtable_32.c
		total: 10 errors, 3 warnings, 375 lines checked
./arch/x86/kernel/cpu/mcheck/mce_32.c
		total: 10 errors, 3 warnings, 90 lines checked
./arch/x86/lib/io_64.c
		total: 10 errors, 1 warnings, 23 lines checked
./arch/x86/pci/mmconfig_32.c
		total: 10 errors, 0 warnings, 148 lines checked
./arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
		total: 9 errors, 34 warnings, 423 lines checked
./arch/x86/mach-es7000/es7000plat.c
		total: 9 errors, 9 warnings, 307 lines checked
./arch/x86/kernel/i8259_32.c
		total: 9 errors, 9 warnings, 422 lines checked
./arch/x86/pci/common.c
		total: 9 errors, 8 warnings, 544 lines checked
./arch/x86/lib/bitops_64.c
		total: 9 errors, 8 warnings, 175 lines checked
./arch/x86/mm/ioremap_64.c
		total: 9 errors, 6 warnings, 194 lines checked


