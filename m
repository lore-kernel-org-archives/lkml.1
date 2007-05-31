Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbXEaG6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbXEaG6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 02:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXEaG63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 02:58:29 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724AbXEaG61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 02:58:27 -0400
Date: Wed, 30 May 2007 23:58:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc3-mm1
Message-Id: <20070530235823.793f00d9.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc3/2.6.22-rc3-mm1/

- Merged the convert-cpusets-to-container-infrastructure patches.  These
  will probably be dropped and redone.



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



Changes since 2.6.22-rc2-mm1:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-drm.patch
 git-dvb.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ieee1394.patch
 git-input.patch
 git-kbuild.patch
 git-kvm.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-netdev-all.patch
 git-net.patch
 git-backlight.patch
 git-battery.patch
 git-ioat.patch
 git-ioat-vs-git-md-accel.patch
 git-nfs.patch
 git-nfs-server-cluster-locking-api.patch
 git-ocfs2.patch
 git-parisc.patch
 git-r8169.patch
 git-selinux.patch
 git-pciseg.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-scsi-rc-fixes.patch
 git-scsi-target.patch
 git-unionfs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-xtensa.patch
 git-gccbug.patch

 git trees

-powerpc-fix.patch
-freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
-freezer-fix-vfork-problem.patch
-freezer-take-kernel_execve-into-consideration.patch
-freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
-freezer-fix-pf_nofreeze-vs-freezeable-race.patch
-freezer-move-frozen_process-to-kernel-power-processc.patch
-ignore-bogus-acpi-info-for-offline-cpus.patch
-slub-debug-fix-object-size-calculation.patch
-fuse-fix-mknod-of-regular-file.patch
-mpc52xx_psc_spi-fix-it-for-config_ppc_merge.patch
-spi-doc-update-describe-clock-mode-bits.patch
-nohz-rate-limit-the-local-softirq-pending-warning-output.patch
-genhd-expose-an-to-user-space.patch
-genhd-send-async-notification-on-media-change.patch
-capabilityh-warning-fix.patch
-remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
-avr32-ratelimit-segfault-reporting-rate.patch
-cifs-oops-fix.patch
-powerpc-fix-kconfig-select-warning-with-ucc_fast.patch
-8xx-mpc885ads-pcmcia-support-fix.patch
-gregkh-driver-howto-removing-duplicated-entry.patch
-drm-spinlock-initializer-cleanup.patch
-cinergyt2-fix-file-release-handler.patch
-saa7111-fix-picture-settings-cache-bug.patch
-jdelvare-i2c-i2c-legacy-drivers-shouldnt-issue-uevents.patch
-jdelvare-i2c-i2c-usb-tiny-fix-name-length.patch
-jdelvare-i2c-i2c-s3c2410-fix-build-warning.patch
-jdelvare-hwmon-hwmon-ds1621-swapped-limits.patch
-jdelvare-hwmon-hwmon-coretemp-add-more-safety-checks.patch
-jdelvare-hwmon-hwmon-w83627hf-quiet-when-no-chip.patch
-dave-broke-gfs2-26-nmwgit.patch
-use-menuconfig-objects-ii-kvm-virt.patch
-libata-acpi-add-infrastructure-for-drivers-to-use.patch
-pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
-optional-led-trigger-for-libata.patch
-libata-add-support-for-ata_16-on-atapi.patch
-drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
-drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
-drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch
-cleanup-libata-hpa-support.patch
-cleanup-libata-hpa-support-fix.patch
-hpt3x2n-correct-revision-boundary.patch
-pata_sis-fix-and-clean-up-some-timing-setups.patch
-ide-aec62xx-kill-speedproc-method-wrapper.patch
-ide-warning-fixes.patch
-ide-add-seagate-stt20000a-to-dma-blacklist.patch
-git-md-accel-build-fix.patch
-sundance-change-phy-address-search-from-phy=1-to-phy=0.patch
-forcedeth-add-vitesse-phy.patch
-forcedeth-fix-power-management-support.patch
-forcedeth-fix-cpu-irq-mask.patch
-forcedeth-version-bump.patch
-use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
-use-menuconfig-objects-dccp.patch
-use-menuconfig-objects-ipvs.patch
-use-menuconfig-objects-sctp.patch
-use-menuconfig-objects-tipc.patch
-use-menuconfig-objects-arcnet.patch
-use-menuconfig-objects-toeknring.patch
-af_rxrpc-af_rxrpc-depends-on-ipv4.patch
-af_rxrpc-make-call-state-names-available-if-config_proc_fs=n.patch
-xfrm_algo-warning-fixes.patch
-round_up-macro-cleanup-in-drivers-parisc.patch
-pci-quirks-disable-msi-on-rs400-200-and-rs480.patch
-drivers-scsi-advansysc-cleanups.patch
-remove-unnecessary-check-in-drivers-scsi-sgc.patch
-drivers-scsi-ncr5380c-replacing-yield-with-a.patch
-scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
-fdomainc-get-rid-of-unused-stuff.patch
-scsi-fix-config_scsi_wait_scan=m.patch
-scsi-use-irq_handler_t-where-appropriate.patch
-drivers-scsi-ipsc-remove-kernel-24-code.patch
-drivers-scsi-nsp32c-remove-kernel-24-code.patch
-aic94xx-asd_clear_nexus-should-fail-if-the-cleared-task-does-not-complete.patch
-scsi-megaraid_sas-intercepts-cmd-timeout-and-throttle-io.patch
-scsi-remove-__gfp_dma.patch
-ncr5380-warning-fixes.patch
-gregkh-usb-usb-fix-omninet-memory-leak-found-by-coverity.patch
-gregkh-usb-usb-remove-useless-check-in-mos7840-found-by-coverity.patch
-gregkh-usb-usb-storage-ignore-sitecom-wl-117-usb-wlan.patch
-gregkh-usb-usb-fix-more-ftdi-elan-u132-hcd-include-lossage.patch
-gregkh-usb-usb-handle-more-rndis_host-oddities.patch
-gregkh-usb-usb-remove-usb-docbook-warnings.patch
-gregkh-usb-usb-address-fixme-in-usbnet-wrt-drivers-claiming-multiple-interfaces.patch
-gregkh-usb-ehci-fix-problem-with-bios-handoff.patch
-gregkh-usb-usb-more-autosuspend-timer-stuff.patch
-gregkh-usb-usb-remove-unneeded-warn_on.patch
-gregkh-usb-usb-new-device-pid-for-ftdi_sio-driver.patch
-gregkh-usb-usb-set-the-correct-interrupt-interval-in-usb_bulk_msg.patch
-gregkh-usb-usb-fsl_usb2_udc-fix-umti_wide-support-and-a-compile-warning.patch
-gregkh-usb-usb-auerswald-fix-file-release-handler.patch
-gregkh-usb-usb-remove-duplicate-ids-from-option-card-driver.patch
-gregkh-usb-usb-deref-urb-after-usbmon-is-done-with-it.patch
-gregkh-usb-usb-remove-short-initial-timeout-for-device-descriptor-fetch.patch
-gregkh-usb-usb-don-t-try-to-kzalloc-0-bytes.patch
-gregkh-usb-usb-onetouch-switch-to-using-input_dev-devparent.patch
-gregkh-usb-usb-fix-debug-output-of-ark3116.patch
-gregkh-usb-usb-usblp-use-correct-dma-address-in-case-of-probe-error.patch
-gregkh-usb-usb-fix-usb-ohci-subvendor-for-toshiba-portege-4000.patch
-gregkh-usb-usb-make-the-autosuspend-workqueue-thread-freezable.patch
-gregkh-usb-usb-handle-errors-in-power-level-attribute.patch
-gregkh-usb-usb-fix-ratelimit-call-semantics.patch
-gregkh-usb-usb-fix-race-between-autosuspend-and-unregister-for-root-hubs.patch
-usb-core-hubc-loops-forever-on-resume-from-ram-due-to.patch
-watchdog-documentation.patch
-drivers-net-wireless-libertas-rxc-fix.patch
-arch-x86_64-vdso-vmac-needs-schedh.patch
-x86_64-build-and-use-gdt-on-copied-compressed-kernel.patch
-i386-efi-fix-proc-iomem-type-for-kexec-tools.patch
-bug-in-i386-mtrr-initialization.patch
-xfs-clean-up-shrinker-games.patch
-xfs-use-zero_user_page.patch
-prohibit-rcutorture-from-being-compiled-into-the-kernel.patch
-avoid-zero-size-allocation-in-cache_k8_northbridges.patch
-recalc_sigpending_tsk-fixes.patch
-optimize-compat_core_sys_select-by-a-using-stack-space-for-small-fd-sets.patch
-spi-potential-memleak-in-spidev_ioctl.patch
-fbdev-cleanup-of-sparc-fb-options.patch
-pm2fb-rdac_wr-barriers-clean-up.patch
-pm3fb-various-fixes.patch
-w100fb-fix-compile-warnings.patch
-ps3fb-use-fb_sys_-instead-of-fb_cfb_.patch
-imxfb-remove-ifdefs.patch
-imxfb-fix-memory-hole.patch
-missing-const-from-reiserfs-min_key-declaration.patch
-uselib-add-missing-mnt_noexec-check.patch
 x86_64-allocate-sparsemem-memmap-above-4g.patch
