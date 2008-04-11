Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbYDKDeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbYDKDeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 23:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYDKDeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 23:34:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbYDKDd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 23:33:59 -0400
Date: Thu, 10 Apr 2008 20:33:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc8-mm2
Message-Id: <20080410203354.f0a6f464.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm2/

- Compilation is busted on mips due to the page-flags patches

- Compilation is busted on sparc64 due to the page-flags patches

- Compilation is partially busted on powerpc due to the page-flags patches. 
  It compiles for my g5 but allmodconfig fails.

- git-drm is dropped due to build errors

- git-xfs is dropped due to failure to get a clean git diff

- git-slub has been temporarily replaced by git-pekka.  Pekka is standing in
  while Christoph is away.

- git-kvm is dropped due to clashes with git-s390

- Many patches which weren't in 2.6.25-rc8-mm1's git-x86.patch and
  git-sched.patch have now (belatedly) been introduced.

  x86 works for me, but Rafael is reporting some crashes.



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



Changes since 2.6.25-rc8-mm1:

 origin.patch
 git-acpi.patch
 git-x86.patch
 git-kgdb-light.patch
 git-alsa-tiwai.patch
 git-agpgart.patch
 git-arm.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-dlm.patch
 git-hid.patch
 git-hrt.patch
 git-ia64.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-leds.patch
 git-libata-all.patch
 git-async-tx.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-udf.patch
 git-net.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-parisc.patch
 git-selinux.patch
 git-security-testing.patch
 git-s390.patch
 git-sched.patch
 git-sh.patch
 git-scsi-misc.patch
 git-block.patch
 git-sparc64.patch
 git-unionfs.patch
 git-v9fs.patch
 git-vfs.patch
 git-watchdog.patch
 git-cryptodev.patch
 git-xtensa.patch
 git-pekka.patch
 git-semaphore.patch
 git-semaphore-vs-git-x86.patch
 git-semaphore-git-rejects.patch

 git trees

