Return-Path: <linux-kernel-owner+w=401wt.eu-S1763676AbXGYLDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763676AbXGYLDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759370AbXGYLDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:03:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35440 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755639AbXGYLDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:03:18 -0400
Date: Wed, 25 Jul 2007 04:03:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc1-mm1
Message-Id: <20070725040304.111550f4.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/



- New git tree "git-dma": replaces git-md-accel (I think) ("Nelson, Shannon"
  <shannon.nelson@intel.com>)

- New git tree git-e1000new: a new e1000 driver (Auke Kok
  <auke-jan.h.kok@intel.com>).  Source of some controversy.



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



Changes since 2.6.22-rc6-mm1:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-arm-master.patch
 git-audit-master.patch
 git-dma.patch
 git-drm.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ieee1394.patch
 git-input.patch
 git-jg-misc.patch
 git-kbuild.patch
 git-kvm.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-netdev-all.patch
 git-ixgbe.patch
 git-e1000new.patch
 git-battery.patch
 git-ocfs2.patch
 git-r8169.patch
 git-s390.patch
 git-sh.patch
 git-scsi-rc-fixes.patch
 git-scsi-target.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-ipwireless_cs.patch
 git-kgdb.patch

 git trees

-ecryptfs-fix-write-zeros-behavior.patch
-ecryptfs-initialize-crypt_stat-in-setattr.patch
-ecryptfs-zero-out-last-page-for-llseek-write.patch
-atyfb-fix-xclk-frequency-on-apple-ibook1.patch
-eventfd-clean-compile-when-config_eventfd=n.patch
-mtrr-cyrix-fix-sections.patch
-smsc-ircc2-skip-preconfiguration-for-pnp-devices.patch
-pnp-smcf010-quirk-auto-config-device-if-bios-left-it-broken.patch
-mm-kill-validate_anon_vma-to-avoid-mapcount-bug.patch
-fix-kconfig-dependency-problems-wrt-boolean-menuconfigs.patch
-ioatdma-fix-section-mismatches.patch
-alsa-fix-ice1712-section-mismatch.patch
-saa7134-fix-thread-shutdown-handling.patch
-avoid-spurious-pollin-returns-in-signalfd.patch
-fix-section-mismatch-in-chipsfb.patch
-documentation-howto-update-urls-of-git-trees.patch
-alsa-use-__devexit_p.patch
-relay-file-read-start-pos-fixpatch.patch
-relayfs-fix-overwrites.patch
-w1_therm_read_bin-suspicious-usage-of-flush_signals.patch
-mips-jazz-correct-flags-for-timer-io-resource.patch
-add-some-pci-ids-for-xgi-chips.patch
-ext2-fix-return-of-uninitialised-variable.patch
-serial-clear-proper-mpsc-interrupt-cause-bits.patch
-introduce-fixed-sys_sync_file_range2-syscall-implement-on.patch
-slab-remove-warn_on_once-for-zero-sized-objects-for-2622-release.patch
-always-probe-the-nmi-watchdog.patch
-linux-hpet-issue-with-amd-southbridges.patch
-serial-assert-dtr-for-serial-console-devices.patch
-make-common-helpers-for-seq_files-that-work-with-list_head-s.patch
-lots-of-architectures-enable-arbitary-speed-tty-support.patch
-git-acpi-ia64-build-fix.patch
-cpuidle-menu-governor-and-hrtimer-compile-fix.patch
-cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch
-cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch
-cpuidle-menu-governor-change-the-early-break-condition.patch
-cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default.patch
-cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default.patch
-cpuidle-first-round-of-documentation-updates.patch
-git-acpi-tickh-needs-hrtimerh.patch
-git-acpi-add-exports.patch
 exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
