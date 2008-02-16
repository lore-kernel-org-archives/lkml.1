Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbYBPIZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbYBPIZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 03:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYBPIZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 03:25:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41769 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbYBPIZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 03:25:32 -0500
Date: Sat, 16 Feb 2008 00:25:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc2-mm1
Message-Id: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/

- git-xfs is dropped due to git conflicts

- git-x86 is dropped due to too many changes to non-x86 code

- git-perfmon remains dropped due to rejects

- git-kgdb remains dropped due to rejects

- Added the slab/slub tree as git-slub.patch (Christoph Lameter)



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
  the mm-commits list.  These probably are at least compilable.

- More-than-daily -mm snapshots may be found at
  http://userweb.kernel.org/~akpm/mmotm/.  These are almost certainly not
  compileable.




Changes since 2.6.24-mm1:

 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-drm.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-hrt.patch
 git-ieee1394.patch
 git-jfs.patch
 git-kbuild.patch
 git-kvm.patch
 git-libata-all.patch
 git-md-accel.patch
 git-ubi.patch
 git-net.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-s390.patch
 git-sched.patch
 git-sh.patch
 git-scsi-rc-fixes.patch
 git-block.patch
 git-sparc64.patch
 git-unionfs.patch
 git-watchdog.patch
 git-wireless.patch
 git-cryptodev.patch
 git-xtensa.patch
 git-slub.patch

 git trees