-kvm-provide-kvmh-for-all-architecture-fixes-headers_install.patch
-atmel_serial-avoid-stopping-pdc-during-transmission.patch
-atmel_serial-fix-uart-console-concurrent-access.patch
-alpha-fix-alsa-dma-mmap-crash.patch
-fix-typos-in-documentation-unaligned-memory-accesstxt.patch
-doc-fix-typo-in-submittingpatches.patch
-nbd-prevent-sock_xmit-from-attempting-to-use-a-null-socket.patch
-char-ip2-fix-sparse-warnings.patch
-char-rio-fix-sparse-warnings.patch
-block-fix-the-setting-of-the-bounce-limit.patch
-efs-update-error-msg-to-not-refer-to-deleted-read_inode.patch
-vmcoreinfo-add-the-symbol-phys_base.patch
-markers-use-synchronize_sched.patch
-alpha-get_current-dont-add-zero-to-current_thread_info-task.patch
-lib-swiotlbc-avoid-endless-loops-fix.patch
-git-x86-fix-printk-warning.patch
-x86-remove-redundant-display-of-free-swap-space-in-show_mem.patch
-x86_64-do-not-reserve-ramdisk-two-times.patch
-x86-handle_vm86_trap-cleanup.patch
-i386-arch-x86-math-emu-fpu_entryc-warning-fix.patch
-x86_64-ia32-ptrace-vs-enosys.patch
-x86_64-ptrace-vs-enosys.patch
-x86_64-ia32-ptrace-vs-enosys-sysenter-syscall.patch
-x86_32-fix-visualws-and-voyager-kexec-build-failures.patch
-pm-remove-legacy-pm-fix.patch
-scsi-add-iscsi-ibft-support.patch
-dvb-usb-leadtek-winfast-usb-dtv-dongle-support.patch
-radio-cadet-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
-video-test-cmd-not-definition-in-decoder_command-drivers-media-video-zoran_devicec.patch
-bttv-bt832-fix-possible-null-pointer-deref.patch
-bttv-fix-missed-index-check.patch
-jdelvare-i2c-i2c-bfin-twi-04-driver-description.patch
-ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch
-kprobes-kprobe-booster-for-ia64.patch
-ia64-make-iommu-respect-the-segment-boundary-limits.patch
-ia64-remove-redundant-display-of-free-swap-space-in-show_mem.patch
-arch-ia64-kernel-use-time_-macros.patch
-xpad-match-xbox-360-devices-with-interface-info.patch
-git-libata-fix-config_pci=n-build.patch
-libata-isolate-and-rework-cable-logic.patch
-ata-swncq-should-be-enabled-by-default.patch
-net-mac80211-debugfs_netdevc-use-of-bool-triggers-a-gcc-bug.patch
-lapb-use-the-shorter-list_head-form-for-brevity.patch
-bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch
-usb-net-asix-does-not-really-need-10-100mbit.patch
-forcedeth-fix-locking-bug-with-netconsole.patch
-tulip-tulip_read_eeprom-fixes-for-bug-4420.patch
-execute-tasklets-in-the-same-order-they-were-queued.patch
-git-sched-schedc-needs-tickh.patch
-scsi-aic94xx-cleanups.patch
-drivers-scsi-hptiopc-fix-build-warning.patch
-scsi-chc-fix-sparse-shadowed-variable-warnings.patch
-sparc32-delete-bogus-js-rtc-records.patch
-gregkh-usb-ub-drop-bug-and-update-small-things.patch
-usb-gadget-dummy_hcdc-fix-nested-switch-statements.patch
-drivers-net-usb-pegasusc-remove-in_atomic-check.patch
-usb-mem-leak-fixes-for-amd-5536-udc-high-full-speed-usb-device-controller-driver.patch
-usb-u132-hcd-driver-style-clean-up.patch
-usb-u132-hcd-driver-semaphore-to-mutex.patch
-usb-ohci-fix-2-timers-to-fire-at-jiffies-1s.patch
-rusty-module-fix_verify_export_symbols.patch
-mac80211-fix-deadlocks-in-debugfs_netdevc.patch
-r8169-fix-irqx-nobody-cared-for-shared-irq-with-intx.patch
-r8169-fix-irqx-nobody-cared-for-shared-irq-with-intx-checkpatch-fixes.patch
-arch-um-os-linux-mainc-fix-memory-leaks.patch
-arch-um-os-linux-mainc-fix-memory-leaks-checkpatch-fixes.patch
-asm-generic-add-node_to_cpumask_ptr-macro.patch
-rcu_batches_completed-prototype-cleanup.patch
-cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
-cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time-fix-boot-option-parsing.patch
-memory-controller-make-memory-resource-control-aware-of-boot-options.patch
-ipmi-change-device-node-ordering-to-reflect-probe-order.patch
-make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
-clocksource-keep-track-of-original-clocksource-frequency.patch
-clocksource-introduce-clock_monotonic_raw.patch
-clocksource-introduce-clock_monotonic_raw-fix.patch
-clocksource-introduce-clock_monotonic_raw-fix-checkpatch-fixes.patch
-i386-arch-x86-math-emu-reg_ld_strc-fix-warning.patch

 Merged into mainline or a subsystem tree

+cgroups-include-hierarchy-ids-in-proc-pid-cgroup.patch
+rtc-rtc-s35390ac-needs-the-bitreverse-library.patch
+eventfd-kaio-integration-fix.patch
+i2c-fix-platform-driver-hotplug-coldplug.patch
+spi-fix-platform-driver-hotplug-coldplug.patch
+usb-gadget-fix-platform-driver-hotplug-coldplug.patch
+usb-host-fix-platform-driver-hotplug-coldplug.patch
+watchdog-fix-platform-driver-hotplug-coldplug.patch
+rtc-fix-platform-driver-hotplug-coldplug.patch
+cciss-error-implicit-declaration-of-function-sg_init_table.patch
+hfs-fix-unlink-of-links.patch
+md-close-a-livelock-window-in-handle_parity_checks5.patch
+pnp-increase-number-of-devices-supported-per-protocol.patch
+signalfd-fix-for-incorrect-si_queue-user-data-reporting.patch
+lzo-fix-typo-in-decompresor.patch
+generic_file_splice_read-fix-lockups.patch

 2.6.25 queue (some already merged)

+acpi-unneccessary-to-scan-the-pci-bus-already-scanned.patch
+revert-x86-fix-call-to-set_cyc2ns_scale-from-time_cpufreq_notifier.patch

 git-acpi.patch

+git-acpi-revert-suspend-wakeup-code-in-c.patch

 Revert this so that git-x86 applies

