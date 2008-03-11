Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYCKIP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYCKIP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbYCKIPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:15:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbYCKIO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:14:58 -0400
Date: Tue, 11 Mar 2008 01:14:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc5-mm1
Message-Id: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/

- Added the kgdb tree as git-kgdb-light (Jason Wessel, Ingo Molnar)

- Added a random-security-stuff-apart-from-selinux tree as
  git-security-testing (James Morris)

- suspend-to-disk is still busted on my x86_64 t61p (git-x86, iirc)



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



Changes since 2.6.25-rc3-mm1:

 origin.patch
 git-x86.patch
 git-kgdb-light.patch
 git-acpi.patch
 git-alsa.patch
 git-arm.patch
 git-arm-master.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-drm.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-dlm.patch
 git-hid.patch
 git-hrt.patch
 git-ia64.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-jfs.patch
 git-kvm.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mips.patch
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
 git-scsi-rc-fixes.patch
 git-block.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-xfs.patch
 git-cryptodev.patch
 git-xtensa.patch
 git-slub.patch
 git-semaphore.patch
 git-semaphore-git-rejects.patch

 git trees

-cgroup-fix-default-notify_on_release-setting.patch
-update-checkpatchpl-to-version-015.patch
-serial-add-pnp-id-gvc0303-for-archtek-3334brv-isa-modem.patch
-cris-v10-include-mmh-instead-of-vmstath-in-kernel-timec.patch
-memory-resource-controller-use-strstrip-while-parsing-arguments.patch
-rtc-add-support-for-the-s-35390a-rtc-chip.patch
-specialixc-fix-possible-double-unlock.patch
-gpio-linux-gpioh-and-no-gpio-support-here-stubs.patch
-control-groups-add-paul-menage-a-maintainer.patch
-add-balbir-as-the-maintainer-for-memory-resource-controller.patch
-core-dump-user_regset-writeback.patch
-fix-malformed-early-option-loglevel.patch
-zlc_setup-handle-jiffies-wraparound.patch
-zlc_setup-handle-jiffies-wraparound-fix.patch
-hda_intel-needs-dma-mappingh.patch
-m68knommu-wire-up-new-timerfd-syscalls.patch
-git-alsa-build-fix.patch
-snd-hda-intel-dont-print-using-snd_printdd-on-device-open.patch
-arm-replace-remaining-__function__-occurences.patch
-at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
-omap-register-the-l4-io-bus-to-boot-omap2.patch
-cpufreq-change-cpu-freq-tables-to-per_cpu-variables.patch
-cpufreq-fix-section-mismatch-warnings.patch
-gregkh-driver-debugfs-fix-sparse-warnings.patch
-gregkh-driver-driver-core-numactl-interleave-all-doesn-t-works-on-memoryless-node.patch
-driver-core-fix-cleanup-when-failing-device_add.patch
-video-limit-stack-usage-of-ir-kbd-i2cc.patch
-time-remove-obsolete-clock_tick_adjust.patch
-time-remove-obsolete-clock_tick_adjust-update.patch
-ia64-fix-ptrace-inside-a-namespace.patch
-ia64-remove-unnecessary-nfs-includes-from-sys_ia32c.patch
-ia64-remove-remaining-__function__-occurences.patch
-hdaps-invert-the-axes-for-hdaps-on-lenovo-r61i-thinkpads.patch
-leds-add-mail-led-support-for-clevo-d400p.patch
-pata-i-do-not-think-it-means-what-you-think-it-means.patch
-pata-i-do-not-think-it-means-what-you-think-it-means-checkpatch-fixes.patch
-ide-mm-ide-fix-enabling-dma-on-it821x-in-smart-mode.patch
-ide-mm-ide-add-struct-ide_port_ops.patch
-ide-mm-ide-manage-resources-for-pci-devices-in-ide_pci_enable.patch
-bluetooth-make-hci_sock_cleanup-return-void.patch
-bluetooth-make-bnep_sock_cleanup-return-void.patch
-make-s2iocinit_tti-static.patch
-drivers-net-apnec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-drivers-net-appletalk-ltpcc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-drivers-net-arcnet-capmodec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-drivers-net-8390c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-drivers-net-ac3200c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-fs-ocfs2-use-bug_on.patch
-fs-ocfs2-dlm-dlmdomainc-fix-printk-warning.patch
-pci-fix-section-mismatch-warning-in-pci_scan_child_bus.patch
-pci-consolidate-duplicated-msi-enable-functions.patch
-pci-use-dev_printk-in-quirk-messages.patch
-sh-superh-keysc-platform-driver.patch
-sh-superh-keysc-keypad-data-for-migor.patch
-sh-superh-keysc-keypad-data-for-solution-engine-7722.patch
-sh-replace-remaining-__function__-occurences.patch
-sh-export-copy-page-to-modules.patch
-block-fix-shadowed-variable-warning-in-blk-mapc.patch
-block-remove-extern-on-function-definition.patch
-cciss-remove-read_ahead-define-and-use-block-layer-defaults.patch
-device-mapper-not-reporting-no-barrier-support.patch
-drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
-hci_usb-another-device-with-buggy-sco-support.patch
-cypress_m8-added-ups-powercom-0d9f0002.patch
-usb-use-div_round_up.patch
-usbaudio-handle-kcalloc-failure.patch
-drivers-usb-serial-io_tic-remove-unneeded-null-tty-check.patch
-usb-remove-unnecessary-type-casting-of-urb-context.patch
-usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes.patch
-usb-fix-comment-of-struct-usb_interface.patch
-usb-mos7840c-add-support-for-the-mos7820-7840-based-bb-usb-rs485-converter.patch
-9p-handle-kstrdup-and-match_strdup-failure.patch
-watchdog-hpwdt-fix-declaration-of-struct-smbios_entry_point.patch
-watchdog-hpwdt-fix-return-value-warning.patch
-watchdog-hpwdt-use-dmi_walk-instead-of-own-copy.patch
-crypto-switch-to-proc_create.patch
-alloc_percpu-fails-to-allocate-percpu-data.patch
-vt-notifier-fix-for-vt-switch.patch
-documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
-kprobes-indicate-kretprobe-support-in-kconfig.patch
-kprobes-move-kprobe-examples-to-samples.patch
-memory-controller-rename-to-memory-resource-controller.patch
-tridentfb-resource-management-fixes-in-probe-function.patch
-tridentfb-resource-management-fixes-in-probe-function-fix.patch
-add-noinline_for_stack.patch
-pktcdvd-reduce-stack-consumption.patch
-mpc5200-fix-build-error-on-mpc52xx_psc_spi-device-driver.patch
-ds1wm-should-check-for-is_errclk-instead-of-null.patch
-ds1wm-report-bus-reset-error.patch
-ndelay-switch-to-c-function-to-avoid-64-bit-division.patch
-ndelay-switch-to-c-function-to-avoid-64-bit-division-fix.patch
-sm501fb-direct-color-visual-does-not-work.patch
-sm501fb-rgb-offsets-are-reversed-in-16bpp-modes.patch
-sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes.patch
-sm501fb-fix-timing-limits.patch
-sm501-remove-a-duplicated-table.patch
-sm501-add-support-for-the-sm502-programmable-pll.patch
-sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes.patch
-ipwireless-fix-potential-tty-==-null-dereference.patch
-cris-import-stringc-memcpy-from-newlib-fixes-compile-error-with-gcc-4.patch
-include-falloch-in-header-y.patch
-alpha-convert-iommu-to-use-align.patch
-alpha-iommu-had-better-access-to-the-free-space-bitmap-at-only-one-place.patch
-alpha-make-iommu-respect-the-segment-boundary-limits.patch
-alpha-remove-unused-debug_forcedac-define-in-iommu.patch
-gitignore-ignore-emacs-backup-and-temporary-files.patch
-markers-dont-risk-null-deref-in-marker.patch
-markers-dont-risk-null-deref-in-marker-checkpatch-fixes.patch
-markers-add-an-if0-to-__mark_check_format.patch
-memcg-mm_match_cgroup-not-vm_match_cgroup.patch
-memcg-move_lists-on-page-not-page_cgroup.patch
-memcg-page_cache_release-not-__free_page.patch
-memcg-when-do_swaps-do_wp_page-fails.patch
-memcg-fix-vm_bug_on-from-page-migration.patch
-memcg-bad-page-if-page_cgroup-when-free.patch
-memcg-mem_cgroup_charge-never-null.patch
-memcg-remove-mem_cgroup_uncharge.patch
-memcg-memcontrol-whitespace-cleanups.patch
-memcg-memcontrol-uninlined-and-static.patch
-memcg-remove-clear_page_cgroup-and-atomics.patch
-memcg-css_put-after-remove_list.patch
-memcg-fix-mem_cgroup_move_lists-locking.patch
-memcg-simplify-force_empty-and-move_lists.patch
-memcg-fix-oops-on-null-lru-list.patch
-drivers-char-isicomc-correct-use-of-and.patch
-drivers-isdn-correct-use-of-and.patch
-drivers-serial-m32r_sioc-correct-use-of-and.patch
-fs-reiserfs-superc-correct-use-of-and.patch
-block-fix-residual-byte-count-handling.patch
-acpi-thinkpad-acpi-fix-hotkey_get_tablet_mode.patch
-cris-correct-usage-of-__user-for-copy-to-and-from-user-space-in-lib-usercopy-and-uaccessh-try-2.patch
-cris-correct-syscall-numbers-in-unistdh-for-timerfd_settime-and-timerfd_gettime.patch
-kernel-add-clamp-and-clamp_t-macros.patch
-kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
-kernel-add-clamp-and-clamp_t-macros-fix.patch
-ecryptfs-make-ecryptfs_prepare_write-decrypt-the-page.patch
-hisax_fcpcipnp-move-request_irq-later-in-probe.patch
-iommu-export-iommu_is_span_boundary-helper-function.patch
-iommu-parisc-pass-struct-device-to-iommu_alloc_range.patch
-iommu-parisc-pass-struct-device-to-iommu_alloc_range-checkpatch-fixes.patch
-iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits.patch
-iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits-checkpatch-fixes.patch
-md-fix-deadlock-in-md-raid1-and-md-raid10-when-handling-a-read-error.patch
-md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap.patch
-md-guard-against-possible-bad-array-geometry-in-v1-metadata.patch
-md-clean-up-irregularity-with-raid-autodetect.patch
-md-make-sure-a-reshape-is-started-when-device-switches-to-read-write.patch
-md-lock-access-to-rdev-attributes-properly.patch
-md-dont-attempt-read-balancing-for-raid10-far-layouts.patch
-md-fix-possible-raid1-raid10-deadlock-on-read-error-during-resync.patch
-md-the-md-raid10-resync-thread-could-cause-a-md-raid10-array-deadlock.patch
-hugetlb-correct-page-count-for-surplus-huge-pages.patch
-hugetlb-close-a-difficult-to-trigger-reservation-race.patch
-hugetlb-fix-pool-shrinking-while-in-restricted-cpuset.patch
-ext3-fix-mount-option-parsing.patch
-input-add-i2c-to-config-since-the-driver-makes-several-i2c-calls.patch
-kprobes-fix-a-null-pointer-bug-in-register_kretprobe.patch
-pm-do-not-acquire-device-semaphores-upfront-during-suspend.patch
-pm-do-not-acquire-device-semaphores-upfront-during-suspend-fix.patch
-mpt-fusion-dont-oops-if-numphys==0.patch
-bluetooth-hci_core-defer-hci_unregister_sysfs.patch
-e100-do-suspend-shutdown-like-e1000.patch
-bluetooth-conwise-technology-based-adapters-with-buggy-sco-support-bugzilla-9027.patch
-i8042-use-sgi_has_i8042-to-select-sgi-i8042-handlinig.patch
-de2104x-remove-bug_on-when-changing-media-type.patch
-time-prevent-the-loop-in-timespec_add_ns-from-being-optimised-away.patch
-acpi-ec-fix-regression.patch
-drivers-media-video-em28xx-correct-use-of-and.patch
-drivers-media-video-em28xx-correct-use-of-and-fix.patch
-drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
-time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch
-scsi-arcmsr-update-driver-version.patch
-the-kernel-gets-no-ip-from-some-dhcp-servers.patch
-fixed_phy-must-depend-on-phylib=y.patch
-ntfs-fix-nommu-build.patch
-2625-rc2-mm1-warning-at-arch-x86-mm-ioremapc129.patch
-slub-fix-possible-null-pointer-dereference.patch
-slub-fix-possible-null-pointer-dereference-fix.patch
-rxrpc-fix-rxrpc_recvmsgs-returning-of-msg_name.patch
-lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks.patch
-selinux-setup-new-inode-ipc-getsecid-hooks.patch
-audit-use-new-lsm-hooks-instead-of-selinux-exports.patch
-netlink-use-generic-lsm-hook.patch
-selinux-remove-redundant-exports.patch
-lsm-audit-introduce-generic-audit-lsm-hooks.patch
-audit-internally-use-the-new-lsm-audit-hooks.patch
-selinux-use-new-audit-hooks-remove-redundant-exports.patch
-audit-final-renamings-and-cleanup.patch
-cciss-procfs-updates-to-display-info-about-many-volumes.patch
-make-udf_error-static.patch
-udf-fix-anchor-point-detection.patch
-make-ext4_xattr_list-static.patch
-jbd2-fix-the-way-the-b_modified-flag-is-cleared.patch
-jbd2-fix-possible-journal-overflow-issues.patch
-ext4-fix-mount-option-parsing.patch
-nozomi-prepare-for-bkl-pushdown.patch
-modules-warn-about-suspicious-return-values-from-modules-init-hook.patch

 Merged into mainline or a subsystem tree

