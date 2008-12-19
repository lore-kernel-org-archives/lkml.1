Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbYLSABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbYLSABU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYLSAAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:00:34 -0500
Received: from relay1.sgi.com ([192.48.179.29]:59225 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751571AbYLSAAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:00:31 -0500
Message-Id: <20081219000029.540121000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Dec 2008 16:00:29 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] x86 cpumask: update more code to use new cpumask API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Patches for review only.  Will be pushed via one git conduit or another.

Pulled the following patches from:

http://ozlabs.org/~rusty/kernel/rr-2008-12-18-1.tar.bz2

 (*)	x86:speedstep-centrino-cleanup.patch
	cpumask:get-rid-of-CPUMASK_ALLOC-x86.patch
	cpumask:convert-acpi_processor-structs.patch
	cpumask:convert-drivers_acpi.patch
	cpumask:more-work_on_cpu.patch
	x86:use-cpumask_var_t-in-acpi_boot.c
	cpumask:percpu_alloc-nmi.patch
	cpumask:percpu_alloc-mce_64.patch

... and built/tested on x86_64

(* - already in linux-next/rr)

In addition, the following are OBSOLETE:

	x86:use-cpumask_next_zero.patch
	x86:io_apic-leak-fix.patch
	x86:add-NR_CPUS-sysfs


The files are either x86 or generic:

	arch/x86/kernel/acpi/boot.c
	arch/x86/kernel/acpi/cstate.c
	arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
	arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
	arch/x86/kernel/cpu/cpufreq/powernow-k8.c
	arch/x86/kernel/cpu/cpufreq/powernow-k8.h
	arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
	arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
	arch/x86/kernel/cpu/mcheck/mce_64.c
	arch/x86/kernel/cpu/mcheck/mce_amd_64.c
	arch/x86/kernel/nmi.c
	drivers/acpi/processor_core.c
	drivers/acpi/processor_perflib.c
	drivers/acpi/processor_throttling.c
	drivers/cpufreq/cpufreq.c
	drivers/cpufreq/cpufreq_conservative.c
	drivers/cpufreq/cpufreq_ondemand.c
	include/acpi/processor.h
	include/linux/cpufreq.h

-- 