-acpi-video-dont-export-sysfs-backlight-interface-if-query-_bcl-fail.patch
-use-menuconfig-objects-acpi.patch
-acpi-do-not-attempt-to-run-s1-standby-workarounds-while-hibernating.patch
-make-drivers-acpi-oslcosi_linux-static.patch
-drivers-acpi-processor_throttlingc-make-2-functions.patch
-drivers-cpuidle-governors-menuc-make-a-struct-static.patch
-fix-empty-macros-in-acpi.patch
-remove-leftover-documentation-of-acpi_generic_hotkey.patch
-cifs-use-simple_prepare_write-to-zero-page-data.patch
-cifs-zero_user_page-conversion.patch
-cifs-use-simple_prepare_write-to-zero-page-data.patch
-git-cpufreq-fix.patch
-bugfix-cpufreq-in-combination-with-performance-governor.patch
-bugfix-cpufreq-in-combination-with-performance-governor-fix.patch
-agk-dm-dm-bio_list-macro-renaming.patch
-agk-dm-dm-bio_list-prefetch-removal.patch
-agk-dm-dm-use-kmem_cache-macro.patch
-agk-dm-dm-delay-cleanup.patch
-agk-dm-dm-remove-duplicate-module-name-from-error-msgs.patch
-agk-dm-dm-use-singlethread-workqueues.patch
-agk-dm-dm-merge-max_hw_sector.patch
-agk-dm-dm-raid1-fix-status.patch
-agk-dm-dm-io-fix-panic-on-large-request.patch
-agk-dm-dm-snapshot-fix-invalidation-deadlock.patch
-agk-dm-dm-snapshot-permit-invalid-activation.patch
-agk-dm-dm-raid1-clear-region-outside-spinlock.patch
-agk-dm-dm-add-ratelimit-logging-macros.patch
-agk-dm-dm-mpath-rdac.patch
-powerpc-ps3-use-__maybe_unused.patch
-powerpc-promc-remove-undef-printk.patch
-8xx-mpc885ads-pcmcia-support.patch
-dts-kill-hardcoded-phandles.patch
-ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
-viotape-use-designated-initializers-for-fops-member.patch
-make-drivers-char-hvc_consoleckhvcd-static.patch
-powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch
-powerpc-tlb_32c-build-fix.patch
-gregkh-driver-sysfs-rules.patch
-gregkh-driver-debugfs-add-rename-for-debugfs-files.patch
-gregkh-driver-dmi-based-module-autoloading.patch
-gregkh-driver-driver-core-add-missing-kset-uevent.patch
-gregkh-driver-sysdev-use-mutex-instead-of-semaphore.patch
-gregkh-driver-power-management-use-mutexes-instead-of-semaphores.patch
-gregkh-driver-pm-remove-pm_parent-from-struct-dev_pm_info.patch
-gregkh-driver-pm-remove-saved_state-from-struct-dev_pm_info.patch
-gregkh-driver-pm-simplify-suspend_device.patch
-gregkh-driver-driver-core-include-linux-mutexh-from-attribute_containerc.patch
-gregkh-driver-driver-core-properly-get-driver-in-device_release_driver.patch
-gregkh-driver-driver-core-fix-kernel-doc-of-device_release_driver.patch
-gregkh-driver-driver-core-fix-devres_release_all-return-value.patch
-gregkh-driver-pm-remove-prev_state-from-struct-dev_pm_info.patch
-gregkh-driver-pm-remove-power_stateevent-checks-from-suspend-core-code.patch
-gregkh-driver-pm-do-not-check-parent-state-in-suspend-and-resume-core-code.patch
-gregkh-driver-howto-translated-into-japanese.patch
-gregkh-driver-add-japanese-translated-stable_api_nonsensetxt.patch
-gregkh-driver-howto-add-chinese-translation-of-documentation-howto.patch
-gregkh-driver-chinese-translation-of-documentation-stable_api_nonsensetxt.patch
-gregkh-driver-uio.patch
-gregkh-driver-uio-documentation.patch
-gregkh-driver-uio-hilscher-cif-card-driver.patch
-gregkh-driver-idr-fix-obscure-bug-in-allocation-path.patch
-gregkh-driver-idr-separate-out-idr_mark_full.patch
-gregkh-driver-ida-implement-idr-based-id-allocator.patch
-gregkh-driver-sysfs-move-release_sysfs_dirent-to-dirc.patch
-gregkh-driver-sysfs-allocate-inode-number-using-ida.patch
-gregkh-driver-sysfs-make-sysfs_put-ignore-null-sd.patch
-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
-gregkh-driver-sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir.patch
-gregkh-driver-sysfs-flatten-and-fix-sysfs_rename_dir-error-handling.patch
-gregkh-driver-sysfs-consolidate-sysfs_dirent-creation-functions.patch
-gregkh-driver-sysfs-add-sysfs_dirent-s_parent.patch
-gregkh-driver-sysfs-add-sysfs_dirent-s_name.patch
-gregkh-driver-sysfs-make-sysfs_dirent-s_element-a-union.patch
-gregkh-driver-sysfs-implement-kobj_sysfs_assoc_lock.patch
-gregkh-driver-sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch
-gregkh-driver-sysfs-implement-bin_buffer.patch
-gregkh-driver-sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect.patch
-gregkh-driver-sysfs-kill-attribute-file-orphaning.patch
-gregkh-driver-sysfs-separate-out-sysfs_attach_dentry.patch
-gregkh-driver-sysfs-reimplement-sysfs_drop_dentry.patch
-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
-gregkh-driver-driver-core-make-devt_attr-and-uevent_attr-static.patch
-gregkh-driver-sysfs-make-sysfs_alloc_ino-static.patch
-gregkh-driver-sysfs-fix-parent-refcounting-during-rename-and-move.patch
-gregkh-driver-sysfs-reorganize-sysfs_new_indoe-and-sysfs_create.patch
-gregkh-driver-sysfs-use-iget_locked-instead-of-new_inode.patch
-gregkh-driver-sysfs-fix-root-sysfs_dirent-root-dentry-association.patch
-gregkh-driver-sysfs-move-s_active-functions-to-fs-sysfs-dirc.patch
-gregkh-driver-sysfs-slim-down-sysfs_dirent-s_active.patch
-gregkh-driver-sysfs-use-singly-linked-list-for-sysfs_dirent-tree.patch
-gregkh-driver-sysfs-fix-oops-in-sysfs_drop_dentry-on-x86_64.patch
-gregkh-driver-sysfs-make-sysfs_drop_dentry-access-inodes-using-ilookup.patch
-gregkh-driver-sysfs-rename-sysfs_dirent-s_type-to-s_flags-and-make-room-for-flags.patch
-gregkh-driver-sysfs-implement-sysfs_flag_removed-flag.patch
-gregkh-driver-sysfs-implement-sysfs_find_dirent-and-sysfs_get_dirent.patch
-gregkh-driver-sysfs-make-kobj-point-to-sysfs_dirent-instead-of-dentry.patch
-gregkh-driver-sysfs-consolidate-sysfs-spinlocks.patch
-gregkh-driver-sysfs-use-sysfs_mutex-to-protect-the-sysfs_dirent-tree.patch
-gregkh-driver-sysfs-restructure-add-remove-paths-and-fix-inode-update.patch
-gregkh-driver-sysfs-move-sysfs_drop_dentry-to-dirc-and-make-it-static.patch
-gregkh-driver-sysfs-implement-sysfs_get_dentry.patch
-gregkh-driver-sysfs-make-directory-dentries-and-inodes-reclaimable.patch
-gregkh-driver-nozomi.patch
-fix-gregkh-driver-nozomi.patch
-driver-core-check-return-code-of-sysfs_create_link.patch
-driver-core-check-return-code-of-sysfs_create_link-fix.patch
-driver-core-coding-style-cleanup.patch
-pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch
-dvb-saa7134-dependency-fix.patch
-jdelvare-i2c-i2c-kerneldoc.patch
-jdelvare-i2c-i2c-rpx-will-be-removed.patch
-jdelvare-i2c-i2c-fix-sparse-warning-in-i2c-h.patch
-jdelvare-i2c-scx200_acb-use-mutex-instead-of-semaphore.patch
-jdelvare-i2c-i2c-delete-outdated-x1205-doc.patch
-jdelvare-i2c-i2c-deprecate-rtc-drivers.patch
-jdelvare-i2c-i2c_smbus_read_i2c_block_data-fixed-prototype.patch
-jdelvare-i2c-i2c-ds1628-new-driver.patch
-jdelvare-i2c-i2c-piix4-add-ati-sb700-support.patch
-jdelvare-i2c-i2c-mv64xxx-numbered-adapter.patch
-jdelvare-i2c-i2c-mpc-numbered-adapter.patch
-jdelvare-i2c-i2c-nforce2-add-smbus-block-transactions.patch
-jdelvare-i2c-video-matroxfb-crtc2-header-fix.patch
-jdelvare-i2c-i2c-sis5595-resolve-resource-conflict.patch
-jdelvare-i2c-i2c-iop3xx-numbered-adapter.patch
-jdelvare-i2c-i2c-gpio-add-support-for-new-style-clients.patch
-jdelvare-i2c-i2c-gpio-make-some-internal-functions-static.patch
-jdelvare-i2c-i2c-pxa-numbered-adapter.patch
-jdelvare-i2c-i2c-tsl2550-support.patch
-jdelvare-i2c-i2c-i801-cleanups.patch
-jdelvare-i2c-i2c-i801-use-block-buffer.patch
-jdelvare-i2c-i2c-taos-evm-new-driver.patch
-jdelvare-i2c-i2c-tsl2550-faster-init.patch
-applesmc-switch-to-using-input-polldev.patch
-ams-switch-to-using-input-polldev.patch
-git-gfs2-nmw-build-fix.patch
-ia64-arbitary-speed-tty-ioctl-support.patch
-use-menuconfig-objects-ii-infiniband.patch
-make-input-layer-use-seq_list_xxx-helpers.patch
-touchscreen-fujitsu-touchscreen-driver.patch
-joydevc-automatic-re-calibration.patch
-input-delete-useless-reference-to-dead-module_parm-macro.patch
-serio_raw_read-warning-fix.patch
-tsdev-fix-broken-usecto-millisecs-conversion.patch
-use-posix-bre-in-headers-install-target.patch
-modpost-white-list-pattern-adjustment.patch
-strip-config_-automatically-in-kernel-configuration-search.patch
-led_colour_show-warning-fix.patch
-libata-config_pm=n-compile-fix.patch
-libata-core-convert-to-use-cancel_rearming_delayed_work.patch
-libata-add-hts541616j9sa00-to-ncq-blacklist.patch
-libata-add-ich8m-pciids-to-ata_piix.patch
-sata_promise-cleanups.patch
-sata_promise-sata-hotplug-support.patch
-libata-add-irq_flags-to-struct-pata_platform_info.patch
-ide-ide-never-called-printk-statement-in-ide-taskfilec-wait_drive_not_busy.patch
-ide-ide-fix-a-theoretical-oops-case.patch
-ide-serverworks-tune-csb6.patch
-ide-ide-make-void-and-rename-ide_dma_lostirq-method.patch
-ide-ide-make-void-and-rename-ide_dma_timeout-method.patch
-ide-ide-use-mutex-instead-of-ide_cfg_sem-semaphore.patch
-ide-hpt366-simplify-ultradma-filtering-take-3.patch
-ide-cmd64x-init-code-cleanup.patch
-ide-aec62xx-rework-init_setup_aec6x80.patch
-ide-aec62xx-remove-init_dma-method-take-2.patch
-ide-ide-use-mutex-instead-of-ide_setting_sem-semaphore.patch
-ide-aec62xx-kill-speedproc-method-wrapper-take-2.patch
-ide-ide_in_drive_list-accept-null-as-the-wildcard-for-firmware-revision.patch
-ide-mips-au1xxx_ide-h-use-null-as-firmware-revision-wildcard.patch
-ide-ide_in_drive_list-all-is-not-a-wildcard-anymore.patch
-ide-idecd-replace-c-code-with-call-to-array_size-macro.patch
-ide-ide-remove-references-to-the-non-existent-config_scsi_eata_dma-variable.patch
-ide-ide-remove-content-related-to-dead-config_blk_dev_mac_mediabay-config-variable.patch
-ide-hd-array-size-calculation-using-sizeof-replaced-with-array_size.patch
-ide-ide-pre-eide-swdma-support-fix.patch
-ide-ide-convert-ide-find-best-mode-users-to-use-ide-max-dma-mode.patch
-ide-ide-add-short-cable-support.patch
-ide-piix-handle-short-cables.patch
-ide-alim15x3-handle-short-cables.patch
-ide-sis5513-handle-short-cables.patch
-ide-via82cxxx-handle-short-cables.patch
-ide-unexport-ide_set_dma.patch
-ide-ide-stop-mapping-roms.patch
-ide_scan_pcibus-cehck-__pci_register_driver-return-value.patch
-mips-make-resources-for-ds1742-static-__initdata.patch
-mmc-at91_mci-typo.patch
-nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
-romfs-printk-format-warnings.patch
-drivers-mtd-maps-nettelc-possible-cleanups.patch
-use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
-use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
-mtd-use-null-for-pointer.patch
-cafe_nandc-the-olpc-laptop-is-not-available-for-100.patch
-blackfin-on-chip-ethernet-mac-controller-driver.patch
-atari_pamsnetc-old-declaration-ritchie-style-fix.patch
-sundance-phy-address-form-0-only-for-device-id-0x0200-fix.patch
-use-is_power_of_2-in-cxgb3-cxgb3_mainc.patch
-use-is_power_of_2-in-myri10ge-myri10gec.patch
-#extract-chip-specific-code-out-of-lasi_82596c.patch: busted
-extract-chip-specific-code-out-of-lasi_82596c.patch
-extract-chip-specific-code-out-of-lasi_82596c-update.patch
-ethernet-driver-for-eisa-only-sni-rm200-rm400-machines.patch
-ethernet-driver-for-eisa-only-sni-rm200-rm400-machines-update.patch
-ehea-whitespace-cleanup.patch
-make-atm-driver-use-seq_list_xxx-helpers.patch
-make-some-network-related-proc-files-use-seq_list_xxx.patch
-make-some-netfilter-related-proc-files-use-seq_list_xxx.patch
-wrong-timeout-value-in-sk_wait_data-v2-fix.patch
-netpoll-tx-lock-deadlock-fix.patch
-tun-tap-allow-group-ownership-of-tun-tap-devices.patch
-git-battery-vs-git-acpi.patch
-bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
-git-ioat-vs-git-md-accel.patch
-ioat-warning-fix.patch
-fix-i-oat-for-kexec.patch
-auth_gss-unregister-gss_domain-when-unloading-module.patch
-nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
-git-selinux-disable-mmap_min_addr-by-default.patch
-gregkh-pci-pci-remove-cpqphp-maintainer.patch
-gregkh-pci-pci-fix-the-error-message-to-point-to-the-proper-person.patch
-gregkh-pci-pci-syscallc-switch-to-refcounting-api.patch
-gregkh-pci-pci-add-pci-x-pci-express-read-control-interfaces.patch
-gregkh-pci-pci-use-a-weak-symbol-for-the-empty-version-of-pcibios_add_platform_entries.patch
-gregkh-pci-pci-make-pcibios_add_platform_entries-return-errors.patch
-gregkh-pci-pci-pci_find_slot-mark-deprecated.patch
-gregkh-pci-pciehp-fix-possible-race-condition-in-writing-slot.patch
-gregkh-pci-pciehp-wait-for-1-second-after-power-off-slot.patch
-gregkh-pci-pci-fix-aer-driver-error-information.patch
-gregkh-pci-pci-aer-fix-stub-return-values.patch
-gregkh-pci-pci-aer-add-pci_cleanup_aer_correct_aer_status.patch
-gregkh-pci-pci-unexport-pci_proc_attach_device.patch
-gregkh-pci-pci-remove-useless-pci-driver-method.patch
-gregkh-pci-pci-read-revision-id-by-default.patch
-gregkh-pci-pci-atm-lanai-change-vendor-to-device.patch
-gregkh-pci-pci-i386-traps-change-vendor-to-device.patch
-gregkh-pci-pci-pci_ids-reorder-some-entries.patch
-gregkh-pci-pci-pci_ids-add-atheros-and-3com_2-vendors.patch
-gregkh-pci-pci-pci_ids-remove-double-or-more-empty-lines.patch
-fix-gregkh-pci-pci-syscallc-switch-to-refcounting-api.patch
-pci-x-pci-express-read-control-interfaces-fix.patch
-remove-pci_dac_dma_-apis.patch
-round_up-macro-cleanup-in-drivers-pci.patch
-pcie-remove-spin_lock_unlocked.patch
-add-pci_try_set_mwi.patch
-cpci_hotplug-convert-to-use-the-kthread-api.patch
-pci_set_power_state-check-for-pm-capabilities-earlier.patch
-revert-acpi-change-for-scsi.patch
-git-scsi-misc.patch
-restore-acpi-change-for-scsi.patch
-git-scsi-misc-vs-greg-sysfs-stuff.patch
-scsi-dont-build-scsi_dma_mapunmap-for-has_dma.patch
-scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
-drivers-scsi-small-cleanups.patch
-sym53c8xx_2-claims-cpqarray-device.patch
-drivers-scsi-wd33c93c-cleanups.patch
-make-seagate_st0x_detect-static.patch
-drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch
-drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc.patch
-use-menuconfig-objects-ii-scsi.patch
-use-menuconfig-objects-ii-scsi-fix.patch
-ppa-coding-police-and-printk-levels.patch
-remove-the-dead-cyberstormiii_scsi-option.patch
-use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
-use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
-add-support-for-xilinx-systemace-compactflash-interface.patch
-use-menuconfig-objects-oldcd.patch
-use-menuconfig-objects-block-layer.patch
-use-menuconfig-objects-ib-block.patch
-use-menuconfig-objects-ii-block-devices.patch
-use-menuconfig-objects-ii-block-devices-fix.patch
-block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch
-update-documentation-block-barriertxt.patch
-block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio.patch
-cdrom_sysctl_info-fix.patch
-gregkh-usb-usb-suspend-support-for-usb-serial.patch
-gregkh-usb-usb-ehci-cpufreq-fix.patch
-gregkh-usb-usb-ehci-support-for-big-endian-descriptors.patch
-gregkh-usb-usb-cxacru-cleanup-sysfs-attribute-code.patch
-gregkh-usb-usb-serial-keyspan-add-support-for-usa-49wg-usa-28xg.patch
-gregkh-usb-usb-m66592-udc-peripheral-controller-driver-for-m66592.patch
-gregkh-usb-usb-m66592-udc-fix-use-old-interrupt-flags.patch
-gregkh-usb-usb-r8a66597-hcd-host-controller-driver-for-r8a66597.patch
-gregkh-usb-usb-r8a66597-hcd-fix-null-access.patch
-gregkh-usb-usb-interface-pm-state.patch
-gregkh-usb-usb-implement-pm-freeze-and-prethaw.patch
-gregkh-usb-usb-move-bus_suspend-and-bus_resume-method-calls.patch
-gregkh-usb-usb-don-t-unsuspend-for-a-new-connection.patch
-gregkh-usb-usb-remove-references-to-devpowerpower_state.patch
-gregkh-usb-usb-remove-locktree-routine-from-the-hub-driver.patch
-gregkh-usb-usb-make-hub-driver-s-release-more-robust.patch
-gregkh-usb-usb-use-menuconfig-objects.patch
-gregkh-usb-usb-ehci-refcounts-work-on-ppc7448.patch
-gregkh-usb-usb-oti6858-usb-serial-driver.patch
-gregkh-usb-usbmon-add-class-for-binary-interface.patch
-gregkh-usb-usb-add-usb-persist-facility.patch
-gregkh-usb-usb-ehci-ohci-handover-changes.patch
-gregkh-usb-usb-add-reset_resume-device-quirk.patch
-gregkh-usb-usb-ehci-fix-handover-for-designated-full-speed-ports.patch
-gregkh-usb-usb-make-device-reset-stop-retrying-after-disconnect.patch
-gregkh-usb-usb-io_ti-digi-edgeport-update-for-new-devices.patch
-gregkh-usb-usb-patch-to-align-the-various-usb-timers-to-fire-at-the-same-time.patch
-gregkh-usb-usb-rts-cts-handshaking-support-dtr-fixes-for-mct-u232-serial-adapter.patch
-gregkh-usb-usb-usb-gadget-dead-config-cleanup.patch
-gregkh-usb-usb-add-usb_device_and_interface_info-for-device-matching.patch
-gregkh-usb-usb-hubc-loops-forever-on-resume-from-ram-due-to-bluetooth.patch
-gregkh-usb-usb-prevent-char-device-open-deregister-race.patch
-gregkh-usb-usb-rework-c-style-comments.patch
-gregkh-usb-usb-ftdi_sioc-allow-setting-latency-timer-on-ft232rl.patch
-gregkh-usb-usb-ehci-big-endian-data-structures-support.patch
-gregkh-usb-usb-set-config_usb_ehci_big_endian_mmio-_desc-in-usb-host-kconfig.patch
-gregkh-usb-usb-ehci_fsl-update-for-mpc831x-support.patch
-gregkh-usb-usb-use-function-attribute-__maybe_unused.patch
-gregkh-usb-usb-export-linux-usb_gadgetfs-as-linux-usb-gadgetfsh.patch
-gregkh-usb-usb-visor-driver-adapted-to-new-tty-buffering.patch
-gregkh-usb-usb-digi-acceleport-adapted-to-new-tty-buffering.patch
-gregkh-usb-usb-generic-usb-serial-to-new-buffering-scheme.patch
-gregkh-usb-pl2303c-patch.patch
-gregkh-usb-usb-usb-serial-gadget-sparse-fixes.patch
-gregkh-usb-usb-core-hubc-prevent-re-enumeration-on-hnp.patch
-gregkh-usb-usb-introduce-usb_anchor.patch
-gregkh-usb-usb-usb-skeleton-use-anchor-to-implement-flush.patch
-gregkh-usb-usb-whiteheat-driver-update.patch
-gregkh-usb-usb-digi_acceleport-further-buffer-clean-up.patch
-gregkh-usb-usb-ehci-safe-endianness-for-transfer-buffers-after-reset-in-case-of-hub-with-tt.patch
-gregkh-usb-usb-disable-file_storage-usb_config_att_wakeup.patch
-gregkh-usb-usb-fix-nec-ohci-chip-silicon-bug.patch
-gregkh-usb-usb-remove-__usb_port_suspend.patch
-gregkh-usb-usb-separate-root-and-non-root-suspend-resume.patch
-gregkh-usb-usb-remove-excess-code-from-hubc.patch
-gregkh-usb-usb-add-reset_resume-method.patch
-gregkh-usb-usb-unify-reset_resume-and-normal-resume.patch
-gregkh-usb-usb-add-power-persist-device-attribute.patch
-gregkh-usb-usb-fsl_usb2_udc-replace-deprecated-irq-flag.patch
-gregkh-usb-usb-fsl_usb2_udc-get-max-ep-number-from-dccparams-register.patch
-gregkh-usb-usb-option-fix-usage-of-urb-status-abuse.patch
-gregkh-usb-usb-ps3-usb-system-bus-rework.patch
-gregkh-usb-usb-gadget-driver-for-samsung-s3c2410-arm-soc.patch
-gregkh-usb-usb-usb-storage-use-kthread_stop-for-the-control-thread.patch
-gregkh-usb-usb-usb-host-side-can-be-configured-given-pcmcia.patch
-gregkh-usb-ehci-hub-improved-over-current-recovery.patch
-gregkh-usb-usb-io_ti-sleep-with-spinlock-held-detected-by-automatic-tool.patch
-gregkh-usb-usb-fix-usb_serial_put-synchronization.patch
-gregkh-usb-usb-handle-bogus-low-speed-bulk-endpoints.patch
-gregkh-usb-usb-free-dma-mappings-if-enqueue-fails.patch
-gregkh-usb-usb-serial-license-fix.patch
-gregkh-usb-usb-aircable-status.patch
-gregkh-usb-usb-airprime-status.patch
-gregkh-usb-usb-belkin_sa-status.patch
-gregkh-usb-usb-cyberjack-status.patch
-gregkh-usb-usb-cypress_m8-status.patch
-gregkh-usb-usb-digi_acceleport-status.patch
-gregkh-usb-usb-empeg-status.patch
-gregkh-usb-usb-ftdi_sio-status.patch
-gregkh-usb-usb-garmin_gps-status.patch
-gregkh-usb-usb-generic-status.patch
-gregkh-usb-usb-io_edgeport-status.patch
-gregkh-usb-usb-io_ti-status.patch
-gregkh-usb-usb-ipaq-status.patch
-gregkh-usb-usb-ipw-status.patch
-gregkh-usb-usb-ir-usb-status.patch
-gregkh-usb-usb-keyspan-status.patch
-gregkh-usb-usb-keyspan_pda-status.patch
-gregkh-usb-usb-kl5kusb105-status.patch
-gregkh-usb-usb-kobil_sct-status.patch
-gregkh-usb-usb-mct_u232-status.patch
-gregkh-usb-usb-mos7720-status.patch
-gregkh-usb-usb-mos7840-status.patch
-gregkh-usb-usb-navman-status.patch
-gregkh-usb-usb-omninet-status.patch
-gregkh-usb-usb-option-status.patch
-gregkh-usb-usb-oti6858-status.patch
-gregkh-usb-usb-pl2303-status.patch
-gregkh-usb-usb-safe_serial-status.patch
-gregkh-usb-usb-sierra-status.patch
-gregkh-usb-usb-ti_usb_3410_5052-status.patch
-gregkh-usb-usb-visor-status.patch
-gregkh-usb-usb-whiteheat-status.patch
-gregkh-usb-usb-sierra-fix-status-usage.patch
-gregkh-usb-usb-sierra-cleanup-urb-startup.patch
-gregkh-usb-usb-serial-ark3116c-mixed-fixups.patch
-gregkh-usb-usb-serial-belkin_sa-various-needed-fixes.patch
-gregkh-usb-usb-serial-ir_usb-clean-up-the-worst-of-it-remove-exciting-crash-on-open-feature.patch
-gregkh-usb-usb-usb-skeleton-use-anchors-in-disconnect-handling.patch
-gregkh-usb-usb-usb-skeleton-use-anchors-in-suspend-resume-handling.patch
-gregkh-usb-usb-usb-skeleton-use-anchors-in-pre-post-reset.patch
-gregkh-usb-usb-fix-up-full-speed-binterval-values-in-high-speed-interrupt-descriptor.patch
-gregkh-usb-usb-add-urb_free_buffer-flag-and-the-logic-behind-it.patch
-gregkh-usb-usb-gadget-rename-husb2dev-usba.patch
-gregkh-usb-usb-autosuspend-for-usblcd.patch
-gregkh-usb-usb-fsl_usb2_udc-fix-bug-for-portsc-bit-masking.patch
-gregkh-usb-usb-pete-s-taking-over-usblp.patch
-gregkh-usb-usb-usblp-add-dynamic-urbs-fix-races.patch
-gregkh-usb-usb-remove-usages-of-dev-powerpower_state.patch
-gregkh-usb-usb-don-t-resume-root-hub-if-the-controller-is-suspended.patch
-gregkh-usb-usb-fix-off-by-1-error-in-the-scatter-gather-library.patch
-gregkh-usb-usb-mos7720-developer-change.patch
-gregkh-usb-usb-add-iad-support-to-usbfs-and-sysfs.patch
-gregkh-usb-usb-support-blackberry-pearl-with-berry_charge.patch
-gregkh-usb-don-t-autosuspend-blackberry-devices.patch
-gregkh-usb-usb-add-printer-gadget-driver.patch
-fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
-fix-gregkh-usb-usb-use-menuconfig-objects.patch
-make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
-drivers-block-ubc-use-list_for_each_entry.patch
-use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
-x86_64-mm-bug-in-i386-mtrr-initialization.patch
-x86_64-mm-cpa-cache-flush.patch
-x86_64-mm-stack-align.patch
-x86_64-mm-asm-ptrace_h-needs-linux-compiler_h.patch
-x86_64-mm-apic-id.patch
-x86_64-mm-irq-migrate-report.patch
-x86_64-mm-define-and-use-local_distance-and-remote_distance.patch
-x86_64-mm-acpi-various-cleanups.patch
-x86_64-mm-fam10-string.patch
-x86_64-mm-gcc43-memcpy.patch
-x86_64-mm-gcc-hot-cold.patch
-x86_64-mm-remove-size-of-apicid_to_node-from-header.patch
-x86_64-mm-unwinder.patch
-x86_64-mm-vdso.patch
-x86_64-mm-tsc-unstable.patch
-x86_64-mm-on-cpu-single.patch
-x86_64-mm-sched-clock-share.patch
-x86_64-mm-sched-clock64.patch
-x86_64-mm-paravirt-add-a-sched_clock-paravirt_op.patch
-x86_64-mm-verify-cpu-rename.patch
-x86_64-mm-xencleanup-use-elfnote_h-to-generate-vsyscall-notes.patch
-x86_64-mm-xencleanup-add-kstrndup.patch
-x86_64-mm-xencleanup-add-argv_split.patch
-x86_64-mm-xencleanup-split-usermodehelper-setup-from-execution.patch
-x86_64-mm-add-common-orderly_poweroff.patch
-x86_64-mm-xencleanup-tidy-up-usermode-helper-waiting-a-bit.patch
-x86_64-mm-xen-add-an-mm-argument-to-alloc_pt.patch
-x86_64-mm-xen-add-a-hook-for-once-the-allocator-is-ready.patch
-x86_64-mm-xen-increase-irq-limit.patch
-x86_64-mm-xen-unstatic-leave_mm.patch
-x86_64-mm-xen-unstatic-smp_store_cpu_info.patch
-x86_64-mm-xen-make-siblingmap-functions-visible.patch
-x86_64-mm-xen-export-__supported_pte_mask.patch
-x86_64-mm-xen-allocate-and-free-vmalloc-areas.patch
-x86_64-mm-xen-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
-x86_64-mm-xen-add-xen-interface-header-files.patch
-x86_64-mm-xen-core-xen-implementation.patch
-x86_64-mm-xen-xen-virtual-mmu.patch
-x86_64-mm-xen-xen-event-channels.patch
-x86_64-mm-xen-xen-time-implementation.patch
-x86_64-mm-xen-xen-configuration.patch
-x86_64-mm-xen-add-pinned-page-flag.patch
-x86_64-mm-xen-complete-pagetable-pinning-for-xen.patch
-x86_64-mm-xen-ignore-rw-mapping-of-ro-pages-in-pagetable_init.patch
-x86_64-mm-xen-account-for-time-stolen-by-xen.patch
-x86_64-mm-xen-implement-xen_sched_clock.patch
-x86_64-mm-xen-xen-smp-guest-support.patch
-x86_64-mm-xen-add-support-for-preemption.patch
-x86_64-mm-xen-lazy-mmu-operations.patch
-x86_64-mm-xen-hack-to-prevent-bad-segment-register-reload.patch
-x86_64-mm-xen-use-the-hvc-console-infrastructure-for-xen-console.patch
-x86_64-mm-xen-add-xen-grant-table-support.patch
-x86_64-mm-xen-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
-x86_64-mm-xen-add-the-xen-virtual-network-device-driver.patch
-x86_64-mm-xen-xen-machine-operations.patch
-x86_64-mm-xen-handle-external-requests-for-shutdown-reboot-and-sysrq.patch
-x86_64-mm-xen-place-vcpu_info-structure-into-per-cpu-memory-if-possible.patch
-x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
-x86_64-mm-paravirt-helper-to-disable-all-io-space.patch
-x86_64-mm-xen-use-iret-directly-where-possible.patch
-x86_64-mm-xen-xen_start_kernel-is-__init-so-startup_xen-should-be-too.patch
-x86_64-mm-xen-disable-all-non-virtual-devices.patch
-x86_64-mm-fam10-l3cache.patch
-x86_64-mm-use-null-for-pointer.patch
-x86_64-mm-remove-extra-extern-declaring-dmi_ioremap.patch
-x86_64-mm-smp-call-no-bh.patch
-revert-x86_64-mm-verify-cpu-rename.patch
-add-kstrndup-fix.patch
-xen-build-fix.patch
-fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
-fix-x86_64-mm-xen-xen-smp-guest-support.patch
-more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
-fix-x86_64-mm-sched-clock-share.patch
-fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
-fix-x86_64-mm-add-common-orderly_poweroff.patch
-tidy-up-usermode-helper-waiting-a-bit-fix.patch
-update-x86_64-mm-xen-use-iret-directly-where-possible.patch
-i386-add-support-for-picopower-irq-router.patch
-make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
-arch-i386-kernel-i8253c-should-include-asm-timerh.patch
-make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
-quicklist-support-for-x86_64.patch
-x86_64-extract-helper-function-from-e820_register_active_regions.patch
-x86_64-fix-e820_hole_size-based-on-address-ranges.patch
-x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
-x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch
-x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
-x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
-mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
-x86_64-fix-smp_call_function_single-return-value.patch
-x86_64-o_excl-on-dev-mcelog.patch
-x86_64-support-poll-on-dev-mcelog.patch
-x86_64-mcelog-tolerant-level-cleanup.patch
-i386-fix-machine-rebooting.patch
-x86-fix-section-mismatch-warnings-in-mtrr.patch
-x86_64-ratelimit-segfault-reporting-rate.patch
-x86_64-pm_trace-support.patch
-make-alt-sysrq-p-display-the-debug-register-contents.patch
-i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
-round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
-pci-disable-decode-of-io-memory-during-bar-sizing.patch
-mmconfig-validate-against-acpi-motherboard-resources.patch
-mmconfig-validate-against-acpi-motherboard-resources-fix.patch
-mmconfig-validate-against-acpi-motherboard-resources-fix-2.patch
-mmconfig-validate-against-acpi-motherboard-resources-fix-3.patch
-mmconfig-validate-against-acpi-motherboard-resources-fix-2-3.patch
-x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
-i386-remove-support-for-the-rise-cpu.patch
-x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch
-x86-64-calgary-update-copyright-notice.patch
-x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch
-x86-64-calgary-introduce-chipset-specific-ops.patch
-x86-64-calgary-introduce-chipset-specific-ops-fix.patch
-x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch
-x86-64-calgary-introduce-calioc2-support.patch
-x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
-x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
-x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch
-x86-64-calgary-make-dump_error_regs-a-chip-op.patch
-x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch
-x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
-x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
-x86-64-calgary-cleanup-of-unneeded-macros.patch
-x86-64-calgary-tabify-and-trim-trailing-whitespace.patch
-x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch
-x86-64-calgary-tidy-up-debug-printks.patch
-i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
-i386-fix-section-mismatch-warning-in-intel_cacheinfo.patch
-i386-do-not-restore-reserved-memory-after-hibernation.patch
-i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
-paravirt-helper-to-disable-all-io-space-fix.patch
-paravirt-helper-to-disable-all-io-space-fix-2.patch
-paravirt-helper-to-disable-all-io-space-fix-3.patch
-dmi_match-patch-in-rebootc-for-sff-dell-optiplex-745-fixes-hang.patch
-i386-hpet-check-if-the-counter-works.patch
-i386-trim-memory-not-covered-by-wb-mtrrs.patch
-i386-trim-memory-not-covered-by-wb-mtrrs-fix.patch
-kprobes-x86_64-fix-for-mark-ro-data.patch
-kprobes-i386-fix-for-mark-ro-data.patch
-divorce-config_x86_pae-from-config_highmem64g.patch
-remove-unneeded-test-of-task-in-dump_trace.patch
-i386-move-the-kernel-to-16mb-for-numa-q.patch
-i386-show-unhandled-signals.patch
-i386-show-unhandled-signals-fix.patch
-i386-minor-nx-handling-adjustment.patch
-i386-minor-nx-handling-adjustment-fix.patch
-x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch
-x86-64-remove-unused-variable-maxcpus.patch
-move-functions-declarations-to-header-file.patch
-x86_64-during-vm-oom-condition.patch
-i386-during-vm-oom-condition.patch
-x86-64-disable-the-gart-in-shutdown.patch
-x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
-x86_84-move-iommu-declaration-from-proto-to-iommuh-fix.patch
-i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
-i386-add-cpu_relax-to-cmos_lock.patch
-i386-add-cpu_relax-to-cmos_lock-fix.patch
-x86_64-flush_tlb_kernel_range-warning-fix.patch
-x86_64-add-ioapic-nmi-support.patch
-x86_64-add-ioapic-nmi-support-fix.patch
-x86_64-add-ioapic-nmi-support-fix-2.patch
-x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
-x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
-reserve-the-right-performance-counter-for-the-intel-perfmon-nmi-watchdog.patch
-fix-xfs_ioc_fsgeometry_v1-in-compat-mode.patch
-fix-xfs_ioc__to_handle-and-xfs_ioc_openreadlink_by_handle-in-compat-mode.patch
-fix-xfs_ioc_fsbulkstat_single-and-xfs_ioc_fsinumbers-in-compat-mode.patch
-xfs-warning-fix.patch
-kgdb-warning-fix.patch
-kgdb-kconfig-fix.patch
-kgdb-use-new-style-interrupt-flags.patch
-kgdb-section-fix.patch
-kgdb_skipexception-warning-fix.patch
-kgdb-ia64-fixes.patch
-kgdb-bust-on-ia64.patch
-irda-fix-printk-format.patch
-netconsole-fix-soft-lockup-when-removing-module.patch
-gen_estimator-fix-locking-and-timer-related-bugs.patch
-console-more-buf-for-index-parsing.patch
-console-console-handover-to-preferred-console.patch
-x86-initial-fixmap-support.patch
-serial-convert-early_uart-to-earlycon-for-8250.patch
-serial-convert-early_uart-to-earlycon-for-8250-fix.patch
-serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch
-serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias.patch
-change-zonelist-order-zonelist-order-selection-logic.patch
-change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
-change-zonelist-order-v6-zonelist-fix.patch
-change-zonelist-order-v6-zonelist-fix-2.patch
-change-zonelist-order-auto-configuration.patch
-change-zonelist-order-documentaion.patch
-hugetlb-remove-unnecessary-nid-initialization.patch
-mm-use-div_round_up-in-mm-memoryc.patch
-make-proc-slabinfo-use-seq_list_xxx-helpers.patch
-make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch
-mm-alloc_large_system_hash-can-free-some-memory-for.patch
-remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
-slob-rework-freelist-handling.patch
-slob-remove-bigblock-tracking.patch
-slob-improved-alignment-handling.patch
-vmscan-fix-comments-related-to-shrink_list.patch
-mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
-mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
-mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
-mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
-mm-merge-nopfn-into-fault.patch
-mm-merge-nopfn-into-fault-spufs-fix.patch
-convert-hugetlbfs-to-use-vm_ops-fault.patch
-mm-remove-legacy-cruft.patch
-mm-debug-check-for-the-fault-vs-invalidate-race.patch
-mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
-invalidate_mapping_pages-add-cond_resched.patch
-ocfs2-release-page-lock-before-calling-page_mkwrite.patch
-document-page_mkwrite-locking.patch
-slub-support-slub_debug-on-by-default.patch
-slub-support-slub_debug-on-by-default-tidy.patch
-numa-mempolicy-dynamic-interleave-map-for-system-init.patch
-oom-stop-allocating-user-memory-if-tif_memdie-is-set.patch
-numa-mempolicy-trivial-debug-fixes.patch
-mm-fix-improper-init-type-section-references.patch
-page-table-handling-cleanup.patch
-kill-vmalloc_earlyreserve.patch
-mm-more-__meminit-annotations.patch
-mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
-madvise_need_mmap_write-usage.patch
-slob-initial-numa-support.patch
-fix-read-truncate-race.patch
-make-sure-readv-stops-reading-when-it-hits-end-of-file.patch
-remove-alloc_zeroed_user_highpage.patch
-create-the-zone_movable-zone.patch
-create-the-zone_movable-zone-fix.patch
-create-the-zone_movable-zone-fix-2.patch
-allow-huge-page-allocations-to-use-gfp_high_movable.patch
-allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
-allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
-allow-huge-page-allocations-to-use-gfp_high_movable-fix-3.patch
-handle-kernelcore=-generic.patch
-handle-kernelcore=-generic-fix.patch
-lumpy-reclaim-v4.patch
-lumpy-move-to-using-pfn_valid_within.patch
-have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
-have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
-only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
-mm-clean-up-and-kernelify-shrinker-registration.patch
-mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch
-split-mmap.patch
-only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
-mm-document-fault_data-and-flags.patch
-slub-mm-only-make-slub-the-default-slab-allocator.patch
-slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
-slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
-slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
-slub-remove-useless-export_symbol.patch
-slub-use-list_for_each_entry-for-loops-over-all-slabs.patch
-slub-slab-validation-move-tracking-information-alloc-outside-of.patch
-slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch
-slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects.patch
-slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch
-slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch
-slab-allocators-support-__gfp_zero-in-all-allocators.patch
-slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch
-slub-extract-dma_kmalloc_cache-from-get_cache.patch
-slub-do-proper-locking-during-dma-slab-creation.patch
-slub-faster-more-efficient-slab-determination-for-__kmalloc.patch
-slub-faster-more-efficient-slab-determination-for-__kmalloc-fix.patch
-slub-faster-more-efficient-slab-determination-for-__kmalloc-fix-2.patch
-slub-simplify-dma-index-size-calculation.patch
-add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch
-fs-introduce-some-page-buffer-invariants.patch
-nfs-invariant-fix.patch
-fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
-freezer-make-kernel-threads-nonfreezable-by-default.patch
-freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
-freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
-freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
-nommu-stub-expand_stack-for-nommu-case.patch
-m68knommu-use-trhead_size-instead-of-hard-constant.patch
-m68knommu-remove-cruft-from-setup-code.patch
-m68knommu-remove-old-cache-management-cruft-from-mm-code.patch
-h8300-enable-arbitary-speed-tty-port-setup.patch
-h8300-zimage-support-update.patch
-alpha-fix-trivial-section-mismatch-warnings.patch
-fix-alpha-isa-support.patch
-fix-alpha-isa-support-fix.patch
-arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
-arm26-remove-broken-and-unused-macro.patch
-freezer-run-show_state-when-freezing-times-out.patch
-pm-do-not-require-dev-spew-to-get-pm_debug.patch
-swsusp-remove-incorrect-code-from-userc.patch
-swsusp-remove-code-duplication-between-diskc-and-userc.patch
-swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
-swsusp-introduce-restore-platform-operations.patch
-swsusp-fix-hibernation-code-ordering.patch
-hibernation-prepare-to-enter-the-low-power-state.patch
-freezer-avoid-freezing-kernel-threads-prematurely.patch
-freezer-use-__set_current_state-in-refrigerator.patch
-freezer-return-int-from-freeze_processes.patch
-freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
-pm-introduce-hibernation-and-suspend-notifiers.patch
-pm-introduce-hibernation-and-suspend-notifiers-fix.patch
-pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
-pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
-pm-disable-usermode-helper-before-hibernation-and-suspend.patch
-pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
-pm-reduce-code-duplication-between-mainc-and-userc.patch
-pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
-m32r-enable-arbitary-speed-tty-rate-setting.patch
-etrax-enable-arbitary-speed-setting-on-tty-ports.patch
-cris-replace-old-style-member-inits-with-designated-inits.patch
-uml-fix-request-sector-update.patch
-uml-use-get_free_pages-to-allocate-kernel-stacks.patch
-add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
-uml-debug_shirq-fixes.patch
-uml-xterm-driver-tidying.patch
-uml-pty-channel-tidying.patch
-uml-handle-errors-on-opening-host-side-of-consoles.patch
-uml-sigio-support-cleanup.patch
-uml-simplify-helper-stack-handling.patch
-uml-eliminate-kernel-allocator-wrappers.patch
-v850-enable-arbitary-speed-tty-ioctls.patch
-fix-rmmod-read-write-races-in-proc-entries.patch
-fix-rmmod-read-write-races-in-proc-entries-cleanup.patch
-fix-rmmod-read-write-races-in-proc-entries-fix.patch
-more-scheduled-oss-driver-removal.patch
-introduce-write_trylock_irqsave.patch
-use-write_trylock_irqsave-in-ptrace_attach.patch
-use-write_trylock_irqsave-in-ptrace_attach-fix.patch
-use-menuconfig-objects-ii-auxdisplay.patch
-use-menuconfig-objects-ii-auxdisplay-fix.patch
-use-menuconfig-objects-ii-edac.patch
-use-menuconfig-objects-ii-ipmi.patch
-use-menuconfig-objects-ii-misc-strange-dev.patch
-use-menuconfig-objects-ii-misc-strange-dev-fix.patch
-use-menuconfig-objects-ii-module-menu.patch
-use-menuconfig-objects-ii-oprofile.patch
-use-menuconfig-objects-ii-oprofile-fix.patch
-use-menuconfig-objects-ii-telephony.patch
-use-menuconfig-objects-ii-tpm.patch
-use-menuconfig-objects-connector.patch
-use-menuconfig-objects-crypto-hw.patch
-use-menuconfig-objects-crypto-hw-fix.patch
-use-menuconfig-objects-i2o.patch
-use-menuconfig-objects-parport.patch
-use-menuconfig-objects-pnp.patch
-use-menuconfig-objects-w1.patch
-fix-jvc-cdrom-drive-lockup.patch
-use-no_pci_devices-in-pci-searchc.patch
-introduce-boot-based-time.patch
-introduce-boot-based-time-fix.patch
-use-boot-based-time-for-process-start-time-and-boot-time.patch
-use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
-use-boot-based-time-for-process-start-time-and-boot-time-fix-2.patch
-use-boot-based-time-for-process-start-time-and-boot-time-fix-3.patch
-use-boot-based-time-for-uptime-in-proc.patch
-udf-check-for-allocated-memory-for-data-of-new-inodes.patch
-udf-check-for-allocated-memory-for-data-of-new-inodes-fix.patch
-add-argv_split-fix.patch
-add-common-orderly_poweroff-fix.patch
-prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by.patch
-udf-check-for-allocated-memory-for-inode-data-v2.patch
-fix-stop_machine_run-problem-with-naughty-real-time-process.patch
-cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
-cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
-use-mutexes-instead-of-semaphores-in-i2o-driver.patch
-fuse-warning-fix.patch
-vxfs-warning-fixes.patch
-percpu_counters-use-cpu-notifiers.patch
-percpu_counters-use-for_each_online_cpu.patch
-make-afs-use-seq_list_xxx-helpers.patch
-make-crypto-api-use-seq_list_xxx-helpers.patch
-make-proc-misc-use-seq_list_xxx-helpers.patch
-make-proc-modules-use-seq_list_xxx-helpers.patch
-make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
-make-proc-self-mountstats-use-seq_list_xxx-helpers.patch
-make-nfs-client-use-seq_list_xxx-helpers.patch
-fat-gcc-43-warning-fix.patch
-remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
-drivers-block-z2ram-remove-true-false-defines.patch
-fix-compiler-warnings-in-acornc.patch
-update-zilog-timeout.patch
-edd-switch-to-pci_get-based-api.patch
-fix-up-codingstyle-in-isofs.patch
-define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
-mpu401-warning-fixes.patch
-introduce-config_virt_to_bus.patch
-pie-randomization.patch
 remove-unused-tif_notify_resume-flag.patch
