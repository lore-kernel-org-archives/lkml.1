Return-Path: <linux-kernel-owner+w=401wt.eu-S1423117AbXEEIuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423117AbXEEIuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 04:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423122AbXEEIuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 04:50:08 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423117AbXEEIuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 04:50:01 -0400
Date: Sat, 5 May 2007 01:49:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-mm1
Message-Id: <20070505014955.8f3990b5.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/


- Added the git-battery tree to the -mm lineup (Anton Vorontsov
  <cbou@mail.ru>).  It presently generates mysterious depmod error messages.

- The staircase CPU scheduler was dropped




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




Changes since 2.6.21-rc7-mm2:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-arm.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-drm.patch
 git-dvb.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ia64.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-kbuild.patch
 git-kvm.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-e1000.patch
 git-net.patch
 git-battery.patch
 git-bluetooth.patch
 git-ioat.patch
 git-nfs.patch
 git-ocfs2.patch
 git-parisc.patch
 git-selinux.patch
 git-pciseg.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-unionfs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-cryptodev.patch
 git-gccbug.patch

 git trees

-packet-fix-error-handling.patch
-make-sysrq-t-show-all-tasks-again.patch
-drivers-acpi-kconfig-formulation-fixpatch.patch
-make-proc-acpi-wakeup-more-useful.patch
-cpuidle-hang-fix.patch
-acpi-processor_idlec-remove-duplicate-include.patch
-acpi-remove-duplicate-definitions-for-_sta-bits.patch
-acpi-use-_sta-bit-names-rather-than-0x0f.patch
-cpu_idle-prevents-resuming-from-str.patch
-pata_platform-for-arm-riscpc.patch
-arm-fix-section-mismatch-warning-in-board-sam9260.patch
-arm-ecard-convert-to-use-the-kthread-api.patch
-avr32-remove-unneeded-cast-in-atomich.patch
-cifs-use-mutexdiff.patch
-git-cpufreq-borkage-fix.patch
-git-powerpc-arch-powerpc-sysdev-timerc-build-fix.patch
-ppc4xx_sgdma-needs-dma_mappingh.patch
-powerpc-rtas-msi-support.patch
-spin_lock_unlocked-cleanup-in-arch-powerpc.patch
-gregkh-driver-driver-core-fix-device_add-error-path.patch
-gregkh-driver-driver-core-fix-namespace-issue-with-devices-assigned-to-classes.patch
-gregkh-driver-dev_printk-and-new-style-class-devices.patch
-gregkh-driver-driver-core-udev-triggered-device-driver-binding.patch
-gregkh-driver-driver-core-use-attribute-groups-in-struct-device_type.patch
-gregkh-driver-named-device_type.patch
-gregkh-driver-kobject-kobject_shadow_add-cleanup.patch
-gregkh-driver-driver-core-per-subsystem-multithreaded-probing.patch
-gregkh-driver-powerpc-make-it-compile-for-multithread-change.patch
-gregkh-driver-driver-core-don-t-fail-attaching-the-device-if-it-cannot-be-bound.patch
-gregkh-driver-driver-no-more-wait.patch
-gregkh-driver-kref-fix-cpu-ordering-with-respect-to-krefs.patch
-gregkh-driver-driver-core-notify-userspace-of-network-device-renames.patch
-gregkh-driver-driver-core-suppress-uevents-via-filter.patch
-gregkh-driver-driver-core-switch-firmware_class-to-uevent_suppress.patch
-gregkh-driver-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
-gregkh-driver-driver-core-add-suspend-and-resume-to-struct-device_type.patch
-gregkh-driver-kobject-kobject_ueventc-collapse-unnecessary-loop-nesting.patch
-gregkh-driver-kobject-kobject_add-reference-leak.patch
-gregkh-driver-devices_subsys-rwsem-removal.patch
-gregkh-driver-scsi-hosts-rwsem-removal.patch
-gregkh-driver-usb-bus-mutex.patch
-gregkh-driver-pnp-remove-rwsem-usage.patch
-gregkh-driver-input-serio-do-not-touch-bus-s-rwsem.patch
-gregkh-driver-input-gameport-do-not-touch-bus-s-rwsem.patch
-gregkh-driver-ide-proc-remove-rwsem.patch
-gregkh-driver-ieee1394-rwsem-removal.patch
-gregkh-driver-phy-rwsem-removal.patch
-gregkh-driver-qeth-remove-usage-of-subsys_rwsem.patch
-gregkh-driver-subsys-rwsem-removal.patch
-gregkh-driver-sysfs-fix-i_ino-handling-in-sysfs.patch
-gregkh-driver-sysfs-make-lockdep-ignore-s_active.patch
-gregkh-driver-sysfs-rename-object_depth-to-sysfs_path_depth-and-make-it-global.patch
-gregkh-driver-sysfs-reimplement-sysfs_drop_dentry.patch
-gregkh-driver-sysfs-kill-sysfs_dirent-s_dentry.patch
-gregkh-driver-driver-core-make-uevent-environment-available-in-uevent-file.patch
-gregkh-driver-driver-core-warn-for-odd-store-uevent-usage.patch
-gregkh-driver-kobject-comment-and-warning-fixes-to-kobjectc.patch
-gregkh-driver-the-overdue-removal-of-the-mount-umount-uevents.patch
-gregkh-driver-debugfs-add-debugfs_create_u64.patch
-gregkh-driver-bus_add_driver-return-error-for-no-bus.patch
-gregkh-driver-uio-dummy.patch
-fix-gregkh-driver-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
-sysfs-oops-workaround.patch
-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
-even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
-s390-cio-delay-uevents-for-subchannels.patch
-device_schedule_callback-needs-a-module-reference.patch
-device_schedule_callback-needs-a-module-reference-fix.patch
-security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group.patch
-define-platform-wakeup-hook-use-in-pci_enable_wake.patch
-define-platform-wakeup-hook-use-in-pci_enable_wake-update.patch
-define-platform-wakeup-hook-use-in-pci_enable_wake-fix.patch
-s2ram-add-arch-irq-disable-enable-hooks.patch
-mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs.patch
-drivers-base-attribute_containerc-use-mutex-instead-of-binary-semaphore.patch
-dev_dbg-check-dev_dbg-arguments.patch
-dev_dbg-check-dev_dbg-arguments-fix.patch
-dev_dbg-check-dev_dbg-arguments-fix-2.patch
-sysfs-binc-printk-fix.patch
-video4linux-fix-audio-input-for-avertv-go-007.patch
-mm-only-saa7134-tvaudio-convert-to-kthread-api.patch
-git-dvb-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
-jdelvare-i2c-i2c-02-revert-core-warning-removal.patch
-jdelvare-i2c-i2c-writing-clients-drop-isa-references.patch
-gfs2-printk-warning-fixes.patch
-ohci1394-fix-mistake-in-printk-message.patch
-fw-device-printk-fix.patch
-wistron_btns-fix-a-typo-on-the-tm610-definition.patch
-jfs-use-set_current_state.patch
-kbuild-handle-compressed-cpio-initramfs-es.patch
-ata-printk-warning-fixes.patch
-sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
-libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
-pata_acpi-restore-driver-fix.patch
-pata_acpi-restore-driver-fix-2.patch
-pata_hpt37x-further-small-fixes.patch
-pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
-drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
-spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
-ata_timing-ensure-t-cycle-is-always-correct.patch
-revert-rm-pointless-dmaengine-exports.patch
-git-md-accel-fix.patch
-spin_lock_unlocked-cleanup-in-arch-mips.patch
-dont-force-frame-pointers-for-lockdep-on-mips.patch
-git-mmc-build-fix.patch
-git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
-git-mtd-build-fix.patch
-git-netdev-all-export-ieee80211_debug_level.patch
-add-napi-support-to-sb1250-macc-take-2.patch
-ehea-fix-for-dlpar-and-sysfs-entries.patch
-3c509-remove-unnecessary-include-of-linux-pm_legacyh.patch
-netlink-dont-reinitialize-callback-mutex.patch
-sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage.patch
-sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage-fix.patch
-sctp_getsockopt_local_addrs-type-fix.patch
-git-net-fix-yamc.patch
-net-possible-cleanups.patch
-git-net-vs-git-netdev-all.patch
-delete-unused-header-file-linux-sdla_frh.patch
-delete-unused-header-file-linux-if_wanpipe_commonh.patch
-net-tun-tap-fixed-hw-address-handling.patch
-round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
-iucv-fix-compilation-on-s390-up.patch
-sunrpc-cleanup-use-seq_release_private-where-appropriate.patch
-spin_lock_unlocked-cleanup-in-drivers-atm-net.patch
-networking-bonding-documentation-fix-for-multiple-bonding-interfaces.patch
-irda_device_dongle_init-fix-kzallocgfp_kernel-in-spinlock.patch
-rfcomm_worker-fix-wakeup-race.patch
-use-mutex-instead-of-binary-semaphore-in-fore-systems-200e-series-driver-for-atm.patch
-nfs-statfs-error-handling-fix.patch
-fs-ocfs2-make-3-functions-static.patch
-ocfs2-use-__set_current_state.patch
-git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
-s390-scsi-zfcp_erp-partially-convert-to-use-the-kthread-api.patch
-s390-qeth-convert-to-use-the-kthread-api.patch
-s390-net-lcs-convert-to-the-kthread-api.patch
-s390-net-lcs-convert-to-the-kthread-api-fix.patch
-aacraid-2621-rc6-mm1-aacraid-not-finding-device.patch
-scsi-spi-transport-scsi-domain-validation-after-reset.patch
-scsi-newstyle-hotplug-coldplug-support.patch
-scsi-megaraid_sas-intercepts-cmd-timeout-and-throttle-io.patch
-fix-buslogic-to-stop-using-check_region.patch
-gregkh-usb-adding-pid-of-sharp-s01sh-for-ipaqc.patch
-gregkh-usb-pxa2xx_udc-cleanups-use-platform_get_irq.patch
-gregkh-usb-usb-pxa2xx_udc-fix-hardcoded-irq-number.patch
-gregkh-usb-usb-fix-skeleton-driver.patch
-gregkh-usb-usb-kill-bkl-in-skeleton-driver.patch
-gregkh-usb-usb-kill-bkl-in-usblcd.patch
-gregkh-usb-usbmon-extended-text-api.patch
-gregkh-usb-usb-additional-structure-from-cdc-spec.patch
-gregkh-usb-usb-cdc-acm-export-parsed-capabilities-through-sysfs.patch
-gregkh-usb-ub-bind-to-first-endpoint-not-to-last.patch
-gregkh-usb-libusual-change-block-scope-variable-to-function-scope.patch
-gregkh-usb-usbcore-move-usb_autosuspend_work.patch
-gregkh-usb-usb-unnecessary-gfp_atomic-in-mos7720-driver.patch
-gregkh-usb-usbatm-create-sysfs-link-device-from-atm-class-device-to-usb-interface.patch
-gregkh-usb-usb-cxacru-export-detailed-device-info-through-sysfs.patch
-gregkh-usb-usb-maintainers-cxacru.patch
-gregkh-usb-usb-fix-race-in-hcd-removal.patch
-gregkh-usb-ehci-fsl-change-si_ctrl-pri_ctrl-register-offsets-according-to-errata.patch
-gregkh-usb-mos7720-update.patch
-gregkh-usb-usb-help-text-for-mos-7720-driver.patch
-gregkh-usb-usb-separate-autosuspend-from-external-suspend.patch
-gregkh-usb-usb-allow-autosuspend-delay-to-equal-0.patch
-gregkh-usb-ehci-add-delay-to-bus_resume-before-accessing-ports.patch
-gregkh-usb-usb-io_edgeport-race-condition-in-counters.patch
-gregkh-usb-usb-overhaul-of-mos7840-driver.patch
-gregkh-usb-usb-io_edgeport-convert-to-generic-boolean.patch
-gregkh-usb-usb-dm9601-fix-sparse-null-warnings.patch
-gregkh-usb-usb-iowarriorc-fix-null-dereference.patch
-gregkh-usb-usb-fix-endianness-in-mos7720.patch
-gregkh-usb-uhci-add-some-warn_ons.patch
-gregkh-usb-usb-omninet-memory-leak-in-error-case.patch
-gregkh-usb-option-close-race.patch
-gregkh-usb-usb-sierra-close-race.patch
-gregkh-usb-usb-add-power-level-sysfs-attribute.patch
-gregkh-usb-usb-gadget-storage-needs-block.patch
-gregkh-usb-usb-make-usbdevices-export-their-device-nodes-instead-of-using-a-separate-class.patch
-gregkh-usb-usb-aircable-cleanup.patch
-gregkh-usb-usb-fix-race-in-visor_write.patch
-gregkh-usb-usb-fix-race-in-ftdio_write.patch
-gregkh-usb-usb-ftdi_sio-add-usb-id-of-adstech-usbx-707.patch
-gregkh-usb-usb-fix-ark3116-memory-leak.patch
-gregkh-usb-usb-cypress_cy7c63-race-disconnect-sysfs-read-write-leading-to-following-null-pointer.patch
-gregkh-usb-usb-fix-catc-error-handling.patch
-gregkh-usb-usb-fix-error-handling-in-kl5kusb.patch
-gregkh-usb-usb-fix-error-handling-for-mct_u232.patch
-gregkh-usb-usb-fix-omninet-write-vs-close-race.patch
-gregkh-usb-usb-whiteheat-convert-to-generic-boolean.patch
-gregkh-usb-usb-add-last_busy-field-for-use-in-autosuspend.patch
-gregkh-usb-usb-cleanup-ofd-adutux.patch
-gregkh-usb-usb-allow-transfer_buffer-with-transfer_dma.patch
-gregkh-usb-usbmon-bus-zero.patch
-gregkh-usb-usb-fix-signed-jiffies-issue-in-autosuspend-logic.patch
-gregkh-usb-usb-linux-usb-ch9h-minor-doc-update.patch
-gregkh-usb-usb-rndis_host-various-cleanups.patch
-gregkh-usb-usb-usbnet-reports-minidriver-name-through-ethtool.patch
-gregkh-usb-usb-add-an-ohci-board-specific-quirk.patch
-usb-elan-ftdi-check-for-driver-registration-status-v2.patch
-usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
-usb-bandrich-bandluxe-hsdpa-data-card-driver.patch
-remove-duplicate-define-of-ohci_quirk_zfmicro.patch
-usbatm-detect-usb-device-shutdown-and-ignore-failed-urbs.patch
-usb-cxacru-adsl-state-management.patch
-usb-cxacru-adsl-state-management-udpate.patch
-fix-x86_64-mm-nmi-watchdog-ops.patch
-allow-boot-time-disable-of-paravirt_ops-patching.patch
-fix-mtrr-sections.patch
-i386-extend-alternative-instructions-framework.patch
-x86_64-changes-to-x86_64-architecture-for.patch
-x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
-x86_64-move-__vgetcpu_mode-__jiffies-to-the-vsyscall_2-zone.patch
-i386-machine_real_restart-replace-spin_lock_irqsave-with-spin_lock.patch
-i386-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined.patch
-i386-make-compat_vdso-runtime-selectable-fix.patch
-i386-cleanup-flush_tlb_others-fn.patch
-i386-mce-check-capability.patch
-x86_64-set-node_possible_map-at-runtime.patch
-x86_64-set-node_possible_map-at-runtime-fix.patch
-x86_64-set-node_possible_map-at-runtime-fix-2.patch
-slab-x86_64-skip-cache_free_alien-on-non-numa.patch
-i386-tsc-remove-xtime_locking-around-cpufreq-notifier.patch
-i386-pte-clear-optimization.patch
-i386-pte-xchg-optimization.patch
-i386-pte-simplify-ops.patch
-i386-voyager-convert-the-monitor-thread-to-use-the-kthread-api.patch
-i386-balance_irq-convert-to-the-kthread-api.patch
-x86_64-unexport-cpu_llc_id.patch
-fix-slab-corruption-running-ip6sic.patch
-drivers-macintosh-mac_hidc-make-code-static.patch
-clocksource-acpi_pm-trivial-comment-update.patch
-alphabetically-sorted-entries-in.patch
-clarify-the-creation-of-the-localversion_auto-string.patch

 Merged into mainline or a subsystem tree