-kvm-i386-fix.patch
-sys_remap_file_pages-fix-vm_file-accounting.patch
-drivers-net-wireless-b43-mainc-needs-ioh.patch
-adb-add-missing-include-linux-platform_deviceh.patch
-lockdep-annotate-epoll.patch
-get_task_comm-return-the-result.patch
-clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
-clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
-__group_complete_signal-fix-coredump-with-group-stop-race.patch
-remove-handle_group_stop-in-favor-of-do_signal_stop.patch
-exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
-timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch
-timerfd-v3-new-timerfd-api.patch
-timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64.patch
-timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration.patch
-timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration-checkpatch-fixes.patch
-timerfd-v3-new-timerfd-api-ia64-fix.patch
-timerfd-v3-new-timerfd-api-m68k-fix.patch
-timerfd-v3-new-timerfd-api-mips-fix.patch
-timerfd-v3-new-timerfd-api-arch-fixes.patch
-timerfd-v3-new-timerfd-api-s390-fix.patch
-timerfd-v3-new-timerfd-api-powerpc-fix.patch
-timerfd-v3-new-timerfd-api-sparc64-fix.patch
-timerfd-v3-new-timerfd-api-update-sys_nic-with-the-new-timerfd-syscalls.patch
-timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch
-timerfd-v3-un-break-config_timerfd.patch
-sdio-fix-module-device-table-definition-for-m68k.patch
-drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
-drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements-checkpatch-fixes.patch
-acpi4asus-add-support-for-f3sa.patch
-acpi-remove-duplicated-warning-message.patch
-acpi_pci_irq_find_prt_entry-use-list_for_each_entry-instead-of-list_for_each.patch
-small-acpica-extension-to-be-able-to-store-the-name-of.patch
-export-acpi_check_resource_conflict.patch
-acpi-backlight-reset-brightness-on-resume.patch
-acpi-backlight-reset-brightness-on-resume-checkpatch-fixes.patch
-mm-only-enforce-acpi-resource-conflict-checks.patch
-git-agpgart-fix.patch
-fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one.patch
-cifs-fix-warning.patch
-drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch
-agk-dm-dm-add-missing-memory-barrier-to-dm_suspend.patch
-agk-dm-dm-mark-function-lists-static.patch
-agk-dm-dm-ioctl-remove-lock_kernel.patch
-agk-dm-dm-ioctl-move-compat-code.patch
-agk-dm-dm-table-use-list_for_each.patch
-agk-dm-dm-table-remove-unused-variable.patch
-agk-dm-dm-table-remove-unused-total.patch
-agk-dm-dm-snapshot-use-rounddown_pow_of_two.patch
-agk-dm-dm-convert-suspend_lock-semaphore-to-mutex.patch
-agk-dm-dm-snapshot-use-uninitialized_var.patch
-agk-dm-dm-table-use-uninitialized_var.patch
-agk-dm-dm-ioctl-use-uninitialized_var.patch
-agk-dm-dm-tidy-alloc_dev-labels.patch
-agk-dm-dm-refactor-deferred-bio_list-processing.patch
-agk-dm-dm-tidy-dm_suspend.patch
-agk-dm-dm-split-dm_suspend-io_lock-hold-into-two.patch
-agk-dm-dm-refactor-dm_suspend-completion-wait.patch
-agk-dm-dm-targets-no-longer-experimental.patch
-agk-dm-dm-mpath-add-missing-static.patch
-agk-dm-dm-crypt-move-convert_context-inside-dm_crypt_io.patch
-agk-dm-dm-crypt-remove-unnecessary-crypt_context-write-parm.patch
-agk-dm-dm-crypt-move-error-setting-outside-crypt_dec_pending.patch
-agk-dm-dm-crypt-tidy-crypt_endio.patch
-agk-dm-dm-crypt-adjust-io-processing-functions.patch
-agk-dm-dm-crypt-move-queue-functions.patch
-agk-dm-dm-crypt-store-sector-mapping-in-dm_crypt_io.patch
-agk-dm-dm-crypt-abstract-crypt_write_done.patch
-agk-dm-dm-crypt-introduce-crypt_write_io_loop.patch
-agk-dm-dm-crypt-tidy-io-ref-counting.patch
-agk-dm-dm-crypt-extract-scatterlist-processing.patch
-agk-dm-dm-crypt-add-async-request-mempool.patch
-agk-dm-dm-crypt-add-completion-for-async.patch
-agk-dm-dm-crypt-prepare-async-callback-fn.patch
-agk-dm-dm-crypt-use-async-crypto.patch
-agk-dm-dm-move-deferred-bio-flushing-to-workqueue.patch
-agk-dm-dm-log-auto-load-modules.patch
-agk-dm-dm-stripe-trigger-event-on-failure.patch
-agk-dm-dm-stripe-enhanced-status-return.patch
-agk-dm-dm-snapshot-combine-consecutive-exceptions-in-memory.patch
-agk-dm-dm-raid1-handle-write-failures.patch
-agk-dm-dm-raid1-handle-recovery-failures.patch
-agk-dm-dm-raid1-fix-eio-after-log-failure.patch
-agk-dm-dm-raid1-handle-read-failures.patch
-agk-dm-dm-raid1-report-fault-status.patch
-include-asm-powerpc-nvramh-needs-listh.patch
-include-asm-powerpc-nvramh-needs-listh-fix.patch
-arch-powerpc-platforms-pseries-add-missing-of_node_put.patch
-arch-powerpc-sysdev-add-missing-of_node_put.patch
-arch-powerpc-platforms-82xx-add-missing-of_node_put.patch
-gregkh-driver-kobject-always-build-in-kernel-ksysfso.patch
-gregkh-driver-kobject-kerneldoc-comment-fix.patch
-gregkh-driver-add-ja_jp-translation-of-stable_kernel_rulestxt.patch
-gregkh-driver-nozomi-driver-update.patch
-gregkh-driver-nozomi-constify-driver.patch
-gregkh-driver-nozomi-finish-constification.patch
-gregkh-driver-pm-export-device_pm_schedule_removal.patch
-gregkh-driver-driver-core-convert-to-use-class_find_device-api.patch
-gregkh-driver-driver-core-update-some-prototypes-in-platformtxt.patch
-gregkh-driver-driver-core-remove-unneeded-get_-device-driver-calls.patch
-git-drm-fix.patch
-drm-convert-from-nopage-to-fault.patch
-drm-convert-from-nopage-to-fault-checkpatch-fixes.patch
-drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
-jdelvare-i2c-i2c-algos-fix-typos.patch
-gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid.patch
-gfs2-make-gfs2_holdergh_owner_pid-be-a-struct-pid.patch
-revert-git-hrt.patch
-ia64-remove-dead-code.patch
-ia64-honor-notify_die-returning-notify_stop.patch
-ia64-fix-the-order-of-atomic-operations-in-restore_previous_kprobes.patch
-ia64-fix-userspace-compile-error-in-gcc_intrinh.patch
-ia64-make-pfm_get_task-work-with-virtual-pids.patch
-ia64-aliasing-test-fix-gcc-warnings-on-non-ia64.patch
-ia64-slim-down-__clear_bit_unlock.patch
-i8042-non-x86-build-fix.patch
-ata-drivers-ata-sata_mvc-needs-dmapoolh.patch
-ide-mm-ppc-fix-ifdefs-in-mediabay-driver.patch
-ide-mm-ide-remove-write-only-sata_misc-from-ide_hwif_t.patch
-ide-mm-ide-remove-redundant-bug_on-from-atapi_-reset_pollfunc.patch
-ide-mm-ide-remove-ide_setup_ports.patch
-ide-mm-ide-add-ide_read_-alt-status-inline-helpers.patch
-ide-mm-ide-add-ide_read_error-inline-helper.patch
-fix-ide-mm-ppc-fix-ifdefs-in-mediabay-driver.patch
-drivers-ide-ide-acpic-fix-uninitialized-var-warning.patch
-drivers-ide-legacy-hdc-fix-uninitialized-var-warning.patch
-m32r-remove-dead-config-symbols-from-m32r-code.patch
-memstick-initial-commit-for-sony-memorystick-support.patch
-memstick-initial-commit-for-sony-memorystick-support-fix.patch
-memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
-updates-for-the-memstick-driver.patch
-memstick-git-busted.patch
-drivers-mtd-maps-physmapc-fix-compile-remove-ifdef.patch
-eccbuf-is-statically-defined-and-always-evaluate-to-true.patch
-mtd-fix-startup-lock-when-using-multiple-nor-flash-chips.patch
-hamradio-fix-dmascc-section-mismatch.patch
-tun-dev-impossible-to-deassert-iff_one_queue-or-iff_no_pi.patch
-mv643xx_eth-fix-byte-order-when-checksum-offload-is-enabled.patch
-drivers-net-tlanc-compilation-warning-fix.patch
-drivers-net-dm9000c-vague-probably-wrong-build-fix.patch
-bluetooth-hidp_process_hid_control-remove-unnecessary-parameter-dealing.patch
-bluetooth-uninlining.patch
-drivers-bluetooth-bpa10xc-fix-memleak.patch
-drivers-bluetooth-btsdioc-fix-double-free.patch
-bluetooth-blacklist-another-broadcom-bcm2035-device.patch
-hci_ldisc-fix-null-pointer-deref.patch
-rfcomm-tty-destroy-before-tty_close.patch
-nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
-pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
-pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
-pcmcia-stop-updating-dev-powerpower_state.patch
-pcmcia-include-bad-cis-filename-in-error-message.patch
-pcmcia-3c574_cs-fix-shadow-variable-warning.patch
-pcmcia-axnet_cs-make-functions-static.patch
-pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one.patch
-pcmcia-fmvj18x_cs-fix-shadow-variable-warning.patch
-pcmcia-pcnet_cs-fix-shadow-variable-warning.patch
-at91_cf-use-generic-gpio-calls.patch
-drivers-pcmcia-add-missing-iounmap.patch
-drivers-pcmcia-add-missing-pci_dev_get.patch
-serial-keep-the-dtr-setting-for-serial-console.patch
-drivers-serial-s3c2410c-remove-dead-config-symbols.patch
-serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh.patch
-serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh-checkpatch-fixes.patch
-8250c-support-specifying-dw-apb-uarts-in-device-platform_data.patch
-avoid-waking-up-closed-serial-ports-on-resume.patch
-serial-avoid-stalling-suspend-if-serial-port-wont-drain.patch
-serial-speed-setup-failure-reporting.patch
-serial-coding-style.patch
-serial-mpsc-set-baudrate-when-brg-divider-is-set.patch
-gregkh-pci-pci-pci_enable_device_bars-fix-for-lpfc-driver.patch
-gregkh-pci-pci-fix-section-mismatch-warnings-referring-to-pci_do_scan_bus.patch
-gregkh-pci-pci-fix-4x-section-mismatch-warnings.patch
-sh-termios-ioctl-definitions.patch
-scsi-fix-isa-pcmcia-compile-problem.patch
-scsi-fix-isa-pcmcia-compile-problem-checkpatch-fixes.patch
-git-scsi-misc-gdth-fix.patch
-megaraid-driver-management-char-device-moved-to-misc.patch
-scsi-advansysc-make-3-functions-static.patch
-sg-nopage.patch
-scsi-aic94xx-cleanups-checkpatch-fixes.patch
-scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
-small-cleanups-for-scsi_hosth.patch
-scsi-arcmsr-updates-1200015.patch
-drivers-scsi-dc395xc-fix-uninitialized-var-warning.patch
-vfs-apply-coding-standards-to-fs-ioctlc.patch
-vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
-vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
-vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls.patch
-ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
-9p-fix-p9_printfcall-export.patch
-b43-fix-build-with-config_ssb_pcihost=n.patch
-acpi-default-unmap-fixpatch.patch
-git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
-pci-dont-load-acpi_php-when-acpi-is-disabled-fix.patch
-x86-amd-thermal-interrupt-support-fix-2.patch
-x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
-x86-mmconf-enable-mcfg-early.patch
-x86-mmconf-enable-mcfg-early-cleanup.patch
-x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-v3.patch
-x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
-iommu-sg-merging-add-device_dma_parameters-structure.patch
-iommu-sg-merging-pci-add-device_dma_parameters-support.patch
-iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
-iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
-iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
-iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
-iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
-iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
-iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
-iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
-iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch
-iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch
-iommu-sg-add-iommu-helper-functions-for-the-free-area-management-update.patch
-iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper.patch
-iommu-sg-powerpc-remove-dma-4gb-boundary-protection.patch
-iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
-iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
-iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
-add-accessors-for-segment_boundary_mask-in.patch
-pci-add-dma-segment-boundary-support.patch
-swiotlb-respect-the-segment-boundary-limits.patch
-call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch
-tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch
-gpiolib-add-drivers-gpio-directory.patch
-gpiolib-add-gpio-provider-infrastructure.patch
-gpiolib-update-documentation-gpiotxt.patch
-gpiolib-pxa-platform-support.patch
-gpiolib-pcf857x-i2c-gpio-expander-support.patch
-gpiolib-mcp23s08-spi-gpio-expander-support.patch
-gpiolib-pca9539-i2c-gpio-expander-support.patch
-gpiolib-deprecate-obsolete-pca9539-driver.patch
-gpiolib-avr32-at32ap-platform-support.patch
-pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
-pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
-pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
-move-vmalloc_to_page-to-mm-vmalloc.patch
-vmalloc-add-const-to-void-parameters.patch
-vmalloc-add-const-to-void-parameters-fix.patch
-i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
-i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
-is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
-vmalloc-clean-up-page-array-indexing.patch
-vunmap-return-page-array-passed-on-vmap.patch
-slub-move-count_partial.patch
-slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
-slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
-slub-use-non-atomic-bit-unlock.patch
-slub-fix-coding-style-violations.patch
-slub-fix-coding-style-violations-checkpatch-fixes.patch
-slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
-slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
-slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
-slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
-slub-__slab_alloc-exit-path-consolidation.patch
-slub-provide-unique-end-marker-for-each-slab.patch
-slub-provide-unique-end-marker-for-each-slab-fix.patch
-slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
-slub-optional-fast-path-using-cmpxchg_local.patch
-slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
-slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
-slub-do-our-own-locking-via-slab_lock-and-slab_unlock-fix.patch
-slub-restructure-slab-alloc.patch
-slub-comment-kmem_cache_cpu-structure.patch
-slub-fix-sysfs-refcounting.patch
-vm-allow-get_page_unless_zero-on-compound-pages.patch
-bufferhead-revert-constructor-removal.patch
-bufferhead-revert-constructor-removal-checkpatch-fixes.patch
-hugetlb-allow-sticky-directory-mount-option.patch
-swapin_readahead-excise-numa-bogosity.patch
-swapin_readahead-move-and-rearrange-args.patch
-swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
-shmem-sgp_quick-and-sgp_fault-redundant.patch
-shmem_getpage-return-page-locked.patch
-shmem_file_write-is-redundant.patch
-swapin-fix-valid_swaphandles-defect.patch
-swapoff-scan-ptes-preemptibly.patch
-shmem-factor-out-sbi-free_inodes-manipulations.patch
-shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
-tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
-tmpfs-move-swap_state-stats-update.patch
-tmpfs-shuffle-add_to_swap_caches.patch
-tmpfs-move-swap-swizzling-into-shmem.patch
-tmpfs-allow-filepage-alongside-swappage.patch
-tmpfs-allocate-on-read-when-stacked.patch
-tmpfs-make-shmem_unuse-more-preemptible.patch
-tmpfs-open-a-window-in-shmem_unuse_inode.patch
-tmpfs-radix_tree_preloading.patch
-tmpfs-fix-shmem_swaplist-races.patch
-clean-up-vmtruncate.patch
-maps4-add-proportional-set-size-accounting-in-smaps.patch
-maps4-rework-task_size-macros.patch
-maps4-rework-task_size-macros-mips-fix.patch
-maps4-move-is_swap_pte.patch
-maps4-introduce-a-generic-page-walker.patch
-maps4-use-pagewalker-in-clear_refs-and-smaps.patch
-maps4-simplify-interdependence-of-maps-and-smaps.patch
-maps4-move-clear_refs-code-to-task_mmuc.patch
-maps4-regroup-task_mmu-by-interface.patch
-maps4-add-proc-pid-pagemap-interface.patch
-maps4-add-proc-pid-pagemap-interface-fix.patch
-maps4-add-proc-kpagecount-interface.patch
-maps4-add-proc-kpagecount-interface-fix.patch
-maps4-add-proc-kpageflags-interface.patch
-maps4-add-proc-kpageflags-interface-fix.patch
-maps4-add-proc-kpageflags-interface-fix-2.patch
-maps4-add-proc-kpageflags-interface-fix-2-fix.patch
-maps4-make-page-monitoring-proc-file-optional.patch
-maps4-make-page-monitoring-proc-file-optional-fix.patch
-memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
-add-remove_memory-for-ppc64-3.patch
-enable-hotplug-memory-remove-for-ppc64.patch
-add-arch-specific-walk_memory_remove-for-ppc64.patch
-mm-page-writebackc-make-a-function-static.patch
-remove-unused-code-from-mm-tiny-shmemc.patch
-make-__vmalloc_area_node-static.patch
-radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
-page-allocator-clean-up-pcp-draining-functions.patch
-page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
-page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
-add-mm-argument-to-pte-pmd-pud-pgd_free.patch
-add-mm-argument-to-pte-pmd-pud-pgd_free-checkpatch-fixes.patch
-arch_rebalance_pgtables-call.patch
-vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
-mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
-page-allocator-get-rid-of-the-list-of-cold-pages.patch
-page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
-mm-page-writeback-highmem_is_dirtyable-option.patch
-mm-page-writeback-highmem_is_dirtyable-option-fix.patch
-fix-proc-dcache-deadlock-in-do_exit.patch
-vmstat-remove-prefetch.patch
-mm-dont-waste-swap-on-locked-pages.patch
-skip-writing-data-pages-when-inode-is-under-i_sync.patch
-mm-special-mapping-nopage.patch
-remove-unused-arguments-in-zone_init_free_lists.patch
-mm-remove-fastcall-from-mm.patch
-mm-remove-fastcall-from-mm-checkpatch-fixes.patch
-set_page_refcounted-vm_bug_on-fix.patch
-fix-dirty-page-accounting-leak-with-ext3-data=journal.patch
-include-count-of-pagecache-pages-in-show_mem-output.patch
-check-advice-of-fadvice64_64-even-if-get_xip_page-is-given.patch
-document-about-lowmem_reserve_ratio.patch
-page-migraton-handle-orphaned-pages.patch
-page-migraton-handle-orphaned-pages-fix.patch
-mm-fix-pageuptodate-data-race.patch
-mm-fix-section-mismatch-warning-in-sparsec.patch
-writeback-speed-up-writeback-of-big-dirty-files.patch
-slob-fix-free-block-merging-at-head-of-subpage.patch
-slob-reduce-external-fragmentation-by-using-three-free-lists.patch
-slob-correct-kconfig-description.patch
-vfs-security-rework-inode_getsecurity-and-callers-to.patch
-vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
-revert-capabilities-clean-up-file-capability-reading.patch
-revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
-add-64-bit-capability-support-to-the-kernel.patch
-add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
-add-64-bit-capability-support-to-the-kernel-fix.patch
-add-64-bit-capability-support-to-the-kernel-fix-fix.patch
-add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message.patch
-add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
-add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
-64bit-capability-support-legacy-support-fix.patch
-add-64-bit-capability-support-to-the-kernel-capabilities-export-__cap_-symbols.patch
-remove-unnecessary-include-from-include-linux-capabilityh.patch
-capabilities-introduce-per-process-capability-bounding-set.patch
-capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
-oom_kill-remove-uid==0-checks.patch
-netlabel-introduce-a-new-kernel-configuration-api-for-netlabel.patch
-smack-version-11c-simplified-mandatory-access-control-kernel.patch
-smack-version-11c-simplified-mandatory-access-control-kernel-fix.patch
-smack-using-capabilities-32-and-33.patch
-smack-using-capabilities-32-and-33-update-cap_last_cap-to-reflect-cap_mac_admin.patch
-smack-mutex-capability-pointers-and-spelling-cleanup.patch
-smack-getpeercred_stream-fix-for-so_peersec-and-tcp.patch
-smack-socket-label-setting-fix.patch
-frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
-frv-move-dma-macros-to-scatterlisth-for-consistency.patch
-frv-remove-dead-config-symbol-from-frv-code.patch
-frv-use-find_task_by_vpid-in-cxn_pin_by_pid.patch
-m68knommu-use-array_size-in-coldfire-serial-driver.patch
-m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch
-m68knommu-removing-config-variable-dumptoflash.patch
-nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
-m68knommu-remove-duplicate-exports.patch
-arch-alpha-removed-duplicate-includes.patch
-alpha-atomic_add_return-should-return-int.patch
-alpha-kill-deprecated-virt_to_bus.patch
-alpha-doesnt-use-socketcall.patch
-agp-alpha-nopage.patch
-alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
-kernel-power-diskc-make-code-static.patch
-make-kernel_shutdown_prepare-static.patch
-pm-qos-infrastructure-and-interface.patch
-pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
-pm-qos-remove-locks-around-blocking-notifier.patch
-latencyc-use-qos-infrastructure.patch
-misc-add-possibility-to-remove-misc-devices-during-suspend-resume.patch
-hwrng-add-possibility-to-remove-hwrng-devices-during-suspend-resume.patch
-leds-add-possibility-to-remove-leds-classdevs-during-suspend-resume.patch
-b43-avoid-unregistering-device-objects-during-suspend.patch
-m68k-use-cc-cross-prefix.patch
-m68k-array_size-cleanup.patch
-dio-array_size-cleanup.patch
-dio-array_size-cleanup-update.patch
-dio-array_size-cleanup-update-checkpatch-fixes.patch
-m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch
-nubus-kill-drivers-nubus-nubus_symsc.patch
-m68k-kill-arch-m68k-mac-mac_ksymsc.patch
-m68k-kill-arch-m68k-hp300-ksymsc.patch
-m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
-m68k-kill-arch-m68k-atari-atari_ksymsc.patch
-m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
-mac68k-macii-adb-comment-correction.patch
-mac68k-remove-dead-code.patch
-mac68k-add-nubus-card-definitions-and-a-typo-fix.patch
-mac68k-remove-dead-mac_adbkeycodes.patch
-cris-avoid-using-arch-links-in-kconfig.patch
-arch-cris-added-a-missing-iounmap.patch
-cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch
-uml-arch-um-include-inith-needs-a-definition-of-__used.patch
-uml-remove-xmm-checking-on-x86.patch
-uml-code-tidying-under-arch-um-os-linux.patch
-uml-implement-get_wchan.patch
-uml-implement-get_wchan-fix.patch
-uml-get-rid-of-asmlinkage.patch
-uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
-uml-document-new-ubd-flag.patch
-uml-fix-urls-in-kconfig-and-help-strings.patch
-uml-improve-detection-of-host-cmov.patch
-uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
-uml-improve-detection-of-host-cmov-checkpatch-fixes-fix.patch
-uml-remove-now-unused-code.patch
-uml-further-bugsc-tidying.patch
-uml-further-bugsc-tidying-checkpatch-fixes.patch
-uml-const-and-other-tidying.patch
-uml-smp-needs-to-depend-on-broken-for-now.patch
-uml-gprof-needs-to-depend-on-frame_pointer.patch
-uml-console-driver-cleanups.patch
-uml-clonec-tidying.patch
-uml-borrow-consth-techniques.patch
-uml-delete-some-unused-headers.patch
-uml-allow-lflags-on-command-line.patch
-uml-tidy-kern_utilh.patch
-uml-tidy-pgtableh.patch
-uml-tidy-pgtableh-fix.patch
-uml-reconst-a-parameter.patch
-arch-um-remove-duplicate-includes.patch
-uml-remove-unused-variables-in-the-context-switcher.patch
-uml-convert-functions-to-void.patch
-uml-host-tls-diagnostics.patch
-uml-move-um_virt_to_phys.patch
-uml-header-untangling.patch
-uml-header-untangling-fix.patch
-uml-style-cleanup.patch
-uml-currenth-cleanup.patch
-uml-fix-page-table-data-sizes.patch
-uml-add-virt_to_pte.patch
-uml-simplify-sigsegv-handling.patch
-uml-use-ptrace-directly-in-libc-code.patch
-uml-kill-processes-instead-of-panicing-kernel.patch
-uml-add-missing-space.patch
-uml-clean-up-task_size-usage.patch
-uml-cover-stubs-with-a-vma.patch
-uml-fix-command-line-cflags-and-ldflags-support.patch
-uml-style-fixes-in-arch-um-os-linux.patch
-uml-remove-duplicate-config-symbol-and-unused-file-and-variables.patch
-uml-fix-mconsole-stop.patch
-uml-miscellaneous-code-cleanups.patch
-uml-style-fixes-in-filec.patch
-uml-64-bit-tlb-fixes.patch
-uml-customize-tlbh.patch
-uml-eliminate-setjmp_wrapper.patch
-uml-install-panic-notifier-earlier.patch
-uml-use-barrier-instead-of-mb.patch
-uml-tidy-helper-code.patch
-uml-dont-kill-pid-0.patch
-uml-get-rid-of-syscall-counters.patch
-uml-dont-allow-processes-to-call-into-stub.patch
-uml-move-sig_handler_common_skas.patch
-uml-clean-up-sig_handler_common_skas.patch
-uml-style-fixes-in-arch-um-kernel.patch
-uml-fix-hostfs-tv_usec-calculations.patch
-uml-signal-handling-tidying.patch
-uml-remove-init_irq_signals.patch
-uml-smp-locking-commentary.patch
-uml-implement-o_append.patch
-uml-remove-fakehd.patch
-uml-debug_shirq-fixes.patch
-uml-add-back-config_hz.patch
-uml-style-fixes-in-arch-um-sys-x86_64.patch
-uml-add-newlines-to-printks.patch
-uml-move-register-initialization.patch
-uml-remove-unused-fields-from-mm_context.patch
-uml-remove-topdir.patch
-uml-spelling-fix.patch
-uml-remove-map_cb.patch
-uml-fix-infinite-mconsole-loop.patch
-uml-use-of-a-public-mac-is-a-warning-not-an-error.patch
-uml-ldt-mutex-conversion.patch
-uml-mconsole-mutex-conversion.patch
-uml-port-mutex-conversion.patch
-uml-defconfig-tweaks.patch
-uml-redo-the-calculation-of-nr_syscalls.patch
-uml-make-mconsole_stack-namespace-aware.patch
-drivers-pmc-msp71xx-gpio-char-driver.patch
-kernel-printkc-concerns-about-the-console-handover.patch
-fix-versus-precedence-in-various-places.patch
-geode-lists-are-subscriber-only.patch
-fs-fat-refine-chmod-checks.patch
-a-potential-bug-in-inotify_userc.patch
-riscom8-fix-smp-brokenness.patch
-riscom8-fix-smp-brokenness-fix.patch
-taskstats-scaled-time-cleanup.patch
-use-__set_task_state-for-traced-stopped-tasks.patch
-hash-add-explicit-u32-and-u64-versions-of-hash.patch
-remove-inclusions-of-linux-autoconfh.patch
-sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
-sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
-sound-oss-sb_commonc-fix-casting-warning.patch
-remove-warnings-for-longstanding-conditions.patch
-remove-warnings-for-longstanding-conditions-fix.patch
-ext2-return-after-ext2_error-in-case-of-failures.patch
-ext2-change-the-default-behaviour-on-error.patch
-sigio-driven-i-o-with-inotify-queues.patch
-remove-pointless-casts-from-void-pointers.patch
-ipc-fix-error-check-in-all-new-xxx_lock-and.patch
-genericizing-iova.patch
-genericizing-iova-fix.patch
-dcdbas-add-dmi-based-module-autloading.patch
-parallel-port-convert-port_mutex-to-the-mutex-api.patch
-parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
-remove-support-for-un-needed-_extratext-section.patch
-remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
-allow-auto-destruction-of-loop-devices.patch
-allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
-register_cpu-__devinit-or-__cpuinit.patch
-make-ipc-utilcsysvipc_find_ipc-static.patch
-cleanup-after-apus-removal.patch
-remove-mm_ptovvtop.patch
-mnt_unbindable-fix.patch
-proper-show_interrupts-prototype.patch
-fat-fix-printk-format-strings.patch
-scheduled-oss-driver-removal.patch
-read_current_time-cleanups.patch
-read_current_time-cleanups-build-fix.patch
-read_current_time-cleanups-build-fix-fix.patch
-smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive.patch
-proper-prototype-for-signals_init.patch
-kernel-ptracec-should-include-linux-syscallsh.patch
-make-srcu_readers_active-static.patch
-kernel-notifierc-should-include-linux-rebooth.patch
-proper-prototype-for-get_filesystem_list.patch
-fs-utimesc-should-include-linux-syscallsh.patch
-fs-signalfdc-should-include-linux-syscallsh.patch
-fs-eventfdc-should-include-linux-syscallsh.patch
-proper-prototype-for-vty_init.patch
-drivers-misc-lkdtmc-cleanups.patch
-rd-use-is_power_of_2-in-drivers-block-rdc.patch
-sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set.patch
-time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
-cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
-log2h-define-order_base_2-macro-for-convenience.patch
-fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
-alpha-parisc-removing-config-variable-debug_rwlock.patch
-document-i_sync-and-i_datasync.patch
-percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
-printkc-use-unsigned-ints-instead-of-longs-for-logbuf-index.patch
-tpmc-fix-crash-during-device-removal.patch
-vt-bitlock-fix.patch
-avoid-divide-in-is_align.patch
-do_wait-remove-one-else-if-branch.patch
-proc-loadavg-reading-race.patch
-fs-use-hlist_unhashed.patch
-fs-use-list_for_each_entry_reverse-and-kill-sb_entry.patch
-radix_treeh-trivial-comment-correction.patch
-ncpfs-update-diagnostic-strings-to-match-routine-names.patch
-address-hfs-on-disk-corruption-robustness-review-comments.patch
-hfs-update-comment-to-reflect-actual-init-and-exit-routines.patch
-maintainers-order-auerswald-alphabetically.patch
-inotify-send-in_attrib-events-when-link-count-changes.patch
-inotify-send-in_attrib-events-when-link-count-changes-fix.patch
-via-rng-enable-secondary-noise-source-on-cpus-where-it-is-present.patch
-reiserfs-complement-va_start-with-va_end.patch
-get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
-get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
-synclink-standardize-format-of-linux-header-file-includes-with.patch
-synclink_gt-fix-missed-serial-input-signal-changes.patch
-fix-__const_udelay-declaration-and-definition-mismatches.patch
-drivers-char-randomcwrite_pool-cond_resched-needed.patch
-kill-an-unused-ptr_err-in-bdev_cache_init.patch
-remove-rcu_assign_pointer-penalty-for-null-pointers.patch
-remove-superfluous-checks-for-config_blk_dev_initrd-from-initramfsc.patch
-serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch
-char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch
-sc26xx-new-serial-driver-for-sc2681-uarts.patch
-sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
-inotify-fix-race.patch
-inotify-remove-debug-code.patch
-documentation-about-unaligned-memory-access.patch
-drivers-char-tty_ioc-remove-pty_sem.patch
-drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
-unix98-allocated_ptys_lock-semaphore-to-mutex.patch
-kallsyms-should-prefer-non-weak-symbols.patch
-kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
-dio-fix-kernel-doc-notation.patch
-relay-nopage.patch
-uio-nopage.patch
-deprecate-smbfs-in-favour-of-cifs.patch
-drivers-char-use-list_head-instead-of-list_head_init.patch
-remove-one-useless-extern-declaration.patch
-quota-improve-inode-list-scanning-in-add_dquot_ref.patch
-quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
-add-arch_ptrace_stop.patch
-tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
-tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
-docs-kernel-locking-convert-semaphore-references.patch
-virtio_net-remove-double-ether_setup.patch
-drivers-char-ipmi-ipmi_msghandlerc-use-list_head-instead-of-list_head_init.patch
-fs-reiserfs-xattrc-use-list_head-instead-of-list_head_init.patch
-stopmachine-semaphore-to-mutex.patch
-stopmachine-semaphore-to-mutex-fix.patch
-amiga-serial-driver-port_write_mutex-fixup.patch
-ext2-xip-check-fix.patch
-parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard.patch
-parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard-fix.patch
-parport_serial-netmos-9855-fix.patch
-partition-use-default_sgi_partition-for-sgi_partion-default.patch
-ik8-add-dell-uk-6400-inspiron-model-mm061.patch
-parport_pc-detection-for-superio-it87xx-post.patch
-lib-extablec-removes-an-expensive-integer-divide-in-search_extable.patch
-kernel-paramsc-remove-sparse-warning-different-signedness.patch
-calibrate_delay-must-be-__cpuinit.patch
-idle_regs-must-be-__cpuinit.patch
-kernel-sysc-get-rid-of-expensive-divides-in-groups_sort.patch
-debug_smp_processor_id-fixlets.patch
-use-ilog2-in-fs-namespacec.patch
-use-ilog2-in-fs-namespacec-fix.patch
-docs-convert-kref-semaphore-to-mutex.patch
-fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch
-fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline-update.patch
-maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources.patch
-make-sys_poll-wait-at-least-timeout-ms.patch
-ds1wm-decouple-host-irq-and-intr-active-state-settings.patch
-documentation-add-hint-about-call-traces-module-symbols-to-bug-hunting.patch
-claim-maintainership-for-block2mtd-and-update-email-addresses.patch
-phantom-dont-grab-other-devices.patch
-system-timer-fix-crash-in-100hz-system-timer.patch
-system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
-speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
-tpm-infineon-section-mismatch.patch
-w1-remove-unused-and-confusing-variable.patch
-drivers-cdrom-cdromc-simplify-logic-in-cdrom_release.patch
-w1-w1_thermc-standardize-units-to-millidegrees-c.patch
-atari-floppy-rename-disk_type-to-atari_disk_type.patch
-spi-core-stop-updating-dev-powerpower_state.patch
-atmel_spi-throughput-improvement.patch
-atmel_spi-chain-dma-transfers.patch
-atmel_spi-chain-dma-transfers-update.patch
-atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
-spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch
-spi-superh-spi-using-sci.patch
-spi_imx-spelling-fixes.patch
-spi-omap2_mcspi-handles-omap3-too.patch
-spi_bfin-remove-useless-fault-path.patch
-spi_bfin-use-more-useful-gpio-labels.patch
-spi_bfin-wait-for-tx-to-complete-on-some-cs_chg-paths.patch
-spi_bfin-wait-for-tx-to-complete-on-full-duplex-paths.patch
-spi_bfin-wait-for-tx-to-complete-on-write-paths.patch
-spi_bfin-headers-are-not-for-changelogs.patch
-kprobes-kretprobe-user-entry-handler-updated.patch
-gigaset-clean-up-urb-status-usage.patch
-gigaset-code-cleanups.patch
-bas_gigaset-suspend-support-v2.patch
-usb_gigaset-suspend-support-v3.patch
-gigaset-atomic-cleanup.patch
-gigaset-permit-module-unload.patch
-ser_gigaset-convert-mutex-to-completion.patch
-fix-and-typo-in-eicons-addinfo.patch
-drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch
-fs-ecryptfs-possible-cleanups.patch
-ecryptfs-track-header-bytes-rather-than-extents.patch
-ecryptfs-set-inode-key-only-once-per-crypto-operation.patch
-ecryptfs-make-show_options-reflect-actual-mount-options.patch
-ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
-ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
-ecryptfs-minor-fixes-to-printk-messages.patch
-ecryptfs-change-the-type-of-cipher_code-from-u16-to-u8.patch
-ecryptfs-check-for-existing-key_tfm-at-mount-time.patch
-fuse-fix-attribute-caching-after-create.patch
-fuse-save-space-in-struct-fuse_req.patch
-fuse-limit-queued-background-requests.patch
-cosmetic-fixes-to-rtc-subsystems-kconfig.patch
-rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
-rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
-rtc-cmos-exports-nvram-in-sysfs.patch
-rtc-ds1302-rtc-support.patch
-rtc-ds1302-rtc-support-checkpatch-fixes.patch
-rtc-cmos-alarm-acts-as-oneshot.patch
-platform-real-time-clock-driver-for-dallas-1511-chip.patch
-blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz.patch
-blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler.patch
-blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs.patch
-blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp.patch
-blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch
-blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment.patch
-blackfin-rtc-driver-convert-sync-wait-to-use-the-irq-write-complete-notice.patch
-add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
-add-hpet-rtc-emulation-to-rtc_drv_cmos-fix.patch
-driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2.patch
-rtc-add-support-for-epson-rtc-9701je-v2.patch
-rtc-add-support-for-epson-rtc-9701je-v4.patch
-rtc-ds1307-ds_1340-change-init.patch
-rtc-update-documentation-wrt-irq_set_freq.patch
-rtc-cleanup-example-code.patch
-w1-gpio-add-gpio-w1-bus-master-driver.patch
-w1-gpio-add-gpio-w1-bus-master-driver-v3.patch
-make-video-geode-lxfb_corecgeode_modedb-static.patch
-video-hpfbc-section-fix.patch
-drivers-video-remove-unnecessary-pci_dev_put.patch
-fbmon-remove-unnecessary-local-variable.patch
-fbmon-cleanup-trailing-whitespaces.patch
-fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
-fb-defio-nopage.patch
-atmel_lcdfb-validate-display-timings.patch
-vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
-fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
-fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
-drivers-video-pm3fbc-section-fix.patch
-neofb-avoid-overwriting-fb_info-fields.patch
-vermilionc-use-align-not-__align_mask.patch
-fb-nvidiafb-try-harder-at-initial-mode-setting.patch
-tdfxfb-fix-section-mismatch-warnings.patch
-uvesafb-small-cleanups.patch
-drivers-video-add-missing-pci_dev_get.patch
-sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
-sm501fb-clear-framebuffer-memory-and-palette.patch
-atmel_lcdfb-backlight-control.patch
-atmel_lcdfb-backlight-control-tiny-rework.patch
-ps3av-ps3av_get_scanmode-and-ps3av_get_refresh_rate-are-unused.patch
-ps3-use-symbolic-names-for-video-modes.patch
-ps3fb-kill-ps3fb_full_mode_bit.patch
-ps3fb-inline-macros-that-are-used-only-once.patch
-ps3fb-kill-ps3fb_res.patch
-ps3fb-make-frame-buffer-offsets-unsigned-int.patch
-ps3fb-add-support-for-configurable-black-borders.patch
-ps3fb-reorganize-modedb-handling.patch
-ps3fb-round-up-video-modes.patch
-ps3fb-cleanup-sweep.patch
-ps3fb-fix-modedb-typos.patch
-pm2fb-big-endian-fix.patch
-fb-sm501-ensure-console-suspended-before-saving-state.patch
-fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver.patch
-fb-s3c2410-update-debugging-in-s3c2410-framebuffer-driver.patch
-fb-s3c2410-ensure-s3c2410-framebuffer-clears-initial-memory-to-black.patch
-fb-s3c2410-check-default_display-parameter-passed-in-platform-data.patch
-fbcon-fix-color-generation-for-monochrome-framebuffer.patch
-i810fb-module-parameter-mode_option-inconsistent-with-other-framebuffer-modules.patch
-coding-style-cleanups-for-drivers-md-mktablesc.patch
-md-raid6-fix-mktablec.patch
-md-raid6-clean-up-the-style-of-raid6test-testc.patch
-md-update-md-bitmap-during-resync.patch
-md-update-md-bitmap-during-resync-fix.patch
-md-support-external-metadata-for-md-arrays.patch
-md-give-userspace-control-over-removing-failed-devices-when-external-metdata-in-use.patch
-md-allow-a-maximum-extent-to-be-set-for-resyncing.patch
-md-set-and-test-the-persistent-flag-for-md-devices-more-consistently.patch
-md-allow-devices-to-be-shared-between-md-arrays.patch
-md-lock-address-when-changing-attributes-of-component-devices.patch
-md-allow-an-md-array-to-appear-with-0-drives-if-it-has-external-metadata.patch
-md-fix-use-after-free-bug-when-dropping-an-rdev-from-an-md-array.patch
-md-change-a-few-int-to-size_t-in-md.patch
-md-change-interate_mddev-to-for_each_mddev.patch
-md-change-interate_mddev-to-for_each_mddev-fix.patch
-md-change-iterate_rdev-to-rdev_for_each.patch
-md-change-iterate_rdev-to-rdev_for_each-fix.patch
-md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending.patch
-md-fix-an-occasional-deadlock-in-raid5.patch
-md-fix-an-occasional-deadlock-in-raid5-fix.patch
-pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch
-declare-pnp-option-parsing-functions-as-__init.patch
-declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
-isapnp-driver-semaphore-to-mutex.patch
-isapnp-driver-semaphore-to-mutex-fix.patch
-isapnp-driver-semaphore-to-mutex-fix-fix.patch
-pnp-do-not-test-pnp_driver_res_do_not_change-on-suspend-resume.patch
-pnp-disable-supermicro-h8dce-motherboard-resources-that-overlap-sata-bars.patch
-ext2-add-block-bitmap-validation.patch
-ext3-add-block-bitmap-validation.patch
-bkl-removal-convert-ext2-over-to-use-unlocked_ioctl.patch
-bkl-removal-remove-incorrect-bkl-comment-in-ext2.patch
-bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2.patch
-make-jbd-journalc__journal_abort_hard-static.patch
-ext3-return-after-ext3_error-in-case-of-failures.patch
-ext3-change-the-default-behaviour-on-error.patch
-ext-fix-comment-for-nonexistent-variable.patch
-ext-use-ext_get_group_desc.patch
-ext-remove-unused-argument-for-ext_find_goal.patch
-ext-cleanup-ext_bg_num_gdb.patch
-ext3-remove-unused-code-from-ext3_find_entry.patch
-jbdh-hide-kernel-only-code.patch
-ext3-fix-lock-inversion-in-direct-io.patch
-ext3-fix-lock-inversion-in-direct-io-fix.patch
-add-missing-section-ids-to-genericirqtmpl.patch
-add-missing-section-ids-to-genericirqtmpl-updated.patch
-add-missing-section-id-to-lsmtmpl.patch
-add-section-ids-to-mtdnandtmpl.patch
-add-missing-ids-to-procfs-guidetmpl.patch
-add-section-ids-to-rapidiotmpl.patch
-add-table-ids-to-videobooktmpl.patch
-add-chapter-ids-to-z8530booktmpl.patch
-move-edactxt-two-levels-up.patch
-remove-documentation-smptxt.patch
-documentation-move-dnotifytxt-to-filesystems.patch
-documentation-move-sharedsubtreestxt-to-filesystems.patch
-documentation-create-new-scheduler-subdirectory.patch
-reporting-bugs-cc-the-mailing-list-too.patch
-kernel-doc-prevent-duplicate-description-output.patch
-kernel-doc-warn-on-badly-formatted-short-description.patch
-email-clientstxt-sylpheed-is-ok-at-imap.patch
-doc-use-correct-debugfs-mountpoint.patch
-kernel-cgroupc-remove-dead-code.patch
-cgroup-brace-coding-style-fix.patch
-cgroup-simplify-space-stripping.patch
-cgroup-simplify-space-stripping-fix.patch
-cgroups-move-cgroups-destroy-callbacks-to-cgroup_diput.patch
-kernel-cgroupc-make-2-functions-static.patch
-memory-controller-add-documentation.patch
-memcgroup-temporarily-revert-swapoff-mod.patch
-memory-controller-resource-counters-v7.patch
-memory-controller-containers-setup-v7.patch
-memory-controller-accounting-setup-v7.patch
-memory-controller-memory-accounting-v7.patch
-memory-controller-task-migration-v7.patch
-memory-controller-add-per-container-lru-and-reclaim-v7.patch
-memory-controller-improve-user-interface.patch
-memory-controller-oom-handling-v7.patch
-memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
-memory-controller-make-page_referenced-container-aware-v7.patch
-memory-controller-make-charging-gfp-mask-aware.patch
-memcgroup-reinstate-swapoff-mod.patch
-memory-controller-bug_on.patch
-mem-controller-gfp-mask-fix.patch
-memcontrol-move-mm_cgroup-to-header-file.patch
-memcontrol-move-mm_cgroup-to-header-file-fix.patch
-memcontrol-move-mm_cgroup-to-header-file-fix-2.patch
-memcontrol-move-oom-task-exclusion-to-tasklist.patch
-oom-add-sysctl-to-enable-task-memory-dump.patch
-kswapd-should-only-wait-on-io-if-there-is-io.patch
-bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
-bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
-bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
-bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
-bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
-bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
-memcgroup-fix-zone-isolation-oom.patch
-memcgroup-revert-swap_state-mods.patch
-memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
-memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
-memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
-memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
-memcgroup-tidy-up-mem_cgroup_charge_common.patch
-memcgroup-fix-hang-with-shmem-tmpfs.patch
-memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
-memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
-memory-cgroup-enhancements-add-memorystat-file.patch
-memory-cgroup-enhancements-add-pre_destroy-handler.patch
-memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
-memory-controller-remove-control_type-feature.patch
-update-documentation-controller-memorytxt.patch
-cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
-cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
-cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
-hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
-hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
-cpusets-update_cpumask-revision.patch
-cpusets-update_cpumask-revision-fix.patch
-cpusets-update_cpumask-revision-checkpatch-fixes.patch
-cgroups-update-comments-in-cpusetc.patch
-handle-pid-namespaces-in-cgroups-code.patch
-tty-kill-tty_flipbuf_size.patch
-asic3-driver.patch
-asic3-driver-update.patch
-asic3-driver-update-2.patch
-drivers-edac-turnon-edac-device-error-logging.patch
-drivers-edac-use-round_jiffies_relative.patch
-drivers-edac-add-cell-xdr-memory-types.patch
-drivers-edac-add-cell-mc-driver.patch
-drivers-edac-i3000-code-tidying.patch
-drivers-edac-i3000-replace-macros-with-functions.patch
-drivers-edac-add-freescale-mpc85xx-driver.patch
-drivers-edac-add-marvell-mv64x60-driver.patch
-drivers-edac-add-marvell-mv64x60-driver-fix.patch
-drivers-edac-pci-broken-parity-regression.patch
-drivers-edac-i3000-64bit-build.patch
-drivers-edac-mpc85xx-add-static-scope.patch
-drivers-edac-i3000-missing-init-code.patch
-drivers-edac-i3000-document-type-promotion.patch
-dzh-remove-useless-unused-module-junk.patch
-dz-always-check-if-it-is-safe-to-console_putchar.patch
-dz-dont-panic-when-request_irq-fails.patch
-dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
-dz-update-kconfig-description.patch
-dz-rename-the-serial-console-structure.patch
-dz-fix-locking-issues.patch
-dz-handle-special-conditions-on-reception-correctly.patch
-maintainers-add-self-for-the-dz-serial-driver.patch
-dz-clean-up-and-improve-the-setup-of-termios-settings.patch
-dzc-use-a-helper-to-cast-from-struct-uart_port.patch
-dzc-resource-management.patch
-fs-menu-small-reorg.patch
-introduce-flags-for-reserve_bootmem.patch
-introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
-use-bootmem_exclusive-for-kdump.patch
-vmcoreinfo-rename-vmcoreinfos-macros-returning-the-size.patch
-vmcoreinfo-use-the-existing-offsetof-for-vmcoreinfo_offset.patch
-vmcoreinfo-add-vmcoreinfo_-to-all-the-call-for-vmcoreinfo_append_str.patch
-vmcoreinfo-fix-the-configuration-dependencies.patch
-vmcoreinfo-fix-the-configuration-dependencies-fix.patch
-mbcs-convert-algolock-to-mutex.patch
-mbcs-convert-dmawritelock-to-mutex.patch
-mbcs-convert-dmareadlock-to-mutex.patch
-add-an-err_cast-function-to-complement-err_ptr-and-co.patch
-convert-err_ptrptr_errp-instances-to-err_castp.patch
-iget-introduce-a-function-to-register-iget-failure.patch
-iget-use-iget_failed-in-afs.patch
-iget-use-iget_failed-in-gfs2.patch
-iget-stop-affs-from-using-iget-and-read_inode-try.patch
-iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
-iget-stop-autofs-from-using-iget-and-read_inode.patch
-iget-stop-befs-from-using-iget-and-read_inode-try.patch
-iget-stop-bfs-from-using-iget-and-read_inode-try.patch
-iget-stop-bfs-from-using-iget-and-read_inode-try-fix.patch
-iget-stop-cifs-from-using-iget-and-read_inode-try.patch
-iget-stop-efs-from-using-iget-and-read_inode-try.patch
-iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
-iget-stop-ext2-from-using-iget-and-read_inode-try.patch
-iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
-iget-stop-ext3-from-using-iget-and-read_inode-try.patch
-iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
-iget-stop-ext4-from-using-iget-and-read_inode-try.patch
-iget-stop-fat-from-using-iget-and-read_inode-try.patch
-iget-stop-freevxfs-from-using-iget-and-read_inode.patch
-iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
-iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
-iget-stop-fuse-from-using-iget-and-read_inode-try.patch
-iget-stop-hfsplus-from-using-iget-and-read_inode.patch
-iget-stop-isofs-from-using-read_inode.patch
-iget-stop-isofs-from-using-read_inode-fix-2.patch
-iget-stop-isofs-from-using-read_inode-fix-2-update.patch
-iget-stop-isofs-from-using-read_inode-fix-2-update-fix.patch
-iget-stop-jffs2-from-using-iget-and-read_inode.patch
-iget-stop-jfs-from-using-iget-and-read_inode-try.patch
-iget-stop-the-minix-filesystem-from-using-iget-and.patch
-iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
-iget-stop-procfs-from-using-iget-and-read_inode.patch
-iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
-iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
-iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
-iget-stop-romfs-from-using-iget-and-read_inode.patch
-iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
-iget-stop-the-sysv-filesystem-from-using-iget-and.patch
-iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
-iget-stop-ufs-from-using-iget-and-read_inode-try.patch
-iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
-iget-stop-openpromfs-from-using-iget-and.patch
-iget-stop-hostfs-from-using-iget-and-read_inode.patch
-iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
-iget-stop-hppfs-from-using-iget-and-read_inode.patch
-iget-remove-iget-and-the-read_inode-super-op-as.patch
-iget-stop-unionfs-from-using-iget-and-read_inode.patch
-iget-stop-unionfs-from-using-iget-and-read_inode-fix.patch
-iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
-dca-convert-struct-class_device-to-struct-device.patch
-unexport-asm-userh-and-linux-userh.patch
-cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed.patch
-cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed-fix.patch
-unexport-asm-elfh.patch
-unexport-asm-pageh.patch
-sanitize-the-type-of-struct-useru_ar0.patch
-add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
-add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
-add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
-add-cmpxchg64-and-cmpxchg64_local-to-powerpc.patch
-add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
-add-cmpxchg_local-to-arm.patch
-add-cmpxchg_local-to-avr32.patch
-add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
-add-cmpxchg_local-to-cris.patch
-add-cmpxchg_local-to-frv.patch
-add-cmpxchg_local-to-h8300.patch
-add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
-new-cmpxchg_local-optimized-for-up-case-for-m32r.patch
-fix-m32r-__xchg.patch
-m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch
-local_t-m32r-use-architecture-specific-cmpxchg_local.patch
-add-cmpxchg_local-to-m86k.patch
-add-cmpxchg_local-to-m68knommu.patch
-add-cmpxchg_local-to-parisc.patch
-add-cmpxchg_local-to-ppc.patch
-add-cmpxchg_local-to-s390.patch
-add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
-add-cmpxchg_local-to-sparc64.patch
-add-cmpxchg_local-to-v850.patch
-add-cmpxchg_local-to-xtensa.patch
-i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
-i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
-i8k-inspiron-e1705-fix.patch
-dont-touch-fs_struct-in-drivers.patch
-dont-touch-fs_struct-in-usermodehelper.patch
-remove-path_release_on_umount.patch
-move-struct-path-into-its-own-header.patch
-embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
-embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
-embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-nfs4-fix.patch
-embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
-embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
-embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
-introduce-path_put.patch
-introduce-path_put-cifs-fix.patch
-use-path_put-in-a-few-places-instead-of-mntdput.patch
-introduce-path_get.patch
-use-struct-path-in-fs_struct.patch
-make-set_fs_rootpwd-take-a-struct-path.patch
-introduce-path_get-unionfs.patch
-embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
-introduce-path_put-unionfs.patch
-one-less-parameter-to-__d_path.patch
-one-less-parameter-to-__d_path-checkpatch-fixes.patch
-d_path-kerneldoc-cleanup.patch
-d_path-use-struct-path-in-struct-avc_audit_data.patch
-d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
-d_path-make-proc_get_link-use-a-struct-path-argument.patch
-d_path-make-get_dcookie-use-a-struct-path-argument.patch
-d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
-use-struct-path-in-struct-svc_export.patch
-use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
-use-struct-path-in-struct-svc_export-nfsd-fix-wrong-mnt_writer-count-in-rename.patch
-use-struct-path-in-struct-svc_expkey.patch
-d_path-make-seq_path-use-a-struct-path-argument.patch
-d_path-make-d_path-use-a-struct-path.patch
-d_path-make-d_path-use-a-struct-path-fix.patch
-dentries-extract-common-code-to-remove-dentry-from-lru.patch
-dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
-char-rocket-switch-long-delay-to-sleep.patch
-char-rocket-printk-cleanup.patch
-char-rocket-remove-useless-macros.patch
-char-char-serial-remove-serial_type_normal-redefines.patch
-char-mxser_new-ioaddresses-are-ulong.patch
-char-stallion-fix-compiler-warnings.patch
-char-riscom8-change-rc_init_drivers-prototype.patch
-char-esp-remove-hangup-and-wakeup-bottomhalves.patch
-char-istallion-remove-hangup-bottomhalf.patch
-char-specialix-remove-bottomhalves.patch
-char-stallion-remove-bottomhalf.patch
-char-serial167-remove-bottomhalf.patch
-char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch
-mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
-char-mxser-remove-special-baudrate-processing.patch
-char-mxser-0-to-null-in-pointer.patch
-char-mxser-reorder-mxser_cardinfo-fields.patch
-char-mxser-simplify-mxser_get_serial_info.patch
-char-mxser-ioctl-cleanup.patch
-char-mxser-remove-it.patch
-char-mxser-add-support-for-cp-114ul.patch
-add-the-namespaces-config-option.patch
-move-the-uts-namespace-under-uts_ns-option.patch
-move-the-ipc-namespace-under-ipc_ns-option.patch
-cleanup-the-code-managed-with-the-user_ns-option.patch
-cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
-cleanup-the-code-managed-with-pid_ns-option.patch
-cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
-mark-net_ns-with-depends-on-namespaces.patch
-proc-less-lock-operations-during-lookup.patch
-proc-simplify-function-prototypes.patch
-proc-remove-useless-check-on-symlink-removal.patch
-proc-detect-duplicate-names-on-registration.patch
-proc-detect-duplicate-names-on-registration-fix.patch
-proc-implement-proc_single_file_operations.patch
-proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
-proc-seqfile-convert-proc_pid_statm.patch
-proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
-proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
-proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
-proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
-proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
-proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
-proc-proper-pidns-handling-for-proc-self.patch
-proc-fix-the-threaded-proc-self.patch
-proc-fix-openless-usage-due-to-proc_fops-flip.patch
-proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
-pid-namespaces-vs-locks-interaction.patch
-intel-iommu-pmen-support.patch
-intel-iommu-pmen-support-fix.patch
-intel-iommu-fault_reason_index_cleanuppatch.patch
-intel-iommu-fault_reason_index_cleanuppatch-fix.patch
-tty-let-architectures-override-the-user-kernel-macros.patch
-tty-s390-support-for-termios2.patch
-modules-handle-symbols-that-have-a-zero-value.patch
-modules-include-sectionsh-to-avoid-defining-linker-variables.patch
-modules-make-module_address_lookup-safe-fix.patch
-moxa-first-pass-at-termios-reporting.patch
-n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch
-rocket-first-pass-at-termios-reporting.patch
-rocket-dont-let-random-users-reset-the-controller.patch
-tty_audit-fix-checkpatch-complaint.patch
-tty_io-drag-screaming-into-coding-style-compliance.patch
-tty_ioctl-drag-screaming-into-compliance-with-the-coding.patch
-8250_early-coding-style.patch
-8250_gsc-coding-style.patch
-8250_hp300-coding-style.patch
-8250_hub6-codding-style.patch
-8250_pci-coding-style.patch
-serial8250-coding-style.patch
-8250-enable-rate-reporting-via-termios.patch
-serial_core-bring-mostly-into-line-with-coding-style.patch
-ipc-uninline-some-code-from-utilh.patch
-ipc-semaphores-consolidate-sem_stat-and.patch
-ipc-make-struct-ipc_ids-static-in-ipc_namespace.patch
-ipc-consolidate-sem_exit_ns-msg_exit_ns-and-shm_exit_ns.patch
-kill-pt_attached.patch
-kill-my_ptrace_child.patch
-ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
-ptrace_stop-fix-the-race-with-ptrace-detachattach.patch
-wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
-wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
-do_wait-factor-out-retval-=-0-checks.patch
-ptrace_stop-fix-racy-nonstop_code-setting.patch
-wait_task_stopped-remove-unneeded-delay_group_leader-check.patch
-do_wait-cleanup-delay_group_leader-usage.patch
-do_wait-fix-security-checks.patch
-do_wait-fix-security-checks-fix.patch
-wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch
-wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch
-sys_setpgid-simplify-pid-ns-interaction.patch
-fix-setsid-for-sub-namespace-sbin-init.patch
-teach-set_special_pids-to-use-struct-pid.patch
-move-daemonized-kernel-threads-into-the-swappers-session.patch
-start-the-global-sbin-init-with-00-special-pids.patch
-fix-group-stop-with-exit-race.patch
-sys_setsid-remove-now-unneeded-session-=-1-check.patch
-move-the-related-code-from-exit_notify-to-exit_signals.patch
-pid-sys_wait-fixes-v2.patch
-pid-sys_wait-fixes-v2-checkpatch-fixes.patch
-pid-extend-fix-pid_vnr.patch
-sys_getsid-dont-use-nsproxy-directly.patch
-pid-fix-mips-irix-emulation-pid-usage.patch
-pid-fix-mips-irix-emulation-pid-usage-fix.patch
-pid-fix-solaris_procids.patch
-uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
-uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
-itimer_real-convert-to-use-struct-pid.patch
-pidns-make-full-use-of-xxx_vnr-calls.patch
-pidns-fix-badly-converted-mqueues-pid-handling.patch
-clocksource-remove-redundant-code.patch
-clockevent-simplify-list-operations.patch
-timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
-time-fix-typo-in-comments.patch
-time-delete-comments-that-refer-to-noexistent-symbols.patch
-aout-move-stack_top-to-asm-processorh.patch
-aout-mark-arches-that-support-aout-format.patch
-aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
-aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
-aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
-aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
-aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
-aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
-usb-net2280-cant-have-a-function-called-show_registers.patch
-mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
-mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
-mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
-mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
-rewrite-rd.patch
-rewrite-rd-fix.patch
-rewrite-rd-fixes.patch
-rewrite-rd-fix-2.patch
-rd-support-xip.patch
-linux-kernel-markers-support-multiple-probes.patch
-linux-kernel-markers-support-multiple-probes-update.patch
-linux-kernel-markers-create-modpost-file.patch
-cramfs-update-documentation.patch
-fs-remove-fastcall-it-is-always-empty.patch
-fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
-kernel-remove-fastcall-in-kernel.patch
-kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
-lib-remove-fastcall-from-lib.patch
-lib-remove-fastcall-from-lib-checkpatch-fixes.patch
-remove-fastcall-from-linux-include.patch
-remove-fastcall-from-linux-include-checkpatch-fixes.patch
-asm-generic-remove-fastcall.patch
-misc-removal-of-final-callers-using-fastcall.patch
-constify-tables-in-kernel-sysctl_checkc.patch
-constify-tables-in-kernel-sysctl_checkc-fix.patch
-aoe-bring-driver-version-number-to-47.patch
-aoe-handle-multiple-network-paths-to-aoe-device.patch
-aoe-mac_addr-avoid-64-bit-arch-compiler-warnings.patch
-aoe-clean-up-udev-configuration-example.patch
-aoe-eliminate-goto-and-improve-readability.patch
-aoe-user-can-ask-driver-to-forget-previously-detected-devices.patch
-aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary.patch
-aoe-only-install-new-aoe-device-once.patch
-aoe-add-module-parameter-for-users-who-need-more-outstanding-i-o.patch
-aoe-the-aoeminor-doesnt-need-a-long-format.patch
-aoe-make-error-messages-more-specific.patch
-aoe-update-copyright-date.patch
-aoe-statically-initialise-devlist_lock.patch
-use-pgoff_t-instead-of-unsigned-long.patch
-byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core.patch
-ext3-replace-all-adds-to-little-endians-variables-with-le_add_cpu.patch
-xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
-xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
-fixup-container_of-usage.patch
-aio-partial-write-should-not-return-error-code.patch
-aio-negative-offset-should-return-einval.patch
-ext2-remove-unused-ext2_put_inode-prototype.patch
-ufs-fix-symlink-creation-on-ufs2.patch
-ufs-fix-symlink-creation-on-ufs2-fix.patch
-asm-posix_typesh-scrub-__glibc__.patch
-allow-executables-larger-than-2gb.patch
-write_inode_now-avoid-unnecessary-synchronous-write.patch
-nuke-duplicate-include-from-printkc.patch
-nuke-a-duplicate-include-from-profilec.patch
-nuke-duplicate-header-from-sysctlc.patch
-libfs-allow-error-return-from-simple-attributes.patch
-libfs-allow-error-return-from-simple-attributes-fix.patch
-libfs-make-simple-attributes-interruptible.patch
-libfs-rename-simple_attr_close-to-simple_attr_release.patch
-udf-fix-coding-style-of-superc.patch
-udf-remove-some-ugly-macros.patch
-udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function.patch
-udf-check-if-udf_load_logicalvol-failed.patch
-udf-convert-macros-related-to-bitmaps-to-functions.patch
-udf-move-calculating-of-nr_groups-into-helper-function.patch
-udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
-udf-fix-coding-style.patch
-udf-create-common-function-for-tag-checksumming.patch
-udf-create-common-function-for-changing-free-space-counter.patch
-udf-replace-loops-coded-with-goto-to-real-loops.patch
-udf-convert-byte-order-of-constant-instead-of-variable.patch
-udf-remove-udf_i_-macros-and-open-code-them.patch
-udf-cache-struct-udf_inode_info.patch
-udf-fix-udf_debug-macro.patch
-udf-improve-readability-of-udf_load_partition.patch
-kill-udffs_dateversion.patch
-udf-remove-wrong-prototype-of-udf_readdir.patch
-udf-fix-3-signedness-1-unitialized-variable-warnings.patch
-udf-fix-signedness-issue.patch
-udf-avoid-unnecessary-synchronous-writes.patch
-udf-cleanup-directory-offset-handling.patch
-udf-fix-adding-entry-to-a-directory.patch
-change-udf-maintainer.patch
-fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
-fs-afs-securityc-fix-uninitialized-var-warning.patch
-update-checkpatchpl-to-version-013.patch
-remove-the-unused-exports-of-sys_open--sys_read-for-2625.patch
-the-scheduled-time-option-removal.patch
-parport_ieee1284_epp_read_addr-patch.patch
-smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
-maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver.patch
-atmel_serial-clean-up-the-code.patch
-atmel_serial-use-cpu_relax-when-busy-waiting.patch
-atmel_serial-use-existing-console-options-only-if-brg-is-running.patch
-atmel_serial-fix-bugs-in-probe-error-path-and-remove.patch
-atmel_serial-split-the-interrupt-handler.patch
-atmel_serial-add-dma-support.patch
-atmel_serial-add-dma-support-fix.patch
-atmel_serial-fix-broken-rx-buffer-allocation.patch
-atmel_serial-use-container_of-instead-of-direct-cast.patch
-atmel_serial-show-tty-name-in-proc-interrupts.patch
-workqueue-make-delayed_work_timer_fn-static.patch
-isofs-implement-dmode-option.patch
-isofs-implement-dmode-option-fix.patch
-reiserfs-constify-function-pointer-tables.patch
-procfs-constify-function-pointer-tables.patch
-oss-constify-function-pointer-tables.patch
-basic-pwm-driver-for-avr32-and-at91.patch
-basic-pwm-driver-for-avr32-and-at91-fix.patch
-pwm-led-driver.patch
-bkl-removal-convert-pipe-to-use-unlocked_ioctl-too.patch
-remove-__strict_ansi__-from-linux-typesh.patch
-kill-do_generic_mapping_read.patch
-printk_ratelimit-functions-should-use-config_printk.patch
-avoid-overflows-in-kernel-timec.patch
-drop-linux-ufs_fsh-from-userspace-export-and-relocate-it-to-fs-ufs-ufs_fsh.patch
-mount-options-add-documentation.patch
-mount-options-add-generic_show_options.patch
-mount-options-fix-adfs.patch
-mount-options-fix-affs.patch
-mount-options-fix-afs.patch
-mount-options-fix-autofs4.patch
-mount-options-fix-autofs.patch
-mount-options-fix-befs.patch
-mount-options-fix-capifs.patch
-mount-options-fix-devpts.patch
-mount-options-fix-ext2.patch
-mount-options-fix-fat.patch
-mount-options-fix-fuse.patch
-mount-options-fix-hostfs.patch
-mount-options-fix-hpfs.patch
-mount-options-fix-hugetlbfs.patch
-mount-options-fix-isofs.patch
-mount-options-fix-ncpfs.patch
-mount-options-fix-reiserfs.patch
-mount-options-fix-spufs.patch
-mount-options-fix-tmpfs.patch
-mount-options-fix-tmpfs-fix.patch
-mount-options-fix-udf.patch
-char-applicom-use-pci_resource_start.patch
-char-applicom-use-pci_match_id.patch
-char-applicom-use-pci_match_id-fix.patch
-nbd-remove-limit-on-max-number-of-nbd-devices.patch
-#vfs-create-proc-pid-mountinfo.patch: several akpm issues...
-use-find_task_by_vpid-in-posix-timers.patch
-dont-operate-with-pid_t-in-rtmutex-tester.patch
-remove-aout-interpreter-support-in-elf-loader.patch
-use-__u32-in-linux-reiserfs_fsh.patch
-cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus.patch
-cpu-fix-section-mismatch-related-to-cpu_chain.patch
-cpu-do-not-annotate-exported-register_cpu_notifier.patch
-cpu-silence-section-mismatch-warnings-for-hotcpu-notifies.patch
-getdelays-fix-gcc-warnings.patch
-add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them.patch
-add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
-convert-loglevel-related-kernel-boot-parameters-to-early_param.patch

 Merged into mainline or a subsystem tree