-rocketc-fix-unchecked-mutex_lock_interruptible.patch
-only-send-sigxfsz-when-exceeding-rlimits.patch
-procfs-directory-entry-cleanup.patch
-procfs-directory-entry-cleanup-fix.patch
-8xx-fix-whitespace-and-indentation.patch
-vdso-print-fatal-signals.patch
-rtc-ratelimit-lost-interrupts-message.patch
-reduce-cpusetc-write_lock_irq-to-read_lock.patch
-reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
-char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
-afs-implement-file-locking.patch
-tty_io-use-kzalloc.patch
-remove-clockevents_releaserequest_device.patch
-kconfig-no-strange-misc-devices.patch
-afs-drop-explicit-extern.patch
-remove-useless-tolower-in-isofs.patch
-char-mxser_new-fix-sparse-warning.patch
-char-tty_ioctl-use-wait_event_interruptible_timeout.patch
-char-tty_ioctl-little-whitespace-cleanup.patch
-char-genrtc-use-wait_event_interruptible.patch
-char-n_r3964-use-wait_event_interruptible.patch
-char-ip2-use-msleep-for-sleeping.patch
-proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
-udf-coding-style-conversion-lindent.patch
-udf-coding-style-conversion-lindent-fixups.patch
-udf-coding-style-conversion-lindent-fixups-2.patch
-ext2-fix-a-comment-when-ext2_release_file-is-called.patch
-mutex_unlock-later-in-seq_lseek.patch
-zs-move-to-the-serial-subsystem.patch
-zs-move-to-the-serial-subsystem-update.patch
-fs-block_devc-use-list_for_each_entry.patch
-fault-injection-add-min-order-parameter-to-fail_page_alloc.patch
-fault-injection-fix-example-scripts-in-documentation.patch
-add-printktime-option-deprecate-time.patch
-fs-clarify-dummy-member-in-struct.patch
-dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
-remove-odd-and-misleading-comments-from-uioh.patch
-add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
-buffer-kill-old-incorrect-comment.patch
-introduce-o_cloexec-take-2.patch
-introduce-o_cloexec-parisc-fix.patch
-o_cloexec-for-scm_rights.patch
-o_cloexec-for-scm_rights-fix.patch
-o_cloexec-for-scm_rights-fix-2.patch
-init-wait-for-asynchronously-scanned-block-devices.patch
-init-wait-for-asynchronously-scanned-block-devices-fix.patch
-atmel_serial-fix-break-handling.patch
-documentation-proc-pid-stat-files.patch
-seq_file-more-atomicity-in-traverse.patch
-lib-add-idr_for_each.patch
-lib-add-idr_for_each-fix.patch
-lib-add-idr_remove_all.patch
-remove-capabilityh-from-mmh.patch
-kernel-utf-8-handling.patch
-kernel-utf-8-handling-fix.patch
-remove-sonypi_camera_command.patch
-drop-an-empty-isicomh-from-being-exported-to-user-space.patch
-ext3-ext4-orphan-list-check-on-destroy_inode.patch
-ext3-ext4-orphan-list-check-on-destroy_inode-fix.patch
-ext3-ext4-orphan-list-corruption-due-bad-inode.patch
-allow-file-system-to-configure-for-no-leases.patch
-remove-apparently-useless-commented-apm_get_battery_status.patch
-taskstats-add-context-switch-counters.patch
-taskstats-add-context-switch-counters-fix.patch
-sony-laptop-use-null-for-pointer.patch
-undeprecate-raw-driver.patch
-hfsplus-change-kmalloc-memset-to-kzalloc.patch
-submitchecklist-update-fix-spelling-error.patch
-fix-typo-in-prefetchh.patch
-zsc-drain-the-transmission-line.patch
-hugetlbfs-use-lib-parser-fix-docs.patch
-report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
-intel-rng-undo-mess-made-by-an-80-column-extremist.patch
-improve-behaviour-of-spurious-irq-detect.patch
-improve-behaviour-of-spurious-irq-detect-fix.patch
-audit-add-tty-input-auditing.patch
-audit-add-tty-input-auditing-fix.patch
-audit-add-tty-input-auditing-fix-2.patch
-remove-config_uts_ns-and-config_ipc_ns.patch
-user-namespace-add-the-framework.patch
-user-namespace-add-unshare.patch
-revert-vanishing-ioctl-handler-debugging.patch
-binfmt_elf-warning-fix.patch
-document-the-fact-that-rcu-callbacks-can-run-in-parallel.patch
-cobalt-remove-all-references-to-cobalt-nvram.patch
-allow-softlockup-to-be-runtime-disabled.patch
-dirty_writeback_centisecs_handler-cleanup.patch
-mm-fix-create_new_namespaces-return-value.patch
-add-a-kmem_cache-for-nsproxy-objects.patch
-ptrace_peekdata-consolidation.patch
-ptrace_pokedata-consolidation.patch
-adjust-nosmp-handling.patch
-ext3-fix-deadlock-in-ext3_remount-and-orphan-list-handling.patch
-ext4-fix-deadlock-in-ext4_remount-and-orphan-list-handling.patch
-remove-unused-lock_cpu_hotplug_interruptible-definition.patch
-add-werror-implicit-function-declaration.patch
-kerneldoc-fix-in-audit_core_dumps.patch
-add-lzo1x-algorithm-to-the-kernel.patch
-introduce-compat_u64-and-compat_s64-types.patch
-diskquota-32bit-quota-tools-on-64bit-architectures.patch
-diskquota-32bit-quota-tools-on-64bit-architectures-fix.patch
-diskquota-32bit-quota-tools-on-64bit-architectures-fix-fix.patch
-blink-only-blink-when-parameter-is-set.patch
-blink-only-blink-when-parameter-is-set-fix.patch
-remove-final-two-references-to-__obsolete_setup-macro.patch
-update-procfs-guide-doc-of-read_func.patch
-ext3-remove-extra-is_rdonly-check.patch
-namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long.patch
-doc-oops-tracing-add-code-decode-info.patch
-drop-obsolete-sys_ioctl-export.patch
-is_power_of_2-ext3-superc.patch
-is_power_of_2-jbd.patch
-sys_time-speedup.patch
-sys_time-speedup-build-fixes.patch
-cdrom-replace-hard-coded-constants-by-kernelh-macro.patch
-update-description-in-documentation-filesystems-vfstxt-typo-fixed.patch
-futex-tidy-up-the-code-v2.patch
-add-documentation-sysctl-ctl_unnumberedtxt.patch
-sysctlc-add-text-telling-people-to-use-ctl_unnumbered.patch
-mistaken-ext4_inode_bitmap-for-ext4_block_bitmap.patch
-hfs-refactor-ascii-to-unicode-conversion-routine.patch
-hfs-refactor-ascii-to-unicode-conversion-routine-fix.patch
-hfs-add-custom-dentry-hash-and-comparison-operations.patch
-sprint_symbol-cleanup.patch
-fs-namespacec-should-include-internalh.patch
-proper-prototype-for-proc_nr_files.patch
-replace-obscure-constructs-in-fs-block_devc.patch
-replace-obscure-constructs-in-fs-block_devc-fix.patch
-bd_claim_by_disk-fix-warning.patch
-adb_probe_task-remove-unneeded-flush_signals-call.patch
-kcdrwd-remove-unneeded-flush_signals-call.patch
-nbdcsock_xmit-cleanup-signal-related-code.patch
-move-seccomp-from-proc-to-a-prctl.patch
-make-seccomp-zerocost-in-schedule.patch
-is_power_of_2-kernel-kfifoc.patch
-parport_pc-it887x-fix.patch
-is_power_of_2-ufs-superc.patch
-codingstyle-add-information-about-trailing-whitespace.patch
-codingstyle-add-information-about-editor-modelines.patch
-uninline-check_signature.patch
-ibmasm-whitespace-cleanup.patch
-ibmasm-dont-use-extern-in-function-declarations.patch
-ibmasm-miscellaneous-fixes.patch
-ibmasm-must-depend-on-config_input.patch
-spi-controller-drivers-check-for-unsupported-modes.patch
-spi-controller-drivers-check-for-unsupported-modes-update.patch
-spi-add-3wire-mode-flag.patch
-spi-add-3wire-mode-flag-fix.patch
-crc7-support.patch
-crc7-support-fix.patch
-spidev-compiler-warning-gone.patch
-spi_lm70llp-parport-adapter-driver.patch
-spi_lm70llp-parport-adapter-driver-correction.patch
-spi_mpc83xxc-underclocking-hotfix.patch
-atmel_spi-minor-updates.patch
-s3c24xx-spi-controllers-both-select-bitbang.patch
-spi-tle620x-power-switch-driver.patch
-spi-master-driver-for-xilinx-virtex.patch
-spi-master-driver-for-xilinx-virtex-fix.patch
-move-page-writeback-acounting-out-of-macros.patch
-use-mutex-instead-of-semaphore-in-capi-20-driver.patch
-mismatching-declarations-of-revision-strings-in-hisax.patch
-make-isdn-capi-use-seq_list_xxx-helpers.patch
-update-isdn-tree-to-use-pci_get_device.patch
-sane-irq-initialization-in-sedlbauer-hisax.patch
-use-menuconfig-objects-isdn-config_isdn.patch
-use-menuconfig-objects-isdn-config_isdn_i4l.patch
-use-menuconfig-objects-isdn-config_isdn_drv_gigaset.patch
-use-menuconfig-objects-isdn-config_isdn_capi.patch
-use-menuconfig-objects-isdn-config_capi_avm.patch
-use-menuconfig-objects-isdn-config_capi_eicon.patch
-isdn-capi-warning-fixes.patch
-i4l-leak-in-eicon-idifuncc.patch
-i2o_cfg_passthru-cleanup.patch
-i2o_cfg_passthru-cleanup-fix.patch
-wrong-memory-access-in-i2o_block_device_lock.patch
-i2o-message-leak-in-i2o_msg_post_wait_mem.patch
-i2o-proc-reading-oops.patch
-i2o-debug-output-cleanup.patch
-knfsd-exportfs-add-exportfsh-header.patch
-knfsd-exportfs-add-exportfsh-header-fix.patch
-knfsd-exportfs-remove-iget-abuse.patch
-knfsd-exportfs-remove-iget-abuse-fix.patch
-knfsd-exportfs-add-procedural-interface-for-nfsd.patch
-knfsd-exportfs-remove-call-macro.patch
-knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
-knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
-knfsd-exportfs-add-find_disconnected_root-helper.patch
-knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch
-nfsd-warning-fix.patch
-knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4.patch
-knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
-knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
-knfsd-nfsd4-fix-enc_stateid_sz-for-nfsd-callbacks.patch
-knfsd-nfsd4-fix-handling-of-acl-errrors.patch
-knfsd-nfsd-remove-unused-header-interfaceh.patch
-knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
-knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix.patch
-knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix.patch
-knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix.patch
-knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix-fix.patch
-knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts.patch
-couple-fixes-to-fs-ecryptfs-inodec.patch
-ecryptfs-move-ecryptfs-docs-into-documentation-filesystems.patch
-rtc-ds1307-cleanups.patch
-rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
-thecus-n2100-register-rtc-rs5c372-i2c-device.patch
-rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
-rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
-driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
-driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
-driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2.patch
-driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-3.patch
-rtc_class-is-no-longer-considered-experimental.patch
-rtc-kconfig-tweax.patch
-rtc-add-rtc-m41t80-driver-take-2.patch
-rtc-add-rtc-m41t80-driver-take-2-fix.patch
-rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
-rtc-add-support-for-the-st-m48t59-rtc.patch
-rtc-add-support-for-the-st-m48t59-rtc-fix-2.patch
-rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch
-rtc-add-support-for-the-st-m48t59-rtc-fix-3.patch
-rtc-driver-for-ds1216-chips.patch
-rtc-driver-for-ds1216-chips-fix.patch
-rtc-ds1307-oscillator-restart-for-ds1337383940.patch
-revoke-special-mmap-handling.patch
-revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
-revoke-core-code.patch
-revoke-core-code-fix-zero-length-kmalloc.patch
-revoke-support-for-ext2-and-ext3.patch
-revoke-add-documentation.patch
-revoke-wire-up-i386-system-calls.patch
-fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
-lguest-export-symbols-for-lguest-as-a-module.patch
-lguest-the-guest-code.patch
-lguest-the-host-code.patch
-lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
-lguest-the-asm-offsets.patch
-lguest-the-makefile-and-kconfig.patch
-lguest-the-console-driver.patch
-lguest-the-net-driver.patch
-lguest-the-block-driver.patch
-lguest-the-documentation-example-launcher.patch
-oss-trident-massive-whitespace-removal.patch
-oss-trident-fix-locking-around-write_voice_regs.patch
-oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch
-remove-options-depending-on-oss_obsolete.patch
-char-cyclades-add-firmware-loading.patch
-char-cyclades-fix-sparse-warning.patch
-char-isicom-cleanup-locking.patch
-char-isicom-del_timer-at-exit.patch
-char-isicom-proper-variables-types.patch
-char-moxa-eliminate-busy-waiting.patch
-char-specialix-remove-busy-waiting.patch
-char-riscom8-eliminate-busy-loop.patch
-char-vt-use-kzalloc.patch
-char-vt-use-array_size.patch
-char-kconfig-mxser_new-remove-experimental-comment.patch
-char-stallion-remove-user-class-report-request.patch
-char-istallion-initlocking-fixes-try-2.patch
-fbcon-smart-blitter-usage-for-scrolling.patch
-nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method.patch
-fbcon-cursor-blink-control.patch
-fbcon-use-struct-device-instead-of-struct-class_device.patch
-fbdev-move-arch-specific-bits-to-their-respective.patch
-fbdev-move-arch-specific-bits-to-their-respective-fix.patch
-fbdev-detect-primary-display-device.patch
-fbcon-allow-fbcon-to-use-the-primary-display-driver.patch
-fbcon-allow-fbcon-to-use-the-primary-display-driver-fix.patch
-fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
-radeonfb-add-support-for-radeon-xpress-200m-rs485.patch
-nvidiafb-add-proper-support-for-geforce-7600-chipset.patch
-pm2fb-white-spaces-clean-up.patch
-fbcon-set_con2fb_map-fixes.patch
-fbcon-revise-primary-device-selection.patch
-fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch
-fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
-vt-add-comment-for-unbind_con_driver.patch
-68328fb-the-pseudo_palette-is-only-16-elements-long.patch
-controlfb-the-pseudo_palette-is-only-16-elements-long.patch
-cyblafb-fix-pseudo_palette-array-overrun-in-setcolreg.patch
-epson1355fb-color-setting-fixes.patch
-fm2fb-the-pseudo_palette-is-only-16-elements-long.patch
-gbefb-the-pseudo_palette-is-only-16-elements-long.patch
-macfb-fix-pseudo_palette-size-and-overrun.patch
-offb-the-pseudo_palette-is-only-16-elements-long.patch
-platinumfb-the-pseudo_palette-is-only-16-elements.patch
-pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch
-q40fb-the-pseudo_palette-is-only-16-elements-long.patch
-sgivwfb-the-pseudo_palette-is-only-16-elements-long.patch
-tgafb-actually-allocate-memory-for-the-pseudo_palette.patch
-tridentfb-fix-pseudo_palette-array-overrun-in-setcolreg.patch
-tx3912fb-fix-improper-assignment-of-info-pseudo_palette.patch
-atyfb-the-pseudo_palette-is-only-16-elements-long.patch
-radeonfb-the-pseudo_palette-is-only-16-elements-long.patch
-i810fb-the-pseudo_palette-is-only-16-elements-long.patch
-intelfb-the-pseudo_palette-is-only-16-elements-long.patch
-sisfb-fix-pseudo_palette-array-size-and-overrun.patch
-matroxfb-color-setting-fixes.patch
-pm3fb-fillrect-acceleration.patch
-pm3fb-possible-cleanups.patch
-vt8623fbc-make-code-static.patch
-matroxfb-color-setting-fixes-fix.patch
-fb-epson1355fb-kill-off-dead-sh-support.patch
-fix-the-graphic-corruption-issue-on-ia64-machines.patch
-omap-add-ti-omap-framebuffer-driver.patch
-omap-add-ti-omap1610-accelerator-entry.patch
-omap-add-ti-omap1-internal-lcd-controller.patch
-omap-add-ti-omap2-internal-display-controller-support.patch
-omap-add-ti-omap1-external-lcd-controller-support-sossi.patch
-omap-add-ti-omap2-external-lcd-controller-support-rfbi.patch
-omap-add-external-epson-hwa742-lcd-controller-support.patch
-omap-add-external-epson-blizzard-lcd-controller-support.patch
-omap-lcd-panel-support-for-the-ti-omap-h4-board.patch
-omap-lcd-panel-support-for-the-ti-omap-h3-board.patch
-omap-lcd-panel-support-for-the-palm-tungsten-e.patch
-omap-lcd-panel-support-for-palm-tungstent.patch
-omap-lcd-panel-support-for-the-palm-zire71.patch
-omap-lcd-panel-support-for-the-ti-omap1610-innovator-board.patch
-omap-lcd-panel-support-for-the-ti-omap1510-innovator-board.patch
-omap-lcd-panel-support-for-the-ti-omap-osk-board.patch
-omap-lcd-panel-support-for-the-siemens-sx1-mobile-phone.patch
-use-menuconfig-objects-ii-md.patch
-md-improve-message-about-invalid-superblock-during-autodetect.patch
-md-improve-the-is_mddev_idle-test-fix.patch
-md-check-that-internal-bitmap-does-not-overlap-other-data.patch
-md-change-bitmap_unplug-and-others-to-void-functions.patch
-readahead-introduce-pg_readahead.patch
-readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
-readahead-min_ra_pages-max_ra_pages-macros.patch
-readahead-data-structure-and-routines.patch
-readahead-on-demand-readahead-logic.patch
-readahead-convert-filemap-invocations.patch
-readahead-convert-splice-invocations.patch
-readahead-convert-ext3-ext4-invocations.patch
-readahead-remove-the-old-algorithm.patch
-readahead-move-synchronous-readahead-call-out-of-splice-loop.patch
-readahead-pass-real-splice-size.patch
-mm-share-pg_readahead-and-pg_reclaim.patch
-readahead-split-ondemand-readahead-interface-into-two-functions.patch
-readahead-sanify-file_ra_state-names.patch
-fallocate-implementation-on-i86-x86_64-and-powerpc.patch
-fallocate-on-s390.patch
-fallocate-on-ia64.patch
-fallocate-on-ia64-fix.patch
-jprobes-make-struct-jprobeentry-a-void.patch
-jprobes-remove-jprobe_entry.patch
-jprobes-make-jprobes-a-little-safer-for-users.patch
-jprobes-make-jprobes-a-little-safer-for-users-fix.patch
-define-new-percpu-interface-for-shared-data-version-4.patch
-use-the-new-percpu-interface-for-shared-data-version-4.patch
-arch-personality-independent-stack-top.patch
-audit-rework-execve-audit.patch
-mm-variable-length-argument-support.patch
-mm-variable-length-argument-support-fix.patch
-ext4-ext4_noextent_mount_opt.patch
-ext4-ext4_extents_on_by_default.patch
-ext4-ext4-propagate_flags.patch
-ext4-ext4-extent-sanity-checks.patch
-ext4-ext4-fallocate-5-ext4_support.patch
-ext4-ext4-fallocate-6-uninit_write_support.patch
-ext4-ext4-nanosecond-patch.patch
-ext4-ext4_expand_inode_extra_isize.patch
-ext4-ext4_expand_inode_isize_fix.patch
-ext4-jbd-stats-through-procfs.patch
-ext4-ext4_remove_subdirs_limit.patch
-ext4-zero_user_page-conversion.patch
-ext4-remove-extra-is_rdonly-check.patch
-is_power_of_2-ext4-superc.patch
-fs-introduce-vfs_path_lookup.patch
-sunrpc-use-vfs_path_lookup.patch
-nfsctl-use-vfs_path_lookup.patch
-fs-mark-link_path_walk-static.patch
-fs-remove-path_walk-export.patch
-cfs-scheduler.patch
-cfs-scheduler-vs-detach-schedh-from-mmh.patch
-cfs-scheduler-v14-rc2-mm1.patch
-cfs-scheduler-warning-fixes.patch
-cfs-scheduler-v15-rc3-mm1.patch
-kernel-sched_fairc-make-code-static.patch
-fs-proc-basec-make-a-struct-static.patch
-cfs-warning-fixes.patch
-schedstats-fix-printk-format.patch
-cfs-scheduler-v16.patch
-sched-cfs-v2.6.22-git-v18.patch
-kernel-doc-add-tools-doc-in-makefile.patch
-kernel-doc-fix-unnamed-struct-union-warning.patch
-kernel-doc-strip-c99-comments.patch
-kernel-doc-fix-leading-dot-in-man-mode-output.patch
-kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
-coredump-masking-bound-suid_dumpable-sysctl.patch
-coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
-coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
-coredump-masking-add-an-interface-for-core-dump-filter.patch
-coredump-masking-elf-enable-core-dump-filtering.patch
-coredump-masking-elf-fdpic-remove-an-unused-argument.patch
-coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
-coredump-masking-documentation-for-proc-pid-coredump_filter.patch
-drivers-edac-add-edac_mc_find-api.patch
-drivers-edac-core-make-functions-static.patch
-drivers-edac-add-rddr2-memory-types.patch
-drivers-edac-split-out-functions-to-unique-files.patch
-drivers-edac-add-edac_device-class.patch
-drivers-edac-mc-sysfs-add-missing-mem-types.patch
-drivers-edac-change-from-semaphore-to-mutex-operation.patch
-drivers-edac-new-intel-5000-mc-driver.patch
-drivers-edac-new-intel-5000-mc-driver-fix.patch
-drivers-edac-coreh-fix-scrubdefs.patch
-drivers-edac-new-i82443bxgz-mc-driver.patch
-drivers-edac-new-i82443bxgz-mc-driver-broken.patch
-drivers-edac-add-new-nmi-rescan.patch
-drivers-edac-mod-use-edac_coreh.patch
-drivers-edac-add-dev_name-getter-function.patch
-drivers-edac-new-inte-30x0-mc-driver.patch
-drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
-drivers-edac-updated-pci-monitoring.patch
-drivers-edac-mod-assert_error-check.patch
-drivers-edac-mod-pci-poll-names.patch
-drivers-edac-core-lindent-cleanup.patch
-drivers-edac-edac_device-sysfs-cleanup.patch
-drivers-edac-cleanup-workq-ifdefs.patch
-drivers-edac-lindent-amd76x.patch
-drivers-edac-lindent-i5000.patch
-drivers-edac-lindent-e7xxx.patch
-drivers-edac-lindent-i3000.patch
-drivers-edac-lindent-i82860.patch
-drivers-edac-lindent-i82875p.patch
-drivers-edac-lindent-e752x.patch
-drivers-edac-lindent-i82443bxgx.patch
-drivers-edac-lindent-r82600.patch
-drivers-edac-drivers-to-use-new-pci-operation.patch
-drivers-edac-add-device-sysfs-attributes.patch
-drivers-edac-device-output-clenaup.patch
-drivers-edac-add-info-kconfig.patch
-drivers-edac-update-maintainers-files-for-edac.patch
-drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch
-driver-edac-add-mips-and-ppc-visibility.patch
-driver-edac-mod-race-fix-i82875p.patch
-driver-edac-fix-ignored-return-i82875p.patch
-include-linux-pci_id-h-add-amd-northbridge-defines.patch
-driver-edac-i5000-define-typo.patch
-driver-edac-remove-null-from-statics.patch
-driver-edac-i5000-code-tidying.patch
-driver-edac-edac_device-code-tidying.patch
-driver-edac-mod-edac_align_ptr-function.patch
-driver-edac-mod-edac_opt_state_to_string-function.patch
-driver-edac-remove-file-edac_mc-h.patch
-fix-raw_spinlock_t-vs-lockdep.patch
-lockdep-sanitise-config_prove_locking.patch
-lockdep-reduce-the-ifdeffery.patch
-lockstat-core-infrastructure.patch
-lockstat-core-infrastructure-fix.patch
-lockstat-core-infrastructure-fix-fix.patch
-lockstat-core-infrastructure-fix-fix-fix.patch
-lockstat-human-readability-tweaks.patch
-lockstat-human-readability-tweaks-fix.patch
-lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
-lockdep-various-fixes.patch
-lockdep-various-fixes-checkpatch.patch
-lockdep-fixup-sk_callback_lock-annotation.patch
-lockstat-measure-lock-bouncing.patch
-lockstat-measure-lock-bouncing-checkpatch.patch
-lockstat-better-class-name-representation.patch
-restore-rogue-readahead-printk.patch

 Merged into mainline or a subsystem tree