+serial-serial_core-use-pr_debug.patch
+add-unitialized_var-macro-for-suppressing-gcc-warnings.patch
+tty_register_driver-only-allocate-tty-instances-when-defined.patch
+slub-change-default-alignments.patch
+slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes.patch
+slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes-fix.patch
+powerpc-disable-slub-for-configurations-in-which-slab-page-structs-are-modified.patch
+slub-add-min_partial.patch
+slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
+oom-fix-constraint-deadlock.patch
+get_unmapped_area-handles-map_fixed-on-powerpc.patch
+get_unmapped_area-handles-map_fixed-on-alpha.patch
+get_unmapped_area-handles-map_fixed-on-arm.patch
+get_unmapped_area-handles-map_fixed-on-frv.patch
+get_unmapped_area-handles-map_fixed-on-i386.patch
+get_unmapped_area-handles-map_fixed-on-ia64.patch
+get_unmapped_area-handles-map_fixed-on-parisc.patch
+get_unmapped_area-handles-map_fixed-on-sparc64.patch
+get_unmapped_area-handles-map_fixed-on-x86_64.patch
+get_unmapped_area-handles-map_fixed-in-hugetlbfs.patch
+get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix.patch
+get_unmapped_area-handles-map_fixed-in-generic-code.patch
+get_unmapped_area-doesnt-need-hugetlbfs-hacks-anymore.patch
+slab-allocators-remove-useless-__gfp_no_grow-flag.patch
+hugetlbfs-add-null-check-in-hugetlb_zero_setup.patch
+slob-fix-page-order-calculation-on-not-4kb-page.patch
+page-migration-only-migrate-pages-if-allocation-in-the-highest-zone-is-possible.patch
+h8300-generic-irq.patch
+h8300-add-zimage-support.patch
+arm26-remove-useless-config-option-generic_bust_spinlock.patch
+m68k-export-csum_partial_copy_from_user.patch
+uml-send-pointers-instead-of-structures-to-i-o-thread-fix.patch
+uml-eliminate-a-piece-of-debugging-code.patch
+uml-more-page-fault-path-trimming.patch
+uml-only-flush-areas-covered-by-vma.patch
+uml-out-of-tmpfs-space-error-clarification.patch
+uml-virtualized-time-fix.patch
+cx88-video-build-fix.patch
+fix-ppp_deflate-issues-with-recent-zlib_inflate-changes.patch
+ehci-ps3-ohci-ps3-fix-compilation.patch
+rename-tanbac-tb0219-config.patch
+maintainer-change-for-connect-tech-inc.patch

 Part of the forst 2.6.22 batch