+smackfs-do-not-trust-count-in-inodes-writes.patch
+pagemap-proper-read-error-handling.patch
+h8300-fix-recent-uaccess-breakage.patch

 2.6.25 queue

-define-functions-for-page-cache-handling.patch
-use-page_cache_xxx-in-fs-splicec.patch
-use-page_cache_xxx-for-fs-xfs.patch
-use-page_cache_xxx-functions-in-mm-filemapc.patch
-use-page_cache_xxx-in-mm-page-writebackc.patch
-use-page_cache_xxx-in-mm-truncatec.patch
-use-page_cache_xxx-in-mm-rmapc.patch
-use-page_cache_xxx-in-mm-filemap_xipc.patch
-use-page_cache_xxx-in-mm-migratec.patch
-use-page_cache_xxx-in-fs-libfsc.patch
-use-page_cache_xxx-in-fs-sync.patch
-use-page_cache_xxx-in-fs-bufferc.patch
-use-page_cache_xxx-in-mm-mpagec.patch
-use-page_cache_xxx-in-mm-fadvisec.patch
-use-page_cache_xxx-in-ext2.patch
-use-page_cache_xxx-in-ext2-fix.patch
-use-page_cache_xxx-in-fs-ext3.patch
-use-page_cache_xxx-in-fs-reiserfs.patch
-use-page_cache_xxx-in-fs-ext4.patch

 Dropped