+tiny-signalfd-cleanup.patch
+kernel-doc-fix-for-kmodc.patch
+slab-maintainer-credits-update.patch
+rtc-stk17ta8-update-for-sysfs-api-change.patch
+use-ldflags_module-only-for-ko-links.patch
+pm-fix-compiler-error-of-ppc-dart_iommu.patch
+fixup-s3c24xx-build-after-arch-moves.patch
+rtc-ds1307-typo-fix-found-by-coverity.patch
+xen-xen-pageh-compile-fix.patch
+lguest-documentation-i-preparation.patch
+lguest-documentation-ii-guest.patch
+lguest-documentation-iii-drivers.patch
+lguest-documentation-iv-launcher.patch
+lguest-documentation-v-host.patch
+lguest-documentation-vi-switcher.patch
+lguest-documentation-vii-fixmes.patch
+x86_powernow_k8_acpi-must-depend-on-acpi.patch
+make-timerfd-return-a-u64-and-fix-the-__put_user.patch
+memory-unplug-v7-migration-by-kernel.patch
+memory-unplug-v7-isolate_lru_page-fix.patch
+revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
+reorder-rtc-makefile.patch
+ufs-printk-warning-fix.patch
+i2c-ds1682-warning-fix.patch
+edac-is-bust-on-mips.patch
+xenbus_xsc-fix-a-use-after-free.patch
+fix-inode_table-test-in-ext234_check_descriptors.patch
+kdebugh-forward-declare-struct-struct-notifier_block.patch

 2.6.23 queue