-slab-introduce-krealloc-fix.patch

 Folded into slab-introduce-krealloc.patch

+acpi-video-dont-export-sysfs-backlight-interface-if-query-_bcl-fail.patch
+acpimsi-laptop-fall-back-to-ec-polling-mode-for-msi-laptop-specific-ec-commands.patch
+git-acpi-export-acpi_set_cstate_limit.patch

 ACPI things

-asus_acpi-invert-read-of-wled-proc-file-to-show-correct.patch

 Dropped

-git-alsa-fixup.patch

 Unneeded

+wm8750-typo-fix.patch
+wavefront-only-declare-isapnp-on-config_pnp.patch

 ALSA fixes

-git-agp-build-fix.patch

 Unneeded

+working-3d-dri-intel-agpko-resume-for-i815-chip.patch
+working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch

 AGP fix.  Needs to be redone.

+iop13xx-msi-support-rev6.patch
+arm-remove-useless-config-option-generic_bust_spinlock.patch
+arm-spinlock-initializer-cleanup.patch

 ARM things

+agk-dm-dm-raid1-fix-to-commit-pending-clear-region-requests.patch
+agk-dm-dm-raid1-switch-rh_in_sync-to-blocking-in-do_reads.patch
+agk-dm-dm-log-fix-resume-failed-log-device.patch

 device-mapper tree updates

+kcopyd-use-mutex-instead-of-semaphore.patch

 DM cleanup

-macintosh-mediabay-convert-to-kthread-api.patch
-macintosh-adb-convert-to-the-kthread-api.patch
-macintosh-therm_pm72c-partially-convert-to-kthread-api.patch
-powerpc-pseries-rtasd-convert-to-kthread-api.patch
-powerpc-pseries-eeh-convert-to-kthread-api.patch

 Dropped

+gregkh-driver-fix-uevent-show.patch
+gregkh-driver-platform-reorder-platform_device_del.patch
+gregkh-driver-doc-fix-wrong-identifier-name-in-documentation-driver-model-devrestxt.patch
+gregkh-driver-sysfs-printk-format-warning.patch
+gregkh-driver-idr-fix-obscure-bug-in-allocation-path.patch
+gregkh-driver-idr-separate-out-idr_mark_full.patch
+gregkh-driver-ida-implement-idr-based-id-allocator.patch
+gregkh-driver-sysfs-allocate-inode-number-using-ida.patch
+gregkh-driver-sysfs-flatten-and-fix-sysfs_rename_dir-error-handling.patch
+gregkh-driver-sysfs-separate-out-sysfs_attach_dentry.patch
+gregkh-driver-sysfs-reimplement-syfs_drop_dentry.patch

 Driver tree updates

+fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
+gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch
+s390-fix-subsystem-removal-fallout.patch

 Fix it.

+power-management-remove-some-useless-code-from-arm.patch
+power-management-use-mutexes-instead-of-semaphores.patch
+sysdev-use-mutex-instead-of-semaphore.patch

 Things for the driver tree

+drm-spinlock-initializer-cleanup.patch

 DRM fixlet

+cinergyt2-fix-file-release-handler.patch

 DVB fix

+jdelvare-i2c-i2c-documentation-update.patch

 I2C tree update

+scx200-use-mutex-instead-of-semaphore.patch

 i2c cleanup

+jdelvare-hwmon-hwmon-maintainer-position-open.patch

 hwmon tree updates

-apple-smc-driver-standardize-and-sanitize-sysfs-tree.patch
-apple-smc-driver-implement-key-enumeration.patch
-applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue.patch
-applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix.patch

 Folded into apple-smc-driver-hardware-monitoring-and-control.patch

-hid-add-two-led-codes-to-hid-input-mapping.patch

 Dropped, I think

+git-hid-fixup.patch

 Fix rejects in git-hid

-ia64-sn-xpc-convert-to-use-kthread-api.patch
-ia64-sn-xpc-convert-to-use-kthread-api-fix.patch

 Dropped

-git-input-fixup.patch

 Unneeded

+input-fix-aux-port-detection-with-some-i8042-chips.patch
+input-fix-aux-port-detection-with-some-i8042-chips-fix.patch

 8042 fix

-setstream-param-for-psmouse.patch

 Dropped, unneeded

-input-ff-add-ff_raw-effect.patch
-input-phantom-add-a-new-driver.patch

 Updated

+libata-clean-up-sff-init-mess.patch
+pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
+pata_pcmcia-recognize-2gb-compactflash-from-transcend.patch
+drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch
+pata_icside-driver.patch
+add-the-combined-mode-for-ati-sb700.patch
+add-the-ati-sb700-sata-controller-device-id-to-ahci-pci-table.patch
+libata-add-support-for-ata_16-on-atapi.patch
+fix-pata_qdic-probe-code.patch
+pata_scc-fix-compilation.patch

 ata things

-testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch

 Folded into testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch

+sl82c105-switch-to-ref-counting-api.patch
+hpt366-dont-check-enablebits-for-hpt36x.patch

 IDE fixes

+mips-make-resources-for-ds1742-static-__initdata.patch

 MIPS fix

-git-ubi-fixup.patch

 Unneeded

+drivers-mtd-maps-nettelc-possible-cleanups.patch
+ubi-dereference-after-kfree-in-create_vtbl-2.patch

 UBI fixes

-vioc-warning-fix.patch
-vioc-cast-warning-fix.patch
-drivers-net-vioc-possible-cleanups.patch
-vioc-replace-more-deprecated-sa_xxx-interrupt-flags.patch

 This driver got removed.

+mips-drop-unnecessary-config_isa-from-rbtx49xx.patch
+ibmtr_cs-fix-hang-on-eject.patch
+ne-add-platform_driver.patch
+ne-misc-fixes-for-platform-driver.patch
+ne-add-needs_portlist-to-control-isa-auto-probe.patch
+ne-mips-use-platform_driver-for-ne-on-rbtx49xx.patch
+natsemi-improve-diagnostics-for-dspcfg-workaround.patch
+natsemi-allow-users-to-disable-workaround-for-dspcfg-reset.patch
+natsemi-allow-users-to-disable-workaround-for-dspcfg-reset-fix.patch
+atl1-use-dev_printk-macros.patch
+atl1-use-dev_printk-macros-fix.patch
+atl1-fix-whitespace-damage.patch

 netdev stuff

-git-net-fixup.patch

 Unneded

+netlink-remove-bogus-bug_on.patch
+use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch

 net things

-input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes.patch
-input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-fix.patch
-input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-2.patch
-input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-3.patch

 Folded into input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch

+git-nfs-printk-warning-fixes.patch

 Fix git-nfs.patch