+revert-send-a-single-notification-on-device-state-changes.patch
+uml-fix-initrd-printk.patch
+uml-update-defconfig.patch
+arch-um-kernel-memc-fix-a-shadowed-variable.patch
+make-lkdtm-depend-on-block.patch
+fuse-fix-permission-checking.patch
+mn10300-define-hz-as-a-config-option.patch
+mn10300-define-so_mark.patch

 2.6.25 queue

+samples-build-fix.patch

 Maybe 2.6.25 queue

+softlockup-workaround.patch

 Make poweroff work on one of my test boxes.

+check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch

 Linus spat this back

+git-acpi-powerpc-kconfig-fix.patch

 Make git-acpi.patch compile

-acpi-enable-c3-power-state-on-dell-inspiron-8200-update.patch

 Folded into acpi-enable-c3-power-state-on-dell-inspiron-8200.patch

+miscacpibacklight-compal-laptop-extras-3rd-try.patch
+remove-is_processor_present-prototype.patch
+acpi-use-acpi_debug_print-instead-of-printk.patch

 acpi things

-git-alsa-disable-sound-pci-ice1712-ice1724c.patch

 Unneeded

+git-agpgart-make-ia64-compile.patch

 unbork git-agpgart

-git-audit-master-fix-git-rejects.patch

 Unneeded