+check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch

 In limbo.

+consolidate-ptrace_detach.patch
+powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
+slow-down-printk-during-boot.patch
+slow-down-printk-during-boot-fix-2.patch

 Misc

+git-acpi-build-fix.patch

 git-acpi fix

+acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
+acpi-add-reboot-mechanism.patch
+acpi-add-reboot-mechanism-fix.patch
+acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
+acpi-remove-references-to-acpi_state_s2-from-acpi_pm_enter.patch
+acpi-fix-oops-due-to-typo-in-new-throttling-code.patch

 APCI stuff

+fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch

 agp fix

+agk-dm-dm-crypt-drop-device-ref-in-ctr-error-path.patch
+agk-dm-dm-delay-fix-ctr-error-paths.patch

 dm updates

+powerpc-vdso-install-unstripped-copies-on-disk.patch
+sky-cpu-and-nexus-code-style-improvement.patch
+sky-cpu-and-nexus-include-ioh.patch
+sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
+sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
+sky-cpu-use-c99-style-for-struct-init.patch
+sky-cpu-and-nexus-get-rid-of-useless-null-init.patch
+sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface.patch

 ppc things

+gregkh-driver-howto-adjust-translation-header-of-japanese-stable_api_nonsensetxt.patch
+gregkh-driver-howto-sync-japanese-howto.patch
+gregkh-driver-kobject-fix-link-error-when-config_hotplug-is-disabled.patch
+gregkh-driver-kobject-put-kobject_actions-in-kobjecth.patch
+gregkh-driver-sysfs-remove-first-pass-at-shadow-directory-support.patch
+gregkh-driver-sysfs-implement-sysfs-manged-shadow-directory-support.patch
+gregkh-driver-sysfs-implement-sysfs_delete_link-and-sysfs_rename_link.patch
+gregkh-driver-driver-core-implement-shadow-directory-support-for-device-classes.patch
+gregkh-driver-nozomi.patch

 Driver tree updates

