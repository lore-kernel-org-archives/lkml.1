Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYDBEcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYDBEcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 00:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbYDBEcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 00:32:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbYDBEcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 00:32:18 -0400
Date: Tue, 1 Apr 2008 21:32:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc8-mm1
Message-Id: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/

- Added the wm97xx touchscreen driver tree, as git-wm97xx.patch (Mark Brown
  <broonie@opensource.wolfsonmicro.com>)

- git-alsa.patch has been replaced by git-alsa-tiwai.patch

- git-drm.patch is dropped due to build errors

- git-md-accel.patch has been replaced with git-async_tx.patch

- git-xfs.patch is dropped due to extensive git rejects.

- Added the VFS git tree, as git-vfs.patch (Al Viro <viro@zeniv.linux.org.uk>)



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





Changes since 2.6.25-rc5-mm1:


 git-x86.patch
 git-kgdb-light.patch
 git-acpi.patch
 git-alsa-tiwai.patch
 git-agpgart.patch
 git-arm.patch
 git-avr32.patch
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
 git-wm97xx.patch
 git-jfs.patch
 git-kvm.patch
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
 git-slub.patch
 git-semaphore.patch

 git trees

-smackfs-do-not-trust-count-in-inodes-writes.patch
-pagemap-proper-read-error-handling.patch
-h8300-fix-recent-uaccess-breakage.patch
-ntfs-fix-nommu-build.patch
-poweroff-workaround.patch
-arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
-documentation-i386-io-apictxt-fix-description.patch
-add-the-dff-desktop-form-factor-dell-optiplex-745-to-the-reboot-errata-list.patch
-acpi-add-acpi-aliases-to-toshiba_acpi-module.patch
-acpi-make-real-parent-for-acpi-button-input-devices.patch
-acpi-use-acpi_debug_print-instead-of-printk.patch
-acpi-replace-remaining-__function__-occurrences.patch
-sound-use-bug_on.patch
-at73c213-remove-redundant-private_free-routine.patch
-sound-replace-remaining-__function__-occurences.patch
-atmel_serial-avoid-stopping-pdc-during-transmission.patch
-atmel_serial-avoid-stopping-pdc-during-transmission-update.patch
-cifs-hack-around-biuld-error.patch
-agk-dm-dm-crypt-add-cond_resched.patch
-agk-dm-dm-io-write-error-bits-form-long-not-int.patch
-powerpc-replace-remaining-__function__-occurences.patch
-ppc-replace-remaining-__function__-occurences.patch
-drivers-block-viodasdc-use-field_sizeof.patch
-powerpc-8xx-fix-swap.patch
-powerpc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
-ppc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
-gregkh-driver-driver-core-convert-debug-functions-declared-inline-__attribute__-to-statement-expression-macros.patch
-gregkh-driver-memstick-convert-struct-class_device-to-struct-device.patch
-gregkh-driver-video-add-the-go7007-driver.patch
-revert-gregkh-driver-video-add-the-go7007-driver.patch
-kobjects-mark-cleaned-up-kobjects-as-unitialized-2.patch
-fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch
-drivers-base-cpu-fix-section-mismatch-in-cpucstore_online.patch
-sysdev-detect-multiple-driver-registrations.patch
-driver-core-debug-for-bad-dev_attr_show-return-value.patch
-radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
-drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
-drivers-media-video-tvp5150c-logical-bitwise-and-confusion.patch
-jdelvare-i2c-i2c-amd756-fix-off-by-one.patch
-jdelvare-i2c-i2c-fix-i2c_device_probe.patch
-infiniband-replace-remaining-__function__-occurrences.patch
-drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
-input-i8042-fix-warning-on-non-x86-builds.patch
-keyboard-notifier-documentation.patch
-input-core-driver-for-wm97xx-touchscreens.patch
-input-add-chip-driver-for-wm9705-touchscreen.patch
-input-add-chip-driver-for-wm9712-touchscreen.patch
-input-add-chip-driver-for-wm9713-touchscreen.patch
-input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone.patch
-input-build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers.patch
-input-add-lenovo-3000-n100-to-nomux-blacklist.patch
-ide-mm-ide-add-warm-plug-support-for-ide-devices.patch
-ide-mm-ide-remove-config_blk_dev_hd_ide-config-option.patch
-ide-mm-ide-remove-obsoleted-idex-base_-ctl_-irq_-kernel-parameters.patch
-ide-mm-ide-remove-obsoleted-idex-noprobe-kernel-parameter.patch
-ide-mm-ide-do-complete-dma-setup-in-init_dma-method.patch
-ide-mm-ide-add-struct-ide_dma_ops.patch
-drivers-ide-idec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-mips-remove-redundant-display-of-free-swap-space-in-show_mem.patch
-mips-replace-remaining-__function__-occurences.patch
-git-net-fix-build-with-config_net=n.patch
-cosa-srp-convert-channel_datarsem-to-mutex.patch
-drivers-net-mv643xx_ethc-use-field_sizeof.patch
-qla3xxx-convert-byte-order-of-constant-instead-of-variable.patch
-smc91x-pass-along-private-data-v2.patch
-smc91x-introduce-platform-data-flags-v2.patch
-smc91x-add-insw-outsw-to-default-config-v2.patch
-smc91x-make-superh-use-default-config-v2.patch
-3c509-convert-to-isa_driver-and-pnp_driver-v6.patch
-tulip-de_stop_rxtx-polling-wrong.patch
-3c501-further-coding-style-fixes.patch
-nfs-replace-remaining-__function__-occurrences.patch
-gregkh-pci-ide-remove-ide-reverse-ide-core.patch
-pci-iova-rb-tree-setup-tweak.patch
-pci-simplify-quirk-debug-output.patch
-pci-iommu-iotlb-flushing.patch
-s390-remove-redundant-display-of-free-swap-space-in-show_mem.patch
-drivers-s390-replace-remaining-__function__-occurrences.patch
-mptbase-reset-ioc-initiator-during-pci-resume.patch
-3w-raid-drivers-memset-not-needed-in-probe.patch
-scsi-le_add_cpu-conversion.patch
-arcmsr-modify-the-type-of-element-of-messageunit_b.patch
-fusion-mpt-convert-inactive_list_mutex-in-a-mutex.patch
-scsi-stc-make-class-attributes-static.patch
-scsi-osstc-make-class-attributes-static.patch
-scsi-chc-fix-shadowed-variable-warnings.patch
-scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
-remove-ps2esdi.patch
-gregkh-usb-usb-add-sensoray-2255-v4l-driver.patch
-gregkh-usb-usb-s2255drv-fix-memset.patch
-usb-add-support-for-motorola-rokr-z6-cellphone-in-mass-storage-mode.patch
-make-b43_mac_enablesuspend-static.patch
-wireless-rt2x00-fix-driver-menu-indenting.patch
-ipw2200-le_add_cpu-conversion.patch
-convert-acl-sem-in-a-mutex.patch
-convert-stats_sem-in-a-mutex.patch
-convert-wpa_sem-in-a-mutex.patch
-the-scheduled-bcm43xx-removal.patch
-the-scheduled-ieee80211-softmac-removal.patch
-the-scheduled-rc80211-simplec-removal.patch
-wdev-ath5k-typecheck-on-nondebug.patch
-prism54-support-for-124a4025-another-version-of-iogear-gwu513-80211g.patch
-xtensa-remove-redundant-display-of-free-swap-space-in-show_mem.patch
-char-riscom-fix-rc_board-indexing.patch
-alpha-use-iommu_is_span_boundary-helper-function.patch
-kernel-doc-set-verbose-mode-via-environment.patch
-block-floppy-fix-rmmod-lockup.patch
-kthread-call-wake_up_process-without-the-lock-being-held.patch
-romfs-prevent-romfs_lookup-from-always-failing.patch
-x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
-x86-fix-clearcopy_user_page-declarations-in-pageh.patch
-x86-visws-fix-printk-format-warnings.patch
-gdth-allocate-sense_buffer-to-prevent-null-pointer-dereference.patch
-at73c213-fix-error-checking-for-clk-api.patch
-at73c213-monaural-support.patch
-at73c213-fix-dma-size-at-the-end-of-dma-buffer.patch
-smc91x-fix-build-breakage-from-the-smc_get_mac_addr-api-upgrade.patch
-ioc3-fix-section-missmatch.patch
-forcedeth-limit-tx-to-16.patch
-drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
-iova-lockdep-false-alarm-fix.patch
-fix-typo-in-tick-broadcastc.patch
-acpi-ec-revert-208c70a45624400fafd7511b96bc426bf01f8f5e.patch
-drivers-acpi-asus_acpic-correct-use-of-and.patch
-acpi-fix-overflow.patch
-drm-fix-for-non-coherent-dma-powerpc.patch
-input-fix-cobalt_btns-loadable-keymap-support.patch
-keep-rd-online-and-cpu_online_map-in-sync.patch
-power-replace-remaining-__function__-occurrences.patch
-block-genhdc-check-class_register-return-value.patch
-tpm-fix-section-mismatch-warning.patch
-kernel-add-clamp-and-clamp_t-macros.patch
-kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
-kernel-add-clamp-and-clamp_t-macros-fix.patch
-ioc3c-replace-remaining-__function__-occurrences.patch
-connector-convert-to-single-threaded-workqueue.patch
-reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
-hppfs-pass-vfsmount-to-dentry_open.patch
-check-for-null-vfsmount-in-dentry_open.patch
-fix-up-new-filp-allocators.patch
-do-namei_flags-calculation-inside-open_namei.patch
-merge-open_namei-and-do_filp_open.patch
-r-o-bind-mounts-stub-functions.patch
-r-o-bind-mounts-create-helper-to-drop-file-write-access.patch
-r-o-bind-mounts-drop-write-during-emergency-remount.patch
-r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch
-r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch
-r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
-r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers.patch
-r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers.patch
-r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
-r-o-bind-mounts-elevate-write-count-for-ncp_ioctl.patch
-r-o-bind-mounts-write-counts-for-time-functions.patch
-r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
-r-o-bind-mounts-write-count-for-file_update_time.patch
-r-o-bind-mounts-write-counts-for-link-symlink.patch
-r-o-bind-mounts-elevate-write-count-for-ioctls.patch
-r-o-bind-mounts-elevate-write-count-for-opens.patch
-r-o-bind-mounts-get-write-access-for-vfs_rename-callers.patch
-r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
-r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch
-r-o-bind-mounts-write-counts-for-truncate.patch
-r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates.patch
-r-o-bind-mounts-make-access-use-new-r-o-helper.patch
-r-o-bind-mounts-check-mnt-instead-of-superblock-directly.patch
-r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
-r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
-r-o-bind-mounts-get-callers-of-vfs_mknod-create.patch
-r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
-r-o-bind-mounts-track-numbers-of-writers-to-mounts.patch
-r-o-bind-mounts-honor-mount-writer-counts-at-remount.patch
-r-o-bind-mounts-debugging-for-missed-calls.patch
-serial-remove-double-initializer.patch
-gxfb-replace-fbsize-config-option-with-a-kernel-argument.patch
-fbdev-defio-and-metronomefb-v4.patch
-jbd-sparse-warnings-in-revokec-journalc.patch
-reiserfs-fix-sparse-warnings-in-fix_nodec.patch
-reiserfs-fix-sparse-warnings-in-do_balanc.patch
-reiserfs-fix-sparse-warning-in-nameic.patch
-reiserfs-fix-sparse-warnings-in-lbalancec.patch
-ext4-mm-jbd2-sparse-warnings-in-revokec-journalc.patch
-vfs-create-proc-pid-mountinfo.patch

 Merged into mainline or a subsystem tree

