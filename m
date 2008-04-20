Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbYDTOU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbYDTOU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758782AbYDTOUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:20:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758007AbYDTOUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:20:41 -0400
Date: Sun, 20 Apr 2008 07:20:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: -mm merge plans for 2.6.26
Message-Id: <20080420072053.6bcb7884.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These can be found at
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1



 mm-fix-possible-off-by-one-in-walk_pte_range.patch
 dz-test-after-postfix-decrement-fails-in-dz_console_putchar.patch
 disable-the-memory-controller-by-default-v3.patch
 disable-the-memory-controller-by-default-v3-fix.patch
 cgroup-fix-a-race-condition-in-manipulating-tsk-cg_list.patch
 rtc-pcf8583-build-fix.patch
 memcgroup-check-and-initialize-page-cgroup-in-memmap_init_zone.patch

Merge, and backport to 2.6.25.x

 hotplug-memory-remove-generic-__remove_pages-support.patch
 hotplug-memory-make-online_page-common.patch
 hotplug-memory-make-online_page-common-fix.patch
 aio-io_getevents-should-return-if-io_destroy-is-invoked.patch

Merge

 revert-set-relay-file-can-not-be-read-by-pread2.patch

Drop (grr)

 check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch

Linus spat this back.  We need to solve the acpi-vs-i2c resouce
conflict problem differently.

 acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
 acpi-fix-fadt-parsing.patch
 acpi-adjust-register-handling.patch
 acpi-adjust-_acpi_modulefunction_name-definitions.patch
 acpi-use-__init-on-everything-in-tables-tbfadtc.patch
 acpi-video-balcklist-fujitsu-lifebook-s6410.patch
 miscacpibacklight-compal-laptop-extras-3rd-try.patch
 acpi-check-a-return-value-correctly-in-acpi_power_get_context.patch
 thinkpad-acpi-fix-possible-null-pointer-dereference.patch

-> git-acpi

 arch-x86-mm-ioremapc-fix-printk-warnings.patch
 git-x86-fix-warning-in-arch-x86-kernel-vsmp_64c.patch
 x86_64-restore-mask_bits-in-msi-shutdown.patch
 arch-x86-video-fbdevc-add-module_license.patch
 x86-ptrace-pebs-support.patch
 x86-ptrace-pebs-support-warning-fix.patch

-> git-x86

 git-x86-hack-around-to-make-git-kgdb-build.patch
 git-x86-vs-git-kgdb-lite.patch

Already merged, I think.

 mm-only-enforce-acpi-resource-conflict-checks.patch

Hold

 git-agpgart-export-agp_generic_alloc_pages.patch
 git-agpgart-fix-type-confusion.patch
 git-agpgart-drivers-char-agp-i460-agpc-hacks.patch
 convert-drivers-char-agp-frontendc-to-use-unlocked_ioctl.patch
 agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch

-> git-agpgart

 git-arm-fix.patch
 arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch

-> git-arm

 audit-let-userspace-fully-control-tty-input-auditing.patch
 use-find_task_by_vpid-in-audit-code.patch

-> git-audit

 bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
 cifs-remove-global_extern-macro.patch
 cifs-suppress-warning.patch

-> git-cifs

 cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism.patch
 cpufreq-document-the-currently-undocumented-parts-of-the-sysfs-interface.patch
 allow-use-of-the-powersave-governor-as-the-default-one.patch

-> git-cpufreq

 rapidio-change-rio-function-mpc85xx_-to-fsl_.patch
 rapidio-add-rapidio-option-to-kernel-configuration.patch
 rapidio-move-include-asm-ppc-rioh-to-include-asm-powerpc-rioh.patch
 rapidio-add-rapidio-multi-mport-support.patch
 rapidio-add-of-tree-support-to-rapidio-controller-driver.patch
 rapidio-change-the-kernel-configurated-rapidio-system-size-to-auto-probing.patch
 rapidio-add-rapidio-node-into-mpc8641hpcn-dts-file.patch
 rapidio-add-rapidio-node-probing-into-mpc86xx_hpcn-board-id-table.patch
 rapidio-add-serial-rapidio-controller-support-which-includes-mpc8548-mpc8641.patch
 rapidio-add-rapidio-connection-info-print-out-and-re-training-for-break-connection.patch
 rapidio-add-memory-mapping-driver-to-rapidio.patch
 rapidio-add-rapidio-space-allocation-bitmap-arithmetic.patch
 rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
 rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch
 rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
 rapidio-change-rapidio-doorbell-source-and-target-id-field-to-16-bit.patch
 rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
 rapidio-fix-docbook-references.patch
 #
 powerpc-hotplug-memory-notifications-for-ppc.patch
 powerpc-update-lmb-for-hotplug-memory-add-remove.patch
 powerpc-provide-walk_memory_resource-for-ppc.patch
 macintosh-windfarm-fix-platform-driver-hotplug-coldplug.patch

-> git-powerpc

 sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch

Dunno.

 s2ram-warn-when-interrupts-should-be-disabled-but-are-not.patch

I think this needs to print additional information

 revert-git-drm.patch

WIll drop if it ever gets mended

 git-dvb-kconfig-fix.patch

-> git-dvb

 i2c-renesas-highlander-fpga-smbus-support.patch

-> i2c tree

 hdaps-invert-the-axes-for-hdaps-on-lenovo-r61i-thinkpads.patch
 adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
 adt7473-minor-documentation-update.patch

-> git-hwmon

 provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
 provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-update.patch
 time-close-small-window-for-vsyscall-time-inconsistencies.patch

These are still under discussion between John and Roman

 add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
 fix-typo-in-tick-broadcastc.patch
 #time-close-small-window-for-vsyscall-time-inconsistencies.patch: roman nack
 hrtimer-reduce-calls-to-hrtimer_get_softirq_time.patch

-> git-hrt

 git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
 gregkh-driver-ib-convert-struct-class_device-to-struct-device-vs-git-infiniband.patch

Merge in git-infiniband or the driver tree.

 input-fix-platform-driver-hotplug-coldplug.patch
 wistron_btns-add-support-for-fujitsu-siemens-amilo-pro-edition-v3505.patch
 elantech-touchpad-driver.patch
 maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
 input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
 input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
 touch-screen-driver-for-the-superh-migor-board.patch

-> git-input

 tags-add-menuconfig-symbols-as-well.patch
 kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch

-> git-kbuild

 ata-ide-fix-platform-driver-hotplug-coldplug.patch
 pata_atiixp-simplex-clear.patch

-> git-libata-all

 m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch

-> git-m32r

 fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

Merge in git-async-tx or git-powerpc

 mmc-use-shorter-equivalent-set_current_state.patch

-> git-mmc

 mtd-maps-document-mtd_physmap-module-name-in-kconfig.patch
 mtdoopsc-make-struct-oops_cxt-static-again.patch
 make-mtd-nand-cs553x_nandcpart_probes-static.patch
 jffs2-include-function-prototype-for-jffs2_ioctl.patch
 jffs2-fix-sparse-warning-in-nodemgmtc.patch
 jffs2-fix-sparse-warning-in-writec.patch
 jffs2-fix-sparse-warnings-in-gcc.patch
 block2mtd-logging-typo-fixes.patch
 jffs2-add-write-verify-on-dataflash.patch
 mtd-nor-add-support-for-the-st-m29w400db-flash-chip.patch
 mtd-replace-remaining-__function__-occurrences.patch
 mtd-prevent-physmap-from-causing-request_module-runaway-loop-modprobe-net-pf-1.patch
 jffs2-check-if-partition-is-marked-ro-on-remount.patch
 jffs2-check-if-partition-is-marked-ro-on-mount.patch
 mtd-nand-fix-possible-ooops-in-rfc_from4.patch
 jffs2-summary-allocation-dont-use-vmalloc.patch
 mtd-maps-fix-platform-driver-hotplug-coldplug.patch
 mtd-nand-fix-platform-driver-hotplug-coldplug.patch

-> git-mtd

 drivers-atm-use-time_before-time_before_eq-etc.patch
 drivers-net-appletalk-use-time_before-time_before_eq-etc.patch
 hci_usb-remove-code-obfuscation.patch
 hci_usbh-fix-hard-to-trigger-race.patch
 smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
 nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch

-> git-net

 forcedeth-power-down-phy-when-interface-is-down.patch
 forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
 sc92031-use-net_device-stats.patch
 ehea-fix-dlpar-memory-add-support-fix.patch
 sundance-set-carrier-status-on-link-change-events.patch
 forcedeth-new-backoff-implementation.patch
 net-drivers-fix-platform-driver-hotplug-coldplug.patch
 smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt.patch
 8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch

-> jeff -> git-net

 e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
 3x59x-fix-pci-resource-management.patch
 update-smc91x-driver-with-arm-versatile-board-info.patch

These were rejected.  Retain because iirc they fix real bugs.

 blackfin-replace-remaining-__function__-occurences.patch
 blackfin-add-include-boot-gitignore-files.patch

->git-blackfin

 nfs-replace-remaining-__function__-occurrences.patch
 fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
 nfs-fix-potential-null-pointer-dereference-v2.patch
 nfs-lsm-make-nfsv4-set-lsm-mount-options.patch

->git-nfs->git-nfsd

 ntfs-le_add_cpu-conversion.patch

->git-ntfs (is it still alive?)

 parisc-new-termios-definitions.patch
 parisc-replace-remaining-__function__-occurences.patch
 drivers-parisc-replace-remaining-__function__-occurrences.patch
 parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
 arch-parisc-kernel-unalignedc-use-time_-macros.patch

->git-parisc

 pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
 pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
 pcmcia-annotate-cb_alloc-with-__ref.patch
 pcmcia-replace-remaining-__function__-occurrences.patch
 alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex.patch
 drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch

Merge

 pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
 pcmcia-pccard-deadlock-fix.patch

Hold

 pci_alloc_child_bus-mustnt-be-__devinit.patch
 pci_scan_device-mustnt-be-__devinit.patch
 pci_bus_size_cardbus-mustnt-be-__devinit.patch
 pci_setup_bridge-mustnt-be-__devinit.patch
 pci-iommu-iotlb-flushing-speedup.patch

-> PCI tree

 pci-hotplug-construct-one-fakephp-slot-per-pci-slot.patch
 pci-hotplug-export-kobject_rename-for-pci_hotplug_core.patch
 pci-hotplug-introduce-pci_slot.patch
 pci-hotplug-acpi-pci-slot-detection-driver.patch

These still have problems

 add-rcu_assign_index-if-ever-needed.patch
 rcu-split-listh-and-move-rcu-protected-lists-into-rculisth.patch
 rculisth-use-the-rcu-api.patch
 rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch
 rcu-add-call_rcu_sched.patch
 rcu-add-memory-barriers-and-comments-to-rcu_check_callbacks.patch
 rcu-add-rcu_barrier_sched-and-rcu_barrier_bh.patch
 rcu-add-call_rcu_sched-and-friends-to-rcutorture.patch
 rcu-1q08-rcu-doc-update-add-call_rcu_sched.patch

->git-sched

 git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
 git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
 scsi-fix-platform-driver-hotplug-coldplug.patch
 #git-scsi-rc-fixes.patch
 dell-cerc-support-for-megaraid_mbox.patch
 scsi-fix-section-mismatch-in-aic94xx.patch
 if-0-ses_match_host.patch
 scsi-replace-remaining-__function__-occurrences.patch
 fusion-replace-remaining-__function__-occurrences.patch
 scsi-replace-__inline-with-inline.patch
 drivers-scsi-mvsasc-fix-build-warnings.patch
 mpt-remove-unused-struct-mpt_proc_entry_t.patch
 drivers-scsi-use-time_before-time_before_eq-etc.patch

->git-scsi-misc

 kconfig-cleanup-block-kconfig-help-descriptions.patch
 block-replace-remaining-__function__-occurrences.patch
 block-fix-memory-hotplug-and-bouncing-in-block-layer.patch
 block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
 block-fix-blk_register_queue-return-value.patch

->git-block

 sparc32-export-empty_zero_page.patch

->git-sparc64.patch

 fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
 usb-asix-add-buffalo-lua-u2-gt-10-100-1000.patch
 fix-gregkh-usb-usb-ohci-host-controller-resumes-leave-root-hub-suspended.patch
 fix-gregkh-usb-wusb-add-the-wireless-usb-stack-to-linux.patch
 uwb-seems-to-need-pci.patch

-> USB tree

 mm-only-b43-rewrite-lo-calibration.patch

 Hold

 xfs-suppress-uninitialized-var-warnings.patch

->git-xfs

 aes-x86_64-asm-implementation-optimization.patch

Hold

 xtensa-warn-about-including-asm-rwsemh-directly.patch
 xtensa-replace-remaining-__function__-occurences.patch
 xtensa-use-newer-__spin_lock_unlocked-macro.patch

->git-xtensa

 make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch

->rusty

 ext4-is-busted-on-m68k.patch

Hold

 #
 # mm
 #
 remove-set_migrateflags.patch
 remove-sparse-warning-for-mmzoneh.patch
 remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
 fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
 fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
 mmap_region-cleanup-the-final-vma_merge-related-code.patch
 mm-remove-nopage.patch
 make-swap_pte_to_pagemap_entry-static.patch
 mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
 mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
 mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
 mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
 mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
 mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
 mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
 mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
 mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
 mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
 mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
 mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
 mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify.patch
 mm-try-both-endianess-when-checking-for-endianess.patch
 hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
 mm-move-cache_line_size-to-linux-cacheh.patch
 mempolicy-convert-mpol-constants-to-enum.patch
 mempolicy-support-optional-mode-flags.patch
 mempolicy-support-optional-mode-flags-fix.patch
 mempolicy-add-mpol_f_static_nodes-flag.patch
 mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
 mempolicy-add-mpol_f_relative_nodes-flag.patch
 mempolicy-update-numa-memory-policy-documentation.patch
 mempolicy-move-rebind-functions.patch
 mempolicy-create-mempolicy_operations-structure.patch
 mempolicy-create-mempolicy_operations-structure-fix.patch
 mempolicy-small-header-file-cleanup.patch
 mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
 mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
 mm-make-mem_map-allocation-continuous-v2.patch
 mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
 mm-offset-align-in-alloc_bootmem.patch
 mm-make-reserve_bootmem-can-crossed-the-nodes.patch
 mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
 dmapool-enable-debugging-for-config_slub_debug_on-too.patch
 mm-save-some-bytes-in-mm_struct-by-filling-holes-on-64bit.patch
 fix-indentation.patch
 mm-rotate_reclaimable_page-cleanup.patch
 mm-make-early_pfn_to_nid-a-c-function.patch
 vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
 vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
 vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix.patch
 vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
 vmallocinfo-add-caller-information.patch
 vmallocinfo-add-caller-information-checkpatch-fixes.patch
 sparsemem-vmemmap-does-not-need-section-bits.patch
 kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
 page_mapping-add-ifdef-around-reference-to-swapper_space.patch
 pageflags-standardize-comment-inclusion-in-asm-offsetsh-and-fix-mips.patch
 pageflags-use-an-enum-for-the-flags.patch
 pageflags-get-rid-of-flags_reserved.patch
 pageflags-get-rid-of-flags_reserved-sparc64-fix.patch
 pageflags-introduce-macros-to-generate-page-flag-functions.patch
 pageflags-convert-to-the-use-of-new-macros.patch
 pageflags-use-proper-page-flag-functions-in-xen.patch
 pageflags-eliminate-pg_xxx-aliases.patch
 page-flags-handle-pg_uncached-like-all-other-flags.patch
 page-flags-add-pageflags_false-for-flags-that-are-always-false.patch
 mm-get-rid-of-__zone_count.patch
 pageflags_extended-and-separate-page-flags-for-head-and-tail.patch
 mm-remove-unused-max_nodes_shift.patch
 smaps-account-swap-entries.patch
 smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
 mm-introduce-vm_mixedmap.patch
 mm-introduce-pte_special-pte-bit.patch
 mm-introduce-pte_special-pte-bit-fix.patch
 mm-add-vm_insert_mixed.patch
 return-pfn-from-direct_access-for-xip.patch
 xip-support-non-struct-page-backed-memory.patch
 s390-implement-pte-special-bit.patch
 #s390-remove-struct-page-entries-for-dcss-memory-segments.patch: restore with git-s390
 vmcoreinfo-add-page-flags-values.patch
 hugetlb-vmstat-events-for-huge-page-allocations.patch
 hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch
 mempolicy-rename-mpol_free-to-mpol_put.patch
 mempolicy-rename-mpol_copy-to-mpol_dup.patch
 mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy.patch
 mempolicy-fixup-fallback-for-default-shmem-policy.patch
 mempolicy-rename-struct-mempolicy-policy-member-to-mode.patch
 mempolicy-mark-shared-policies-for-unref.patch
 mempolicy-document-setget_policy-vm_ops-apis.patch
 mempolicy-rework-mempolicy-reference-counting.patch
 mempolicy-use-mpol_preferred-for-system-wide-default-policy.patch
 mempolicy-mpol_preferred-cleanups-for-local-allocation.patch
 mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy.patch
 mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy-fix.patch
 mempolicy-clean-up-mpol-to-str-mempolicy-formatting.patch
 mempolicy-rework-shmem-mpol-parsing-and-display.patch
 mempolicy-support-mpol=local-tmpfs-mount-option.patch
 mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch
 mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
 mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
 mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
 hugetlbfs-architecture-header-cleanup.patch
 hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow.patch
 hugetlbfs-common-code-update-for-s390.patch
 memory-hotplug-register-section-node-id-to-free.patch
 memory-hotplug-align-memmap-to-page-size.patch
 memory-hotplug-make-alloc_bootmem_section.patch
 memory-hotplugallocate-usemap-on-the-section-with-pgdat.patch
 memory-hotplug-free-memmaps-allocated-by-bootmem.patch
 oom_kill-remove-unused-parameter-in-badness.patch
 mm-page_allocc-remove-hand-coded-get_order.patch
 mm-fix-broken-gfp_zone-with-__gfp_thisnode.patch
 mm-fix-misleading-__gfp_repeat-related-comments.patch
 page-allcoator-smarter-retry-of-costly-order-allocations.patch
 page-allocator-explicitly-retry-hugepage-allocations.patch