+acpi-fix-fadt-parsing.patch
+acpi-adjust-register-handling.patch
+acpi-adjust-_acpi_modulefunction_name-definitions.patch
+acpi-use-__init-on-everything-in-tables-tbfadtc.patch

 ACPI stuff

+revert-include-asm-x86-i387h-checkpatch-cleanups-formatting-only.patch
+git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5.patch
+git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5.patch
+arch-x86-mm-ioremapc-fix-printk-warnings.patch
+git-x86-fix-warning-in-arch-x86-kernel-vsmp_64c.patch

 Fix git-x86

+x86_64-do-not-reserve-ramdisk-two-times.patch

 x86 fix
 
+git-x86-hack-around-to-make-git-kgdb-build.patch
+git-x86-vs-git-kgdb-lite.patch

 Fix git-kgdb-light.patch

+git-alsa-tiwai-hda_codec-fix-locking.patch

 Fix git-alsa-tiwai.patch

+es1968-fix-jitter-on-some-maestro-cards.patch
+es1968-fix-jitter-on-some-maestro-cards-checkpatch-fixes.patch
+sound-pci-rme9652-hdspmc-stop-inlining-largish-static-functions.patch

 alsa things

+gregkh-driver-kobject-replace-list_for_each-with-list_for_each_entry.patch
+gregkh-driver-pm-remove-legacy-pm.patch
+gregkh-driver-firmware-add-iscsi-ibft-support.patch
-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch

 driver tree updates

+sysfs-refill-attribute-buffer-when-reading-from-offset-0.patch
+pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7.patch
+pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7-fix.patch
+pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type-rev-3.patch
+pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3.patch
+pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3-fix.patch

 driver/PM updates

+v4l-common-replace-remaining-__function__-occurences.patch
+v4l-dvb-replace-remaining-__function__-occurences.patch
+v4l-video-replace-remaining-__function__-occurences.patch

 v4l things

+jdelvare-i2c-i2c-superh-mobile-i2c-bus-controller-v5.patch

 I2C tree update

+git-dlm-vs-git-gfs2-nwm.patch

 Fix git-dlm.patch

+time-close-small-window-for-vsyscall-time-inconsistencies.patch
+time-close-small-window-for-vsyscall-time-inconsistencies-checkpatch-fixes.patch

 stuff for git-hrt

+gregkh-driver-ib-convert-struct-class_device-to-struct-device-vs-git-infiniband.patch

 Fix infiniband tree versus the driver tree

-git-kvm-fixup.patch
-git-kvm-vs-git-s390.patch

 git-kvm.patch is dropped

+git-libata-all-unbork-drivers-ata-sata_sx4c.patch

 Fix git-libata-all.

-pata_amd-fix-sparse-warning.patch

 Folded into pata_atiixp-simplex-clear.patch

+pata_atiixp-simplex-clear-fix.patch

 Unbreak pata_atiixp-simplex-clear.patch

+ide-mm-ide-make-32-bit-io-support-for-ide-vlb-available-only-when-it-makes-sense.patch
+ide-mm-ide-add-struct-ide_io_ports.patch
+ide-mm-ide-tape-improve-buffer-allocation-strategy.patch
+ide-mm-ide-tape-mv-tape-stage_size-tape-buffer_size.patch
+ide-mm-ide-tape-mv-tape-pages_per_stage-tape-pages_per_buffer.patch
+ide-mm-ide-tape-improve-buffer-pages-freeing-strategy.patch
+ide-mm-ide-remove-_proc_ide_ali.patch
+ide-mm-ide-remove-now-unused-ide_pci_create_host_proc.patch
+ide-mm-ide-tape-make-__idetape_discard_read_pipeline-of-type-void.patch
+ide-mm-ide-tape-mv-idetape_discard_read_pipeline-ide_tape_discard_merge_buffer.patch
+ide-mm-ide-tape-mv-idetape_empty_write_pipeline-ide_tape_flush_merge_buffer.patch
+ide-mm-ide-tape-mv-tape-merge_stage_size-tape-merge_bh_size.patch
+ide-mm-ide-tape-remove-tape-merge_stage.patch
+ide-mm-ide-tape-fix-mem-leak.patch
+ide-mm-falconide-q40ide-add-atapi_-put_bytes-and-ata_-put_data-methods-take-2.patch
+ide-mm-ide-merge-atapi_-put_bytes-and-ata_-put_data-methods.patch
+ide-mm-scc_pata-add-in-out-put_data-methods.patch
+ide-mm-au1xxx-ide-add-in-out-put_data-methods.patch
+ide-mm-ide-h8300-add-in-out-put_data-methods.patch
+ide-mm-ide-add-ide_hflag_mmio-host-flag-take-2.patch
+ide-mm-ide-remove-inswl-and-outswl-methods.patch
+ide-mm-siimage-do-clocking-register-posting-earlier-in-setup_mmio_siimage.patch
+ide-mm-siimage-add-sil_-io-ops.patch
+ide-mm-siimage-remove-proc_reports_siimage.patch

 IDE tree updates