-x86_64-allocate-sparsemem-memmap-above-4g-fix.patch
-fuse-generic_write_checks-for-direct_io.patch
-fuse-delete-inode-on-drop.patch
-slub-debug-fix-check-for-super-sized-slabs-512k-64bit-256k.patch
-char-cyclades-fix-deadlock.patch
-simplify-cleanup_workqueue_thread.patch
-simplify-cleanup_workqueue_thread-fix.patch
-simplify-cleanup_workqueue_thread-fix2.patch
-misc-phantom-move-to-unlocked_ioctl.patch
-misc-misc-phantom-move-to-unlocked_ioctl-fix.patch
-misc-phantom-take-care-of-pci-posting.patch
-power-fix-sizeofpage_size-typo.patch
-update-dontdiff-file.patch
-signalfd-retrieve-multiple-signals-with-one-read-call.patch
-signalfd-retrieve-multiple-signals-with-one-read-call-tidy.patch
-i2o-destroy-event-queue-only-when-drv-event-is-set.patch
-i2o-fix-notifiers-when-max_drivers-is-configured.patch
-i2o-eliminate-a-peculiar-constraint-on-i2o_max_drivers.patch
-i386-x86-64-show-that-config_hotplug_cpu-is-required-for-suspend-on-smp.patch
-md-avoid-overflow-in-raid0-calculation-with-large-components.patch
-md-dont-write-more-than-is-required-of-the-last-page-of-a-bitmap.patch
-md-fix-bug-with-linear-hot-add-and-elsewhere.patch
-hisax-fix-error-checking-for-hisax_register.patch
-sch_htb-fix-event-cache-time-calculation.patch
-applesmc-sensors-patch-missing-from-2622-rc2.patch
-off-by-one-in-floppyc.patch
-ecryptfs-delay-writing-0s-after-llseek-until-write.patch
-doc-clocksources.patch
-ehci-fsl-fix-cache-coherency-problem-on-system-with-large-memory.patch
-prevent-going-idle-with-softirq-pending.patch
-i386-fix-early-usage-of-atomic_add_return-and.patch
-omap_uwire-spi_cpha-mode-bugfix.patch
-ads7846-spi_cpha-mode-bugfix.patch
-capifunc-warning-fixes.patch
-hardware-eicon-messagec-warning-fixes.patch
-delete-every-useless-reference-to-noret_type-in-the-tree.patch
-ext4-copy-i_flags-to-inode-flags-on-write.patch
-firestream-warnings.patch

 Merged into mainline or a subsystem tree