+fix-typos-in-fs-sysfs-filec.patch

 sysfs fix

+dma-arch-fix.patch

 Fix git-dma.patch

+initialize-filp-private_data-only-once-in-em28xx_v4l2_open.patch
+stradis-and-zoran-depend-on-virt_to_bus.patch

 dvb fixes

+jdelvare-i2c-i2c-i801-typo-erroneous.patch
+jdelvare-i2c-i2c-mpc-pass-correct-dev_id-to-free_irq.patch
+jdelvare-i2c-i2c-isp1301_omap-build-fixes.patch
+jdelvare-i2c-i2c-iop3xx-set-adapater-class.patch
+jdelvare-i2c-i2c-new-style-devices-can-support-wakeup-flags.patch

 i2c tree updates

+clean-up-duplicate-includes-in-drivers-hwmon.patch

 hwmon fix

+hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch

 hid update

+ia64-allow-smp_call_function_single-to-current-cpu.patch
+ia64-rename-partial_page.patch

 ia64 fixes

+pci-x-pci-express-read-control-interfaces-mthca.patch

 infiniband fix

+hdaps-switch-to-using-input-polldev.patch
+applesmc-switch-to-using-input-polldev.patch
+applesmc-add-temperature-sensors-set-for-macbook.patch
+ams-switch-to-using-input-polldev.patch
+adbhid-produce-all-capslock-key-events.patch
+adbhid-produce-all-capslock-key-events-fix.patch
+m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
+clean-up-duplicate-includes-in-drivers-input.patch
+iforce-warning-fix.patch

 input things

+pass-g-to-assembler-under-config_debug_info.patch
+mkmakefile-include-arch-on-o=-builds.patch

 kbuild

+pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
+sata_nv-allow-changing-queue-depth.patch
+sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
+libata-adjust-libata-to-ignore-errors-after.patch
+libata-check-for-an-support.patch
+scsi-expose-an-to-user-space.patch
+libata-expose-an-to-user-space.patch
+scsi-save-disk-in-scsi_device.patch
+libata-send-event-when-an-received.patch
+ata-ahci-alpm-store-interrupt-value.patch
+ata-ahci-alpm-expose-power-management-policy-option-to-users.patch
+ata-ahci-alpm-enable-link-power-management-for-ata-drivers.patch
+ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix.patch
+ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch

 ata things