+ntfs-fix-nommu-build.patch

 Fix ntfs on nommu (wrongly)

+poweroff-workaround.patch

 Make powerpff work on one of my test boxes (unneeded)

+x86-remove-redundant-display-of-free-swap-space-in-show_mem.patch

 x86 cleanup

+acpi-replace-remaining-__function__-occurrences.patch

 ACPI cleanup

+at73c213-remove-redundant-private_free-routine.patch

 alsa cleanup

+arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch

 arm cleanup

+atmel_serial-avoid-stopping-pdc-during-transmission.patch
+atmel_serial-avoid-stopping-pdc-during-transmission-update.patch

 serial driver updates

+cifs-hack-around-biuld-error.patch

 Pseudo-fix git-cifs

+agk-dm-dm-crypt-add-cond_resched.patch
+agk-dm-dm-log-generalise-name-in-messages.patch
+agk-dm-dm-log-move-dirty-region-log-code-into-separate-module.patch
+agk-dm-dm-snapshot-store-pointer-to-target-instance.patch
+agk-dm-dm-io-write-error-bits-form-long-not-int.patch
+agk-dm-dm-io-rename-error-to-error_bits.patch
+agk-dm-dm-io-clean-interface.patch
+agk-dm-dm-kcopyd-clean-interface.patch
+agk-dm-dm-log-clean-interface.patch

 device mapper tree updates