+slub-more-documentation.patch
+slub-more-documentation-fix.patch
+smpboot-cachesize-comparison-fix-in-smp_tune_scheduling.patch
+pci-quirks-fix-msi-disabling-on-rs400-200-and-rs480.patch
+ntfs_init_locked_inode-fix-array-indexing.patch
+m68k-runtime-patching-infrastructure.patch
+slub-fix-numa--sysfs-bootstrap-issue.patch
+afs-needs-schedh.patch
+m68k-discontinuous-memory-support.patch

 2.6.22 queue

+mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch

 Fix mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch

+lots-of-architectures-enable-arbitary-speed-tty-support.patch

 tty work

+remove-dell-optiplex-gx240-from-the-acpi-blacklist.patch

 ACPI fix

-use-menuconfig-objects-ii-sound.patch

 Dropped, being redone

-working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
-working-3d-dri-intel-agpko-resume-for-i815-chip-update.patch

 Folded into working-3d-dri-intel-agpko-resume-for-i815-chip.patch

+intel_agp-cleanup-intel-private-data.patch
+intel_agp-cleanup-intel-private-data-update.patch
+intel_agp-use-table-for-device-probe.patch
+intel_agp-use-table-for-device-probe-update.patch

 AGP stuff

+dm-add-missing-braces-in-driver-debug-code.patch

 DM fix

+ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
+viotape-use-designated-initializers-for-fops-member.patch

 powerpc fixes

