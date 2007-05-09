Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbXEIIX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbXEIIX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755779AbXEIIXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:23:38 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892AbXEIIX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:23:28 -0400
Date: Wed, 9 May 2007 01:23:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-mm2
Message-Id: <20070509012322.199f292b.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/


- git-acpi was temporarily dropped due to git conflicts which I didn't feel
  like fixing.

- So was git-kvm

- A handful of IDE patches were dropped due to compilation failures.  Bart
  may have fixed this since I last downloaded his tree..

- The adaptive readahead patches were dropped.  We're expecting a new, much
  simpler version of these.




Boilerplate:

- See the `hot-fixes' directory for any important updates to this patchset.

- To fetch an -mm tree using git, use (for example)

  git-fetch git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git tag v2.6.16-rc2-mm1
  git-checkout -b local-v2.6.16-rc2-mm1 v2.6.16-rc2-mm1

- -mm kernel commit activity can be reviewed by subscribing to the
  mm-commits mailing list.

        echo "subscribe mm-commits" | mail majordomo@vger.kernel.org

- If you hit a bug in -mm and it is not obvious which patch caused it, it is
  most valuable if you can perform a bisection search to identify which patch
  introduced the bug.  Instructions for this process are at

        http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt

  But beware that this process takes some time (around ten rebuilds and
  reboots), so consider reporting the bug first and if we cannot immediately
  identify the faulty patch, then perform the bisection search.

- When reporting bugs, please try to Cc: the relevant maintainer and mailing
  list on any email.

- When reporting bugs in this kernel via email, please also rewrite the
  email Subject: in some manner to reflect the nature of the bug.  Some
  developers filter by Subject: when looking for messages to read.

- Occasional snapshots of the -mm lineup are uploaded to
  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/ and are announced on
  the mm-commits list.




Changes since 2.6.21-mm1:


 origin.patch
 git-alsa.patch
 git-arm.patch
 git-avr32.patch
 git-dvb.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ia64.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mips.patch
 git-mtd.patch
 git-ubi.patch
 git-e1000.patch
 git-net.patch
 git-battery.patch
 git-ioat.patch
 git-parisc.patch
 git-r8169.patch
 git-selinux.patch
 git-pciseg.patch
 git-sh.patch
 git-scsi-misc.patch
 git-block.patch
 git-unionfs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-gccbug.patch

 git trees

-slab-introduce-krealloc.patch
-at91_cf-minor-fix.patch
-add-new_id-to-pcmcia-drivers.patch
-ide-cs-recognize-2gb-compactflash-from-transcend.patch
-serial-driver-pmc-msp71xx.patch
-rm9000-serial-driver.patch
-serial-define-fixed_port-flag-for-serial_core.patch
-mpsc-serial-driver-tx-locking.patch
-serial-serial_core-use-pr_debug.patch
-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
-safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
-use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
-proper-prototype-for-hugetlb_get_unmapped_area.patch
-mm-remove-gcc-workaround.patch
-slab-ensure-cache_alloc_refill-terminates.patch
-mm-make-read_cache_page-synchronous.patch
-fs-buffer-dont-pageuptodate-without-page-locked.patch
-allow-oom_adj-of-saintly-processes.patch
-introduce-config_has_dma.patch
-mm-slabc-proper-prototypes.patch
-add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch
-mm-simplify-filemap_nopage.patch
-add-unitialized_var-macro-for-suppressing-gcc-warnings.patch
-i386-add-ptep_test_and_clear_dirtyyoung.patch
-i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
-smaps-extract-pmd-walker-from-smaps-code.patch
-smaps-add-pages-referenced-count-to-smaps.patch
-smaps-add-clear_refs-file-to-clear-reference.patch
-readahead-improve-heuristic-detecting-sequential-reads.patch
-readahead-code-cleanup.patch
-slab-use-num_possible_cpus-in-enable_cpucache.patch
-slab-dont-allocate-empty-shared-caches.patch
-slab-numa-kmem_cache-diet.patch
-do-not-disable-interrupts-when-reading-min_free_kbytes.patch
-slab-mark-set_up_list3s-__init.patch
-cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch
-i386-use-page-allocator-to-allocate-thread_info-structure.patch
-tty_register_driver-only-allocate-tty-instances-when-defined.patch
-slub-core.patch
-slub-change-default-alignments.patch
-slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes.patch
-slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes-fix.patch
-powerpc-disable-slub-for-configurations-in-which-slab-page-structs-are-modified.patch
-make-page-private-usable-in-compound-pages-v1.patch
-optimize-compound_head-by-avoiding-a-shared-page.patch
-add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
-slub-fix-object-tracking.patch
-slub-enable-tracking-of-full-slabs.patch
-slub-validation-of-slabs-metadata-and-guard-zones.patch
-slub-add-min_partial.patch
-slub-add-ability-to-list-alloc--free-callers-per-slab.patch
-slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
-slub-remove-object-activities-out-of-checking-functions.patch
-slub-user-documentation.patch
-slub-add-slabinfo-tool.patch
-quicklists-for-page-table-pages.patch
-quicklist-support-for-sparc64.patch
-slob-handle-slab_panic-flag.patch
-include-kern_-constant-in-printk-calls-in-mm-slabc.patch
-mm-madvise-avoid-exclusive-mmap_sem.patch
-mm-remove-destroy_dirty_buffers-from-invalidate_bdev.patch
-mm-optimize-kill_bdev.patch
-mm-optimize-acorn-partition-truncate.patch
-slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
-kmem_cache-simplify-slab-cache-creation.patch
-slab-allocators-remove-multiple-alignment-specifications.patch
-fault-injection-fix-failslab-with-config_numa.patch
-mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
-oom-fix-constraint-deadlock.patch
-get_unmapped_area-handles-map_fixed-on-powerpc.patch
-get_unmapped_area-handles-map_fixed-on-alpha.patch
-get_unmapped_area-handles-map_fixed-on-arm.patch
-get_unmapped_area-handles-map_fixed-on-frv.patch
-get_unmapped_area-handles-map_fixed-on-i386.patch
-get_unmapped_area-handles-map_fixed-on-ia64.patch
-get_unmapped_area-handles-map_fixed-on-parisc.patch
-get_unmapped_area-handles-map_fixed-on-sparc64.patch
-get_unmapped_area-handles-map_fixed-on-x86_64.patch
-get_unmapped_area-handles-map_fixed-in-hugetlbfs.patch
-get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix.patch
-get_unmapped_area-handles-map_fixed-in-generic-code.patch
-get_unmapped_area-doesnt-need-hugetlbfs-hacks-anymore.patch
-slab-allocators-remove-slab_debug_initial-flag.patch
-slab-allocators-remove-slab_ctor_atomic.patch
-slab-allocators-remove-useless-__gfp_no_grow-flag.patch
-hugetlbfs-add-null-check-in-hugetlb_zero_setup.patch
-slob-fix-page-order-calculation-on-not-4kb-page.patch
-page-migration-only-migrate-pages-if-allocation-in-the-highest-zone-is-possible.patch
-return-eperm-not-echild-on-security_task_wait-failure.patch
-blackfin-arch.patch
-driver_bfin_serial_core.patch
-blackfin-patch-add-blackfin-support-in-smc91x.patch
-blackfin-on-chip-rtc-controller-driver.patch
-blackfin-blackfin-on-chip-spi-controller-driver.patch
-convert-h8-300-to-generic-timekeeping.patch
-h8300-generic-irq.patch
-h8300-add-zimage-support.patch
-round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
-alpha-fix-bootp-image-creation.patch
-alpha-prctl-macros.patch
-srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
-arm26-remove-useless-config-option-generic_bust_spinlock.patch
-fix-refrigerator-vs-thaw_process-race.patch
-swsusp-use-inline-functions-for-changing-page-flags.patch
-swsusp-do-not-use-page-flags.patch
-mm-remove-unused-page-flags.patch
-swsusp-fix-error-paths-in-snapshot_open.patch
-swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
-freezer-remove-pf_nofreeze-from-handle_initrd.patch
-swsusp-use-rbtree-for-tracking-allocated-swap.patch
-freezer-fix-racy-usage-of-try_to_freeze-in-kswapd.patch
-remove-software_suspend.patch
-power-management-change-sys-power-disk-display.patch
-kconfig-mentioneds-hibernation-not-just-swsusp.patch
-swsusp-fix-snapshot_release.patch
-swsusp-free-more-memory.patch
-remove-unused-header-file-arch-m68k-atari-atasoundh.patch
-spin_lock_unlocked-cleanup-in-arch-m68k.patch
-m68k-export-csum_partial_copy_from_user.patch
-remove-unused-header-file-drivers-serial-crisv10h.patch
-cris-check-for-memory-allocation.patch
-cris-remove-code-related-to-pre-22-kernel.patch
-uml-delete-unused-code.patch
-uml-formatting-fixes.patch
-uml-host_info-tidying.patch
-uml-mark-tt-mode-code-for-future-removal.patch
-uml-print-coredump-limits.patch
-uml-handle-block-device-hotplug-errors.patch
-uml-driver-formatting-fixes.patch
-uml-driver-formatting-fixes-fix.patch
-uml-network-interface-hotplug-error-handling.patch
-array_size-check-for-type.patch
-uml-move-sigio-testing-to-sigioc.patch
-uml-create-archh.patch
-uml-create-as-layouth.patch
-uml-move-remaining-useful-contents-of-user_utilh.patch
-uml-remove-user_utilh.patch
-uml-add-missing-__init-declarations.patch
-remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
-uml-improve-checking-and-diagnostics-of-ethernet-macs.patch
-uml-eliminate-temporary-buffer-in-eth_configure.patch
-uml-replace-one-element-array-with-zero-element-array.patch
-uml-fix-umid-in-xterm-titles.patch
-uml-speed-up-exec.patch
-uml-no-locking-needed-in-tlsc.patch
-uml-tidy-processc.patch
-uml-remove-page_size.patch
-uml-kernel_thread-shouldnt-panic.patch
-uml-tidy-fault-code.patch
-uml-kernel-segfaults-should-dump-proper-registers.patch
-uml-comment-early-boot-locking.patch
-uml-irq-locking-commentary.patch
-uml-delete-host_frame_size.patch
-uml-drivers-get-release-methods.patch
-uml-dump-registers-on-ptrace-or-wait-failure.patch
-uml-speed-up-page-table-walking.patch
-uml-remove-unused-x86_64-code.patch
-uml-start-fixing-os_read_file-and-os_write_file.patch
-uml-tidy-libc-code.patch
-uml-convert-libc-layer-to-call-read-and-write.patch
-uml-batch-i-o-requests.patch
-uml-send-pointers-instead-of-structures-to-i-o-thread.patch
-uml-send-pointers-instead-of-structures-to-i-o-thread-fix.patch
-uml-dump-core-on-panic.patch
-uml-dont-try-to-handle-signals-on-initial-process-stack.patch
-uml-change-remaining-callers-of-os_read_write_file.patch
-uml-formatting-fixes-around-os_read_write_file-callers.patch
-uml-remove-debugging-remnants.patch
-uml-rename-os_read_write_file_k-back-to-os_read_write_file.patch
-uml-aio-deadlock-avoidance.patch
-uml-speed-page-fault-path.patch
-uml-eliminate-a-piece-of-debugging-code.patch
-uml-more-page-fault-path-trimming.patch
-uml-only-flush-areas-covered-by-vma.patch
-uml-out-of-tmpfs-space-error-clarification.patch
-uml-virtualized-time-fix.patch
-uml-fix-prototypes.patch
-v850-generic-timekeeping-conversion.patch
-xtensa-strlcpy-is-smart-enough.patch
-cx88-video-build-fix.patch
-fix-ppp_deflate-issues-with-recent-zlib_inflate-changes.patch
-ehci-ps3-ohci-ps3-fix-compilation.patch
-rename-tanbac-tb0219-config.patch
-maintainer-change-for-connect-tech-inc.patch
-wm8750-typo-fix.patch
-wavefront-only-declare-isapnp-on-config_pnp.patch
-gregkh-driver-fix-uevent-show.patch
-gregkh-driver-platform-reorder-platform_device_del.patch
-gregkh-driver-doc-fix-wrong-identifier-name-in-documentation-driver-model-devrestxt.patch
-gregkh-driver-sysfs-printk-format-warning.patch
-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch
-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch
-fix-sysfs-rom-file-creation-for-bios-rom-shadows.patch
-jdelvare-i2c-i2c-04-kill-i2c_adapterclass_dev.patch
-jdelvare-i2c-i2c-05-i2c_adapter-devices-have-no-driver.patch
-jdelvare-i2c-i2c-07-i2c_register_driver-cleanup.patch
-jdelvare-i2c-i2c-08-shrink-i2c_client.patch
-jdelvare-i2c-i2c-09-i2c-class-attribute-cleanup.patch
-jdelvare-i2c-i2c-10-rename-dev_to_i2c_adapter.patch
-jdelvare-i2c-i2c-algo-bit-always-send-stop-before-leaving.patch
-jdelvare-i2c-i2c-add-smbus-block-read-emulation.patch
-jdelvare-i2c-i2c-algo-bit-emulate-smbus-block-read.patch
-jdelvare-i2c-i2c-parport-optimize-size.patch
-jdelvare-i2c-i2c-nforce2-add-mcp61-mcp65-support.patch
-jdelvare-i2c-clean-up-i2c-header-includes.patch
-jdelvare-i2c-scx200_acb-fix-pci-device-reference-count.patch
-jdelvare-i2c-i2c-parport-fix-race-on-unload.patch
-jdelvare-i2c-i2c-parport-light-to-platform-driver.patch
-jdelvare-i2c-i2c-elektor-to-isa-driver.patch
-jdelvare-i2c-i2c-pca-isa-to-isa-driver.patch
-jdelvare-i2c-i2c-01-i2c-stack-can-probe.patch
-jdelvare-i2c-i2c-02-i2c-stack-can-remove.patch
-jdelvare-i2c-i2c-03-i2c-document-probe-and-remove.patch
-jdelvare-i2c-i2c-04-i2c_board_info-and-i2c_new_device.patch
-jdelvare-i2c-i2c-05-i2c_add_numbered_adapter.patch
-jdelvare-i2c-i2c-06-export_symbol-cleanup.patch
-jdelvare-i2c-i2c-07-i2c_bit_add_numbered_bus.patch
-jdelvare-i2c-i2c-08-i2c_new_probed_device.patch
-jdelvare-i2c-i2c-09-document-i2c_new_device.patch
-jdelvare-i2c-i2c-isa-exports-only-to-i2c-isa.patch
-jdelvare-i2c-i2c-del-driver-returns-void.patch
-jdelvare-i2c-i2c-algo-sgi-cleanup.patch
-jdelvare-i2c-i2c-blackfin-new-bus-driver.patch
-jdelvare-i2c-i2c-omap-adapter-numbering.patch
-jdelvare-i2c-i2c-algo-bit-50-50-duty-cycle-4.patch
-jdelvare-i2c-i2c-algo-bit-improve-debug-4.patch
-jdelvare-i2c-i2c-pxa-clean-stop.patch
-jdelvare-i2c-i2c-add-smbus-block-read.patch
-jdelvare-i2c-i2c-use-menuconfig-objects.patch
-jdelvare-i2c-i2c-gpio-new-bus-driver.patch
-jdelvare-i2c-i2c-simtec-new-bus-driver.patch
-jdelvare-i2c-i2c-deprecate-specific-gpio-drivers.patch
-jdelvare-i2c-i2c-spin_lock_unlocked-cleanup.patch
-jdelvare-i2c-i2c-documentation-update.patch
-jdelvare-i2c-i2c-tiny-usb-new-driver.patch
-jdelvare-i2c-i2c-s3c2410-setup-time.patch
-jdelvare-i2c-i2c-s3c2410-fix-bug-in-releasing-driver.patch
-jdelvare-i2c-i2c-rpx-will-be-removed.patch
-jdelvare-hwmon-hwmon-smsc47m192-document-lpc47m292-support.patch
-jdelvare-hwmon-hwmon-request-regions.patch
-jdelvare-hwmon-hwmon-smsc47m1-add-lpc47m292-support.patch
-jdelvare-hwmon-hwmon-smsc47m1-drop-useless-lock.patch
-jdelvare-hwmon-hwmon-only-call-vid_which_vrm-when-needed.patch
-jdelvare-hwmon-hwmon-fix-vid-table.patch
-jdelvare-hwmon-hwmon-w83627hf-cleanups.patch
-jdelvare-hwmon-hwmon-w83627hf-to-platform-driver.patch
-jdelvare-hwmon-hwmon-sysfs-interface-add-fan-target.patch
-jdelvare-hwmon-hwmon-smsc47m1-to-platform-driver.patch
-jdelvare-hwmon-hwmon-smsc47m1-use-drvname-consistently.patch
-jdelvare-hwmon-hwmon-smsc47m1-use-dynamic-attributes.patch
-jdelvare-hwmon-hwmon-max6650-new-driver.patch
-jdelvare-hwmon-hwmon-lm78-to-platform-driver.patch
-jdelvare-hwmon-hwmon-lm78-less-client-centric.patch
-jdelvare-hwmon-hwmon-lm78-use-dynamic-attributes.patch
-jdelvare-hwmon-hwmon-lm75-use-dynamic-attributes.patch
-jdelvare-hwmon-hwmon-coretemp-new-driver.patch
-jdelvare-hwmon-hwmon-coretemp-documentation.patch
-jdelvare-hwmon-hwmon-ad7418-new-driver.patch
-jdelvare-hwmon-hwmon-ams-i2c-fix-read-retry-logic.patch
-jdelvare-hwmon-hwmon-ams-do-not-print-error-on-systems-without-apple-motion-sensor.patch
-jdelvare-hwmon-hwmon-w83781d-to-platform-driver.patch
-jdelvare-hwmon-hwmon-w83781d-conversions-cleanup.patch
-jdelvare-hwmon-hwmon-w83781d-less-client-centric.patch
-jdelvare-hwmon-hwmon-w83781d-use-dynamic-attributes.patch
-jdelvare-hwmon-hwmon-w83781d-deprecate-w83627hf.patch
-jdelvare-hwmon-hwmon-smsc47b397-to-platform-driver.patch
-jdelvare-hwmon-hwmon-smsc47b397-use-dynamic-attributes.patch
-spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
-kconfig-abort-configuration-with-recursive-dependencies.patch
-pata_icside-driver.patch
-ide-sl82c105-rework-pio-support-take2.patch
-ide-sl82c105-dma-support-code-cleanup-take4.patch
-ide-cmd64x-fix-multiword-and-remove-single-word-dma-support.patch
-ide-cmd64x-interrupt-status-fixes-take-2.patch
-ide-cmd64x-add_fix-enablebits-take-2.patch
-ide-cmd64x-procfs-code-fixes_cleanups-take-2.patch
-ide-cmd64x-use-interrupt-status-from-mrdmode-register-take-2.patch
-ide-aec62xx-fix-pio_dma-setup-issues.patch
-ide-ide-fix-cable-checks-take2.patch
-ide-alim15x3-pio-fallback-fix.patch
-ide-pdc202xx_new-enable-dma-for-all-atapi-devices.patch
-ide-pdc202xx_new-use-ide-tune-dma.patch
-ide-pdc202xx_old-rewrite-mode-programming-v2.patch
-ide-it821x-pio-mode-setup-fixes.patch
-ide-siimage-swdma-mask-fix.patch
-ide-ide-cris-fix-speedproc-and-swdma-mask.patch
-ide-ide-tune-dma-2.patch
-ide-ide-dma-enable.patch
-ide-ide-remove-ide-use-dma.patch
-hpt366-dont-check-enablebits-for-hpt36x.patch
-mips-drop-unnecessary-config_isa-from-rbtx49xx.patch
-ne-add-platform_driver.patch
-ne-misc-fixes-for-platform-driver.patch
-ne-add-needs_portlist-to-control-isa-auto-probe.patch
-ne-mips-use-platform_driver-for-ne-on-rbtx49xx.patch
-natsemi-improve-diagnostics-for-dspcfg-workaround.patch
-natsemi-allow-users-to-disable-workaround-for-dspcfg-reset.patch
-natsemi-allow-users-to-disable-workaround-for-dspcfg-reset-fix.patch
-atl1-use-dev_printk-macros.patch
-atl1-use-dev_printk-macros-fix.patch
-atl1-fix-whitespace-damage.patch
-netlink-remove-bogus-bug_on.patch
-input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
-bluetooth-add-sco-work-around-for-the-broadcom.patch
-git-nfs-printk-warning-fixes.patch
-gregkh-pci-pci-flush-msi-x-table-writes.patch
-gregkh-pci-pci-new-pci-e-reset-api.patch
-gregkh-pci-pciehp-event-handling-rework.patch
-gregkh-pci-pciehp-adapt-to-device-driver-model.patch
-gregkh-pci-pci-fix-multiple-definition-of-queue_pushbutton_work.patch
-gregkh-pci-pci-scatterlisth-needs-typesh.patch
-gregkh-pci-pci-cleanup-the-includes-of-linux-pcih.patch
-gregkh-pci-pci-kernel-doc-fix.patch
-gregkh-pci-pci-require-vendor-and-device-for-new_id.patch
-gregkh-pci-pci-do-not-mark-exported-functions-as-__devinit.patch
-gregkh-pci-pci-define-pci_request-release_regions-for-config_pci-n.patch
-gregkh-pci-pci-documentation-power-pcitxt-fix-copy-paste-error.patch
-gregkh-pci-msi-simplify-bug-handling-in-pci_disable_msi.patch
-gregkh-pci-msi-simplify-bug-handling-in-pci_disable_msix.patch
-gregkh-pci-msi-simplify-bug-handling-in-msi_remove_pci_irq_vectors-part-1.patch
-gregkh-pci-msi-simplify-bug-handling-in-msi_remove_pci_irq_vectors-part-2.patch
-gregkh-pci-msi-consolidate-msi-x-irq-freeing-code.patch
-gregkh-pci-msi-consolidate-bug_ons.patch
-gregkh-pci-msi-move-export_symbols-near-their-definition.patch
-gregkh-pci-msi-remove-msi_cache.patch
-gregkh-pci-msi-expand-pci_msi_supported.patch
-gregkh-pci-msi-consolidate-precondition-checks.patch
-gregkh-pci-msi-rename-pci_msi_supported-to-pci_msi_check_device.patch
-gregkh-pci-msi-add-an-arch_msi_check_device.patch
-gregkh-pci-pci-create-alloc_pci_dev-the-one-true-way-to-create-a-struct-pci_dev.patch
-gregkh-pci-pci-convert-to-alloc_pci_dev.patch
-gregkh-pci-msi-use-a-list-instead-of-the-custom-link-structure.patch
-gregkh-pci-msi-remove-dev-first_msi_irq.patch
-gregkh-pci-msi-introduce-arch_supports_msi-kconfig-option.patch
-gregkh-pci-msi-arch-must-connect-the-irq-and-the-msi_desc.patch
-gregkh-pci-msi-give-archs-the-option-to-allocate-all-msi-xs-at-once.patch
-gregkh-pci-msi-give-archs-the-option-to-free-all-msi-xs-at-once.patch
-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
-gregkh-pci-pci-the-overdue-removal-of-pci_module_init.patch
-gregkh-pci-pci-add-debug-information-to-resource-collision-message.patch
-gregkh-pci-pci-rpaphp-cleanup-flow-of-control-for-rpaphp_add_slot.patch
-gregkh-pci-pci-rpaphp-remove-global-num_slots-variable.patch
-gregkh-pci-pci-rpaphp-match-up-alloc-and-free-in-same-routine.patch
-gregkh-pci-pci-rpaphp-fix-a-memleak-slot-location-string-was-never-freed.patch
-gregkh-pci-pci-rpaphp-remove-un-needed-goto.patch
-gregkh-pci-pci-rpaphp-remove-a-function-that-does-nothing-but-wrap-debug-printk-s.patch
-gregkh-pci-pci-rpaphp-remve-another-call-that-is-a-wrapper.patch
-gregkh-pci-pci-rpaphp-remove-another-wrappered-function.patch
-gregkh-pci-pci-rpaphp-remove-a-call-that-does-nothing-but-a-pointer-lookup.patch
-gregkh-pci-pci-rpaphp-remove-setup_pci_slot.patch
-gregkh-pci-pci-rpaphp-remove-print_slot_pci_funcs.patch
-gregkh-pci-pci-rpaphp-remove-rpaphp_set_attention_status.patch
-gregkh-pci-pci-rpaphp-refactor-tail-call-to-rpaphp_register_slot.patch
-gregkh-pci-pci-rpaphp-rename-rpaphp_register_pci_slot-to-rpaphp_enable_slot.patch
-gregkh-pci-pci-rpaphp-document-find_php_slot.patch
-gregkh-pci-pci-rpaphp-document-is_php_dn.patch
-gregkh-pci-pci-rpaphp-use-pcibios_remove_pci_devices-symmetrically.patch
-gregkh-pci-pci-rpaphp-ensure-more-pcibios_add-pcibios_remove-symmetry.patch
-gregkh-pci-pci-rpaphp-remove-semaphores.patch
-gregkh-pci-zt5550-cpci-hotplug-driver-fix.patch
-gregkh-pci-use-menuconfig-objects-pcihotplug.patch
-gregkh-pci-pci-quirks-disable-msi-on-rs400-200-and-rs480.patch
-gregkh-pci-pci-free-resource-files-in-error-path-of-pci_create_sysfs_dev_files.patch
-megaraid-fix-warnings-when-config_proc_fs=n.patch
-pci_module_init-convertion-in-tmscsimc.patch
-drivers-scsi-megaraidc-replacing-yield-with-a.patch
-drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
-drivers-scsi-qla4xxx-possible-cleanups.patch
-drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
-cleanup-variable-usage-in-mesh-interrupt-handler.patch
-qla1280-use-dma_64bit_mask-instead-of-0ull.patch
-git-wireless-build-fix.patch
-x86_64-mm-defconfig-update.patch
-x86_64-mm-i386-defconfig-update.patch
-x86_64-mm-revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
-x86_64-mm-revert-x86_64-mm-add-genapic_force.patch
-x86_64-mm-revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
-x86_64-mm-optimize-fix-apic-mode-setup.patch
-x86_64-mm-always-use-physical-delivery-mode-on-8-cpus.patch
-x86_64-mm-remove-clustered-apic-mode.patch
-x86_64-mm-default-to-physical-mode-on-hotplug-cpu-kernels.patch
-x86_64-mm-adjustments-to-page-table-dump-during-oops-v4.patch
-x86_64-mm-adjust-inclusion-of-asm-fixmap_h.patch
-x86_64-mm-adjust-inclusion-of-asm-vsyscall32_h.patch
-x86_64-mm-consolidate-smp_send_stop.patch
-x86_64-mm-no-need-to-use-traditional-for-processing-asm-in-i386-kernel.patch
-x86_64-mm-mtrr-range-check-correction.patch
-x86_64-mm-pit_latch_buggy-has-no-effect.patch
-x86_64-mm-add-an-option-for-the-via-c7-which-sets-appropriate-l1-cache.patch
-x86_64-mm-probe_roms-cleanup.patch
-x86_64-mm-a-few-missing-entry_s-annotations.patch
-x86_64-mm-get-user-annotations.patch
-x86_64-mm-fix-i386-and-x86_64-fault-information-pollution.patch
-x86_64-mm-timer-prototype-cleanup.patch
-x86_64-mm-i386-make-nmi-use-perfctr1-for-architectural-perfmon-take-2.patch
-x86_64-mm-x86_64-make-nmi-use-perfctr1-for-architectural-perfmon-take-2.patch
-x86_64-mm-add-__init-to-probe_bigsmp.patch
-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
-x86_64-mm-number-of-cpus.patch
-x86_64-mm-fam10-oprofile.patch
-x86_64-mm-gcc3-options.patch
-x86_64-mm-update-__copy_to_user_inatomic.patch
-x86_64-mm-clean-up-mach_reboot_fixups.patch
-x86_64-mm-fix-usage-of-mtune-when-x86_generic=y-or-config_mcore2=y.patch
-x86_64-mm-remove-unused-set_seg_base.patch
-x86_64-mm-remove-duplicated-code-for-reading-control-registers.patch
-x86_64-mm-fix-cpu-mhz-reporting-on-constant_tsc-cpus.patch
-x86_64-mm-simplify-smp_call_function-by-using-common-implementation.patch
-x86_64-mm-reloc64-dma_ops-as-const.patch
-x86_64-mm-reloc64-assembly-safe-page_h-and-pgtable_h.patch
-x86_64-mm-reloc64-kill-temp-boot-pmds.patch
-x86_64-mm-reloc64-clean-up-the-early-boot-page-table.patch
-x86_64-mm-reloc64-fix-early-printk-to-use-standard-isa-mapping.patch
-x86_64-mm-reloc64-modify-copy_bootdata-to-use-virtual-addresses.patch
-x86_64-mm-reloc64-cleanup-segments.patch
-x86_64-mm-reloc64-add-efer-to-the-register-set-saved-by-save_processor_state.patch
-x86_64-mm-reloc64-64bit-pic-smp-trampoline.patch
-x86_64-mm-reloc64-get-rid-of-dead-code-in-suspend-resume.patch
-x86_64-mm-reloc64-wakeup_s-rename-registers-to-reflect-right-names.patch
-x86_64-mm-reloc64-wakeup_s-misc-cleanups.patch
-x86_64-mm-reloc64-64bit-acpi-wakeup-trampoline.patch
-x86_64-mm-reloc64-modify-discover_ebda-to-use-virtual-addresses.patch
-x86_64-mm-reloc64-remove-the-identity-mapping-as-early-as-possible.patch
-x86_64-mm-reloc64-move-swsusp-__pa-dependent-code-to-arch-portion.patch
-x86_64-mm-reloc64-do-not-use-virt_to_page-on-kernel-data-address.patch
-x86_64-mm-reloc64-__pa-and-__pa_symbol-address-space-separation.patch
-x86_64-mm-reloc64-relocatable-kernel-support.patch
-x86_64-mm-reloc64-build-time-checking.patch
-x86_64-mm-reloc64-extend-bzimage-protocol-for-relocatable-bzimage.patch
-x86_64-mm-reloc64-move-cpu-verification-code-to-common-file.patch
-x86_64-mm-cpufreq-not-configured.patch
-x86_64-mm-sched-clock-share.patch
-x86_64-mm-sched-clock64.patch
-x86_64-mm-block-reordering.patch
-x86_64-mm-uselib-aout.patch
-x86_64-mm-traps-style.patch
-x86_64-mm-set-hashdist_default-to-1-for-x86_64-numa.patch
-x86_64-mm-modpost-apic-related-warning-fixes.patch
-x86_64-mm-make-struct-vmi_ops-static.patch
-x86_64-mm-type-cast-clean-up-for-find_next_zero_bit.patch
-x86_64-mm-workaround-for-a-wmissing-prototypes-warning.patch
-x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch
-x86_64-mm-fix-ia32_binfmt_c-build-error.patch
-x86_64-mm-remove-extra-smp_processor_id-calling.patch
-x86_64-mm-make-simnow_init-static.patch
-x86_64-mm-vmi_pmd_clear-static.patch
-x86_64-mm-fix-gdts-number-of-quadwords-in-comment.patch
-x86_64-mm-configurable-fake-numa-node-sizes.patch
-x86_64-mm-split-remaining-fake-nodes-equally.patch
-x86_64-mm-fixed-size-remaining-fake-nodes.patch
-x86_64-mm-remove-constant_tsc-reporting-from-proc-cpuinfo-power-flags.patch
-x86_64-mm-fake-numa-for-cpusets-document.patch
-x86_64-mm-vdso_prelink-warning-fix.patch
-x86_64-mm-initialize-esp0-properly-all-the-time.patch
-x86_64-mm-introduce-load_tls-to-the-for-loop_.patch
-x86_64-mm-allow-i386-crash-kernels-to-handle-x86_64-dumps.patch
-x86_64-mm-add-command-line-length-to-boot-protocol.patch
-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
-x86_64-mm-use-per-cpu-gdt-immediately-upon-boot.patch
-x86_64-mm-clean-up-cpu_init.patch
-x86_64-mm-rename-boot_gdt_table-to-boot_gdt.patch
-x86_64-mm-rationalize-paravirt-wrappers.patch
-x86_64-mm-cpa-kerneltext.patch
-x86_64-mm-tighten-kernel-image-page-access-rights.patch
-x86_64-mm-get-rid-of-unused-variables.patch
-x86_64-mm-i386-eflags-header.patch
-x86_64-mm-remove-stext.patch
-x86_64-mm-remove-the-apm_rtc_is_gmt-config-option_.patch
-x86_64-mm-use-lru-instead-of-page-index-and-page-private-for-pgd-lists-management_.patch
-x86_64-mm-sys_ioperm-prototype-cleanup.patch
-x86_64-mm-remove-unexpected_io_apic.patch
-x86_64-mm-fix-vtime-vsyscall.patch
-x86_64-mm-vsyscall_gtod_data-diet-and-vgettimeofday-fix.patch
-x86_64-mm-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation_.patch
-x86_64-mm-adjust-edid-retrieval.patch
-x86_64-mm-fix-section-mismatch-compile-warning.patch
-x86_64-mm-cleanup-gdt-access.patch
-x86_64-mm-add-smp_ops-interface.patch
-x86_64-mm-add-machine_ops-interface-to-abstract-halting-and-rebooting.patch
-x86_64-mm-change-email-address.patch
-x86_64-mm-i386-nmi-extern.patch
-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
-x86_64-mm-fix-amd64-agp-aperture-validation.patch
-x86_64-mm-x86-64-eflags-header.patch
-x86_64-mm-fix-arithmetic-in-comment.patch
-x86_64-mm-vmalloc-32.patch
-x86_64-mm-clean-up-asm-i386-bugs_h.patch
-x86_64-mm-clean-up-identify_cpu.patch
-x86_64-mm-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
-x86_64-mm-make-compat_vdso-runtime-selectable_.patch
-x86_64-mm-clean-up-asm-x86_64-bugs_h.patch
-x86_64-mm-fam10-mwait-idle.patch
-x86_64-mm-use-menuconfig-objects-apm.patch
-x86_64-mm-update-smp_call_function-comments.patch
-x86_64-mm-mce-banks.patch
-x86_64-mm-allow-percpu-variables-to-be-page-aligned.patch
-x86_64-mm-msr-index.patch
-x86_64-mm-remove-smp_alt_instructions.patch
-x86_64-mm-allow-boot-time-disable-of-smp-altinstructions.patch
-x86_64-mm-fix-x86_64-compilation-with-debug_sig-on.patch
-x86_64-mm-x86-64-system-crashes-when-no-memory-populating-node-0.patch
-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
-x86_64-mm-paravirt-update-maintainers.patch
-x86_64-mm-paravirt-remove-config_debug_paravirt.patch
-x86_64-mm-paravirt-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
-x86_64-mm-paravirt-pagetable-accessors.patch
-x86_64-mm-paravirt-initial-pagetable.patch
-x86_64-mm-paravirt-fixmap.patch
-x86_64-mm-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
-x86_64-mm-paravirt-even-more-mm-hooks.patch
-x86_64-mm-paravirt-patch-site-rename.patch
-x86_64-mm-paravirt-pvops-offsets.patch
-x86_64-mm-paravirt-clobbers.patch
-x86_64-mm-paravirt-pvops-call.patch
-x86_64-mm-paravirt-documentation.patch
-x86_64-mm-paravirt-patch.patch
-x86_64-mm-paravirt-flush-others.patch
-x86_64-mm-paravirt-revert-map_pt_hook.patch
-x86_64-mm-paravirt-highmem.patch
-x86_64-mm-paravirt-flush-lazy-mmu-updates-on-kunmap_atomic.patch
-x86_64-mm-paravirt-lazy-use-enums.patch
-x86_64-mm-paravirt-wrapper-cleanup.patch
-x86_64-mm-paravirt-drop-unused-ptep_get_and_clear.patch
-x86_64-mm-deflate-stack-usage-in-lib-inflate_c.patch
-x86_64-mm-deflate-inflate_dynamic-too.patch
-x86_64-mm-page-align-the-gdt.patch
-x86_64-mm-convert-pda-into-the-percpu-section.patch
-x86_64-mm-cleanups-to-help-using-per-cpu-variables-from-asm.patch
-x86_64-mm-define-per_cpu_offset.patch
-x86_64-mm-fix-up-gdt-bugs.patch
-x86_64-mm-map-enough-initial-memory-to-create-lowmem-mappings.patch
-x86_64-mm-incremental-update-for-i386-and-x86-64-check_bugs.patch
-x86_64-mm-in-compat-mode-the-return-value-here-was-uninitialized_.patch
-x86_64-mm-paravirt-allow-boot-time-disable-of-paravirt_ops-patching.patch
-x86_64-mm-cleanup-arch-i386-kernel-cpu-mcheck-p4_c.patch
-x86_64-mm-vmi-now-that-the-vdso-can-be-relocated-we-can-support-it-in-vmi-configurations.patch
-x86_64-mm-vmi-kmap-atomic-pte.patch
-x86_64-mm-vmi-convert-vmi-timer-to-use-clock-events.patch
-x86_64-mm-paravirt-rename-parainstructions.patch
-x86_64-mm-paravirt-non-gpl-export.patch
-x86_64-mm-clean-up-elf-note-generation.patch
-x86_64-mm-mtrr-move-definitions-to-mtrr-h.patch
-x86_64-mm-mtrr-adds-mtrr_save_fixed_ranges-for-use-in-two-later-patches.patch
-x86_64-mm-mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap.patch
-x86_64-mm-mtrr-save-and-restore-the-fixed-range-mtrrs-of-the-bsp-when-suspending.patch
-x86_64-mm-mtrr-enable-support-for-fixed-range-iorrs-to-keep-rdmem-wrmem-in-sync.patch
-x86_64-mm-safeapic-safe_apic_wait_icr_idle-i386.patch
-x86_64-mm-safeapic-safe_apic_wait_icr_idle-x86_64.patch
-x86_64-mm-safeapic-use-safe_apic_wait_icr_idle-i386.patch
-x86_64-mm-safeapic-use-safe_apic_wait_icr_idle-x86_64.patch
-x86_64-mm-safeapic-use-safe_apic_wait_icr_idle-smpboot-i386.patch
-x86_64-mm-safeapic-use-safe_apic_wait_icr_idle-smpboot-x86_64.patch
-x86_64-mm-safeapic-__send_ipi_dest_field-i386.patch
-x86_64-mm-safeapic-__send_ipi_dest_field-x86_64.patch
-x86_64-mm-safeapic-use-safe_apic_wait_icr_idle-in-safe_apic_wait_icr_idle-i386.patch
-x86_64-mm-safeapic-use-safe_apic_wait_icr_idle-in-__send_ipi_dest_field-x86_64.patch
-x86_64-mm-fix-mtrr-sections.patch
-x86_64-mm-paravirt-add-a-sched_clock-paravirt_op.patch
-x86_64-mm-paravirt-fix-startup_ipi_hook-config-dependency.patch
-x86_64-mm-move-__vgetcpu_mode-__jiffies-to-the-vsyscall_2-zone.patch
-x86_64-mm-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined.patch
-x86_64-mm-machine-restart-replace-spin_lock_irqsave-with-spin_lock.patch
-x86_64-mm-clean-up-flush_tlb_others-fn.patch
-x86_64-mm-mce-amd-check-capability.patch
-x86_64-mm-auto-generate-syscall-max.patch
-x86_64-mm-skip-cache_free_alien-on-non-numa.patch
-x86_64-mm-remove-xtime_locking-around-cpufreq-notifier.patch
-x86_64-mm-vmi-pte-clear-optimization.patch
-x86_64-mm-pte-xchg-optimization.patch
-x86_64-mm-pte-simplify-ops.patch
-x86_64-mm-irqbalance-convert-to-the-kthread-api.patch
-x86_64-mm-unexport-cpu_llc_id.patch
-x86_64-mm-i386-fix-wrong-comment-for-syscall-stack-layout.patch
-x86_64-mm-ignore-vgacon-if-hardware-not-present.patch
-x86_64-mm-mce-interval.patch
-x86_64-mm-numa-possible-at-runtime.patch
-x86_64-mm-nmi-watchdog-ops.patch
-x86_64-mm-nmi-wd-ops-64bit.patch
-x86_64-mm-compat-ignore-ioctl.patch
-x86_64-mm-compat-siocgifcount.patch
-x86_64-mm-apic-timer-calibration.patch
 x86_64-mm-vdso.patch
-x86_64-mm-verify-cpu-symbolic.patch
-x86_64-mm-drop-traditional-for-boot.patch
-x86_64-mm-i386-drop-traditional-for-boot.patch
-x86_64-mm-i386-verify-cpu.patch
-x86_64-mm-i386-constant-cpufeatures.patch
-x86_64-mm-i386-alternative-io.patch
-x86_64-mm-i386-feature-sync-rdtsc.patch
-x86_64-mm-i386-feature-rdtscp.patch
-x86_64-mm-use-rdtscp-for-get-cycles-sync.patch
-x86_64-mm-disable-numa-for-single-node.patch
-x86_64-mm-i386-smpboot-cleanup.patch
-x86_64-mm-i386-remove-copy-user-bug.patch
-x86_64-mm-compat-decode-ioctl.patch
-x86_64-mm-remove-reordering.patch
-x86_64-mm-share-video-s.patch
-x86_64-mm-compat-ignore-fat-ioctl.patch
-x86_64-mm-errno-genapic.patch
-x86_64-mm-drop-annoying-e820-printks.patch
-x86_64-mm-white-space-fixes-in-i387_h.patch
-x86_64-mm-avoid-redundant-preempt_disable-in-__unlazy_fpu.patch
-x86_64-mm-fix-dontdiff.patch
-fix-x86_64-mm-mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap.patch
-x86-msr-add-support-for-safe-variants.patch
-increase-slab-redzone-to-64bits.patch
-mm-move-common-segment-checks-to-separate-helper-function-v7.patch
-fix-section-mismatch-of-memory-hotplug-related-code.patch
-add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section.patch
-use-slab_panic-flag-cleanup.patch
-uml-make-hostfs_setattr-support-operations-on-unlinked-open-files.patch
-uml-hostfs-style-fixes.patch
-uml-an-idle-system-should-have-zero-load-average.patch
-factor-outstanding-i-o-error-handling.patch
-block_write_full_page-handle-enospc.patch
-simplify-the-stacktrace-code.patch
-filesystem-disk-errors-at-boot-time-caused-by-probe.patch
-allow-access-to-proc-pid-fd-after-setuid.patch
-ext2-3-4-fix-file-date-underflow-on-ext2-3-filesystems-on-64-bit-systems.patch
-reduce-size-of-task_struct-on-64-bit-machines.patch
-fix-quadratic-behavior-of-shrink_dcache_parent.patch
-mm-shrink-parent-dentries-when-shrinking-slab.patch
-ipmi-add-powerpc-openfirmware-sensing.patch
-ipmi-allow-shared-interrupts.patch
-ipmi-add-new-ipmi-nmi-watchdog-handling.patch
-ipmi-add-pci-remove-handling.patch
-freezer-task-exit_state-should-be-treated-as-bolean.patch
-softlockup-trivial-s-99-max_rt_prio.patch
-fix-constant-folding-and-poor-optimization-in-byte-swapping.patch
-documentation-ask-driver-writers-to-provide-pm-support.patch
-use-symbolic-constants-in-generic-lseek-code.patch
-use-use-seek_max-to-validate-user-lseek-arguments.patch
-devpts-add-fsnotify-create-event.patch
-tty-clarify-documentation-of-write.patch
-drivers-char-hvc_consolec-cleanups.patch
-is_power_of_2-in-fat.patch
-is_power_of_2-in-fs-hfs.patch
-is_power_of_2-in-fs-block_devc.patch
-freevxfs-possible-null-pointer-dereference-fix.patch
-reiserfs-possible-null-pointer-dereference-during-resize.patch
-scripts-kernel-doc-whitespace-cleanup.patch
-fix-section-mismatch-warning-in-lib-swiotlbc.patch
-init-do_mountsc-proper-prepare_namespace-prototype.patch
-fix-compilation-of-drivers-with-o0.patch
-apple-smc-driver-hardware-monitoring-and-control.patch
-apple-smc-driver-hardware-monitoring-and-control-fix-names.patch
-apple-smc-driver-hardware-monitoring-and-control-cleanup.patch
-reiserfs-shrink-superblock-if-no-xattrs.patch
-module-use-krealloc.patch
-reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
-kconfig-centralize-the-selection-of-semaphore-debugging.patch
-irq-add-__must_check-to-request_irq.patch
-use-stop_machine_run-in-the-intel-rng-driver.patch
-cap-shmmax-at-int_max-in-compat-shminfo.patch
-exec-fix-remove_arg_zero.patch
-merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
-rcutorture-mark-rcu_torture_init-as-__init.patch
-init-dma-masks-in-pnp_dev.patch
-optimize-timespec_trunc.patch
-ext3-dirindex-error-pointer-issues.patch
-the-scheduled-removal-of-obsolete_oss-options.patch
-epoll-optimizations-and-cleanups.patch
-oss-strlcpy-is-smart-enough.patch
-add-filesystem-subtype-support.patch
-fix-race-between-proc_get_inode-and-remove_proc_entry.patch
-fix-race-between-proc_readdir-and-remove_proc_entry.patch
-proc-remove-pathetic-deleted-warn_on.patch
-vfs-remove-superflous-sb-==-null-checks.patch
-nameic-remove-utterly-outdated-comment.patch
-tpm_infineon-add-support-for-devices-in-mmio-space.patch
-replace-pci_find_device-in-drivers-telephony-ixjc.patch
-floppy-handle-device_create_file-failure-while-init.patch
-rocket-remove-modversions-include.patch
-virtual_eisa_root_init-should-be-__init.patch
-proc-maps-protection.patch
-remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
-remove-unused-header-file-drivers-char-digih.patch
-drivers-char-synclinkc-check-kmalloc-return-value.patch
-procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
-add-file-position-info-to-proc.patch
-vfs-delay-the-dentry-name-generation-on-sockets-and.patch
-tty-i386-x86_64-arbitary-speed-support.patch
-kprobes-make-kprobesymbol_name-const.patch
-fix-cycladesh-for-x86_64-and-probably-others.patch
-cyclades-remove-custom-types.patch
-small-fixes-for-jsm-driver.patch
-jsm-driver-fix-for-linuxpps-support.patch
-as-fix-antic_expire-check.patch
-rtc-add-rtc-rs5c313-driver.patch
-rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
-rtc-add-rtc-class-driver-for-the-maxim-max6900-update.patch
-get_futex_key-get_key_refs-and-drop_key_refs.patch
-futex-restartable-futex_wait.patch
-proc-oom_score-oops-re-badness.patch
-enlarge-console-name.patch
-fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
-tty-remove-unnecessary-export-of-proc_clear_tty.patch
-tty-simplify-calling-of-put_pid.patch
-tty-introduce-no_tty-and-use-it-in-selinux.patch
-reiserfs-proc-support-requires-proc_fs.patch
-kprobes-fix-sparse-null-warning.patch
-move-die-notifier-handling-to-common-code.patch
-char-rocket-add-module_device_table.patch
-char-cs5535_gpio-add-module_device_table.patch
-remove-do_sync_file_range.patch
-protect-tty-drivers-list-with-tty_mutex.patch
-schedule-obsolete-oss-drivers-for-removal-4th-round.patch
-delete-unused-header-file-math-emu-extendedh.patch
-fix-sscanf-%n-match-at-end-of-input-string.patch
-make-remove_inode_dquot_ref-static.patch
-fix-race-between-attach_task-and-cpuset_exit.patch
-delete-unused-header-file-linux-awe_voiceh.patch
-kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
-parport-dev-driver-model-support.patch
-legacy-pc-parports-support-parport-dev.patch
-layered-parport-code-uses-parport-dev.patch
-add-support-for-deferrable-timers-respun.patch
-add-a-new-deferrable-delayed-work-init.patch
-linux-sysdevh-needs-to-include-linux-moduleh.patch
-irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
-time-smp-friendly-alignment-of-struct-clocksource.patch
-move-timekeeping-code-to-timekeepingc.patch
-ignore-stolen-time-in-the-softlockup-watchdog.patch
-add-touch_all_softlockup_watchdogs.patch
-header-cleaning-dont-include-smp_lockh-when-not-used.patch
-fix-82875-pci-setup.patch
-make-dev-port-conditional-on-config-symbol.patch
-remove-artificial-software-max_loop-limit.patch
-kdump-kexec-calculate-note-size-at-compile-time.patch
-fix-kevents-childs-priority-greediness.patch
-enhance-initcall_debug-measure-latency.patch
-kprobes-print-details-of-kretprobe-on-assertion-failure.patch
-reregister_binfmt-returns-with-ebusy.patch
-pnpacpi-sets-pnpdev-devarchdata.patch
-simplify-module_get_kallsym-by-dropping-length-arg.patch
-fix-race-between-rmmod-and-cat-proc-kallsyms.patch
-simplify-kallsyms_lookup.patch
-fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
-fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
-kernel-paramsc-fix-lying-comment-for-param_array.patch
-replace-deprecated-sa_xxx-interrupt-flags.patch
-deprecate-sa_xxx-interrupt-flags-v2.patch
-round_up-macro-cleanup-in-drivers-char-lpc.patch
-i386-schedh-inclusion-from-moduleh-is-baack.patch
-parport_serial-fix-pci-must_checks.patch
-round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
-round_up-macro-cleanup-in-fs-smbfs-requestc.patch
-kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
-merge-compat_ioctlh-into-compat_ioctlc.patch
-lockdep-treats-down_write_trylock-like-regular-down_write.patch
-pad-irq_desc-to-internode-cacheline-size.patch
-partition-add-support-for-sysv68-partitions.patch
-dtlk-fix-error-checks-in-module_init.patch
-add-spaces-on-either-side-of-case-operator.patch
-cleanup-compat-ioctl-handling.patch
-kallsyms-cleanup-use-seq_release_private-where-appropriate.patch
-proc-cleanup-use-seq_release_private-where-appropriate.patch
-cciss-reformat-error-handling.patch
-cciss-add-sg_io-ioctl-to-cciss.patch
-cciss-set-rq-errors-more-correctly-in-driver.patch
-generate-main-index-page-when-building-htmldocs.patch
-fix-hotplug-for-legacy-platform-drivers.patch
-remove-redundant-check-from-proc_setattr.patch
-remove-redundant-check-from-proc_sys_setattr.patch
-make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop.patch
-kernel-doc-html-mode-struct-highlights.patch
-add-webpages-url-and-summarize-3-lines.patch
-add-keyboard-blink-driver.patch
-efi-warn-only-for-pre-100-system-tables.patch
-apm-fix-incorrect-comment.patch
-cciss-include-scsi-scsih-unconditionally.patch
-highres-dyntick-prevent-xtime-lock-contention.patch
-documentation-cciss-detecting-failed-drives.patch
-spin_lock_unlocked-cleanup-in-init_taskh.patch
-spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch
-spin_lock_unlocked-cleanup-in-drivers-serial.patch
-lockdep-lookup_chain_cache-comment-errata.patch
-taskstats-fix-getdelays-usage-information.patch
-smbfs-remove-unnecessary-allow_signal.patch
-pnpbios-conert-to-use-the-kthread-api.patch
-introduce-a-handy-list_first_entry-macro-v2.patch
-document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
-getdelaysc-fix-overrun.patch
-serial_txx9-use-assigned-device-numbers.patch
-serial_txx9-zap-changelog-from-source-code.patch
-cpu-time-limit-patch--setrlimitrlimit_cpu-0-cheat-fix.patch
-ext3-copy-i_flags-to-inode-flags-on-write.patch
-codingstyle-start-flamewar-about-use-of-braces.patch
 upper-32-bits.patch
-console-utf-8-fixes.patch
-check-privileges-before-setting-mount-propagation.patch
-jbd-check-for-error-returned-by-kthread_create-on-creating-journal-thread.patch
-clean-up-mutex_trylock-noise.patch
-the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
-reiserfs-use-__set_current_state.patch
-drivers-char-use-__set_current_state.patch
-kill-warnings-when-building-mandocs.patch
-cleanup-mostly-unused-iospace-macros.patch
-lockdep-removed-unused-ip-argument-in-mark_lock-mark_held_locks.patch
-fat_dont-use_free_clusters-for-fat32.patch
-copy-i_flags-to-ext2-inode-flags-on-write.patch
-fix-chapter-reference-in-codingstyle.patch
-sleep-during-spinlock-in-tpm-driver.patch
-consolidate-asm-consth-to-linux-consth.patch
-consolidate-asm-consth-to-linux-consth-fix.patch
-x86_64-kill-19000-sparse-warnings.patch
-move-log_buf_shift-to-a-more-sensible-place.patch
-w1-printk-format-warning.patch
-w1-allow-bus-master-to-have-reset-and-byte-ops.patch
-driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
-driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-fix.patch
-driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-simplify-platform_data.patch
-driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-disable-interrupts-when-turning-off-ds1wm.patch
-dma_declare_coherent_memory-wrong-allocation.patch
-fix-vfat-compat-ioctls-on-64-bit-systems.patch
-udf-decrement-correct-link-count-in-udf_rmdir.patch
-doc-fix-oops-tracing-duplicate.patch
-laptop-mode-url-update.patch
-fix-error-handling-in-hdio_getgeo-compat-wrapper.patch
-old-buffer-overflow-in-moxa-driver.patch
-update-the-list-information-for-kexec-and-kdump.patch
-procfs-use-simple_read_from_buffer.patch
-cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
-cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
-misc-add-sensable-phantom-driver.patch
-misc-add-sensable-phantom-driver-v3.patch
-do_tty_write-can-block-even-with-o_nonblock.patch
-do_tty_write-can-block-even-with-o_nonblock-tidy.patch
-synclink_gt-use-dynamic-tty-device-registration.patch
-add-taskstatsh-to-kbuild.patch
-hide-spinlock-in-linux-quotah-behind-__kernel__.patch
-docbook-librs-typo-fixes.patch
-clockchipsh-kernel-doc-fix.patch
-invalid-return-value-of-execve-resulting-in-oopses.patch
-export-hrtimer_forward.patch
-use-mutex-instead-of-semaphore-in-rocketport-driver.patch
-use-mutex-instead-of-semaphore-in-tpm-driver.patch
-use-mutex-instead-of-semaphore-in-hdaps-driver.patch
-use-mutex-instead-of-semaphore-for-misc-char-devices.patch
-8250-remove-commented-out-irq-cruft.patch
-minor-spi_butterfly-cleanup.patch
-dev-spidevbc-interface.patch
-spi-kerneldoc.patch
-spi-kerneldoc-fix.patch
-au1550-spi-controller-driver.patch
-make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
-change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
-make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
-drivers-isdn-hardware-eicon-remove-unused-header-files.patch
-fix-spinlock-usage-in-hysdn_log_close.patch
-sanitize-linux-isdn_divertifh-for-userspace.patch
-use-mutex-instead-of-semaphore-in-capi-20-interface.patch
-isdn-spinlock-initializer-cleanup.patch
-sched-fix-idle-load-balancing-in-softirqd-context.patch
-sched-dynticks-idle-load-balancing-v3.patch
-speedup-divides-by-cpu_power-in-scheduler.patch
-sched-optimize-siblings-status-check-logic-in-wake_idle.patch
-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
-sched-align-rq-to-cacheline-boundary.patch
-rcutorture-use-array_size-macro-when-appropriate.patch
-rcutorture-style-cleanup-avoid-=-null-in-boolean-tests.patch
-rcutorture-remove-redundant-assignment-to-cur_ops-in.patch
-utimensat-implementation.patch
-rtc-remove-sys-class-rtc-dev.patch
-rtc-remove-sys-class-rtc-dev-fix.patch
-rtc-rtc-interfaces-dont-use-class_device.patch
-rtc-simplified-rtc-sysfs-attribute-handling.patch
-rtc-simplified-proc-driver-rtc-handling.patch
-rtc-remove-rest-of-class_device.patch
-rtc-suspend-resume-restores-system-clock.patch
-rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
-rtc-update-to-class-device-removal-patches.patch
-rtc-kconfig-cleanup.patch
-rtc-update-vr41xx-alarm-handling.patch
-rtc-cmos-wakeup-interface.patch
-acpi-wakeup-hooks-for-rtc-cmos.patch
-workaround-rtc-related-acpi-table-bugs.patch
-revert-rtc-add-rtc_merge_alarm.patch
-remove-rtc_alm_set-mode-bugs.patch
-rtc-cmos-make-it-load-on-pnpbios-systems.patch
-kprobes-use-hlist_for_each_entry.patch
-kprobes-codingstyle-cleanups.patch
-kprobes-kretprobes-simplifcations.patch
-kprobes-the-on-off-knob-thru-debugfs-updated.patch
-atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
-atomich-complete-atomic_long-operations-in-asm-generic.patch
-atomich-i386-type-safety-fix.patch
-atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
-atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
-atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
-atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
-atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
-atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
-atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
-local_t-architecture-independant-extension.patch
-local_t-alpha-extension.patch
-local_t-i386-extension.patch
-local_t-ia64-extension.patch
-local_t-mips-extension.patch
-local_t-parisc-cleanup.patch
-local_t-powerpc-extension.patch
-local_t-sparc64-cleanup.patch
-local_t-x86_64-extension.patch
-remove-tas.patch
-x86-create-asm-cmpxchgh.patch
-uml-network-and-pcap-cleanup.patch
-uml-pcap-devices-should-get-macs-from-command-line.patch
-some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
-no-longer-include-asm-kdebugh.patch
-nfs-fix-congestion-control-use-atomic_longs.patch
-udf-use-sector_t-and-loff_t-for-file-offsets.patch
-udf-introduce-struct-extent_position.patch
-udf-use-get_bh.patch
-udf-add-assertions.patch
-udf-support-files-larger-than-1g.patch
-udf-possible-null-pointer-dereference-while-load_partition.patch
-add-irqf_irqpoll-flag-common-code.patch
-add-irqf_irqpoll-flag-on-x86_64.patch
-add-irqf_irqpoll-flag-on-i386.patch
-add-irqf_irqpoll-flag-on-ia64.patch
-add-irqf_irqpoll-flag-on-sh.patch
-add-irqf_irqpoll-flag-on-parisc.patch
-add-irqf_irqpoll-flag-on-arm.patch
-char-cyclades-remove-pause.patch
-char-cyclades-cy_readx-writex-cleanup.patch
-char-cyclades-timer-cleanup.patch
-char-cyclades-remove-volatiles.patch
-char-cyclades-remove-useless-casts.patch
-pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi.patch
-pnp-workaround-hp-bios-defect-that-leaves-smcf010-device-partly-enabled.patch
-smsc-ircc2-tidy-up-module-parameter-checking.patch
-smsc-ircc2-add-pnp-support.patch
-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
-char-cyclades-create-cy_init_ze.patch
-char-cyclades-use-pci_iomap-unmap.patch
-char-cyclades-init-ze-immediately.patch
-char-cyclades-create-cy_pci_probe.patch
-char-cyclades-move-card-entries-init-into-function.patch
-char-cyclades-init-card-struct-immediately.patch
-char-cyclades-remove-some-global-vars.patch
-char-cyclades-cy_init-error-handling.patch
-char-cyclades-tty_register_device-separately-for-each-device.patch
-char-cyclades-clear-interrupts-before-releasing.patch
-char-cyclades-allow-debug_shirq.patch
-char-mxser-schedule-for-removal.patch
-char-isicom-use-pr_debug.patch
-char-cyclades-use-is_cyc_z-macro.patch
-char-cyclades-switch-to-pci-probing.patch
-char-cyclades-depends-on-pci-or-isa.patch
-char-cyclades-unexport-struct-cyclades_card.patch
-char-cyclades-remove-useless-fileds-from-cyclades_card.patch
-char-cyclades-irq-is-int.patch
-char-cyclades-printk-cleanups.patch
-char-cyclades-mark-cyy_init_card-as-__devinit-not-__init.patch
-char-cyclades-simplify-variables-initialization.patch
-char-cyclades-get-rid-of-phys-addresses.patch
-char-cyclades-make-info-card-a-pointer.patch
-char-cyclades-remove-sleep_on.patch
-char-cyclades-fix-blockmove.patch
-char-cyclades-timers-cleanup.patch
-char-cyclades-remove-unused-timestamps.patch
-char-cyclades-remove-locking-macros.patch
-char-cyclades-conditions-cleanup.patch
-char-cyclades-conditions-cleanup-fix.patch
-char-cyclades-fix-tty-device-unregister.patch
-char-cyclades-dynamic-ports.patch
-char-cyclades-probe-cleanup.patch
-char-cyclades-probe-cleanup-fix.patch
-char-cyclades-copyright-and-version-changes.patch
-ps3fb-thread-updates.patch
-ps3av-thread-updates.patch
-ps3fb-kill-superfluous-zero-initializations.patch
-ps3fb-atomic-fixes.patch
-ps3av-misc-updates.patch
-ps3-make-ps3videomode-v-0-auto-mode-work-again.patch
-ps3fb-use-__func__-instead-of-__function__.patch
-ps3av-use-__func__-instead-of-__function__.patch
-aty128fb-fix-blanking.patch
-change-rivafb_remove-to-__devexit.patch
-fbdev-display-class.patch
-fbdev-display-class-fix.patch
-fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
-intelfb-fix-ring-space-calculation.patch
-nvidiafb-bring-back-generic-ddc-reading.patch
-fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
-fbdev-fix-obvious-bug-in-show_pan.patch
-neofb-fill-transp-msb_right-with-the-correct.patch
-atyfb-kill-dead-code.patch
-fbdev-mm-deferred-io-support.patch
-fbdev-mm-deferred-io-support-fix.patch
-fbdev-mm-deferred-io-support-fix-2.patch
-fbdev-hecuba-framebuffer-driver.patch
-fbdev-hecuba-framebuffer-driver-fix.patch
-tgafb-turbochannel-support.patch
-tgafb-accelerated-code.patch
-remove-unused-header-file-drivers-video-riva-nv4refh.patch
-fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch
-fbdev-fb_do_show_logo-updates.patch
-fbdev-correct-image-offsets-when-rotating-logo.patch
-radeonfb-add-support-for-radeon-xpress-200m.patch
-nvidiafb-fix-reversed-ddc-port.patch
-vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch
-vt-add-color-support-to-the-underline-and-italic-attributes.patch
-vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
-vt-add-color-support-to-the-underline-and-italic-attributes-fix-2.patch
-fbcon-dont-draw-cursor-when-its-disabled.patch
-vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
-s3fb-fix-pci-must_checks.patch
-fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
-rivafb-nvidiafb-enable-hardware-monitoring.patch
-rivafb-handle-i2c-bus-creation-failure.patch
-rivafb-nvidiafb-various-cleanups.patch
-rivafb-fixed-reversed-ddc-ports.patch
-nvidiafb-ensure-that-crtc-registers-are-accessible.patch
-nvidiafb-access-crt-registers-safely.patch
-skeletonfb-various-corrections.patch
-video-add-spaces-on-either-side-of-the-case-operator.patch
-cirrusfb-convert-to-generic-boolean.patch
-sm501fb-printk-warning-fixes.patch
-epson1355fbc-fix-error-handling-code.patch
-nvidiafb-vga-state-save-and-restore.patch
-savagefb-rework-i2c-bit-access.patch
-savagefb-vga-state-save-and-restore.patch
-fbdev-link-vgastateo-using-kconfig.patch
-fbcon-delay-screen-update-when-setting-the-mode-of.patch
-nvidiafb-fix-sparse-warning.patch
-rivafb-fix-io-access.patch
-fbdev-kill-sparse-warning-in-deferred-io.patch
-fbdev-add-sparse-annotations-in-svgalibc.patch
-arcfb-kill-sparse-warning.patch
-s3fb-add-sparse-annotations.patch
-hecubafb-kill-sparse-warnings.patch
-i810fb-fix-incorrect-frequency-mask.patch
-vt-add-documentation-for-new-boot-sysfs-options.patch
-skeletonfb-documentation-error-fixes.patch
-fbdev-add-drawing-functions-for-framebuffers-in-system.patch
-arcfb-use-sys-instead-of-cfb-drawing-functions.patch
-hecubafb-use-sys-instead-of-cfb-drawing-functions.patch
-vfb-use-sys-instead-of-cfb-drawing-functions.patch
-fbdev-pass-struct-fb_info-to-fb_read-and-fb_write.patch
-fbdev-add-fb_read-fb_write-functions-for-framebuffers.patch
-arcfb-us-fb_sys_read.patch
-hecubafb-us-fb_sys_read.patch
-vfb-us-fb_sys_read-and-fb_sys_write.patch
-fbdev-consolidate-common-drawing-functions-into-a.patch
-fbdev-advertise-limitation-of-drawing-engine.patch
-fbcon-font-setting-should-check-limitation-of-driver.patch
-vga16fb-restrict-to-blit-rectangles-with-widths-of.patch
-s3fb-limit-8x16-rectangles-when-tileblitting-is-enabled.patch
-fbdev-add-tile-operation-to-get-the-maximum-length.patch
-s3fb-implement-fb_get_tilemax.patch
-fbcon-check-if-the-character-count-can-be-handled.patch
-fbdev-save-the-activate-field-before-calling-fb_check_var.patch
-s3fb-driver-fixes.patch
-vmlfb-framebuffer-driver-for-intel-vermilion-range.patch
-nvidiafb-rivafb-switch-to-pci_get-refcounting.patch
-pm2fb-3dlabs-permedia-2v-reference-board-added.patch
-pm2fb-permedia-2v-memory-clock-setting.patch
-pm2fb-pixclock-setting-restriction.patch
-nvidiafb-prevent-triggering-of-softlockup.patch
-fbdev-fbcon-check-if-mode-can-handle-new-screen.patch
-s3fb-implement-fb_get_caps.patch
-vga-vgastate-fix.patch
-nvidiafb-fix-return-value-of-nvidiafb_open.patch
-atyfb-increase-spll-delay.patch
-atyfb-reorganize-clock-init.patch
-atyfb-halve-xclk-with-mobility-and-32bit-memory.patch
-use-mutex-instead-of-semaphore-in-virtual-console-driver.patch
-drivers-video-sis-remove-more-kernel-24-code.patch
-rename-device_is_compatible-to-of_device_is_compatible.patch

 Merged into mainline or a subsystem tree.

+fix-unnecesary-meminit.patch
+smaps-only-define-clear_refs-for-config_mmu.patch
+frv-miscellaneous-fixes.patch
+m68k-asm-scatterlisth-needs-linux-typesh.patch
+usb_gigaset-dont-kmalloc0.patch
+applesmc-use-the-address-as-platform-device-id.patch
+applesmc-use-standard-sysfs-names-for-labels.patch
+revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
+declare-compat_sys_utimensat.patch
+slub-add-support-for-dynamic-cacheline-size-determination.patch
+slub-add-support-for-dynamic-cacheline-size-determination-fix-2.patch
+slub-after-object-padding-only-needed-for-redzoning.patch
+slub-slabinfo-upgrade.patch
+slub-use-check_valid_pointer-in-kmem_ptr_validate.patch
+slub-clean-up-krealloc.patch
+slub-clean-up-krealloc-fix.patch
+slub-get-rid-of-finish_bootstrap.patch
+slub-update-comments.patch
+slub-add-macros-for-scanning-objects-in-a-slab.patch
+slub-move-resiliency-check-into-sysfs-section.patch
+slub-introduce-debugslabpage.patch
+slub-consolidate-trace-code.patch
+slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code.patch
+slub-add-config_slub_debug.patch
+slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output.patch
+slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output-fix.patch
+slub-rework-slab-order-determination.patch
+krealloc-fix-kerneldoc-comments.patch
+fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
+frv-replace-pgd-management-via-slabs-through-quicklists.patch
+disable-slub-on-powerpc.patch
+dm-raid1-one-kmirrord-per-mirror.patch
+dm-crypt-disable-barriers.patch
+dm-crypt-fix-call-to-clone_init.patch
+dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch
+dm-crypt-fix-remove-first_clone.patch
+dm-crypt-use-smaller-bvecs-in-clones.patch
+dm-crypt-add-null-iv.patch
+dm-mpath-log-device-name.patch
+dm-allow-offline-devices.patch
+dm-log-fault-detection.patch
+dm-log-report-fault-status.patch
+dm-raid1-add-handle_errors-feature-flag.patch
+dm-io-delay-dec_count.patch
+dm-io-prepare-for-new-interface.patch
+dm-io-new-interface.patch
+dm-kcopyd-update-dm-io-interface.patch
+dm-exception-store-update-dm-io-interface.patch
+dm-log-update-dm-io-interface.patch
+dm-raid1-update-dm-io-interface.patch
+dm-io-remove-old-interface.patch
+dm-bio-list-helpers.patch
+dm-delay-target.patch
+dm-raid1-fix-to-commit-pending-clear-region-requests.patch
+dm-raid1-switch-rh_in_sync-to-blocking-in-do_reads.patch
+dm-log-fix-resume-failed-log-device.patch

 2.6.21-rc1 queue

-agk-dm-dm-raid1-one-kmirrord-per-mirror.patch
-agk-dm-dm-crypt-disable-barriers.patch
-agk-dm-dm-crypt-fix-call-to-clone_init.patch
-agk-dm-dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch
-agk-dm-dm-crypt-fix-remove-first_clone.patch
-agk-dm-dm-crypt-use-smaller-bvecs-in-clones.patch
-agk-dm-dm-crypt-add-null-iv.patch
-agk-dm-dm-mpath-log-device-name.patch
-agk-dm-dm-allow-offline-devices.patch
-agk-dm-dm-log-fault-detection.patch
-agk-dm-dm-log-report-fault-status.patch
-agk-dm-dm-raid1-add-handle_errors-feature-flag.patch
-agk-dm-dm-io-delay-dec_count.patch
-agk-dm-dm-io-prepare-for-new-interface.patch
-agk-dm-dm-io-new-interface.patch
-agk-dm-dm-kcopyd-update-dm-io-interface.patch
-agk-dm-dm-exception-store-update-dm-io-interface.patch
-agk-dm-dm-log-update-dm-io-interface.patch
-agk-dm-dm-raid1-update-dm-io-interface.patch
-agk-dm-dm-io-remove-old-interface.patch
-agk-dm-dm-bio-list-helpers.patch
-agk-dm-dm-delay.patch
-agk-dm-dm-raid1-fix-to-commit-pending-clear-region-requests.patch
-agk-dm-dm-raid1-switch-rh_in_sync-to-blocking-in-do_reads.patch
-agk-dm-dm-log-fix-resume-failed-log-device.patch

 These were renamed.

+tuner-simplec-add-suport-for-secam-bg-with-fi1216mf.patch

 dvb fix

+drivers-hwmon-switch-to-using-input_dev-devparent.patch

 hwmon API change

+git-ia64-sa_interrupt-is-deprecated.patch
+sn-validate-smp_affinity-mask-on-intr-redirect.patch
+sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
+sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch

 ia64 things

-input-fix-aux-port-detection-with-some-i8042-chips.patch
-input-fix-aux-port-detection-with-some-i8042-chips-fix.patch
-input-convert-from-class-devices-to-standard-devices.patch
-input-evdev-implement-proper-locking.patch
-mousedev-fix.patch
-mousedev-fix-2.patch

 Dropped these due to underlying changes

-ubi-dereference-after-kfree-in-create_vtbl-2.patch

 Dropped

+link_watch-eliminate-potential-delay-on-wrap-around.patch
+link_watch-always-schedule-urgent-events.patch

 git-net fixes

+sunrpc-fix-crash-in-rpc_malloc.patch

 sunrpc fix

+git-battery-fix.patch

 Fix something in git-battery

+fix-gregkh-pci-pci-reduce-aer-init-error-information.patch

 Fix a patch in Greg's PCI tree

+pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips.patch

 Disable MSI on a troublesome system

-git-sh-fixup.patch

 Unneeded

+fix-for-bugzilla-8426-massive-slowdown-on-scsi-cd-dvd-drive-connected-to-mptspi-driver.patch
+fix-old-scsi-adapter-crashes-with-cd-rom-take-2.patch

 SCSI updates

+unionfs-fix-slab-abuses-with-krealloc.patch

 unionfs fix

+git-wireless-fixup.patch

 Fix rejects in git-wireless

+x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned.patch

 x86_64 fixlet

+crypto-fix.patch

 Fix crypto

+slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch

 More experimental SLUB update

+create-the-zone_movable-zone-fix-section-mismatch-of-memory-hotplug-related-code-2.patch

 Fix create-the-zone_movable-zone.patch

+mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch

 Fix  mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch

+slub-reduce-antifrag-max-order.patch

 Update slub-vs-antifrag work

+swsusp-use-reasonable-default-for-hibernation_mode.patch

 Fix swsusp patches in -mm.

+uml-fix-build-breakage.patch
+uml-turn-on-scsi-support.patch
+uml-mark-a-tt-only-function.patch
+fix-linuxdoc-comment.patch
+uml-turn-build-warnings-into-comments.patch

 UML updates

+mutex_lock_interruptible-add-__must_check-must-fix.patch
+clocksource-spelling-error-in-watchdog-code.patch
+fs-fix-indentation-in-do_path_lookup.patch
+fs-use-path_walk-in-do_path_lookup.patch
+doc-what-a-patch-series-is.patch
+kernel-doc-small-kernel-doc-optimization.patch
+tty-flush-flip-buffer-on-ldisc-input-queue-flush.patch
+fix-printk-format-warnings-in-timer_listc.patch
+afs-export-a-couple-of-core-functions-for-afs-write.patch
+afs-afs-fixups.patch
+afs-implement-basic-file-write-support.patch
+afs-implement-basic-file-write-support-fix.patch

 New misc patches

+use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
+atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch

 SPI udpates

-relayfs-use-flush_keventd_work.patch

 Dropped, unneeded

+relay-use-plain-timer-instead-of-delayed-work.patch

 Because of this.

+make-cancel_rearming_delayed_work-reliable-fix.patch
+libata-core-convert-to-use-cancel_rearming_delayed_work.patch

 Update workqueue patches in -mm.

+knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports.patch
+knfsd-rpc-fix-server-side-wrapping-of-krb5i-replies.patch
+knfsd-fix-resource-leak-resulting-in-module-refcount-leak-for-rpcsec_gss_krb5ko.patch
+knfsd-rpcgss-rpc_gss_proc_-destroy-request-will-get-a-bad-rpc.patch
+knfsd-simplify-a-while-condition-in-svcsockc.patch
+knfsd-trivial-makefile-cleanup.patch
+knfsd-various-nfsd-xdr-cleanups.patch
+knfsd-avoid-oops-if-buggy-userspace-performs-confusing-filehandle-dentry-mapping.patch

 NFSD update

+timer-parenthesis-fix-in-tbase_get_deferrable-etc.patch

 Fix timer code

+revoke-core-code-do_revoke-error-handling.patch

 revoke fix

+lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda-lguest-2621-mm1-update.patch
+lguest-the-guest-code-dont-use-paravirt_probe-its-dying.patch
+lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized.patch
+lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch
+lguest-the-net-driver-two-net-bugfixes.patch
+lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
+lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch
+lguest-two-net-bugfixes-doc.patch

 lguest updates

+vmstat-use-our-own-timer-events-fix.patch

 Fix vmstat-use-our-own-timer-events.patch

+move-remote-node-draining-out-of-slab-allocators.patch

 slab/slub udpate

-acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set.patch
-acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set-vs-x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch

 Dropped.

+wrap-access-to-thread_info-fix.patch

 Fix wrap-access-to-thread_info.patch

+rename-thread_info-to-stack-fix-2.patch

 Fix rename-thread_info-to-stack.patch

-readahead-kconfig-options.patch
-radixtree-introduce-scan-hole-data-functions.patch
-mm-introduce-probe_page.patch
-mm-introduce-pg_readahead.patch
-readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
-readahead-insert-cond_resched-calls.patch
-readahead-minmax_ra_pages.patch
-readahead-events-accounting.patch
-readahead-rescue_pages.patch
-readahead-sysctl-parameters.patch
-readahead-min-max-sizes.patch
-readahead-state-based-method-aging-accounting.patch
-readahead-state-based-method-routines.patch
-readahead-state-based-method.patch
-readahead-state-based-method-check-node-id.patch
-readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch
-readahead-state-based-method-cancel-lookahead-gracefully.patch
-readahead-context-based-method.patch
-readahead-initial-method-guiding-sizes.patch
-readahead-initial-method-thrashing-guard-size.patch
-readahead-initial-method-user-recommended-size.patch
-readahead-initial-method.patch
-readahead-backward-prefetching-method.patch
-readahead-thrashing-recovery-method.patch
-readahead-thrashing-recovery-method-check-unbalanced-aging.patch
-readahead-thrashing-recovery-method-refill-holes.patch
-readahead-call-scheme.patch
-readahead-call-scheme-cleanup.patch
-readahead-call-scheme-catch-thrashing-on-lookahead-time.patch
-readahead-call-scheme-doc-fixes-for-readahead.patch
-readahead-laptop-mode.patch
-readahead-loop-case.patch
-readahead-nfsd-case.patch
-readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
-readahead-remove-parameter-ra_max-from-adjust_rala.patch
-readahead-state-based-method-protect-against-tiny-size.patch
-readahead-rename-state_based_readahead-to-clock_based_readahead.patch
-readahead-account-i-o-block-times-for-stock-readahead.patch
-readahead-rescue_pages-updates.patch
-readahead-remove-noaction-shrink-events.patch
-readahead-remove-size-limit-on-read_ahead_kb.patch
-readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
-readahead-partial-sendfile-fix.patch
-readahead-turn-on-by-default.patch

 Dropped

+vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
+vt8623fb-fix-compile-warnings.patch
+vt8623fb-fix-compile-error-if-config_mtrr=n.patch
+arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
+arkfb-fix-compiler-warnings.patch
+arkfb-fix-compile-error-if-config_mtrr=n.patch
+arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
+svgalib-move-fb_get_caps-to-svgalib.patch
+fbdev-add-support-for-avr32.patch
+frame-buffer-geforce-7300-gt.patch

 fbdev updates

+md-move-test-for-whether-level-supports-bitmap-to-correct-place.patch
+md-stop-using-csum_partial-for-checksum-calculation-in-md.patch
+md-remove-the-slash-from-the-name-of-a-kmem_cache-used-by-raid5.patch
+md-allow-reshape_position-for-md-arrays-to-be-set-via-sysfs.patch
+md-improve-partition-detection-in-md-array.patch

 RAID updates




All 811 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/patch-list


