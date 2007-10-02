Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbXJBGS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbXJBGS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 02:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbXJBGSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 02:18:20 -0400
Received: from mx1.suse.de ([195.135.220.2]:46142 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbXJBGST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 02:18:19 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com
Subject: x86 patches was Re: -mm merge plans for 2.6.24
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Oct 2007 08:18:17 +0200
In-Reply-To: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
Message-ID: <p733awu6nva.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> 
> revert-x86_64-mm-cpa-einval.patch
> fix-x86_64-mm-sched-clock-share.patch
> agp-fix-race-condition-between-unmapping-and-freeing-pages.patch
> x86_64-mce-poll-at-idle_start-and-printk-fix.patch
> fix-x86_64-mm-unwinder.patch
> geode-mfgpt-support-for-geode-class-machines.patch
> geode-mfgpt-clock-event-device-support.patch
> x86_64-add-acpi-reboot-option.patch
> i386-convert-mm_context_t-semaphore-to-a-mutex.patch
> dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
> x86-make-io-apic-not-connected-pin-print-complete.patch
> intel_cacheinfo-misc-section-annotation-fixes.patch
> intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
> x86-use-num_online_nodes-to-get-physical-cpus-numbers-for.patch
> i386-stop-bogus-nmi-softlockup-warnings-in-show_mem.patch
> voyager-include-asm-smph-to-fix-compile-error.patch
> x86-64-disable-local-apic-timer-use-on-amd-systems-with-c1e.patch
> clockevents-remove-unused-inline-function.patch
> clockevents-allow-build-without-runtime-use.patch
> x86_64-consolidate-tsc-calibration.patch
> i386-prepare-sharing-hpet-code.patch
> i386-hpet-add-x8664-hpet-bits.patch
> i386-prepare-sharing-pit-code.patch
> x86_64-use-i386-i8253-h.patch
> x86_64-preparatory-apic-set-lvtt.patch
> x86_64-apic-remove-bogus-pit-synchronization.patch
> x86_64-apic-shuffle-calibration-around.patch
> x86_64-apic-calibration-remove-divisor.patch
> x86_64-apic-change-setup-calling-convention.patch
> x86_64-apic-remove-nested-irq-disable.patch
> x86_64-prep-idle-loop-for-dynticks.patch
> x86_64-apic-add-clockevents-functions.patch
> x86_64-convert-to-clockevents.patch
> x86_64-remove-unused-code.patch
> x86_64-cleanup-apic-c.patch
> x86_64-cleanup-apic-c-fix.patch
> x86_64-cleanup-apic-c-fix-2.patch
> jiffies-remove-unused-macros.patch
> acpi-remove-the-useless-ifdef-code.patch
> i386-pit-remove-the-useless-ifdefs.patch
> i386-hpet-sharing-optimize.patch
> ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
> ich-force-hpet-restructure-hpet-generic-clock-code.patch
> ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
> ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
> ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
> ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
> ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
> ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
> ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
> x86-fix-cpu_to_node-references.patch
> x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
> convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
> convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64.patch
> # convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch: busted
> convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch
> convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix.patch
> convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch
> convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64.patch

These are fine to me, but should not all go through my tree
because most changes are in other architectures.

> x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
> x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
> x86-acpi-use-cpu_physical_id.patch
> i386-visws-extern-inline-static-inline.patch
> i386-cleanup-struct-irqaction-initializers.patch
> x86_64-cleanup-struct-irqaction-initializers.patch
> asm-i386-ioh-fix-constness.patch
> optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
> optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-fix.patch
> hpet-force-enable-on-vt8235-37-chipsets.patch
> x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron.patch
> x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
> x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch
> x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is.patch
> x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-fix.patch
> voyager-dont-try-to-support-unprocessor-builds.patch
> x86_64-nx-bit-handling-in-change_page_attr.patch
> x86-64-calgary-fix-calgary=disable=busnum-for-calioc2.patch
> x86-64-calgary-get-rid-of-translate_phb.patch
> x86_64-vdso-linker-script-cleanup.patch
> x86_64-vdso-put-vars-in-rodata.patch
> x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch
> x86_64-nmi_watchdog-fix-to-be-more-like-i386.patch
> x86_64-nmi_watchdog-fix-to-be-more-like-i386-fix.patch
> pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2.patch
> 
>   Send to Andi

Did you resend it? I have nothing pending currently. I rejected
also quite a few of these.

The clockevents patches are not included in this; but given the recent
trouble i'm not 100% sure they are even ready yet.

> sparsemem-clean-up-spelling-error-in-comments.patch
> sparsemem-record-when-a-section-has-a-valid-mem_map.patch
> sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
> generic-virtual-memmap-support-for-sparsemem.patch
> generic-virtual-memmap-support-for-sparsemem-fix.patch
> generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
> generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
> generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
> generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
> x86_64-sparsemem_vmemmap-2m-page-size-support.patch
> x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
> x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
> ia64-sparsemem_vmemmap-16k-page-size-support.patch
> ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
> sparc64-sparsemem_vmemmap-support.patch
> sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
> ppc64-sparsemem_vmemmap-support.patch
> ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
> ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix.patch
> ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
> 
>   virtual memmap: merge

Hmm, need to recheck the x86_64 bits I think.

> memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
> memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
> memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
> memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
> # update-n_high_memory-node-state-for-memory-hotadd.patch: fold
> update-n_high_memory-node-state-for-memory-hotadd.patch
> update-n_high_memory-node-state-for-memory-hotadd-fix.patch
> memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
> memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
> memoryless-nodes-no-need-for-kswapd.patch
> memoryless-nodes-slab-support.patch
> memoryless-nodes-slub-support.patch
> memoryless-nodes-uncached-allocator-updates.patch
> memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
> memoryless-nodes-update-memory-policy-and-page-migration.patch
> memoryless-nodes-add-n_cpu-node-state.patch
> memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
> memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
> memoryless-nodes-fix-gfp_thisnode-behavior.patch
> memoryless-nodes-use-n_high_memory-for-cpusets.patch
> memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
> memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
> memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
> memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2-3.patch
> fix-panic-of-cpu-online-with-memory-less-node.patch
> 
>   Merge

At least I still believe the whole concept of memoryless node is dubious.


> maps2-add-proc-pid-pagemap-interface.patch

+ * For each page in the address space, this file contains one long
+ * representing the corresponding physical page frame number (PFN) or

The interface is clearly not compat clean at all

> x86_64-efi-boot-support-efi-frame-buffer-driver.patch
> x86_64-efi-boot-support-efi-boot-document.patch

This required changes from review I think. And the previous patch is useless
without a boot protocol.


-Andi