+gregkh-driver-driver-core-add-missing-kset-uevent.patch
+gregkh-driver-sysfs-make-sysfs_alloc_ino-static.patch
+gregkh-driver-sysfs-fix-parent-refcounting-during-rename-and-move.patch
+gregkh-driver-sysfs-reorganize-sysfs_new_indoe-and-sysfs_create.patch
+gregkh-driver-sysfs-use-iget_locked-instead-of-new_inode.patch
+gregkh-driver-sysfs-fix-root-sysfs_dirent-root-dentry-association.patch
+gregkh-driver-sysfs-move-s_active-functions-to-fs-sysfs-dirc.patch
+gregkh-driver-sysfs-slim-down-sysfs_dirent-s_active.patch
+gregkh-driver-sysfs-use-singly-linked-list-for-sysfs_dirent-tree.patch

 Driver tree updates

+jdelvare-i2c-i2c-mv64xxx-numbered-adapter.patch
+jdelvare-i2c-i2c-mpc-numbered-adapter.patch
+jdelvare-i2c-i2c-nforce2-add-smbus-block-transactions.patch

 I2C tree updates

+jdelvare-hwmon-hwmon-pc87360-to-platform-driver.patch
+jdelvare-hwmon-hwmon-use-platform_device_add_data.patch
+jdelvare-hwmon-hwmon-lm90-add-max6681-support.patch
+jdelvare-hwmon-hwmon-fault-file-name.patch
+jdelvare-hwmon-hwmon-it87-add-it8726f-support.patch
+jdelvare-hwmon-hwmon-w83627hf-pwm-freq-support.patch

 hwmon tree udpates

+hdaps-switch-to-using-input-polldev.patch
+applesmc-switch-to-using-input-polldev.patch
+ams-switch-to-using-input-polldev.patch

 Update some monitoring drivers for new input APIs

+ia64-arbitary-speed-tty-ioctl-support.patch

 tty work

+joydevc-automatic-re-calibration.patch
+drivers-input-mouse-kconfig-fix-typo.patch

 Inupt updates

+use-posix-bre-in-headers-install-target.patch

 kbuild fix

-git-leds-fixup.patch

 Unneeded

-libata-add-human-readable-error-value-decoding-v2.patch

 Folded into libata-add-human-readable-error-value-decoding.patch

+ide-aec62xx-kill-speedproc-method-wrapper-take-2.patch
+ide-ide_in_drive_list-accept-null-as-the-wildcard-for-firmware-revision.patch
+ide-mips-au1xxx_ide-h-use-null-as-firmware-revision-wildcard.patch
+ide-ide_in_drive_list-all-is-not-a-wildcard-anymore.patch

 IDE tree updates

-nommu-make-it-possible-for-romfs-to-use-mtd-devices-fix.patch

 Folded into nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch

-use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch

 Folded into use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch

+atari_pamsnetc-old-declaration-ritchie-style-fix.patch

 netdev fix

+wrong-timeout-value-in-sk_wait_data-v2-fix.patch
+atm-fix-warning.patch

 net stuff

+bluetooth-remove-the-redundant-non-seekable-llseek-method.patch

 Bluetooth fix

-sunrpc-rename-rpcb_getport_external-routine.patch
-sunrpc-rename-rpcb_getport-to-be-consistent-with-new-rpcb_getport_sync-name.patch
-nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client.patch
-nfs-clean-up-in-kernel-nfs-mount.patch
-nfs-improve-debugging-output-in-nfs-in-kernel-mount-client.patch
-nfs-new-infrastructure-for-nfs-client-in-kernel-mount-option-parsing.patch
-nfs-add-functions-to-parse-nfs-mount-options-to-fs-nfs-superc.patch
-nfs-implement-nfsv2-3-in-kernel-mount-option-parsing.patch
-nfs-add-functions-to-parse-nfs4-mount-options-to-fs-nfs-superc.patch
-nfs-move-nfs_copy_user_string.patch
-nfs-more-nfs4-in-kernel-mount-option-parsing-infrastructure.patch
-nfs-integrate-support-for-processing-nfs4-mount-options-in-fs-nfs-superc.patch

 Dropped, being redone

-serial-use-resource_size_t-for-port-io-addresses.patch
-serial-set-dtr-in-uart-for-kernel-serial-console.patch

 Dropped

+gregkh-pci-pci_bridge-device.patch

 PCI tree update

+allow-aer-to-build-for-config_acpi-=-n.patch

 AER fix

+git-scsi-misc-fixup.patch

 Fix rejects in git-scsi-misc.patch