+git-powerpc-fix-git-rejects.patch

 Fix conflicts in git-powerpc.patch

+drivers-block-viodasdc-use-field_sizeof.patch
+powerpc-8xx-fix-swap.patch
+powerpc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
+ppc-remove-redundant-display-of-free-swap-space-in-show_mem.patch

 powerpc stuff

-gregkh-driver-kobject-properly-initialize-ksets.patch

 Dropped

+gregkh-driver-driver-core-convert-debug-functions-declared-inline-__attribute__-to-statement-expression-macros.patch
+gregkh-driver-memstick-convert-struct-class_device-to-struct-device.patch
+gregkh-driver-driver-core-replace-remaining-__function__-occurrences.patch
+gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
+gregkh-driver-ib-rename-dev-to-srp_dev-in-srp_host-structure.patch

 Driver tree updates

+kobjects-mark-cleaned-up-kobjects-as-unitialized-2.patch
+fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch

 Driver things

-drm-i915-fix-oops-after-killing-x.patch

 Unneeded

+drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
+drivers-media-video-tvp5150c-logical-bitwise-and-confusion.patch

 v4l things

+jdelvare-i2c-i2c-fix-i2c_device_probe.patch
+jdelvare-i2c-i2c-replace-remaining-__function__-occurrences.patch

 I2C tree updates

-oz99x-i2c-button-and-led-support-driver.patch
-fjkeyinf-driver-for-fsc-lifebook-laptops.patch

 Dropped