-serial-use-resource_size_t-for-serial-port-io-addresses.patch
-serial-suppress-rts-assertion-with-disabled-crtscts.patch
-8250_pci-fix-pci-must_checks.patch

 Dropped.

+gregkh-pci-pci-syscallc-switch-to-refcounting-api.patch
+gregkh-pci-pci-reduce-aer-init-error-information.patch
+gregkh-pci-msi-fix-arm-compile.patch

 PCI tree updates

-cpqphp-partially-convert-to-use-the-kthread-api.patch
-ibmphp-partially-convert-to-use-the-kthreads-api.patch
-cpci_hotplug-partially-convert-to-use-the-kthread-api.patch

 Dropped

+fix-pci_find_present.patch

 pci core fix

-git-s390-fixup.patch

 Unneeded

+s390-spinlock-initializer-cleanup.patch

 s390 fix

+git-sh-fixup.patch

 Fix rejects in git-sh.patch

-scsi-fix-config_scsi_wait_scan=m-fix.patch
-scsi-fix-config_scsi_wait_scan=m-fix-fix.patch

 Folded into scsi-fix-config_scsi_wait_scan=m.patch

-sas_scsi_host-partially-convert-to-use-the-kthread-api.patch

 Dropped

-pci-error-recovery-symbios-scsi-base-support-fixes.patch

 Folded into pci-error-recovery-symbios-scsi-base-support.patch

-pci-error-recovery-symbios-scsi-first-failure-fix.patch

 Folded into pci-error-recovery-symbios-scsi-first-failure.patch

+scsi-use-irq_handler_t-where-appropriate.patch
+scsi-lpfc-lpfc_initc-remove-unused-variable.patch
+drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
+drivers-scsi-ipsc-remove-kernel-24-code.patch
+drivers-scsi-nsp32c-remove-kernel-24-code.patch
+drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch
+drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc.patch

 scsi cleanups

+use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
+use-mutex-instead-of-semaphore-in-sbpcd-driver.patch

 Mutex conversions in cdrom drivers

+git-block-fixup.patch

 Fix DM tree for recent block merge

-sparc64-powerc-convert-to-use-the-kthread-api.patch

 Dropped

+gregkh-usb-usb-fix-omninet-memory-leak-found-by-coverity.patch
+gregkh-usb-usb-remove-useless-check-in-mos7840-found-by-coverity.patch
+gregkh-usb-usb-storage-ignore-sitecom-wl-117-usb-wlan.patch
+gregkh-usb-usb-fix-more-ftdi-elan-u132-hcd-include-lossage.patch
+gregkh-usb-usb-handle-more-rndis_host-oddities.patch
+gregkh-usb-usb-remove-usb-docbook-warnings.patch
+gregkh-usb-usb-address-fixme-in-usbnet-wrt-drivers-claiming-multiple-interfaces.patch
+gregkh-usb-ehci-fix-problem-with-bios-handoff.patch
+gregkh-usb-usb-more-autosuspend-timer-stuff.patch
+gregkh-usb-usb-make-the-autosuspend-workqueue-thread-freezable.patch
+gregkh-usb-usb-remove-unneeded-warn_on.patch
+gregkh-usb-usb-new-device-pid-for-ftdi_sio-driver.patch
+gregkh-usb-usb-suspend-support-for-usb-serial.patch
+gregkh-usb-usb-set-the-correct-interrupt-interval-in-usb_bulk_msg.patch
+gregkh-usb-usb-fsl_usb2_udc-fix-umti_wide-support-and-a-compile-warning.patch

 USB tree updates

-cxacru-add-documentation-file-fix.patch

 Folded into cxacru-add-documentation-file.patch

+cxacru-cleanup-sysfs-attribute-code.patch
+cxacru-create-sysfs-attributes-in-atm_start-instead-of-bind.patch
+maintainers-add-cxacru-website-mailing-list.patch
+cxacru-ignore-error-trying-to-start-adsl-in-atm_start.patch
+auerswald-fix-file-release-handler.patch
+use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch

 USB updates

+git-wireless-build-fix.patch

 Fix git-wireless.patch

-x86_64-mm-a-memcpy-that-tries-to-reduce-cache-pressure.patch
-x86_64-mm-fam10-l3cache.patch
-x86_64-mm-unwinder.patch
-x86_64-mm-dma_ops-as-const.patch
-x86_64-mm-assembly-safe-page_h-and-pgtable_h.patch
-x86_64-mm-kill-temp-boot-pmds.patch
-x86_64-mm-clean-up-the-early-boot-page-table.patch
-x86_64-mm-fix-early-printk-to-use-standard-isa-mapping.patch
-x86_64-mm-modify-copy_bootdata-to-use-virtual-addresses.patch
-x86_64-mm-cleanup-segments.patch
-x86_64-mm-add-efer-to-the-register-set-saved-by-save_processor_state.patch
-x86_64-mm-64bit-pic-smp-trampoline.patch
-x86_64-mm-get-rid-of-dead-code-in-suspend-resume.patch
-x86_64-mm-wakeup_s-rename-registers-to-reflect-right-names.patch
-x86_64-mm-wakeup_s-misc-cleanups.patch
-x86_64-mm-64bit-acpi-wakeup-trampoline.patch
-x86_64-mm-modify-discover_ebda-to-use-virtual-addresses.patch
-x86_64-mm-remove-the-identity-mapping-as-early-as-possible.patch
-x86_64-mm-move-swsusp-__pa-dependent-code-to-arch-portion.patch
-x86_64-mm-do-not-use-virt_to_page-on-kernel-data-address.patch
-x86_64-mm-__pa-and-__pa_symbol-address-space-separation.patch
-x86_64-mm-relocatable-kernel-support.patch
-x86_64-mm-build-time-checking.patch
-x86_64-mm-extend-bzimage-protocol-for-relocatable-bzimage.patch
-x86_64-mm-move-cpu-verification-code-to-common-file.patch
-x86_64-mm-export_symbol_gpl-5-functions.patch
-x86_64-mm-get_futex_key-get_key_refs-and-drop_key_refs.patch
-x86_64-mm-clarify-config_reorder-explanation.patch
-x86_64-mm-prevent-acpi-quirk-warning-mass-spamming-in-logs.patch
-x86_64-mm-fam10-i386-mce.patch
-x86_64-mm-paravirt-fix-paravirt-documentation.patch
-x86_64-mm-kremove-a-warning-about-unused-variable-in-config_acpi-compilation_.patch
-x86_64-mm-nmi-hack-revert.patch

 I think a lot of these were dropped from Andi's tree