Merge

 memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch

Hold

 input-replace-remaining-__function__-occurrences.patch

->git-input

 vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
 vm-dont-run-touch_buffer-during-buffercache-lookups.patch

Hold

 #
 # security
 #
 capabilities-implement-per-process-securebits.patch
 capabilities-implement-per-process-securebits-warning-fix.patch
 capabilities-implement-per-process-securebits-fix.patch
 smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
 lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
 lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
 selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
 audit-final-renamings-and-cleanup-checkpatch-fixes.patch
 root_plug-use-cap_task_prctl.patch

Merge

 #
 # smack
 #
 smack-make-smk_cipso_doi-and-smk_unlbl_ambient.patch
 smack-use-cap_task_prctl.patch

Merge

 #
 # alpha
 #
 alpha-handle-kcalloc-failure.patch
 alpha-remove-remaining-__function__-occurences.patch
 alpha-replace-__inline-with-inline.patch
 arch-alpha-kernel-trapsc-use-time_-macros.patch
 arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
 alpha-teach-the-compiler-that-bug-doesnt-return.patch

Merge

 #
 # power management
 #
 power-replace-remaining-__function__-occurrences.patch

Merge

 #
 # m68k
 #
 m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch
 m68k-replace-remaining-__function__-occurences.patch

Merge

 #
 # cris
 #
 crisv10-prepare-for-bkl-push-down.patch
 cris-remove-redundant-display-of-free-swap-space-in-show_mem.patch

Merge

 #
 # uml
 #
 arch-um-kernel-um_archc-some-small-improvements.patch
 uml-replace-remaining-__function__-occurences.patch
 arch-um-os-linux-start_upc-various-improvements.patch
 uml-make-a-function-static.patch
 uml-remove-a-useless-function.patch
 uml-make-three-functions-static.patch
 uml-make-several-things-static.patch
 arch-um-os-linux-sys-i386-task_sizec-improve-a-bit.patch
 uml-clean-up-arch-um-drivers-ubd_kernc.patch

Merge

 #
 # Misc
 #
 make-dev-kmem-a-config-option.patch
 make-dev-kmem-a-config-option-fix.patch
 epoll-avoid-kmemcheck-warning.patch
 avoid-divides-in-bits_to_longs.patch
 fs-coda-remove-static-inline-forward-declarations.patch
 taint-kernel-after-warn_oncondition.patch
 adfs-work-around-bogus-sparse-warning.patch
 add-rusage_thread.patch
 coda-add-static-to-functions-in-dirc.patch
 befs-fix-sparse-warning-in-linuxvfsc.patch
 cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch
 cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch
 cpu-fix-section-mismatch-warnings-in-cpu_down.patch
 cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch
 fs-ramfs-extern-cleanup.patch
 fs-hfsplus-proper-externs.patch
 fs-freevxfs-proper-externs.patch
 make-__put_super-static.patch
 make-vfs_ioctl-static.patch
 fs-fs-writeback-make-2-functions-static.patch
 fs-drop_cachesc-make-2-functions-static.patch
 fs-aioc-make-3-functions-static.patch
 let-log_buf_shift-default-to-17.patch
 fs-timerfdc-should-include-linux-syscallsh.patch
 remove-generic_commit_write.patch
 make-fs-bufferccont_expand_zero-static.patch
 make-binfmt_flat-a-bool.patch
 remove-mca_is_adapter_used.patch
 autofs4-fix-sparse-warning-in-rootc.patch
 ipwireless-remove-dead-code.patch
 fs-remove-unused-fops-from-struct-char_device_struct.patch
 affs-handle-match_strdup-failure.patch
 hfs-handle-match_strdup-failure.patch
 hfsplus-handle-match_strdup-failure.patch
 lib-inflatec-handle-failed-malloc.patch
 simplify-initcall_debug-output.patch
 iomap-fix-64-bits-resources-on-32-bits.patch
 fs-affs-filec-use-bug_on.patch
 proper-__do_softirq-prototype.patch
 misc-phantom-add-compat-ioctl.patch
 misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
 misc-phantom-fix-poll.patch
 misc-phantom-consistent-whitespace.patch
 remove-the-macro-get_personality.patch
 exec-remove-argv_len-from-struct-linux_binprm.patch
 proper-extern-for-late_time_init.patch
 firmware-replace-remaining-__function__-occurrences.patch
 drivers-misc-replace-remaining-__function__-occurrences.patch
 sysrq-add-show-backtrace-on-all-cpus-function.patch
 sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
 sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
 drivers-block-floppyc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
 #n_tty-loss-of-sync-following-a-buffer-overflow.patch: alan dubious?
 codafs-fix-build-warning.patch
 kthread-call-wake_up_process-without-the-lock-being-held.patch
 binfmt_miscc-avoid-potential-kernel-stack-overflow.patch
 kernel-explicitly-include-required-header-files-under-kernel.patch
 remove-superfluous-include-of-stringh-from-percpuh.patch
 fs-binfmt_aoutc-use-printk_ratelimit.patch
 kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
 kbuild-move-files-that-dont-check-__kernel__.patch
 lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
 lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
 drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
 scripts-lindent-support-gnu-indent-v2210.patch
 gen_initramfs_listsh-fix-unportability.patch
 update-checkpatchpl-to-version-017.patch
 update-checkpatchpl-to-version-018.patch
 smbh-uses-struct-timespec-but-didnt-include-linux-timeh.patch

Mostly-merge, subject to re-review.

 utimensat-non-conformances-and-fixes.patch
 utimensat-non-conformances-and-fixes-checkpatch-fixes.patch

Needs input from Ulrich

 #
 # swiotlb
 #
 lib-swiotlbc-cleanups.patch
 swiotlb-use-iommu_is_span_boundary-helper-function.patch

Merge

 #
 # vfs
 #
 vfs-fix-lock-inversion-in-drop_pagecache_sb.patch
 vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch
 fs-inodec-use-hlist_for_each_entry.patch
 fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
 vfs-remove-lives_below_in_same_fs.patch
 xattr-add-missing-consts-to-function-arguments.patch

Merge

 isolate-ratelimit-from-printkc-for-other-use.patch
 isolate-ratelimit-from-printkc-for-other-use-update.patch
 add-warn_on_secs-macro.patch
 add-warn_on_secs-macro-simplification.patch
 add-warn_on_secs-macro-simplification-fix.patch
 add-warn_on_secs-macro-simplification-fix-fix.patch
 use-warn_on_secs-in-rcupreempth.patch

Merge

 #
 # initramfs
 #
 use-directly-kmalloc-and-kfree-in-init-initramfsc.patch

Merge

 #
 # ncpfs
 #
 ncpfs-add-prototypes-to-ncp_fsh.patch
 ncpfs-fix-sparse-warnings-in-ioctlc.patch
 ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch

Merge

 #
 # serial
 #
 serial-silence-section-mismatch-warnings-in-8250_pci.patch
 synclink-drivers-bool-conversion.patch
 char-make-functions-static-in-synclinkmpc.patch
 fix-tty-speed-handling-on-8250.patch
 uart_get_baud_rate-stop-mangling-termios.patch
 uart_get_baud_rate-stop-mangling-termios-fix.patch
 serial-add-vr41xx_siu_early_setup-for-serial-console.patch
 serial-add-vr41xx-siu-setup-for-serial-console.patch
 serial-8250-tighten-test-for-using-backup-timer.patch
 serial-use-time_before-time_before_eq-etc.patch
 atmel_serial-remove-duplicated-macro-definition.patch