+cpufreq-change-cpu-freq-tables-to-per_cpu-variables.patch

 cpufreq fix

-agk-dm-dm-loop.patch
-revert-agk-dm-dm-loop.patch

 Dropped

+enable-hotplug-memory-remove-for-ppc64.patch

 oops, this shouldn't be here.

+git-dvb-someone-broke-the-gpio-includes.patch

 work around dvb build problem

+jdelvare-i2c-i2c-pxa-misc-fixes.patch
+jdelvare-i2c-i2c-no-algos-in-kconfig.patch
+jdelvare-i2c-i2c-pca-02-extension-of-pca-algorithm.patch

 I2C tree updates

-oz99x-i2c-button-and-led-support-driver-update.patch

 Folded into oz99x-i2c-button-and-led-support-driver.patch

-adt7473-new-driver-for-analog-devices-adt7473-sensor-chip-fix.patch

 Folded into adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch

-applesmc-sensors-set-for-macbook2-try-2.patch

 Folded into applesmc-sensors-set-for-macbook2.patch

+dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch

 DLM fix

-infiniband-is-scrogged-again.patch

 Unneeded

+input-i8042-fix-warning-on-non-x86-builds.patch

 input warning fix

+apanel-fix-kconfig-dependencies.patch
+keyboard-notifier-documentation.patch

 input things

