Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbXKNB7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbXKNB7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbXKNB73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:59:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47706 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754534AbXKNB7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:59:21 -0500
Date: Tue, 13 Nov 2007 17:59:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc2-mm1
Message-Id: <20071113175906.497a1a6a.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/

- In response to various people needing to get at the mm tree in a timely
  fashion I have created "MM of the minute", at

	http://userweb.kernel.org/~akpm/mmotm/

  I'll upload the patch queue there multiple times per day.  I will attempt
  to ensure that the patches in there actually apply, but they sure as heck
  won't all compile and run.

- 2.6.24-rc2-mm1 may oops during shutdown and reboot.  This is due to
  gregkh-driver-kset-convert-sys-devices-system-to-use-kset_create.patch. 
  It's a known problem, but if you have additional insights into what causes
  it, feel free to let Greg know.

- Added the pci hotplug development quilt tree to the -mm lineup, from
  http://www.kernel.org/pub/linux/kernel/people/kristen/pci-hotplug/
  (Kristen Carlson Accardi <kristen.c.accardi@intel.com>)

- Added the x86 development tree to the -mm lineup (Thomas Gleixner
  <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>)

- Probably added other git trees too - I often forget to explicitly mention
  them.



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




Changes since 2.6.23-mm1:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-arm-master.patch
 git-arm.patch
 git-avr32.patch
 git-cpufreq.patch
 git-drm.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-hrt.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-kbuild.patch
 git-kvm.patch
 git-leds.patch
 git-libata-all.patch
 git-m32r.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-net.patch
 git-netdev-all.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-parisc.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-scsi-rc-fixes.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-x86.patch
 git-newsetup.patch
 git-xfs.patch
 git-cryptodev.patch

 git trees