+remove-dead-references-to-module_parm-macro.patch
+scsi-lpfc-lpfc_initc-remove-unused-variable.patch

 scsi updates

+block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch

 elevator cleanup

+sparc32-build-fix.patch

 Fix sparc32 build

+gregkh-usb-usb-set-default-y-for-config_usb_device_class.patch
+gregkh-usb-usblp-don-t-let-suspend-to-kill-used.patch
+gregkh-usb-usb-usb-gadgets-avoid-le-16-32-_to_cpup.patch
+gregkh-usb-usb-unusual_dev-sync-up-some-reported-devices-from-ubuntu.patch
+gregkh-usb-usb-oti6858-usb-serial-driver.patch
+gregkh-usb-usbmon-add-class-for-binary-interface.patch
+gregkh-usb-usb-add-usb-persist-facility.patch
+gregkh-usb-usb-ehci-ohci-handover-changes.patch
+gregkh-usb-usb-add-reset_resume-device-quirk.patch
+gregkh-usb-usb-ehci-fix-handover-for-designated-full-speed-ports.patch
+gregkh-usb-usb-make-device-reset-stop-retrying-after-disconnect.patch
+gregkh-usb-usb-io_ti-digi-edgeport-update-for-new-devices.patch
+gregkh-usb-usb-patch-to-align-the-various-usb-timers-to-fire-at-the-same-time.patch
+gregkh-usb-usb-rts-cts-handshaking-support-dtr-fixes-for-mct-u232-serial-adapter.patch
+gregkh-usb-usb-usb-gadget-dead-config-cleanup.patch
+gregkh-usb-usb-add-usb_device_and_interface_info-for-device-matching.patch
+gregkh-usb-usb-hubc-loops-forever-on-resume-from-ram-due-to-bluetooth.patch
+gregkh-usb-usb-prevent-char-device-open-deregister-race.patch
+gregkh-usb-usb-rework-c-style-comments.patch
+gregkh-usb-usb-ftdi_sioc-allow-setting-latency-timer-on-ft232rl.patch
+gregkh-usb-usb-ehci-big-endian-data-structures-support.patch
+gregkh-usb-usb-set-config_usb_ehci_big_endian_mmio-_desc-in-usb-host-kconfig.patch
+gregkh-usb-usb-ehci_fsl-update-for-mpc831x-support.patch
+gregkh-usb-usb-use-function-attribute-__maybe_unused.patch
+gregkh-usb-usb-export-linux-usb_gadgetfs-as-linux-usb-gadgetfsh.patch
+gregkh-usb-usb-visor-driver-adapted-to-new-tty-buffering.patch
+gregkh-usb-usb-ti-serial-driver-sleeps-with-spinlock-held.patch
+gregkh-usb-usb-digi-acceleport-adapted-to-new-tty-buffering.patch
+gregkh-usb-usb-generic-usb-serial-to-new-buffering-scheme.patch
+gregkh-usb-pl2303c-patch.patch
+gregkh-usb-usb-usb-serial-gadget-sparse-fixes.patch
+gregkh-usb-usb-core-hubc-prevent-re-enumeration-on-hnp.patch
+gregkh-usb-usb-introduce-usb_anchor.patch
+gregkh-usb-usb-usb-skeleton-use-anchor-to-implement-flush.patch
+gregkh-usb-usb-whiteheat-driver-update.patch
+gregkh-usb-usb-digi_acceleport-further-buffer-clean-up.patch
+gregkh-usb-usb-ehci-safe-endianness-for-transfer-buffers-after-reset-in-case-of-hub-with-tt.patch

 USB tree updates

+make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
+drivers-block-ubc-use-list_for_each_entry.patch

 USB fixes

+use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
+b44-ssb-fix-an-invalid-pointer-casting.patch

 Wireless fixes