+jffs2-summary-allocation-dont-use-vmalloc.patch

 jffs2 fix (not mergeable)

+sc92031-use-net_device-stats.patch
+ehea-fix-dlpar-memory-add-support.patch
+ehea-fix-dlpar-memory-add-support-fix.patch
+sundance-set-carrier-status-on-link-change-events.patch
+sundance-set-carrier-status-on-link-change-events-checkpatch-fixes.patch
+forcedeth-new-backoff-implementation.patch
+forcedeth-new-backoff-implementation-update.patch

 netdev stuff

+gregkh-pci-pci-update-via-cx700-quirk.patch
+gregkh-pci-pci-aerdrv_acpic-remove-unneeded-null-check.patch
+gregkh-pci-pci-clean-up-resource-alignment-management.patch

 PCI tree updates

-git-s390-git-rejects.patch

 Unneeded

+sh-arch-sh-kernel-traps_32c-needs-asm-fpuh.patch
+sh-export-empty_zero_page.patch

 sh fixes

+cfq-iosched-do-not-leak-ioc_data-across-iosched-switches.patch

 CFQ fix

+sparc32-export-empty_zero_page.patch

 sparc32 fix

+gregkh-usb-usb-add-usb_dt_cs_radio_control-define-to-ch9h.patch
+gregkh-usb-usb-serial-sierra-clean-up.patch
+gregkh-usb-usb-serial-sierra-c597-fix.patch
+gregkh-usb-u132-hcd-fix-checkpatch-style-issues.patch
+gregkh-usb-u132-hdc-semaphore-to-mutex.patch
+gregkh-usb-usb-fix-comments-of-2-functions-in-hcdc.patch
+gregkh-usb-usb-serial-remove-obsolete-contact-addresses.patch
+gregkh-usb-usb-test-for-null-return-from-platform_get_resource-in-ohci_hcd_sm501_drv_remove.patch
+gregkh-usb-usb-g_printer-bugfixes.patch
+gregkh-usb-usb-usb-storage-use-adaptive-dma-mask.patch
+gregkh-usb-usb-mem-leak-fixes-for-amd-5536-udc-high-full-speed-usb-device-controller-driver.patch
+gregkh-usb-usb-gadget-dummy_hcdc-fix-nested-switch-statements.patch
+gregkh-usb-wusb-add-authenticated-bit-to-usb-dev.patch
+gregkh-usb-usb-add-usb_dev_reset_delayed.patch
+gregkh-usb-wusb-add-link-wusb-usb-dev.patch
+gregkh-usb-wusb-teach-choose-address-about-wireless-devices.patch
+gregkh-usb-wusb-devices-dont-use-a-set-address.patch
+gregkh-usb-wusb-make-ep0-reinit-available.patch
+gregkh-usb-wusb-update-devnum.patch
+gregkh-usb-wusb-documentation.patch
+gregkh-usb-bitmap-add-bitmap_copy_le.patch
+gregkh-usb-wusb-add-usb-specific-wusb-include-files.patch
+gregkh-usb-wusb-add-the-uwb-include-files.patch

 USB tree updates

+usb-asix-add-buffalo-lua-u2-gt-10-100-1000.patch

 USB device support

+mm-only-b43-rewrite-lo-calibration.patch

 b43 testing patch

-git-cryptodev-fixup.patch

 Unneeded

+git-cryptodev-misplaced-hunk.patch
+git-cryptodev-fix-conflict.patch
+git-cryptodev-fix-conflict-hack.patch

 git-cryptodev repairs