+leds-add-mail-led-support-for-clevo-d400p.patch

 LED device driver

+libata-isolate-and-rework-cable-logic.patch
+ata-fix-sparse-warning-in-libatah.patch

 ata things

+ide-mm-ide-add-missing-base-addresses-for-falconide-and-macide.patch
+ide-mm-ide-tape-schedule-driver-for-removal-after-6-months.patch
+ide-mm-ide-generic-set-hwif-chipset.patch
+ide-mm-ide-fix-ide_find_port.patch
+ide-mm-ide-use-ide_find_port-instead-of-ide_deprecated_find_port.patch
+ide-mm-ide-acpi-add-missing-drive-acpidata-zeroing.patch
+ide-mm-ide-factor-out-cable-detection-from-ide_init_port.patch
+ide-mm-ide-factor-out-unregistering-devices-from-ide_unregister.patch
+ide-mm-ide-factor-out-devices-init-from-ide_init_port_data.patch
+ide-mm-ide-move-ide_port_setup_devices-call-to-ide_device_add_all.patch
+ide-mm-ide-rework-powermac-media-bay-support.patch
+ide-mm-ide-add-warm-plug-support-for-ide-devices.patch
+ide-mm-ide-add-ide_generic-class-and-attribute-for-adding-new-interfaces.patch
+ide-mm-ide-remove-needless-config_blk_dev_hd-hack-from-init_hwif.patch
+ide-mm-ide-remove-config_blk_dev_hd_ide-config-option.patch
+ide-mm-ide-remove-obsoleted-idex-base_-ctl_-irq_-kernel-parameters.patch
+ide-mm-ide-remove-broken-dangerous-ide-unregister-scan-hwif-ioctls-take-2.patch
+ide-mm-ide-remove-hold-field-from-ide_hwif_t-take-2.patch
+ide-mm-ide-remove-init_hwif_default.patch
+ide-mm-ide-remove-ide_init_hwif_ports.patch
+ide-mm-ide-floppy-remove-struct-idefloppy_id_gcw.patch
+ide-mm-ide-add-ide_atapi_discard_data-write_zeros-inline-helpers.patch
+ide-mm-ide-remove-ide_-_reg-macros.patch
+ide-mm-ide-tape-move-all-struct-and-other-defs-at-the-top.patch
+ide-mm-ide-tape-remove-atomic-test_set-macros-for-packet-commands.patch
+ide-mm-ide-add-generic-packet-command-representation-ide_atapi_pc.patch
+ide-mm-ide-tape-convert-driver-to-using-generic-ide_atapi_pc.patch
+ide-mm-ide-floppy-convert-driver-to-using-generic-ide_atapi_pc.patch
+ide-mm-ide-scsi-convert-driver-to-using-generic-ide_atapi_pc.patch
+ide-mm-ide-floppy-rename-end_request-handler-properly.patch
+ide-mm-ide-use-generic-atapi-packet-command-flags-in-ide-floppy-tape.patch
+ide-mm-ide-scsi-do-non-atomic-pc-flags-testing.patch

 IDE tree updates