+x86_64-mm-via-no-dac.patch
+x86_64-mm-bug-in-i386-mtrr-initialization.patch
+x86_64-mm-mtrr-sections.patch
+x86_64-mm-allocate-sparsemem-memmap-above-4g-on-x86_64.patch
+x86_64-mm-asm-ptrace_h-needs-linux-compiler_h.patch
+x86_64-mm-gcc-hot-cold.patch
+x86_64-mm-on-cpu-single.patch
+x86_64-mm-xen-add-an-mm-argument-to-alloc_pt.patch
+x86_64-mm-xen-add-a-hook-for-once-the-allocator-is-ready.patch
+x86_64-mm-xen-increase-irq-limit.patch
+x86_64-mm-xen-unstatic-leave_mm.patch
+x86_64-mm-xen-unstatic-smp_store_cpu_info.patch
+x86_64-mm-xen-make-siblingmap-functions-visible.patch
+x86_64-mm-xen-export-__supported_pte_mask.patch
+x86_64-mm-xen-core-xen-implementation.patch
-x86_64-mm-core-xen-implementation.patch
-x86_64-mm-xen-event-channels.patch
+x86_64-mm-xen-xen-event-channels.patch
+x86_64-mm-xen-add-pinned-page-flag.patch
-x86_64-mm-xen-fix-multicall-batching.patch
-x86_64-mm-xen-deal-with-negative-stolen-time.patch
+x86_64-mm-xen-hack-to-prevent-bad-segment-register-reload.patch
-x86_64-mm-xen-add-early-printk-support-via-hvc-console.patch
-x86_64-mm-xen-rename-xen-netif_-structures-to-xen_netif.patch
+revert-x86_64-mm-allocate-sparsemem-memmap-above-4g-on-x86_64.patch

 x86 tree updates

-mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
-mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-update.patch

 Folded into mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch

+x86_64-pm_trace-support.patch
+make-alt-sysrq-p-display-the-debug-register-contents.patch
+i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch

 x86 things

+add-select-phylib-to-the-ucc_geth-kconfig-option.patch
+m68k-parenthesis-balance.patch
+msi-fix-the-ordering-of-msix-irqs.patch
+msi-mask-the-msix-vector-before-we-unmap-it.patch
+potential-parse-error-in-ifdef.patch
+potential-parse-error-in-ifdef-fix.patch
+potential-parse-error-in-ifdef-update.patch
+pci_ids-update-patch-for-intel-ich9m.patch
+x86-fix-oprofile-double-free-was-re-multiple-free.patch
+work-around-dell-e520-bios-reboot-bug.patch
+skeletonfb-fix-of-xxxfb_setup-ifdef.patch
+vt8623fb-arkfb-null-pointer-dereference-fix.patch
+cfag12864bfb-use-sys_-instead-of-cfb_-framebuffer-accessors.patch
+fbdev-move-declaration-of-fb_class-to-linux-fbh.patch
+misc-tifm_7xx1-replace-deprecated-irq-flag.patch
+add-a-trivial-patch-style-checker-v2.patch
+rtc-use-fallback-irq-if-pnp-tables-dont-provide-one.patch
+memory-hotplug-fix-unnecessary-calling-of-init_currenty_empty_zone.patch
+missing-include-linux-mmh-in-drivers-sbus-char-flashc.patch
+tty-fix-leakage-of-erestartsys-to-userland.patch
+isdn4linux-fix-maturity-label-v4.patch
+prism54-maintainers-update.patch
+aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch
+atmel_spi-dma-address-bugfix.patch
+neofb-fix-pseudo_palette-array-overrun-in-neofb_setcolreg.patch
+ramfs-nommu-a-bug-in-ramfs_nommu_resize-function-passing-old-size-to-vmtruncate.patch
+h8300-trival-patches.patch
+vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch

 2.6.22 probable-queue

+rework-ptep_set_access_flags-and-fix-sun4c.patch
+unmap_vm_area-becomes-unmap_kernel_range-for-the-public.patch

 MM updates

-lazy-freeing-of-memory-through-madv_free.patch
-restore-madv_dontneed-to-its-original-linux-behaviour.patch

 Dropped

-add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix-alloc_zeroed_user_highpage-on-m68knommu.patch
-add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-bio_alloc-allocations-correctly.patch
-add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable.patch
-add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-page-cache-pages-as-__gfp_pagecache-instead-of-__gfp_movable.patch

 Folded into add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch

-move-free-pages-between-lists-on-steal-anti-fragmentation-switch-over-to-pfn_valid_within.patch

 Folded into move-free-pages-between-lists-on-steal.patch

-group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
-group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
-group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly.patch
-group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch

 Folded into group-short-lived-and-reclaimable-kernel-allocations.patch

-dont-group-high-order-atomic-allocations-remove-unused-parameter-to-allocflags_to_migratetype.patch

 Folded into dont-group-high-order-atomic-allocations.patch

+breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch

 Update the page mobility patches in -mm

+slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
+slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch

 Slub updates

+freezer-make-kernel-threads-nonfreezable-by-default.patch
+freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
+freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch

 Freezer fixes

+blackfin-enable-arbitary-speed-serial-setting.patch

 blackfin driver update