+kvm-provide-kvmh-for-all-architecture-fixes-headers_install.patch
+atmel_serial-avoid-stopping-pdc-during-transmission.patch
+atmel_serial-fix-uart-console-concurrent-access.patch
+alpha-fix-alsa-dma-mmap-crash.patch
+fix-typos-in-documentation-unaligned-memory-accesstxt.patch
+doc-fix-typo-in-submittingpatches.patch
+nbd-prevent-sock_xmit-from-attempting-to-use-a-null-socket.patch
+char-ip2-fix-sparse-warnings.patch
+char-rio-fix-sparse-warnings.patch
+block-fix-the-setting-of-the-bounce-limit.patch
+efs-update-error-msg-to-not-refer-to-deleted-read_inode.patch
+vmcoreinfo-add-the-symbol-phys_base.patch
+markers-use-synchronize_sched.patch
+alpha-get_current-dont-add-zero-to-current_thread_info-task.patch

 2.6.25 queue

+hotplug-memory-remove-generic-__remove_pages-support.patch

 Not sure.

+revert-set-relay-file-can-not-be-read-by-pread2.patch

 Seems that we're happy to break existing userspace.

+lib-swiotlbc-avoid-endless-loops-fix.patch

 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> had issues with this?

+git-x86-fix-printk-warning.patch
+x86_64-do-not-reserve-ramdisk-two-times.patch
+x86-handle_vm86_trap-cleanup.patch
+i386-arch-x86-math-emu-fpu_entryc-warning-fix.patch
+x86_64-ia32-ptrace-vs-enosys.patch
+x86_64-ptrace-vs-enosys.patch
+x86_64-ia32-ptrace-vs-enosys-sysenter-syscall.patch
+x86_32-fix-visualws-and-voyager-kexec-build-failures.patch

 x86 stuff