-consolidate-ptrace_detach.patch
-slow-down-printk-during-boot.patch
-clockevents-fix-bogus-next_event-reset-for-oneshot-broadcast-devices.patch
-acpi-fix-bdc-handling-in-drivers-acpi-sleep-procc.patch
-generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
-fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
-at91-remove-at91_lcdch.patch
-make-power-supply-class-available-for-arm-architecture.patch
-fix-auditscc-kernel-doc.patch
-cifs-build-fix.patch
-cifs-warning-fixes.patch
-agk-dm-dm-mpath-rdac-fix-init-race.patch
-agk-dm-dm-ioctl-use-constant-struct-size.patch
-agk-dm-dm-crypt-drop-device-ref-in-ctr-error-path.patch
-agk-dm-dm-crypt-missing-kfree-in-ctr-error-path.patch
-agk-dm-dm-raid1-fix-leakage.patch
-agk-dm-dm-delay-fix-ctr-error-paths.patch
-agk-dm-dm-delay-fix-status.patch
-agk-dm-dm-fix-thaw_bdev.patch
-agk-dm-dm-use-is_power_of_2.patch
-agk-dm-dm-use-kzalloc.patch
-agk-dm-kcopyd-use-mutex-instead-of-semaphore.patch
-agk-dm-dm-tidy-bio_io_error-usage.patch
-agk-dm-dm-ioctl-remove-vmalloc-void-cast.patch
-agk-dm-dm-bio_list-macro-renaming.patch
-agk-dm-dm-crypt-use-per-device-singlethread-workqueues.patch
-agk-dm-dm-crypt-add-post-processing-queue.patch
-agk-dm-dm-crypt-tidy-pending.patch
-agk-dm-dm-crypt-tidy-whitespace.patch
-agk-dm-dm-crypt-tidy-labels.patch
-agk-dm-dm-mpath-add-retry-pg-init.patch
-agk-dm-dm-mpath-add-hp-handler.patch
-agk-dm-dm-mpath-hp-retry-if-not-ready.patch
-agk-dm-dm-log-split-suspend.patch
-agk-dm-dm-raid1-add-mirror_set-to-struct-mirror.patch
-agk-dm-dm-raid1-handle-recovery-write-failures.patch
-gregkh-driver-platform-prefix-modalias-with-platform.patch
-gregkh-driver-howto-update-ja_jp-howto-with-latest-changes.patch
-gregkh-driver-driver-core-make-sysfs-uevent-attributes-static.patch
-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
-gregkh-driver-driver-core-add-config_uevent_helper_path.patch
-gregkh-driver-driver-core-remove-subsys_set_kset.patch
-gregkh-driver-driver-core-remove-kset_set_kset_s.patch
-gregkh-driver-driver-core-remove-subsys_put.patch
-gregkh-driver-driver-core-remove-subsys_get.patch
-gregkh-driver-driver-core-remove-put_bus.patch
-gregkh-driver-driver-core-remove-get_bus.patch
-gregkh-driver-kobjects-fix-up-improper-use-of-the-kobject-name-field.patch
-gregkh-driver-cdev-remove-unneeded-setting-of-cdev-names.patch
-gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
-gregkh-driver-driver-core-clean-up-removed-functions-from-the-documentation.patch
-gregkh-driver-debugfs-helper-for-decimal-challenged.patch
-gregkh-driver-sysfs-filec-use-mutex-instead-of-semaphore.patch
-gregkh-driver-sysfs-cleanup-semaphoreh.patch
-gregkh-driver-sysfs-remove-first-pass-at-shadow-directory-support.patch
-gregkh-driver-sysfs-cosmetic-changes-in-sysfs_lookup.patch
-gregkh-driver-sysfs-simplify-sysfs_rename_dir.patch
-gregkh-driver-sysfs-make-sysfs_add-remove_one-call-link-unlink_sibling-implictly.patch
-gregkh-driver-sysfs-make-sysfs_add_one-automatically-check-for-duplicate-entry.patch
-gregkh-driver-sysfs-make-sysfs_addrm_finish-return-void.patch
-gregkh-driver-dmi-id-use-dynamic-sysfs-attributes.patch
-gregkh-driver-dmi-id-possible-cleanup.patch
-gregkh-driver-convert-from-class_device-to-device-for-drivers-video.patch
-gregkh-driver-convert-from-class_device-to-device-in-drivers-char.patch
-gregkh-driver-no-uevent-without-hotplug.patch
-gregkh-driver-uevent-bus-driver.patch
-gregkh-driver-kobject_uevent_trivial.patch
-gregkh-driver-fix-firmware-class-name-collision.patch
-gregkh-driver-drivers-base-power-make-2-functions-static.patch
-gregkh-driver-sysfs-fix-typos-in-fs-sysfs-filec.patch
-gregkh-driver-sysdev-remove-global-sysdev-drivers-list.patch
-gregkh-driver-driver-core-make-platform_deviceid-an-int.patch
-gregkh-driver-sysfs-fix-i_mutex-locking-in-sysfs_get_dentry.patch
-gregkh-driver-sysfs-move-all-of-inode-initialization-into-sysfs_init_inode.patch
-gregkh-driver-sysfs-remove-sysfs_instantiate.patch
-gregkh-driver-sysfs-use-kill_anon_super.patch
-gregkh-driver-sysfs-make-sysfs_mount-static.patch
-gregkh-driver-sysfs-in-sysfs_lookup-don-t-open-code-sysfs_find_dirent.patch
-gregkh-driver-sysfs-simplify-readdir.patch
-gregkh-driver-sysfs-rewrite-sysfs_drop_dentry.patch
-gregkh-driver-sysfs-introduce-sysfs_rename_mutex.patch
-gregkh-driver-sysfs-simply-sysfs_get_dentry.patch
-gregkh-driver-sysfs-remove-s_dentry.patch
-gregkh-driver-sysfs-rewrite-rename-in-terms-of-sysfs-dirents.patch
-gregkh-driver-sysfs-rewrite-sysfs_move_dir-in-terms-of-sysfs-dirents.patch
-gregkh-driver-ptycount-parm.patch
-gregkh-driver-sysfs-spit-a-warning-to-users-when-they-try-to-create-a-duplicate-sysfs-file.patch
-gregkh-driver-sysfs-fix-comments-of-sysfs_add-remove_one.patch
-gregkh-driver-sysfs-fix-sysfs_chmod_file-such-that-it-updates-sd-s_mode-too.patch
-gregkh-driver-sysfs-clean-up-header-files.patch
-gregkh-driver-sysfs-kill-sysfs_update_file.patch
-gregkh-driver-sysfs-reposition-sysfs_dirent-s_mode.patch
-gregkh-driver-sysfs-kill-unnecessary-sysfs_get-in-open-paths.patch
-gregkh-driver-sysfs-kill-unnecessary-null-pointer-check-in-sysfs_release.patch
-gregkh-driver-sysfs-make-bin-attr-open-get-active-reference-of-parent-too.patch
-gregkh-driver-sysfs-make-s_elem-an-anonymous-union.patch
-gregkh-driver-sysfs-open-code-sysfs_attach_dentry.patch
-gregkh-driver-sysfs-make-sysfs_root-a-regular-directory-dirent.patch
-gregkh-driver-sysfs-move-sysfs_dirent-s_children-into-sysfs_dirent-s_dir.patch
-gregkh-driver-sysfs-implement-sysfs_open_dirent.patch
-gregkh-driver-sysfs-move-sysfs-file-poll-implementation-to-sysfs_open_dirent.patch
-gregkh-driver-driver-core-remove-subsystem_init.patch
-gregkh-driver-kset-add-some-kerneldoc-to-help-describe-what-these-strange-things-are.patch
-gregkh-driver-kobject-update-the-copyrights.patch
-drm-via-invalid-device-ids-removal.patch
-git-dvb-rename-videobuf_qtype_opscopy_to_user.patch
-git-dvb-vs-i2c-tree.patch
-v4l-stk11xx-add-a-new-webcam-driver.patch
-v4l-stk11xx-use-array_size-in-another-2-cases.patch
-v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
-v4l-stk11xx-add-static-to-tables.patch
-jdelvare-i2c-i2c-kill-struct-i2c_device_id.patch
-jdelvare-i2c-i2c-new-style-devices-can-support-wakeup-flags.patch
-jdelvare-i2c-i2c-core-make-some-code-static.patch
-jdelvare-i2c-i2c-tps65010-new-style-part-1.patch
-jdelvare-i2c-i2c-tps65010-new-style-part-2.patch
-jdelvare-i2c-i2c-ibm_iic-numbered-adapter.patch
-jdelvare-i2c-i2c-davinci-new-bus-driver.patch
-jdelvare-i2c-i2c-pcf8574-no-init.patch
-jdelvare-i2c-i2c-document-i2c_msg.patch
-jdelvare-i2c-i2c-i801-tolapai-support.patch
-jdelvare-i2c-i2c-bfin_twi-remove-useless-mutex.patch
-jdelvare-i2c-i2c-stub-add-multiple-chip-support.patch
-jdelvare-i2c-i2c-dev-rejects-i2c_m_recv_len.patch
-jdelvare-i2c-i2c-remove-nop-algo_control-methods.patch
-jdelvare-i2c-i2c-remove-algo_control.patch
-jdelvare-i2c-i2c-dev-move-interfaces-to-i2c-dev-h.patch
-jdelvare-i2c-i2c-at91-mark-as-broken.patch
-jdelvare-i2c-i2c-rename-pec-func-bit.patch
-jdelvare-i2c-i2c-au1550-fix-misused-register.patch
-jdelvare-i2c-i2c-nforce2-timeout-cleanup.patch
-jdelvare-i2c-i2c-nforce2-implement-abort.patch
-jdelvare-i2c-i2c-nforce2-declare-pec-functionality.patch
-applesmc-for-mac-pro-2-x-quad-core.patch
-applesmc-for-mac-pro-2-x-quad-core-fix.patch
-ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
-ia64-perfmon-remove-exit_pfm_fs.patch
-hdaps-switch-to-using-input-polldev.patch
-adbhid-produce-all-capslock-key-events.patch
-keyboard-capsshift-lock.patch
-console-keyboard-events-and-accessibility.patch
-git-jg-warning-fixes.patch
-git-jg-misc-powernow-fix.patch
-libata-implement-ata_wait_after_reset.patch
-scsi-expose-an-support-to-user-space.patch
-libata-expose-an-to-user-space.patch
-ide-atiixp-sb700-2-ide-channels.patch
-ide-hpt366-mwdma-filter-for-sata-cards-take-2.patch
-ide-ide-add-platform-ide-driver.patch
-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
-ide-pdc202xx_new-switch-to-using-pci_get_slot-take-2.patch
-ide-ide-make-jmicron-match-vendor-and-device-class.patch
-ide-ide-call-udma_filter-before-resorting-to-the-ultradma-mask.patch
-ide-ide-add-missing-ide-rate-filter-calls.patch
-ide-ide-mode-limiting-fixes-for-user-requested-speed-changes.patch
-ide-sis5513-udma-filter.patch
-ide-ide-remove-ide-rate-filter-from-speedproc-take-2.patch
-ide-ide-kconfig-face-lift.patch
-ide-ide-add-ide-set-pio-take-4.patch
-ide-amd74xx-via82cxxx-use-ide-tune-dma.patch
-ide-sgiioc4-use-ide-tune-dma.patch
-ide-icside-fix-speedproc-for-unsupported-modes-take-5.patch
-ide-ide-pmac-pio-mode-setup-fixes-take-3.patch
-ide-sc1200-remove-redundant-warning-message.patch
-ide-cs5520-dont-enable-vdma-in-speedproc.patch
-ide-siimage-fix-set-pio-method-to-select-pio-data-transfer.patch
-ide-alim15x3-pio-mode-setup-fixes.patch
-ide-it8213-piix-slc90e66-dont-change-dma-settings-for-pio-modes.patch
-ide-sis5513-dont-change-udma-settings-for-pio-modes.patch
-ide-ide-use-only-set-pio-mode-for-programming-pio-modes-take-2.patch
-ide-ide-pmac-dont-check-kauai-lookup-timing-return-value.patch
-ide-ide-pmac-fix-pmac-ide-tune-chipset.patch
-ide-ide-pmac-fix-set-timings-mdma.patch
-ide-ide-pmac-remove-control-register-messing-from-pmac-ide-dma-check.patch
-ide-ide-pmac-remove-pmac-ide-dma-enable-take-2.patch
-ide-ide-add-__ide-wait-stat-helper.patch
-ide-ide-pmac-ide-do-setfeature-remove-pre-wait.patch
-ide-ide-pmac-use-__ide-wait-stat.patch
-ide-ide-pmac-remove-nien-clearing-from-pmac-ide-do-setfeature.patch
-ide-ide-pmac-remove-pmac-ide-do-setfeature-take-2.patch
-ide-ide-pmac-use-ide-tune-dma-take-2.patch
-ide-ide-pmac-fix-pio-setup-and-enable-autotune.patch
-ide-icside-use-ide-tune-dma.patch
-ide-au1xxx-fix-au1xxx-fix-set-pio-mode.patch
-ide-amd74xx-via82cxxx-check-ide-config-drive-speed-return-value.patch
-ide-cs5535-check-ide-config-drive-speed-return-value.patch
-ide-pdc202xx_new-check-ide-config-drive-speed-return-value.patch
-ide-ide-move-ide-config-drive-speed-to-upper-layers-take-2.patch
-ide-ide-change-master-slave-identify-order.patch
-ide-ide-remove-config-idedma-ivb.patch
-ide-cs5535-add-missing-dma-base-check.patch
-ide-sgiioc4-add-missing-dma-base-check.patch
-ide-cs5520-fix-dma-base-equal-zero-handling.patch
-ide-sc1200-fix-dma-base-equal-zero-handling.patch
-ide-alim15x3-remove-redundant-m5229_revision-check.patch
-ide-hpt366-always-tune-pio.patch
-ide-sis5513-dma-setup-fixes.patch
-ide-sis5513-always-tune-pio.patch
-ide-aec62xx-always-tune-pio.patch
-ide-slc90e66-always-tune-pio.patch
-ide-ide-cris-always-tune-pio.patch
-ide-cs5530-always-tune-pio.patch
-ide-sc1200-always-tune-pio.patch
-ide-atiixp-dma-setup-fixes.patch
-ide-it8213-piix-slc90e66-remove-dma-2-pio.patch
-ide-au1xxx-use-ide-tune-dma.patch
-ide-ide-remove-drive-init-speed-zeroing.patch
-ide-ide-remove-ide-use-fast-pio.patch
-ide-cs5530-sc1200-add-pio-autotune-fallback-to-ide-dma-check.patch
-ide-sl82c105-add-pio-autotune-fallback-to-ide-dma-check.patch
-ide-ide-cris-add-pio-autotune-fallback-to-ide-dma-check.patch
-ide-ide-pmac-add-pio-autotune-fallback-to-ide-dma-check.patch
-ide-ide-remove-ide-dma-check-take-2.patch
-ide-it8213-piix-slc90e66-de-couple-pio-and-udma-modes.patch
-ide-sis5513-clear-prefetch-and-postwrite-for-atapi-devices.patch
-ide-sis5513-remove-proc-ide-sis.patch
-ide-ide-use-pci-vdevice.patch
-ide-ide-remove-config-blk-dev-idedma-forced.patch
-ide-ide-remove-idex-autodma-kernel-parameter.patch
-ide-ide-remove-hwif-autodma-and-drive-autodma.patch
-ide-ide-add-hdx-nodma-kernel-parameter.patch
-ide-ide-remove-config-idedma-onlydisk.patch
-ide-ide-pci-generic-add-declare-generic-pci-dev-macro.patch
-ide-amd74xx-via82cxxx-dont-initialize-drive-dn.patch
-ide-amd74xx-remove-ide-proc-amd74xx.patch
-ide-ide-add-ide-hflag-no-atapi-dma.patch
-ide-ide-pci-add-ide-hflag-bootable-flag.patch
-ide-ide-pci-add-ide-hflag-no-dma-and-no-autodma-flags.patch
-ide-ide-remove-init-setup-dma-from-ide-pci-device-t.patch
-ide-ide-add-ide-hflag-no-lba48-and-ide-hflag-no-lba48-dma.patch
-ide-pdc202xx_old-remove-broken-swdma-support.patch
-ide-ide-add-mwdma-mask-and-swdma-mask-to-ide-pci-device-t-take-2.patch
-ide-amd74xx-omit-pci_revision_id-read.patch
-ide-cmd64x-use-dev-revision.patch
-ide-ide-pci-use-pci-dev-revision.patch
-ide-ide-use-io-ops-directly-part-2-take-2.patch
-ide-aec62xx-remove-init-setup.patch
-ide-cmd64x-remove-init-setup.patch
-ide-hpt366-remove-init-setup.patch
-ide-pdc202xx_new-remove-init-setup.patch
-ide-pdc202xx_old-remove-init-setup.patch
-ide-scc_pata-remove-init-setup.patch
-ide-serverworks-remove-init-setup.patch
-ide-ide-remove-init-setup-from-ide-pci-device-t.patch
-ide-aec62xx-no-need-to-disable-udma-in-init-hwif-method-for-atp850uf.patch
-ide-pdc202xx_new-add-declare-pdcnew-dev-macro.patch
-ide-pdc202xx_old-add-declare-pdc2026x-dev-macro.patch
-ide-piix-add-declare-ich-dev-macro.patch
-ide-ide-add-ide-hflag-error-stops-fifo.patch
-ide-ide-add-ide-hflag-serialize.patch
-ide-ide-add-ide-hflag-legacy-irqs.patch
-ide-alim15x3-always-tune-pio.patch
-ide-cs5520-always-tune-pio.patch
-ide-cy82c693-always-tune-pio.patch
-ide-opti621-always-tune-pio.patch
-ide-triflex-always-tune-pio.patch
-ide-ide-set-drive-autotune-in-ide-pci-setup-ports.patch
-ide-cmd64x-always-set-hwif-chipset-for-cmd646.patch
-ide-ide-fix-disabled-ports-reporting-for-pci-controllers.patch
-ide-rz1000-set-serialized-flag-only-if-mate-interface-exists.patch
-ide-serverworks-remove-dead-code-from-svwks-set-dma-mode.patch
-ide-ide-add-hwif-register-devices-helper.patch
-ide-ide-remove-unused-next-field-from-ide-pci-device-t.patch
-ide-ide-add-chipset-field-to-ide-pci-device-t.patch
-ide-ide-add-ide-hflag-force-legacy-irqs.patch
-ide-ide-add-ide-hflag-rqsize-256.patch
-ide-ide-add-ide-hflag-io-32bit-unmask-irqs-host-flags.patch
-ide-alim15x3-fix-cd_rom-dma-and-pio-fifo-settings-setup.patch
-ide-alim15x3-use-host-flags-and-udma-mask-fields-from-ide-pci-device-t.patch
-ide-aec62xx-remove-aec62xx-dma-lost-irq.patch
-ide-siimage-separate-pata-and-sata-methods.patch
-ide-ide-add-fixup-method-to-ide-hwif-t.patch
-ide-ide-add-ide-device-add.patch
-ide-maintainers-mark-ide-scsi-as-orhpan.patch
-ide-ide-add-ide-find-port-helper.patch
-ide-ide-remove-redundant-comments-from-ide-h.patch
-ide-ide-add-config-ide-arch-obsolete-init.patch
-ide-ide_platform-set-hwif-chipset.patch
-ide-ide-fix-ide-register-hw-to-check-hwif-io_ports.patch
-ide-icside-use-ec-dma-directly.patch
-ide-ide-remove-write-only-hwif-hw.patch
-ide-au1xxx-ide-set-autotune-and-no-io-32bit-also-for-the-slave-device.patch
-ide-dtc2278-set-pio-mask-also-for-the-second-port.patch
-ide-via82cxxx-keep-local-ide-pci-device-t-copy.patch
-ide-ide-replace-ide-pci-device-by-struct-ide-port-info.patch
-ide-ide-constify-struct-ide-port-info.patch
-ide-ali14xx-fix-deadlock-on-error-handling.patch
-ide-dtc2278-fix-deadlock-on-error-handling.patch
-ide-qd65xx-fix-deadlock-on-error-handling.patch
-ide-opti621-fix-deadlock-on-error-handling.patch
-ide-slc90e66-fix-deadlock-on-error-handling.patch
-ide-cmd640-fix-deadlock-on-error-handling.patch
-ide-ht6560b-fix-deadlock-on-error-handling.patch
-ide-ide-take-ide-lock-for-prefetch-disable-enable-in-do-special.patch
-ide-cs5530-remove-needless-ide-lock-taking.patch
-ide-ide-enhance-ide-setup-pci-noise.patch
-ide-ide-use-__ide_end_request-in-ide_end_dequeued_request.patch
-ide-ide-remove-dead-code-from-ide-driveid-update.patch
-ide-ide-remove-stale-comments-from-ide-taskfile-c.patch
-ide-fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
-ide-fix-ide-ide-remove-ide-dma-check.patch
-ide-ide-unexport-noautodma.patch
-ide-ide-pci-bmdma-initialization-fixes-take-2.patch
-ide-qd65xx-remove-pointless-qd-read-write-reg-take-2.patch
-mmc-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
-mtd-alaudac-warning-fix.patch
-git-mtd-vs-powerpc.patch
-mtd-fix-ctrl-alt-del-cant-reboot-for-intel-flash-bug.patch
-blackfin-on-chip-nand-flash-controller-driver.patch
-ircomm-discovery-indication-simplification.patch
-git-net-fix-qeth_main.patch
-wol-bugfix-for-3c59xc.patch
-git-net-vs-git-nfs.patch
-clean-up-duplicate-includes-in-fs-ntfs.patch
-pa-risc-use-page-allocator-instead-of-slab-allocator.patch
-parisc-extern-inline-static-inline.patch
-use-menuconfig-objects-pcmcia.patch
-pxa2xx-pcmcia-timing-issue-on-ipaq-h5550.patch
-move-a-few-definitions-to-au1000_xxs1500c.patch
-move-a-few-definitions-to-au1000_xxs1500c-fix.patch
-pcmcia-cistpl-use-get_unaligned-in-cis-parsing.patch
-add-support-for-pcmcia-card-sierra-wireless-ac850.patch
-introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
-pcmcia-use-dma_mask_none-for-the-default-for-all.patch
-serial_txx9-cleanup-includes.patch
-8250_pci-autodetect-mainpine-cards.patch
-8250_pci-autodetect-mainpine-cards-fix.patch
-provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch
-wake-up-from-a-serial-port.patch
-serial_txx9-use-upf_fixed_port.patch
-gregkh-pci-pci-hotplug-cpqphp_ctrlc-kmalloc-memset-conversion-to-kzalloc.patch
-gregkh-pci-pciehp-remove-config_hotplug_pci_pcie_poll_event_mode.patch
-gregkh-pci-pci-hotplug-pciehp-dont-check-bridge-control-on-remove.patch
-gregkh-pci-pci-hotplug-pciehp-request-control-over-pci-express-capability-as-well-as-native-hotplug.patch
-gregkh-pci-pciehp-remove-dbg_xxx_routine.patch
-gregkh-pci-pciehp-remove-trailing-whitespace-from-pciehp_hpcc.patch
-gregkh-pci-pciehp-remove-trailing-whitespace-from-pciehp_corec.patch
-gregkh-pci-pciehp-remove-trailing-whitespace-from-pciehp_ctrlc.patch
-gregkh-pci-pciehp-remove-trailing-whitespace-form-pciehp_pcic.patch
-gregkh-pci-pciehp-minor-cleanups-for-pciehp_hpcc.patch
-gregkh-pci-pci-is_power_of_2-in-drivers-pci-pcic.patch
-gregkh-pci-pci-hotplug-ibmphp-convert-to-kthread.patch
-gregkh-pci-pci-hotplug-cpqphp-convert-to-kthread.patch
-gregkh-pci-dma_free_coherent-needs-irqs-enabled.patch
-gregkh-pci-pci-pci_get_device-call-from-interrupt-in-reboot-fixups.patch
-gregkh-pci-i386-add-support-for-picopower-irq-router.patch
-gregkh-pci-pci-add-missing-pci-capability-ids.patch
-gregkh-pci-cpqphp-use-pci_class_revision-instead-of-pci_revision_id-for-read.patch
-gregkh-pci-pci-quirk-amd_8131_mmrbc-omit-reading-pci-revision-id.patch
-gregkh-pci-pci-quirk_vt82c586_acpi-omit-reading-pci-revision-id.patch
-gregkh-pci-pci-re-enable-onboard-sound-on-msi-k8t-neo2-fir.patch
-gregkh-pci-pci-remove-no-longer-correct-documentation-regarding-msi-vector-assignment.patch
-gregkh-pci-pci-i386-compaq-evo-n800c-needs-pci-bus-renumbering.patch
-gregkh-pci-pci-fix-incorrect-argument-order-to-list_add_tail-in-pci-dynamic-id-code.patch
-gregkh-pci-msi-use-correct-data-offset-for-32-bit-msi-in-read_msi_msg.patch
-gregkh-pci-pci-fix-ide-legacy-mode-resources.patch
-gregkh-pci-pci-implement-pci-noaer.patch
-gregkh-pci-pci-use-size-stored-in-proc_dir_entry-for-proc-bus-files.patch
-gregkh-pci-pci-write-file-size-to-inode-on-proc-bus-file-write.patch
-gregkh-pci-pci-remove-transparent-bridge-sizing.patch
-gregkh-pci-pci-skip-isa-ioresource-alignment-on-some-systems.patch
-gregkh-pci-pci-avoid-p2p-prefetch-window-for-expansion-roms.patch
-gregkh-pci-pci-use-_crs-for-pci-resource-allocation.patch
-git-jg-misc-vs-gregkh-pci-pci-skip-isa-ioresource-alignment-on-some-systems.patch
-qla2xxx-printk-fixes.patch
-pci-error-recovery-symbios-scsi-base-support.patch
-pci-error-recovery-symbios-scsi-first-failure.patch
-scsi-send-media-state-change-modification-events.patch
-scsi-use-notifier-chain-for-asynchronous-event.patch
-sparc-fix-build-due-to-termios-changes.patch
-partially-fix-up-the-lookup_one_noperm-mess.patch
-gregkh-usb-usb-remove-unneeded-pointer-intf-from-speedtch_upload_firmware.patch
-gregkh-usb-usb-clean-up-duplicate-includes-in-drivers-usb.patch
-gregkh-usb-usblp-implement-the-enospc-convention.patch
-gregkh-usb-usblp-make-use-of-urb_free_buffer.patch
-gregkh-usb-usb-ohci-handles-more-zfmicro-quirks.patch
-gregkh-usb-usb-remove-dead-references-to-safe_serial-config-variables.patch
-gregkh-usb-usb-usb_gadgeth-whitespace-fixes.patch
-gregkh-usb-usb-storage-usbat_check_status-fix-check-after-use.patch
-gregkh-usb-usb-add-urb-ep.patch
-gregkh-usb-usb-add-ep-enable.patch
-gregkh-usb-usb-add-direction-bit-to-urb-transfer_flags.patch
-gregkh-usb-usb-avoid-using-urb-pipe-in-usbcore.patch
-gregkh-usb-usb-address-0-handling-during-device-initialization.patch
-gregkh-usb-usb-avoid-urb-pipe-in-usbfs.patch
-gregkh-usb-usb-avoid-urb-pipe-in-usbmon.patch
-gregkh-usb-usb-cleanup-for-previous-patches.patch
-gregkh-usb-usb-update-spinlock-usage-for-root-hub-urbs.patch
-gregkh-usb-usb-separate-out-endpoint-queue-management-and-dma-mapping-routines.patch
-gregkh-usb-usb-add-drivers-usb-misc-iowarriorc-to-the-makefile.patch
-gregkh-usb-usb-gadget-gadget_is_-dualspeed-otg-predicates-and-cleanup.patch
-gregkh-usb-usb-gadget-ethernet-gadget-cleanups-shrinkage.patch
-gregkh-usb-usb-gadget-gmidi-cleanups.patch
-gregkh-usb-usb-gadget-serial-gadget-cleanups.patch
-gregkh-usb-usb-gadget-file-storage-gadget-cleanups.patch
-gregkh-usb-usb-gadget-gadget-zero-cleanups.patch
-gregkh-usb-usb-introduce-usb_device-authorization-bits.patch
-gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-hosts.patch
-gregkh-usb-usb-cleanup-usb_register_bus-and-hook-up-sysfs-group.patch
-gregkh-usb-usb-initialize-authorization-and-wusb-bits-in-usb-devices.patch
-gregkh-usb-usb-usb_set_configuration-obeys-authorization.patch
-gregkh-usb-usb-usb_get_configuration-obeys-authorization.patch
-gregkh-usb-usb-usb_probe_interface-obeys-authorization.patch
-gregkh-usb-usb-usb_generic_probe-obeys-authorization.patch
-gregkh-usb-usb-split-usb_new_device-for-clarity-and-refactoring.patch
-gregkh-usb-usb-introduce-usb_authorize-deauthorize.patch
-gregkh-usb-usb-hook-up-device-authorization-to-sysfs.patch
-gregkh-usb-usb-document-device-authorization.patch
-gregkh-usb-usb-choose_configuration.patch
-gregkh-usb-usb-usb_release_interface-static.patch
-gregkh-usb-usb-make-hcds-responsible-for-managing-endpoint-queues.patch
-gregkh-usb-usb-don-t-touch-sysfs-stuff-when-altsetting-is-unchanged.patch
-gregkh-usb-usb-cleanups-for-g_file_storage.patch
-gregkh-usb-usb-sisusb2vga-whitespace-cleanups.patch
-gregkh-usb-usb-sisusb2vga-remove-if-0-ed-code.patch
-gregkh-usb-usb-sisusb2vga-mis-spelled-word.patch
-gregkh-usb-usb-sisusb2vga-lindent-drivers-usb-misc-sisusbvga-sisusbh.patch
-gregkh-usb-usb-sisusb2vga-lindent-drivers-usb-misc-sisusbvga-sisusb_initc.patch
-gregkh-usb-usb-sisusb2vga-lindent-drivers-usb-misc-sisusbvga-sisusb_inith.patch
-gregkh-usb-usb-sisusb2vga-lindent-drivers-usb-misc-sisusbvga-sisusb_structh.patch
-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
-gregkh-usb-usblp-mutex-in-usblp_check_status.patch
-gregkh-usb-usblp-cosmetics.patch
-gregkh-usb-usbmon-update-pipe-removal-to-suit-my-taste.patch
-gregkh-usb-usbmon-drop-dma-mapping-for-setup-packet.patch
-gregkh-usb-usbmon-smooth-the-core-code.patch
-gregkh-usb-usblp-fix-a-double-kfree.patch
-gregkh-usb-usb-kl5kusb105-witch-to-new-speed-api.patch
-gregkh-usb-usb-mct_u232-convert-to-proper-speed-handling-api-fix.patch
-gregkh-usb-usb-ftdi-elanc-kmalloc-memset-conversion-to-kzalloc.patch
-gregkh-usb-usb-remove-redundant-memset-from-amd5536udc.patch
-gregkh-usb-usb-missing-test-for-eshutdown-in-adutux-driver.patch
-gregkh-usb-usb-ark3116c-fix-check-after-use.patch
-gregkh-usb-usb-remove-unnecessary-tests-in-isp116x-and-sl811.patch
-gregkh-usb-ueagle-eagle-iv-chipset-support.patch
-gregkh-usb-ueagle-devolo-and-elsa-chipsets-support.patch
-gregkh-usb-ueagle-allow-user-to-choose-input-interface-alternate-setting.patch
-gregkh-usb-ueagle-avoid-keyboard-driver-blocking.patch
-gregkh-usb-ueagle-do-not-sleep-when-device-is-disconnected.patch
-gregkh-usb-ueagle-cosmetic.patch
-gregkh-usb-usb-ehci-restart-speedup.patch
-gregkh-usb-usb-minor-fixes-for-r8a66597-driver.patch
-gregkh-usb-usb-remove-iso-status-value-in-uhci-hcd.patch
-gregkh-usb-usb-centralize-eremoteio-handling.patch
-gregkh-usb-usb-add-urb-unlinked-field.patch
-gregkh-usb-usb-ftdi_sio-handle-ft232rl-devices-like-ft232bm-devices.patch
-gregkh-usb-usb-fix-mistake-in-usb_hcd_giveback_urb.patch
-gregkh-usb-usb-avoid-the-donelist-after-an-error-in-ohci-hcd.patch
-gregkh-usb-usb-cp2101-coding-style-police.patch
-gregkh-usb-usb-kobil_sct-rework-driver.patch
-gregkh-usb-usb-less-restrictive-command-checking-in-g-file-storage.patch
-gregkh-usb-usb-berry-charge-memory-leak.patch
-gregkh-usb-usb-serial-show-port-number-in-sysfs.patch
-gregkh-usb-usb-usbmon-doc-update-mention-new-wildcard-bus.patch
-gregkh-usb-usb-avoid-redundant-cast-of-kmalloc-return-value-in-oti-6858-driver.patch
-gregkh-usb-usb-serial-pl2303-support-for-benq-siemens-mobile-phone-ef81.patch
-gregkh-usb-usb-reorganize-urb-status-use-in-dummy-hcd.patch
-gregkh-usb-usb-reorganize-urb-status-use-in-ehci-hcd.patch
-gregkh-usb-usb-reorganize-urb-status-use-in-ohci-hcd.patch
-gregkh-usb-usb-reorganize-urb-status-use-in-sl811-hcd.patch
-gregkh-usb-usb-reorganize-urb-status-use-in-r8a66597-hcd.patch
-gregkh-usb-usb-reorganize-urb-status-use-in-usbmon.patch
-gregkh-usb-usb-eliminate-urb-status-usage.patch
-gregkh-usb-usb-get-rid-of-urb-lock.patch
-gregkh-usb-usb-remove-traces-of-urb-status-from-usbcore.patch
-gregkh-usb-usb-fix-location-of-statement-label-in-dummy-hcd.patch
-gregkh-usb-usb-usb-storage-initialize-huawei-e220-properly.patch
-gregkh-usb-usb-elan-u132-host-controller-driver-convert-sw_lock-to-mutex.patch
-gregkh-usb-usb-fix-errornous-assumption-in-the-usb-serial-framework-revealed-by-iuu_phoenix.patch
-gregkh-usb-usb-sisusbvga-fix-bug-and-build-warnings.patch
-gregkh-usb-usb-amd5536-use-pdev-revision.patch
-gregkh-usb-usb-get-rid-of-annoying-endpoint-release-message.patch
-gregkh-usb-usb-move-decision-to-ignore-freeze-events.patch
-gregkh-usb-usb-break-apart-flush_endpoint-and-disable_endpoint.patch
-gregkh-usb-usb-flush-outstanding-urbs-when-suspending.patch
-gregkh-usb-usb-usb-skeleton-leaking-locks-on-open.patch
-gregkh-usb-usb-always-visit-drivers-usb-misc.patch
-gregkh-usb-usb-fix-double-frees-in-error-code-paths-of-ipaq-driver.patch
-gregkh-usb-usb-fix-limited_power-setting-mistake-in-hubc.patch
-gregkh-usb-usb-unusual_devs-update-for-nokia-6131.patch
-gregkh-usb-usb-don-t-propagate-freeze-or-prethaw-suspends.patch
-gregkh-usb-usb-remove-usb_quirk_no_autosuspend.patch
-gregkh-usb-usb-unusual_devs-modification-for-nikon-d200.patch
-gregkh-usb-usb-cp2101c-add-additional-device-id.patch
-gregkh-usb-usb-cxacru-use-appropriate-logging-for-errors.patch
-gregkh-usb-usb-driver-for-ch341-usb-serial-adaptor.patch
-gregkh-usb-usb-usb-serial-ch341c-make-4-functions-static.patch
-gregkh-usb-usb-r8a66597-hcd-fix-class-or-vendor-request.patch
-gregkh-usb-usb-r8a66597-hcd-fix-endian-problem.patch
-gregkh-usb-usb-r8a66597-hcd-fix-driver-removing.patch
-gregkh-usb-usb-fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
-gregkh-usb-usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race.patch
-gregkh-usb-usb-drivers-usb-misc-sisusbvga-sisusbc-kill-two-unused-variables.patch
-gregkh-usb-usb-serial-gadget-disable-endpoints-on-unload.patch
-gregkh-usb-usb-export-urb-statistics-for-powertop.patch
-gregkh-usb-usb-move-linux-usb_gadgeth-to-linux-usb-gadgeth.patch
-gregkh-usb-usb-re-remove-linux-usb_sl811h.patch
-gregkh-usb-usb-unusual_devs-entry-for-nikon-dsc-d2xs.patch
-gregkh-usb-usb-visor-termios-bits.patch
-gregkh-usb-usb-funsoft-fix-termios.patch
-git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
-revert-x86_64-mm-cpa-einval.patch
-fix-x86_64-mm-sched-clock-share.patch
-agp-fix-race-condition-between-unmapping-and-freeing-pages.patch
-x86_64-mce-poll-at-idle_start-and-printk-fix.patch
-geode-mfgpt-support-for-geode-class-machines.patch
-geode-mfgpt-clock-event-device-support.patch
-i386-convert-mm_context_t-semaphore-to-a-mutex.patch
-dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
-x86-make-io-apic-not-connected-pin-print-complete.patch
-intel_cacheinfo-misc-section-annotation-fixes.patch
-intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
-i386-stop-bogus-nmi-softlockup-warnings-in-show_mem.patch
-x86-64-disable-local-apic-timer-use-on-amd-systems-with-c1e.patch
-clockevents-remove-unused-inline-function.patch
-clockevents-allow-build-without-runtime-use.patch
-x86_64-consolidate-tsc-calibration.patch
-i386-prepare-sharing-hpet-code.patch
-i386-hpet-add-x8664-hpet-bits.patch
-i386-prepare-sharing-pit-code.patch
-x86_64-use-i386-i8253-h.patch
-x86_64-preparatory-apic-set-lvtt.patch
-x86_64-apic-remove-bogus-pit-synchronization.patch
-x86_64-apic-shuffle-calibration-around.patch
-x86_64-apic-calibration-remove-divisor.patch
-x86_64-apic-change-setup-calling-convention.patch
-x86_64-apic-remove-nested-irq-disable.patch
-x86_64-prep-idle-loop-for-dynticks.patch
-x86_64-apic-add-clockevents-functions.patch
-x86_64-convert-to-clockevents.patch
-x86_64-remove-unused-code.patch
-x86_64-cleanup-apic-c.patch
-jiffies-remove-unused-macros.patch
-acpi-remove-the-useless-ifdef-code.patch
-i386-pit-remove-the-useless-ifdefs.patch
-i386-hpet-sharing-optimize.patch
-ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
-ich-force-hpet-restructure-hpet-generic-clock-code.patch
-ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
-ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
-ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
-ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
-ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
-x86-fix-cpu_to_node-references.patch
-x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
-x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
-x86-acpi-use-cpu_physical_id.patch
-i386-visws-extern-inline-static-inline.patch
-i386-cleanup-struct-irqaction-initializers.patch
-x86_64-cleanup-struct-irqaction-initializers.patch
-asm-i386-ioh-fix-constness.patch
-hpet-force-enable-on-vt8235-37-chipsets.patch
-x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron.patch
-x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
-x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is.patch
-voyager-dont-try-to-support-unprocessor-builds.patch
-x86_64-nx-bit-handling-in-change_page_attr.patch
-x86-64-calgary-fix-calgary=disable=busnum-for-calioc2.patch
-x86-64-calgary-get-rid-of-translate_phb.patch
-x86_64-vdso-linker-script-cleanup.patch
-x86_64-vdso-put-vars-in-rodata.patch
-x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
-convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
-convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64.patch
-convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64-fix.patch
-convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch
-convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix.patch
-convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch
-convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64.patch
-x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch
-optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
-optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-sparc64-fix.patch
-sparsemem-clean-up-spelling-error-in-comments.patch
-sparsemem-record-when-a-section-has-a-valid-mem_map.patch
-sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
-generic-virtual-memmap-support-for-sparsemem.patch
-generic-virtual-memmap-support-for-sparsemem-fix.patch
-generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
-generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
-generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
-generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
-x86_64-sparsemem_vmemmap-2m-page-size-support.patch
-x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
-x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
-ia64-sparsemem_vmemmap-16k-page-size-support.patch
-ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
-sparc64-sparsemem_vmemmap-support.patch
-sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
-ppc64-sparsemem_vmemmap-support.patch
-ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
-ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix.patch
-ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
-slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
-during-vm-oom-condition-kill-all-threads-in-process-group.patch
-clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
-clean-up-duplicate-includes-in-mm.patch
-readahead-compacting-file_ra_state.patch
-readahead-mmap-read-around-simplification.patch
-readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
-readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
-readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
-radixtree-introduce-radix_tree_next_hole.patch
-readahead-basic-support-of-interleaved-reads.patch
-readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
-readahead-remove-several-readahead-macros.patch
-readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
-filemap-trivial-code-cleanups.patch
-filemap-convert-some-unsigned-long-to-pgoff_t.patch
-slub-direct-pass-through-of-page-size-or-higher-kmalloc.patch
-remove-zero_page.patch
-mm-use-lockless-radix-tree-probe.patch
-mm-improve-find_lock_page.patch
-mm-clarify-__add_to_swap_cache-locking.patch
-mm-clarify-__add_to_swap_cache-locking-fix.patch
-radix-tree-use-indirect-bit.patch
-move-mm_struct-and-vm_area_struct.patch
-move-mm_struct-and-vm_area_struct-fix.patch
-slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
-calculation-of-pgoff-in-do_linear_fault-uses-mixed.patch
-slab-allocators-fail-if-ksize-is-called-with-a-null-parameter.patch
-mm-add-end_buffer_read-helper-function.patch
-fs-fix-nobh-error-handling.patch
-fix-the-max-path-calculation-in-radix-treec.patch
-fix-the-max-path-calculation-in-radix-treec-update.patch
-mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch
-use-vm_read-write-exec-to-set-vm_page_prot.patch
-prevent-kswapd-from-freeing-excessive-amounts-of-lowmem.patch
-mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag.patch
-mm-use-pagevec-to-rotate-reclaimable-page.patch
-mm-use-pagevec-to-rotate-reclaimable-page-fix.patch
-mm-use-pagevec-to-rotate-reclaimable-page-fix-2.patch
-mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration.patch
-mm-use-pagevec-to-rotate-reclaimable-page-fix-bug-at-include-linux-mmh220.patch
-mm-use-pagevec-to-rotate-reclaimable-page-kill-redundancy-in-rotate_reclaimable_page.patch
-mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drain.patch
-mm-revert-kernel_ds-buffered-write-optimisation.patch
-revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
-revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
-mm-clean-up-buffered-write-code.patch
-mm-debug-write-deadlocks.patch
-mm-trim-more-holes.patch
-mm-buffered-write-cleanup.patch
-mm-write-iovec-cleanup.patch
-mm-fix-pagecache-write-deadlocks.patch
-mm-buffered-write-iterator.patch
-fs-fix-data-loss-on-error.patch
-fs-introduce-write_begin-write_end-and-perform_write-aops.patch
-introduce-write_begin-write_end-aops-important-fix.patch
-introduce-write_begin-write_end-aops-fix2.patch
-deny-partial-write-for-loop-dev-fd.patch
-mm-restore-kernel_ds-optimisations.patch
-implement-simple-fs-aops.patch
-implement-simple-fs-aops-fix.patch
-block_dev-convert-to-new-aops.patch
-ext2-convert-to-new-aops.patch
-ext2-convert-to-new-aops-fix.patch
-ext2-convert-to-new-aops-fix2.patch
-ext3-convert-to-new-aops.patch
-ext3-convert-to-new-aops-fix.patch
-ext3-convert-to-new-aops-fix-fix.patch
-ext4-convert-to-new-aops.patch
-ext4-convert-to-new-aops-fix.patch
-ext4-convert-to-new-aops-fix-fix.patch
-xfs-convert-to-new-aops.patch
-gfs2-convert-to-new-aops.patch
-gfs2-convert-to-new-aops-fix.patch
-fs-new-cont-helpers.patch
-fat-convert-to-new-aops.patch
-hfs-convert-to-new-aops.patch
-hfsplus-convert-to-new-aops.patch
-hpfs-convert-to-new-aops.patch
-bfs-convert-to-new-aops.patch
-qnx4-convert-to-new-aops.patch
-reiserfs-use-generic-write.patch
-reiserfs-convert-to-new-aops.patch
-reiserfs-convert-to-new-aops-fix.patch
-reiserfs-convert-to-new-aops-fix2.patch
-reiserfs-use-generic_cont_expand_simple.patch
-with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
-nfs-convert-to-new-aops.patch
-git-nfs-vs-nfs-convert-to-new-aops.patch
-git-nfs-vs-nfs-convert-to-new-aops-fix.patch
-smb-convert-to-new-aops.patch
-fuse-convert-to-new-aops.patch
-hostfs-convert-to-new-aops.patch
-hostfs-convert-to-new-aops-fix.patch
-hostfs-convert-to-new-aops-fix-fix.patch
-jffs2-convert-to-new-aops.patch
-ufs-convert-to-new-aops.patch
-ufs-convert-to-new-aops-fix.patch
-ufs-convert-to-new-aops-fix2.patch
-udf-convert-to-new-aops.patch
-udf-convert-to-new-aops-fix.patch
-sysv-convert-to-new-aops.patch
-sysv-convert-to-new-aops-fix.patch
-sysv-convert-to-new-aops-fix2.patch
-minix-convert-to-new-aops.patch
-minix-convert-to-new-aops-fix.patch
-minix-convert-to-new-aops-fix2.patch
-jfs-convert-to-new-aops.patch
-fs-adfs-convert-to-new-aops.patch
-fs-affs-convert-to-new-aops.patch
-affs-convert-to-new-aops-fix.patch
-affs-convert-to-new-aops-fix-fix.patch
-ocfs2-convert-to-new-aops.patch
-fs-remove-some-aop_truncated_page.patch
-memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
-memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
-memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
-memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
-update-n_high_memory-node-state-for-memory-hotadd.patch
-update-n_high_memory-node-state-for-memory-hotadd-fix.patch
-memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
-memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
-memoryless-nodes-no-need-for-kswapd.patch
-memoryless-nodes-slab-support.patch
-memoryless-nodes-slub-support.patch
-memoryless-nodes-uncached-allocator-updates.patch
-memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
-memoryless-nodes-update-memory-policy-and-page-migration.patch
-memoryless-nodes-add-n_cpu-node-state.patch
-memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
-memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
-memoryless-nodes-fix-gfp_thisnode-behavior.patch
-memoryless-nodes-use-n_high_memory-for-cpusets.patch
-memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
-memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
-memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
-memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2-3.patch
-fix-panic-of-cpu-online-with-memory-less-node.patch
-categorize-gfp-flags.patch
-categorize-gfp-flags-fix.patch
-make-swappiness-safer-to-use.patch
-flush-cache-before-installing-new-page-at-migraton.patch
-flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
-flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
-flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
-add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
-split-the-free-lists-for-movable-and-unmovable-allocations.patch
-choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
-add-a-configure-option-to-group-pages-by-mobility.patch
-drain-per-cpu-lists-when-high-order-allocations-fail.patch
-move-free-pages-between-lists-on-steal.patch
-group-short-lived-and-reclaimable-kernel-allocations.patch
-group-high-order-atomic-allocations.patch
-do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
-bias-the-placement-of-kernel-pages-at-lower-pfns.patch
-be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
-fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
-fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
-fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix-fix.patch
-bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
-remove-page_group_by_mobility.patch
-dont-group-high-order-atomic-allocations.patch
-fix-calculation-in-move_freepages_block-for-counting-pages.patch
-do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
-print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
-mm-page_allocc-make-code-static.patch
-slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab.patch
-slub-do-not-use-page-mapping.patch
-slub-do-not-use-page-mapping-fix.patch
-slub-move-page-offset-to-kmem_cache_cpu-offset.patch
-slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch
-slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab-fix.patch
-slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch
-slub-optimize-cacheline-use-for-zeroing.patch
-slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
-breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
-memory-unplug-v7-memory-hotplug-cleanup.patch
-memory-unplug-v7-memory-hotplug-cleanup-fix.patch
-memory-unplug-v7-page-isolation.patch
-memory-unplug-v7-page-offline.patch
-memory-unplug-v7-page-offline-fix.patch
-memory-unplug-v7-ia64-interface.patch
-fix-memory-hot-remove-not-configured-case.patch
-fix-memory-hot-remove-not-configured-case-fix.patch
-memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
-memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
-hugetlb-move-update_and_free_page.patch
-hugetlb-try-to-grow-hugetlb-pool-for-map_private-mappings.patch
-hugetlb-try-to-grow-hugetlb-pool-for-map_shared-mappings.patch
-hugetlb-add-hugetlb_dynamic_pool-sysctl.patch
-hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch
-hugetlbfs-read-support.patch
-hugetlbfs-read-support-fix.patch
-hugetlbfs-read-support-fix-2.patch
-hugetlbfs-read-support-fix-2-fix.patch
-hugetlb-fix-pool-resizing-corner-case-v2.patch
-mm-shmemc-make-3-functions-static.patch
-mm-mempolicyc-cleanups.patch
-mm-mempolicyc-cleanups-fix.patch
-mm-vmstatc-cleanups.patch
-add-node-states-sysfs-class-attributes-v5.patch
-nfs-remove-congestion_end.patch
-lib-percpu_counter_add.patch
-lib-percpu_counter_sub.patch
-lib-percpu_counter-variable-batch.patch
-lib-make-percpu_counter_add-take-s64.patch
-lib-percpu_counter_set.patch
-lib-percpu_counter_sum_positive.patch
-lib-percpu_count_sum.patch
-lib-percpu_counter_init-error-handling.patch
-lib-percpu_counter_init_irq.patch
-mm-bdi-init-hooks.patch
-mm-scalable-bdi-statistics-counters.patch
-mm-count-reclaimable-pages-per-bdi.patch
-mm-count-writeback-pages-per-bdi.patch
-lib-floating-proportions.patch
-mm-per-device-dirty-threshold.patch
-mm-per-device-dirty-threshold-warning-fix.patch
-mm-per-device-dirty-threshold-fix.patch
-mm-dirty-balancing-for-tasks.patch
-mm-dirty-balancing-for-tasks-warning-fix.patch
-slub-simplify-irq-off-handling.patch
-slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
-slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
-slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
-slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
-oom-move-prototypes-to-appropriate-header-file.patch
-oom-move-prototypes-to-appropriate-header-file-fix.patch
-oom-move-constraints-to-enum.patch
-oom-change-all_unreclaimable-zone-member-to-flags.patch
-oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
-oom-add-per-zone-locking.patch
-oom-serialize-out-of-memory-calls.patch
-oom-add-oom_kill_allocating_task-sysctl.patch
-oom-suppress-extraneous-stack-and-memory-dump.patch
-oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
-oom-do-not-take-callback_mutex.patch
-oom-do-not-take-callback_mutex-fix.patch
-oom-prevent-including-schedh-in-header-file.patch
-oom-add-header-file-to-kbuild-as-unifdef.patch
-oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch
-mm-test-and-set-zone-reclaim-lock-before-starting.patch
-mm-test-and-set-zone-reclaim-lock-before-starting-cleanup.patch
-mm-document-tree_lock-zonelock-lockorder.patch
-writeback-dont-propagate-aop_writepage_activate.patch
-security-convert-lsm-into-a-static-interface.patch
-security-convert-lsm-into-a-static-interface-fix.patch
-security-convert-lsm-into-a-static-interface-fix-2.patch
-security-convert-lsm-into-a-static-interface-fix-2-fix.patch
-security-convert-lsm-into-a-static-interface-fix-unionfs.patch
-security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
-ifdef-struct-task_structsecurity.patch
-implement-file-posix-capabilities.patch
-implement-file-posix-capabilities-fix.patch
-file-capabilities-introduce-cap_setfcap.patch
-file-capabilities-get_file_caps-cleanups.patch
-file-caps-update-selinux-xattr-hooks.patch
-file-capabilities-clear-caps-cleanup.patch
-file-capabilities-clear-caps-cleanup-fix.patch
-file-capabilities-change-xattr-format-v2.patch
-file-capabilities-change-fe-to-a-bool.patch
-file-caps-clean-up-for-linux-capabilityh.patch
-capabilityh-remove-include-of-currenth.patch
-file-capabilities-clear-fcaps-on-inode-change.patch
-file-capabilities-clear-fcaps-on-inode-change-fix.patch
-capabilities-reset-current-pdeath_signal-when-increasing-capabilities.patch
-security-cleanups.patch
-remove-frv-usage-of-flush_tlb_pgtables.patch
-include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
-frv-cleanup-struct-irqaction-initializers.patch
-blackfin-enable-arbitary-speed-serial-setting.patch
-m68knommu-remove-unused-config-symbol-config_disktel.patch
-cleanup-arch-alpha-makefile.patch
-alpha-convert-to-generic-sys_ptrace.patch
-alpha-beautify-vmlinuxlds.patch
-make-kernel-power-maincsuspend_enter-static.patch
-pm-move-definition-of-struct-pm_ops-to-suspendh.patch
-pm-rename-struct-pm_ops-and-related-things.patch
-pm-rework-struct-platform_suspend_ops.patch
-pm-make-suspend_ops-static.patch
-pm-rework-struct-hibernation_ops.patch
-pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
-freezer-document-relationship-with-memory-shrinking.patch
-freezer-do-not-sync-filesystems-from-freeze_processes.patch
-freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
-freezer-introduce-freezer-firendly-waiting-macros.patch
-freezer-introduce-freezer-firendly-waiting-macros-fix.patch
-freezer-do-not-send-signals-to-kernel-threads.patch
-unexport-pm_power_off_prepare.patch
-pm_trace-displays-the-wrong-time-from-the-rtc.patch
-freezer-be-more-verbose.patch
-freezer-use-wait-queue-instead-of-busy-looping.patch
-freezer-measure-freezing-time.patch
-serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
-serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
-s2ram-kill-old-debugging-junk.patch
-hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch
-hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch
-hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch
-hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
-hibernation-check-if-acpi-is-enabled-during-restore-in-the-right-place.patch
-hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4.patch
-hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4-fix.patch
-include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
-m32r-cleanup-struct-irqaction-initializers.patch
-m32r-serial-remove-m32r_sio_share_irqs.patch
-m32r-convert-to-generic-sys_ptrace.patch
-cris-cleanup-struct-irqaction-initializers.patch
-tty-bring-the-old-cris-driver-back-somewhere-into-the.patch
-uml-move-userspace-code-to-userspace-file.patch
-uml-tidy-recently-moved-code.patch
-uml-fix-error-cleanup-ordering.patch
-uml-console-subsystem-tidying.patch
-uml-fix-console-writing-bugs.patch
-uml-console-tidying.patch
-uml-stop-using-libc-asm-pageh.patch
-uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
-uml-fix-nonremovability-of-watchdog.patch
-uml-stop-specially-protecting-kernel-stacks.patch
-uml-stop-saving-process-fp-state.patch
-uml-stop-saving-process-fp-state-fix.patch
-uml-physmem-code-tidying.patch
-uml-add-vde-networking-support.patch
-uml-remove-unnecessary-hostfs_getattr.patch
-uml-throw-out-config_mode_tt.patch
-uml-remove-sysdep-threadh.patch
-uml-style-fixes-pass-1.patch
-uml-throw-out-choose_mode.patch
-uml-style-fixes-pass-2.patch
-uml-remove-code-made-redundant-by-choose_mode-removal.patch
-uml-style-fixes-pass-3.patch
-uml-remove-__u64-usage-from-physical-memory-subsystem.patch
-uml-get-rid-of-do_longjmp.patch
-uml-fold-mmu_context_skas-into-mm_context.patch
-uml-rename-pt_regs-general-purpose-register-file.patch
-uml-rename-pt_regs-general-purpose-register-file-fix.patch
-uml-free-ldt-state-on-process-exit.patch
-uml-remove-os_-usage-from-userspace-files.patch
-uml-replace-clone-with-fork.patch
-uml-fix-inlines.patch
-uml-userspace-files-should-call-libc-directly.patch
-uml-clean-up-tlb-flush-path.patch
-uml-remove-unneeded-if-from-hostfs.patch
-uml-fix-hostfs-style.patch
-uml-dont-use-glibc-asm-userh.patch
-uml-floating-point-signal-delivery-fixes.patch
-uml-ptrace-floating-point-fixes.patch
-uml-coredumping-floating-point-fixes.patch
-uml-sysrq-and-mconsole-fixes.patch
-uml-style-fixes-in-fp-code.patch
-uml-eliminate-floating-point-state-from-register-file.patch
-uml-remove-unneeded-void-cast.patch
-uml-remove-unused-file.patch
-uml-more-idiomatic-parameter-parsing.patch
-uml-eliminate-hz.patch
-uml-fix-timer-switching.patch
-uml-simplify-interval-setting.patch
-uml-separate-timer-initialization.patch
-uml-generic_time-support.patch
-uml-generic_clockevents-support.patch
-uml-clocksource-support.patch
-uml-clocksource-support-fix.patch
-uml-tickless-support.patch
-uml-tickless-support-fix.patch
-uml-eliminate-interrupts-in-the-idle-loop.patch
-uml-time-build-fix.patch
-uml-eliminate-sigalrm.patch
-uml-use-sec_per_sec-constants.patch
-uml-network-formatting.patch
-uml-network-driver-mtu-cleanups.patch
-uml-correctly-handle-skb-allocation-failures.patch
-uml-correctly-handle-skb-allocation-failures-fix.patch
-uml-fix-stub-address-calculations.patch
-uml-fix-stub-address-calculations-checkpatch-fixes.patch
-uml-arch-um-drivers-formatting.patch
-uml-arch-um-drivers-formatting-checkpatch-fixes.patch
-uml-definitively-kill-subprocesses-on-panic.patch
-v850-cleanup-struct-irqaction-initializers.patch
-i-oat-new-device-ids.patch
-i-oat-rename-the-source-file.patch
-i-oat-code-cleanup-from-checkpatch-output.patch
-i-oat-split-pci-startup-from-dma-handling-code.patch
-i-oat-add-support-for-msi-and-msi-x.patch
-i-oat-add-support-for-msi-and-msi-x-fix.patch
-dca-add-direct-cache-access-driver.patch
-i-oat-add-dca-services.patch
-cpuset-remove-sched-domain-hooks-from-cpusets.patch
-fs-reiserfs-cleanups.patch
-use-list_head-in-binfmt-handling-update.patch
-make-unregister_binfmt-return-void.patch
-immunize-rcu_dereference-against-crazy-compiler-writers.patch
-remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
-softlockup-use-cpu_clock-instead-of-sched_clock.patch
-fix-the-softlockup-watchdog-to-actually-work.patch
-softlockup-make-asm-irq_regsh-available-on-every-platform.patch
-softlockup-improve-debug-output.patch
-softlockup-improve-debug-output-fix.patch
-softlockup-watchdog-style-cleanups.patch
-softlockup-add-a-proc-tuning-parameter.patch
-softlockup-add-a-proc-tuning-parameter-fix.patch
-slab_panic-more-proc-posix-timers-shmem.patch
-zisofs-use-mutex-instead-of-semaphore.patch
-force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
-force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
-driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
-driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
-unexport-asm-shmparamh.patch
-ext2-statfs-improvement-for-block-and-inode-free-count.patch
-kill-declare_mutex_locked.patch
-add-kernel-notifierc.patch
-add-kernel-notifierc-fix.patch
-add-kernel-notifierc-fix-2.patch
-add-kernel-notifierc-fix-2-fix-3.patch
-nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable.patch
-nbd-change-a-parameters-type-to-remove-a-memcpy-call.patch
-fs-romfs-inodec-trivial-improvements.patch
-fs-mark-nibblemap-const.patch
-kconfig-make-instrumentation-support-non-experimental.patch
-faster-ext2_clear_inode.patch
-remove-unneded-lock_kernel-in-driver-block-loopc.patch
-do_sys_poll-simplify-playing-with-on-stack-data.patch
-do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
-do_poll-return-eintr-when-signalled.patch
-fs-proc-mmuc-headers-butchery.patch
-i386-mark-pit_clockevent-static.patch
-fs-use-kmem_cache_zalloc-instead.patch
-pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
-pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix.patch
-remove-sysctlh-from-fsh.patch
-clean-up-duplicate-includes-in-drivers-char.patch
-clean-up-duplicate-includes-in-drivers-w1.patch
-clean-up-duplicate-includes-in-fs.patch
-clean-up-duplicate-includes-in-fs-ecryptfs.patch
-clean-up-duplicate-includes-in-kernel.patch
-time-simplify-smp_call_function_single-call-sequence.patch
-convert-ill-defined-log2-to-ilog2.patch
-ext2-show-all-mount-options.patch
-ext3-show-all-mount-options.patch
-ext4-show-all-mount-options.patch
-remove-unsafe-from-module-struct.patch
-report-the-per-irq-statistics-on-allarches.patch
-fix-config_debug_shirq-trigger-on-free_irq.patch
-fs-remove-the-unused-mempages-parameter.patch
-remove-unused-bh-in-calls-to-ext234_get_group_desc.patch
-add-in-sunos-41x-compatible-mode-for-ufs.patch
-add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
-add-in-sunos-41x-compatible-mode-for-ufs-fix-2.patch
-ufs-implement-show_options.patch
-argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
-core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe.patch
-core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix.patch
-core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe.patch
-core_pattern-fix-up-a-few-miscellaneous-bugs.patch
-core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
-epcac-reformat-comments-and-coding-style-improvements.patch
-add-sys-module-name-notes.patch
-kernel-rtmutex-debugc-cleanups.patch
-fs-afs-possible-cleanups.patch
-lib-ioremapc-should-include-linux-ioh.patch
-ipc-shmc-make-2-functions-static.patch
-printk-add-interfaces-for-external-access-to-the-log-buffer.patch
-printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
-printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch
-drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
-doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
-fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
-drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
-tpm_tis-fix-interrupt-probing.patch
-pi-futex-set-pf_exiting-without-taking-pi_lock.patch
-do_sigaction-remove-now-unneeded-recalc_sigpending.patch
-deprecate-aout-elf-interpreters.patch
-deprecate-aout-elf-interpreters-fix.patch
-handle-the-multi-threaded-inits-exit-properly.patch
-tweak-proc-ipmi-removal.patch
-ufs-move-non-layout-parts-of-ufs_fsh-to-fs-ufs.patch
-ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
-add-linux-elfcore-compath.patch
-x86_64-use-linux-elfcore-compath.patch
-powerpc-use-linux-elfcore-compath.patch
-avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
-wait_task_zombie-remove-unneeded-child-signal-check.patch
-wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
-exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting.patch
-zap_other_threads-dont-optimize-thread_group_empty-case.patch
-wait_task_zombie-dont-fight-with-non-existing-race-with-a-dying-ptracee.patch
-__group_complete_signal-eliminate-unneeded-wakeup-of-group_exit_task.patch
-wait_task_stopped-continued-remove-unneeded-p-signal-=-null-check.patch
-do-not-export-usr-include-scsi-in-make-headers_install.patch
-add-mmf_dump_elf_headers.patch
-ext2-ext3-ext4-add-block-bitmap-validation.patch
-ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
-aoe-remove-unecessary-wrapper-function.patch
-unicode-diacritics-support.patch
-unicode-diacritics-support-s390-fix.patch
-mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
-jsm-remove-further-unneeded-crud.patch
-jsm-remove-further-unneeded-crud-fix.patch
-remove-consolemaph-from-header-exports.patch
-lib-sortc-optimization.patch
-vfs-check-nanoseconds-in-utimensat.patch
-fix-execute-checking-in-permission.patch
-exec-remove-unnecessary-check-for-mnt_noexec.patch
-clean-out-unused-code-in-dentry-pruning.patch
-include-linux-typesh-in-if_fddih.patch
-pie-executable-randomization.patch
-pie-executable-randomization-fix.patch
-pie-executable-randomization-fix-2.patch
-pie-executable-randomization-fix-3.patch
-cramfs-error-message-about-endianess.patch
-remove-strict-ansi-check-from-__u64-in-asm-typesh.patch
-shrink-struct-task_structoomkilladj.patch
-remove-struct-task_structio_wait.patch
-ext2-4-use-is_power_of_2.patch
-limit-minixfs-printks-on-corrupted-dir-i_size.patch
-kernel-time-timekeepingc-cleanups.patch
-make-fs-libfscsimple_commit_write-static.patch
-allow-disabling-dnotify-without-embedded.patch
-use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
-use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
-use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
-make-rcutorture-rng-use-temporal-entropy.patch
-aio-account-i-o-wait-time-properly.patch
-fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
-exec-simplify-sighand-switching.patch
-exec-simplify-the-new-sighand-allocation.patch
-exec-consolidate-2-fast-paths.patch
-exec-rt-sub-thread-can-livelock-and-monopolize-cpu-on-exec.patch
-do_sigaction-dont-worry-about-signal_pending.patch
-add-stack-checking-for-blackfin.patch
-binfmt_flat-warning-fixes.patch
-console-events-and-accessibility.patch
-console-events-and-accessibility-fix.patch
-add-vmcoreinfo.patch
-add-vmcore-cleanup-the-coding-style-according-to-andrews-comments.patch
-add-vmcore-add-nodemask_ts-size-and-nr_free_pagess-value-to-vmcoreinfo_data.patch
-add-vmcore-use-the-existing-ia64_tpa-instead-of-asm-code.patch
-add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros.patch
-maintainters-use-our-mail-list-as-blackfin-arch-maintainters.patch
-shrink-task_struct-if-config_futex=n.patch
-ttyh-remove-dead-define.patch
-fix-a-trivial-typo-in-scripts-checkstackpl.patch
-move-preempt_notifiers-into-an-always-included-kconfig.patch
-floppy-tolerate-dma-channel-unavailability.patch
-cleanup-floppyh.patch
-codingstyle-relax-the-80-cole-rule.patch
-script-to-check-for-undefined-kconfig-symbols.patch
-nbd-set-uninitialized-devices-to-size-0.patch
-nbd-allow-hung-network-i-o-to-be-cancelled.patch
-cciss-fix-error-reporting-for-sg_io.patch
-drop-some-headers-from-mmh.patch
-remove-include-asm-ipch.patch
-n_hdlcc-fix-check-after-use.patch
-kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
-make-kernel-profilectime_hook-static.patch
-drivers-block-ccissc-fix-check-after-use.patch
-remove-valueless-definition-of-hard-selected-ramfs-option.patch
-local_t-documentation-update-2.patch
-atomic_opstxt-mention-local_t.patch
-local_t-update-documentation.patch
-docs-ramdisk-initrd-initramfs-corrections.patch
-remove-final-traces-of-long-deprecated-ramdisk-kernel.patch
-send-quota-messages-via-netlink.patch
-send-quota-messages-via-netlink-fix.patch
-send-quota-messages-via-netlink-fix-fix.patch
-make-dmapool-code-use-__set_current_state.patch
-add-a-rounddown_pow_of_two-routine-to-log2h.patch
-add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
-fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
-handle-recursive-calls-to-bust_spinlocks.patch
-store-__setup_str_-in-a-more-compact-way.patch
-constify-string-array-kparam-tracking-structures.patch
-avoid-negative-and-full-width-shifts-in-radix-treec.patch
-add-config_vt_unicode.patch
-update-checkpatchpl-to-version-010.patch
-i2o-fix-defined-but-not-used-build-warnings.patch
-i2o-fix-defined-but-not-used-build-warnings-fix.patch
-ipc-namespace-remove-config-ipc-ns-fix.patch
-spelling-fix-weired-weird.patch
-mutex-documentation-is-unclear-about-software-interrupts-tasklets-and-timers.patch
-dcache-trivial-comment-fix.patch
 procfs-detect-duplicate-names.patch