+hdaps-invert-the-axes-for-hdaps-on-lenovo-r61i-thinkpads.patch
+adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch

 hwmon things

+add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch

 time handling helpers

+ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch
+kprobes-kprobe-booster-for-ia64.patch
+kprobes-kprobe-booster-for-ia64-fix.patch
+ia64-make-iommu-respect-the-segment-boundary-limits.patch
+ia64-remove-redundant-display-of-free-swap-space-in-show_mem.patch

 ia64 things

+infiniband-replace-remaining-__function__-occurrences.patch

 infiniband cleanup

-maple-add-driver-for-sega-dreamcast-controller-update.patch
-maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch

 Folded into maple-add-driver-for-sega-dreamcast-controller.patch

-input-put-ledstate-in-the-keyboard-notifier-fix.patch

 Folded into input-put-ledstate-in-the-keyboard-notifier.patch

-ati_remote2-autorepeat-and-loadable-keymap-support.patch

 Dropped

+aiptekc-add-support-for-genius-g-pen-560-tablet.patch
+ps-2-serio-driver-for-avr32-devices.patch
+input-replace-remaining-__function__-occurrences.patch

 Input things

+ata-swncq-should-be-enabled-by-default.patch

 ATA work

+ide-mm-ide-add-struct-ide_port_ops-take-2.patch
+ide-mm-ide-manage-resources-for-pci-devices-in-ide_pci_enable-take-2.patch
+ide-mm-ide-replace-remaining-__function__-occurrences.patch
+ide-mm-ide-remove-extra-field-from-struct-ide_port_info.patch
+ide-mm-ide-remove-ide_dma_iobase.patch
+ide-mm-ide-remove-cds-field-from-ide_hwif_t.patch
+ide-mm-ide-dont-display-bios-settings-in-ide_setup_dma.patch
+ide-mm-pdc202xx_old-remove-init_dma_pdc202xx.patch
+ide-mm-alim15x3-skip-dma-initialization-completely-on-revs-lt-0x20.patch
+ide-mm-ide-move-ide_setup_dma-call-out-from-init_dma-method.patch
+ide-mm-ide-export-ide_allocate_dma_engine.patch
+ide-mm-ide-factor-out-setting-pci-bus-mastering-from-ide_hwif_setup_dma.patch
+ide-mm-ide-cleanup-ide_setup_dma.patch
+ide-mm-au1xxx-ide-fix-mwdma-support.patch
+ide-mm-ide-do-complete-dma-setup-in-init_dma-method.patch
+ide-mm-ide-pmac-use-init_dma-method.patch
+ide-mm-icside-use-init_dma-method.patch
+ide-mm-sgiioc4-use-init_dma-method.patch
+ide-mm-palm_bk3710-use-init_dma-method.patch
+ide-mm-au1xxx-ide-use-init_dma-method.patch
+ide-mm-sl82c105-check-bridge-revision-in-sl82c105_init_one.patch
+ide-mm-ide-add-ide_hflag_serialize_dma-host-flag.patch
+ide-mm-ide-add-struct-ide_dma_ops.patch
+ide-mm-ide-constify-struct-ide_dma_ops.patch
+ide-mm-ide-tape-remove-tape-cache_stage.patch
+ide-mm-ide-tape-remove-pipeline-specific-code-from-idetape_add_chrdev_write_request.patch
+ide-mm-ide-tape-remove-pipeline-speed_control-calculations.patch
+ide-mm-ide-tape-remove-pipeline-specific-code-from-idetape_add_chrdev_read_request.patch

 IDE tree updates

+drivers-ide-idec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

 IDE cleanup

+mips-remove-redundant-display-of-free-swap-space-in-show_mem.patch

 MIPS cleanup

+mtd-replace-remaining-__function__-occurrences.patch

 MTD cleanup

+git-net-fix-build-with-config_net=n.patch

 Fix git-net

+drivers-net-3c501c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+drivers-net-3c505c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+drivers-net-3c507c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+drivers-net-3c515c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+drivers-net-3c523c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+drivers-net-3c527c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+drivers-net-82596c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+3c509-convert-to-isa_driver-and-pnp_driver-v6.patch
+tulip-de_stop_rxtx-polling-wrong.patch
+3c501-further-coding-style-fixes.patch

 netdev things

+nfs-replace-remaining-__function__-occurrences.patch

 NFS cleanup

+drivers-parisc-replace-remaining-__function__-occurrences.patch
+parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch

 parisc things

+pcmcia-replace-remaining-__function__-occurrences.patch
+alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex.patch
+drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch

 PCMCIA updates