+usb-audio-fix-another-dallas-quirk.patch
+usb-audio-make-quirk-handling-more-readable-and-fix-commented-out-code.patch

 alsa stuff

+git-agpgart-export-agp_generic_alloc_pages.patch
+git-agpgart-fix-type-confusion.patch
+git-agpgart-drivers-char-agp-i460-agpc-hacks.patch

 agp things

+cifs-suppress-warning.patch

 cifs fix

+cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism.patch
+cpufreq-document-the-currently-undocumented-parts-of-the-sysfs-interface.patch
+allow-use-of-the-powersave-governor-as-the-default-one.patch

 cpufreq things

+agk-dm-dm-raid1-use-list_split_init.patch
+agk-dm-dm-log-move-register-functions.patch
+agk-dm-dm-log-make-module-use-tracking-internal.patch
+agk-dm-dm-kcopyd-per-device.patch
+agk-dm-dm-kcopyd-private-mempool.patch
+agk-dm-dm-kcopyd-remove-redundant-client-counting.patch
+agk-dm-dm-expose-macros.patch
+agk-dm-dm-kcopyd-rename.patch
+agk-dm-dm-move-include-files.patch

 device mapper updates

+lmb-add-lmb_alloc_nid.patch
+rapidio-change-rio-function-mpc85xx_-to-fsl_.patch
+rapidio-add-rapidio-option-to-kernel-configuration.patch
+rapidio-move-include-asm-ppc-rioh-to-include-asm-powerpc-rioh.patch
+rapidio-add-rapidio-multi-mport-support.patch
+rapidio-add-of-tree-support-to-rapidio-controller-driver.patch
+rapidio-change-the-kernel-configurated-rapidio-system-size-to-auto-probing.patch
+rapidio-add-rapidio-node-into-mpc8641hpcn-dts-file.patch
+rapidio-add-rapidio-node-probing-into-mpc86xx_hpcn-board-id-table.patch
+rapidio-add-serial-rapidio-controller-support-which-includes-mpc8548-mpc8641.patch
+rapidio-add-rapidio-connection-info-print-out-and-re-training-for-break-connection.patch
+rapidio-add-memory-mapping-driver-to-rapidio.patch
+rapidio-add-rapidio-space-allocation-bitmap-arithmetic.patch
+rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
+rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch
+rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
+rapidio-change-rapidio-doorbell-source-and-target-id-field-to-16-bit.patch
+rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
+rapidio-fix-docbook-references.patch
+powerpc-hotplug-memory-notifications-for-ppc.patch
+powerpc-update-lmb-for-hotplug-memory-add-remove.patch
+powerpc-provide-walk_memory_resource-for-ppc.patch

 powerpc things

+gregkh-driver-uio-implement-a-uio-interface-for-the-smx-cryptengine.patch
+gregkh-driver-driver-core-convert-debug-functions-declared-inline-__attribute__-to-statement-expression-macros.patch
+gregkh-driver-driver-core-cpu-fix-section-mismatch-in-cpuc-store_online.patch
+gregkh-driver-sysdev-detect-multiple-driver-registrations.patch
+gregkh-driver-block-send-disk-change-event-for-rescan_partitions.patch
+gregkh-driver-pm-handle-device-registrations-during-suspend-resume.patch
+gregkh-driver-driver-core-call-device_pm_add-after-bus_add_device-in-device_add.patch
+gregkh-driver-pm-fix-misuse-of-wakeup-flag-accessors-in-serial-core.patch
+gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
+gregkh-driver-pm-convert-wakeup-flag-accessors-to-inline-functions.patch
+gregkh-driver-driver-core-make-device_is_registered-work-for-class-devices.patch
+gregkh-driver-sysfs-explicitly-include-required-header-file-slabh.patch
+gregkh-driver-memstick-convert-struct-class_device-to-struct-device.patch
+gregkh-driver-drm-remove-unused-dev_class.patch
+gregkh-driver-scsi-convert-struct-class_device-to-struct-device.patch
+gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch

 driver tree updates
 
+pm-remove-legacy-pm-fix.patch
+power-replace-remaining-__function__-occurrences.patch
+pm-remove-destroy_suspended_device.patch
+scsi-add-iscsi-ibft-support.patch

 driver tree things

+dvb-usb-leadtek-winfast-usb-dtv-dongle-support.patch
+radio-cadet-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
+video-test-cmd-not-definition-in-decoder_command-drivers-media-video-zoran_devicec.patch
+bttv-bt832-fix-possible-null-pointer-deref.patch
+bttv-fix-missed-index-check.patch

 DVB things