-procfs-detect-duplicate-names-fix.patch
-procfs-detect-duplicate-names-fix-fix-2.patch
-remove-dma_cache_wbackinvwback_inv-functions.patch
-maintainers-linux-omap-list-is-subscribers-only.patch
-try-to-reap-reiserfs-pages-left-around-by-invalidatepage.patch
-keys-make-request_key-and-co-fundamentally-asynchronous.patch
-keys-make-request_key-and-co-fundamentally-asynchronous-update.patch
-keys-make-request_key-and-co-fundamentally-asynchronous-vs-git-mmc.patch
-keys-missing-word-in-documentation.patch
-make-the-pr_-family-of-macros-in-kernelh-complete.patch
-doc-about-email-clients-for-linux-patches.patch
-reiserfs-fix-kernel-panic-on-corrupted-directory.patch
-lib-iomapcbad_io_access-print-0x-hex-prefix.patch
-lk201-remove-obsolete-driver.patch
-shrink_dcache_sb-speedup.patch
-add-consts-where-appropriate-in-fs-nls.patch
-reiserfs-workaround-for-dead-loop-in-finish_unfinished.patch
-reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
-unify-dma_bit_mask-definitions-v31.patch
-stop-using-dma_xxbit_mask.patch
-stop-using-dma_xxbit_mask-fix.patch
-delete-gcc-295-compatible-structure-definition.patch
-fs-isofs-nameic-remove-uninitialized-local-vars-warning.patch
-ide-cd-is-unmaintained.patch
-tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
-tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
-atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
-udf-code-style-fixup-v3.patch
-userc-deinline.patch
-userc-ifdef-mq_bytes.patch
-userc-ifdef-mq_bytes-fix.patch
-remove-unused-member-from-nsproxy.patch
-use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
-vfs-use-the-predefined-d_unhashed-inline-function-instead.patch
-increase-at_vector_size-to-terminate-saved_auxv-properly.patch
-increase-at_vector_size-to-terminate-saved_auxv-properly-updates.patch
-change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch
-delay-creation-of-khcvd-thread.patch
-hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help.patch
-lockdep-give-each-filesystem-its-own-inode-lock-class.patch
-menuconfig-transform-nls-and-dlm-menus.patch
-menuconfig-transform-network-filesystems-menu.patch
-fs-udf-ballocc-mark-a-variable-as-uninitialized_var.patch
-dont-truncate-proc-pid-environ-at-4096-characters.patch
-fix-wrong-filename-reference-in-drivers-testingtxt.patch
-anon-inodes-use-open-coded-atomic_inc-for-the-shared-inode.patch
-ncr53c8xx-remove-deprecated-irq-flags-sa_.patch
-completely-remove-deprecated-irq-flags-sa_.patch
-compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
-fs-correct-sus-compliance-for-open-of-large-file-without.patch
-ext3-remove-ifdef-config_ext3_index.patch
-rename-signalfd_siginfo-fields.patch
-break-elf_platform-and-stack-pointer-randomization-dependency.patch
-spin_lock_unlocked-cleanups.patch
-task_struct-move-fpu_counter-and-oomkilladj.patch
-f_dupfd_cloexec-implementation.patch
-f_dupfd_cloexec-implementation-fix-2.patch
-module-return-error-when-mod_sysfs_init-failed.patch
-ext3-lighten-up-resize-transaction-requirements.patch
-ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes.patch
-printk-add-kern_cont-annotation.patch
-lp_console-cleanups.patch
-reiserfs-do-not-repair-wrong-journal-params.patch
-dontdiff-update-based-on-gitignore-updates.patch
-writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
-writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
-writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
-writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
-writeback-fix-comment-use-helper-function.patch
-writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
-writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
-writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
-writeback-fix-periodic-superblock-dirty-inode-flushing.patch
-writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
-writeback-fix-ntfs-with-sb_has_dirty_inodes.patch
-writeback-remove-pages_skipped-accounting-in-__block_write_full_page.patch
-writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch
-writeback-introduce-writeback_controlmore_io-to-indicate-more-io.patch
-introduce-i_sync.patch
-introduce-i_sync-fix.patch
-writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch
-clean-up-duplicate-includes-in-drivers-spi.patch
-omap2-mcspi-code-cleanup.patch
-spi-driver-runtime-footprint-shrinkage.patch
-spi_mpc83xx-handles-other-processors-with.patch
-documentation-spi-spidev_testc-constify-some-variables.patch
-revert-faster-ext2_clear_inode.patch
-ext2-reservations.patch
-ext2-reservations-fix-for-percpu_counter-changes.patch
-fix-for-ext2-reservation.patch
-remove-fs-ext2-balloccreserve_blocks.patch
-ext2-balloc-use-io_error-label.patch
-kprobes-support-kretprobe-blacklist.patch
-lockdep-annotate-kprobes-irq-fiddling.patch
-lockdep-annotate-kprobes-irq-fiddling-fix.patch
-gigaset-remove-pointless-locking.patch
-use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch
-fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
-isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
-isdn-hisax-hfc_usbc-fix-check-after-use.patch
-fs-nfsd-exportc-make-3-functions-static.patch
-ecryptfs-add-key-list-structure-search-keyring.patch
-ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch
-ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch
-ecryptfs-fix-tag-1-parsing-code.patch
-ecryptfs-fix-tag-3-parsing-code.patch
-ecryptfs-fix-tag-11-parsing-code.patch
-ecryptfs-fix-tag-11-writing-code.patch
-ecryptfs-update-comment-and-debug-statement.patch
-ecryptfs-printk-warning-fixes.patch
-ecryptfs-remove-unnecessary-bug_on.patch
-ecryptfs-collapse-flag-set-into-one-statement.patch
-ecryptfs-grammatical-fix-destruct-to-destroy.patch
-ecryptfs-comments-for-some-structs.patch
-ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec.patch
-ecryptfs-remove-unnecessary-variable-initializations.patch
-ecryptfs-make-needlessly-global-symbols-static.patch
-ecryptfs-use-generic_file_splice_read.patch
-ecryptfs-remove-header_extent_size.patch
-ecryptfs-remove-header_extent_size-fix.patch
-ecryptfs-remove-assignments-in-if-statements.patch
-ecryptfs-fix-error-handling.patch
-ecryptfs-read_writec-routines.patch
-ecryptfs-replace-encrypt-decrypt-and-inode-size-write.patch
-ecryptfs-set-up-and-destroy-persistent-lower-file.patch
-ecryptfs-update-metadata-read-write-functions.patch
-ecryptfs-update-metadata-read-write-functions-cleanup.patch
-ecryptfs-make-open-truncate-and-setattr-use-persistent-file.patch
-ecryptfs-convert-mmap-functions-to-use-persistent-file.patch
-ecryptfs-convert-mmap-functions-to-use-persistent-file-fix.patch
-ecryptfs-fix-data-types.patch
-ecryptfs-initialize-persistent-lower-file-on-inode-create.patch
-ecryptfs-remove-unused-functions-and-kmem_cache.patch
-ecryptfs-replace-magic-numbers.patch
-ecryptfs-clean-up-page-flag-handling.patch
-rtc-periodic-irq-fix.patch
-rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
-no-need-to-convert-file-private_data-to-rtc-device.patch
-rtc-make-rtc-ds1553-driver-hotplug-aware-take-3.patch
-rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch
-rtc-pcf8583-check-for-i2c-adapter-functionality.patch
-rtc-rtc-class-driver-for-the-ds1374.patch
-rtc-fix-readback-from-sys-class-rtc-rtc-wakealarm.patch
-rtc-cmos-probe-cleanup.patch
-rtc-cmos-probe-cleanup-checkpatch-fixes.patch
-fbdev-export-fb_destroy_modelist.patch
-connector-change-connectors-max-message-size.patch
-uvesafb-add-connector-entries.patch
-uvesafb-the-driver-core.patch
-uvesafb-the-driver-core-uvesafb-set-the-refresh-rate-to-60hz-if-nocrtc-is-used.patch
-uvesafb-the-driver-core-uvesafb-always-use-mutexes-when-accessing-uvfb_tasks.patch
-uvesafb-the-driver-core-uvesafb-fix-a-typo-in-a-warning.patch
-uvesafb-the-driver-core-uvesafb-use-visual_truecolor-as-the-default-visual.patch
-uvesafb-the-driver-core-uvesafb-use-the-default-refresh-rate-if-the-monitor-limits-are-not-set.patch
-uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed.patch
-uvesafb-the-driver-core-dont-access-vga-registers-directly-when-running-on-non-x86.patch
-uvesafb-documentation.patch
-uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch
-pm3fb-copyarea-and-partial-imageblit-suppor.patch
-skeletonfb-wrong-field-name-fix.patch
-pm3fb-header-file-reduction.patch
-pm3fb-imageblit-improved.patch
-pm3fb-3-small-fixes.patch
-pm3fb-improvements-and-cleanups.patch
-pm3fb-mtrr-support-and-noaccel-option.patch
-pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
-pm2fb-mtrr-support-and-noaccel-option.patch
-pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
-pm2fb-accelerated-imageblit.patch
-pm2fb-source-code-improvements.patch
-pm2fb-permedia-2v-initialization-fixes.patch
-pm2fb-accelerated-24-bit-fillrect.patch
-sm501fb-update-suspend-and-resume-code.patch
-sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch
-sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch
-mbxfb-improvements-and-new-features.patch
-pxafb-add-support-for-other-palette-formats.patch
-tridentfb-coding-style-improvement.patch
-tdfxfb-coding-style-improvement.patch
-tdfxfb-3-fixes.patch
-tdfxfb-palette-fixes.patch
-radeon_driver_vblank_do_wait-static.patch
-unexport-fb_prepare_logo.patch
-fbdev-fix-incorrect-timings-in-some-modedb-entries.patch
-tdfxfb-code-improvements.patch
-tdfxfb-hardware-cursor.patch
-tdfxfb-mtrr-support.patch
-tdfxfb-mtrr-support-fix.patch
-tdfxfb-mtrr-support-fix-2.patch
-pm2fb-checkpatch-fixes.patch
-pm3fb-checkpatch-fixes.patch
-drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch
-fbdev-fb_create_modedb-non-static-int-first-=-1.patch
-fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
-pm2fb-permedia-2v-hardware-cursor-support.patch
-pm3fb-hardware-cursor-support.patch
-s3c2410fb-code-cleanup.patch
-s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
-s3c2410fb-multi-display-support.patch
-s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
-s3c2410fb-use-new-margin-fields.patch
-s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
-s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
-s3c2410fb-use-vertical-margins-values.patch
-s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
-s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
-s3c2410fb-fix-missing-registers-offset.patch
-s3c2410fb-byte-ordering-fixes.patch
-atyfb-atyfb-unshare-pseudo_palette.patch
-fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
-fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.patch
-vt-fix-warnings-in-selectionh.patch
-fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
-s3c2410fb-source-code-improvements.patch
-s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
-s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
-s3c2410fb-make-use-of-default_display-settings.patch
-cirrusfb-checkpatchpl-cleanup.patch
-cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
-cirrusfb-remove-typedefs.patch
-cirrusfb-remove-fields-from-cirrusfb_info.patch
-cirrusfb-code-improvements.patch
-cirrusfb-code-improvement-2nd-part.patch
-pm3fb-header-file-cleanup.patch
-pm2fb-hardware-cursor-support-for-the-permedia2.patch
-pm2fb-panning-and-hardware-cursor-fixes.patch
-vfb-make-virtual-framebuffer-mmapable.patch
-intel-fb-support-for-interlaced-video-modes.patch
-fbdev-find-mode-with-the-highest-safest-refresh-rate-in-fb_find_mode.patch
-nvidiafb-add-boot-option-to-reverse-i2c-port-assignment.patch
-fbdev-support-for-byte-reversed-framebuffer-formats.patch
-ps3-fix-black-and-white-stripes.patch
-ps3fb-fix-spurious-mode-change-failures.patch
-fbdev-update-documentation-fb-00-index.patch
-tdfxfb-replace-busy-waiting-with-cpu_relax.patch
-pm2fb-replace-busy-waiting-with-cpu_relax.patch
-pm3fb-replace-busy-waiting-with-cpu_relax.patch
-tdfxfb-checkpatch-fixes.patch
-drivers-video-kconfig-fix-fb_pmagb_b-dependencies.patch
-export-font_vga_8x16.patch
-radeonfb-xpress-200m-rc410-support-patch.patch
-drivers-video-pmag-ba-fbc-improve-diagnostics.patch
-drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
-intel-fb-whitespace-bracket-and-other-clean-ups.patch
-intel-fb-obvious-changes-and-corrections.patch
-intel-fb-force-even-line-count-in-interlaced-mode.patch
-intel-fb-more-interlaced-mode-support.patch
-video-gfx-fix-menu-ordering.patch
-vt-vgacon-check-if-screen-resize-request-comes-from-userspace.patch
-nvidiafb-correctly-assign-the-i2c-class-with-the-port-reversal.patch
-pmagb-b-fb-improve-diagnostics.patch
-fbcon-logo-disable-logo-at-boot.patch
-fbcon-logo-disable-logo-at-boot-fix.patch
-bf54x-lq043fb-framebuffer-driver-for-blackfin-bf54x-framebuffer-device-driver.patch
-video-gfx-merge-kconfig-menus.patch
-ps3av-eliminate-unneeded-temporary-variables.patch
-ps3av-eliminate-ps3av_debug.patch
-ps3av-use-ps3-video-mode-ids-in-autodetect-code.patch
-ps3av-treat-dvi-d-like-hdmi-in-autodetect.patch
-ps3av-add-autodetection-for-vesa-modes.patch
-ps3av-add-quirk-database-for-broken-monitors.patch
-ps3av-remove-unused-ps3av_set_mode.patch
-ps3av-dont-distinguish-between-boot-and-non-boot-autodetection.patch
-imxfb-fast-read-flag-and-nonstandard-field-configurable.patch
-md-software-raid-autodetect-dev-list-not-array.patch
-bitmaph-remove-dead-artifacts.patch
-cpu-hotplug-slab-cleanup-cpuup_callback.patch
-cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
-cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
-cpu-hotplug-topology-remove-topology_dev_map.patch
-cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
-cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
-cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
-cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
-cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
-do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
-do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist-fix.patch
-migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
-floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
-floppy-remove-dead-commented-out-code-from-floppy-driver.patch
-floppy-remove-register-keyword-use-from-floppy-driver.patch
-intel-iommu-dmar-detection-and-parsing-logic.patch
-intel-iommu-pci-generic-helper-function.patch
-intel-iommu-clflush_cache_range-now-takes-size-param.patch
-intel-iommu-iova-allocation-and-management-routines.patch
-intel-iommu-intel-iommu-driver.patch
-intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
-intel-iommu-intel-iommu-cmdline-option-forcedac.patch
-intel-iommu-dmar-fault-handling-support.patch
-intel-iommu-iommu-gfx-workaround.patch
-intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
-intel-iommu-iommu-floppy-workaround.patch
-intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
-intel-iommu-optimize-sg-map-unmap-calls.patch
-intel-iommu-fix-for-iommu-early-crash-2.patch
-git-block-intel-iommu-sg-chaining-support.patch
-fuse-update-backing_dev_info-congestion-state.patch
-fuse-fix-reserved-request-wake-up.patch
-fuse-add-reference-counting-to-fuse_file.patch
-fuse-truncate-on-spontaneous-size-change.patch
-fuse-fix-page-invalidation.patch
-fuse-set-i_nlink-to-sane-value-after-mount.patch
-fuse-refresh-stale-attributes-in-fuse_permission.patch
-fuse-fix-permission-checking-on-sticky-directories.patch
-fuse-fix-permission-checking-on-sticky-directories-fix.patch
-fuse-fix-permission-checking-on-sticky-directories-fix-setting-i_mode-bits.patch
-fuse-cleanup-in-release.patch
-fuse-no-abort-on-interrupt.patch
-fuse-no-enoent-from-fuse-device-read.patch
-fuse-clean-up-execute-permission-checking.patch
-ext4-jbd_slab_cleanup.patch
-ext4-jbd2_slab_cleanup.patch
-ext4-jbd_jbd_kmalloc_cleanup.patch
-ext4-jbd2_jbd_kmalloc_cleanup.patch
-ext4-jbd2-ext4-cleanups-convert-to-kzalloc.patch
-ext4-jbd_to_jbd2_naming_cleanups.patch
-ext4-jbd2-fix-commit-code-to-properly-abort-journal.patch
-ext4-jbd2-debug-code-cleanup.patch
-ext4-remove-obsolete-fragments.patch
-ext4-remove-ifdef-config_ext4_index.patch
-ext4-uninitialized-block-groups.patch
-ext4-fix-sparse-warnings.patch
-ext4-flex_bg-kernel-support-v2.patch
-ext4-ext4-convert_bg_block_bitmap_to_bg_block_bitmap_lo.patch
-ext4-ext4-convert_bg_inode_bitmap_and_bg_inode_table.patch
-ext4-ext4-convert_s_blocks_count_to_s_blocks_count_lo.patch
-ext4-ext4-convert_s_r_blocks_count_and_s_free_blocks_count.patch
-ext4-ext4-convert_ext4_extentee_start_to_ext4_extentee_start_lo.patch
-ext4-ext4-convert_ext4_extent_idxei_leaf_to_ext4_extent_idxei_leaf_lo.patch
-ext4-ext4-sparse-fix.patch
-ext4-ext4_fix_setup_new_group_blocks_locking.patch
-ext4-ext4_lighten_up_resize_transaction_requirements.patch
-ext4-jbd-stats-through-procfs.patch
-ext4-ext4-journal_chksum-2620.patch
-ext4-ext4-journal-chksum-review-fix.patch
-ext4-64-bit-i_version.patch
-ext4-i_version_hi.patch
-ext4-ext4_i_version_hi_2.patch
-ext4-i_version_update_ext4.patch
-ext4-delalloc-vfs.patch
-ext4-delalloc-ext4.patch
-ext4-ext-truncate-mutex.patch
-ext4-ext3-4-migrate.patch
-ext4-generic-find-next-le-bit.patch
-ext4-new-extent-function.patch
-ext4-mballoc-core.patch
-ext4-mballoc-bug-workaround.patch
-ext4-jbd-blocks-reservation-fix-for-large-blk.patch
-ext4-jbd2-blocks-reservation-fix-for-large-blk.patch
-jbd-ext3-cleanups-convert-to-kzalloc.patch
-jbd-remove-printk-from-j_assert-macros.patch
-jbd-config_jbd_debug-cannot-create-proc-entry.patch
-jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
-jbd-fix-commit-code-to-properly-abort-journal.patch
-jbd-fix-jbd-warnings-when-compiling-with-config_jbd_debug.patch
-peterz-vs-ext4-mballoc-core.patch
-pnp-make-pnpacpi_suspend-handle-errors.patch
-pnp-dont-fail-device-init-if-no-dma-channel.patch
-fix-very-high-interrupt-rate-for-irq8-rtc-unless-pnpacpi=off.patch
-pnp-remove-null-pointer-checks.patch
-pnp-simplify-pnp-card-error-handling.patch
-pnp-use-dev_info-dev_err-etc-in-core.patch
-pnp-use-dev_info-dev_err-etc-in-core-fix.patch
-pnp-use-dev_info-dev_err-etc-in-core-fix-fix.patch
-pnp-use-dev_info-in-system-driver.patch
-pnp-simplify-pnpbios-insert_device.patch
-pnp-add-debug-message-for-adding-new-device.patch
-pnp-add-debug-message-for-adding-new-device-fix.patch
-pnp-add-debug-message-for-adding-new-device-fix-fix.patch
-ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
-knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set.patch
-reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch
-unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch
-vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
-nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change.patch
-cifs-ignore-mode-change-if-its-just-for-clearing-setuid-setgid-bits.patch
-r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
-r-o-bind-mounts-rearrange-may_open-to-be-r-o-friendly.patch
-r-o-bind-mounts-give-permission-a-local-mnt-variable.patch
-r-o-bind-mounts-create-cleanup-helper-svc_msnfs.patch
-clean-up-duplicate-includes-in-documentation.patch
-documentation-make-headers_installtxt.patch
-documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch
-add-a-missing-00-index-file-for-documentation-vm.patch
-add-a-missing-00-index-file-for-documentation-vm-fix.patch
-add-a-00-index-file-to-documentation-mips.patch
-add-a-00-index-file-to-documentation-sysctl.patch
-add-a-00-index-file-to-documentation-telephony.patch
-kernel-doc-fix-doc-blocks-and-html.patch
-documentation-delete-unreferenced-xterm-linuxxpm-file.patch
-express-relocatability-of-kernel-on-x86_64-in-documentation.patch
-express-relocatability-of-kernel-on-x86_64-in.patch
-express-new-elf32-mechanisms-in-documentation.patch
-add-reset_devices-to-the-recommended-parameters.patch
-tweak-documentation-sm501txt.patch
-add-missing-entries-to-top-level-documentation-00-index.patch
-add-documentation-w1w1-masters-00-index.patch
-add-entries-to-documentation-powerpc.patch
-add-documentation-power-00-index.patch
-update-dma-mapping-documentation.patch
-kdump-documentation-cleanups.patch
-vmtxt-document-min_free_pages-as-critical-for-correctness.patch
-documentation-vm-slabinfoc-clean-up-this-code.patch
-sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
-sysctl-factor-out-sysctl_data.patch
-sysct-mqueue-remove-the-binary-sysctl-numbers.patch
-sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
-sysctl-fix-neighbour-table-sysctls.patch
-sysctl-ipv6-route-flushing-kill-binary-path.patch
-sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
-sysctl-x86_64-remove-unnecessary-binary-paths.patch
-sysctl-remove-broken-cdrom-binary-sysctls.patch
-sysctl-remove-broken-cdrom-binary-sysctls-update.patch
-sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
-sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
-sysctl-parport-remove-binary-paths.patch
-sysctl-parport-remove-binary-paths-fix.patch
-sysctl-simplify-the-pty-sysctl-logic.patch
-sysctl-remove-broken-netfilter-binary-sysctls.patch
-sysctl-remove-the-cad_pid-binary-sysctl-path.patch
-sysctl-properly-register-the-irda-binary-sysctl-numbers.patch
-sysctl-error-on-bad-sysctl-tables.patch
-sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
-sysctl-update-sysctl_check_table.patch
-sysctl-update-sysctl_checks-list-of-binary-paths.patch
-sysctl-update-sysctl_check_table-sysctl-update-sysctl_check-to-handle-compiled-out-code.patch
-sysctl-for-irda-update-sysctl_checks-list-of-binary-paths.patch
-sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion.patch
-sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion-fix.patch
-v3-file-capabilities-alter-behavior-of-cap_setpcap.patch
-char-mxser_new-upgrade-to-110.patch
-char-mxser_new-move-to-pci_vdevice.patch
-char-mxser_new-remove-useless-comments-in-mxser_cards.patch
-mxser-remove-commented-crap.patch
-mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
-mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
-cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
-task-containersv11-basic-task-container-framework.patch
-task-containersv11-basic-task-container-framework-fix.patch
-task-containersv11-basic-task-container-framework-containers-fix-refcount-bug.patch
-task-containersv11-basic-task-container-framework-fix-cgroup_create_dir-comments.patch
-task-containersv11-add-tasks-file-interface.patch
-add-cgroup-write_uint-helper-method.patch
-task-containersv11-add-fork-exit-hooks.patch
-task-containersv11-add-container_clone-interface.patch
-task-containersv11-add-container_clone-interface-containers-fix-refcount-bug.patch
-task-containersv11-add-procfs-interface.patch
-task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch
-task-containersv11-shared-container-subsystem-group-arrays.patch
-task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
-task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
-task-containersv11-automatic-userspace-notification-of-idle-containers.patch
-task-containersv11-make-cpusets-a-client-of-containers.patch
-task-containersv11-example-cpu-accounting-subsystem.patch
-task-containersv11-simple-task-container-debug-info-subsystem.patch
-task-containers-enable-containers-by-default-in-some-configs.patch
-add-containerstats-v3.patch
-add-containerstats-v3-fix.patch
-containers-implement-namespace-tracking-subsystem.patch
-containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig.patch
-pid-namespaces-round-up-the-api.patch
-pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
-pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
-pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
-pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
-pid-namespaces-rename-child_reaper-function.patch
-pid-namespaces-use-task_pid-to-find-leaders-pid.patch
-pid-namespaces-define-is_global_init-and-is_container_init.patch
-pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
-pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
-pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
-pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
-pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
-pid-namespaces-move-alloc_pid-to-copy_process.patch
-make-access-to-tasks-nsproxy-lighter.patch
-make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
-make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch
-workqueue-debug-flushing-deadlocks-with-lockdep.patch
-workqueue-debug-work-related-deadlocks-with-lockdep.patch
-lockdep-fix-mismatched-lockdep_depth-curr_chain_hash.patch
-lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
-fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
-fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
-fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
-fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
-kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
-kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
-mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
-whitespace-fixes-time-syscalls.patch
-whitespace-fixes-process-accounting.patch
-whitespace-fixes-cpuset.patch
-whitespace-fixes-relayfs.patch
-whitespace-fixes-audit-filtering.patch
-whitespace-fixes-dma-channel-allocator.patch
-whitespace-fixes-fork.patch
-whitespace-fixes-module-loading.patch
-whitespace-fixes-panic-handling.patch
-whitespace-fixes-capability-syscalls.patch
-whitespace-fixes-syscall-auditing.patch
-whitespace-fixes-compat-syscalls.patch
-whitespace-fixes-system-auditing.patch
-whitespace-fixes-execution-domains.patch
-whitespace-fixes-interval-timers.patch
-whitespace-fixes-system-timers.patch
-whitespace-fixes-task-exit-handling.patch
-pid-namespaces-rework-forget_original_parent.patch
-pid-namespaces-move-exit_task_namespaces.patch
-pid-namespaces-introduce-ms_kernmount-flag.patch
-pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
-pid-namespaces-introduce-struct-upid.patch
-pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
-pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
-pid-namespaces-helpers-to-obtain-pid-numbers.patch
-pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
-pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
-pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
-pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
-pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
-pid-namespaces-allow-cloning-of-new-namespace.patch
-pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch
-pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
-pid-namespaces-initialize-the-namespaces-proc_mnt.patch
-pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
-pid-namespaces-allow-signalling-container-init.patch
-pid-namespaces-destroy-pid-namespace-on-inits-death.patch
-pid-namespaces-changes-to-show-virtual-ids-to-user.patch
-pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
-pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
-pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
-pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
-pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
-pid-namespaces-changes-to-show-virtual-ids-to-user-sys_getsid-sys_getpgid-return-wrong-id-for-task-from-another.patch
-pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-sys_setpgrp-to-work-between-namespaces.patch
-uninline-find_task_by_xxx-set-of-functions.patch
-pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
-pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
-isolate-some-explicit-usage-of-task-tgid.patch
-uninline-find_pid-etc-set-of-functions.patch
-uninline-the-task_xid_nr_ns-calls.patch
-cpuset-sched_load_balance-flag.patch
-cpuset-sched_load_balance-flag-fix.patch
-cpusets-decrustify-cpuset-mask-update-code.patch
-cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
-the-next-round-of-scheduled-oss-code-removal.patch
-char-moxa-fix-and-optimise-empty-timer.patch
-char-cyclades-remove-bottom-half-processing.patch
-char-cyclades-make-the-isr-code-readable.patch
-char-cyclades-move-spin_lock-to-one-place.patch
-char-cyclades-fix-some-w-warnings.patch
-cyclades-avoid-label-defined-but-not-used-warning.patch
-char-moxa-cleanup-prints.patch
-char-moxa-function-names-cleanup.patch
-char-moxa-remove-sleep_on.patch
-add-missing-newlines-to-some-uses-of-dev_level-messages.patch
-add-scaled-time-to-taskstats-based-process-accounting.patch
-add-missing-newlines-to-some-uses-of-dev_level-messages-fix.patch
-powerpc-add-scaled-time-accounting.patch
-powerpc-add-scaled-time-accounting-speedup.patch
-fs-select-remove-unused-macros.patch
-remove-asm-bitopsh-includes.patch
-forbid-asm-bitopsh-direct-inclusion.patch
-cyber2000fb-rename-bit-macro.patch
-cyber2000fb-checkpatch-fixes.patch
-i2c-pxa-rename-bit-macro-to-pxa_bit.patch
-s2io-rename-bit-macro.patch
-amba-pl011-rename-bit-macro.patch
-define-first-set-of-bit-macros.patch
-get-rid-of-input-bit-duplicate-defines.patch
-define-global-bit-macro.patch
-flashpoint-use-bit-instead-of-bitw.patch
-remove-bits_to_type-macro.patch
-remove-bits_to_type-macro-fix.patch
-proc-export-a-processes-resource-limits-via-proc-pid.patch
-fix-tsk-exit_state-usage-resend.patch
-isolate-the-explicit-usage-of-signal-pgrp.patch
-use-helpers-to-obtain-task-pid-in-printks.patch
-use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
-use-helpers-to-obtain-task-pid-in-printks-arch-code.patch
-remove-unused-variables-from-fs-proc-basec.patch
-use-task_pid_nr-in-ip_vs_syncc.patch
-use-task_pid_nr-instead-of-pid_nrtask_pid.patch
-redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
-x86-msr-driver-misc-cpuinit-annotations.patch
-hotplug-cpu-migrate-a-task-within-its-cpuset.patch
-hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
-hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
-cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
-cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
-bitops-introduce-lock-ops.patch
-alpha-fix-bitops.patch
-alpha-lock-bitops.patch
-alpha-lock-bitops-fix.patch
-ia64-lock-bitops.patch
-mips-fix-bitops.patch
-mips-lock-bitops.patch
-powerpc-lock-bitops.patch
-powerpc-lock-bitops-fix.patch
-bit_spin_lock-use-lock-bitops.patch
-fs-cramfs-inodec-remove-unused-variable.patch
-fs-cramfs-inodec-replace-hardcoded-value-with-preprocessor-constant.patch
-ipc-store-ipcs-into-idrs.patch
-ipc-unify-the-syscalls-code.patch
-ipc-remove-the-ipc_get-routine.patch
-ipc-integrate-ipc_checkid-into-ipc_lock.patch
-ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
-ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
-ipc-integrate-ipc_checkid-into-ipc_lock-fix-3.patch
-storing-ipcs-into-idrs.patch
-ipc-introduce-the-ipcid_to_idx-macro.patch
-ipc-inline-ipc_buildid.patch
-ipc_fix_wrong_comments.patch
-fix-idr_find-locking.patch
-ipc-remove-unneeded-parameters.patch
-extended-crashkernel-command-line.patch
-extended-crashkernel-command-line-update.patch
-extended-crashkernel-command-line-comment-fix.patch
-extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch
-use-extended-crashkernel-command-line-on-i386.patch
-use-extended-crashkernel-command-line-on-i386-update.patch
-use-extended-crashkernel-command-line-on-x86_64.patch
-use-extended-crashkernel-command-line-on-x86_64-update.patch
-use-extended-crashkernel-command-line-on-ia64.patch
-use-extended-crashkernel-command-line-on-ia64-fix.patch
-use-extended-crashkernel-command-line-on-ia64-update.patch
-use-extended-crashkernel-command-line-on-ppc64.patch
-use-extended-crashkernel-command-line-on-ppc64-update.patch
-use-extended-crashkernel-command-line-on-sh.patch
-use-extended-crashkernel-command-line-on-sh-update.patch
-add-documentation-for-extended-crashkernel-syntax.patch
-add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
-exportfs-add-fid-type.patch
-exportfs-add-new-methods.patch
-ext2-new-export-ops.patch
-ext3-new-export-ops.patch
-ext4-new-export-ops.patch
-efs-new-export-ops.patch
-jfs-new-export-ops.patch
-ntfs-new-export-ops.patch
-xfs-new-export-ops.patch
-fat-new-export-ops.patch
-isofs-new-export-ops.patch
-shmem-new-export-ops.patch
-reiserfs-new-export-ops.patch
-gfs2-new-export-ops.patch
-ocfs2-new-export-ops.patch
-exportfs-remove-old-methods.patch
-exportfs-make-struct-export_operations-const.patch
-exportfs-update-documentation.patch
-ext3-support-large-blocksize-up-to-pagesize.patch
-usb_serial-stop-passing-null-to-functions-that-expect-data.patch
-ark3116-update-termios-handling.patch
-usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
-ch341-fix-termios-handling.patch
-digi_acceleport-fix-termios-and-also-readability-a-bit.patch
-empeg-clean-up-and-handle-speeds.patch
-ir_usb-termios-handling.patch
-keyspan-termios-tidy.patch
-kobil_sct-termios-encoding-fixups.patch
-option-termios-handling.patch
-sierra-termios.patch
-usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
-hook-up-group-scheduler-with-control-groups.patch
-hook-up-group-scheduler-with-control-groups-fix.patch
-change-struct-marker-users.patch
-combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
-linux-kernel-markers.patch
-linux-kernel-markers-checkpatch-fixes.patch
-linux-kernel-markers-coding-style-fixes.patch
-linux-kernel-markers-alignment-fix.patch
-add-samples-subdir.patch
-linux-kernel-markers-samples.patch
-linux-kernel-markers-samples-checkpatch-fixes.patch
-linux-kernel-markers-samples-coding-style-fix.patch
-linux-kernel-markers-samples-remove-asm.patch
-linux-kernel-markers-documentation.patch
-kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch
-uninline-forkc-exitc.patch
-uninline-forkc-exitc-checkpatch-fixes.patch
-fuse-fix-allowing-operations.patch
-fuse-fix-race-between-getattr-and-write.patch
-fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
-fuse-add-file-handle-to-getattr-operation.patch
-fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
-fuse-clean-up-open-file-passing-in-setattr.patch
-vfs-allow-filesystems-to-implement-atomic-opentruncate.patch
-fuse-improve-utimes-support.patch
-fuse-add-atomic-opentruncate-support.patch
-fuse-support-bsd-locking-semantics.patch
-fuse-add-list-of-writable-files-to-fuse_inode.patch
-fuse-add-helper-for-asynchronous-writes.patch
-fuse-add-support-for-mandatory-locking.patch
-fuse-add-blksize-field-to-fuse_attr.patch
-sparse-pointer-use-of-zero-as-null.patch
-sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
-replace-__attribute_pure__-with-__pure.patch

 Merged into mainline or a subsystem tree

