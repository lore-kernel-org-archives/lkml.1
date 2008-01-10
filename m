Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYAJUFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYAJUFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYAJUEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:04:54 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:40218 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYAJUEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:04:49 -0500
Subject: [x86] list of style offenders
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 10 Jan 2008 12:03:11 -0800
Message-Id: <1199995391.29897.26.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I was playing with checkpatch.pl ;) .. I made a list of style offenders
inside the arch/x86/ sub-directory. I thought it might be helpful to
prioritize any style clean ups that people might want to do for x86 ..
OTOH some of these might show imperfections in checkpatch.pl .. Either
way I thought it was interesting to review ..

These are sorted by errors, then warnings.. I only included the first
hundred files which includes about the top %30 of the list .. The
kprobes_64.c error rate is a little miss-leading because several errors
are found on a single line ..

./arch/x86/math-emu/fpu_trig.c
		total: 649 errors, 11 warnings, 1845 lines checked
./arch/x86/kernel/kprobes_64.c
		total: 528 errors, 9 warnings, 749 lines checked
./arch/x86/math-emu/reg_ld_str.c
		total: 392 errors, 17 warnings, 1375 lines checked
./arch/x86/kernel/kprobes_32.c
		total: 271 errors, 8 warnings, 756 lines checked
./arch/x86/math-emu/errors.c
		total: 214 errors, 28 warnings, 739 lines checked
./arch/x86/kernel/i387_32.c
		total: 203 errors, 10 warnings, 544 lines checked
./arch/x86/mach-voyager/voyager_cat.c
		total: 200 errors, 81 warnings, 1180 lines checked
./arch/x86/kernel/pci-gart_64.c
		total: 187 errors, 15 warnings, 748 lines checked
./arch/x86/math-emu/fpu_entry.c
		total: 168 errors, 12 warnings, 761 lines checked
./arch/x86/mach-voyager/voyager_smp.c
		total: 162 errors, 59 warnings, 1953 lines checked
./arch/x86/kernel/cpu/centaur.c
		total: 152 errors, 11 warnings, 471 lines checked
./arch/x86/kernel/process_64.c
		total: 119 errors, 21 warnings, 905 lines checked
./arch/x86/kernel/aperture_64.c
		total: 114 errors, 18 warnings, 299 lines checked
./arch/x86/crypto/aes_32.c
		total: 113 errors, 0 warnings, 515 lines checked
./arch/x86/kernel/traps_64.c
		total: 112 errors, 26 warnings, 1145 lines checked
./arch/x86/math-emu/reg_compare.c
		total: 107 errors, 0 warnings, 381 lines checked
./arch/x86/math-emu/reg_add_sub.c
		total: 104 errors, 2 warnings, 374 lines checked
./arch/x86/kernel/io_apic_32.c
		total: 97 errors, 70 warnings, 2890 lines checked
./arch/x86/ia32/ia32_signal.c
		total: 96 errors, 11 warnings, 617 lines checked
./arch/x86/math-emu/get_address.c
		total: 93 errors, 0 warnings, 438 lines checked
./arch/x86/kernel/traps_32.c
		total: 91 errors, 22 warnings, 1223 lines checked
./arch/x86/ia32/sys_ia32.c
		total: 87 errors, 79 warnings, 889 lines checked
./arch/x86/oprofile/op_model_p4.c
		total: 86 errors, 10 warnings, 722 lines checked
./arch/x86/ia32/ptrace32.c
		total: 81 errors, 8 warnings, 404 lines checked
./arch/x86/kernel/e820_64.c
		total: 78 errors, 32 warnings, 751 lines checked
./arch/x86/kernel/setup_64.c
		total: 74 errors, 10 warnings, 1192 lines checked
./arch/x86/kernel/mpparse_32.c
		total: 73 errors, 36 warnings, 1132 lines checked
./arch/x86/mm/k8topology_64.c
		total: 72 errors, 6 warnings, 182 lines checked