+jdelvare-i2c-i2c-new-co-maintainer.patch
+jdelvare-i2c-i2c-ibm_iic-fast-mode-parm-desc-fixup.patch
+jdelvare-i2c-i2c-davinci-01-fix-lost-interrupt.patch
+jdelvare-i2c-i2c-tiny-usb-new-vid-pid-pair.patch
+jdelvare-i2c-i2c-pca-03-platform-driver.patch
+jdelvare-i2c-i2c-remove-whitespaces-in-busses-kconfig.patch
+jdelvare-i2c-i2c-bfin-twi-01-add-repeated-start.patch
+jdelvare-i2c-i2c-bfin-twi-02-support-multiport-controllers.patch
+jdelvare-i2c-i2c-bfin-twi-03-add-pin-mux-operation.patch
+jdelvare-i2c-i2c-bfin-twi-04-driver-description.patch
+jdelvare-i2c-i2c-bfin-twi-05-use-simpler-comment-headers.patch
+jdelvare-i2c-i2c-bfin-twi-06-add-adsp-bf52x-support.patch
+jdelvare-i2c-i2c-bfin-twi-07-fix-mismatch-in-add-timer-and-delete-timer.patch
+jdelvare-i2c-i2c-scx200_acb-dont-use-0-as-null-pointer.patch

 I2C tree updates

+i2c-renesas-highlander-fpga-smbus-support.patch

 i2c driver

+adt7473-minor-documentation-update.patch

 hwmon update

+fix-typo-in-tick-broadcastc.patch

 fxi tpyo

-kprobes-kprobe-booster-for-ia64-fix.patch

 Folded into kprobes-kprobe-booster-for-ia64.patch

+arch-ia64-kernel-use-time_-macros.patch

 ia64 cleanup

+git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch

 Fix greg-vs-roland bunfight

+touch-screen-driver-for-the-superh-migor-board.patch
+touch-screen-driver-for-the-superh-migor-board-checkpatch-fixes.patch

 New touchscreen driver

+kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch

 kbuild fixlet

+git-kvm-fixup.patch
+git-kvm-vs-git-s390.patch

 Mend kvm

+git-libata-fix-config_pci=n-build.patch

 ata build fix

+pata_atiixp-simplex-clear.patch

 pata update

+ide-mm-ide-remove-ide-reverse-ide-core.patch
+ide-mm-ide-remove-ide-devices-from-proc-ide-before-unregistering-them.patch
+ide-mm-ide-add-warm-plug-support-for-ide-devices-take-2.patch
+ide-mm-ide-remove-config_blk_dev_hd_ide-config-option-take-2.patch
+ide-mm-ide-remove-obsoleted-idex-base_-ctl_-irq_-kernel-parameters-take-2.patch
+ide-mm-ide-remove-obsoleted-idex-noprobe-kernel-parameter-take-2.patch
+ide-mm-ide-do-complete-dma-setup-in-init_dma-method-take-2.patch
+ide-mm-ide-add-struct-ide_dma_ops-take-2.patch
+ide-mm-ide-add-ignore_cable-kernel-parameter-take-2.patch
+ide-mm-ide-remove-obsoleted-idex-serialize-kernel-parameter.patch
+ide-mm-ide-remove-obsoleted-idex-reset-kernel-parameter.patch
+ide-mm-ide-remove-obsoleted-idex-kernel-parameters.patch
+ide-mm-ide-remove-obsoleted-hdx-noautotune-kernel-parameter.patch
+ide-mm-ide-tape-remove-unused-parameter-from-idetape_copy_stage_to_user.patch
+ide-mm-ide-tape-remove-unused-parameter-from-idetape_copy_stage_from_user.patch
+ide-mm-ide-tape-remove-pipeline-specific-code-in-idetape_space_over_filemarks.patch
+ide-mm-ide-tape-remove-idetape_pipeline_size.patch
+ide-mm-ide-tape-remove-idetape_remove_stage_head.patch
+ide-mm-ide-tape-remove-pipeline-specific-code-from-idetape_end_request.patch
+ide-mm-ide-tape-unwrap-idetape_queue_pc_tail.patch
+ide-mm-ide-tape-remove-remaining-pipeline-functionality.patch
+ide-mm-ide-tape-remove-pipelined-mode-tape-control-flags.patch
+ide-mm-ide-tape-remove-pipeline-specific-members-from-struct-ide_tape_obj.patch
+ide-mm-ide-tape-remove-pipelined-mode-parameters.patch
+ide-mm-ide-tape-remove-misc-references-to-pipelined-operation-in-the-comments.patch
+ide-mm-ide-tape-remove-pipelined-mode-description-from-documentation_ide_ide-tape-txt.patch
+ide-mm-ide-tape-remove-comments-markup-from-documentation_ide_ide-tape-txt.patch
+ide-mm-ide-add-vlb-pci_clock-parameter.patch
+ide-mm-ide-mark-idebus-kernel-parameter-as-obsoleted-take-2.patch
+ide-mm-ide-remove-obsoleted-idebus-kernel-parameter.patch
+ide-mm-ide-always-auto-tune-pio-in-legacy-vlb-host-drivers.patch
+ide-mm-cmd640-always-auto-tune-pio.patch
+ide-mm-ide-remove-ide_hflag_no_autotune-host-flag.patch
+ide-mm-ide-remove-obsoleted-hdx-autotune-kernel-parameter.patch
+ide-mm-ide-add-nodma-noflush-noprobe-nowerr-parameters.patch
+ide-mm-ide-add-cdrom-and-chs-parameters.patch
+ide-mm-ide-remove-obsoleted-hdx-kernel-parameters.patch
+ide-mm-ide-cleanup-init_ide_data.patch
+ide-mm-gayle-add-doubler-parameter.patch
+ide-mm-ide-add-noacpi-acpigtf-acpionboot-parameters.patch
+ide-mm-ide-remove-obsoleted-ide-parameters.patch
+ide-mm-mpc8xx-ide-use-ide_find_port.patch
+ide-mm-ide-sanitize-ide_unregister-usage.patch
+ide-mm-ide-make-ide_unregister-take-ide_hwif_t-as-an-argument.patch
+ide-mm-ide-fix-hwif-s-initialization.patch
+ide-mm-ide-make-ide_hwifs-static.patch

 IDE tre updates

+fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

 DMA driver update

+mmc-use-shorter-equivalent-set_current_state.patch

 mmc cleanup

+mtd-prevent-physmap-from-causing-request_module-runaway-loop-modprobe-net-pf-1.patch
+jffs2-check-if-partition-is-marked-ro-on-remount.patch
+jffs2-check-if-partition-is-marked-ro-on-mount.patch
+mtd-nand-fix-possible-ooops-in-rfc_from4.patch

 MTD updates

+net-mac80211-debugfs_netdevc-use-of-bool-triggers-a-gcc-bug.patch
+drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
+wan-new-ppp-code-for-generic-hdlc.patch
+drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
+lapb-use-the-shorter-list_head-form-for-brevity.patch

 net things

+bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch
+hci_usb-do-not-initialize-static-variables-to-0.patch
+hci_usb-remove-code-obfuscation.patch
+hci_usbh-fix-hard-to-trigger-race.patch

 bluetooth updates

+smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
+nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch

 irda updates

-drivers-net-appletalk-copsc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-drivers-net-arcnet-com20020c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-drivers-net-at1700c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-drivers-net-atarilancec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-drivers-net-3c501c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-drivers-net-3c505c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-drivers-net-3c507c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-drivers-net-3c515c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-drivers-net-3c523c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-drivers-net-3c527c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
-drivers-net-82596c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

 Dropped

+forcedeth-fix-locking-bug-with-netconsole.patch
+tulip-tulip_read_eeprom-fixes-for-bug-4420.patch

 netdev fixes

+8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch

 Attempt to repair
 8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch

+fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch

 nfs warning fix

+nfs-replace-remaining-__function__-occurrences.patch

 nfs cleanup

+arch-parisc-kernel-unalignedc-use-time_-macros.patch

 parisc cleanup

+gregkh-pci-pci-doc-pci-create-documentation-pci-and-move-files-into-it.patch
+gregkh-pci-pci-iova-rb-tree-setup-tweak.patch
+gregkh-pci-pci-simplify-quirk-debug-output.patch
+gregkh-pci-pci-iommu-iotlb-flushing.patch
+gregkh-pci-pci-expose-pci-vpd-through-sysfs.patch

 PCI tree updates

+revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
+revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
+revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
+revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
+revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
+revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
+revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
+revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
+revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
+revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
+revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch

 revert dodgy stuff from the PCI tree

+pci-hotplug-fix-leaks-in-ibm-hot-plug-controller-driver-ibmphp_init_devno.patch
+pci-hotplug-construct-one-fakephp-slot-per-pci-slot.patch
+pci-hotplug-export-kobject_rename-for-pci_hotplug_core.patch
+pci-hotplug-introduce-pci_slot.patch
+pci-hotplug-introduce-pci_slot-fix.patch
+pci-hotplug-introduce-pci_slot-fix-fix.patch
+pci-hotplug-introduce-pci_slot-fix-2.patch
+pci-hotplug-introduce-pci_slot-fix-99.patch
+pci-hotplug-introduce-pci_slot-fix-3.patch
+pci-hotplug-acpi-pci-slot-detection-driver.patch
+pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
+drivers-acpi-pci_slotc-fix-build-with-config_dmi=n.patch

 PCI hotplug work

+git-s390-git-rejects.patch

 git-s390 and git-kvm are bunfighting at present

+git-sched-schedc-needs-tickh.patch

 fix git-sched

+git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
+git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch

 greg and james are bunfighting too.

+drivers-scsi-hptiopc-fix-build-warning.patch
+drivers-scsi-mvsasc-fix-build-warnings.patch
+scsi-chc-fix-sparse-shadowed-variable-warnings.patch

 scsi things

+sparc32-delete-bogus-js-rtc-records.patch

 sparc32 fix

+gregkh-usb-usb-ehci-paranoia-reject-large-control-transfers.patch
+gregkh-usb-usb-cypress_m8-speed-handling.patch
+gregkh-usb-drivers-usb-core-devioc-suppress-warning-with-64k-page_size.patch
+gregkh-usb-usb-usbh-reduce-syslog-clutter.patch
+gregkh-usb-usb-standardize-inclusion-protection-and-add-where-missing.patch
+gregkh-usb-usb-mass-storage-emulation-of-sat-scsi_pass_thru-with-atacb.patch
+gregkh-usb-usb-remove-experimental-designation-from-usb-storage-kconfig-entries.patch
+gregkh-usb-usb-remove-experimental-tags-from-some-usb-gadget-kconfig-entries.patch
+gregkh-usb-usb-remove-experimental-designation-from-usb-misc-kconfig-entries.patch
+gregkh-usb-usb-remove-experimental-designation-from-usb-serial-kconfig-entries.patch
+gregkh-usb-usb-remove-experimental-designation-from-usb-mdc800-support.patch
+gregkh-usb-usb-remove-experimental-from-dynamic-usb-minor-allocation.patch
+gregkh-usb-usb-remove-experimental-designation-from-usb_ehci_root_hub_tt.patch
+gregkh-usb-usb-a-couple-corrections-and-clarifications-in-usb-doc.patch
+gregkh-usb-usb-fix-cut-and-paste-booboo-in-usbmon-makefile.patch
+gregkh-usb-ub-drop-bug-and-update-small-things.patch
+gregkh-usb-usbmon-restore-mmap.patch
+gregkh-usb-usb-cdc-acm-tell-tty-layer-not-to-split-things-up.patch
+gregkh-usb-usb-increase-cdc-acm-write-throughput.patch

 USB tree updates

+fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
+usb-gadget-dummy_hcdc-fix-nested-switch-statements.patch
+drivers-net-usb-pegasusc-remove-in_atomic-check.patch
+usb-mem-leak-fixes-for-amd-5536-udc-high-full-speed-usb-device-controller-driver.patch
+usb-u132-hcd-driver-style-clean-up.patch
+usb-u132-hcd-driver-semaphore-to-mutex.patch
+usb-ohci-fix-2-timers-to-fire-at-jiffies-1s.patch
+usb-serial-fix-regression-in-visor-palm-os-module-for-kernels-=-2624.patch

 usb things