+ecryptfs-cast-page-index-to-loff_t-instead-of-off_t.patch
+fix-oops-in-toshiba_acpi-error-return-path.patch
+rtc_hctosys-expects-rtcs-in-utc-doc.patch
+rtcs-handle-nvram-better.patch
+rtc-ds1307-exports-nvram.patch
+drivers-video-ps3fb-fix-memset-size-error.patch
+w1-fix-memset-size-error.patch
+slab-fix-typo-in-allocation-failure-handling.patch
+serial-add-pnp-id-for-davicom-isa-336k-modem.patch
+sysctl-check-length-at-deprecated_sysctl_warning.patch
+cm40x0_csc-fix-debug-macros.patch
+lib-move-bitmapo-from-lib-y-to-obj-y.patch
+uml-fix-symlink-loops.patch
+rtc-tweak-driver-documentation-for-rtc-periodic.patch
+chipsfb-uses-depends-on-pci.patch
+uvesafb-fix-warnings-about-unused-variables-on-non-x86.patch
+oprofile-oops-when-profile_pc-return-0lu.patch
+uml-fix-recvmsg-return-value-checking.patch
+uml-update-address-space-affected-by-pud_clear.patch
+uml-update-address-space-affected-by-pud_clear-checkpatch-fixes.patch
+improve-cgroup-printks.patch
+improve-cgroup-printks-fix.patch
+drivers-video-s1d13xxxfbc-as-module-with-dbg.patch

 2.6.24 queue