+rusty-virtio-broken-virtqueues.patch
+rusty-module-find_symbol-cleanup.patch
+rusty-module-use-unused_gpl_crcs.patch
+rusty-module-more-checking-in-verify_export_symbols.patch
+rusty-module-markers_support_for_proprierary_s.patch
+rusty-lguest-avoid-nr_cpus-for-number-of-cpus.patch
+rusty-lguest-remove-bogus-null-cpu-check.patch
+rusty-virtio-fix_sparse_return_void_valued_expression_warnings.patch

 Rustytree updates

+make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch

 Some stranded patch

-git-slub.patch

 Dropped

-git-slub-git-rejects.patch

 Unneeded

+git-pekka.patch

 New slub tree

+git-semaphore-vs-git-x86.patch

 Repair git-semaphore.patch

+ext4-is-busted-on-m68k.patch

 ext4 doesn't build on m68k

+acpi-bus-check-once-more-for-an-empty-list-after-locking-it.patch
+acpi-thermal-trip-points-increased-to-12.patch
+sc92031-sysfs-link-missing.patch
+usb-fix-interface-deregistration-during-unbind-operations.patch

 Fixes for 2.6.25 (I think)

-mm-make-mem_map-allocation-continuous.patch
-mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
+mm-make-mem_map-allocation-continuous-v2.patch

 Replaced p[atch

-mm-allocate-section_map-for-sparse_init.patch
-mm-allocate-section_map-for-sparse_init-update.patch
-mm-allocate-section_map-for-sparse_init-update-fix.patch

 These got moved into mm-make-mem_map-allocation-continuous-v2.patch

+mm-get-rid-of-__zone_count.patch
+pageflags_extended-and-separate-page-flags-for-head-and-tail.patch

 Update page-flags patches in -mm.

-s390-remove-struct-page-entries-for-dcss-memory-segments.patch

 Accidentally dropped.  Will come back.

+mempolicy-rename-mpol_free-to-mpol_put.patch
+mempolicy-rename-mpol_copy-to-mpol_dup.patch
+mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy.patch
+mempolicy-fixup-fallback-for-default-shmem-policy.patch
+mempolicy-rename-struct-mempolicy-policy-member-to-mode.patch
+mempolicy-mark-shared-policies-for-unref.patch
+mempolicy-document-setget_policy-vm_ops-apis.patch
+mempolicy-rework-mempolicy-reference-counting.patch
+mempolicy-use-mpol_preferred-for-system-wide-default-policy.patch
+mempolicy-mpol_preferred-cleanups-for-local-allocation.patch
+mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy.patch
+mempolicy-clean-up-mpol-to-str-mempolicy-formatting.patch
+mempolicy-rework-shmem-mpol-parsing-and-display.patch
+mempolicy-support-mpol=local-tmpfs-mount-option.patch
+mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch
+mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
+mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
+mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch

 mempolicy updates

+hugetlbfs-architecture-header-cleanup.patch
+hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow.patch
+hugetlbfs-common-code-update-for-s390.patch

 hugetlbfs updates

+memory-hotplug-register-section-node-id-to-free.patch
+memory-hotplug-align-memmap-to-page-size.patch
+memory-hotplug-make-alloc_bootmem_section.patch
+memory-hotplugallocate-usemap-on-the-section-with-pgdat.patch
+memory-hotplug-free-memmaps-allocated-by-bootmem.patch

 memory hotplug updates

+oom_kill-remove-unused-parameter-in-badness.patch

 cleanup

+frv-handle-update_mmu_cache-being-called-when-current-mm-is-null.patch
+frv-move-stack_top_max-up.patch
+frv-add-support-for-emulation-of-userspace-atomic-ops.patch
+frv-make-nommu-mode-work-with-base-addresses-other-than-0xc0000000.patch
+frv-dont-make-smp_r-w-mb-interpolate-membar-when-config_smp=n.patch

 FRV updates

+gen_initramfs_listsh-fix-unportability.patch
+update-checkpatchpl-to-version-017.patch
+swiotlb-use-iommu_is_span_boundary-helper-function.patch

 Misc

+spi-spi_imx-updates.patch

 SPI updates

+ecryptfs-add-missing-lock-around-notify_change.patch

 ecryptfs updates

+gpiochip_reserve-fix-2.patch

 Fix gpiochip_reserve.patch some more

+gxfb-add-power-management-functionality-update.patch

 Update gxfb-add-power-management-functionality-fix.patch

+pxafb-introduce-lcd_readwritel-to-wrap-the-__raw_readwritel.patch
+pxafb-use-completion-for-lcd-disable-wait-code.patch
+pxafb-move-parallel-lcd-timing-setup-into-dedicate-function.patch
+pxafb-preliminary-smart-panel-interface-support.patch
+pxafb-preliminary-smart-panel-interface-support-update.patch
+lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
+lxfb-add-power-management-functionality-update.patch
+lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt.patch
+fbdev-metronomefb-bugfix-v4.patch
+fbdev-hecubafb-bugfix-v4.patch
+fbdev-platforming-metronomefb-and-am200epd-v4.patch
+fbdev-platforming-hecubafb-and-n411-v4.patch

 fbdev updates

+ext3-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch

 ext3 fix

+reiserfs-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch

 reiserfs fix

+docbook-some-kernel-locking-fixes.patch
+kernel-doc-detect-prevent-duplicate-doc-section-names.patch
+kernel-doc-detect-trailing-kernel-doc-line-trash.patch
+documentation-build-source-files-in-documentation-sub-dir.patch
+documentation-build-source-files-in-documentation-sub-dir-update.patch
+documentation-build-source-files-in-documentation-sub-dir-disable.patch

 Documentation updates

+cgroups-use-a-hash-table-for-css_set-finding.patch
+cgroups-simplify-init_subsys.patch
+cgroups-remove-the-css_set-linked-list.patch
+cgroups-introduce-cft-read_seq-v2.patch

 cgroups udpates

+memcg-remove-redundant-function-calls.patch
+memcgroup-make-the-memory-controller-more-desktop-responsive.patch

 memory controller updates

+signals-add-set_restore_sigmask.patch
+signals-set_restore_sigmask-tif_sigpending.patch
+signals-s390-renumber-tif_restore_sigmask.patch
+signals-ia64-renumber-tif_restore_sigmask.patch
+signals-use-have_set_restore_sigmask.patch
+signals-x86-ts_restore_sigmask.patch

 More signals work.

-ext4-is-broken.patch

 Dropped

+ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch

 ext4 fix

+doc-fix-dma-api-function-parameters.patch

 DMA API update

+tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch
+usb-serial-more-fixes-and-groundwork-for-tty-changes.patch

 TTY updates

+proc-switch-proc-driver-ray_cs-ray_cs-to-seq_file-interface.patch
+proc-switch-proc-driver-radio-typhoon-to-seq_file-interface.patch
+proc-switch-proc-bus-zorro-devices-to-seq_file-interface.patch
+proc-switch-proc-apm-to-seq_file-interface.patch
+proc-remove-proc-mac_iop.patch
+proc-switch-proc-bus-ecard-devices-to-seq_file-interface.patch
+proc-switch-proc-excite-unit_id-to-seq_file-interface.patch
+proc-switch-proc-irda-irnet-to-seq_file-interface.patch
+proc-convert-proc-bus-nubus-to-seq_file-interface.patch
+proc-switch-proc-ip2mem-to-seq_file-interface.patch
+proc-switch-proc-scsi-device_info-to-seq_file-interface.patch
+proc-remove-get_info-infrastructure.patch

 procfs work

+nbd-delete-superfluous-test-for-__gnuc__.patch

 nbd cleanup

+printk-dont-read-beyond-string-arguments-terminating-zero.patch

 printk fixlet

+edac-remove-unneeded-functions-and-add-static-accessor.patch
+edac-fix-module-initialization-on-several-modules-2nd-time.patch

 EDAC updates

-linuxpps-core-support.patch
-pps-userland-header-file-for-pps-api.patch
-pps-documentation-programs-and-examples.patch
-pps-linuxpps-clients-support.patch
-pps-serial-clients-support.patch
-pps-example-program-to-enable-pps-support-on-serial-ports.patch
-pps-parallel-port-clients-support.patch

 Dropped, keeps being updated

+afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch
+afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself-try-3.patch

 AFS updates

+modify-ramdisk-brd-device-to-be-able-to-manage-partitions.patch

 ramdisk fix

+sysv-fs-remove-superfluous-check-for-__gnuc__-compiler.patch

 sysvfs cleanup

+remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
+drop-the-exporting-of-empty-linux-byteorder-generich.patch

 cleanups

+notify_change-callers-must-hold-i_mutex.patch

 debug check

+likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

 Update -mm's likeliness profiling patch.



5191 commits in 1682 patch files

All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm2/patch-list