Merge

 blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch

I have a note that this needs more work

 #
 # dmi
 #
 drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
 x86-configurable-dmi-scanning-code.patch


Merge

 dmi-clean-up-dmi-helper-declarations.patch

Apparently needs ia64 testing

 #
 # oprofile
 #
 oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
 oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch

Merge

 #
 # spi
 #
 spi-use-menuconfig-for-config_spi.patch
 spi-pxa2xx_spi-sparse-fixes.patch
 documentation-move-spidev_fdx-example-to-its-own-source-file.patch
 spi-replace-remaining-__function__-occurrences.patch
 atmel_spi-support-zero-length-transfer.patch
 spi-spi_imx-updates.patch

Merge

 #
 # mfd
 #
 sm501-add-uart-support.patch
 mfd-use-shorter-set_current_state.patch

Merge

 #
 # vt
 #
 vt-notifier-extension-for-accessibility.patch
 vt-notifier-extension-for-accessibility-checkpatch-fixes.patch

Merge

 #
 # kprobes
 #
 kprobes-prevent-probing-of-preempt_schedule.patch
 kprobes-prevent-probing-of-preempt_schedule-fix.patch
 kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch

Merge

 listh-add-list_singleton.patch
 listh-add-list_singleton-fix.patch
 kprobes-add-unregister_kprobes-for-batch-registration.patch
 kprobes-add-unregister_kprobes-for-batch-registration-fix.patch
 kprobes-add-unregister_kretprobes-for-batch-registration.patch
 kprobes-add-unregister_jprobes-for-batch-registration.patch
 kprobes-update-document-about-batch-registration.patch

Merge

 #
 # quota
 #
 quota-do-not-allow-setting-of-quota-limits-to-too-high-values.patch
 quota-remove-superfluous-dquot_off-in-fs-namespacec.patch
 quota-various-style-cleanups.patch
 quota-various-style-cleanups-checkpatch-fixes.patch
 quota-quota-core-changes-for-quotaon-on-remount.patch
 quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
 quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
 quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
 quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
 quota-quota-core-changes-for-quotaon-on-remount-quota-reiserfs-make-reiserfs-handle-quotaon-on-remount.patch
 quota-convert-stub-functions-from-macros-into-inlines.patch

Merge

 #
 # i4l
 #
 capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
 avm-fix-sparse-warning-using-integer-as-null-pointer.patch
 eicon-fix-sparse-integer-as-null-pointer-warnings.patch
 isdn-replace-remaining-__function__-occurrences.patch
 isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
 hisax-depend-on-config_pnp-not-__isapnp__.patch
 capifs-fix-memory-leak-on-remount.patch

Merge

 #
 # i2o
 #
 i2o-remove-static-inline-forward-declarations.patch

Merge

 #
 # xen
 #
 xen-make-blkif_getgeo-static.patch

->Jeremy I guess

 #
 # ecryptfs
 #
 remove-ecryptfs_header_cache_0.patch
 ecryptfs-replace-remaining-__function__-occurrences.patch
 ecryptfs-add-missing-lock-around-notify_change.patch
 ecryptfs-introduce-device-handle-for-userspace-daemon-communications.patch
 ecryptfs-integrate-ecryptfs-device-handle-into-the-module.patch
 ecryptfs-integrate-ecryptfs-device-handle-into-the-module-printk-fixes.patch
 ecryptfs-make-key-module-subsystem-respect-namespaces.patch
 ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns.patch
 ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns-fix.patch

Merge

 #
 # rtc
 #
 rtc-avoid-legacy-drivers-with-generic-framework.patch
 rtc-avoid-legacy-drivers-with-generic-framework-update.patch
 rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
 rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
 rtc-pcf8563-new-style-conversion.patch
 rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
 rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
 rtc-pcf8563-add-device-ids-table.patch
 rtc-x1205-new-style-conversion.patch
 rtc-x1205-new-style-conversion-checkpatch-fixes.patch
 rtc-silence-section-mismatch-warning-in-rtc-test.patch
 make-ds1511_rtc_readset_time-static.patch
 kerneldoc-for-linux-clkh.patch
 kerneldoc-for-linux-clkh-fix.patch
 rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path.patch
 #rtc-rtc-rs5c372-smbus-conversion-support.patch: david-b no like
 rtc-rtc-rs5c372-smbus-conversion-support.patch
 rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
 rtc-add-the-support-for-alarm-time-relative-to-current-time-in-sysfs.patch
 drivers-char-rtcc-use-time_before-time_before_eq-etc.patch
 rtc-replace-remaining-__function__-occurrences.patch

Merge

 #
 # gpio
 #
 gpiolib-better-rmmod-infrastructure.patch
 gpiolib-i2c-spi-drivers-handle-rmmod-better.patch
 gpio-define-gpio_is_valid.patch
 gpiolib-dynamic-gpio-number-allocation.patch
 gpiochip_reserve.patch
 gpiochip_reserve-fix.patch
 gpiochip_reserve-fix-2.patch

Merge

 #
 # fbdev
 #
 fbdev-make-the-best-fit-section-of-fb_find_mode-return-the-closest-matching-mode.patch
 #fb-add-support-for-foreign-endianness.patch: paulus wanted generalisation
 fb-add-support-for-foreign-endianness.patch
 fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness.patch
 fb-add-support-for-foreign-endianness-force-it-on.patch
 powerpc-offb-add-support-for-foreign-endianness.patch
 fbdev-use-div_round_up-or-roundup.patch
 pm2fb-correct-error-values-returned-from-probe-function.patch
 fbcon-replace-mono_col-macro-with-static-inline.patch
 fbcon-replace-mono_col-macro-with-static-inline-fix.patch
 x86-geode-msr-cleanup.patch
 x86-geode-add-virtual-systems-architecture-detection.patch
 gxfb-set-the-right-registers-to-tweak-the-sync-polarity.patch
 gxfb-dont-enable-the-crt-dacs-when-we-are-in-flatpanel-mode.patch
 gxfb-use-pci_device-for-gxfbs-pci-device-table.patch
 gxfb-replace-fbsize-config-option-with-a-module-parameter.patch
 gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
 gxfb-clean-up-register-definitions.patch
 gxfb-move-msr-bit-fields-into-gxfbh.patch
 gxfb-stop-sharing-code-with-gx1fb.patch
 gxfb-add-power-management-functionality.patch
 gxfb-add-power-management-functionality-fix.patch
 gxfb-add-power-management-functionality-update.patch
 pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
 pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
 fbmem-fix-con2fbmap-limit-check.patch
 free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
 pm2fb-change-option-mode-to-mode_option.patch
 tridentfb-change-option-mode-to-mode_option.patch
 pm3fb-change-option-mode-to-mode_option.patch
 update-modedbtxt-documentation-about-mode_option-parameter-change.patch
 vt8623fb-change-option-mode-to-mode_option.patch
 arkfb-add-option-mode_option.patch
 s3fb-add-option-mode_option.patch
 fbdev-add-removed-option-mode-to-keep-compatibility.patch
 drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
 radeonfb-use-pci-device-id-in-hex-for-name-string.patch
 radeonfb-fix-debug-option.patch
 radeonfb-drop-redundant-rtrace-macro.patch
 radeonfb-speed-up-the-i2c-buses.patch
 uvesafb-dont-treat-valid-modes-returned-by-fb_find_mode-as-errors.patch
 drivers-video-imsttfbc-add-missing-curly-brackets.patch
 savagefb-speed-up-the-i2c-bus.patch
 fbdev-vt8623fb-better-resume-from-str.patch
 fbdev-framebuffer_alloc-fixes.patch
 pxafb-un-nest-pxafb_parse_options-to-cleanup-the-coding-style-issue.patch
 pxafb-fix-various-coding-style-issues-for-pxafb.patch
 pxafb-purge-unnecessary-pr_debug-and-comments-from-pxafb.patch
 pxafb-sanitize-the-usage-of-ifdef-processing-pxafb-parameters.patch
 pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel.patch
 pxafb-introduce-struct-pxafb_dma_buff-for-palette-and-dma-descriptors.patch
 pxafb-introduce-register-independent-lcd-connection-type-for-pxafb.patch
 pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type.patch
 pxafb-introduce-lcd_readwritel-to-wrap-the-__raw_readwritel.patch
 pxafb-use-completion-for-lcd-disable-wait-code.patch
 pxafb-move-parallel-lcd-timing-setup-into-dedicate-function.patch
 pxafb-preliminary-smart-panel-interface-support.patch
 pxafb-preliminary-smart-panel-interface-support-update.patch
 atmel_lcdfb-dont-initialize-a-pre-allocated-framebuffer.patch
 atmel_lcdfb-suspend-resume-support.patch
 atmel_lcdfb-wiring-bgr-to-rgb-color-mode.patch
 atmel_lcdfb-adjust-fifo-size-for-at91sam9rl.patch
 lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
 lxfb-create-gp-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
 lxfb-clean-up-register-definitions.patch
 lxfb-clean-up-final-bits-of-df_regs.patch
 lxfb-rearrange-rename-msr-bitfields.patch
 lxfb-add-power-management-functionality.patch
 lxfb-add-power-management-functionality-fix.patch
 lxfb-add-power-management-functionality-update.patch
 lxfb-rename-kernel-arg-fbsize-to-vram.patch
 lxfb-disable-suspend-vt-switch-by-default.patch
 lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt.patch
 gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size.patch
 gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available.patch
 olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers.patch
 olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers-section-fix.patch
 nv-drop-useless-module-ifdefs.patch
 nv-drop-useless-config_pci-checks.patch
 nv-fix-sparse-noise.patch
 fbdev-powerpc-driver-for-freescale-8610-and-5121-diu.patch
 powerpc-add-diu-platform-code-for-mpc8610hpcd.patch
 fbdev-metronomefb-bugfix-v4.patch
 fbdev-hecubafb-bugfix-v4.patch
 fbdev-platforming-metronomefb-and-am200epd-v4.patch
 fbdev-platforming-hecubafb-and-n411-v4.patch
 drivers-video-uvesafbc-fix-error-path-memory-leak.patch
 fb-convert-proc-fb-to-seq_file-interface.patch
 fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
 fbdev-intelfb-add-support-for-the-intel-integrated-graphics-controller-965g-965gm.patch
 drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
 video-replace-remaining-__function__-occurrences.patch