+git-watchdog-git-rejects.patch

 FIx rejects in git-watchdog

+mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers.patch
+mac80211-tkipc-remove-opencoded-swab16-in-tkip_s.patch
+mac80211-tkipc-eliminate-the-hi16-lo16-functions.patch
+mac80211-tkipc-remove-mk16-hi8-lo8-helpers.patch
+mac80211-michaelc-replace-macro-with-function.patch
+mac80211-michaelc-use-unaligned-byteorder-helpers.patch
+mac80211-michaelc-fold-initial-xor-into-block-helper.patch

 wireless cleanups

+xfs-suppress-uninitialized-var-warnings.patch

 xfs warning fixes

+git-cryptodev-fixup.patch

 git-cryptodev.patch is bunfighting with git-s390 too.

+xtensa-use-newer-__spin_lock_unlocked-macro.patch

 xtensa celanup

+rusty-module-make_sect_attrs_private_to_kernel_c.patch
+rusty-module-reduce_image_and_resident_size.patch
+rusty-module-fix_verify_export_symbols.patch

 rustree updates

+git-slub-git-rejects.patch

 Fix git rejects in git-slub.patch

+mac80211-fix-deadlocks-in-debugfs_netdevc.patch
+forcedeth-mac-address-fix.patch
+r8169-fix-irqx-nobody-cared-for-shared-irq-with-intx.patch
+r8169-fix-irqx-nobody-cared-for-shared-irq-with-intx-checkpatch-fixes.patch
+smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch

 Things which we probably need in 2.6.25, but whihc go via subsystem
 maintainers

-dm-raid1-bitops-bug.patch

 Dropped, unneeded

+mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
+mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
+mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch

 Repair
 mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch

+mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify.patch

 Debloat mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch

+mempolicy-support-optional-mode-flags-fix.patch

 Fix mempolicy-support-optional-mode-flags.patch

+mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
+mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
+mm-make-mem_map-allocation-continuous.patch
+mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
+mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
+mm-allocate-section_map-for-sparse_init.patch
+mm-allocate-section_map-for-sparse_init-update.patch
+mm-allocate-section_map-for-sparse_init-update-fix.patch
+mm-offset-align-in-alloc_bootmem.patch
+mm-make-reserve_bootmem-can-crossed-the-nodes.patch
+mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
+dmapool-enable-debugging-for-config_slub_debug_on-too.patch
+mm-save-some-bytes-in-mm_struct-by-filling-holes-on-64bit.patch
+fix-indentation.patch
+mm-rotate_reclaimable_page-cleanup.patch
+mm-make-early_pfn_to_nid-a-c-function.patch
+vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
+vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
+vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix.patch
+vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
+vmallocinfo-add-caller-information.patch
+vmallocinfo-add-caller-information-checkpatch-fixes.patch
+sparsemem-vmemmap-does-not-need-section-bits.patch
+kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
+page_mapping-add-ifdef-around-reference-to-swapper_space.patch
+pageflags-use-an-enum-for-the-flags.patch
+pageflags-get-rid-of-flags_reserved.patch
+pageflags-introduce-macros-to-generate-page-flag-functions.patch
+pageflags-convert-to-the-use-of-new-macros.patch
+pageflags-use-proper-page-flag-functions-in-xen.patch
+pageflags-eliminate-pg_xxx-aliases.patch
+page-flags-handle-pg_uncached-like-all-other-flags.patch
+page-flags-add-pageflags_false-for-flags-that-are-always-false.patch
+mm-remove-unused-max_nodes_shift.patch
+smaps-account-swap-entries.patch
+smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
+mm-introduce-vm_mixedmap.patch
+mm-introduce-pte_special-pte-bit.patch
+mm-introduce-pte_special-pte-bit-fix.patch
+mm-add-vm_insert_mixed.patch
+return-pfn-from-direct_access-for-xip.patch
+xip-support-non-struct-page-backed-memory.patch
+s390-implement-pte-special-bit.patch
+s390-remove-struct-page-entries-for-dcss-memory-segments.patch
+vmcoreinfo-add-page-flags-values.patch
+hugetlb-vmstat-events-for-huge-page-allocations.patch
+hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch

 MM updates

+arch-alpha-kernel-trapsc-use-time_-macros.patch
+arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
+alpha-teach-the-compiler-that-bug-doesnt-return.patch

 alpha updates

+arch-um-os-linux-start_upc-various-improvements.patch
+arch-um-os-linux-mainc-fix-memory-leaks.patch
+arch-um-os-linux-mainc-fix-memory-leaks-checkpatch-fixes.patch

 UML fixlets

+codafs-fix-build-warning.patch
+lib-swiotlbc-cleanups.patch
+kthread-call-wake_up_process-without-the-lock-being-held.patch
+binfmt_miscc-avoid-potential-kernel-stack-overflow.patch
+kernel-explicitly-include-required-header-files-under-kernel.patch
+remove-superfluous-include-of-stringh-from-percpuh.patch
+fs-binfmt_aoutc-use-printk_ratelimit.patch
+kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
+kbuild-move-files-that-dont-check-__kernel__.patch
+lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
+lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
+drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
+scripts-lindent-support-gnu-indent-v2210.patch
+asm-generic-add-node_to_cpumask_ptr-macro.patch

 Misc

+vfs-fix-lock-inversion-in-drop_pagecache_sb.patch
+vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch
+vfs-remove-lives_below_in_same_fs.patch
+xattr-add-missing-consts-to-function-arguments.patch

 VFS things

+rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch

 RCU fix

+add-warn_on_secs-macro-simplification.patch
+add-warn_on_secs-macro-simplification-fix.patch
+add-warn_on_secs-macro-simplification-fix-fix.patch

 Fix add-warn_on_secs-macro.patch