+fix-ide-mm-ide-rework-powermac-media-bay-support.patch

 Fix it

+mtd-maps-document-mtd_physmap-module-name-in-kconfig.patch

 mtd fix

+fix-alignment-of-ip-config-output.patch

 net fixlet

-git-netdev-all-fix-conflicts-fix.patch

 Unneeded

+drivers-net-mv643xx_ethc-use-field_sizeof.patch
+qla3xxx-convert-byte-order-of-constant-instead-of-variable.patch
+3c509-convert-to-isa_driver-and-pnp_driver-v4.patch
+3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
+usb-net-asix-does-not-really-need-10-100mbit.patch

 netdev things

+git-nfsd-fix.patch

 Fix git-nfsd.patch

+ntfs-le_add_cpu-conversion.patch

 ntfs cleanup

+ocfs2-le_add_cpu-conversion.patch

 ocfs2 celanup

+gregkh-pci-pci-remove-pci_find_present.patch
+gregkh-pci-pci-remove-pci_get_device_reverse-from-calgary-driver.patch
+gregkh-pci-ide-remove-ide-reverse-ide-core.patch
+gregkh-pci-pci-remove-pci_get_device_reverse.patch
+gregkh-pci-pci-clean-up-searchc-a-lot.patch
+gregkh-pci-pci-hotplug-make-cpcihp-driver-use-modern-apis.patch
+gregkh-pci-pci-hotplug-the-ibm-driver-is-not-dependant-on-pci_legacy.patch
+gregkh-pci-pci-remove-initial-bios-sort-of-pci-devices-on-x86.patch
+gregkh-pci-pci-make-no_pci_devices-use-the-pci_bus_type-list.patch
+gregkh-pci-pci-add-is_added-flag-to-struct-pci_dev.patch
+gregkh-pci-pci-remove-pcibios_fixup_ghosts.patch
+gregkh-pci-pci-remove-global-list-of-pci-devices.patch

 PCI tree updates