./arch/x86/kernel/mpparse_64.c
		total: 69 errors, 27 warnings, 865 lines checked
./arch/x86/math-emu/reg_divide.c
		total: 69 errors, 2 warnings, 207 lines checked
./arch/x86/mm/init_64.c
		total: 68 errors, 18 warnings, 783 lines checked
./arch/x86/lib/mmx_32.c
		total: 68 errors, 3 warnings, 403 lines checked
./arch/x86/kernel/vm86_32.c
		total: 66 errors, 16 warnings, 841 lines checked
./arch/x86/lib/usercopy_32.c
		total: 63 errors, 2 warnings, 882 lines checked
./arch/x86/pci/irq.c
		total: 62 errors, 83 warnings, 1212 lines checked
./arch/x86/boot/compressed/misc_32.c
		total: 62 errors, 8 warnings, 382 lines checked
./arch/x86/kernel/signal_64.c
		total: 61 errors, 16 warnings, 493 lines checked
./arch/x86/boot/compressed/misc_64.c
		total: 61 errors, 8 warnings, 371 lines checked
./arch/x86/oprofile/nmi_int.c
		total: 60 errors, 10 warnings, 477 lines checked
./arch/x86/kernel/ptrace_64.c
		total: 58 errors, 10 warnings, 621 lines checked
./arch/x86/math-emu/poly_l2.c
		total: 58 errors, 0 warnings, 272 lines checked
./arch/x86/kernel/cpu/common.c
		total: 57 errors, 15 warnings, 733 lines checked
./arch/x86/kernel/apm_32.c
		total: 56 errors, 31 warnings, 2403 lines checked
./arch/x86/math-emu/load_store.c
		total: 55 errors, 1 warnings, 272 lines checked
./arch/x86/mm/numa_64.c
		total: 54 errors, 13 warnings, 648 lines checked
./arch/x86/kernel/cpu/mtrr/main.c
		total: 53 errors, 23 warnings, 760 lines checked
./arch/x86/math-emu/poly_sin.c
		total: 53 errors, 1 warnings, 397 lines checked
./arch/x86/lib/csum-wrappers_64.c
		total: 51 errors, 6 warnings, 135 lines checked
./arch/x86/ia32/ia32_aout.c
		total: 50 errors, 18 warnings, 528 lines checked
./arch/x86/kernel/io_apic_64.c
		total: 49 errors, 51 warnings, 2290 lines checked
./arch/x86/kernel/cpu/cyrix.c
		total: 49 errors, 11 warnings, 463 lines checked
./arch/x86/kernel/i8259_64.c
		total: 48 errors, 4 warnings, 502 lines checked
./arch/x86/mm/fault_64.c
		total: 47 errors, 9 warnings, 623 lines checked
./arch/x86/kernel/setup64.c
		total: 45 errors, 16 warnings, 295 lines checked
./arch/x86/lib/string_32.c
		total: 45 errors, 0 warnings, 237 lines checked
./arch/x86/kernel/cpu/amd.c
		total: 42 errors, 26 warnings, 342 lines checked
./arch/x86/kernel/mca_32.c
		total: 42 errors, 3 warnings, 469 lines checked
./arch/x86/ia32/ia32_binfmt.c
		total: 41 errors, 5 warnings, 285 lines checked
./arch/x86/math-emu/poly_atan.c
		total: 41 errors, 0 warnings, 229 lines checked
./arch/x86/math-emu/poly_tan.c
		total: 40 errors, 0 warnings, 222 lines checked
./arch/x86/kernel/ptrace_32.c
		total: 39 errors, 11 warnings, 717 lines checked
./arch/x86/ia32/fpu32.c
		total: 39 errors, 1 warnings, 183 lines checked
./arch/x86/kernel/cpu/intel.c
		total: 37 errors, 14 warnings, 346 lines checked
./arch/x86/mm/fault_32.c
		total: 37 errors, 11 warnings, 659 lines checked
./arch/x86/mm/pageattr_64.c
		total: 37 errors, 3 warnings, 255 lines checked