Merge

 x86-olpc-add-one-laptop-per-child-architecture-support.patch
 x86-olpc-add-one-laptop-per-child-architecture-support-fix.patch
 x86-olpc-add-one-laptop-per-child-architecture-support-fix-2.patch

Probably merge.  There is at least one minorish issue.

 #
 # md
 #
 md-fix-integer-as-null-pointer-warnings-in-mdc.patch
 md-replace-remaining-__function__-occurrences.patch
 md-introduce-get_priority_stripe-to-improve-raid456-write-performance.patch
 md-raid5c-convert-simple_strtoul-to-strict_strtoul.patch
 raid-remove-leading-tab-on-printk-messages.patch
 raid-remove-trailing-space-from-printk-line.patch
 drivers-md-use-time_before-time_before_eq-etc.patch
 drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch

Merge

 #
 # pnp
 #
 pnp-skip-dev-protocol-null-checks.patch
 pnp-simplify-quirk-debug-output.patch
 pnp-use-dev_printk-for-quirk-messages.patch
 pnp-use-dev_printk-for-quirk-messages-fix.patch

Merge

 #
 # ext2
 #
 ext2-le_add_cpu-conversion.patch
 ext2-convert-byte-order-of-constant-instead-of-variable.patch
 ext2-improve-ext2_readdir-return-value.patch
 ext2-use-ext2_group_first_block_no.patch
 ext2-use-ext2_fsblk_t-type.patch
 fs-ext2-use-bug_on.patch
 ext2-replace-remaining-__function__-occurrences.patch
 ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch
 ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch

Merge

 #
 # ext3
 #
 ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
 ext3-convert-byte-order-of-constant-instead-of-variable.patch
 make-ext3_xattr_list-static.patch
 ext3-use-ext3_group_first_block_no.patch
 ext3-add-missing-ext3_journal_stop.patch
 ext3-use-ext3_get_group_desc.patch
 ext3-check-ext3_journal_get_write_access-errors.patch
 fs-ext3-use-bug_on.patch
 jbd-fix-the-way-the-b_modified-flag-is-cleared.patch
 jbd-fix-possible-journal-overflow-issues.patch
 ext3-fix-update-of-mtime-and-ctime-on-rename.patch
 ext3-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
 ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch
 ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
 ext3-fix-mount-messages-when-quota-disabled.patch
 ext3-replace-remaining-__function__-occurrences.patch
 jbd-replace-remaining-__function__-occurrences.patch

Merge

 #
 # ufs
 #
 ufs-e_add_cpu-conversion.patch
 ufs-replace-remaining-__function__-occurrences.patch
 ufs-remove-unused-fs64_add-and-fs64_sub.patch
 ufs-replace-__inline-with-inline.patch

Merge

 #
 # udf
 #
 udf-fix-sparse-warning-in-nameic.patch

->git-udf

 #
 # reiserfs
 #
 reiserfs-le_add_cpu-conversion.patch
 reiserfs-fix-sparse-warning-in-journalc.patch
 reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
 reiserfs-replace-remaining-__function__-occurrences.patch
 reiserfs-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch

Merge

 #
 # fat
 #
 fat_valid_media-remove-pointless-test.patch
 fat-detect-media-without-partition-table-correctly.patch
 fatfs-fix-build-warning-with-64k-page_size.patch

Merge

 #
 # documentation
 #
 kernel-doc-detect-prevent-duplicate-doc-section-names.patch
 kernel-doc-detect-trailing-kernel-doc-line-trash.patch
 documentation-build-source-files-in-documentation-sub-dir.patch
 documentation-build-source-files-in-documentation-sub-dir-update.patch
 documentation-build-source-files-in-documentation-sub-dir-disable.patch

Merge

 docbook-some-kernel-locking-fixes.patch

Need to check with Rusty

 #
 # cgroups
 #
 make-cgroup_enable_task_cg_lists-static.patch
 cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
 cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
 cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
 cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix.patch
 cgroup-api-files-add-res_counter_read_u64.patch
 cgroup-api-files-use-read_u64-in-memory-controller.patch
 cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
 cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
 cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
 cgroup-api-files-add-cgroup-map-data-type.patch
 cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
 cgroup-api-files-drop-mem_cgroup_force_empty.patch
 cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
 cgroup-api-files-make-cgroup_debug-default-to-off.patch
 cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods.patch
 cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file.patch
 cgroup-annotate-cgroup_init_subsys-with-__init.patch
 cgroup-switch-to-proc_create.patch
 cgroups-add-the-trigger-callback-to-struct-cftype.patch
 cgroups-implement-device-whitelist-v6.patch
 cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
 cgroups-implement-device-whitelist-v6-cleanups.patch
 cgroups-implement-device-whitelist-doc.patch
 cgroups-implement-device-whitelist-v6-fix.patch
 cgroups-use-a-hash-table-for-css_set-finding.patch
 cgroups-simplify-init_subsys.patch
 cgroups-remove-the-css_set-linked-list.patch
 cgroups-introduce-cft-read_seq-v2.patch
 cgroups-add-an-owner-to-the-mm_struct.patch

Merge

 #
 # memcgroup
 #
 memcgroup-add-the-max_usage-member-on-the-res_counter.patch
 add-a-document-describing-the-resource-counter-abstraction-v2.patch
 add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
 memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
 memcgroup-use-triggers-in-force_empty-and-max_usage-files.patch
 memcgroup-implement-failcounter-reset.patch
 memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
 memcg-remove-redundant-function-calls.patch
 memcgroup-make-the-memory-controller-more-desktop-responsive.patch
 use-vmalloc-for-mem_cgroup-allocation-v3.patch
 use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch

Merge

 #
 # cpusets
 #
 kernel-cpusetc-make-3-functions-static.patch
 cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch
 cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets.patch