+forbid-user-to-change-file-flags-on-quota-files.patch
+forbid-user-to-change-file-flags-on-quota-files-fix.patch
+lxfb-use-the-correct-msr-number-for-panel-support.patch
+lguest_userc-fix-memory-leak.patch
+video-sis-fix-negative-array-index.patch
+8250_pnp-add-support-for-lg-c1-express-dual-machines.patch
+proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks.patch
+proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch
+migration-find-correct-vma-in-new_vma_page.patch
+memory-hotremove-unset-migrate-type-isolate-after-removal.patch
+make-getdelays-cgroupstats-aware.patch
+mm-speed-up-writeback-ramp-up-on-clean-systems.patch
+add-ioresouce_busy-flag-for-system-ram.patch
+acpi-make-acpi_procfs-default-to-y.patch
+spi-fix-double-free-on-spi_unregister_master.patch
+spi-fix-error-paths-on-txx9spi_probe.patch
+get_task_comm-return-the-result.patch
+clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
+paride-pf-driver-fixes.patch
+drivers-misc-move-misplaced-pci_dev_puts.patch
+dmaengine-fix-broken-device-refcounting.patch
+atmel_serial-build-warnings-begone.patch
+hugetlb-follow_hugetlb_page-for-write-access.patch
+hugetlb-follow_hugetlb_page-for-write-access-fix.patch
+raid5-fix-unending-write-sequence.patch
+x86_64-efi-boot-support-efi-frame-buffer.patch
+x86_64-efi-boot-support-efi-frame-buffer-v3.patch
+x86_64-efi-boot-support-efi-boot-document.patch
+hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
+hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
+hugetlb-fix-quota-management-for-private-mappings.patch
+hugetlb-debit-quota-in-alloc_huge_page.patch
+hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
+hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
+mm-hugetlbc-make-a-function-static.patch
+hugetlb-fix-i_blocks-accounting.patch
+revert-task-control-groups-example-cpu-accounting-subsystem.patch
+fixes-to-the-bfs-filesystem-driver.patch
+linux-kernel-markers-fix-marker-mutex-not-taken-upon-module-load.patch
+linux-kernel-markers-document-format-string.patch
+linux-kernel-markers-fix-samples-to-follow-format-string-standard.patch

 More 2.6.24 queue

+acpi-enable-c3-power-state-on-dell-inspiron-8200-fix.patch

 Fix acpi-enable-c3-power-state-on-dell-inspiron-8200.patch

+acpi-sbs-fix-retval-warning.patch
+acpi-expose-_sun-in-proc-acpi-processor-info.patch
+rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
+acpi4asus-add-support-for-f3sa.patch
+acpi-cleanup-linux-acpih.patch
+small-acpica-extension-to-be-able-to-store-the-name-of.patch
+export-acpi_check_resource_conflict.patch
+export-acpi_check_resource_conflict-update.patch
+mm-only-enforce-acpi-resource-conflict-checks.patch

 ACPI things

+uninitialised-variable-in-arm-ixp4xx-clockevents-code.patch
+unlock-when-ssp-tries-to-close-an-invalid-port.patch
+ixp4xx-remove-double-include.patch
+arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch
+arm-fix-memset-size-error.patch
+arch-arm-removed-duplicate-includes.patch
+omap-register-the-l4-io-bus-to-boot-omap2.patch
+arm-remove-dead-config-symbols-from-arm-code.patch

 arm things

+gx-suspmodc-use-boot_cpu_data-instead-of-current_cpu_data.patch
+cpufreq-fix-incorrect-comment-on-show_available_freqs-in-freq_tablec.patch

 cpufreq things

+agk-dm-dm-table-detect-io-beyond-device.patch
+agk-dm-dm-mpath-hp-requires-scsi.patch
+agk-dm-dm-crypt-fix-write-endio.patch
+agk-dm-dm-trigger-change-uevent-on-rename.patch
+agk-dm-dm-mark-function-lists-static.patch
+agk-dm-dm-ioctl-remove-lock_kernel.patch
+agk-dm-dm-ioctl-move-compat-code.patch
+agk-dm-dm-table-use-list_for_each.patch
+agk-dm-dm-table-remove-unused-variable.patch
+agk-dm-dm-table-remove-unused-total.patch
+agk-dm-dm-snapshot-use-rounddown_pow_of_two.patch
+agk-dm-dm-crypt-move-convert_context-inside-dm_crypt_io.patch
+agk-dm-dm-crypt-remove-unnecessary-crypt_context-write-parm.patch
+agk-dm-dm-crypt-move-error-setting-outside-crypt_dec_pending.patch
+agk-dm-dm-crypt-tidy-crypt_endio.patch
+agk-dm-dm-crypt-adjust-io-processing-functions.patch
+agk-dm-dm-crypt-store-sector-mapping-in-dm_crypt_io.patch
+agk-dm-dm-crypt-abstract-crypt_write_done.patch
+agk-dm-dm-crypt-introduce-crypt_write_io_loop.patch
+agk-dm-dm-crypt-tidy-io-ref-counting.patch
+agk-dm-dm-crypt-move-bio-submission-to-thread.patch
+agk-dm-dm-crypt-extract-scatterlist-processing.patch

 device mapper updates

+agk-dm-dm-ioctl-move-compat-code-fix.patch

 Fix it

+arch-powerpc-remove-duplicate-includes.patch
+arch-ppc-remove-duplicate-includes.patch
+arch-ppc-remove-an-unnecessary-pci_dev_put.patch
+powerpc-kill-non-existent-symbols-from-ksyms-and-commproch.patch
+powerpc-fix-fs_enet-module-build.patch
+powerpc-fix-typo-ifdef-ifndef.patch

 powerpc things