-libata-add-human-readable-error-value-decoding.patch

 Dropped

+ide-ide-add-missing-ide-rate-filter-calls.patch
+ide-ide-mode-limiting-fixes-for-user-requested-speed-changes.patch
+ide-cs5520-fix-pio-auto-tuning-in-ide-dma-check-method.patch
+ide-cs5535-pio-fixes.patch
+ide-it8213-pio-fixes-take2.patch
+ide-jmicron-pio-fixes.patch
+ide-piix-slc90e66-fix-pio1-handling-in-speedproc-method-take2.patch
+ide-scc_pata-pio-fixes.patch
+ide-sis5513-udma-filter.patch
+ide-ide-remove-ide-rate-filter-from-speedproc.patch
+ide-ide-kconfig-face-lift.patch
+ide-ide-add-ide-set-pio-take3.patch
+ide-ide-cris-fix-set-pio-mode.patch
+ide-amd74xx-via82cxxx-use-ide-tune-dma.patch
+ide-sgiioc4-use-ide-tune-dma.patch
+ide-ide-config-drive-for-dma-fixes.patch
+ide-icside-fix-speedproc-for-unsupported-modes-take4.patch
+ide-ide-pmac-fix-drive-init-speed-reporting.patch
+ide-ide-pmac-pio-mode-setup-fixes-take-3.patch
+ide-sc1200-remove-redundant-warning-message.patch
+ide-cs5520-dont-enable-vdma-in-speedproc.patch
+ide-siimage-fix-set-pio-method-to-select-pio-data-transfer.patch
+ide-ide-add-cable-detection-for-early-udma66-devices.patch
+ide-alim15x3-pio-mode-setup-fixes.patch
+ide-it8213-piix-slc90e66-dont-change-dma-settings-for-pio-modes.patch
+ide-sis5513-dont-change-udma-settings-for-pio-modes.patch
+ide-ide-use-only-set-pio-mode-for-programming-pio-modes.patch

 IDE tree updates

+fix-ide-ide-add-ide-set-pio-take3.patch
+ide-bodge-things-around-to-make-arm-work.patch

 IDE things

+git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
+mtdoops-printk-warning-fixes.patch
+mtd-add-module-license-to-mtdbdi.patch

 MTD things

+drivers-net-ns83820c-add-paramter-to-disable-auto.patch
+drivers-net-cxgb3-remove-several-unneeded-zero-initialization.patch
+via-rhine-disable-rx_copybreak-on-archs-that.patch
+phy-fixed-driver-rework-release-path-and-update.patch
+pci-x-pci-express-read-control-interfaces-myrinet.patch
+pci-x-pci-express-read-control-interfaces-e1000.patch
+dev-priv-to-netdev_privdev-drivers-net-tokenring.patch
+3c59x-check-return-of-pci_enable_device.patch
+clean-up-duplicate-includes-in-drivers-net.patch
+ax88796-printk-fixes.patch

 netdev things

-drivers-net-ns83820c-add-paramter-to-disable-auto.patch

 Dropped

+e1000new-build-fix.patch
+e1000new-build-fix-2.patch

 Fix git-e1000new.patch

+fore200e_param_bs_queue-must-be-__devinit.patch
+ip_auto_config-fix.patch
+ip_auto_config-fix-fix.patch
+clean-up-duplicate-includes-in-drivers-atm.patch
+clean-up-duplicate-includes-in-net-atm.patch
+clean-up-duplicate-includes-in-net-ipv4.patch
+clean-up-duplicate-includes-in-net-ipv6.patch
+clean-up-duplicate-includes-in-net-sched.patch
+clean-up-duplicate-includes-in-net-sunrpc.patch
+clean-up-duplicate-includes-in-net-tipc.patch
+clean-up-duplicate-includes-in-net-xfrm.patch
+fix-theoretical-ccids_readwrite_lock-race.patch

 net stuff

+clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch

 nfs cleanup

+clean-up-duplicate-includes-in-fs-ntfs.patch

 ntfs celanup

-pa-risc-use-page-allocator-instead-of-slab-allocator-fix.patch

 Folded into pa-risc-use-page-allocator-instead-of-slab-allocator.patch

-dont-optimise-away-baud-rate-changes-when-bother-is-used-fix.patch
-dont-optimise-away-baud-rate-changes-when-bother-is-used-fix-fix.patch

 Folded into dont-optimise-away-baud-rate-changes-when-bother-is-used.patch

+serial_txx9-fix-modem-control-line-handling.patch
+serial_txx9-cleanup-includes.patch
+serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
+serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
+add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
+add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch

 serial stuff

+gregkh-pci-pci-move-prototypes-for-pci_bus_find_capability-to-include-linux-pcih.patch
+gregkh-pci-pci-quirk_e100_interrupt-called-too-early.patch
+gregkh-pci-pci-document-pci_iomap.patch

 PCI tree updates

+pci-disable-decode-of-io-memory-during-bar-sizing.patch
+i386-add-support-for-picopower-irq-router.patch
+acpiphp_ibm-add-missing-n.patch
+try-parent-numa_node-at-first-before-using-default-v2.patch
+try-parent-numa_node-at-first-before-using-default-v2-fix.patch
+pci-remove-irritating-try-pci=assign-busses-warning.patch

 PCi things

+aacraid-rename-check_reset.patch
+incorrect-scsi-transfer-length-computation-from-odd.patch
+aha152x-in-debug-mode.patch
+use-menuconfig-objects-fusion.patch
+clean-up-duplicate-includes-in-drivers-scsi.patch
+megaraid-add-cerc_ata100-support.patch

 scsi fixes

+git-scsi-target-fixup.patch

 Fix rejects in git-scsi-target.patch

+gregkh-usb-usb-devices-misc-trivial-patch-to-build-the-iowarrior-when-it-is-selected-in-kconfig.patch
+gregkh-usb-usb-don-t-let-usb-storage-steal-blackberry-pearl.patch
+gregkh-usb-usb-more-quirky-devices.patch
+gregkh-usb-usb-usbh-kernel-doc-additions.patch
+gregkh-usb-usb-even-more-quirks.patch
+gregkh-usb-usb-introduce-usb_device-authorization-bits.patch
+gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-hosts.patch
+gregkh-usb-usb-cleanup-usb_register_bus-and-hook-up-sysfs-group.patch
+gregkh-usb-usb-initialize-authorization-and-wusb-bits-in-usb-devices.patch
+gregkh-usb-usb-usb_set_configuration-obeys-authorization.patch

 USB tree updates

+merge-the-sonics-silicon-backplane-subsystem.patch
+merge-the-sonics-silicon-backplane-subsystem-fix.patch
+ssb-add-a-driver-for-the-broadcom-ohci-core.patch
+usb-typo-in-usb-r8a66597-hcd-config.patch
+nikon-d50-is-an-unusual-device.patch
+0-null-drivers-usb-gadget.patch
+clean-up-duplicate-includes-in-drivers-usb.patch

 USB stuff

+x86_64-mm-pci-mmconfig-eax.patch
+x86_64-mm-early-quirks-unification.patch
+x86_64-mm-nvidia-timer-quirk.patch
+x86_64-mm-fam11-rep-good.patch
+x86_64-mm-clean-up-duplicate-includes-in-arch-i386-kernel.patch
+x86_64-mm-x86_64-sanitize-user-specified-e820-memmap-values.patch
+x86_64-mm-no-video-module.patch
+x86_64-mm-fix-arch-i386-kernel-nmi_c-unknown_nmi_panic_callback-declared-static-but-never-defined-warning.patch

 x86 tree updates

+revert-x86_64-mm-pci-mmconfig-eax.patch
+fix-x86_64-mm-early-quirks-unification.patch

 fix it
 
+x86_64-clean-up-apicid_to_node-declaration.patch
+geode-mfgpt-support-for-geode-class-machines.patch
+geode-mfgpt-clock-event-device-support.patch
+i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
+i386-vdso-install-unstripped-copies-on-disk.patch
+i386-vdso-install-unstripped-copies-on-disk-fix.patch
+x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
+x86_64-hide-cond_syscall-behind-__kernel__.patch
+arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
+x86_64-add-acpi-reboot-option.patch
+x86_64-make-acpi-the-default-reset-option.patch
+mmconfig-validate-against-acpi-motherboard-resources.patch
+geode-setup-correct-chipset-access-functions-fix.patch
+x86_64-use-wbinvd-macro-instead-of-raw-inline-assembly-in-c-files.patch
+i386-remove-unnecessary-code.patch
+x86_64-use-descriptors-functions-instead-of-inline-assembly.patch
+clean-up-duplicate-includes-in-arch-i386-xen.patch
+mtrr-simplify-smp_call_function_single-call-sequence.patch
+cpuid-driver-simplify-smp_call_function_single-call-sequence.patch
+msr-driver-simplify-smp_call_function_single-call-sequence.patch

 x86 stuff

-acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
-clockevents-fix-typo-in-acpi_pmc.patch
-timekeeping-fixup-shadow-variable-argument.patch
-timerc-cleanup-recently-introduced-whitespace-damage.patch
-clockevents-remove-prototypes-of-removed-functions.patch
-clockevents-fix-resume-logic.patch
-clockevents-fix-device-replacement.patch
-tick-management-spread-timer-interrupt.patch
-highres-improve-debug-output.patch
-highres-improve-debug-output-fix.patch
-hrtimer-speedup-hrtimer_enqueue.patch
-pcspkr-use-the-global-pit-lock.patch
-ntp-move-the-cmos-update-code-into-ntpc.patch
-ntp-move-the-cmos-update-code-into-ntpc-fix.patch
-ntp-move-the-cmos-update-code-into-ntpc-fix-fix.patch
-i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
-i386-remove-volatile-in-apicc.patch
-i386-hpet-assumes-boot-cpu-is-0.patch
-i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
-x86_64-untangle-asm-hpeth-from-asm-timexh.patch
-x86_64-use-generic-cmos-update.patch
-x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
-x86_64-fix-apic-typo.patch
-x86_64-convert-to-cleckevents.patch
-acpi-remove-the-useless-ifdef-code.patch

 dynticks got lost

-ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
-ich-force-hpet-restructure-hpet-generic-clock-code.patch
-ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
-ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
-ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
-ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
-ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
-ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
-ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch

 These died and need redoing.

+git-kgdb-arm-fix.patch
+git-kgdb-mips-fix.patch

 kgdb fixes

+sparsemem-clean-up-spelling-error-in-comments.patch
+sparsemem-record-when-a-section-has-a-valid-mem_map.patch
+sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
+generic-virtual-memmap-support-for-sparsemem.patch
+x86_64-sparsemem_vmemmap-2m-page-size-support.patch
+ia64-sparsemem_vmemmap-16k-page-size-support.patch
+sparc64-sparsemem_vmemmap-support.patch
+ppc64-sparsemem_vmemmap-support.patch
+slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
+during-vm-oom-condition-kill-all-threads-in-process-group.patch
+clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
+clean-up-duplicate-includes-in-mm.patch
+readahead-compacting-file_ra_state.patch
+readahead-mmap-read-around-simplification.patch
+readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
+readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
+readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
+radixtree-introduce-radix_tree_next_hole.patch
+readahead-basic-support-of-interleaved-reads.patch
+readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
+readahead-remove-several-readahead-macros.patch
+readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
+filemap-trivial-code-cleanups.patch
+filemap-convert-some-unsigned-long-to-pgoff_t.patch

 MM things

-fs-introduce-write_begin-write_end-and-perform_write-aops-fix.patch
-fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2.patch
-fs-introduce-write_begin-write_end-and-perform_write-aops-fix-3.patch
-fs-introduce-write_begin-write_end-and-perform_write-aops-fix-4.patch
-fs-introduce-write_begin-write_end-and-perform_write-aops-fix-5.patch

 Folded into fs-introduce-write_begin-write_end-and-perform_write-aops.patch

+introduce-write_begin-write_end-aops-important-fix.patch
+deny-partial-write-for-loop-dev-fd.patch
+ext2-convert-to-new-aops-fix.patch
+reiserfs-convert-to-new-aops-fix.patch
+hostfs-convert-to-new-aops-fix.patch
+udf-convert-to-new-aops-fix.patch
+affs-convert-to-new-aops-fix.patch
+ocfs2-convert-to-new-aops.patch

 Fix the write-vs-pagefault deadlock fixes in -mm.

+fs-remove-some-aop_truncated_page.patch
+fs-remove-some-aop_truncated_page-fix.patch

 cleanup

-add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch

 Folded into add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch

-maps2-move-the-page-walker-code-to-lib-fix.patch

 Folded into maps2-move-the-page-walker-code-to-lib.patch

+mmaps2-vma-out-of-mem_size_stats.patch
+maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
+maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch

 maps2 updates

+slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
+memory-unplug-v7-memory-hotplug-cleanup.patch
+memory-unplug-v7-page-isolation.patch
+memory-unplug-v7-page-offline.patch
+memory-unplug-v7-ia64-interface.patch
+hugetlbfs-read-support.patch
+hugetlbfs-read-support-fix.patch

 More MM things

+security-convert-lsm-into-a-static-interface.patch
+security-convert-lsm-into-a-static-interface-fix.patch
+security-convert-lsm-into-a-static-interface-fix-2.patch
+security-convert-lsm-into-a-static-interface-fix-unionfs.patch

 Break LSMs

+file-capabilities-get_file_caps-cleanups.patch
+file-caps-update-selinux-xattr-hooks.patch
+file-capabilities-clear-caps-cleanup.patch
+file-capabilities-clear-caps-cleanup-fix.patch
+file-capabilities-change-xattr-format-v2.patch
+file-capabilities-change-fe-to-a-bool.patch
+file-caps-clean-up-for-linux-capabilityh.patch
+capabilityh-remove-include-of-currenth.patch

 More file-capabilities work