+x86_64-mm-reloc64-dma_ops-as-const.patch
+x86_64-mm-reloc64-assembly-safe-page_h-and-pgtable_h.patch
+x86_64-mm-reloc64-kill-temp-boot-pmds.patch
+x86_64-mm-reloc64-clean-up-the-early-boot-page-table.patch
+x86_64-mm-reloc64-fix-early-printk-to-use-standard-isa-mapping.patch
+x86_64-mm-reloc64-modify-copy_bootdata-to-use-virtual-addresses.patch
+x86_64-mm-reloc64-cleanup-segments.patch
+x86_64-mm-reloc64-add-efer-to-the-register-set-saved-by-save_processor_state.patch
+x86_64-mm-reloc64-64bit-pic-smp-trampoline.patch
+x86_64-mm-reloc64-get-rid-of-dead-code-in-suspend-resume.patch
+x86_64-mm-reloc64-wakeup_s-rename-registers-to-reflect-right-names.patch
+x86_64-mm-reloc64-wakeup_s-misc-cleanups.patch
+x86_64-mm-reloc64-64bit-acpi-wakeup-trampoline.patch
+x86_64-mm-reloc64-modify-discover_ebda-to-use-virtual-addresses.patch
+x86_64-mm-reloc64-remove-the-identity-mapping-as-early-as-possible.patch
+x86_64-mm-reloc64-move-swsusp-__pa-dependent-code-to-arch-portion.patch
+x86_64-mm-reloc64-do-not-use-virt_to_page-on-kernel-data-address.patch
+x86_64-mm-reloc64-__pa-and-__pa_symbol-address-space-separation.patch
+x86_64-mm-reloc64-relocatable-kernel-support.patch
+x86_64-mm-reloc64-build-time-checking.patch
+x86_64-mm-reloc64-extend-bzimage-protocol-for-relocatable-bzimage.patch
+x86_64-mm-reloc64-move-cpu-verification-code-to-common-file.patch
+x86_64-mm-cpa-kerneltext.patch
+x86_64-mm-paravirt-lazy-use-enums.patch
+x86_64-mm-deflate-inflate_dynamic-too.patch
+x86_64-mm-paravirt-allow-boot-time-disable-of-paravirt_ops-patching.patch
+x86_64-mm-mtrr-move-definitions-to-mtrr-h.patch
+x86_64-mm-safeapic-safe_apic_wait_icr_idle-i386.patch
+x86_64-mm-safeapic-safe_apic_wait_icr_idle-x86_64.patch
+x86_64-mm-safeapic-use-safe_apic_wait_icr_idle-i386.patch
+x86_64-mm-safeapic-use-safe_apic_wait_icr_idle-x86_64.patch
+x86_64-mm-safeapic-use-safe_apic_wait_icr_idle-smpboot-i386.patch
+x86_64-mm-safeapic-use-safe_apic_wait_icr_idle-smpboot-x86_64.patch
+x86_64-mm-safeapic-__send_ipi_dest_field-i386.patch
+x86_64-mm-safeapic-__send_ipi_dest_field-x86_64.patch
+x86_64-mm-safeapic-use-safe_apic_wait_icr_idle-in-safe_apic_wait_icr_idle-i386.patch
+x86_64-mm-safeapic-use-safe_apic_wait_icr_idle-in-__send_ipi_dest_field-x86_64.patch
+x86_64-mm-fix-mtrr-sections.patch
+x86_64-mm-paravirt-add-a-sched_clock-paravirt_op.patch
+x86_64-mm-paravirt-fix-startup_ipi_hook-config-dependency.patch
+x86_64-mm-move-__vgetcpu_mode-__jiffies-to-the-vsyscall_2-zone.patch
+x86_64-mm-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined.patch
+x86_64-mm-machine-restart-replace-spin_lock_irqsave-with-spin_lock.patch
+x86_64-mm-clean-up-flush_tlb_others-fn.patch
+x86_64-mm-mce-amd-check-capability.patch
+x86_64-mm-auto-generate-syscall-max.patch
+x86_64-mm-skip-cache_free_alien-on-non-numa.patch
+x86_64-mm-remove-xtime_locking-around-cpufreq-notifier.patch
+x86_64-mm-vmi-pte-clear-optimization.patch
+x86_64-mm-pte-xchg-optimization.patch
+x86_64-mm-pte-simplify-ops.patch
+x86_64-mm-irqbalance-convert-to-the-kthread-api.patch
+x86_64-mm-unexport-cpu_llc_id.patch
+x86_64-mm-i386-fix-wrong-comment-for-syscall-stack-layout.patch
+x86_64-mm-mce-interval.patch
+x86_64-mm-numa-possible-at-runtime.patch
+x86_64-mm-compat-ignore-ioctl.patch
+x86_64-mm-verify-cpu-symbolic.patch
+x86_64-mm-drop-traditional-for-boot.patch
+x86_64-mm-i386-drop-traditional-for-boot.patch
+x86_64-mm-i386-verify-cpu.patch
+x86_64-mm-i386-constant-cpufeatures.patch
+x86_64-mm-i386-alternative-io.patch
+x86_64-mm-i386-feature-sync-rdtsc.patch
+x86_64-mm-i386-feature-rdtscp.patch
+x86_64-mm-use-rdtscp-for-get-cycles-sync.patch
+x86_64-mm-disable-numa-for-single-node.patch
+x86_64-mm-i386-smpboot-cleanup.patch
+x86_64-mm-i386-remove-copy-user-bug.patch
+x86_64-mm-compat-decode-ioctl.patch
+x86_64-mm-remove-reordering.patch
+x86_64-mm-share-video-s.patch
+x86_64-mm-compat-ignore-fat-ioctl.patch
+x86_64-mm-errno-genapic.patch
+x86_64-mm-drop-annoying-e820-printks.patch
+x86_64-mm-white-space-fixes-in-i387_h.patch
+x86_64-mm-avoid-redundant-preempt_disable-in-__unlazy_fpu.patch
+x86_64-mm-fix-dontdiff.patch

 x86 tree updates

+fix-x86_64-mm-mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap.patch
+i386-add-support-for-picopower-irq-router.patch
+i386-add-support-for-picopower-irq-router-fix.patch
+make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
+arch-i386-kernel-i8253c-should-include-asm-timerh.patch
+make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch

 x86 updates

-spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
-spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
-spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch

 Dropped.

+fix-leaky-resv_huge_pages-when-cpuset-is-in-use.patch
+increase-slab-redzone-to-64bits.patch
+handle-kernelcore=-generic.patch

 MM updates

-add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages-fix.patch

 Folded into add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch

-add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
-add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch

 Folded into add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch

-add-a-configure-option-to-group-pages-by-mobility-speedup.patch

 Folded into add-a-configure-option-to-group-pages-by-mobility.patch

-move-free-pages-between-lists-on-steal-fix.patch
-move-free-pages-between-lists-on-steal-fix-2.patch
-move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch
-move-free-pages-between-lists-on-steal-do-not-cross-section-boundary-when-moving-pages-between-mobility-lists.patch
+move-free-pages-between-lists-on-steal-anti-fragmentation-switch-over-to-pfn_valid_within.patch

 Folded into move-free-pages-between-lists-on-steal.patch

-create-the-zone_movable-zone-align-zone_movable-to-a-max_order_nr_pages-boundary.patch

 Folded into create-the-zone_movable-zone.patch

-x86-specify-amount-of-kernel-memory-at-boot-time.patch
-ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
-x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
-ia64-specify-amount-of-kernel-memory-at-boot-time.patch
-add-documentation-for-additional-boot-parameter-and-sysctl.patch
-handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64.patch

 Folded into allow-huge-page-allocations-to-use-gfp_high_movable.patch

-mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
-mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix-2.patch

 Folded into mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch

-mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch

 Folded into  mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch

+mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch

 Fix it a bit more

-mm-merge-nopfn-into-fault-fix.patch

 Folded into mm-merge-nopfn-into-fault.patch

-i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
-smaps-add-clear_refs-file-to-clear-reference-fix.patch
-smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
-smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
-smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
-smaps-use-ptep_test_and_clear_young.patch
-smaps-add-clear_refs-file-to-clear-reference-docs.patch

 Folded into other patches

-maps2-move-the-page-walker-code-to-lib-fix.patch

 Folded into maps2-move-the-page-walker-code-to-lib.patch

-maps2-add-proc-pid-pagemap-interface-fix.patch
-maps2-add-proc-pid-pagemap-interface-fix-fix.patch

 Folded into maps2-add-proc-pid-pagemap-interface.patch

-maps2-add-proc-kpagemap-interface-fix.patch

 Folded into maps2-add-proc-kpagemap-interface.patch

-lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch
-lumpy-only-count-taken-pages-as-scanned.patch
-kswapd-use-reclaim-order-in-background-reclaim.patch
-lumpy-increase-pressure-at-the-end-of-the-inactive-list.patch
-introduce-high_order-delineating-easily-reclaimable-orders.patch
-introduce-high_order-delineating-easily-reclaimable-orders-cleanups.patch
-lumpy-increase-pressure-at-the-end-of-the-inactive-list-cleanups.patch
-anti-fragmentation-switch-over-to-pfn_valid_within.patch

 Folded into lumpy-reclaim-v4.patch

-readahead-code-cleanup-fix.patch
-bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
-bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy-fix.patch

 Folded into other patches

-mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch

 Folded into mm-move-common-segment-checks-to-separate-helper-function-v7.patch