-fix-gregkh-pci-pci-pcie-aspm-support.patch

 Unneeded

-quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch

 Flded into quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch

-x86-validate-against-acpi-motherboard-resources.patch

 Dropped, I think

+pci-iova-rb-tree-setup-tweak.patch

 PCI fix

+drivers-block-viodasdc-use-field_sizeof.patch

 s390 driver cleanup.

+git-sched-git-rejects.patch

 Fix git rejects in git-sched

+tracing-is-borked-on-powerpc.patch

 Fix build on non-x86

+execute-tasklets-in-the-same-order-they-were-queued.patch

 Fiddle with tasklet arrival/dispatch ordering

+scsi-qlogicptic-section-fixes.patch
+megaraid-outb_p-extermination.patch
+scsi-le_add_cpu-conversion.patch

 scsi things

+git-block-git-rejects.patch

 Fix rejects in git-block.patch

+git-unionfs-git-rejects.patch
+unionfs-is-broken.patch
+embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
+introduce-path_put-unionfs.patch
+iget-stop-unionfs-from-using-iget-and-read_inode.patch

 unionfs stff.  Needs updating: currently disabled

+gregkh-usb-usb-ftdi_sioc-add-missing.patch
+gregkh-usb-usb-sane-memory-allocation-in-option-driver.patch
+gregkh-usb-usb-add-usb-serial-spcp8x5-driver.patch

 USB tree updates

+drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
+usb-ehci-tolerates-some-buggy-devices.patch
+usbatm-switch-to-kthread-api-stop-using-kill_proc.patch
+hci_usb-another-device-with-buggy-sco-support.patch
+usb-serial-move-zte-mf330-from-sierra-to-option.patch
+cypress_m8-added-ups-powercom-0d9f0002.patch

 USB things

-git-watchdog-fixup.patch

 Unneeded

+git-watchdog-git-rejects.patch

 Fix git rejects

+it8712f_wdt-support-for-16-bit-timeout-values-wdioc_getstatus.patch

 watchdog driver support

+make-b43_mac_enablesuspend-static.patch
+wireless-rt2x00-fix-driver-menu-indenting.patch
+ipw2200-le_add_cpu-conversion.patch
+convert-acl-sem-in-a-mutex.patch
+convert-stats_sem-in-a-mutex.patch
+convert-wpa_sem-in-a-mutex.patch

 wireless things

+x86-visws-fix-printk-format-warnings.patch
+x86-minor-cleanup-of-comments-in-processorh.patch
+documentation-i386-io-apictxt-fix-description.patch

 x86 things

+xtensa-warn-about-including-asm-rwsemh-directly.patch

 xtensa tweak

+rtc-cmos-display-hpet-emulation-mode.patch
+register_memory-unregister_memory-fix-use-after-free-and-refcounting.patch
+acer-wmi-fail-gracefully-if-acpi-is-disabled.patch
+tc1100-wmi-fail-gracefully-if-acpi-is-disabled.patch
+dmi-dont-save-the-same-device-twice-was-smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
+uml-remove-unused-sigcontext-accessors.patch
+uml-fix-helper_wait-calls-in-watchdog.patch
+uml-fix-fp-register-corruption.patch
+x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
+nbd-make-nbd-default-to-deadline-i-o-scheduler.patch
+efs-move-headers-out-of-include-linux.patch
+percpu-fix-debug_preempt-per_cpu-checking.patch
+proc-add-rlimit_rttime-to-proc-pid-limits.patch
+sparc-fix-build.patch
+drivers-video-uvesafbc-fix-section-mismatch-warning-in-param_set_scroll.patch
+remove-rcu_assign_pointernull-penalty-with-type-macro-safety.patch
+add-rcu_assign_index-if-ever-needed.patch
+add-rcu_assign_index-if-ever-needed-fix.patch
+dmi-prevent-linked-list-corruption-resent.patch
+proc-pid-pagemap-fix-pm_special-macro.patch
+x86-fix-clearcopy_user_page-declarations-in-pageh.patch
+futex-fix-init-order.patch
+futex-runtime-enable-pi-and-robust-functionality.patch
+bluetooth-fix-warning-in-net-bluetooth-hci_sysfsc.patch
+h8300-signalc-typo-fix.patch
+h8300-uaccessh-update.patch
+h8300-config_kallsyms-fix.patch
+h8300-irq-handling-update.patch
+h8300-defconfig-update.patch

 Probably 2.6.25 material.