Merge

 #
 # signals
 #
 remove-unused-variable-from-send_signal.patch
 turn-legacy_queue-macro-into-static-inline-function.patch
 consolidate-checking-for-ignored-legacy-signals.patch
 consolidate-checking-for-ignored-legacy-signals-simplify.patch
 signals-do_signal_stop-use-signal_group_exit.patch
 signals-do_group_exit-use-signal_group_exit-more-consistently.patch
 lock_task_sighand-add-rcu-lock-unlock.patch
 k_getrusage-dont-take-rcu_read_lock.patch
 do_task_stat-dont-take-rcu_read_lock.patch
 signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
 signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
 #signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch: Roland probs?
 signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
 signals-cleanup-security_task_kill-usage-implementation.patch
 signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch
 kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch
 handle_stop_signal-unify-partial-full-stop-handling.patch
 handle_stop_signal-use-the-cached-p-signal-value.patch
 get_signal_to_deliver-use-the-cached-signal-sighand-values.patch
 signals-send_sigqueue-dont-take-rcu-lock.patch
 signals-send_sigqueue-dont-forget-about-handle_stop_signal.patch
 signals-__group_complete_signal-cache-the-value-of-p-signal.patch
 signals-send_group_sigqueue-dont-take-tasklist_lock.patch
 signals-move-handle_stop_signal-into-send_signal.patch
 signals-do_tkill-dont-use-tasklist_lock.patch
 signals-do_tkill-dont-use-tasklist_lock-comment.patch
 signals-send_sig_info-dont-take-tasklist_lock.patch
 signals-microoptimize-the-usage-of-curr_target.patch
 signals-move-the-definition-of-__group_complete_signal-up.patch
 signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter.patch
 signals-use-__group_complete_signal-for-the-specific-signals-too.patch
 signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
 signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
 signals-join-send_sigqueue-with-send_group_sigqueue.patch
 signals-handle_stop_signal-dont-worry-about-sigkill.patch
 signals-cleanup-the-usage-of-print_fatal_signal.patch
 signals-fold-sig_ignored-into-handle_stop_signal.patch
 signals-fold-sig_ignored-into-handle_stop_signal-comment.patch
 signals-document-cld_continued-notification-mechanics.patch
 signals-document-cld_continued-notification-mechanics-more.patch
 signals-send_signal-be-paranoid-about-signalfd_notify.patch
 signals-check_kill_permission-check-session-under-tasklist_lock.patch
 signals-check_kill_permission-remove-tasklist_lock.patch
 signals-fix-sbin-init-protection-from-unwanted-signals.patch
 signals-de_thread-simplify-the-child_reaper-switching.patch
 signals-allow-the-kernel-to-actually-kill-sbin-init.patch
 signals-add-set_restore_sigmask.patch
 signals-set_restore_sigmask-tif_sigpending.patch
 signals-s390-renumber-tif_restore_sigmask.patch
 signals-ia64-renumber-tif_restore_sigmask.patch
 signals-use-have_set_restore_sigmask.patch
 signals-x86-ts_restore_sigmask.patch

Merge (whee)

 #
 # ptrace
 #
 ptrace-introduce-task_detached-helper.patch
 reparent_thread-use-same_thread_group.patch
 document-de_thread-with-exit_notify-connection.patch
 ptrace-introduce-ptrace_reparented-helper.patch
 ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
 ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch
 ptrace-allow-to-ptrace-sbin-init.patch
 ptrace_signal-subroutine.patch

Merge

 #
 # workqueues
 #
 workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
 workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
 cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch

Merge

 #
 # cpu hotplug
 #
 simplify-cpu_hotplug_begin-put_online_cpus.patch

Merge

 fs-ext4-use-bug_on.patch
 jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful.patch
 jbd2-fix-kernel-doc-notation.patch
 ext4-fix-wrong-gfp-type-under-transaction.patch
 ext4-replace-remaining-__function__-occurrences.patch
 jdb2-replace-remaining-__function__-occurrences.patch
 ext4-fix-update-of-mtime-and-ctime-on-rename.patch
 ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
 ext4-fix-mount-messages-when-quota-disabled.patch

->ext4 dudes

 #
 # dma
 #
 dma-add-dma_map_attrs-interfaces.patch
 dma-document-dma_map_attrs-interfaces.patch
 dma-ia64-update-ia64-machvecs-swiotlbc.patch
 ib-expand-ib_umem_get-prototype.patch
 doc-fix-dma-api-function-parameters.patch

Merge

 #
 # ipc
 #
 ipc-use-ipc_buildid-directly-from-ipc_addid.patch
 ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
 ipc-scale-msgmni-to-the-amount-of-lowmem.patch
 ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
 ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
 ipc-recompute-msgmni-on-memory-add--remove.patch
 ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
 ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
 ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
 ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch
 ipc-semaphores-code-factorisation.patch
 ipc-shared-memory-introduce-shmctl_down.patch
 ipc-message-queues-introduce-msgctl_down.patch
 ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch
 ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch
 ipc-get-rid-of-the-use-_setbuf-structure.patch
 ipc-introduce-ipc_update_perm.patch
 ipc-consolidate-all-xxxctl_down-functions.patch
 ipc-consolidate-all-xxxctl_down-functions-fix.patch
 ipc-add-definitions-of-ushort_max-and-others.patch
 ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
 ipc-sysvsem-implement-sys_unshareclone_sysvsem.patch
 ipc-sysvsem-force-unshareclone_sysvsem-when-clone_newipc.patch
 ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc.patch
 ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc-cleanup.patch

Merge

 #
 # ipmi
 #
 ipmi-hold-attn-until-upper-layer-ready.patch
 ipmi-run-to-completion-fixes.patch
 ipmi-run-to-completion-fixes-fix.patch
 ipmi-run-to-completion-fixes-checkpatch-fixes.patch
 ipmi-dont-grab-locks-in-run-to-completion-mode.patch
 ipmi-dont-grab-locks-in-run-to-completion-mode-fix.patch
 ipmi-dont-print-event-queue-full-on-every-event.patch
 ipmi-update-driver-version.patch
 ipmi-convert-locked-counters-to-atomics.patch
 ipmi-convert-locked-counters-to-atomics-convert-message-handler-defines-to-an-enum.patch
 ipmi-convert-locked-counters-to-atomics-in-the-system-interface.patch
 ipmi-convert-locked-counters-to-atomics-in-the-system-interface-convert-system-interface-defines-to-an-enum.patch
 ipmi-style-fixes-in-the-base-code.patch
 ipmi-style-fixes-in-the-system-interface-code.patch
 ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
 ipmi-style-fixes-in-the-misc-code.patch
 ipmi-remove-unused-target-and-action-in-makefile.patch
 ipmi-remove-write_proc-code.patch

Merge

 #
 # tty
 #
 amiserial-prepare-for-locking-relaxation-in-caller.patch
 cyclades-prepare-for-relaxed-locking-in-callers.patch
 epca-lock_kernel-push-down.patch
 esp-lock_kernel-push-down.patch
 isicom-prepare-for-lock_kernel-push-down.patch
 isicom-istallion-prepare-for-lock_kernel-pushdown.patch
 mxser-prepare-for-bkl-pushdown.patch
 riscom8-prepare-for-bkl-pushdown.patch
 rocket-prepare-for-bkl-pushdown.patch
 serial167-prepare-to-push-bkl-down-into-drivers.patch
 specialix-prepare-for-bkl-pushdown.patch
 stallion-prepare-for-bkl-push-down.patch
 sx-prepare-for-bkl-pushdown.patch
 synclink-series-prepare-for-bkl-pushdown.patch
 viocons-bkl-locking.patch
 vt_ioctl-prepare-for-bkl-push-down.patch
 isdn_tty-prepare-for-bkl-push-down.patch
 68360serial-note-that-there-isnt-any-info-mcr-locking.patch
 serial_core-prepare-for-bkl-push-down.patch
 tty-bkl-pushdown.patch
 tty-bkl-pushdown-fix.patch
 tty-bkl-pushdown-fix1.patch
 redo-locking-of-tty-pgrp.patch
 resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
 tty_io-fix-remaining-pid-struct-locking.patch
 tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
 tty_ioctl-locking-for-tty_wait_until_sent.patch
 tty_ioctl-soft-carrier-handling.patch
 tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch
 sxc-fix-printk-warnings-on-sparc32.patch

Merge

 #
 # elf
 #
 elf-use-ei_nident-instead-of-numeric-value.patch
 binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch
 #elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch: check mips
 elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch
 elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

Merge

 #
 # char
 #
 sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
 sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
 sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
 char-moxa-remove-static-isa-support.patch
 char-moxa-cleanup-module-param-passed-isa-init.patch
 char-moxa-pci-io-space-fixup.patch
 char-moxa-fix-tiocg-ssoftcar-param.patch
 char-moxa-add-firmware-loading.patch
 char-moxa-merge-c2xx-and-c320-firmware-loading.patch
 char-moxa-remove-port-port.patch
 char-moxa-remove-unused-port-entries.patch
 char-moxa-centralize-board-readiness.patch
 char-moxa-centralize-board-readiness-warning-fix.patch
 char-moxa-timer-cleanup.patch
 char-moxa-ioctl-cleanup.patch
 char-moxa-merge-2-poll-functions.patch
 char-moxa-cleanup-rx-tx.patch
 char-moxa-serialise-timer.patch
 char-moxa-rework-open-close.patch
 char-moxa-little-cleanup.patch
 char-moxa-remove-useless-tty-functions.patch
 char-moxa-introduce-moxa_is_320-macro.patch
 char-moxa-notify-about-board-readiness.patch
 char-moxa-update-credits.patch
 char-moxa-add-firmware-loading-fix.patch
 char-fix-sparse-shadowed-variable-warnings-in-espc.patch
 char-espc-fix-possible-double-unlock.patch
 char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
 cycladesc-fix-sparse-shadowed-variable-warnings.patch
 epcac-static-functions-and-integer-as-null-pointer-fixes.patch
 epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
 drivers-char-ip2-ip2mainc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
 char-ip2-macros-cleanup.patch
 istallion-tiocg-ssoftcar-handling-removal.patch
 cyclades-coding-style-review.patch
 char-rio-fix-cirrus-defines.patch
 drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