+serial-add-vr41xx_siu_early_setup-for-serial-console.patch
+serial-add-vr41xx-siu-setup-for-serial-console.patch
+serial-8250-tighten-test-for-using-backup-timer.patch

 Serial updates

+drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch

 Fix acpi build when x86-configurable-dmi-scanning-code.patch is applied.

+atmel_spi-support-zero-length-transfer.patch

 SPI fix

+mfd-use-shorter-set_current_state.patch

 mfs cleanup

+listh-add-list_singleton.patch
+listh-add-list_singleton-fix.patch

 cleanups

+kprobes-add-unregister_kprobes-for-batch-registration.patch
+kprobes-add-unregister_kprobes-for-batch-registration-fix.patch
+kprobes-add-unregister_kretprobes-for-batch-registration.patch
+kprobes-add-unregister_jprobes-for-batch-registration.patch
+kprobes-update-document-about-batch-registration.patch

 kprobes updates

+quota-do-not-allow-setting-of-quota-limits-to-too-high-values.patch
+quota-remove-superfluous-dquot_off-in-fs-namespacec.patch
+quota-various-style-cleanups.patch
+quota-various-style-cleanups-checkpatch-fixes.patch
+quota-quota-core-changes-for-quotaon-on-remount.patch
+quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
+quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
+quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
+quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
+quota-quota-core-changes-for-quotaon-on-remount-quota-reiserfs-make-reiserfs-handle-quotaon-on-remount.patch
+quota-convert-stub-functions-from-macros-into-inlines.patch

 quota work

+isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
+hisax-depend-on-config_pnp-not-__isapnp__.patch

 ISDN things

+kerneldoc-for-linux-clkh-fix.patch

 Fix kerneldoc-for-linux-clkh.patch

+rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path.patch
+rtc-rtc-rs5c372-smbus-conversion-support.patch
+rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch

 RTC updates

+gpiolib-dynamic-gpio-number-allocation.patch
+gpiochip_reserve.patch
+gpiochip_reserve-fix.patch

 GPIO updates

+x86-geode-msr-cleanup.patch
+gxfb-replace-fbsize-config-option-with-a-module-parameter.patch
+gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
+gxfb-clean-up-register-definitions.patch
+gxfb-move-msr-bit-fields-into-gxfbh.patch
+gxfb-stop-sharing-code-with-gx1fb.patch
+gxfb-add-power-management-functionality.patch
+gxfb-add-power-management-functionality-fix.patch
+pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
+pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
+lxfb-create-gp-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
+lxfb-clean-up-register-definitions.patch
+lxfb-clean-up-final-bits-of-df_regs.patch
+lxfb-rearrange-rename-msr-bitfields.patch
+lxfb-add-power-management-functionality.patch
+lxfb-add-power-management-functionality-fix.patch
+lxfb-rename-kernel-arg-fbsize-to-vram.patch
+lxfb-disable-suspend-vt-switch-by-default.patch
+nv-drop-useless-module-ifdefs.patch
+nv-drop-useless-config_pci-checks.patch
+nv-fix-sparse-noise.patch
+fbdev-powerpc-driver-for-freescale-8610-and-5121-diu.patch
+powerpc-add-diu-platform-code-for-mpc8610hpcd.patch

 fbdev updates

+md-introduce-get_priority_stripe-to-improve-raid456-write-performance.patch
+md-raid5c-convert-simple_strtoul-to-strict_strtoul.patch

 MD updates

+pnp-use-dev_printk-for-quirk-messages-fix.patch

 Fix pnp-use-dev_printk-for-quirk-messages.patch

+ext3-fix-update-of-mtime-and-ctime-on-rename.patch

 ext3 fix

+fatfs-fix-build-warning-with-64k-page_size.patch

 fatfs update

+cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time-fix-boot-option-parsing.patch

 Fix cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch

+cgroups-add-the-trigger-callback-to-struct-cftype.patch
+cgroups-implement-device-whitelist-v6.patch
+cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
+cgroups-implement-device-whitelist-v6-cleanups.patch
+cgroups-implement-device-whitelist-doc.patch
+cgroups-implement-device-whitelist-v6-fix.patch

 cgroups updates

+memcgroup-add-the-max_usage-member-on-the-res_counter.patch
+add-a-document-describing-the-resource-counter-abstraction-v2.patch
+add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
+memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
+memcgroup-use-triggers-in-force_empty-and-max_usage-files.patch
+memcgroup-implement-failcounter-reset.patch
+memcgroup-implement-failcounter-reset-checkpatch-fixes.patch

 memory controller updates

-signals-send_signal-factor-out-signal_group_exit-checks.patch
-signals-fold-sig_ignored-into-prepare_signal.patch
-signals-document-cld_continued-notification-mechanics.patch
+signals-fold-sig_ignored-into-handle_stop_signal.patch
+signals-fold-sig_ignored-into-handle_stop_signal-comment.patch
+signals-document-cld_continued-notification-mechanics.patch
+signals-document-cld_continued-notification-mechanics-more.patch
+signals-send_signal-be-paranoid-about-signalfd_notify.patch
+signals-check_kill_permission-check-session-under-tasklist_lock.patch
+signals-check_kill_permission-remove-tasklist_lock.patch
+signals-fix-sbin-init-protection-from-unwanted-signals.patch
+signals-de_thread-simplify-the-child_reaper-switching.patch
+signals-allow-the-kernel-to-actually-kill-sbin-init.patch

 signal management updates

+ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch
+ptrace-allow-to-ptrace-sbin-init.patch

 ptrace updates

+jbd2-fix-kernel-doc-notation.patch
+ext4-fix-wrong-gfp-type-under-transaction.patch
+ext4-fix-update-of-mtime-and-ctime-on-rename.patch

 ext4 things

+dma-add-dma_map_attrs-interfaces.patch
+dma-document-dma_map_attrs-interfaces.patch
+dma-ia64-update-ia64-machvecs-swiotlbc.patch
+ib-expand-ib_umem_get-prototype.patch

 DMA API updates

+ipc-add-definitions-of-ushort_max-and-others.patch
+ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch

 IPC cleanups

+tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch

 tty update

+sxc-fix-printk-warnings-on-sparc32.patch

 fix warnings

+char-moxa-centralize-board-readiness-warning-fix.patch

 Fix char-moxa-centralize-board-readiness.patch

+char-rio-fix-cirrus-defines.patch

 char driver cleanup

+keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
+keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
+keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch
+keys-explicitly-include-required-slabh-header-file.patch
+keys-make-key_serial-a-function-if-config_keys=y.patch

 key management updates

+procfs-task-exe-symlink-fix-3.patch

 Fix procfs-task-exe-symlink-fix.patch some more

+procfs-mem-permission-cleanup.patch
+proc-simplify-locking-in-remove_proc_entry.patch
+proc-less-special-case-in-xlate-code.patch
+proc-drop-several-pde-valid-invalid-checks.patch
+proc-remove-proc_bus.patch
+proc-remove-proc_root_fs.patch
+proc-remove-proc_root_driver.patch
+proc-remove-proc_root-from-drivers.patch

 procfs updates

+pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
+pids-introduce-change_pid-helper.patch
+pids-sys_setpgid-use-change_pid-helper.patch
+pids-__set_special_pids-use-change_pid-helper.patch
+pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch.patch
+pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu.patch

 PID management updates

+nbd-add-partition-support.patch

 NBD feature work

+make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch

 hm, this seems to have got stranded.

+mm-bdi-add-separate-writeback-accounting-capability.patch
+mm-bdi-export-bdi_writeout_inc.patch
+mm-bdi-export-bdi_writeout_inc-fix.patch
+mm-add-nr_writeback_temp-counter.patch
+mm-document-missing-fields-for-proc-meminfo.patch
+fuse-support-writable-mmap.patch
+fuse-support-writable-mmap-fix.patch
+fuse-clean-up-setting-i_size-in-write.patch
+fuse-implement-perform_write.patch
+fuse-update-file-size-on-short-read.patch

 FUSE updates

+basic-braille-screen-reader-support-makefile-fix.patch

 Fix basic-braille-screen-reader-support.patch some more

+hfs-fix-warning-with-64k-page_size.patch
+hfsplus-fix-warning-with-64k-page_size.patch
+alloc_uid-cleanup.patch
+add-macros-similar-to-min-max-min_t-max_t.patch
+add-macros-similar-to-min-max-min_t-max_t-doc.patch
+ide-eliminate-fit-macro.patch
+ata-remove-fit-macro.patch
+b43-replace-limit_value-macro-with-clamp_val.patch
+b43legacy-replace-limit_value-macro-with-clamp_val.patch
+fuse-use-clamp-rather-than-nested-min-max.patch
+ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
+input-ff-memlessc-use-clamp_val-macro.patch
+dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
+introduce-explicit-signed-unsigned-64bit-divide.patch
+convert-a-few-do_div-user.patch
+rename-div64_64-to-div64_u64.patch
+rename-div64_64-to-div64_u64-mm.patch
+remove-div_long_long_rem.patch

 Various random fixes and cleanups

+ntp-cleanup-ntpc.patch
+ntp-ntp4-user-space-bits-update.patch
+ntp-increase-time_freq-resolution.patch
+ntp-increase-time_offset-resolution.patch
+ntp-support-for-tai.patch
+ntp-rename-tick_length_shift-to-ntp_scale_shift.patch
+ntp-remove-current_tick_length.patch
+ntp-handle-leap-second-via-timer.patch

 NTP updates

+clocksource-keep-track-of-original-clocksource-frequency.patch
+clocksource-introduce-clock_monotonic_raw.patch
+clocksource-introduce-clock_monotonic_raw-fix.patch
+clocksource-introduce-clock_monotonic_raw-fix-checkpatch-fixes.patch

 clocksource updates

+idr-create-idr_layer_cache-at-boot-time.patch
+idr-create-idr_layer_cache-at-boot-time-fix.patch
+idr-create-idr_layer_cache-at-boot-time-fix-fix.patch

 IDR updates

+edac-new-support-for-intel-3100-chipset.patch
+edac-add-e752x-parameter-for-sysbus_parity-selection.patch
+edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
+edac-use-the-shorter-list_head-for-brevity.patch

 EDAC updates

+introduce-a-generic-__fls-implementation.patch
+implement-__fls-on-all-64-bit-archs.patch
+use-__fls-for-fls64-on-64-bit-archs.patch

 cleanups

+linuxpps-core-support.patch
+pps-userland-header-file-for-pps-api.patch
+pps-documentation-programs-and-examples.patch
+pps-linuxpps-clients-support.patch
+pps-serial-clients-support.patch
+pps-example-program-to-enable-pps-support-on-serial-ports.patch
+pps-parallel-port-clients-support.patch

 "pulse per second" support.  Updates are expected.

+slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
+infrastructure-to-debug-dynamic-objects.patch
+debugobjects-add-documentation.patch
+debugobjects-add-timer-specific-object-debugging-code.patch
+add-hrtimer-specific-debugobjects-code.patch

 Thomas's debug-objects stuff

+afs-use-the-shorter-list_head-for-brevity.patch

 AFS update

+parport_pc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch

 parport update

+tpm-fix-section-mismatch-warning.patch
+tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp.patch

 tpm updates

+cpufreq-change-cpu-freq-arrays-to-per_cpu-variables.patch
+acpi-change-processors-from-array-to-per_cpu-variable.patch
+cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch
+net-remove-nr_cpus-arrays-in-net-core-devc-v2.patch

 per-cpu work

+remove-ifdef-__kernel__-checks-from-unexported-headers.patch

 cleanup

+reiser4-kgdb-fix.patch

 reiser4 fix

+i386-arch-x86-math-emu-reg_ld_strc-fix-warning.patch

 x86 warning fix (grubby, mm-only)

+likely_prof-changed-to-use-proc_create.patch
+likeliness-accounting-change-and-cleanup.patch
+proc-remove-proc_root-from-drivers-likelyprof.patch

 likeliness-profiling updates



5011 commits in 1542 patch files


All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/patch-list