+gregkh-driver-kobject-remove-incorrect-comment-in-kobject_rename.patch
+gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
+gregkh-driver-aoechr-convert-from-class_device-to-device.patch
+gregkh-driver-atm-convert-struct-class_device-to-struct-device.patch
+gregkh-driver-coda-convert-struct-class_device-to-struct-device.patch
+gregkh-driver-dma-convert-from-class_device-to-device-for-dma-engine.patch
+gregkh-driver-drm-convert-from-class_device-to-device-in-drivers-char-drm.patch
+gregkh-driver-ide-convert-from-class_device-to-device-for-ide-tape.patch
+gregkh-driver-isdn-convert-from-class_device-to-device-for-isdn-capi.patch
+gregkh-driver-adb-convert-from-class_device-to-device.patch
+gregkh-driver-mcp_ucb1200-convert-from-class_device-to-device.patch
+gregkh-driver-mtd-convert-from-class_device-to-device-for-mtd-mtdchar.patch
+gregkh-driver-paride-convert-from-class_device-to-device-for-block-paride.patch
+gregkh-driver-pktcdvd-convert-from-class_device-to-device-for-block-pktcdvd.patch
+gregkh-driver-tifm-convert-from-class_device-to-device-for-ti-flash-media.patch
+gregkh-driver-cosa-convert-from-class_device-to-device-for-cosa-sync-driver.patch
+gregkh-driver-ecryptfs-sysfs-fixes.patch
+gregkh-driver-remove-struct-kobj_type-from-struct-kset.patch
+gregkh-driver-remove-kobj_set_kset_s.patch
+gregkh-driver-kset-add-kset_create_and_register-function.patch
+gregkh-driver-kobject-add-kobject_create_and_register-function.patch
+gregkh-driver-kobject-get-rid-of-kobject_add_dir.patch
+gregkh-driver-kobject-get-rid-of-kobject_kset_add_dir.patch
+gregkh-driver-kobject-convert-fuse-to-use-kobject_create.patch
+gregkh-driver-kobject-convert-securityfs-to-use-kobject_create.patch
+gregkh-driver-kobject-convert-debugfs-to-use-kobject_create.patch
+gregkh-driver-kobject-convert-configfs-to-use-kobject_create.patch
+gregkh-driver-kset-convert-ecryptfs-to-use-kset_create.patch
+gregkh-driver-kobject-convert-main-fs-kobject-to-use-kobject_create.patch
+gregkh-driver-kset-convert-gfs2-to-use-kset_create.patch
+gregkh-driver-kset-convert-gfs2-dlm-to-use-kset_create.patch
+gregkh-driver-kset-convert-dlm-to-use-kset_create.patch
+gregkh-driver-kset-convert-pci-hotplug-to-use-kset_create_and_register.patch
+gregkh-driver-kset-remove-decl_subsys_name.patch
+gregkh-driver-kset-convert-kernel_subsys-to-use-kset_create.patch
+gregkh-driver-kset-convert-drivers-base-busc-kset_create_and_register.patch
+gregkh-driver-kset-convert-drivers-base-classc-kset_create_and_register.patch
+gregkh-driver-kset-convert-drivers-base-firmwarec-kset_create_and_register.patch
+gregkh-driver-kset-convert-sys-devices-to-use-kset_create.patch
+gregkh-driver-kobject-convert-sys-hypervisor-to-use-kobject_create.patch
+gregkh-driver-kobject-convert-s390-hypervisor-to-use-kobject_create.patch
+gregkh-driver-kset-convert-sys-devices-system-to-use-kset_create.patch
+gregkh-driver-kset-convert-slub-to-use-kset_create.patch
+gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab.patch
+gregkh-driver-kset-convert-sys-module-to-use-kset_create.patch
+gregkh-driver-kset-convert-sys-power-to-use-kset_create.patch
+gregkh-driver-kset-convert-struct-bus_device-devices-to-use-kset_create.patch
+gregkh-driver-kset-convert-struct-bus_device-drivers-to-use-kset_create.patch
+gregkh-driver-driver-core-remove-owner-field-from-struct-bus_type.patch
+gregkh-driver-driver-core-add-way-to-get-to-bus-kset.patch
+gregkh-driver-driver-core-add-way-to-get-to-bus-device-klist.patch
+gregkh-driver-driver-core-remove-fields-from-struct-bus_type.patch
+gregkh-driver-kobject-kobj_attribute-handling.patch
+gregkh-driver-kset-convert-to-kobj_sysfs_ops.patch
+gregkh-driver-struct-user_info-sysfs.patch
+gregkh-driver-ecryptfs-remove-version_str-file-from-sysfs.patch
+gregkh-driver-efivars-make-new_var-and-del_var-binary-sysfs-files.patch
+gregkh-driver-kobject-convert-efivars-to-kobj_attr-interface.patch
+gregkh-driver-firmware-export-firmware_kset.patch
+gregkh-driver-kset-convert-efivars-to-use-kset_create-for-the-efi-subsystem.patch
+gregkh-driver-kset-convert-efivars-to-use-kset_create-for-the-vars-sub-subsystem.patch
+gregkh-driver-kobject-convert-arm-mach-omap1-pmc-to-kobj_attr-interface.patch
+gregkh-driver-kobject-convert-pseries-powerc-to-kobj_attr-interface.patch
+gregkh-driver-kobject-convert-s390-iplc-to-kobj_attr-interface.patch
+gregkh-driver-kset-convert-s390-iplc-to-use-kset_create.patch
+gregkh-driver-kobject-convert-parisc-pdc_stable-to-kobj_attr-interface.patch
+gregkh-driver-kset-convert-parisc-pdc_stablec-to-use-kset_create.patch
+gregkh-driver-kset-kill-subsys-attr.patch
+gregkh-driver-kset-convert-edd-to-use-kset_create.patch
+gregkh-driver-kset-convert-acpi-to-use-kset_create.patch
+gregkh-driver-firmware-remove-firmware_register.patch
+gregkh-driver-firmware-change-firmware_kset-to-firmware_kobj.patch
+gregkh-driver-kset-convert-ocfs2-to-use-kset_create.patch
+gregkh-driver-kset-convert-block_subsys-to-use-kset_create.patch
+gregkh-driver-kset-remove-decl_subsys-macro.patch
+gregkh-driver-kobject-convert-kernel_kset-to-be-a-kobject.patch
+gregkh-driver-kobject-remove-subsystem_register-functions.patch
+gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse.patch
+gregkh-driver-kobject-convert-ecryptfs-to-use-kobject_create.patch
+gregkh-driver-kobject-convert-efivars-to-use-kobject_create.patch
+gregkh-driver-kobject-convert-parisc-pdc_stable-to-use-kobject_create.patch

 driver tree updates

+fix-gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse.patch
+unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
+unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc-fix.patch
+create-sys-power-when-config_pm-is-set.patch
+sysfs-fix-off-by-one-error-in-fill_read_buffer.patch
+fs-sysfs-remove-spin_lock_unlocked.patch

 Variosu fixes and updates to the driver tree

+git-drm-oops-fix.patch

 Fix crash in git-drm.patch

-git-dvb-fixup.patch

 Unneeded

+remove-saa7134-oss.patch

 DVB cleanup

+jdelvare-i2c-i2c-dev-add-comments.patch
+jdelvare-i2c-i2c-slave-busy-only-if-has-driver.patch
+jdelvare-i2c-i2c-make-i2c_check_addr-static.patch
+jdelvare-i2c-i2c-pasemi-replace-obsolete-driverfs-reference.patch
+jdelvare-i2c-i2c-eeprom-hide-serial-to-non-root-users.patch
+jdelvare-i2c-i2c-eeprom-recognize-vgn-prefix-as-vaio.patch
+jdelvare-i2c-i2c-nforce2-nforce2-supports-block-and-reset.patch
+jdelvare-i2c-i2c-pasemi-use-i2c_add_numbered_adapter.patch
+jdelvare-i2c-i2c-pasemi-fix-nack-detection.patch
+jdelvare-i2c-i2c-ibm_iic-whitespace-cleanups.patch
+jdelvare-i2c-i2c-pcf8575-new-driver.patch
+jdelvare-i2c-i2c-tsl2550-add-power-management.patch
+jdelvare-i2c-i2c-stub-mention-helper-script.patch
+jdelvare-i2c-i2c-stub-single-array.patch
+jdelvare-i2c-i2c-remove-deprecated-rtc-drivers.patch
+jdelvare-i2c-i2c-pxa-use-cpu_is_pxa27x.patch
+jdelvare-i2c-i2c-algo-bit-whitespace-cleanups.patch
+jdelvare-i2c-i2c-algo-bit-sendbyte-error-code.patch

 I2C tree updates

+check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
+check-for-acpi-resource-conflicts-in-hwmon-drivers.patch

 Some i2c/hwmon/acpi work.

-git-hwmon-fixup.patch

 Unneeded

+hwmon-replace-power-of-two-test-in-drivers-hwmon-adt7470c.patch

 hwmon cleanup

+clocksource-make-clocksource_mask-bullet-proof.patch

 time management cleanup

+ia64-slim-down-__clear_bit_unlock.patch
+ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
+rename-_bss-to-__bss_start.patch
+ia64-efi-make-full-use-of-macro-efi_md_size.patch

 ia64 fixes

-git-input-fixup.patch

 Unneeded

-first-stab-at-elantech-touchpad-driver-for-26226-testers.patch

 Updated

+fujitsu-application-panel-driver.patch
+fujitsu-application-panel-driver-space-savings.patch
+elantech-touchpad-driver.patch
+elantech-touchpad-driver-fix.patch

 Input things

+kconfig-use-getopt-in-confc-for-handling-command-line.patch
+cscope-build-warning.patch

 kbuild things

+pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
+#
+ata_generic-unindent-loop-in-generic_set_mode.patch
+libata-export-xfermode--pata-timing-related-functions.patch
+libata-clean-up-xfermode--pata-timing-related-stuff.patch
+libata-kill-ata_id_to_dma_mode.patch
+libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
+libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch
+libata-fix-ata_acpi_gtm_xfermask.patch
+libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch
+libata-implement-ata_acpi_init_gtm.patch
+libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
+libata-add-ata_cbl_pata_ign.patch
+pata_amd-update-mode-selection-for-nv-patas.patch

 libata stuff.

+ide-mm-ide-remove-dma-master-field-from-ide-hwif-t-take-5.patch
+ide-mm-ide-remove-task-ioreg-t-typedef-take-2.patch
+ide-mm-ide-add-struct-ide_taskfile-take-2.patch
+ide-mm-ide-disk-merge-lba28-and-lba48-host-protected-area-support-code-take-2.patch
+ide-mm-ide-disk-fix-taskfile-registers-loading-order-in-__ide_do_rw_disk.patch
+ide-mm-ide-disk-use-struct-ide_taskfile-in-__ide_do_rw_disk.patch
+ide-mm-ide-add-ide_tf_load-helper.patch
+ide-mm-ide-add-ide_no_data_taskfile-helper.patch
+ide-mm-ide-use-do-rw-taskfile-in-flagged-taskfile.patch
+ide-mm-ide-pmac-fix-pmac_ide_init_hwif_ports.patch
+ide-mm-ide-remove-irqf_disabled-from-irq-flags-for-ide-irq-handler.patch
+ide-mm-ide-remove-config_idepci_share_irq-config-option.patch
+ide-mm-ide-remove-stale-ide-h-configuration-options.patch
+ide-mm-ide-tape-remove-dead-use_iotrace-code.patch
+ide-mm-ide-use-drive-select-all-for-req_type_ata_task-in-execute_drive_cmd.patch
+ide-mm-ide-fix-registers-loading-order-for-win_smart-in-execute_drive_cmd.patch
+ide-mm-ide-fix-registers-loading-order-for-ide_nsector_reg-in-execute_drive_cmd.patch
+ide-mm-ide-execute_drive_cmd-cleanup.patch
+ide-mm-ide-remove-ide_cmd-helper.patch
+ide-mm-ide-use-ide_tf_load-in-execute_drive_cmd.patch
+ide-mm-ide-use-ide_tflag_lba48-for-req_type_ata_taskfile-requests.patch
+ide-mm-ide-remove-unnecessary-writes-to-hob-taskfile-registers.patch
+ide-mm-ide-extend-timeout-for-req_type_ata_cmd_task-requests.patch
+ide-mm-ide-switch-idedisk_prepare_flush-to-use-req_type_ata_taskfile-requests.patch
+ide-mm-ide-switch-ide_task_ioctl-to-use-req_type_ata_taskfile-requests.patch
+ide-mm-ide-remove-req_type_ata_task.patch
+ide-mm-ide-floppy-remove-dead-code.patch
+ide-mm-ide-cpu-endianness-doesn-t-matter-for-special_t.patch
+ide-mm-ide-remove-ata_status_t-and-atapi_status_t.patch
+ide-mm-ide-remove-atapi_error_t-take-2.patch
+ide-mm-ide-remove-atapi_feature_t.patch
+ide-mm-ide-remove-ata_nsector_t-ata_data_t-and-atapi_bcount_t.patch
+ide-mm-ide-remove-atapi_ireason_t-take-3.patch
+ide-mm-ide-cd-fix-register-loading-order-in-cdrom_start_packet_command.patch
+ide-mm-ide-floppy-tape-scsi-fix-register-loading-order-when-issuing-packet-command.patch
+ide-mm-ide-add-ide_pktcmd_tf_load-helper.patch
+ide-mm-ide-remove-quirk_list.patch
+ide-mm-ide-remove-select_interrupt.patch
+ide-mm-ide-remove-hwif-intrproc.patch
+ide-mm-ide-remove-command-type-field-from-ide_task_t.patch
+ide-mm-ide-remove-tf_in_flags-field-from-ide_task_t.patch
+ide-mm-sc1200-remove-pointless-hwif-lookup-loop.patch
+ide-mm-ide-disk-fix-__ide_do_rw_disk-to-use-outbsync.patch
+ide-mm-ide-disk-guarantee-400ns-delay-after-writing-command-register.patch
+ide-mm-ide-merge-flagged_taskfile-into-do_rw_taskfile.patch
+ide-mm-ide-convert-do_rw_taskfile-to-use-data_phase.patch
+ide-mm-ide-use-data_phase-to-set-handler-in-do_rw_taskfile.patch
+ide-mm-ide-remove-handler-field-from-ide_task_t-take-2.patch
+ide-mm-ide-disk-extend-timeout-for-pio-out-commands.patch
+ide-mm-ide-disk-add-ide_tf_set_cmd-helper.patch
+ide-mm-ide-disk-use-do_rw_taskfile.patch
+ide-mm-ide-pmac-skip-conservative-pio-downgrade.patch
+ide-mm-ide-add-missing-hob-bit-clearing-to-ide_dump_ata_status.patch
+ide-mm-ide-fix-registers-loading-order-in-ide_dump_ata_status.patch
+ide-mm-ide-add-ide_tf_read-helper.patch
+ide-mm-ide-disk-use-ide_get_lba_addr.patch
+ide-mm-ide-kill-duplicate-code-in-ide_dump_ata_atapi_status.patch
+ide-mm-ide-make-extra-field-in-struct-ide_port_info-u8.patch
+ide-mm-pdc202xx_new-move-pio-programming-code-to-pdcnew_set_pio_mode.patch
+ide-mm-sis5513-factor-out-udma-programming-code.patch
+ide-mm-ide-dont-bug-on-unsupported-transfer-modes.patch
+ide-mm-ide-add-ide_hflag_abuse_set_dma_mode-host-flag.patch
+ide-mm-sc1200-move-dma-timings-to-timing-tables.patch
+ide-mm-ide-remove-redundant-ide_dma_on-call-from-set_using_dma.patch
+ide-mm-ide-cleanup-ide_set_dma.patch
+ide-mm-ide-remove-redundant-dma-blacklist-check-from-__ide_dma_on.patch
+ide-mm-sl82c105-program-dma-pio-timings-in-dma_start-and-ide_dma_end.patch
+ide-mm-sl82c105-remove-no-longer-needed-selectproc-method.patch

 IDE tree updates

+ide-add-helper-__ide_setup_pci_device.patch
+blk_dev_idecd-help-remove-outdated-note.patch

 IDE things

+m32r-remove-dead-config-symbols-from-m32r-code.patch

 m32r cleanup

+mips-remove-dead-config-symbols-from-mips-code.patch

 mips cleanup

-git-mmc-fixup2.patch

 Unneeded

+mmc-sd-write-operation-in-invalid-states-by-borken-cards.patch

 mmc fix

-git-mtd-fixup.patch
-git-mtd-borkage.patch

 Unneeded

+eccbuf-is-statically-defined-and-always-evaluate-to-true.patch

 dvb cleanup

-git-net-fixup.patch

 Unneeded

+pfkey-sending-an-sadb_get-responds-with-an-sadb_get.patch
+make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
+tlan-list-is-subscribers-only.patch
+remove-references-to-net-modulestxt.patch
+net-sunrpc-remove-spin_lock_unlocked.patch

 net things

-forcedeth-power-down-phy-when-interface-is-down-checkpatch-fixes.patch

 Folded into  forcedeth-power-down-phy-when-interface-is-down.patch

+forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
+ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
+drivers-net-chelsio-if-0-unused-functions.patch
+pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
+forcedeth-new-mcp79-device-ids.patch
+net-ibm_newemac-remove-spin_lock_unlocked.patch

 netdev things

+ucc_geth-fix-module-removal.patch
+ucc_geth-add-support-for-netpoll.patch
+phy-implement-release-function.patch

 More netdev things

+blackfin-typo-config_rtc_bfin_module.patch

 blackfin cleanup

+bluetooth-hidp_process_hid_control-remove-unnecessary-parameter-dealing.patch
+bluetooth-uninlining.patch
+drivers-bluetooth-bpa10xc-fix-memleak.patch
+drivers-bluetooth-btsdioc-fix-double-free.patch
+bluetooth-blacklist-another-broadcom-bcm2035-device.patch

 bluetooth things

-git-nfs-vs-git-unionfs.patch

 Unneeded

+nfs-stop-sillyname-renames-and-unmounts-from-racing.patch
+nfs-stop-sillyname-renames-and-unmounts-from-racing-fix.patch
+nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix.patch
+nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix-fix.patch
+fs-nfs-dirc-should-include-internalh.patch
+nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch

 NFS fixes

+arch-parisc-remove-duplicate-includes.patch

 parisc cleanup (err, looks like it needs to be dropped now)

+pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
+pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch

 pcmcia work

+blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch
+drivers-serial-s3c2410c-remove-dead-config-symbols.patch

 blackfin stuff

+gregkh-pci-pci-make-pci_restore_bars-static.patch
+gregkh-pci-pci-drivers-pci-romc-if-0-two-functions.patch
+gregkh-pci-pci-drivers-pci-remove-unused-exports.patch
+gregkh-pci-pcie-port-driver-correctly-detect-native-pme-feature.patch
+gregkh-pci-pcie-utilize-pcie-transaction-pending-bit.patch

 PCI tree updates

+mem-policy-fix-mempolicy-usage-in-pci-driver.patch
+pci-get-rid-of-pci_devvendordevice_compatible-fields.patch
+quirk_vialatency-omit-reading-pci-revision-id.patch
+quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
+pci-remove-unneeded-lock_kernel-in-drivers-pci-syscallc.patch
+always-export-pci_scan_single_device.patch
+remove-additional-pci_scan_child_bus-prototype.patch

 PCI things

+pci-hotplug-mm-pci-hotplug-pciehp-deal-with-pre-inserted-expresscards.patch
+pci-hotplug-mm-pci-hotplug-pciehp-split-out-hardware-init-from-pcie_init.patch
+pci-hotplug-mm-pci-hotplug-pciehp-reinit-hotplug-h-w-on-resume-from-suspend.patch

 PCI hotplug tree

+fix-build-breakage-if-sysfs-fix.patch
+track-accurate-idle-time-with-tick_schedidle_sleeptime.patch

 sched things

-git-scsi-misc-fixup.patch

 Uneeded

+git-scsi-misc-gdth-fix.patch

 Fix git-scsi-misc

+kill-warnings-in-mptbaseh-on-parisc64.patch
+hptiop-fix-type-mismatch-warning.patch
+ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
+ips-trim-trailing-whitespace.patch
+ips-trim-trailing-whitespace-checkpatch-fixes.patch
+ips-pci-api-cleanups.patch
+ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
+megaraid-driver-management-char-device-moved-to-misc.patch
+scsi-gdth-kill-unneeded-irq-argument.patch
+scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
+scsi-sym53c416-kill-pointless-irq-handler-loop-and-test.patch
+scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers.patch
+scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
+scsi-ncr5380-minor-irq-handler-cleanups.patch
+megaraid-sas-convert-aen_mutex-to-the-mutex-api.patch
+advansys-fix-section-mismatch-warning.patch
+aic94-fix-section-mismatches.patch
+sym2-fix-section-mismatch-warning.patch
+aacraid-driver-fails-with-dell-poweredge-expandable-raid-controller-3-di.patch
+scsi-advansysc-make-3-functions-static.patch
+update-kerneldoc-comments-in-drivers-scsi-scsicamc.patch
+scsi-qla2xxx-possible-cleanups.patch
+libsas-convert-sas_proto-users-to-sas_protocol.patch
+libsas-fix-various-sparse-complaints.patch

 scsi things

+bidi-support-sr-sd-remove-dead-code.patch
+bidi-support-tgt-use-scsi_init_io-instead-of-scsi_alloc_sgtable.patch
+bidi-support-scsi_data_buffer.patch
+bidi-support-scsi_data_buffer-broke-qla1280.patch
+bidi-support-scsi_data_buffer-broke-lots-of-stuff.patch
+scsi-bidi-support.patch

 bidirectional scsi support

-git-block-fixup-1.patch
-git-block-fixup.patch
-git-block-fixup-fix.patch
-git-block-borkages.patch
-git-block-s390-fix.patch

 Uneeded/merged

+unionfs-clear-partial-read.patch
+vfs-apply-coding-standards-to-fs-ioctlc.patch
+vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
+vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
+vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls.patch

 Stuff related to unionfs