Merge

 #
 # tty again:
 #
 tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch
 s390-tty-prepare-for-put_char-to-return-success-fail.patch
 serial-m68k-put_char-returns.patch
 usb-gadget-switch-to-put_char-returning-int.patch
 amiserial-switch-put-char-to-return-success-fail.patch
 char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch
 mxser-switch-to-put_char-being-int.patch
 pcmcia-serial-to-int-put_char-method.patch
 riscom-rocket-switch-to-int-put_char-method.patch
 serial167-switch-to-int-put_char-method.patch
 specialix-switch-to-int-put_char-method.patch
 synclink-series-switch-to-int-put_char-method.patch
 consoles-switch-to-int-put_char-method.patch
 isdn-switch-to-int-put_char-method.patch
 pty-prepare-for-tty-ops-changes.patch
 pc300-update-to-tty_set_operations.patch
 serial-switch-the-serial-core-to-int-put_char-methods.patch
 isicom-bring-into-coding-style.patch
 isicom-bring-into-coding-style-fix.patch
 tty-the-big-operations-rework.patch
 tty-the-big-operations-rework-broke-wan-x25_asy-fix.patch
 tty-the-big-operations-rework-fix-2.patch
 tty-the-big-operations-rework-isicom-fix.patch
 tty-the-big-operations-rework-simserial-fix.patch
 strip-fix-up-strip-for-the-new-order.patch
 tty-the-big-operations-rework-vs-git-kgdb-light.patch
 tty-the-big-operations-rework-vs-kgdb-2.patch
 tty-fix-routine-name-in-ptmx_open.patch
 devpts-propagate-error-code-from-devpts_pty_new.patch
 devpts-factor-out-pty-index-allocation.patch
 devpts-factor-out-pty-index-allocation-fix.patch

Merge

 #
 # keys
 #
 keys-increase-the-payload-size-when-instantiating-a-key.patch
 keys-check-starting-keyring-as-part-of-search.patch
 keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
 keys-add-keyctl-function-to-get-a-security-label.patch
 keys-add-keyctl-function-to-get-a-security-label-fix.patch
 keys-switch-to-proc_create.patch
 keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch
 keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
 keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
 keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch
 keys-explicitly-include-required-slabh-header-file.patch
 keys-make-key_serial-a-function-if-config_keys=y.patch

Merge

 #
 # proc
 #
 proc-print-more-information-when-removing-non-empty-directories.patch
 procfs-task-exe-symlink.patch
 procfs-task-exe-symlink-fix.patch
 procfs-task-exe-symlink-fix-2.patch
 procfs-task-exe-symlink-fix-3.patch
 proc-switch-to-proc_create.patch
 procfs-mem-permission-cleanup.patch
 proc-simplify-locking-in-remove_proc_entry.patch
 proc-less-special-case-in-xlate-code.patch
 proc-drop-several-pde-valid-invalid-checks.patch
 proc-remove-proc_bus.patch
 proc-remove-proc_root_fs.patch
 proc-remove-proc_root_driver.patch
 proc-remove-proc_root-from-drivers.patch
 proc-switch-proc-bus-zorro-devices-to-seq_file-interface.patch
 proc-switch-proc-apm-to-seq_file-interface.patch
 proc-remove-proc-mac_iop.patch
 proc-switch-proc-bus-ecard-devices-to-seq_file-interface.patch
 proc-switch-proc-excite-unit_id-to-seq_file-interface.patch
 proc-switch-proc-irda-irnet-to-seq_file-interface.patch
 proc-convert-proc-bus-nubus-to-seq_file-interface.patch
 proc-switch-proc-ip2mem-to-seq_file-interface.patch
 proc-switch-proc-scsi-device_info-to-seq_file-interface.patch
 proc-remove-get_info-infrastructure.patch
 proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch
 proc-introduce-proc_create_data-to-setup-de-data.patch
 nfsd-use-proc_create-to-setup-de-proc_fops.patch
 nfs-use-proc_create-to-setup-de-proc_fops.patch
 afs-use-non-racy-method-for-proc-entries-creation.patch
 ext4-use-non-racy-method-for-proc-entries-creation.patch
 reiserfs-use-non-racy-method-for-proc-entries-creation.patch
 jbd2-use-non-racy-method-for-proc-entries-creation.patch
 sysvipc-use-non-racy-method-for-proc-entries-creation.patch
 mm-use-non-racy-method-for-proc-swaps-creation.patch
 sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
 zorro-use-non-racy-method-for-proc-entries-creation.patch
 samples-use-non-racy-method-for-proc-marker-example-creation.patch
 scsi-use-non-racy-method-for-proc-entries-creation.patch
 usb-use-non-racy-method-for-proc-entries-creation.patch
 s390-use-non-racy-method-for-proc-entries-creation.patch
 arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
 avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
 cris-use-non-racy-method-for-proc-system_profile-creation.patch
 ia64-use-non-racy-method-for-proc-entries-creation.patch
 parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
 powerpc-use-non-racy-method-for-proc-entries-creation.patch
 acpi-use-non-racy-method-for-proc-entries-creation.patch
 netdev-use-non-racy-method-for-proc-entries-creation.patch
 isdn-use-non-racy-method-for-proc-entries-creation.patch
 kernel-use-non-racy-method-for-proc-entries-creation.patch
 parisc-use-non-racy-method-for-proc-entries-creation.patch
 drivers-use-non-racy-method-for-proc-entries-creation.patch
 drivers-use-non-racy-method-for-proc-entries-creation-2.patch

Merge

 #
 # sysctl
 #
 sysctl-allow-embedded-targets-to-disable-sysctl_checkc.patch
 include-linux-sysctlh-remove-empty-else.patch
 sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
 sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
 sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch

Merge

 #
 # pid management
 #
 free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
 use-find_task_by_vpid-in-taskstats.patch
 deprecate-find_task_by_pid.patch
 deprecate-find_task_by_pid-warning-fix.patch
 pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
 pids-introduce-change_pid-helper.patch
 pids-sys_setpgid-use-change_pid-helper.patch
 pids-__set_special_pids-use-change_pid-helper.patch
 pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch.patch
 pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu.patch

Merge

 #
 # char
 #
 mxser-convert-large-macros-to-functions.patch

Merge

 #
 # edd
 #
 edd-add-default-mode-config_edd_off=n-override-with-edd=onoff.patch
 edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch

Merge

 #
 # nbd
 #
 nbd-allow-nbd-to-be-used-locally.patch
 nbd-add-partition-support.patch
 nbd-delete-superfluous-test-for-__gnuc__.patch

Merge

 #
 # ioctl
 #
 generalize-asm-generic-ioctlh-to-allow-overriding-values.patch

Merge

 #
 # aoe
 #
 remove-aoedev_isbusy.patch

Merge

 #
 # markers
 #
 make-marker_debug-static.patch

Merge

 #
 # namespaces
 #
 pidns-make-pid-level-and-pid_ns-level-unsigned.patch

Merge

 #
 # random
 #
 random-clean-up-checkpatch-complaints.patch
 random-clean-up-checkpatch-complaints-fix.patch
 random-consolidate-wakeup-logic.patch
 random-use-unlocked_ioctl.patch
 random-reuse-rand_initialize.patch
 random-improve-variable-naming-clear-extract-buffer.patch
 random-make-backtracking-attacks-harder.patch
 random-remove-cacheline-alignment-for-locks.patch
 random-eliminate-redundant-new_rotate-variable.patch
 random-remove-some-prefetch-logic.patch
 random-simplify-add_ptr-logic.patch
 random-make-mixing-interface-byte-oriented.patch
 random-simplify-and-rename-credit_entropy_store.patch
 random-add-async-notification-support-to-dev-random.patch

Merge

 mm-bdi-export-bdi-attributes-in-sysfs.patch
 mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
 mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
 mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
 mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
 mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
 mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
 mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
 mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
 mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
 mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
 mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
 mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
 mm-bdi-move-statistics-to-debugfs.patch

Merge

 mm-bdi-add-separate-writeback-accounting-capability.patch
 mm-bdi-export-bdi_writeout_inc.patch
 mm-bdi-export-bdi_writeout_inc-fix.patch
 mm-add-nr_writeback_temp-counter.patch
 mm-document-missing-fields-for-proc-meminfo.patch
 fuse-support-writable-mmap.patch
 fuse-support-writable-mmap-fix.patch
 fuse-clean-up-setting-i_size-in-write.patch
 fuse-implement-perform_write.patch
 fuse-update-file-size-on-short-read.patch