+pm-move-definition-of-struct-pm_ops-to-suspendh.patch
+pm-rename-struct-pm_ops-and-related-things.patch
+pm-rework-struct-platform_suspend_ops.patch
+pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
+pm-make-suspend_ops-static.patch
+pm-rework-struct-hibernation_ops.patch
+pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
+freezer-document-relationship-with-memory-shrinking.patch
+freezer-do-not-sync-filesystems-from-freeze_processes.patch
+freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
+freezer-introduce-freezer-firendly-waiting-macros.patch
+freezer-do-not-send-signals-to-kernel-threads.patch

 PM udpates

+whitelist-references-from-__dbe_table-to-init.patch
+use-list_head-in-binfmt-handling.patch
+use-list_head-in-binfmt-handling-fix.patch
+make-unregister_binfmt-return-void.patch
+fix-user-struct-leakage-with-locked-ipc-shem-segment.patch
+bpqether-fix-rcu-usage.patch
+immunize-rcu_dereference-against-crazy-compiler-writers.patch
+remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
+afs-fix-file-locking.patch
+fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
+fix-leak-on-proc-lockdep_stats.patch
+softlockup-use-cpu_clock-instead-of-sched_clock.patch
+fix-the-softlockup-watchdog-to-actually-work.patch
+softlockup-make-asm-irq_regsh-available-on-every-platform.patch
+softlockup-improve-debug-output.patch
+softlockup-watchdog-style-cleanups.patch
+softlockup-add-a-proc-tuning-parameter.patch
+softlockup-add-a-proc-tuning-parameter-fix.patch
+blktrace-use-cpu_clock-instead-of-sched_clock.patch
+futex-pass-nr_wake2-to-futex_wake_op.patch
+slab_panic-more-proc-posix-timers-shmem.patch
+zisofs-use-mutex-instead-of-semaphore.patch
+force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
+force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
+# driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch: exports?
+driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
+driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
+include-serial_regh-with-userspace-headers.patch
+trivial-in-string-typos-of-error.patch
+unexport-asm-shmparamh.patch
+pure_initcall-id-inconsistency.patch
+serial-fix-section-mismatch-vr41xx_siu.patch
+serial-fix-vr41xx_siu-interface-select.patch
+serial-fix-vr41xx_siu-serial-console-support.patch
+remove-tx3912fb.patch
+# ext2-statfs-improvement-for-block-and-inode-free-count.patch: bad tradeoff?
+ext2-statfs-improvement-for-block-and-inode-free-count.patch
+sunrpc-convert-rpc_pipefs-to-use-the-generic-filesystem-notification-hooks.patch
+locks-kill-redundant-local-variable.patch
+isofs-mounting-to-regular-file-may-succeed.patch
+update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
+kill-declare_mutex_locked.patch
+serial-mpsc-remove-race-between-rx-stop-restart.patch
+serial-mpsc-stop-rx-engine-when-cread-cleared.patch
+serial-mpsc-remove-duplicate-support_sysrq-definition.patch
+serial-mpsc-fix-coding-style-and-whitespace-issues.patch
+i2ch-kernel-doc-additions.patch
+irqh-fix-kernel-doc.patch
+docbook-bad-file-references.patch
+add-kernel-notifierc.patch
+add-kernel-notifierc-fix.patch
+add-kernel-notifierc-fix-2.patch
+ipmi-fix-mem-leak-in-try_init_dmi.patch
+ncp-delete-test-of-long-deceased-config_ncpfs_debugdentry.patch
+nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable.patch
+nbd-change-a-parameters-type-to-remove-a-memcpy-call.patch
+fs-romfs-inodec-trivial-improvements.patch
+fs-mark-nibblemap-const.patch
+broken-lilo-check-on-make-install.patch
+remove-one-more-leftover-reference-to-devfs.patch
+anon_inodes-shouldnt-be-user-visible.patch
+hpettxt-broken-link-fix.patch
+use-__val-in-__get_unaligned.patch
+vfs-fix-a-race-in-lease-breaking-during-truncate.patch
+fs-9p-convc-error-path-fix.patch
+kconfig-make-instrumentation-support-non-experimental.patch
+faster-ext2_clear_inode.patch
+remove-unneded-lock_kernel-in-driver-block-loopc.patch
+loop-use-unlocked_ioctl.patch
+do_sys_poll-simplify-playing-with-on-stack-data.patch
+do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
+do_poll-return-eintr-when-signalled.patch
+kthread-silence-bogus-section-mismatch-warning.patch
+fs-proc-mmuc-headers-butchery.patch
+fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
+idr_remove_all-kill-unused-variable.patch
+typo-fixes-errror-error.patch
+i386-include-asm-bugsh-in-bugsc-for-check_bugs-prototype.patch
+x86_64-include-asm-bugsh-in-bugsc-for-check_bugs.patch
+mark-sysrq_sched_debug_show-static.patch
+i386-mark-pit_clockevent-static.patch
+cfs-mark-print_cfs_stats-static.patch
+sb1250-duart-__maybe_unused-etc-fixes.patch
+rename-setleast-to-generic_setlease.patch
+fs-use-kmem_cache_zalloc-instead.patch
+# remove-kconfig-setting-config_debug_shirq.patch: Ingo worried
+remove-kconfig-setting-config_debug_shirq.patch
+# debug-handling-of-early-spurious-interrupts.patch: akpm worried about non-shared handlers
+debug-handling-of-early-spurious-interrupts.patch
+videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
+documentation-update-sched-stattxt.patch
+pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
+allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
+allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
+allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-sparc64-fix.patch
+allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2.patch
+allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-fix.patch
+allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch
+remove-sysctlh-from-fsh.patch
+drivers-char-hpetc-integer-constant-is-too-large-for-long-type.patch
+clean-up-duplicate-includes-in-drivers-char.patch
+clean-up-duplicate-includes-in-drivers-w1.patch
+clean-up-duplicate-includes-in-fs.patch
+clean-up-duplicate-includes-in-fs-ecryptfs.patch
+clean-up-duplicate-includes-in-kernel.patch
+time-simplify-smp_call_function_single-call-sequence.patch
+kconfig-remove-top-level-menu-code-maturity-level-options.patch
+cciss-fix-memory-leak.patch
+# convert-ill-defined-log2-to-ilog2.patch: needs acks
+convert-ill-defined-log2-to-ilog2.patch
+udf-fix-uid-and-gid-mount-option-ignorance.patch
+ext2-show-all-mount-options.patch
+ext3-show-all-mount-options.patch
+ext4-show-all-mount-options.patch
+remove-unsafe-from-module-struct.patch
+report-the-per-irq-statistics-on-allarches.patch
+ip2main-warning-fix.patch

 Misc new patches

+writeback-fix-periodic-superblock-dirty-inode-flushing.patch

 Fix writeback some more

+clean-up-duplicate-includes-in-drivers-spi.patch
+spi-kerneldoc-update.patch
+spi-device-setup-gets-better-error-checking.patch

 SPi updates

+remove-isdn_-is-defined-but-unused-warnings.patch
+gigaset-remove-pointless-locking.patch

 i4l

+ecryptfs-add-key-list-structure-search-keyring.patch
+ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch
+ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch
+ecryptfs-fix-tag-1-parsing-code.patch
+ecryptfs-fix-tag-3-parsing-code.patch
+ecryptfs-fix-tag-11-parsing-code.patch
+ecryptfs-fix-tag-11-writing-code.patch
+ecryptfs-update-comment-and-debug-statement.patch
+ecryptfs-printk-warning-fixes.patch

 ecryptfs feature work

+rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
+use-menuconfig-objects-rtc.patch
+no-need-to-convert-file-private_data-to-rtc-device.patch
+rtc-m48t59-driver-no_irq-mode-fixup.patch

 RTC udpates

+floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
+floppy-remove-dead-commented-out-code-from-floppy-driver.patch
+floppy-remove-register-keyword-use-from-floppy-driver.patch

 floppy.c cleanup

+ext4-ext4-journal_chksum-2620.patch
+ext4-64-bit-i_version.patch
+ext4-ext4_i_version_hi_2.patch
+ext4-i_version_update_ext4.patch
+ext4-jbd-stats-through-procfs.patch
+ext4-jbd-stats-through-procfs_fix.patch
+ext4-ext4_block_reservation_fix3.patch
+ext4-ext4_reserve_global_return_error_fix.patch
+ext4-ext4_rebalance_reservation_invariant_checking_fix.patch
+ext4-ext4_delalloc_setpageprivate_fix.patch

 ext4 tree updates

+64-bit-i_version-afs-fixes.patch

 fix it

-mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch
-swap-prefetch-avoid-repeating-entry.patch
-mm-swap-prefetch-improvements.patch
-mm-swap-prefetch-more-improvements.patch
-mm-swap-prefetch-increase-aggressiveness-and-tunability.patch

 Folded into mm-implement-swap-prefetching.patch

+clean-up-duplicate-includes-in-documentation.patch

 cleanup

-containersv10-basic-container-framework.patch
-containersv10-basic-container-framework-fix.patch
-containersv10-basic-container-framework-fix-2.patch
-containersv10-basic-container-framework-fix-3.patch
-containersv10-basic-container-framework-fix-for-bad-lock-balance-in-containers.patch
-containersv10-example-cpu-accounting-subsystem.patch
-containersv10-example-cpu-accounting-subsystem-fix.patch
-containersv10-add-tasks-file-interface.patch
-containersv10-add-tasks-file-interface-fix.patch
-containersv10-add-tasks-file-interface-fix-2.patch
-containersv10-add-fork-exit-hooks.patch
-containersv10-add-fork-exit-hooks-fix.patch
-containersv10-add-container_clone-interface.patch
-containersv10-add-container_clone-interface-fix.patch
-containersv10-add-procfs-interface.patch
-containersv10-add-procfs-interface-fix.patch
-containersv10-make-cpusets-a-client-of-containers.patch
-containersv10-make-cpusets-a-client-of-containers-whitespace.patch
-containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
-containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
-containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
-containersv10-simple-debug-info-subsystem.patch
-containersv10-simple-debug-info-subsystem-fix.patch
-containersv10-simple-debug-info-subsystem-fix-2.patch
-containersv10-support-for-automatic-userspace-release-agents.patch
-containersv10-support-for-automatic-userspace-release-agents-whitespace.patch
+task-containersv11-basic-task-container-framework.patch
+task-containersv11-add-tasks-file-interface.patch
+task-containersv11-add-fork-exit-hooks.patch
+task-containersv11-add-container_clone-interface.patch
+task-containersv11-add-procfs-interface.patch
+task-containersv11-shared-container-subsystem-group-arrays.patch
+task-containersv11-automatic-userspace-notification-of-idle-containers.patch
+task-containersv11-make-cpusets-a-client-of-containers.patch
+task-containersv11-example-cpu-accounting-subsystem.patch
+task-containersv11-simple-task-container-debug-info-subsystem.patch
-containers-implement-subsys-post_clone.patch
-containers-implement-namespace-tracking-subsystem-v3.patch
+containers-implement-namespace-tracking-subsystem.patch

 New containers patch series

+pid-namespaces-round-up-the-api.patch
+pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
+pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
+pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
+pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
+pid-namespaces-rename-child_reaper-function.patch
+pid-namespaces-use-task_pid-to-find-leaders-pid.patch
+pid-namespaces-define-is_global_init-and-is_container_init.patch
+pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
+pid-namespaces-move-alloc_pid-to-copy_process.patch

 pid namespaces

+workqueue-debug-flushing-deadlocks-with-lockdep.patch
+workqueue-debug-work-related-deadlocks-with-lockdep.patch

 workqueue stuff

+fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
+fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
+fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
+fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
+fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
+kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
+kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
+mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
+kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
+whitespace-fixes-time-syscalls.patch
+whitespace-fixes-process-accounting.patch
+whitespace-fixes-cpuset.patch
+whitespace-fixes-relayfs.patch
+whitespace-fixes-audit-filtering.patch
+whitespace-fixes-dma-channel-allocator.patch
+whitespace-fixes-fork.patch
+whitespace-fixes-module-loading.patch
+whitespace-fixes-panic-handling.patch
+whitespace-fixes-capability-syscalls.patch
+whitespace-fixes-syscall-auditing.patch
+whitespace-fixes-compat-syscalls.patch
+whitespace-fixes-system-auditing.patch
+whitespace-fixes-execution-domains.patch
+whitespace-fixes-interval-timers.patch
+whitespace-fixes-system-timers.patch
+whitespace-fixes-task-exit-handling.patch
+the-next-round-of-scheduled-oss-code-removal.patch

 cleanups

-reiser4-export-radix_tree_preload.patch
-reiser4-fix.patch
-reiser4-use-zero_user_page.patch
-reiser4-remove-typedefs.patch
-reiser4-fix-write_extent.patch
-reiser4-make-sync_inodes-non-void.patch
+reiser4-fix-extent2tail.patch
+reiser4-fix-read_tail.patch
+reiser4-fix-unix-file-readpages-filler.patch
+git-block-vs-reiser4.patch

 reiser4 consolidation and fixes

-update-page-order-at-an-appropriate-time-when-tracking-page_owner.patch
-print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
-allow-page_owner-to-be-set-on-any-architecture.patch
-allow-page_owner-to-be-set-on-any-architecture-fix.patch

 Folded into page-owner-tracking-leak-detector.patch

-beeping-patch-for-debugging-acpi-sleep.patch

 Dropped

-squash-ipc-warnings.patch
-random-warning-squishes.patch

 Dropped.


All 782 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/patch-list