+h8300-enable-arbitary-speed-tty-port-setup.patch

 tty work

+arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
+arm26-remove-broken-and-unused-macro.patch

 arm26 updates

+freezer-run-show_state-when-freezing-times-out.patch
+pm-do-not-require-dev-spew-to-get-pm_debug.patch
+swsusp-remove-incorrect-code-from-userc.patch
+swsusp-remove-code-duplication-between-diskc-and-userc.patch
+swsusp-introduce-restore-platform-operations.patch
+swsusp-fix-hibernation-code-ordering.patch
+hibernation-prepare-to-enter-the-low-power-state.patch
+freezer-avoid-freezing-kernel-threads-prematurely.patch
+freezer-use-__set_current_state-in-refrigerator.patch
+freezer-return-int-from-freeze_processes.patch
+freezer-remove-redundant-check-in-try_to_freeze_tasks.patch

 freezer/swsusp updates

+m32r-enable-arbitary-speed-tty-rate-setting.patch

 tty work

+etrax-enable-arbitary-speed-setting-on-tty-ports.patch
+cris-replace-old-style-member-inits-with-designated-inits.patch

 CRIS updates

+v850-enable-arbitary-speed-tty-ioctls.patch

 TTY work

-add-lzo1x-compression-support-to-the-kernel.patch
-add-lzo1x-compression-support-to-the-kernel-fix.patch
-add-lzo1x-compression-support-to-the-kernel-tidy.patch

 Dropped

-add-notime-boot-option.patch

 Dropped

+define-new-percpu-interface-for-shared-data.patch
+use-the-new-percpu-interface-for-shared-data.patch
+introduce-config_virt_to_bus.patch
+pie-randomization.patch
+remove-unused-tif_notify_resume-flag.patch
+rocketc-fix-unchecked-mutex_lock_interruptible.patch
+only-send-sigxfsz-when-exceeding-rlimits.patch
+rtc-ratelimit-lost-interrupts-message.patch
+reduce-cpusetc-write_lock_irq-to-read_lock.patch
+reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
+char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
+afs-implement-file-locking.patch
+tty_io-use-kzalloc.patch
+remove-clockevents_releaserequest_device.patch
+kconfig-no-strange-misc-devices.patch
+afs-drop-explicit-extern.patch
+remove-useless-tolower-in-isofs.patch
+char-mxser_new-fix-sparse-warning.patch
+char-tty_ioctl-use-wait_event_interruptible_timeout.patch
+char-tty_ioctl-little-whitespace-cleanup.patch
+char-genrtc-use-wait_event_interruptible.patch
+char-n_r3964-use-wait_event_interruptible.patch
+char-ip2-use-msleep-for-sleeping.patch
+proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
+udf-coding-style-conversion-lindent.patch
+udf-coding-style-conversion-lindent-fixups.patch
+ext2-fix-a-comment-when-ext2_release_file-is-called.patch
+mutex_unlock-later-in-seq_lseek.patch
+zs-move-to-the-serial-subsystem.patch
+fs-block_devc-use-list_for_each_entry.patch
+fault-injection-add-min-order-parameter-to-fail_page_alloc.patch
+fault-injection-fix-example-scripts-in-documentation.patch
+add-printktime-option-deprecate-time.patch
+fs-clarify-dummy-member-in-struct.patch
+dma-mapping-prevent-dma-dependent-code-from-linking-on.patch

 Misc

-ext4-extent-overlap-bugfix.patch
-ext4-persistent_allocation_1_ioctl_and_unitialized_extents.patch
-ext4-persistent_allocation_2_support_for_writing_to_unitialized_extent.patch
+ext4-ext4_remove_exported_symbles.patch
+ext4-ext4-fallocate-4-extent_overlap_bugfix.patch
+ext4-ext4-free-blocks-on-insert-extent-failure.patch
+ext4-ext4_extents_on_by_default.patch
+ext4-ext4-propagate_flags.patch
+ext4-ext4-extent-sanity-checks.patch
+ext4-ext4-fallocate-5-ext4_support.patch
+ext4-ext4-fallocate-6-uninit_write_support.patch
+ext4-ext4_expand_inode_extra_isize.patch
+ext4-ext4_expand_inode_isize_fix.patch
+ext4-jbd-stats-through-procfs.patch
+ext4-ext4_remove_subdirs_limit.patch

 ext4 tree updates

+spi-add-3wire-mode-flag-fix.patch
+spidev-compiler-warning-gone.patch

 SPI updates