Merge

 reiserfs-use-open_bdev_excl.patch
 affs-be_add_cpu-conversion.patch
 hfs-hfsplus-be_add_cpu-conversion.patch
 quota-le_add_cpu-conversion.patch
 sysv-e_add_cpu-conversion.patch
 asm-futexh-should-include-linux-uaccessh.patch
 basic-braille-screen-reader-support.patch
 basic-braille-screen-reader-support-fixes.patch
 basic-braille-screen-reader-support-ppc-fix.patch
 basic-braille-screen-reader-support-doc.patch
 basic-braille-screen-reader-support-makefile-fix.patch

Merge

 printk-dont-read-beyond-string-arguments-terminating-zero.patch

Merge

 remove-duplicated-unlikely-in-is_err.patch

Merge

 relay-reset-consumed.patch
 trace-code-and-documentation.patch
 trace-sample.patch

Not sure.  I haven't seen much interest in this work.

 hfs-fix-warning-with-64k-page_size.patch
 hfsplus-fix-warning-with-64k-page_size.patch

Merge

 alloc_uid-cleanup.patch

Merge

 add-macros-similar-to-min-max-min_t-max_t.patch
 add-macros-similar-to-min-max-min_t-max_t-doc.patch
 ide-eliminate-fit-macro.patch
 ata-remove-fit-macro.patch
 b43-replace-limit_value-macro-with-clamp_val.patch
 b43legacy-replace-limit_value-macro-with-clamp_val.patch
 fuse-use-clamp-rather-than-nested-min-max.patch
 ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
 input-ff-memlessc-use-clamp_val-macro.patch
 dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch

Merge

 introduce-explicit-signed-unsigned-64bit-divide.patch
 convert-a-few-do_div-user.patch
 rename-div64_64-to-div64_u64.patch
 rename-div64_64-to-div64_u64-fix.patch
 rename-div64_64-to-div64_u64-mm.patch
 remove-div_long_long_rem.patch

Merge

 #
 # ntp
 #
 ntp-cleanup-ntpc.patch
 ntp-ntp4-user-space-bits-update.patch
 ntp-increase-time_freq-resolution.patch
 ntp-increase-time_offset-resolution.patch
 ntp-support-for-tai.patch
 ntp-rename-tick_length_shift-to-ntp_scale_shift.patch
 ntp-remove-current_tick_length.patch
 ntp-handle-leap-second-via-timer.patch

Merge

 #
 # idr
 #
 idr-create-idr_layer_cache-at-boot-time.patch
 idr-create-idr_layer_cache-at-boot-time-fix.patch
 idr-create-idr_layer_cache-at-boot-time-fix-fix.patch

Merge

 #
 # edac
 #
 edac-new-support-for-intel-3100-chipset.patch
 edac-add-e752x-parameter-for-sysbus_parity-selection.patch
 edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
 edac-use-the-shorter-list_head-for-brevity.patch
 edac-remove-unneeded-functions-and-add-static-accessor.patch
 edac-fix-module-initialization-on-several-modules-2nd-time.patch

Merge

 introduce-a-generic-__fls-implementation.patch
 implement-__fls-on-all-64-bit-archs.patch
 use-__fls-for-fls64-on-64-bit-archs.patch

Merge

 drivers-replace-remaining-__function__-occurrences.patch

Merge

 slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
 infrastructure-to-debug-dynamic-objects.patch
 debugobjects-add-documentation.patch
 debugobjects-add-timer-specific-object-debugging-code.patch
 add-hrtimer-specific-debugobjects-code.patch

Merge

 #
 # afs
 #
 afs-use-the-shorter-list_head-for-brevity.patch
 afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch
 afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself-try-3.patch

Merge

 #
 # parport
 #
 parport_pc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch

Merge

 #
 # tpm
 #
 tpm-fix-section-mismatch-warning.patch
 tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp.patch

Merge

 cpufreq-change-cpu-freq-arrays-to-per_cpu-variables.patch
 acpi-change-processors-from-array-to-per_cpu-variable.patch
 cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch
 net-remove-nr_cpus-arrays-in-net-core-devc-v2.patch

->subsystem maintainers

 #
 # ramdisk
 #
 modify-ramdisk-brd-device-to-be-able-to-manage-partitions.patch

Merge

 #
 # sysvfs
 #
 sysv-fs-remove-superfluous-check-for-__gnuc__-compiler.patch

Merge

 kernel-add-common-infrastructure-for-unaligned-access.patch
 kernel-move-arches-to-use-common-unaligned-access.patch
 drivers-block-use-get_unaligned_-helpers.patch
 hid-core-use-get_unaligned_-helpers.patch
 char-use-get_unaligned_-helpers.patch
 input-use-get_unaligned_-helpers.patch
 mmc-use-get-put_unaligned_-helpers.patch
 net-use-get-put_unaligned_-helpers.patch
 wireless-use-get-put_unaligned_-helpers.patch
 pcmcia-use-get-put_unaligned_-helpers.patch
 usb-use-get-put_unaligned_-helpers.patch
 video-use-get-put_unaligned_-helpers.patch
 fat-use-get-put_unaligned_-helpers.patch
 hfsplus-use-get-put_unaligned_-helpers.patch
 isofs-use-get-put_unaligned_-helpers.patch
 ncpfs-use-get-put_unaligned_-helpers.patch
 ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch

Merge

 omap_rng-minor-updates.patch

Merge

 #
 # relayfs:
 #
 relayfs-support-larger-relay-buffer-take-3.patch
 relayfs-support-larger-relay-buffer-take-3-cleanup.patch

Merge

 #
 # aio
 #
 aio-remove-misleading-comment-from-ioctx_lookup.patch

Merge

 add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
 x86-use-kbuildh.patch
 mips-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
 alpha-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
 ia64-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
 arm-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
 xtensa-use-kbuildh-macros-instead-of-defining-them-in-asm-offsetsc.patch
 sparc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
 avr32-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
 blackfin-use-kbuildh-instead-of-defining-macros-in-asm-macrosc.patch
 frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
 h8300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
 m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
 mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
 parisc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
 ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
 s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
 s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update.patch
 sh-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
 v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch

Merge

 mm-remove-remaining-__function__-occurances.patch
 block-remove-remaining-__function__-occurances.patch
 kernel-replace-remaining-__function__-occurances.patch
 lib-replace-remaining-__function__-occurances.patch
 afs-replace-remaining-__function__-occurrences.patch
 fs-replace-remaining-__function__-occurrences.patch
 drivers-char-replace-remaining-__function__-occurrences.patch
 serial-replace-remaining-__function__-occurrences.patch
 remove-ifdef-__kernel__-checks-from-unexported-headers.patch
 remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
 drop-the-exporting-of-empty-linux-byteorder-generich.patch

Merge

 reiser4...
 #
 # debug stuff
 #
 #kconfigneeded.patch
 make-sure-nobodys-leaking-resources.patch
 journal_add_journal_head-debug.patch
 #
 page-owner-tracking-leak-detector.patch
 proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
 #
 releasing-resources-with-children.patch
 nr_blockdev_pages-in_interrupt-warning.patch
 detect-atomic-counter-underflows.patch
 #slab-cache-shrinker-statistics.patch
 mm-debug-dump-pageframes-on-bad_page.patch
 make-frame_pointer-default=y.patch
 mutex-subsystem-synchro-test-module.patch
 slab-leaks3-default-y.patch
 put_bh-debug.patch
 add-debugging-aid-for-memory-initialisation-problems.patch
 shrink_slab-handle-bad-shrinkers.patch
 keep-track-of-network-interface-renaming.patch
 workaround-for-a-pci-restoring-bug.patch
 prio_tree-debugging-patch.patch
 single_open-seq_release-leak-diagnostics.patch
 add-a-refcount-check-in-dput.patch
 getblk-handle-2tb-devices.patch
 getblk-handle-2tb-devices-fix.patch
 undeprecate-pci_find_device.patch
 tg3-debugging.patch
 put_pid-make-sure-we-dont-free-the-live-pid.patch
 notify_change-callers-must-hold-i_mutex.patch
 #
 profile-likely-unlikely-macros.patch
 profile-likely-unlikely-macros-fix.patch
 likely_prof-changed-to-use-proc_create.patch
 likeliness-accounting-change-and-cleanup.patch
 proc-remove-proc_root-from-drivers-likelyprof.patch
 likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch
 #
 drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
 #
 w1-build-fix.patch

Hold