+gregkh-usb-usb-fix-usb_ohci_hcd_ssb-dependencies.patch
+gregkh-usb-usb-omap_udc-build-fix.patch
+gregkh-usb-usb-storage-always-set-the-allow_restart-flag.patch
+gregkh-usb-usb-convert-from-class_device-to-device-for-usb-core.patch
+gregkh-usb-usb-remove-unnecessary-zeroing-from-ub.patch
+gregkh-usb-usb-autosuspend-for-cdc-acm.patch

 USB tree updates

+usb-hcd-avoid-duplicate-local_irq_disable.patch
+usb-s3c2410_udc-minor-irq-handler-cleanups.patch
+usbserial-fix-inconsistent-lock-state.patch
+sis-fb-driver-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch
+usb-fix-locks-and-urb-status-in-adutux-updated.patch
+usb-mon-mon_binc-cleanups.patch
+usb-power-managementtxt-disconnect-clarification.patch
+usb-device-dma-support-on-omap2.patch

 USB things I picked up

+watchdog-add-nano-7240-driver-2.patch

 New watchdog driver

-git-wireless-fixup.patch
-git-wireless-ath5k-broke.patch

 Uneeded

+jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
+iwlwifi-remove-unnecessary-code-in-iwl3945-and-iwl4965-drivers.patch

 wireless things

-x86_64-mm-prefetch-builtin.patch
-x86_64-mm-remove-serialize-cpu.patch
-x86_64-mm-defconfig-update.patch
-x86_64-mm-i386-defconfig-update.patch
-x86_64-mm-misc_-constifications.patch
-x86_64-mm-constify-stacktrace_ops.patch
-x86_64-mm-tsc-unstable.patch
-x86_64-mm-sched-clock-share.patch
-x86_64-mm-sched-clock64.patch
-x86_64-mm-early-quirks-unification.patch
-x86_64-mm-nvidia-timer-quirk.patch
-x86_64-mm-fam11-rep-good.patch
-x86_64-mm-clean-up-duplicate-includes-in-arch-i386-kernel.patch
-x86_64-mm-x86_64-sanitize-user-specified-e820-memmap-values.patch
-x86_64-mm-no-video-module.patch
-x86_64-mm-create-clflush-inline-remove-hardcoded-wbinvd.patch
-x86_64-mm-i386-add-amd64-barcelona-pmu-msr-definitions.patch
-x86_64-mm-do-not-bug_on-when-msr-is-unknown.patch
-x86_64-mm-make-oprofile-call-shutdown-only-once-per-session.patch
-x86_64-mm-0-null-for-arch-x86_64.patch
-x86_64-mm-pci-gart-cleanups.patch
-x86_64-mm-iommu-merge.patch
-x86_64-mm-make-callgraph-use-dump_trace-on-i386-x86_64.patch
-x86_64-mm-introduce-frame_pointer-and-stack_pointer.patch
-x86_64-mm-remove-sync_arb_ids.patch
-x86_64-mm-clear-io_apic-before-enabing-apic-error-vector.patch
-x86_64-mm-convert-mm_context_t-semaphore-to-a-mutex.patch
-x86_64-mm-clean-up-apicid_to_node-declaration.patch
-x86_64-mm-consolidate-show_regs-and-show_registers-for-i386.patch
-x86_64-mm-mtrr-smp-call-function.patch
-x86_64-mm-make-struct-apic_probe-static.patch
-x86_64-mm-hide-cond_syscall-behind-__kernel.patch
-x86_64-mm-es7000-cleanups.patch
-x86_64-mm-no-need-to-make-enable_cpu_hotplug-a-variable.patch
-x86_64-mm-make-some-variables-static.patch
-x86_64-mm-kmalloc-memset-conversion-to-kzalloc.patch
-x86_64-mm-remove-maccumulate-outgoing-args.patch
-x86_64-mm-setup_trampoline-must-be-__cpuinit.patch
-x86_64-mm-block-irq-balancing-for-timer.patch
-x86_64-mm-deactivate-the-test-for-the-dead-config_debug_page_type.patch
-x86_64-mm-remove-unnecessary-code.patch
-x86_64-mm-use-descriptors-functions-instead-of-inline-assembly.patch
-x86_64-mm-clean-up-duplicate-includes-in-arch-i386-xen.patch
-x86_64-mm-implify-smp_call_function_single-call-sequence.patch
-x86_64-mm-simplify-smp_call_function_single-call-sequence.patch
-x86_64-mm-store-core-id-bits-in-cpuinfo_x8.patch
-x86_64-mm-use-core-id-bits-for-apicid_to_node-initialization.patch
-x86_64-mm-remove-never-used-apic_mapped.patch
-x86_64-mm-add-cpu-codenames-for-kconfig_cpu.patch
-x86_64-mm-remove-unordered-io.patch
-x86_64-mm-make-atomic64_t-work-like-atomic_t.patch
-x86_64-mm-remove-strrchr.patch
-x86_64-mm-change-order-in-kconfig_cpu.patch
-x86_64-mm-clean-up-oops-bug-reports.patch
-x86_64-mm-expand-proc-interrupts-to-include-missing-vectors.patch
-x86_64-mm-remove-x86_cpu_to_log_apicid.patch
-x86_64-mm-validate-against-acpi-motherboard-resources.patch
-x86_64-mm-vdso-compat-install-unstripped-copies-on-disk.patch
-x86_64-mm-vdso-64bit-install-unstripped-copies-on-disk.patch
-x86_64-mm-bp-apic-init.patch
-x86_64-mm-cpa-clflush.patch
-x86_64-mm-cpa-cleanup.patch
-x86_64-mm-cpa-einval.patch
-x86_64-mm-cpa-arch-macro.patch
-x86_64-mm-remove-str-macros.patch
-x86_64-mm-save-registers-in-saved_context-during-suspend-and-hibernation.patch
-x86_64-mm-svm-disabled.patch
-x86_64-mm-mm-init-indent.patch
-x86_64-mm-msr-cpuinit.patch
-x86_64-mm-cpuid-cpuinit.patch
-x86_64-mm-implement-missing-x86_64-function-smp_call_function_mask.patch
-x86_64-mm-eliminate-result-signage-problem-in-asm-x86_64-bitops_h.patch
-x86_64-mm-add-parenthesis-to-irq-vector-macros.patch
-x86_64-mm-export-i386-smp_call_function_mask-to-modules.patch
-x86_64-mm-remove-duplicated-nsec-update.patch
-x86_64-mm-remove-stub-early_printk_c.patch
-x86_64-mm-honor-_page_pse-bit-on-page-walks.patch
-x86_64-mm-remove-some-dead-code.patch
-x86_64-mm-honor-notify_die-returning-notify_stop.patch
-x86_64-mm-optionally-show-last-exception-from-to-register-contents.patch
-x86_64-mm-rename-_i-assembler-includes-to-_h.patch
-x86_64-mm-fix-argument-signedness-warnings.patch
-x86_64-mm-cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
-x86_64-mm-die-lock.patch
-x86_64-mm-mce-setup.patch
-x86_64-mm-fix-off-by-one-in-find_next_zero_string.patch
-x86_64-mm-fix-4-bit-apicid-assumption-of-mach-default.patch
-x86_64-mm-fix-section-mismatch.patch
-x86_64-mm-fix-section-mismatch-warning-in-intel_c.patch
-x86_64-mm-constify-wd_ops.patch
-x86_64-mm-multi-byte-single-instruction-nops.patch
-x86_64-mm-introduce-used_vectors-bitmap-which-can-be-used-to-reserve-vectors.patch
-x86_64-mm-configure-hpet_emulate_rtc-automatically.patch
-x86_64-mm-also-show-non-zero-irq-counts-for-vectors-that-currently-dont-have-a-handler.patch
-x86_64-mm-avoid-temporarily-inconsistent-pte-s.patch
-x86_64-mm-return-correct-error-code-from-child_rip-in-x86_64-entry_s.patch
-x86_64-mm-agp-flush.patch
-x86_64-mm-aout-regs.patch
-x86_64-mm-fix-watchdog.patch
-x86_64-mm-mark-read_crx-asm-code-as-volatile.patch
-x86_64-mm-call-free_init_pages-with-irqs-enabled-in-alternative_instructions.patch
-x86_64-mm-ptrace-compat-tls.patch

 This tree is no more.  Most of it was merged.

+git-x86-broke-lguest.patch
+git-x86-broke-xen-too.patch
+git-x86-inlining-borkage.patch

 Fix git-x86.patch

+i386-fix-reboot-with-no-keyboard-attached.patch
+oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters.patch
+oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
+remove-extern-declarations-for-code-data-bss-resource.patch
+x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
+x86_64-do-not-clear-cpu_index-set-by-store_cpu_info.patch
+x86-typo-about-sequence-of-cpu_index-and-cpu_online-in.patch
+i386-and-x86_64-randomize-brk.patch
+i386-and-x86_64-randomize-brk-fix.patch
+i386-and-x86_64-randomize-brk-fix-2.patch
+x86-bitops_32h-style-cleanups.patch
+x86-check-boundary-in-count-setup_resource-called-by.patch
+arch-x86-remove-duplicate-includes.patch
+x86-arch_register_cpu-section-fix.patch
+i386-reboot-fixup-for-wrap-2c-board-sc1100-based.patch
+fix-wrong-proc-cpuinfo-on-x64.patch
+x86_64-clean-up-stack-allocation-and-free.patch
+x86_64-configure-stack-size.patch
+ia32-emu-remove-dead-code.patch

 x86 things

+git-cryptodev-hifn_795x-fixes.patch

 Fix git-cryptodev.patch

+xtensa-iss_net_setup-must-be-__init.patch
+arch-xtensa-remove-duplicate-includes.patch
+xtensa-kernel-setupc-remove-dead-code.patch

 xtensa things

-git-kgdb.patch

 Temporarily dropped

-git-kgdb-fixup.patch
-git-kgdb-be-modern.patch
-disable-kgdb-on-ppc.patch

 Merged or unneeded

+i-oat-add-support-for-version-2-of-ioatdma-device.patch
+reiserfs-dont-drop-pg_dirty-when-releasing-sub-page-sized-dirty-file.patch
+rtc-release-correct-region-in-error-path.patch
+rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
+i5000_edac-no-need-to-__stringify-kbuild_basename.patch
+serial-only-use-pnp-irq-if-its-valid.patch
+sunrpc-xprtrdma-transportc-fix-use-after-free.patch
+fix-mm-utilckrealloc.patch
+fuse_file_alloc-fix-null-dereferences.patch
+tle62x0-driver-stops-ignoring-read-errors.patch
+rd-fix-data-corruption-on-memory-pressure.patch
+cris-gpio-undo-locks-before-returning.patch
+mips-undo-locking-on-error-path-returns.patch
+mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
+nfs-fix-the-ustat-regression.patch
+proc-simplify-and-correct-proc_flush_task.patch
+fix-param_sysfs_builtin-name-length-check.patch
+rtc-convert-mutex-to-bitfield.patch
+mark-sys_open-sys_read-exports-unused.patch
+sysctl-fix-token-ring-procname.patch
+gbefb-fix-section-mismatch-warnings.patch
+vmstat-fix-section-mismatch-warning.patch
+pidns-place-under-config_experimental.patch
+pidns-place-under-config_experimental-checkpatch-fixes.patch
+__do_irq-does-not-check-irq_disabled-when-irq_per_cpu-is-set.patch
+hibernate-fix-lockdep-report-2.patch
+smbfs-fix-debug-builds.patch
+fix-64kb-blocksize-in-ext3-directories.patch
+fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
+uml-fix-spurious-irq-testing.patch
+uml-remove-last-include-of-libc-asm-pageh.patch
+uml-fix-build-for-config_tcp.patch
+uml-fix-build-for-config_printk.patch
+swap-delay-accounting-include-lock_page-delays.patch
+file-capabilities-allow-sigcont-within-session-v2.patch
+file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
+file-capabilities-allow-sigcont-within-session-v2-file-capabilities-remove-the-non-matching-uid-special-case-for-kill.patch
+feature-removal-schedule-remove-sa_-flags-entry.patch
+kernel-taskstatsc-fix-bogus-nlmsg_free.patch
+x86-show-cpuinfo-only-for-online-cpus.patch
+make-proc-acpi-ac_adapter-dependent-on-acpi_procfs.patch
+acpi-ac-update-ac-state-on-resume.patch
+keyspan-init-termios-properly.patch
+x86-disable-preemption-in-delay_tsc.patch
+tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch
+oprofile-fix-oops-on-x86-32-bit.patch
+x86-early_quirks-cleanup.patch
+x86-dont-call-mce_create_device-on-cpu_up_prepare.patch
+aic94xx_sds-rename-flash_size.patch
+ia64-increase-datapatch-offset.patch
+ia64-dont-assume-that-unwcheckpy-is-executable.patch
+ia64-export-copy_page-to-modules.patch
+ia64-export-copy_page-to-modules-fix.patch
+mips-pcspkr-build-fix.patch
+drm-i915-fix-pointer-strip.patch
+pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch

 More 2.6.24 material.  This is supposed to be the
 merge-via-subsystem-maintainers queue but it look like I misplaced a few
 patches there - I'll merge them directly.

+pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
+pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
+pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
+move-vmalloc_to_page-to-mm-vmalloc.patch
+vmalloc-add-const-to-void-parameters.patch
+i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
+i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
+is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
+vmalloc-clean-up-page-array-indexing.patch
+vunmap-return-page-array-passed-on-vmap.patch
+slub-move-count_partial.patch
+slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
+slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
+slub-use-non-atomic-bit-unlock.patch
+slub-fix-coding-style-violations.patch
+slub-fix-coding-style-violations-checkpatch-fixes.patch
+slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
+slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
+slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
+slub-__slab_alloc-exit-path-consolidation.patch
+slub-provide-unique-end-marker-for-each-slab.patch
+slub-provide-unique-end-marker-for-each-slab-fix.patch
+slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
+slub-optional-fast-path-using-cmpxchg_local.patch
+slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
+slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
+slub-do-our-own-locking-via-slab_lock-and-slab_unlock-fix.patch
+slub-restructure-slab-alloc.patch
+slub-comment-kmem_cache_cpu-structure.patch
+vm-allow-get_page_unless_zero-on-compound-pages.patch
+bufferhead-revert-constructor-removal.patch
+bufferhead-revert-constructor-removal-checkpatch-fixes.patch
+hugetlb-allow-sticky-directory-mount-option.patch
+swapin_readahead-excise-numa-bogosity.patch
+swapin_readahead-move-and-rearrange-args.patch
+swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
+shmem-sgp_quick-and-sgp_fault-redundant.patch
+shmem_getpage-return-page-locked.patch
+shmem_file_write-is-redundant.patch
+swapin-fix-valid_swaphandles-defect.patch
+swapoff-scan-ptes-preemptibly.patch
+clean-up-vmtruncate.patch
+maps4-add-proportional-set-size-accounting-in-smaps.patch
+maps4-rework-task_size-macros.patch
+maps4-rework-task_size-macros-mips-fix.patch
+maps4-move-is_swap_pte.patch
+maps4-introduce-a-generic-page-walker.patch
+maps4-use-pagewalker-in-clear_refs-and-smaps.patch
+maps4-simplify-interdependence-of-maps-and-smaps.patch
+maps4-move-clear_refs-code-to-task_mmuc.patch
+maps4-regroup-task_mmu-by-interface.patch
+maps4-add-proc-pid-pagemap-interface.patch
+maps4-add-proc-kpagecount-interface.patch
+maps4-add-proc-kpageflags-interface.patch
+maps4-make-page-monitoring-proc-file-optional.patch
+maps4-make-page-monitoring-proc-file-optional-fix.patch
+memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
+add-remove_memory-for-ppc64-2.patch
+enable-hotplug-memory-remove-for-ppc64.patch
+add-arch-specific-walk_memory_remove-for-ppc64.patch
+mm-page-writebackc-make-a-function-static.patch
+remove-unused-code-from-mm-tiny-shmemc.patch
+tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
+make-__vmalloc_area_node-static.patch
+radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
+page-allocator-clean-up-pcp-draining-functions.patch
+add-mm-argument-to-pte-pmd-pud-pgd_free.patch
+config_highpte-vs-sub-page-page-tables.patch
+config_highpte-vs-sub-page-page-tables-fix.patch
+arch_rebalance_pgtables-call.patch

 Mammary manglement.

-maps2-uninline-some-functions-in-the-page-walker.patch
-maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
-maps2-remove-vma-from-args-in-the-page-walker.patch
-maps2-propagate-errors-from-callback-in-page-walker.patch
-maps2-add-callbacks-for-each-level-to-page-walker.patch
-maps2-move-the-page-walker-code-to-lib.patch
-maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
-maps2-move-clear_refs-code-to-task_mmuc.patch
-maps2-regroup-task_mmu-by-interface.patch
-maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
-maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
-maps2-add-proc-pid-pagemap-interface.patch
-maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch
-maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch
-maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace.patch
-maps2-add-proc-kpagemap-interface.patch
-mmaps2-vma-out-of-mem_size_stats.patch
-maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
-maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
-maps-pssproportional-set-size-accounting-in-smaps.patch

 Updated

+vfs-security-rework-inode_getsecurity-and-callers-to.patch
+vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
+revert-capabilities-clean-up-file-capability-reading.patch
+revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
+add-64-bit-capability-support-to-the-kernel.patch
+add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
+add-64-bit-capability-support-to-the-kernel-fix.patch
+add-64-bit-capability-support-to-the-kernel-fix-fix.patch
+remove-unnecessary-include-from-include-linux-capabilityh.patch

 security things

+netlabel-introduce-a-new-kernel-configuration-api-for-netlabel.patch

 Some of Smack.

+frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
+frv-move-dma-macros-to-scatterlisth-for-consistency.patch
+frv-remove-dead-config-symbol-from-frv-code.patch

 frv updates

+blackfin-remove-dump_thread.patch

 blackfin stuff

+m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer.patch
+m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver.patch
+m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver.patch
+m68knommu-use-array_size-in-coldfire-serial-driver.patch
+add-build-support-for-new-coldfire-serial-driver.patch
+add-configure-support-for-new-coldfire-serial-driver.patch
+m68knommu-platform-setup-for-5206-coldfire-uarts.patch
+m68knommu-platform-setup-for-5206e-coldfire-uarts.patch
+m68knommu-platform-setup-for-520x-coldfire-uarts.patch
+m68knommu-platform-setup-for-5249-coldfire-uarts.patch
+m68knommu-platform-setup-for-5272-coldfire-uarts.patch
+m68knommu-remove-vestiges-of-non-existent-disktel.patch
+m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch

 m68knommu queue

+arch-alpha-removed-duplicate-includes.patch
+alpha-atomic_add_return-should-return-int.patch

 alpha queue

+kernel-power-diskc-make-code-static.patch
+make-kernel_shutdown_prepare-static.patch
+kernel-power-move-function-prototypes-to-header.patch

 Power management queue

-pm-qos-infrastructure-and-interface-fix.patch
-pm-qos-infrastructure-and-interface-vs-git-acpi.patch
-pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch

 Folded into pm-qos-infrastructure-and-interface.patch

+pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch

 and fix it some more.

+m68k-use-cc-cross-prefix.patch

 m68k fix

+cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
+cris-build-fixes-add-missing-syscalls.patch
+cris-build-fixes-hardirqh-include-asm-irqh.patch
+cris-build-fixes-atomich-needs-compilerh.patch
+cris-build-fixes-atomich-needs-compilerh-fix.patch
+cris-build-fixes-irq-fixes.patch
+cris-build-fixes-sys_crisc-needs-fsh.patch
+cris-build-fixes-add-baud-rate-defines.patch
+cris-build-fixes-update-eth_v10c-ethernet-driver.patch
+cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
+cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
+cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
+cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
+cris-build-fixes-setupc-needs-paramh.patch
+cris-build-fixes-fix-crisksymsc.patch
+cris-build-fixes-defconfig-updates.patch
+cris-array_size-cleanup.patch
+cris-dont-include-bitopsh-in-posix_typesh.patch
+crisv10-serial-driver-rewrite-take-three.patch
+cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two.patch
+cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
+crisv10-fix-timer-interrupt-parameters.patch
+crisv10-improve-and-bugfix-fasttimer.patch
+crisv32-add-cache-flush-operations.patch

 Lots of cris work.  I think I'll propose this for 2.6.24.

+uml-remove-xmm-checking-on-x86.patch
+uml-code-tidying-under-arch-um-os-linux.patch
+uml-implement-get_wchan.patch
+uml-implement-get_wchan-fix.patch
+uml-get-rid-of-asmlinkage.patch
+uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
+uml-document-new-ubd-flag.patch
+uml-fix-urls-in-kconfig-and-help-strings.patch
+uml-improve-detection-of-host-cmov.patch
+uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
+uml-remove-now-unused-code.patch
+uml-further-bugsc-tidying.patch
+uml-further-bugsc-tidying-checkpatch-fixes.patch
+uml-const-and-other-tidying.patch
+uml-smp-needs-to-depend-on-broken-for-now.patch
+uml-gprof-needs-to-depend-on-frame_pointer.patch
+uml-console-driver-cleanups.patch
+uml-clonec-tidying.patch
+uml-borrow-consth-techniques.patch
+uml-delete-some-unused-headers.patch
+uml-allow-lflags-on-command-line.patch
+uml-tidy-kern_utilh.patch
+uml-tidy-pgtableh.patch
+uml-reconst-a-parameter.patch

 uml queue

+arch-um-remove-duplicate-includes.patch

 v850 cleanup