+gregkh-pci-pci-add-pci-express-aspm-support.patch
+gregkh-pci-pci-add-generic-pci_enable_resources.patch
+gregkh-pci-pci-alpha-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-ia64-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-powerpc-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
+gregkh-pci-pci-replace-remaining-__function__-occurrences.patch

 PCI tree updates

+pci-iommu-iotlb-flushing-speedup.patch

 PCI speedup

+s390-remove-redundant-display-of-free-swap-space-in-show_mem.patch
+drivers-s390-replace-remaining-__function__-occurrences.patch

 s390 cleanups

+arcmsr-modify-the-type-of-element-of-messageunit_b.patch
+fusion-mpt-convert-inactive_list_mutex-in-a-mutex.patch
+scsi-replace-remaining-__function__-occurrences.patch
+fusion-replace-remaining-__function__-occurrences.patch
+scsi-replace-__inline-with-inline.patch
+scsi-stc-make-class-attributes-static.patch
+scsi-osstc-make-class-attributes-static.patch
+scsi-chc-fix-shadowed-variable-warnings.patch
+scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch

 SCSI things

+block-replace-remaining-__function__-occurrences.patch
+block-fix-memory-hotplug-and-bouncing-in-block-layer.patch
+block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
+block-fix-blk_register_queue-return-value.patch

 block things

+gregkh-usb-usb-ehci-carry-out-port-handover-during-each-root-hub-resume.patch
+gregkh-usb-usb-reorganize-code-in-hubc.patch
+gregkh-usb-usb-make-usb-persist-work-after-every-system-sleep.patch
+gregkh-usb-usb-remove-config_usb_persist-setting.patch
+gregkh-usb-usb-check-serial-number-string-after-device-reset.patch
+gregkh-usb-usb-enable-usb-persist-by-default.patch
+gregkh-usb-usb-convert-usbh-struct-usb_device-to-kernel-doc.patch
+gregkh-usb-usb-use-div_round_up.patch
+gregkh-usb-usb-io_tic-remove-unneeded-null-tty-check.patch
+gregkh-usb-usb-partial-usb-embedded-host-support.patch
+gregkh-usb-usb-ehci-remove-obsolete-workaround-for-bogus-irqs.patch
+gregkh-usb-usb-ipaq-fix-devices-having-more-than-one-endpoint.patch
+gregkh-usb-usb-remove-dev-powerpower_state.patch
+gregkh-usb-usb-replace-remaining-__function__-occurrences.patch
+gregkh-usb-usb-remove-unnecessary-type-casting-of-urb-context.patch
+gregkh-usb-usb-s2255drv-fix-memset.patch

 USB tree updates

+usb-add-support-for-motorola-rokr-z6-cellphone-in-mass-storage-mode.patch

 USB fix

+prism54-support-for-124a4025-another-version-of-iogear-gwu513-80211g.patch

 wireless device support

+xfs-replace-remaining-__function__-occurrences.patch
+xfs-replace-__inline-with-inline.patch

 xfs cleanups

+xtensa-remove-redundant-display-of-free-swap-space-in-show_mem.patch

 xtensa cleanup

+char-riscom-fix-rc_board-indexing.patch
+alpha-use-iommu_is_span_boundary-helper-function.patch
+kernel-doc-set-verbose-mode-via-environment.patch
+block-floppy-fix-rmmod-lockup.patch

 2.6.25 material

+romfs-prevent-romfs_lookup-from-always-failing.patch

 Might be 2.6.25, needs update

+gdth-allocate-sense_buffer-to-prevent-null-pointer-dereference.patch
+at73c213-fix-error-checking-for-clk-api.patch
+at73c213-monaural-support.patch
+at73c213-fix-dma-size-at-the-end-of-dma-buffer.patch
+smc91x-fix-build-breakage-from-the-smc_get_mac_addr-api-upgrade.patch
+ioc3-fix-section-missmatch.patch
+forcedeth-limit-tx-to-16.patch
+drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
+acpi-ec-revert-208c70a45624400fafd7511b96bc426bf01f8f5e.patch
+drm-fix-for-non-coherent-dma-powerpc.patch
+#input:
+input-fix-cobalt_btns-loadable-keymap-support.patch
+keep-rd-online-and-cpu_online_map-in-sync.patch

 2.6.25 material

+mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
+mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
+mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
+mempolicy-convert-mpol-constants-to-enum.patch
+mempolicy-support-optional-mode-flags.patch
+mempolicy-add-mpol_f_static_nodes-flag.patch
+mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
+mempolicy-add-mpol_f_relative_nodes-flag.patch
+mempolicy-update-numa-memory-policy-documentation.patch
+mempolicy-move-rebind-functions.patch
+mempolicy-create-mempolicy_operations-structure.patch
+mempolicy-create-mempolicy_operations-structure-fix.patch
+mempolicy-small-header-file-cleanup.patch

 MM updates

+capabilities-implement-per-process-securebits-fix.patch

 Fix capabilities-implement-per-process-securebits.patch some more

+root_plug-use-cap_task_prctl.patch
+smack-use-cap_task_prctl.patch

 USe securebits

+alpha-replace-__inline-with-inline.patch

 alpha cleanup

+power-replace-remaining-__function__-occurrences.patch

 PM cleanup

+m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch

 m68k cleanup

+cris-remove-redundant-display-of-free-swap-space-in-show_mem.patch

 cris cleanup

+kernel-add-clamp-and-clamp_t-macros.patch
+kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
+kernel-add-clamp-and-clamp_t-macros-fix.patch
+firmware-replace-remaining-__function__-occurrences.patch
+drivers-misc-replace-remaining-__function__-occurrences.patch
+ioc3c-replace-remaining-__function__-occurrences.patch
+connector-convert-to-single-threaded-workqueue.patch
+sysrq-add-show-backtrace-on-all-cpus-function.patch
+sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
+sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
+drivers-block-floppyc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

 Misc

+isolate-ratelimit-from-printkc-for-other-use.patch
+isolate-ratelimit-from-printkc-for-other-use-update.patch
+add-warn_on_secs-macro.patch
+use-warn_on_secs-in-rcupreempth.patch

 printk infrastructure

+synclink-drivers-bool-conversion.patch

 synclink cleanup

+uart_get_baud_rate-stop-mangling-termios-fix.patch

 Fix uart_get_baud_rate-stop-mangling-termios.patch

+spi-replace-remaining-__function__-occurrences.patch

 SPI cleanup

+isdn-replace-remaining-__function__-occurrences.patch

 I4L cleanup

+ecryptfs-replace-remaining-__function__-occurrences.patch

 ecryptfs cleanup

+rtc-avoid-legacy-drivers-with-generic-framework-update.patch

 Fix rtc-avoid-legacy-drivers-with-generic-framework.patch

+kerneldoc-for-linux-clkh.patch

 RTC kerneldoc support

+rtc-replace-remaining-__function__-occurrences.patch

 RTC cleanup

+fbmem-fix-con2fbmap-limit-check.patch
+free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
+drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
+radeonfb-use-pci-device-id-in-hex-for-name-string.patch
+radeonfb-fix-debug-option.patch
+radeonfb-drop-redundant-rtrace-macro.patch
+radeonfb-speed-up-the-i2c-buses.patch
+uvesafb-dont-treat-valid-modes-returned-by-fb_find_mode-as-errors.patch
+drivers-video-imsttfbc-add-missing-curly-brackets.patch
+savagefb-speed-up-the-i2c-bus.patch
+fbdev-vt8623fb-better-resume-from-str.patch
+fbdev-framebuffer_alloc-fixes.patch
+pxafb-un-nest-pxafb_parse_options-to-cleanup-the-coding-style-issue.patch
+pxafb-fix-various-coding-style-issues-for-pxafb.patch
+pxafb-purge-unnecessary-pr_debug-and-comments-from-pxafb.patch
+pxafb-sanitize-the-usage-of-ifdef-processing-pxafb-parameters.patch
+pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel.patch
+pxafb-introduce-struct-pxafb_dma_buff-for-palette-and-dma-descriptors.patch
+pxafb-introduce-register-independent-lcd-connection-type-for-pxafb.patch
+pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type.patch
+atmel_lcdfb-dont-initialize-a-pre-allocated-framebuffer.patch
+atmel_lcdfb-suspend-resume-support.patch
+atmel_lcdfb-wiring-bgr-to-rgb-color-mode.patch
+atmel_lcdfb-adjust-fifo-size-for-at91sam9rl.patch
+video-replace-remaining-__function__-occurrences.patch

 fbdev things

+md-replace-remaining-__function__-occurrences.patch

 MD cleanup

+pnp-use-dev_printk-for-quirk-messages.patch

 PNP work

+ext2-replace-remaining-__function__-occurrences.patch

 Ext2 cleanup

+ext3-replace-remaining-__function__-occurrences.patch
+jbd-replace-remaining-__function__-occurrences.patch

 ext3 cleanups