-extend-print_symbol-capability.patch
-extend-print_symbol-capability-fix.patch
-extend-print_symbol-capability-fix-fix.patch
-slub-fix-numa-bootstrap.patch
-slub-use-correct-flags-to-check-for-dma-cache.patch
-slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
-slub-core-minor-fixes.patch
-slub-core-use-enum-for-tracking-modes-instead-of-integers.patch
-slub-core-fix-another-numa-bootstrap-issue.patch
-slub-core-fix-object-counting.patch
-slub-core-drop-version-number.patch
-slub-core-tidy.patch
-slub-core-tidy-2.patch
-slub-core-tidy-3.patch
-slub-core-tidy-4.patch
-slub-core-tidy-5.patch
-slub-core-tidy-6.patch
-slub-core-tidy-7.patch
-slub-core-tidy-8.patch
-slub-core-tidy-9.patch
-slub-core-we-do-not-need-ifdef-config_smp-around-bit-spinlocks.patch
-slub-core-printk-facility-level-cleanup.patch
-slub-core-kmem_cache_close-is-static-and-should-not-be-exported.patch
-slub-core-add-explanation-for-defrag_ratio-=-100.patch
-slub-core-add-explanation-for-locking.patch
-slub-core-add-explanation-for-locking-fix.patch
-slub-core-explain-the-64k-limits.patch
-slub-core-explain-sizing-of-slabs-in-detail.patch
-slub-core-explain-sizing-of-slabs-in-detail-fix.patch
-slub-core-add-checks-for-interrupts-disabled.patch
-slub-core-use-__print_symbol-instead-of-kallsyms_lookup.patch
-slub-core-missing-inlines-and-statics.patch
-slub-fix-cpu-slab-flushing-behavior-so-that-counters-match.patch
-slub-extract-finish_bootstrap-function-for-clean-sysfs-boot.patch
-slub-core-more-statics.patch
-slub-core-fix-kmem_cache_destroy.patch
-slub-core-fix-validation.patch
-slub-core-add-after-object-padding.patch
-slub-core-resiliency-fixups.patch
-slub-core-resiliency-fixups-fix.patch
-slub-core-resiliency-test.patch
-slub-core-update-cpu-after-new_slab.patch
-make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
-slub-enable-tracking-of-full-slabs-fix.patch
-slub-enable-tracking-of-full-slabs-add-checks-for-interrupts-disabled.patch
-slub-validation-of-slabs-metadata-and-guard-zones-fix-pageerror-checks-during-validation.patch
-slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
-slub-user-documentation-fix.patch
-slub-add-slabinfo-tool-update-slabinfoc.patch
-quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
-quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion-fix.patch
-mm-optimize-kill_bdev-fix.patch
-lazy-freeing-of-memory-through-madv_free-fix.patch
-lazy-freeing-of-memory-through-madv_free-sparc-fix.patch
-madv_free-lazytlb-fix.patch
-lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
-slab-allocators-remove-slab_debug_initial-flag-locks-fix.patch

 Folded into other patches

+slub-exploit-page-mobility-to-increase-allocation-order.patch
+slub-i386-support.patch

 Held-back SLUB patches

-return-eperm-not-echild-on-security_task_wait-failure-fix.patch
-blackfin-Documentation.patch
-blackfin-arch-balance-parenthesis-in-macros.patch
-blackfin-arch-2.6.21-rc4-mm1-update.patch
-blackfin-arch-fix-struct-dmasg-packing-bug.patch
-blackfin-arch-cleanup-cache-header-file.patch
-blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
-blackfin-arch-fix-compiling-error-in-flat-c-file.patch
-blackfin-arch-power-management-replace-firmware-disk-mode.patch
-blackfin-arch-add-kdebug-header-file.patch
-blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch
-blackfin-arch-fix-bug-prevent-warning-in-case-bf531-is-target.patch
-blackfin-arch-fix-stamp537-isp1716-irq-setting-bug.patch
-blackfin-arch-fix-bug-interrupt-setup-problem-request_irq.patch
-blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch
-blackfin-arch-always-include-linux-kallsysms-header-file.patch
-blackfin-arch-sync-with-uclibc-no-functional-changes.patch
-blackfin-arch-using-asm-generic-pgtable-header-file-by.patch
-blackfin-arch-add-missing-__clear_user-function-to.patch
-blackfin-arch-use-boot_command_line-instead-of.patch
-blackfin-arch-fix-some-coding-style-in-include.patch
-blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch
-blackfin-arch-add-missing-blackfin-support-in-lib.patch
-blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data.patch
-blackfin-arch-source-kernel-preemption-option.patch
-blackfin-arch-workaround-bf561-anomaly-05000266.patch
-blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update.patch
-blackfin-arch-fix-bug-asserting-gpio-requested-doesnt-make-sense-with-gpio-whole-port-accesses.patch
-blackfin-arch-04-and-05-silicon-doesnt-exist-for-bf534-bf536-adn-bf537-so-dont-let-people-select-the-option.patch
-driver_bfin_serial_core-update.patch
-blackfin-on-chip-ethernet-mac-controller-driver-update.patch
-blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
-blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
-blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch

 Folded into other patches

+swsusp-clean-up-print.patch
+pm-separate-hibernation-code-from-suspend-code.patch

 swsusp updates

-rework-pm_ops-pm_disk_mode-kill-misuse.patch
-power-management-remove-firmware-disk-mode.patch
-power-management-implement-pm_opsvalid-for-everybody.patch
-power-management-force-pm_opsvalid-callback-to-be.patch
-pm-introduce-suspend-notifiers-rev-2.patch

 Folded into other patches

-array_size-check-for-type-uml-fix.patch
-uml-tidy-processc-fix.patch

 Folded into other patches

+uml-make-hostfs_setattr-support-operations-on-unlinked-open-files.patch
+uml-hostfs-style-fixes.patch
+uml-an-idle-system-should-have-zero-load-average.patch

 UML updates

-deprecate-smbfs-in-favour-of-cifs-docs.patch

 Folded into deprecate-smbfs-in-favour-of-cifs.patch

-doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch

 Folded into other patches

-kill-net-rxrpc-rxrpc_symsc.patch

 Dropped (I think)

-fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch

 Dropped

+apple-smc-driver-hardware-monitoring-and-control-fix-names.patch
+apple-smc-driver-hardware-monitoring-and-control-cleanup.patch

 More apple-smc updates

-exec-fix-remove_arg_zero-add-comment.patch

 Folded into exec-fix-remove_arg_zero.patch

-merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
-merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix.patch
-merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch

 Folded into merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch

-ext3-dirindex-error-pointer-issues-fix.patch

 Folded into ext3-dirindex-error-pointer-issues.patch

-epoll-optimizations-and-cleanups-tidy.patch

 Folded into epoll-optimizations-and-cleanups.patch

-add-file-position-info-to-proc-fix.patch

 Folded into add-file-position-info-to-proc.patch

-fix-cycladesh-for-x86_64-and-probably-others-fix.patch

 Folded into fix-cycladesh-for-x86_64-and-probably-others.patch

-rtc-add-rtc-rs5c313-driver-tidy.patch
-rtc-add-rtc-rs5c313-driver-is-busted.patch

 Folded into rtc-add-rtc-rs5c313-driver.patch

+rtc-add-rtc-class-driver-for-the-maxim-max6900-update.patch

 Folded into rtc-add-rtc-class-driver-for-the-maxim-max6900.patch

-fix-rmmod-read-write-races-in-proc-entries-fix.patch

 Folded into fix-rmmod-read-write-races-in-proc-entries.patch

+get_futex_key-get_key_refs-and-drop_key_refs.patch

 Futex work

-futex-restartable-futex_wait-fix.patch

 Folded into futex-restartable-futex_wait.patch

-tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
-tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch

 Folded into other patches

-add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch

 Folded into add-ability-to-keep-track-of-callers-of-symbol_getput.patch

-move-die-notifier-handling-to-common-code-fixes.patch
-move-die-notifier-handling-to-common-code-fixes-2.patch
-move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
-move-die-notifier-handling-to-common-code-fix.patch

 Folded into move-die-notifier-handling-to-common-code.patch

-fix-sscanf-%n-match-at-end-of-input-string-tidy.patch

 Folded into fix-sscanf-%n-match-at-end-of-input-string.patch

-parport-dev-driver-model-support-powerpc-fix.patch

 Folded into legacy-pc-parports-support-parport-dev.patch

-cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
-cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch

 Folded into cache-pipe-buf-page-address-for-non-highmem-arch.patch

-add-support-for-deferrable-timers-respun-tidy.patch
-add-support-for-deferrable-timers-respun-fix.patch
-add-support-for-deferrable-timers-respun-fix-2.patch

 Folded into add-support-for-deferrable-timers-respun.patch

-move-timekeeping-code-to-timekeepingc-fix.patch

 Folded into move-timekeeping-code-to-timekeepingc.patch

-ignore-stolen-time-in-the-softlockup-watchdog-fix.patch

 Folded into ignore-stolen-time-in-the-softlockup-watchdog.patch

-kdump-kexec-calculate-note-size-at-compile-time-update.patch
-kdump-kexec-calculate-note-size-at-compile-time-update-2.patch

 Folded into kdump-kexec-calculate-note-size-at-compile-time.patch

-fix-kevents-childs-priority-greediness-fix.patch

 Folded into fix-kevents-childs-priority-greediness.patch

-display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch

 Folded into display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch

-enhance-initcall_debug-measure-latency-fix.patch

 Folded into enhance-initcall_debug-measure-latency.patch

-pnpacpi-sets-pnpdev-devarchdata-fix.patch

 Folded into pnpacpi-sets-pnpdev-devarchdata.patch

-fix-race-between-rmmod-and-cat-proc-kallsyms-fix.patch

 Folded into fix-race-between-rmmod-and-cat-proc-kallsyms.patch

-expose-range-checking-functions-from-arch-specific.patch
-expose-range-checking-functions-from-arch-specific-update.patch
-expose-range-checking-functions-from-arch-specific-update-fix.patch

 Dropped

-remove-hardcoding-of-hard_smp_processor_id-on-up-systems-sparc64-fix.patch

 Folded into remove-hardcoding-of-hard_smp_processor_id-on-up.patch

-pad-irq_desc-to-internode-cacheline-size-fix.patch

 Folded into pad-irq_desc-to-internode-cacheline-size.patch

-dtlk-fix-error-checks-in-module_init-fix.patch

 Folded into dtlk-fix-error-checks-in-module_init.patch

-document-spin_lock_unlocked-rw_lock_unlocked-deprecation-fix.patch

 Folded into document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch

+consolidate-asm-consth-to-linux-consth.patch
+consolidate-asm-consth-to-linux-consth-fix.patch
+x86_64-kill-19000-sparse-warnings.patch
+move-log_buf_shift-to-a-more-sensible-place.patch
+w1-printk-format-warning.patch
+w1-allow-bus-master-to-have-reset-and-byte-ops.patch
+driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
+driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-fix.patch
+driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-simplify-platform_data.patch
+driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-disable-interrupts-when-turning-off-ds1wm.patch
+dma_declare_coherent_memory-wrong-allocation.patch
+fix-vfat-compat-ioctls-on-64-bit-systems.patch
+udf-decrement-correct-link-count-in-udf_rmdir.patch
+doc-fix-oops-tracing-duplicate.patch
+laptop-mode-url-update.patch
+fix-error-handling-in-hdio_getgeo-compat-wrapper.patch
+old-buffer-overflow-in-moxa-driver.patch
+update-the-list-information-for-kexec-and-kdump.patch
+procfs-use-simple_read_from_buffer.patch
+cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
+cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
+misc-add-sensable-phantom-driver.patch
+misc-add-sensable-phantom-driver-v3.patch
+do_tty_write-can-block-even-with-o_nonblock.patch
+do_tty_write-can-block-even-with-o_nonblock-tidy.patch
+synclink_gt-use-dynamic-tty-device-registration.patch
+add-taskstatsh-to-kbuild.patch
+hide-spinlock-in-linux-quotah-behind-__kernel__.patch
+docbook-librs-typo-fixes.patch
+clockchipsh-kernel-doc-fix.patch
+invalid-return-value-of-execve-resulting-in-oopses.patch
+mca-fix-bus-matching.patch
+mca-add-integrated-device-bus-matching.patch
+cm4000_cs-fix-error-paths.patch
+cm4000_cs-use-bitrev.patch
+use-simple_read_from_buffer-in-fs.patch
+use-simple_read_from_buffer-in-kernel.patch
+export-hrtimer_forward.patch
+pretend-cpuset-has-some-form-of-hugetlb-page-reservation.patch
+add-info-about-whitespace-to-submitchecklist.patch
+lib-hexdump.patch
+lib-hexdump-fix.patch
+lib-hexdump-update-on-feedback.patch
+use-mutex-instead-of-semaphore-in-rocketport-driver.patch
+use-mutex-instead-of-semaphore-in-tpm-driver.patch
+use-mutex-instead-of-semaphore-in-hdaps-driver.patch
+use-mutex-instead-of-semaphore-for-misc-char-devices.patch
+pasemi-hardware-rng-driver.patch
+pasemi-hardware-rng-driver-tidy.patch
+nbd-check-the-return-value-of-sysfs_create_file.patch
+nbd-check-the-return-value-of-sysfs_create_file-fix.patch
+move-sig_kernel_-et-al-macros-to-linux-signalh.patch
+8250-remove-commented-out-irq-cruft.patch
+tty_set_ldisc-receive_room-fix.patch
+mutex_lock_interruptible-add-__must_check.patch

 Misc

+tty-add-compat_ioctl.patch
+tty-add-compat_ioctl-fix.patch
+remove-constructor-from-buffer_head.patch
+blacklist-dell-optiplex-320-from-using-the-hpet.patch
+blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch

 Dubious misc: things that need more work and/or thought

+mpc52xx-psc-spi-master-driver.patch
+spi-kerneldoc.patch
+spi-kerneldoc-fix.patch
+au1550-spi-controller-driver.patch

 SPI updates

-mips-convert-to-use-shared-apm-emulation-fix.patch

 Dropped

-make-static-counters-in-new_inode-and-iunique-be-32-bits-comments.patch

 Folded into make-static-counters-in-new_inode-and-iunique-be-32-bits.patch

-implement-flush_work-sanity.patch
-implement-flush_work_keventd.patch

 Folded into implement-flush_work.patch

+workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online.patch

 Folded into workqueue-make-init_workqueues-__init.patch

-kthread-dont-depend-on-work-queues-take-2-fix.patch

 Folded into kthread-dont-depend-on-work-queues-take-2.patch

-fix-kthread_create-vs-freezer-theoretical-race-dont-be-obnoxious.patch

 Folded into fix-kthread_create-vs-freezer-theoretical-race.patch

+move-frozen_process-to-kernel-power-processc.patch
+remvoe-kthread_bind-call-from-_cpu_down.patch
+separate-freezer-from-pm-code-rev-2.patch
+introduce-freezer-flags-rev-2.patch
+make-cancel_rearming_delayed_work-reliable.patch
+make-cancel_rearming_delayed_work-reliable-spelling.patch

 More freezer and workqueue work

-edac-new-opteron-athlon64-memory-controller-driver.patch
-drivers-edac-make-code-static.patch
-pci_module_init-convertion-for-k8_edacc.patch
-edac-k8-driver-coding-tidy.patch
-edac-k8-memory-scrubbing-patch.patch

 Dropped - Doug is redoing this

+sanitize-linux-isdn_divertifh-for-userspace.patch
+use-mutex-instead-of-semaphore-in-capi-20-interface.patch
+isdn-spinlock-initializer-cleanup.patch

 ISDN updates

+rpc-add-wrapper-for-svc_reserve-to-account-for-checksum-fix.patch
+sunrpc-fix-error-path-in-module_init.patch

 nfsd things

-sched-fix-idle-load-balancing-in-softirqd-context-fix.patch

 Folded into sched-fix-idle-load-balancing-in-softirqd-context.patch

-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch

 Folded into sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch

-sched-dont-renice-kernel-threads.patch
-sched-remove-sleepavg-from-proc.patch
-revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
-revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
-sched-implement-staircase-deadline-cpu-scheduler.patch
-sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
-sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch
-sched-implement-staircase-deadline-cpu-scheduler-improvements-fix.patch
-sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice.patch
-sched-implement-staircase-deadline-cpu-scheduler-tweak.patch
-sched-implement-staircase-deadline-scheduler-rework-priomatrix.patch
-sched-implement-staircase-deadline-scheduler-further-improvements-1.patch
-sched-implement-staircase-deadline-scheduler-timeslice-fixes.patch
-sched-implement-staircase-scheduler-yaf-fix.patch
-sched-implement-staircase-deadline-scheduler-ymf-accounting-fixes.patch
-sched-ymf-typo.patch
-sched-implement-staircase-deadline-scheduler-load-weight-fix.patch
-sched-increase-ksoftirqd-priority.patch
-sched-remove-noninteractive-flag.patch
-sched-document-sd-cpu-scheduler.patch
-sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch
-sched-consolidate-sched_clock-drift-adjustments.patch
-sched-consolidate-sched_clock-drift-adjustments-fix.patch
-sched-implement-staircase-deadline-scheduler-docupdate.patch

 Dropped sched things

-lutimesat-simplify-utime2.patch
-lutimesat-extend-do_utimes-with-flags.patch
-lutimesat-actual-syscall-and-wire-up-on-i386.patch
-lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
+utimensat-implementation.patch

 Updated

+rtc-remove-sys-class-rtc-dev-fix.patch

 Folded into rtc-remove-sys-class-rtc-dev.patch

+rtc-cmos-make-it-load-on-pnpbios-systems.patch

 RTC udpate