+fix-versus-precedence-in-various-places.patch
+fix-versus-precedence-in-various-places-checkpatch-fixes.patch
+bugh-remove-have_arch_bug--have_arch_warn.patch
+powerpc-switch-to-generic-warn_on-bug_on.patch
+pie-executable-randomization.patch
+pie-executable-randomization-uninlining.patch
+pie-executable-randomization-checkpatch-fixes.patch
+geode-lists-are-subscriber-only.patch
+fs-fat-refine-chmod-checks.patch
+a-potential-bug-in-inotify_userc.patch
+riscom8-fix-smp-brokenness.patch
+riscom8-fix-smp-brokenness-fix.patch
+taskstats-scaled-time-cleanup.patch
+use-wake_up_locked-in-eventpoll.patch
+use-macros-instead-of-task_-flags.patch
+use-macros-instead-of-task_-flags-checkpatch-fixes.patch
+add-task_wakekill.patch
+add-lock_page_killable.patch
+hash-add-explicit-u32-and-u64-versions-of-hash.patch
+remove-inclusions-of-linux-autoconfh.patch
+sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
+sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
+sound-oss-sb_commonc-fix-casting-warning.patch
+remove-warnings-for-longstanding-conditions.patch
+remove-warnings-for-longstanding-conditions-fix.patch
+ext2-return-after-ext2_error-in-case-of-failures.patch
+ext2-change-the-default-behaviour-on-error.patch
+sigio-driven-i-o-with-inotify-queues.patch
+remove-pointless-casts-from-void-pointers.patch
+ipc-fix-error-check-in-all-new-xxx_lock-and.patch
+kill-udffs_dateversion.patch
+genericizing-iova.patch
+dcdbas-add-dmi-based-module-autloading.patch
+parallel-port-convert-port_mutex-to-the-mutex-api.patch
+parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
+remove-support-for-un-needed-_extratext-section.patch
+remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
+optimize-i8259-code-a-bit.patch
+allow-auto-destruction-of-loop-devices.patch
+allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
+register_cpu-__devinit-or-__cpuinit.patch
+make-ipc-utilcsysvipc_find_ipc-static.patch
+cleanup-after-apus-removal.patch
+remove-mm_ptovvtop.patch
+mnt_unbindable-fix.patch
+remove-__attribute_used__.patch
+remove-__attribute_used__-checkpatch-fixes.patch
+proper-show_interrupts-prototype.patch
+fat-fix-printk-format-strings.patch
+fat-optimize-fat_count_free_clusters.patch
+scheduled-oss-driver-removal.patch
+read_current_time-cleanups.patch
+read_current_time-cleanups-build-fix.patch
+read_current_time-cleanups-build-fix-fix.patch
+mm-fix-blkdev-size-calculation-in-generic_write_checks.patch
+smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive.patch
+linux-inith-simplify-__meminitexit-dependencies.patch
+proper-prototype-for-signals_init.patch
+kernel-ptracec-should-include-linux-syscallsh.patch
+make-srcu_readers_active-static.patch
+kernel-notifierc-should-include-linux-rebooth.patch
+proper-prototype-for-get_filesystem_list.patch
+fs-utimesc-should-include-linux-syscallsh.patch
+fs-signalfdc-should-include-linux-syscallsh.patch
+fs-eventfdc-should-include-linux-syscallsh.patch
+proper-prototype-for-vty_init.patch
+drivers-misc-lkdtmc-cleanups.patch
+power_supply_ledssysfsc-should-include-power_supplyh.patch
+rd-use-is_power_of_2-in-drivers-block-rdc.patch
+sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set.patch
+printk-trivial-optimizations.patch
+time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
+cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
+log2h-define-order_base_2-macro-for-convenience.patch

 misc.

+spi-at25-driver-is-for-eeprom-not-flash.patch
+spi-use-mutex-not-semaphore.patch
+spi-simplify-spi_sync-calling-convention.patch
+spi-use-simplified-spi_sync-calling-convention.patch
+spi-initial-bf54x-spi-support.patch
+spi-bfin-spi-uses-portmux-calls.patch
+spi-spi_bfin-cleanups-error-handling.patch
+spi-spi_bfin-handles-spi_transfercs_change.patch
+spi-spi_bfin-dont-bypass-spi-framework.patch
+spi-spi_bfin-uses-platform-device-resources.patch
+spi-spi_bfin-uses-portmux-for-additional-busses.patch
+spi-spi_bfin-rearrange-portmux-calls.patch
+spi-spi_bfin-change-handling-of-communication-parameters.patch
+spi-spi_bfin-relocate-spin-waits.patch
+spi-spi_bfin-handle-multiple-spi_masters.patch
+spi-spi_bfin-bugfix-for-816-bit-word-sizes.patch
+spi-spi_bfin-update-handling-of-delay-after-deselect.patch
+spi-spi_bfin-resequence-dma-start-stop.patch
+blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch
+blackfin-spi-driver-use-void-__iomem-for-regs_base.patch
+blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch
+blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch

 SPI updates

+move-kprobes-examples-to-samples-resend.patch
+move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch

 kprobes things

+fs-ecryptfs-possible-cleanups.patch
+ecryptfs-track-header-bytes-rather-than-extents.patch
+ecryptfs-set-inode-key-only-once-per-crypto-operation.patch

 ecryptfs updates

+fuse-fix-reading-past-eof.patch
+fuse-cleanup-add-fuse_get_attr_version.patch
+fuse-pass-open-flags-to-read-and-write.patch
+fuse-fix-fuse_file_ops-sending.patch

 FUSE updates

+cosmetic-fixes-to-rtc-subsystems-kconfig.patch
+rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
+rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
+rtc-cmos-exports-nvram-in-sysfs.patch

 RTC updates

+generic-gpio-gpio_chip-support.patch
+generic-gpio-gpio_chip-support-fix.patch
+avr32-uses-gpio_chip.patch
+mcp23s08-spi-gpio-expander.patch
+mcp23s08-spi-gpio-expander-checkpatch-fixes.patch

 GPIO updates (the first is controversial)

-unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
-unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling.patch
-unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch

 Folded into other patches

+make-video-geode-lxfb_corecgeode_modedb-static.patch
+sisusb-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch
+video-hpfbc-section-fix.patch

 fbdev updates

+coding-style-cleanups-for-drivers-md-mktablesc.patch

 RAID

+pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch
+pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch

 PNP updates

+ext4-mm-ext4_large_blocksize_support.patch
+ext4-mm-ext4_rec_len_overflow_with_64kblk_fix-v2.patch
+ext4-mm-large-file-blocktype.patch
+ext4-mm-ext4_grpnum_t.patch
+ext4-mm-ext4_grpnum_t_int_fix.patch
+ext4-mm-ext4-cleanup.patch
+ext4-mm-ext4-cleanup-2.patch
+ext4-mm-ext4-cleanup-3.patch
+ext4-mm-ext4-cleanup-4.patch
+ext4-mm-48-bit-i_blocks.patch
+ext4-mm-large-file.patch
+ext4-mm-ext2_fix_max_size.patch
+ext4-mm-ext3_fix_max_size.patch
+ext4-mm-ext4_sync_group_desciptor_with_e2fsprogs.patch
+ext4-mm-ext4-return-after-ext4_error-in-case-of-failures.patch
+ext4-mm-stable-boundary.patch
+ext4-mm-stable-boundary-undo.patch
+ext4-mm-jbd-stats-through-procfs.patch
+ext4-mm-ext4-journal_chksum-2620.patch
+ext4-mm-ext4-journal-chksum-review-fix.patch
+ext4-mm-64-bit-i_version.patch
+ext4-mm-i_version_hi.patch
+ext4-mm-ext4_i_version_hi_2.patch
+ext4-mm-i_version_update_ext4.patch
+ext4-mm-delalloc-vfs.patch
+ext4-mm-delalloc-ext4.patch
+ext4-mm-ext-truncate-mutex.patch
+ext4-mm-ext3-4-migrate.patch
+ext4-mm-generic-find-next-le-bit.patch
+ext4-mm-new-extent-function.patch
+ext4-mm-mballoc-core.patch
+ext4-mm-mballoc-bug-workaround.patch
+ext4-mm-ext4_grpnumt-mballoc-fix.patch
+ext4-mm-mballoc-compilebench-fix.patch
+ext4-mm-jbd-blocks-reservation-fix-for-large-blk.patch
+ext4-mm-jbd2-blocks-reservation-fix-for-large-blk.patch

 ext4 tree

+ext4-fix-mb_debug-format-warnings.patch
+ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines.patch
+ext4-fix-oops-with-jbd-stats-through-procfs-and-external.patch
+ext4-superc-fix-ifdefs.patch

 ext4 things

+make-jbd-journalc__journal_abort_hard-static.patch
+ext3-return-after-ext3_error-in-case-of-failures.patch
+ext3-change-the-default-behaviour-on-error.patch
+ridiculous-ext3-costs-was-re-page-fault-costs.patch

 ext3 things

+do-namei_flags-calculation-inside-open_namei.patch
+make-open_namei-return-a-filp.patch
+kill-do_filp_open.patch
+kill-filp_open.patch
+kill-filp_open-checkpatch-fixes.patch
+rename-open_namei-to-open_pathname.patch
+rename-open_namei-to-open_pathname-fix.patch
 r-o-bind-mounts-stub-functions.patch
-r-o-bind-mounts-elevate-write-count-opend-files.patch
-r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
-r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
-r-o-bind-mounts-make-access-use-mnt-check.patch
+r-o-bind-mounts-do_rmdir-elevate-write-count.patch
 r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
+r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
+r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
 r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
 r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
-r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
-r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
+r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
+r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
 r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
-r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
+r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
+r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
+r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
+r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
+r-o-bind-mounts-elevate-write-count-opened-files.patch
 r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
-r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
+nfsd-fix-wrong-mnt_writer-count-in-rename.patch
+r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
 r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
-r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
-r-o-bind-mounts-elevate-write-count-for-do_utimes-touch-command-causes-oops.patch
-r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
+r-o-bind-mounts-make-access-use-mnt-check.patch
+r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
+r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
 r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
-r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
-r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
-r-o-bind-mounts-do_rmdir-elevate-write-count.patch
 r-o-bind-mounts-track-number-of-mount-writers.patch
 r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
+r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
+r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
 r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
-ext2-reservations-fix-for-r-o-bind-mounts-take-writer-count-v2.patch
-make-reiserfs-stop-using-struct-file-for-internal.patch
+keep-track-of-mnt_writer-state-of-struct-file.patch
+create-file_drop_write_access-helper.patch
+fix-up-new-filp-allocators.patch

 Lots of churn in the read-only-bind-mounts patchset.

+doc-add-uio-document-to-docbook-compilation-target.patch
+add-missing-section-ids-to-genericirqtmpl.patch
+add-missing-section-ids-to-genericirqtmpl-updated.patch
+add-missing-section-id-to-lsmtmpl.patch
+add-section-ids-to-mtdnandtmpl.patch
+add-missing-ids-to-procfs-guidetmpl.patch
+add-section-ids-to-rapidiotmpl.patch
+add-table-ids-to-videobooktmpl.patch
+add-chapter-ids-to-z8530booktmpl.patch
+move-edactxt-two-levels-up.patch
+remove-documentation-smptxt.patch

 Documentation.

+kernel-cgroupc-remove-dead-code.patch
+cgroup-brace-coding-style-fix.patch
+cgroup-simplify-space-stripping.patch
+cgroup-simplify-space-stripping-fix.patch
+cgroups-move-cgroups-destroy-callbacks-to-cgroup_diput.patch
+kernel-cgroupc-make-2-functions-static.patch

 cgroups updates

 memory-controller-add-documentation.patch
+memcgroup-temporarily-revert-swapoff-mod.patch
 memory-controller-resource-counters-v7.patch
-memory-controller-resource-counters-v7-fix.patch
 memory-controller-containers-setup-v7.patch
 memory-controller-accounting-setup-v7.patch
 memory-controller-memory-accounting-v7.patch
-memory-controller-memory-accounting-v7-fix.patch
-memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch
 memory-controller-task-migration-v7.patch
 memory-controller-add-per-container-lru-and-reclaim-v7.patch
-memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
-memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch
-memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
+memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
 memory-controller-improve-user-interface.patch
 memory-controller-oom-handling-v7.patch
-memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
 memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
-memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
-memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
 memory-controller-make-page_referenced-container-aware-v7.patch
 memory-controller-make-charging-gfp-mask-aware.patch
 memory-controller-make-charging-gfp-mask-aware-fix.patch
+memcgroup-reinstate-swapoff-mod.patch
 memory-controller-bug_on.patch
 mem-controller-gfp-mask-fix.patch
 memcontrol-move-mm_cgroup-to-header-file.patch
 memcontrol-move-oom-task-exclusion-to-tasklist.patch
-memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
 oom-add-sysctl-to-enable-task-memory-dump.patch
 kswapd-should-only-wait-on-io-if-there-is-io.patch
+bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
+bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
+bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
+bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
+bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
+memcgroup-fix-zone-isolation-oom.patch
+memcgroup-revert-swap_state-mods.patch
+bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
+memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
+memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
+memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
+memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
+memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
+memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
+memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
+memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
+memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
+memory-cgroup-enhancements-add-memorystat-file.patch
+memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
+memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
+memory-cgroup-enhancements-add-pre_destroy-handler.patch
+memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch

 Lots of updates to the cgroup memeory controller

+tty-kill-tty_flipbuf_size.patch

 tty cleanup

+asic3-driver.patch
+asic3-driver-update.patch
+asic3-driver-update-2.patch

 Driver for the Compaq ASIC3 multi function chip.

+drivers-edac-turnon-edac-device-error-logging.patch
+drivers-edac-use-round_jiffies_relative.patch
+drivers-edac-add-cell-xdr-memory-types.patch
+drivers-edac-add-cell-mc-driver.patch
+drivers-edac-i3000-code-tidying.patch
+drivers-edac-i3000-replace-macros-with-functions.patch
+drivers-edac-add-freescale-mpc85xx-driver.patch
+drivers-edac-add-marvell-mv64x60-driver.patch
+drivers-edac-add-marvell-mv64x60-driver-fix.patch

 edac updates

+dzh-remove-useless-unused-module-junk.patch
+dz-always-check-if-it-is-safe-to-console_putchar.patch
+dz-dont-panic-when-request_irq-fails.patch
+dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
+dz-update-kconfig-description.patch
+dz-rename-the-serial-console-structure.patch
+dz-fix-locking-issues.patch
+dz-handle-special-conditions-on-reception-correctly.patch
+maintainers-add-self-for-the-dz-serial-driver.patch
+dz-clean-up-and-improve-the-setup-of-termios-settings.patch
+dzc-use-a-helper-to-cast-from-struct-uart_port.patch
+dzc-resource-management.patch

 serial driver updates

+fs-menu-small-reorg.patch

 fiddle with kconfig

+introduce-flags-for-reserve_bootmem.patch
+introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
+use-bootmem_exclusive-for-kdump.patch

 kdump things

+mbcs-convert-algolock-to-mutex.patch
+mbcs-convert-dmawritelock-to-mutex.patch
+mbcs-convert-dmareadlock-to-mutex.patch

 clean up this char driver

+add-an-err_cast-function-to-complement-err_ptr-and-co.patch
+convert-err_ptrptr_errp-instances-to-err_castp.patch
+iget-introduce-a-function-to-register-iget-failure.patch
+iget-use-iget_failed-in-afs.patch
+iget-use-iget_failed-in-gfs2.patch
+iget-stop-affs-from-using-iget-and-read_inode-try.patch
+iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
+iget-stop-autofs-from-using-iget-and-read_inode.patch
+iget-stop-befs-from-using-iget-and-read_inode-try.patch
+iget-stop-bfs-from-using-iget-and-read_inode-try.patch
+iget-stop-cifs-from-using-iget-and-read_inode-try.patch
+iget-stop-efs-from-using-iget-and-read_inode-try.patch
+iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
+iget-stop-ext2-from-using-iget-and-read_inode-try.patch
+iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
+iget-stop-ext3-from-using-iget-and-read_inode-try.patch
+iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
+iget-stop-ext4-from-using-iget-and-read_inode-try.patch
+iget-stop-fat-from-using-iget-and-read_inode-try.patch
+iget-stop-freevxfs-from-using-iget-and-read_inode.patch
+iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
+iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
+iget-stop-fuse-from-using-iget-and-read_inode-try.patch
+iget-stop-hfsplus-from-using-iget-and-read_inode.patch
+iget-stop-isofs-from-using-read_inode.patch
+iget-stop-jffs2-from-using-iget-and-read_inode.patch
+iget-stop-jfs-from-using-iget-and-read_inode-try.patch
+iget-stop-the-minix-filesystem-from-using-iget-and.patch
+iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
+iget-stop-procfs-from-using-iget-and-read_inode.patch
+iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
+iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
+iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
+iget-stop-romfs-from-using-iget-and-read_inode.patch
+iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
+iget-stop-the-sysv-filesystem-from-using-iget-and.patch
+iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
+iget-stop-ufs-from-using-iget-and-read_inode-try.patch
+iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
+iget-stop-openpromfs-from-using-iget-and.patch
+iget-stop-hostfs-from-using-iget-and-read_inode.patch
+iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
+iget-stop-hppfs-from-using-iget-and-read_inode.patch
+iget-remove-iget-and-the-read_inode-super-op-as.patch
+iget-stop-unionfs-from-using-iget-and-read_inode.patch
+iget-stop-unionfs-from-using-iget-and-read_inode-fix.patch

 Change iget.

+dca-convert-struct-class_device-to-struct-device.patch
+add-dma-engine-driver-for-freescale-mpc85xx-processors.patch
+add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch

 DMA driver updates

+unexport-asm-userh-and-linux-userh.patch
+cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed.patch
+cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed-fix.patch
+unexport-asm-elfh.patch
+unexport-asm-pageh.patch
+sanitize-the-type-of-struct-useru_ar0.patch

 cleanups

+add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
+fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486.patch
+add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
+add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
+add-cmpxchg64-and-cmpxchg64_local-to-powerpc.patch
+add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
+add-cmpxchg_local-to-arm.patch
+add-cmpxchg_local-to-avr32.patch
+add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
+add-cmpxchg_local-to-cris.patch
+add-cmpxchg_local-to-frv.patch
+add-cmpxchg_local-to-h8300.patch
+add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
+new-cmpxchg_local-optimized-for-up-case-for-m32r.patch
+fix-m32r-__xchg.patch
+m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch
+local_t-m32r-use-architecture-specific-cmpxchg_local.patch
+add-cmpxchg_local-to-m86k.patch
+add-cmpxchg_local-to-m68knommu.patch
+add-cmpxchg_local-to-parisc.patch
+add-cmpxchg_local-to-ppc.patch
+add-cmpxchg_local-to-s390.patch
+add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
+add-cmpxchg_local-to-sh64.patch
+add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
+add-cmpxchg_local-to-sparc64.patch
+add-cmpxchg_local-to-v850.patch
+add-cmpxchg_local-to-xtensa.patch

 atomic op infrastructure addition

+i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
+i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
+i8k-inspiron-e1705-fix.patch

 Update the i8k driver

+dont-touch-fs_struct-in-drivers.patch
+dont-touch-fs_struct-in-usermodehelper.patch
+remove-path_release_on_umount.patch
+move-struct-path-into-its-own-header.patch
+embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
+embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
+introduce-path_put.patch
+use-path_put-in-a-few-places-instead-of-mntdput.patch
+introduce-path_get.patch
+use-struct-path-in-fs_struct.patch
+make-set_fs_rootpwd-take-a-struct-path.patch
+introduce-path_get-unionfs.patch
+embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
+introduce-path_put-unionfs.patch

 VFS work.

+one-less-parameter-to-__d_path.patch
+one-less-parameter-to-__d_path-checkpatch-fixes.patch
+d_path-kerneldoc-cleanup.patch
+d_path-use-struct-path-in-struct-avc_audit_data.patch
+d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
+d_path-make-proc_get_link-use-a-struct-path-argument.patch
+d_path-make-get_dcookie-use-a-struct-path-argument.patch
+d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
+use-struct-path-in-struct-svc_export.patch
+use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
+use-struct-path-in-struct-svc_expkey.patch
+d_path-make-seq_path-use-a-struct-path-argument.patch
+d_path-make-d_path-use-a-struct-path.patch
+# dentries-extract-common-code-to-remove-dentry-from-lru.patch: list_del_init()!
+dentries-extract-common-code-to-remove-dentry-from-lru.patch
+dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch

 More vfs work

+suppress-aout-library-support-if-config_binfmt_aout.patch
+suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes.patch
+usb-net2280-cant-have-a-function-called.patch
+usb-net2280-cant-have-a-function-called-checkpatch-fixes.patch
+mn10300-allocate-serial-port-uart-ids-for-on-chip-serial.patch
+mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
+mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
+mn10300-add-the-mn10300-am33-architecture-to-the-kernel-ia64-fix.patch

 New architecture (won't compile - I broek it to save ia64)

+char-rocket-switch-long-delay-to-sleep.patch
+char-rocket-printk-cleanup.patch
+char-rocket-remove-useless-macros.patch
+char-char-serial-remove-serial_type_normal-redefines.patch
+char-mxser_new-ioaddresses-are-ulong.patch
+char-stallion-fix-compiler-warnings.patch
+char-riscom8-change-rc_init_drivers-prototype.patch
+char-esp-remove-hangup-and-wakeup-bottomhalves.patch
+char-istallion-remove-hangup-bottomhalf.patch
+char-specialix-remove-bottomhalves.patch
+char-stallion-remove-bottomhalf.patch
+char-serial167-remove-bottomhalf.patch
+char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch

 Serial driver cleanups

-mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
-reiser4-fix-null-dereference-in-__mnt_is_readonly-in-ftruncate.patch
-reiser4-fix-extent2tail.patch
-reiser4-fix-read_tail.patch
-reiser4-fix-unix-file-readpages-filler.patch
-reiser4-fix-readpage_unix_file.patch
-reiser4-fix-for-new-aops-patches.patch
-reiser4-do-not-allocate-struct-file-on-stack.patch
-git-block-vs-reiser4.patch
-reiser4-cryptcompress-misc-fixups.patch
-reiser4-cryptcompress-misc-fixups-2.patch
-reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
-reiser4-change-error-code-base.patch
-reiser4-use-lzo-library-functions.patch
-fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
-reiser4-kmalloc-memset-conversion-to-kzalloc.patch
-fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
-fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
-fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
-reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
-remove-asm-bitopsh-includes-reiser4.patch
-git-nfsd-broke-reiser4.patch
-slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch

 Folded into reiser4.patch

+reiser4-portion-of-zero_user-cleanup-patch.patch
+jens-broke-reiser4patch-added-to-mm-tree.patch

 reiser4 maintenance

-device-suspend-debug.patch

 Dropped, I think.

+getblk-handle-2tb-devices.patch
+getblk-handle-2tb-devices-fix.patch

 fix getblk.  I forget why I wrote this.


2794 commits in 1229 patch files

All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/patch-list