+remove-set_migrateflags.patch
+remove-sparse-warning-for-mmzoneh.patch
+remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
+fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
+fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
+mmap_region-cleanup-the-final-vma_merge-related-code.patch

 Memory management work

+memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch

 memory hotplug debug stuff.

+arch-um-kernel-um_archc-some-small-improvements.patch

 UML update

-autofs4-reinstate-negatitive-timeout-of-mount-fails.patch
-autofs4-reinstate-negatitive-timeout-of-mount-fails-fix.patch

 Dropped

+cciss-procfs-updates-to-display-info-about-many-volumes.patch
+make-dev-kmem-a-config-option.patch
+make-dev-kmem-a-config-option-fix.patch
+epoll-avoid-kmemcheck-warning.patch
+avoid-divides-in-bits_to_longs.patch
+fs-coda-remove-static-inline-forward-declarations.patch
+taint-kernel-after-warn_oncondition.patch
+adfs-work-around-bogus-sparse-warning.patch
+debugfs-fix-sparse-warnings.patch
+block-genhdc-check-class_register-return-value.patch
+add-rusage_thread.patch
+coda-add-static-to-functions-in-dirc.patch
+befs-fix-sparse-warning-in-linuxvfsc.patch

 Misc

+reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
+hppfs-pass-vfsmount-to-dentry_open.patch
+check-for-null-vfsmount-in-dentry_open.patch
+fix-up-new-filp-allocators.patch
+do-namei_flags-calculation-inside-open_namei.patch
+merge-open_namei-and-do_filp_open.patch
+r-o-bind-mounts-stub-functions.patch
+r-o-bind-mounts-create-helper-to-drop-file-write-access.patch
+r-o-bind-mounts-drop-write-during-emergency-remount.patch
+r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch
+r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch
+r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
+r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers.patch
+r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers.patch
+r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
+r-o-bind-mounts-elevate-write-count-for-ncp_ioctl.patch
+r-o-bind-mounts-write-counts-for-time-functions.patch
+r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
+r-o-bind-mounts-write-count-for-file_update_time.patch
+r-o-bind-mounts-write-counts-for-link-symlink.patch
+r-o-bind-mounts-elevate-write-count-for-ioctls.patch
+r-o-bind-mounts-elevate-write-count-for-opens.patch
+r-o-bind-mounts-get-write-access-for-vfs_rename-callers.patch
+r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
+r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch
+r-o-bind-mounts-write-counts-for-truncate.patch
+r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates.patch
+r-o-bind-mounts-make-access-use-new-r-o-helper.patch
+r-o-bind-mounts-check-mnt-instead-of-superblock-directly.patch
+r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
+r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
+r-o-bind-mounts-get-callers-of-vfs_mknod-create.patch
+r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
+r-o-bind-mounts-track-numbers-of-writers-to-mounts.patch
+r-o-bind-mounts-honor-mount-writer-counts-at-remount.patch
+r-o-bind-mounts-debugging-for-missed-calls.patch

 VFS work

+rcu_batches_completed-prototype-cleanup.patch

 RCU tweak

+use-directly-kmalloc-and-kfree-in-init-initramfsc.patch
+inflate-refactor-inflate-malloc-code.patch
+inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch

 initramfs work

+ncpfs-add-prototypes-to-ncp_fsh.patch
+ncpfs-fix-sparse-warnings-in-ioctlc.patch
+ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch

 cleanups

+x86-configurable-dmi-scanning-code.patch
+dmi-clean-up-dmi-helper-declarations.patch

 DMI work

+oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
+oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch

 oprofile work

+spi-use-menuconfig-for-config_spi.patch

 SPI

+sm501-add-uart-support.patch

 mfd update

+rtc-avoid-legacy-drivers-with-generic-framework.patch
+rtc-add-support-for-the-s-35390a-rtc-chip.patch
+rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
+rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
+rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
+rtc-pcf8563-new-style-conversion.patch
+rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
+rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
+rtc-x1205-new-style-conversion.patch
+rtc-x1205-new-style-conversion-checkpatch-fixes.patch

 RTC updates

+gpiolib-better-rmmod-infrastructure.patch
+gpiolib-i2c-spi-drivers-handle-rmmod-better.patch
+gpio-define-gpio_is_valid.patch

 gpio updates

+fbdev-make-the-best-fit-section-of-fb_find_mode-return-the-closest-matching-mode.patch
+fb-add-support-for-foreign-endianness.patch
+fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness.patch
+fb-add-support-for-foreign-endianness-force-it-on.patch
+powerpc-offb-add-support-for-foreign-endianness.patch
+pm2fb-change-option-mode-to-mode_option.patch
+tridentfb-change-option-mode-to-mode_option.patch
+pm3fb-change-option-mode-to-mode_option.patch
+update-modedbtxt-documentation-about-mode_option-parameter-change.patch
+vt8623fb-change-option-mode-to-mode_option.patch

 fbdev updates

+ext2-le_add_cpu-conversion.patch
+ext2-convert-byte-order-of-constant-instead-of-variable.patch

 ext2

+ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
+jbd-sparse-warnings-in-revokec-journalc.patch
+ext3-convert-byte-order-of-constant-instead-of-variable.patch

 ext3

+ufs-e_add_cpu-conversion.patch

 UFS update

+reiserfs-le_add_cpu-conversion.patch

 resierfs cleanup

+remove-unused-variable-from-send_signal.patch
+turn-legacy_queue-macro-into-static-inline-function.patch
+consolidate-checking-for-ignored-legacy-signals.patch
+consolidate-checking-for-ignored-legacy-signals-simplify.patch
+signals-do_signal_stop-use-signal_group_exit.patch
+signals-do_group_exit-use-signal_group_exit-more-consistently.patch

 signal things

+ext4-mm-remove_incorrect_bkl_comments_in_ext4.patch
+ext4-mm-stable-boundary.patch
+ext4-mm-stable-boundary-undo.patch
+ext4-mm-delalloc-vfs.patch
+ext4-mm-delalloc-ext4.patch
+ext4-mm-jbd-blocks-reservation-fix-for-large-blk.patch
+ext4-mm-jbd2-blocks-reservation-fix-for-large-blk.patch
+ext4-mm-enable-delalloc-by-default.patch
+ext4-mm-show-delalloc-option.patch
+ext4-mm-ext4_ialloc-flexbg.patch
+ext4-mm-ext4-online-defrag-header-changes.patch
+ext4-mm-ext4-online-defrag-alloc-contiguous-blks.patch
+ext4-mm-ext4-online-defrag-relocate-file-data.patch
+ext4-mm-ext4-online-defrag-free-space-fragmentation.patch
+ext4-mm-ext4-online-defrag-iget-read-inode-fix.patch
+ext4-mm-convert_ext4_to_use_unlocked_ioctl_v2.patch

 The ext4 tree is back

+ext4-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
+ext4-le_add_cpu-conversion.patch
+jbd2-sparse-warnings-in-revokec-journalc.patch
+ext4-convert-byte-order-of-constant-instead-of-variable.patch

 ext4 things

+provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
+fix-shadowed-variables-in-kernel-posix-cpu-timersc.patch
+timers-simplify-lockdep-stuff.patch
+hrtimers-simplify-lockdep-stuff.patch
+kill-double_spin_lock.patch

 time-management things

+ipc-use-ipc_buildid-directly-from-ipc_addid.patch
+ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
+ipc-scale-msgmni-to-the-amount-of-lowmem.patch
+ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
+ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
+ipc-recompute-msgmni-on-memory-add--remove.patch
+ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
+ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
+ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
+ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch
+ipc-semaphores-code-factorisation.patch
+ipc-shared-memory-introduce-shmctl_down.patch
+ipc-message-queues-introduce-msgctl_down.patch
+ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch
+ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch
+ipc-get-rid-of-the-use-_setbuf-structure.patch
+ipc-introduce-ipc_update_perm.patch
+ipc-consolidate-all-xxxctl_down-functions.patch

 IPC work.  Seems a bit sick: ipc-scale-msgmni-to-the-amount-of-lowmem.patch
 slows machine down a lot with some tests.

+ipmi-hold-attn-until-upper-layer-ready.patch
+ipmi-change-device-node-ordering-to-reflect-probe-order.patch
+ipmi-run-to-completion-fixes.patch
+ipmi-run-to-completion-fixes-fix.patch
+ipmi-run-to-completion-fixes-checkpatch-fixes.patch
+ipmi-dont-grab-locks-in-run-to-completion-mode.patch
+ipmi-dont-grab-locks-in-run-to-completion-mode-fix.patch
+ipmi-dont-print-event-queue-full-on-every-event.patch
+ipmi-update-driver-version.patch
+ipmi-convert-locked-counters-to-atomics.patch
+ipmi-convert-locked-counters-to-atomics-convert-message-handler-defines-to-an-enum.patch
+ipmi-convert-locked-counters-to-atomics-in-the-system-interface.patch
+ipmi-convert-locked-counters-to-atomics-in-the-system-interface-convert-system-interface-defines-to-an-enum.patch
+ipmi-style-fixes-in-the-base-code.patch
+ipmi-style-fixes-in-the-system-interface-code.patch
+ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
+ipmi-style-fixes-in-the-misc-code.patch

 IPMI update

+tty-bkl-pushdown.patch
+tty-bkl-pushdown-fix.patch
+tty-bkl-pushdown-fix1.patch

 "sure to break something"

+elf-use-ei_nident-instead-of-numeric-value.patch
+binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch
+elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch
+elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

 ELF updates

+sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
+sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
+sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch

 mmtimer work

+keys-increase-the-payload-size-when-instantiating-a-key.patch
+keys-check-starting-keyring-as-part-of-search.patch
+keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
+keys-add-keyctl-function-to-get-a-security-label.patch

 key management updates

+proc-print-more-information-when-removing-non-empty-directories.patch

 procfs work

+sysctl-allow-embedded-targets-to-disable-sysctl_checkc.patch

 sysctl work

+mxser-convert-large-macros-to-functions.patch

 char drivers

+modules-warn-about-suspicious-return-values-from-modules-init-hook.patch

 modules update

+random-clean-up-checkpatch-complaints-fix.patch

 Fix random-clean-up-checkpatch-complaints.patch

+documentation-patch-tags-one-more-time.patch
+reiserfs-use-open_bdev_excl.patch
+affs-be_add_cpu-conversion.patch
+hfs-hfsplus-be_add_cpu-conversion.patch
+quota-le_add_cpu-conversion.patch
+sysv-e_add_cpu-conversion.patch
+asm-futexh-should-include-linux-uaccessh.patch
+procfs-task-exe-symlink.patch
+procfs-task-exe-symlink-fix.patch

 More misc

-page-owner-tracking-leak-detector-broken-on-s390.patch

 Dropped

+tg3-debugging.patch

 Help sort tg3 problems.




2203 commits in 509 patch files

All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/patch-list