-make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
-make-futex_wait-use-an-hrtimer-for-timeout-fix-2.patch

 Folded into make-futex_wait-use-an-hrtimer-for-timeout.patch

+futex-new-private-futexes.patch

 Bring this back

-kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
-kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix.patch
-kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix-fix.patch
-kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix.patch

 Folded into kprobes-the-on-off-knob-thru-debugfs-updated.patch

-atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix.patch

 Folded into atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch

+remove-tas.patch
+x86-create-asm-cmpxchgh.patch
+uml-network-and-pcap-cleanup.patch
+uml-pcap-devices-should-get-macs-from-command-line.patch

 UML-related things

-linux-kernel-markers-architecture-independant-code-markers-document-the-linux-markerh-header.patch
-linux-kernel-markers-architecture-independant-code-markers-add-documentation-to-the-modulec-marker-functions.patch

 Folded into linux-kernel-markers-architecture-independant-code.patch

-linux-kernel-markers-powerpc-optimization-markers-changes-to-the-powerpc-marker-header.patch

 Folded into linux-kernel-markers-powerpc-optimization.patch

-linux-kernel-markers-i386-optimization-fix.patch
-linux-kernel-markers-i386-optimization-markers-document-the-i386-marker-header.patch

 Folded into linux-kernel-markers-i386-optimization.patch

-linux-kernel-markers-documentation-markers-update-documentation.patch
-linux-kernel-markers-documentation-fix-typo-and-use-array_size.patch

 Folded into linux-kernel-markers-documentation.patch

-signal-timer-event-fds-v9-anonymous-inode-source-fix.patch

 Folded into signal-timer-event-fds-v9-anonymous-inode-source.patch

-signal-timer-event-fds-v9-signalfd-core-fix.patch
-signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
-signal-timer-event-fds-v9-signalfd-core-fix-fix-fix.patch

 Folded into signal-timer-event-fds-v9-signalfd-core.patch

-signal-timer-event-fds-v9-signalfd-wire-up-i386-arch.patch
-signal-timer-event-fds-v9-signalfd-wire-up-x86_64-arch.patch
+signal-timer-event-signalfd-wire-up-x86-arches.patch

 More signalfd work

-signal-timer-event-fds-v9-timerfd-core-fix.patch
-signal-timer-event-fds-v9-timerfd-core-fix-fix.patch

 Folded into signal-timer-event-fds-v9-timerfd-core.patch

-signal-timer-event-fds-v9-timerfd-wire-up-i386-arch.patch
-signal-timer-event-fds-v9-timerfd-wire-up-x86_64-arch.patch
+signal-timer-event-timerfd-wire-up-x86-arches.patch

 More signalfd work

-signal-timer-event-fds-v9-eventfd-core-fix.patch
-signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
-signal-timer-event-fds-v9-eventfd-core-fix-fix-fix.patch

 Folded into signal-timer-event-fds-v9-eventfd-core.patch

-signal-timer-event-fds-v9-eventfd-wire-up-i386-arch.patch
-signal-timer-event-fds-v9-eventfd-wire-up-x86_64-arch.patch
+signal-timer-event-eventfd-wire-up-x86-arches.patch

 More signalfd work

+revoke-core-code-rename-to-can_revoke_filevma.patch
+revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch

 Revoke fixes

-revoke-wire-up-i386-system-calls-x86_64-fix.patch

 Folded into revoke-wire-up-i386-system-calls.patch

-x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch

 Folded into x86-serial-convert-legacy-com-ports-to-platform-devices.patch

+lguest-export-symbols-for-lguest-as-a-module.patch
+lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
+lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch
+lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
+lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
+lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch
+lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch
+lguest-the-host-code-fix-obscure-but-nasty-cow-bug.patch
+lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
+lguest-documentation-and-example-updates.patch
+lguest-the-host-code-vs-futex-new-private-futexes.patch

 lguest fixes

-lguest-build-hack.patch
-lguest-build-hack-2.patch

 Dropped

+add-suspend-related-notifications-for-cpu-hotplug-cleanup.patch

 Folded into add-suspend-related-notifications-for-cpu-hotplug.patch

+vmstat-use-our-own-timer-events.patch
+make-vm-statistics-update-interval-configurable.patch
+make-vm-statistics-update-interval-configurable-fix.patch
+char-mxser-schedule-for-removal.patch
+char-isicom-use-pr_debug.patch
+clocksource-fix-resume-logic.patch
+acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set.patch
+acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set-vs-x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch
+allow-arch-to-initialize-arch-field-of-the-module-structure.patch
+wrap-access-to-thread_info.patch
+rename-thread_info-to-stack.patch
+rename-thread_info-to-stack-fix.patch
+unprivileged-mounts-add-user-mounts-to-the-kernel.patch
+unprivileged-mounts-allow-unprivileged-umount.patch
+unprivileged-mounts-account-user-mounts.patch
+unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
+unprivileged-mounts-allow-unprivileged-bind-mounts.patch
+unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
+unprivileged-mounts-allow-unprivileged-mounts.patch
+unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
+unprivileged-mounts-propagation-inherit-owner-from-parent.patch
+unprivileged-mounts-add-no-submounts-flag.patch
+char-cyclades-use-is_cyc_z-macro.patch
+char-cyclades-switch-to-pci-probing.patch
+char-cyclades-depends-on-pci-or-isa.patch
+char-cyclades-unexport-struct-cyclades_card.patch
+char-cyclades-remove-useless-fileds-from-cyclades_card.patch
+char-cyclades-irq-is-int.patch
+char-cyclades-printk-cleanups.patch
+char-cyclades-mark-cyy_init_card-as-__devinit-not-__init.patch
+char-cyclades-simplify-variables-initialization.patch
+char-cyclades-get-rid-of-phys-addresses.patch
+char-cyclades-make-info-card-a-pointer.patch
+char-cyclades-remove-sleep_on.patch
+char-cyclades-fix-blockmove.patch
+char-cyclades-timers-cleanup.patch
+char-cyclades-remove-unused-timestamps.patch
+char-cyclades-remove-locking-macros.patch
+char-cyclades-conditions-cleanup.patch
+char-cyclades-conditions-cleanup-fix.patch
+char-cyclades-fix-tty-device-unregister.patch
+char-cyclades-dynamic-ports.patch
+char-cyclades-probe-cleanup.patch
+char-cyclades-probe-cleanup-fix.patch
+char-cyclades-copyright-and-version-changes.patch
+compiler-introduce-__used-and-__maybe_unused.patch
+i386-pci-type-may-be-unused.patch
+sh-dma-use-__maybe_unused.patch
+scsi-fix-ambiguous-gdthtable-definition.patch
+frv-gdb-use-__maybe_unused.patch
+i386-voyager-use-__maybe_unused.patch
+mips-excite-use-__maybe_unused.patch
+mips-tlbex-use-__maybe_unused.patch
+powerpc-ps3-use-__maybe_unused.patch
+i386-mmzone-use-__maybe_unused.patch

 Various stuff people sent me (thanks!)

+readahead-call-scheme-doc-fixes-for-readahead.patch

 Fix readahead-call-scheme-catch-thrashing-on-lookahead-time.patch

+reiser4-remove-typedefs.patch
+reiser4-fix-write_extent.patch
+reiser4-make-sync_inodes-non-void.patch

 reiser4 updates

+ps3-make-ps3videomode-v-0-auto-mode-work-again.patch
+ps3fb-use-__func__-instead-of-__function__.patch
+ps3av-use-__func__-instead-of-__function__.patch
+vt-add-color-support-to-the-underline-and-italic-attributes-fix-2.patch
+fbdev-fbcon-check-if-mode-can-handle-new-screen.patch
+s3fb-implement-fb_get_caps.patch
+vga-vgastate-fix.patch
+nvidiafb-fix-return-value-of-nvidiafb_open.patch
+atyfb-increase-spll-delay.patch
+atyfb-reorganize-clock-init.patch
+atyfb-halve-xclk-with-mobility-and-32bit-memory.patch
+use-mutex-instead-of-semaphore-in-virtual-console-driver.patch
+drivers-video-sis-remove-more-kernel-24-code.patch
+rename-device_is_compatible-to-of_device_is_compatible.patch

 fbdev updates

-md-remove-broken-sigkill-support.patch

 Dropped - Neil is redoing this

-mutex-subsystem-synchro-test-module-convert-to-the-kthread-api.patch

 Dropped

+w1-build-fix.patch

 Might fix w1 with gcc-4.3.




All 1836 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/patch-list