-use-menuconfig-objects-ii-isdn.patch
+update-isdn-tree-to-use-pci_get_device.patch
+use-menuconfig-objects-isdn-config_isdn.patch
+use-menuconfig-objects-isdn-config_isdn_i4l.patch
+use-menuconfig-objects-isdn-config_isdn_drv_gigaset.patch
+use-menuconfig-objects-isdn-config_isdn_capi.patch
+use-menuconfig-objects-isdn-config_capi_avm.patch
+use-menuconfig-objects-isdn-config_capi_eicon.patch

 Update ISDN Kconfig changes

+ecryptfs-move-ecryptfs-docs-into-documentation-filesystems.patch

 ecryptfs update

+rtc-rs5c372-becomes-a-new-style-i2c-driver.patch

 rtc maintenance

-lguest-the-host-code-update-for-mm-simplify-boot_params.patch

 Dropped

+char-moxa-eliminate-busy-waiting.patch
+char-specialix-remove-busy-waiting.patch
+char-riscom8-eliminate-busy-loop.patch
+char-vt-use-kzalloc.patch
+char-vt-use-array_size.patch
+char-kconfig-mxser_new-remove-experimental-comment.patch

 char driver updates

+fbcon-cursor-blink-control.patch
+fbcon-use-struct-device-instead-of-struct-class_device.patch
+fbdev-move-arch-specific-bits-to-their-respective.patch
+fbdev-detect-primary-display-device.patch
+fbcon-allow-fbcon-to-use-the-primary-display-driver.patch
+fbcon-allow-fbcon-to-use-the-primary-display-driver-fix.patch
+fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch

 fbdev things

+fs-introduce-vfs_path_lookup.patch
+sunrpc-use-vfs_path_lookup.patch
+nfsctl-use-vfs_path_lookup.patch
+fs-mark-link_path_walk-static.patch
+fs-remove-path_walk-export.patch

 VFS updates

+cfs-scheduler-v14-rc2-mm1.patch

 CFS update

+mm-swap-prefetch-increase-aggressiveness-and-tunability.patch

 swap prefetch update

+kernel-doc-add-tools-doc-in-makefile.patch
+kernel-doc-fix-unnamed-struct-union-warning.patch
+kernel-doc-strip-c99-comments.patch
+kernel-doc-fix-leading-dot-in-man-mode-output.patch
+kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch

 kernel-doc stuff

+coredump-masking-bound-suid_dumpable-sysctl.patch
+coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
+coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
+coredump-masking-add-an-interface-for-core-dump-filter.patch
+coredump-masking-elf-enable-core-dump-filtering.patch
+coredump-masking-elf-fdpic-remove-an-unused-argument.patch
+coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
+coredump-masking-documentation-for-proc-pid-coredump_filter.patch

 Filtering for waht the core dumper will dump

+containersv10-basic-container-framework.patch
+containersv10-basic-container-framework-fix.patch
+containersv10-example-cpu-accounting-subsystem.patch
+containersv10-example-cpu-accounting-subsystem-fix.patch
+containersv10-add-tasks-file-interface.patch
+containersv10-add-tasks-file-interface-fix.patch
+containersv10-add-fork-exit-hooks.patch
+containersv10-add-fork-exit-hooks-fix.patch
+containersv10-add-container_clone-interface.patch
+containersv10-add-container_clone-interface-fix.patch
+containersv10-add-procfs-interface.patch
+containersv10-add-procfs-interface-fix.patch
+containersv10-make-cpusets-a-client-of-containers.patch
+containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
+containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
+containersv10-simple-debug-info-subsystem.patch
+containersv10-simple-debug-info-subsystem-fix.patch
+containersv10-simple-debug-info-subsystem-fix-2.patch
+containersv10-support-for-automatic-userspace-release-agents.patch

 Containers core

+lockdep-sanitise-config_prove_locking.patch
+lockdep-reduce-the-ifdeffery.patch
+lockstat-core-infrastructure.patch
+lockstat-core-infrastructure-fix.patch
+lockstat-core-infrastructure-fix-fix.patch
+lockstat-human-readability-tweaks.patch
+lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch

 lockstat-via-lockdep

-reiser4-use-lzo-library-functions.patch

 Dropped

+update-page-order-at-an-appropriate-time-when-tracking-page_owner.patch

 Update page-owner-tracking for updates to Mel's stuff

-vdso-print-fatal-signals-fix.patch

 Dropped


All 993 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc3/2.6.22-rc3-mm1/patch-list