+ufs-replace-remaining-__function__-occurrences.patch
+ufs-remove-unused-fs64_add-and-fs64_sub.patch
+ufs-replace-__inline-with-inline.patch

 UFS work

+reiserfs-replace-remaining-__function__-occurrences.patch

 reiserfs cleanup

+cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods.patch
+cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file.patch
+cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
+cgroup-annotate-cgroup_init_subsys-with-__init.patch
+cgroup-switch-to-proc_create.patch

 cgroups updates

+memory-controller-make-memory-resource-control-aware-of-boot-options.patch

 meory controller feature

+cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch
+cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets.patch

 cpusets work

+signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch
+kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch
+handle_stop_signal-unify-partial-full-stop-handling.patch
+handle_stop_signal-use-the-cached-p-signal-value.patch
+get_signal_to_deliver-use-the-cached-signal-sighand-values.patch
+signals-send_sigqueue-dont-take-rcu-lock.patch
+signals-send_sigqueue-dont-forget-about-handle_stop_signal.patch
+signals-__group_complete_signal-cache-the-value-of-p-signal.patch
+signals-send_group_sigqueue-dont-take-tasklist_lock.patch
+signals-move-handle_stop_signal-into-send_signal.patch
+signals-do_tkill-dont-use-tasklist_lock.patch
+signals-do_tkill-dont-use-tasklist_lock-comment.patch
+signals-send_sig_info-dont-take-tasklist_lock.patch
+signals-microoptimize-the-usage-of-curr_target.patch
+signals-move-the-definition-of-__group_complete_signal-up.patch
+signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter.patch
+signals-use-__group_complete_signal-for-the-specific-signals-too.patch
+signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
+signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
+signals-join-send_sigqueue-with-send_group_sigqueue.patch
+signals-handle_stop_signal-dont-worry-about-sigkill.patch
+signals-send_signal-factor-out-signal_group_exit-checks.patch
+signals-fold-sig_ignored-into-prepare_signal.patch
+signals-document-cld_continued-notification-mechanics.patch
+signals-cleanup-the-usage-of-print_fatal_signal.patch

 A few signal management changes

-ptrace-introduce-ptrace_reparented-helper.patch

 Dropped (I think)

+ptrace-introduce-ptrace_reparented-helper.patch
+ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch

 ptrace updates

+ext4-mm-ext4-make-ext4-xattr-list-static.patch
+ext4-mm-ext4-fix-mount-option-parsing.patch
+ext4-mm-jbd2-fix-the-way-the-b_modified-flag-is-cleared.patch
+ext4-mm-jbd2-fix-possible-journal-overflow-issues.patch
+ext4-mm-ext4-fix-fallocate-error-path.patch
+ext4-mm-ext4-enable-extent-format-for-symlink.patch
+ext4-mm-ext4-fallocate-full-fs-enospc-handling.patch
+ext4-mm-ext4-page-mkwrite.patch
+ext4-mm-ext4-zero-out-small-uninitlaized-extents.patch
-ext4-mm-ext4_page_mkwrite.patch
+ext4-mm-delalloc-ext4-preallocation-handling.patch

 EXT4 tree updates

+jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful.patch
+ext4-replace-remaining-__function__-occurrences.patch
+jdb2-replace-remaining-__function__-occurrences.patch

 ext4 things

+ipc-consolidate-all-xxxctl_down-functions-fix.patch

 Fix ipc-consolidate-all-xxxctl_down-functions.patch

+tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
+tty_ioctl-locking-for-tty_wait_until_sent.patch
+tty_ioctl-soft-carrier-handling.patch

 More tty work

+drivers-char-ip2-ip2mainc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+istallion-tiocg-ssoftcar-handling-removal.patch

 char driver work

+keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch

 Key management feature (needs dhowells ack)

+nbd-allow-nbd-to-be-used-locally.patch

 NBD update

+remove-duplicated-unlikely-in-is_err.patch

 Cleanup

+relay-reset-consumed.patch
+trace-code-and-documentation.patch
+trace-sample.patch

 Simple tracing infrastructure

+drivers-replace-remaining-__function__-occurrences.patch
+afs-replace-remaining-__function__-occurrences.patch
+fs-replace-remaining-__function__-occurrences.patch
+drivers-char-replace-remaining-__function__-occurrences.patch
+serial-replace-remaining-__function__-occurrences.patch

 cleanups

+reiser4-new-export_ops-fixup.patch

 reiser4 fix

+profile-likely-unlikely-macros-fix.patch

 Fix profile-likely-unlikely-macros.patch


3393 commits in 1196 patch files

All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/patch-list