./arch/x86/mm/pageattr_32.c
		total: 37 errors, 3 warnings, 278 lines checked
./arch/x86/math-emu/reg_mul.c
		total: 37 errors, 0 warnings, 132 lines checked
./arch/x86/kernel/cpu/intel_cacheinfo.c
		total: 36 errors, 49 warnings, 832 lines checked
./arch/x86/oprofile/op_model_ppro.c
		total: 34 errors, 3 warnings, 192 lines checked
./arch/x86/oprofile/op_model_athlon.c
		total: 33 errors, 4 warnings, 190 lines checked
./arch/x86/kernel/cpu/mcheck/mce_64.c
		total: 33 errors, 2 warnings, 902 lines checked
./arch/x86/mach-voyager/voyager_basic.c
		total: 31 errors, 15 warnings, 331 lines checked
./arch/x86/math-emu/poly_2xm1.c
		total: 30 errors, 0 warnings, 156 lines checked
./arch/x86/boot/cpucheck.c
		total: 30 errors, 0 warnings, 262 lines checked
./arch/x86/kernel/smpboot_32.c
		total: 29 errors, 46 warnings, 1339 lines checked
./arch/x86/kernel/e820_32.c
		total: 29 errors, 36 warnings, 957 lines checked
./arch/x86/boot/compressed/relocs.c
		total: 28 errors, 48 warnings, 629 lines checked
./arch/x86/kernel/cpu/cpufreq/longhaul.h
		total: 28 errors, 0 warnings, 353 lines checked
./arch/x86/kernel/vmi_32.c
		total: 27 errors, 31 warnings, 988 lines checked
./arch/x86/kernel/signal_32.c
		total: 27 errors, 10 warnings, 663 lines checked
./arch/x86/math-emu/poly.h
		total: 26 errors, 1 warnings, 121 lines checked
./arch/x86/math-emu/fpu_etc.c
		total: 26 errors, 0 warnings, 143 lines checked
./arch/x86/kernel/smpboot_64.c
		total: 25 errors, 31 warnings, 1099 lines checked
./arch/x86/math-emu/fpu_aux.c
		total: 25 errors, 0 warnings, 204 lines checked
./arch/x86/kernel/cpu/cpufreq/powernow-k7.c
		total: 23 errors, 88 warnings, 701 lines checked
./arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
		total: 23 errors, 20 warnings, 633 lines checked
./arch/x86/math-emu/fpu_emu.h
		total: 23 errors, 3 warnings, 218 lines checked
./arch/x86/kernel/cpu/cpufreq/powernow-k7.h
		total: 23 errors, 0 warnings, 44 lines checked
./arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
		total: 22 errors, 8 warnings, 440 lines checked
./arch/x86/kernel/cpu/cpufreq/longhaul.c
		total: 21 errors, 36 warnings, 1027 lines checked
./arch/x86/kernel/smp_32.c
		total: 21 errors, 6 warnings, 711 lines checked
./arch/x86/kernel/pci-dma_64.c
		total: 21 errors, 3 warnings, 350 lines checked
./arch/x86/kernel/cpu/mcheck/p4.c
		total: 20 errors, 47 warnings, 254 lines checked
./arch/x86/pci/fixup.c
		total: 20 errors, 35 warnings, 493 lines checked
./arch/x86/mm/init_32.c
		total: 20 errors, 35 warnings, 848 lines checked
./arch/x86/kernel/summit_32.c
		total: 20 errors, 11 warnings, 180 lines checked
./arch/x86/mm/ioremap_32.c
		total: 20 errors, 7 warnings, 274 lines checked
./arch/x86/mach-generic/probe.c
		total: 20 errors, 7 warnings, 125 lines checked
./arch/x86/kernel/cpu/mcheck/p6.c
		total: 19 errors, 21 warnings, 119 lines checked
./arch/x86/kernel/reboot_64.c
		total: 19 errors, 5 warnings, 176 lines checked



