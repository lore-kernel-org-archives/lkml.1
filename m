Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbXA1Hti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbXA1Hti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 02:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932435AbXA1Hth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 02:49:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48656 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440AbXA1Htf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 02:49:35 -0500
Date: Sat, 27 Jan 2007 23:49:28 -0800
From: Andrew Morton <akpm@osdl.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20-rc6-mm1
Message-Id: <20070127234928.64d8e437.akpm@osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Temporarily at

	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm1/

will appear one day at

	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm1/


- Added the "IPWireless 3G PCMCIA Network Driver" tree as
  git-ipwireless_cs.patch (Jiri Kosina <jkosina@suse.cz>)

- Added the IDE development tree.  It's a quilt-style tree at
  http://kernel.org/pub/linux/kernel/people/bart/pata-2.6/patches/ (Bartlomiej
  Zolnierkiewicz <bzolnier@gmail.com>)

- google have a position open for a public kernel bug manager.  See

	http://www.google.com/support/jobs/bin/answer.py?answer=53317

  This will involve working out of the Mountain View offices alongside
  myself, keeping track of the status of bugs in Linus's tree.  If you're
  qualified && interested, feel free to contact me.

- It seems that people have been busy creating the need for this.  I had to
  apply over sixty patches to this tree to fix post-2.6.20-rc4-mm1 compilation
  errors.  And a number of patches were dropped due to no-compile or to
  runtime errors.  Heaven knows how many runtime bugs were added.




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

- Semi-daily snapshots of the -mm lineup are uploaded to
  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/ and are announced on
  the mm-commits list.



Changes since 2.6.20-rc4-mm1:


 origin.patch
 git-acpi.patch
 git-ibm-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-arm.patch
 git-avr32.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-drm.patch
 git-dvb.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-libata-all.patch
 git-lxdialog.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-netdev-all.patch
 git-ioat.patch
 git-ocfs2.patch
 git-pciseg.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-scsi-rc-fixes.patch
 git-block.patch
 git-qla3xxx.patch
 git-unionfs.patch
 git-watchdog.patch
 git-ipwireless_cs.patch
 git-cryptodev.patch
 git-gccbug.patch

 git trees.

-sched-tasks-cannot-run-on-cpus-onlined-after-boot.patch
-increment-pos-before-looking-for-the-next-cap-in-__pci_find_next_ht_cap.patch
-fix-sparsemem-on-cell.patch
-qconf-fix-sigsegv-on-empty-menu-items.patch
-rtc-sh-correctly-report-rtc_wkalrmenabled.patch
-change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch
-kdump-documentation-update-for-2620.patch
-i386-sched_clock-using-init-data-tsc_disable-fix.patch
-md-pass-down-bio_rw_sync-in-raid110.patch
-kvm-add-vm-exit-profiling.patch
-nfs-fix-race-in-nfs_release_page.patch
-really-fix-funsoft-driver.patch
-revert-bd_mount_mutex-back-to-a-semaphore.patch
-intel-rng-workarounds.patch
-fix-hwrng-built-in-initcalls-priority.patch
-fix-typo-in-geode_configre-cyrixc.patch
-fd_zero-build-fix.patch
-revert-nmi_known_cpu-check-during-boot-option-parsing.patch
-blockdev-direct_io-fix-signedness-bug.patch
-submitchecklist-update.patch
-paravirt-mark-the-paravirt_ops-export-internal.patch
-kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch
-kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch
-kvm-x86-emulator-fix-bit-string-instructions.patch
-kvm-fix-asm-constraints-with-config_frame_pointer=n.patch
-kvm-fix-bogus-pagefault-on-writable-pages.patch
-rtc-sh-act-on-rtc_wkalrmenabled-when-setting-an-alarm.patch
-fix-blk_direct_io-bio-preparation.patch
-tlclk-bug-fix-misc-fixes.patch
-tlclk-bug-fix-misc-fixes-tidy.patch
-reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped.patch
-cifs-sprintf-fix.patch
-cifs-remove-2-unneeded-kzalloc-casts.patch
-powerpc-use-is_init.patch
-fix-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
-fix2-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
-driver-core-remove-device_is_registered-in.patch
-driver-core-allow-device_movedev-null.patch
-cpiac-buffer-overflow.patch
-fix-bttv-and-friends-on-64bit-machines-with-lots-of-memory.patch
-jdelvare-i2c-i2c-ali1563-fix-initialization.patch
-jdelvare-i2c-i2c-i801-document-unhiding-quirk.patch
-jdelvare-i2c-i2c-update-bus-id-list.patch
-jdelvare-i2c-i2c-add-ids-to-bus-drivers.patch
-jdelvare-hwmon-hwmon-w83793-datasheet-refresh.patch
-jdelvare-hwmon-hwmon-vid-fix-vrm11.patch
-input-atlas-button-driver.patch
-add-suport-for-marvell-88se6121-in-pata_marvell.patch
-sata_promise-atapi-cleanup.patch
-libata-piix3-support.patch
-libata-piix3-support-warning-fix.patch
-ubi-missing-include.patch
-drivers-mtd-ubi-vtblc-make-2-functions-static.patch
-ubi-printk-fix.patch
-cxgb3-main-header-files.patch
-cxgb3-main-source-file.patch
-cxgb3-hw-access-routines.patch
-cxgb3-scatter-gather-engine.patch
-cxgb3-on-board-memory-mac-and-phy.patch
-cxgb3-offload-header-files.patch
-cxgb3-offload-capabilities.patch
-cxgb3-register-definitions.patch
-cxgb3-build-files-and-versioning.patch
-sis190-mac-address-setting-fix.patch
-forcedeth-dma-access.patch
-forcedeth-ring-access.patch
-forcedeth-tx-locking.patch
-forcedeth-rx-skb-recycle.patch
-forcedeth-optimized-routines.patch
-forcedeth-tx-limiting.patch
-forcedeth-tx-data-path-optimization.patch
-forcedeth-rx-data-path-optimization.patch
-forcedeth-irq-data-path-optimization.patch
-forcedeth-tx-max-work.patch
-forcedeth-statistics-supported.patch
-forcedeth-statistics-optimization.patch
-net-use-bitrev8.patch
-x25-add-missing-sock_put-in-x25_receive_data.patch
-gregkh-pci-add-emi-support-to-pciehp.patch
-update-documentation-pcitxt.patch
-make-isa_bridge-alpha-only.patch
-scsi-megaraid_mmmbox-init-fix-for-kdump.patch
-megaraid-fix-kernel-doc.patch
-scsi-scan-fix-logging-message-for-pq3-devices.patch
-megaraid-more-kernel-doc-fixes.patch
-gregkh-usb-usb-usbtouchscreen-make-itm-screens-report-btn_touch-as-zero-when-not-touched.patch
-fix-for-bugzilla-7544-keyspan-usb-to-serial-converter.patch
-pci-mmconfig-support-for-intel-915-bridges.patch
-seq_file-conversion-apm-on-i386.patch
-mbind-restrict-nodes-to-the-currently-allowed-cpuset.patch
-toshiba-tc86c001-ide-driver-take-2.patch
-toshiba-tc86c001-ide-driver-take-2-fix.patch
-toshiba-tc86c001-ide-driver-take-2-fix-2.patch
-make-hdlc_setup-static-again.patch
-more-ftape-removal.patch
-hpt3xx-rework-rate-filtering.patch
-hpt3xx-rework-rate-filtering-tidy.patch
-hpt3xx-print-the-real-chip-name-at-startup.patch
-hpt3xx-switch-to-using-pci_get_slot.patch
-hpt3xx-cache-channels-mcr-address.patch
-hpt3x7-merge-speedproc-handlers.patch
-hpt370-clean-up-dma-timeout-handling.patch
-hpt3xx-init-code-rewrite.patch
-piix-fix-82371mx-enablebits.patch
-pdc202xx_new-remove-useless-code.patch
-pdc202xx_-remove-check_in_drive_lists-abomination.patch
-piix-tuneproc-fixes-cleanups.patch
-slc90e66-carry-over-fixes-from-piix-driver.patch
-hpt36x-pci-clock-detection-fix.patch
-atiixpc-remove-unused-code.patch
-atiixpc-sb600-ide-only-has-one-channel.patch
-atiixpc-add-cable-detection-support-for-ati-ide.patch
-ide-generic-jmicron-has-its-own-drivers-now.patch
-jmicron-warning-fix.patch

 Merged into mainline or a subsystem tree.

+namespaces-fix-exit-race-by-splitting-exit.patch
+uml-fix-mknod.patch
+fix-sys-device-power-state-regression.patch
+bonding-arp-monitoring-broken-on-x86_64.patch
+dont-allow-the-stack-to-grow-into-hugetlb-reserved-regions.patch
+powerpc-fix-sys_pciconfig_iobase-bus-matching.patch
+x86-fix-vdso-mapping-for-aout-executables.patch
+x86-fix-vdso-mapping-for-aout-executables-fixes.patch
+x86-fix-vdso-mapping-for-aout-executables-fixes-2.patch
+x86-fix-vdso-mapping-for-aout-executables-cleanups.patch
+x86-fix-vdso-mapping-for-aout-executables-doh.patch
+x86-fix-vdso-mapping-for-aout-executables-sh-fix.patch

 2.6.20 queue.

+mm-show-bounce-pages-in-oom-killer-output.patch
+fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
+add-install_special_mapping.patch
+i386-vdso-use-install_special_mapping.patch
+x86_64-ia32-vdso-use-install_special_mapping.patch
+powerpc-vdso-use-install_special_mapping.patch
+sh-vdso-use-install_special_mappingpatch.patch
+ufs-alloc-metadata-null-page-fix.patch
+ufs-truncate-negative-to-unsigned-fix.patch
+ufs-rellocation-fix.patch
+ufs-rellocation-fix-fix.patch

 Probable 2.6.20 queue.

+acpi-updates-rtc-cmos-device-platform_data.patch
+acpi-correct-apparent-typo-config_acpi_debug_output.patch

 ACPI things.

+sony_acpi-add-lanpower-and-audiopower-controls.patch
+sony_acpi-allow-multiple-sony_acpi_values-for-the-same-name.patch
+sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration.patch

 sony acpi driver updates

+remove-useless-reference-to-obsolete-kerneld.patch

 ALSA cleanup

+agpgart-allow-drm-populated-agp-memory-types-update.patch

 AGP tweak.

+amba-pl010-add-reference-to-ep93xx-to-kconfig-help-entry.patch

 ARM fix

+avr32-fix-build-breakage.patch

 Fix git-avr32.patch

+fix-ppc64s-writing-to-struct-file_operations.patch
+fix-apparent-typo-config_serial_cpm_smc.patch

 powerpc fixes

+gregkh-driver-kobject_robust.patch
+gregkh-driver-pcmcia-device.patch
+gregkh-driver-driver-core-remove-device_is_registered-in-device_move.patch
+gregkh-driver-driver-core-allow-device_move.patch
+gregkh-driver-built-in-drivers-in-sys-modules.patch
+gregkh-driver-modules-drivers-dir-only-if-needed.patch
+gregkh-driver-pci-kbuild-modname.patch
+gregkh-driver-serio-kbuild-modname.patch
+gregkh-driver-usb-kbuild-modname.patch
+gregkh-driver-sys-modules-holders.patch
+gregkh-driver-sysfs-suppress-lockdep-warnings.patch
+gregkh-driver-howto-add-a-reference-to-harbison-and-steele.patch
+gregkh-driver-sysfs-fix-missing-include-of-listh-in-sysfsh.patch
+gregkh-driver-add-uevent-vars-for-devices-with-a-class.patch
+gregkh-driver-add-device_type-to-device.patch
+gregkh-driver-allow-to-supress-uevent-for-devices.patch
+gregkh-driver-increase-firmware-loader-timeout.patch
+gregkh-driver-sysfs-shadow-directory-support.patch

 driver tree updates

+powerpc-make-it-compile.patch

 Fix driver tree

+remove-the-unused-kernel-config-option-video_videobuf.patch
+drivers-media-dvb-frontends-make-4-functions-static.patch
+dvb-video_buf-depends-on-pci.patch

 DVB fixes

+jdelvare-i2c-i2c-driver-suspend-resume-shutdown-support.patch
+jdelvare-i2c-i2c-ali1563-fix-initialization.patch
+jdelvare-i2c-i2c-i801-document-unhiding-quirk.patch
+jdelvare-i2c-i2c-update-bus-id-list.patch
+jdelvare-i2c-i2c-add-ids-to-bus-drivers.patch
+jdelvare-i2c-i2c-ibm_iic-add-parent-device.patch
+jdelvare-i2c-i2c-viapro-add-cx700-support.patch

 I2C tree updates

+jdelvare-hwmon-hwmon-unchecked-return-status-fixes-abituguru.patch
+jdelvare-hwmon-hwmon-f71805f-remove-redundant-kfree.patch

 hwmon tree updates.

-altix-acpi-ssdt-pci-device-support.patch
-altix-add-acpi-ssdt-pci-device-support-hotplug.patch

 Dropped - changes in the ACPi tree broke these.  But then I reverted the
 changes in the acpi tree because they broke the x86 tree.

+ia64-register-memory-ranges-in-a-consistent-manner.patch
+ia64-clean-up-sparsemem-memory_present-calls.patch

 ia64 fixes

+git-ieee1494-build-fix.patch

 Fix git-ieee1394.patch

-ehca-fix-do_mmap-error-check.patch

 Unneeded

+change-incorrect-config_input_atixl-to-config_mouse_atixl.patch

 Input fix

+qconf-fix-showing-help-info-on-failed-search.patch
+qconf-back-button-behaviour-normalization.patch

 qconfig fixes

+pata_platform-set_mode-fix.patch

 PATA fix

+sata_nv-cleanup-adma-error-handling-v2.patch
+sata_nv-cleanup-adma-error-handling-v2-cleanup.patch

 SATA fixes

+ide-toshiba-tc86c001-ide-driver-take-2.patch
+ide-toshiba-tc86c001-ide-driver-take-2-fix.patch
+ide-toshiba-tc86c001-ide-driver-take-2-fix-2.patch
+ide-hpt3xx-rework-rate-filtering.patch
+ide-hpt3xx-rework-rate-filtering-tidy.patch
+ide-hpt3xx-print-the-real-chip-name-at-startup.patch
+ide-hpt3xx-switch-to-using-pci_get_slot.patch
+ide-hpt3xx-cache-channels-mcr-address.patch
+ide-hpt3x7-merge-speedproc-handlers.patch
+ide-hpt370-clean-up-dma-timeout-handling.patch
+ide-hpt3xx-init-code-rewrite.patch
+ide-piix-fix-82371mx-enablebits.patch
+ide-piix-tuneproc-fixes-cleanups.patch
+ide-slc90e66-carry-over-fixes-from-piix-driver.patch
+ide-hpt36x-pci-clock-detection-fix.patch
+ide-jmicron-warning-fix.patch
+ide-pdc202xx_new-remove-useless-code.patch
+ide-pdc202xx_-remove-check_in_drive_lists-abomination.patch
+ide-atiixpc-remove-unused-code.patch
+ide-atiixpc-sb600-ide-only-has-one-channel.patch
+ide-atiixpc-add-cable-detection-support-for-ati-ide.patch
+ide-ide-generic-jmicron-has-its-own-drivers-now.patch
+ide-ide-maintainers-entry.patch
+ide-it8213-ide-driver.patch
+ide-it8213-ide-driver-update.patch
+ide-ide-pci-init-tags.patch
+ide-pdc202xx_old-dead-code.patch
+ide-au1xxx-dead-code.patch
+ide-ide-pio-blacklisted.patch
+ide-ide-no-dsc-flag.patch
+ide-trm290-dma-ifdefs.patch
+ide-ide-pci-device-tables.patch
+ide-ide-dev-openers.patch
+ide-hpt366-init-dma.patch
+ide-cs5530-cleanup.patch
+ide-svwks-cleanup.patch
+ide-sis5513-config-xfer-rate.patch
+ide-ide-set-xfer-rate.patch
+ide-ide-use-fast-pio-v2.patch
+ide-ide-io-cleanup.patch
+ide-delkin_cb-ide-driver.patch
+ide-ide-acpi-support.patch
+ide-ide-pnp-exit-fix.patch
+ide-via-ide-update.patch
+ide-it8213-ide-driver-update-fixes.patch
+ide-ide-mmio-flag.patch
+ide-hpt34x-tune-chipset-fix.patch
+ide-ide-fix-pio-fallback.patch
+ide-piix-cleanup.patch
+ide-ide-dma-check-disable-dma-fix.patch
+ide-sgiioc4-ide-dma-check-fix.patch
+ide-ide-set-dma-helper.patch
+ide-ide-dma-off-void.patch
+ide-ide-dma-host-on-void.patch
+ide-ide-fix-dma-masks.patch
+ide-ide-max-dma-mode.patch
+ide-ide-tune-dma-helper.patch

 IDE tree.

+mm-ide-ide-acpi-support-warning-fix.patch

 Fix it.

+git-mips-kconfig-fix.patch
+git-mips-prom_free_prom_memory-borkage.patch

 Fix git-mips.patch

+git-mmc-fixup.patch

 Fix rejects in git-mmc.patch

+mmc-au1xmmc-return-errors-for-unknown-response-types.patch
+mmc-au1xmmc-implement-proper-ro-switch-detection.patch

 mmc updates

+mtd_ck804xrom-must-depend-on-pci.patch

 MTD fix

+git-netdev-all-fixup.patch
+git-netdev-all-atl1-build-fix.patch
+git-netdev-all-atl1-pm-fix.patch

 Fix git-netdev-all.patch

+remove-one-remaining-define-bcm_tso-1.patch
+fs_enet-of-related-fixup-for-fec-and-scc-macs.patch
+82596-warning-fix.patch

 netdev fixes

+remove-tcp-header-from-tcp_v4_check-take-2.patch
+slip-replace-kmalloc-memset-pairs-with-the.patch
+remove-unused-kernel-config-option-dlci_count.patch
+dccp-warning-fixes.patch

 net fixes

+nfs-fix-congestion-control-v4.patch
+nfs-fix-congestion-control-v4-tweaks.patch

 Fix NFS request throttling.

+gregkh-pci-pciehp-add-electro-mechanical-interlock-support-to-the-pcie-hotplug-driver.patch
+gregkh-pci-shpchp-remove-config_hotplug_pci_shpc_poll_event_mode.patch
+gregkh-pci-shpchp-remove-dbg_xxx_routine.patch
+gregkh-pci-shpchp-delete-trailing-whitespace.patch
+gregkh-pci-pci-speed-up-the-intel-smbus-unhiding-quirk.patch
+gregkh-pci-pci-remove-quirk_sis_96x_compatible.patch
+gregkh-pci-pci-make-isa_bridge-alpha-only.patch
+gregkh-pci-pci-cleanup-msi-code.patch
+gregkh-pci-pci-power-management-remove-noise-on-non-manageable-hw.patch
+gregkh-pci-pci-duplicate-ids-ata_piix.patch
+gregkh-pci-pci-duplicate-ids-ipr.patch
+gregkh-pci-msi-replace-pci_msi_quirk-with-calls-to-pci_no_msi.patch
+gregkh-pci-msi-remove-pci_scan_msi_device.patch
+gregkh-pci-msi-combine-pci__msi-msix_state.patch
+gregkh-pci-msi-abstract-msi-suspend.patch

 PCI tree updates

+make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch
+make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix.patch

 Add a boot option to set the cardbus window sizes

+bugfixes-pci-devices-get-assigned-redundant-irqs.patch

 PCI fix.  Might break things.

+sh-add-kconfig-default.patch

 Fix git-sh.patch

+scsi-handle-bad-inquiry-responses.patch
+drivers-scsi-qla4xxx-possible-cleanups.patch
+drivers-scsi-buslogic-replace-boolean-by-bool.patch
+make-seagate_st0x_detect-static.patch
+remove-some-unused-scsi-related-kernel-config-variables.patch

 SCSI fixes

+git-block-borkage.patch

 Fix git-block.patch some more.

-git-sas.patch
-git-sas-kconfig-fix.patch

 The git-sas tree appears to be unmaintained and is full of conflicts. 
 Dropped.

+gregkh-usb-usb-unusual_devsh-for-sony-floppy.patch
+gregkh-usb-usb-add-epic-support-to-the-io_edgeport-driver.patch
+gregkh-usb-usb-move-usb_device_class-class-devices-to-be-real-devices.patch
+gregkh-usb-usb-convert-usb-class-devices-to-real-devices.patch
+gregkh-usb-usb-race-on-disconnect-in-mdc800.patch
+gregkh-usb-uhci-improved-debugging-checks-for-the-frame-list.patch
+gregkh-usb-uhci-no-dummy-tds-for-iso-qhs.patch
+gregkh-usb-usb-storage-scsi-level-fixes.patch
+gregkh-usb-usb-ohci-at91-refcount-fix-for-irq-wake-enables.patch
+gregkh-usb-usb-gadgetfs-whitespace-cleanup.patch
+gregkh-usb-usb-gadgetfs-remove-delayed-init-mode.patch
+gregkh-usb-usb-power-management-for-kaweth.patch
+gregkh-usb-usb-better-ethtool-support-for-kaweth.patch
+gregkh-usb-usb-ps3-ehci-bus-glue.patch
+gregkh-usb-usb-ps3-controller-hid-quirk.patch
+gregkh-usb-usb-ohci-error-handling-cleanup.patch
+gregkh-usb-usb-ps3-ohci-bus-glue.patch
+gregkh-usb-uhci-fix-bandwidth-allocation.patch
+gregkh-usb-usbcore-remove-unused-bandwith-related-code.patch
+gregkh-usb-ehci-local-variable-for-port-status-register.patch
+gregkh-usb-ehci-don-t-hide-ports-owned-by-the-companion.patch
+gregkh-usb-ehci-force-high-speed-devices-to-run-at-full-speed.patch
+gregkh-usb-usb-at91_udc-wakeup-event-updates.patch
+gregkh-usb-usb-total-removal-of-multithreaded-probing-in-usb.patch
+gregkh-usb-fix-for-bugzilla-7544.patch
+gregkh-usb-usb-race-fixes-for-usb-serial-step-1.patch
+gregkh-usb-usb-race-fixes-for-usb-serial-step-2.patch
+gregkh-usb-usb-race-fixes-for-usb-serial-step-3.patch
+gregkh-usb-usb-gadgetfs-cleanups.patch
+gregkh-usb-usb-gadgetfs-simplifications.patch
+gregkh-usb-usb-gadgetfs-race-fix.patch
+gregkh-usb-usb-gadgetfs-behaves-better-on-userspace-init-bug.patch
+gregkh-usb-usb-gadgetfs-aio-tweaks.patch
+gregkh-usb-usb-list-atmel-husb2_udc-gadget-controller.patch
+gregkh-usb-usb-usb-ethernet-gadget-recognizes-husb2dev.patch
+gregkh-usb-usb-sierra-wireless-auto-set-d0.patch
+gregkh-usb-usb-input-added-kernel-module-to-support-all-gtco-calcomp-usb-interwrite-school-products.patch
+gregkh-usb-usb-autosuspend-for-usb-printer-driver.patch
+gregkh-usb-usb-switch-ehci-hcd-to-new-polling-scheme.patch
+gregkh-usb-ehci-fix-interrupt-driven-remote-wakeup.patch
+gregkh-usb-usb-storage-use-first-bulk-endpoints-not-last.patch
+gregkh-usb-usbcore-trivial-whitespace-fixes.patch
+gregkh-usb-usb-a-bit-more-coding-style-cleanup.patch
+gregkh-usb-usb-duplicate-ids-visor.patch
+gregkh-usb-usb-duplicate-ids-ftdi_sio.patch
+gregkh-usb-usb-duplicate-ids-keyspan.patch
+gregkh-usb-usb-duplicate-ids-usb_storage.patch
+gregkh-usb-berry_charge.patch

 USB tree updates

+fix-gregkh-usb-usbcore-remove-unused-bandwith-related-code.patch

 Fix it.

+fix-misspelled-usbnet_mii-kernel-config-option.patch
+usb-in-init_endpoint_class-use-ptr_err-to-obtain-an-errno-value-not-is_err.patch
+fix-apparent-typo-config_usb_cdcether.patch

 USB things.

+fix-unaligned-exception-in-drivers-net-wireless-orinococ.patch

 wireless fix.

+x86_64-mm-defconfig-update.patch
+x86_64-mm-i386-defconfig-update.patch
+x86_64-mm-remove-get_pmd.patch
+x86_64-mm-blink-driver.patch
+x86_64-mm-fix-tlbflush-comment.patch
+x86_64-mm-msr-on-cpu.patch
+x86_64-mm-reject-a-broken-mcfg-tables-on-asus-etc.patch
+x86_64-mm-kconfig-typos.patch
+x86_64-mm-msr-scf-single.patch
+x86_64-mm-mtrr-scf-single.patch
+x86_64-mm-fix-preprocessor-condition.patch
+x86_64-mm-mtrr-compat.patch
+x86_64-mm-apm-seqfile.patch
+x86_64-mm-update-disable_io_apic-to-use-8-bit-destination-field.patch
+x86_64-mm-readd-fadt-physflat.patch
+x86_64-mm-fix-size_or_mask-and-size_and_mask.patch
+x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration-code-update-1.patch
+x86_64-mm-putreg-check.patch

 x86 tree updates

+revert-x86_64-mm-msr-on-cpu.patch
+fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch

 Fix it.

-i386-adjustments-to-page-table-dump-during-oops.patch
+i386-adjustments-to-page-table-dump-during-oops-v2.patch

 Updated.

+i386-modpost-apic-related-warning-fixes.patch
+geode-support-classic-mediagxm.patch
+arch-i386-kernel-ptracec-trivial-whitespace-cleanup.patch
+i386-kwatch-kernel-watchpoints-using-cpu-debug-registers.patch
+i386-kwatch-kernel-watchpoints-using-cpu-debug-registers-fix.patch
+i386-entrys-end-endproc-annotations.patch
+x86_64-clean-up-sparsemem-memory_present-call.patch
+arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
+kexec-update-io-apic-dest-field-to-8-bit-for.patch
+remove-unused-kernel-config-option-x86_xadd.patch
+hpet-avoid-warning-message-livelock.patch
+minor-patch-for-compilation-warning-in-x86_64-signal-code.patch
+x86_64-fix-fs-gs-registers-for-vt-execution.patch
+arch-i386-kernel-alternativec-dont-include-bugsh.patch

 x86 updates.

+typeof-__page_to_pfn-with-sparsemem=y.patch

 MM sparse fix

+use-zvc-for-inactive-and-active-counts.patch
+use-zvc-for-inactive-and-active-counts-up-fix.patch
+use-zvc-for-free_pages.patch
+use-zvc-for-free_pages-fix.patch
+use-zvc-for-free_pages-fix-2.patch
+use-zvc-for-free_pages-fix-3.patch
+use-zvc-for-free_pages-fix-4.patch
+reorder-zvcs-according-to-cacheline.patch
+drop-free_pages.patch
+drop-free_pages-fix.patch
+drop-free_pages-sparc64-fix.patch
+drop-nr_free_pages_pgdat.patch
+drop-__get_zone_counts.patch
+drop-get_zone_counts.patch
+get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied.patch
+get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied-fix.patch

 Rework the pagecache accounting pertaining to writeback, use it in the
 writeback code.

+optional-zone_dma-in-the-vm-tidy.patch

 Cleanup

+swsusp-change-code-order-in-diskc-fix.patch

 Fix swsusp-change-code-ordering-in-diskc.patch

-m68k-work-around-binutils-tokenizer-change.patch

 Needs updating.

+m68k-uaccessh-needs-schedh.patch

 m68k build fix.

+uml-add-per-device-queues-and-locks-to-ubd-driver.patch
+uml-locking-fixes-in-the-ubd-driver.patch
+uml-locking-comments-in-memory-and-tempfile-code.patch
+uml-locking-comments-in-startup-code.patch
+uml-style-fixes-in-startup-code.patch
+uml-libc-dependent-code-should-call-libc-directly.patch
+uml-fix-style-violations.patch
+uml-fix-apparent-config_64_bit-typo.patch

 UML updates.

+char-mxser_new-upgrade-to-1915-fix.patch
+char-mxser_new-do-not-null-driver_data.patch
+char-mxser_new-lock-count-and-flags.patch
+char-mxser_new-fix-sparse-warning.patch

 serial driver updates.


+rtc-framework-driver-for-cmos-rtcs-fix.patch
+rtc-framework-driver-for-cmos-rtcs-fix-2.patch

 Fix rtc-framework-driver-for-cmos-rtcs.patch

+audit-fix-audit_filter_user_rules-initialization-bug.patch
+raw-dont-allow-the-creation-of-a-raw-device-with-minor-number-0.patch
+fix-rmmod-read-write-races-in-proc-entries.patch
+sed-s-gawk-awk-scripts-gen_init_ramfssh.patch
+seq_file-conversion-coda.patch
+fix-umask-when-noacl-kernel-meets-extn-tuned-for-acls.patch
+seq_file-conversion-toshibac.patch
+return-enoent-from-ext3_link-when-racing-with-unlink.patch
+return-enoent-from-ext3_link-when-racing-with-unlink-fix.patch
+remove-ext_inc_count-and-_dec_count.patch
+remove-the-last-reference-to-rwlock_is_locked-macro.patch
+consolidate-bust_spinlocks.patch
+extract-and-use-wake_up_klogd.patch
+extend-the-set-of-__attribute__-shortcut-macros.patch
+documentation-rbtreetxt-updated.patch
+replace-highest_possible_node_id-with-nr_node_ids.patch
+docbook-html-correction-of-recursive-a-tags-in-html-output.patch
+pnpacpi-remove-experimental-dependency.patch
+cdevh-forward-declarations.patch
+buffer-memorder-fix.patch
+mm-search_binary_handler-mem-limit-fix.patch
+remove-final-reference-to-superfluous-smp_commence.patch
+cleanup-include-linux-xattrh.patch
+cleanup-include-linux-reiserfs_xattrh.patch
+replace-regular-code-with-appropriate-calls-to-container_of.patch
+remove-dead-kernel-config-option-aedsp16_mpu401.patch
+remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
+remove-unused-kernel-config-option-zisofs_fs.patch
+remove-unused-kernel-config-option-lcd_device.patch
+remove-unused-kernel-config-option-paride_parport.patch
+order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
+minimize-lockdep_on-off-side-effect.patch
+kprobes-replace-magic-numbers-with-enum.patch
+some-rtc-documentation-updates.patch
+drivers-block-dac960-converted-boolean-to-bool.patch
+mxser-remove-useless-fields.patch
+fix-apparent-typo-config_lockdep_debug.patch

 Misc patches.

+spi-kconfig-fix.patch
+spi-controller-driver-for-omap-microwire.patch
+spi-controller-driver-for-omap-microwire-tidy.patch
+spi-controller-driver-for-omap-microwire-update.patch
+spi-controller-driver-for-omap-microwire-update-fix.patch
+spi-freescale-imx-spi-controller-driver-bis.patch
+spi-add-spi_set_drvdata-and-spi_get_drvdata.patch
+spi-documentation-does-not-need-to-set-drivers-bus_type-field.patch
+spi-remove-return-in-spi_unregister_driver.patch
+spi_bitbang-use-overridable-setup_transfer-method.patch
+spi-cleanup-method-param-becomes-non-const.patch

 SPI udpates.

+add-shared-version-of-apm-emulation.patch
+arm-convert-to-use-shared-apm-emulation.patch
+mips-convert-to-use-shared-apm-emulation.patch
+mips-convert-to-use-shared-apm-emulation-fix.patch
+sh-convert-to-use-shared-apm-emulation.patch

 Consolidate APM emulation on several architectures.

+make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
+change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
+have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode.patch
+have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode-update.patch

 Better support for large inode numbers.

-gtod-uninline-jiffiesh.patch
-gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
-gtod-fix-timeout-overflow.patch
-gtod-persistent-clock-support-core.patch
-gtod-persistent-clock-support-i386.patch
-dynticks-uninline-irq_enter.patch
-dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
-hrtimers-namespace-and-enum-cleanup.patch
-hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
-hrtimers-clean-up-locking.patch
-hrtimers-add-state-tracking.patch
-hrtimers-clean-up-callback-tracking.patch
-hrtimers-move-and-add-documentation.patch
-acpi-include-fix.patch
-acpi-keep-track-of-timer-broadcast.patch
-acpi-add-state-propagation-for-dynamic-broadcasting.patch
-acpi-cleanups-allow-early-access-to-pmtimer.patch
-i386-apic-clean-up-the-apic-code.patch
-clockevents-core.patch
-clockevents-i386-drivers.patch
-clockevents-i386-drivers-high-res-timers-fix-apic-event-broadcasting-code.patch
-clockevents-i386-hpet-driver.patch
-i386-apic-rework-and-fix-local-apic-calibration.patch
-high-res-timers-core.patch
-high-res-timers-core-do-itimer-rearming-in-process-context.patch
-high-res-timers-core-do-itimer-rearming-in-process-context-fix2.patch
-high-res-timers-core-hrtimers-add-state-tracking-fix.patch
-high-res-timers-core-hrtimers-add-state-tracking-fix-fix.patch
-high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
-dynticks-core.patch
-dynticks-add-nohz-stats-to-proc-stat.patch
-dynticks-i386-support-idle-handler-callbacks.patch
-dynticks-i386-prepare-nmi-watchdog.patch
-high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
-debugging-feature-add-proc-timer_stat.patch
-debugging-feature-proc-timer_list.patch
-debugging-feature-proc-timer_list-warning-fix.patch
-debugging-feature-sysrq-q-to-print-timers.patch

 A new version of the hrtimers&dynticks patch series was received, and it
 failed.

-hpet-avoid-warning-message-livelock.patch
-generic-vsyscall-gtod-support-for-generic_time.patch
-generic-vsyscall-gtod-support-for-generic_time-tidy.patch
-time-x86_64-hpet_address-cleanup.patch
-revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
-time-x86_64-split-x86_64-kernel-timec-up.patch
-time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
-time-x86_64-split-x86_64-kernel-timec-up-fix.patch
-reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
-time-x86_64-convert-x86_64-to-use-generic_time.patch
-time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
-time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
-time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
-time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch

 And these got dropped as a result, too.

+extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch

 Fix extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch some more.

-handle-cpu_lock_acquire-and-cpu_lock_release-in-workqueue_cpu_callback.patch

 Dropped

+workqueue-rework-threads-hotplug-management.patch

 Update workqueue fixes

+drivers-isdn-sc-proper-prototypes.patch
+isdn-capi-use-array_size-when-appropriate.patch
+isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch

 ISDN updates.

+ecryptfs-public-key-transport-mechanism.patch
+ecryptfs-public-key-transport-mechanism-fix.patch
+ecryptfs-public-key-packet-management.patch
+ecryptfs-public-key-packet-management-slab-fix.patch
+ecryptfs-xattr-flags-and-mount-options.patch
+ecryptfs-generalize-metadata-read-write.patch
+ecryptfs-generalize-metadata-read-write-fix.patch
+ecryptfs-encrypted-passthrough.patch
+ecryptfs-convert-f_op-write-to-vfs_write.patch
+ecryptfs-convert-kmap-to-kmap_atomic.patch
+ecryptfs-open-code-flag-checking-and-manipulation.patch
+ecryptfs-add-flush_dcache_page-calls.patch
+ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd.patch

 ecryptfs queue.

+fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch

 Fix fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch

+fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch

 Fix  fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch

+sched-avoid-div-in-rebalance_tick.patch

 CPU scheduler speedup.

+mm-implement-swap-prefetching-vs-zvc-stuff.patch
+mm-implement-swap-prefetching-vs-zvc-stuff-2.patch

 Fix mm-implement-swap-prefetching.patch

+introduce-and-use-get_task_mnt_ns.patch
+introduce-and-use-get_task_mnt_ns-tweaks.patch
+nsproxy-externalizes-exit_task_namespaces-fix.patch
+user_ns-handle-file-sigio-fix.patch
+user_ns-handle-file-sigio-fix-2.patch
-user-ns-always-on.patch

 More work on the user-namespace patches in -mm.

+remove-find_attach_pid.patch
+statically-initialize-struct-pid-for-swapper.patch
+explicitly-set-pgid-sid-of-init.patch

 More work on the PID management patches in -mm.

+uts-namespace-remove-config_uts_ns.patch
+ipc-namespace-remove-config_ipc_ns.patch
+ipc-namespace-remove-config_ipc_ns-linkage-fix.patch
+ipc-namespace-remove-config_ipc_ns-linkage-fix-fix.patch

 More work on the namespace patches in -mm.

+dynamic-kernel-command-line-common.patch
+dynamic-kernel-command-line-alpha.patch
+dynamic-kernel-command-line-arm.patch
+dynamic-kernel-command-line-arm26.patch
+dynamic-kernel-command-line-avr32.patch
+dynamic-kernel-command-line-cris.patch
+dynamic-kernel-command-line-frv.patch
+dynamic-kernel-command-line-h8300.patch
+dynamic-kernel-command-line-i386.patch
+dynamic-kernel-command-line-ia64.patch
+dynamic-kernel-command-line-ia64-fix.patch
+dynamic-kernel-command-line-m32r.patch
+dynamic-kernel-command-line-m68k.patch
+dynamic-kernel-command-line-m68knommu.patch
+dynamic-kernel-command-line-mips.patch
+dynamic-kernel-command-line-parisc.patch
+dynamic-kernel-command-line-powerpc.patch
+dynamic-kernel-command-line-ppc.patch
+dynamic-kernel-command-line-s390.patch
+dynamic-kernel-command-line-sh.patch
+dynamic-kernel-command-line-sh64.patch
+dynamic-kernel-command-line-sparc.patch
+dynamic-kernel-command-line-sparc64.patch
+dynamic-kernel-command-line-um.patch
+dynamic-kernel-command-line-v850.patch
+dynamic-kernel-command-line-x86_64.patch
+dynamic-kernel-command-line-xtensa.patch
+dynamic-kernel-command-line-fixups.patch

 Remove static limitation on kernel command line size.

+i386-2048-byte-command-line.patch
+x86_64-2048-byte-command-line.patch
+ia64-2048-byte-command-line.patch

 Support longer command lines on some architectures.

+rcu-split-classic-rcu.patch
+rcu-softirq-for-rcu.patch
+rcu-fix-barriers.patch
+rcu-preemptible-rcu.patch
+rcu-preemptible-rcu-fix.patch
+rcu-debug-trace-for-rcu.patch
+rcu-trivial-fixes.patch

 Preemptible RCU.

+lutimesat-simplify-utime2.patch
+lutimesat-extend-do_utimes-with-flags.patch
+lutimesat-actual-syscall-and-wire-up-on-i386.patch

 Implement lutimesat() syscall.

+readahead-state-based-method-aging-accounting-vs-zvc-changes.patch

 Fix readahead-state-based-method-aging-accounting.patch

+reiser4-fix-readpage_cryptcompress.patch
+reiser4-improve-estimation-for-number-of-nodes-occupied.patch
+reiser4-drop-check_cryptcompress.patch
+reiser4-fix-freeze-and-corruption.patch

 reiser4 updates.

+proper-prototype-for-tosh_smm.patch
+recognize-video=gx1fb-option.patch
+correct-apparent-typo-config_aty_ct-in-aty-video.patch

 fbdev updates

+mark-struct-file_operations-const-1.patch
+mark-struct-file_operations-const-2.patch
+mark-struct-file_operations-const-2-fix.patch
+mark-struct-file_operations-const-3.patch
+mark-struct-file_operations-const-4.patch
+mark-struct-file_operations-const-4-fix.patch
+mark-struct-file_operations-const-5.patch
+mark-struct-file_operations-const-6.patch
+mark-struct-file_operations-const-7.patch
+mark-struct-file_operations-const-8.patch
+mark-struct-file_operations-const-9.patch
+mark-struct-inode_operations-const-1.patch
+mark-struct-inode_operations-const-2.patch
+mark-struct-inode_operations-const-3.patch
+mark-struct-super_operations-const.patch

 constifications.

+scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
+scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
+scheduled-removal-of-sa_xxx-interrupt-flags.patch
+scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch

 Remove the SA_* interrupt defines.

+sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
+sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs.patch
+sysctl-sunrpc-remove-unnecessary-insert_at_head-flag.patch
+sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de.patch
+sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
+sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
+sysctl-llc-remove-unnecessary-insert_at_head-flag.patch
+sysctl-ipx-remove-unnecessary-insert_at_head-flag.patch
+sysctl-decnet-remove-unnecessary-insert_at_head-flag.patch
+sysctl-dccp-remove-unnecessary-insert_at_head-flag.patch
+sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
+sysctl-atalk-remove-unnecessary-insert_at_head-flag.patch
+sysctl-xfs-remove-unnecessary-insert_at_head-flag.patch
+sysctl-c99-convert-xfs-ctl_tables.patch
+sysctl-c99-convert-xfs-ctl_tables-fixes.patch
+sysctl-scsi-remove-unnecessary-insert_at_head-flag.patch
+sysctl-md-remove-unnecessary-insert_at_head-flag.patch
+sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
+sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch
+sysctl-cdrom-remove-unnecessary-insert_at_head-flag.patch
+sysctl-cdrom-dont-set-de-owner.patch
+sysctl-move-ctl_pm-into-sysctlh-where-it-belongs.patch
+sysctl-frv-pm-remove-unnecessary-insert_at_head-flag.patch
+sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch
+sysctl-frv-remove-unnecessary-insert_at_head-flag.patch
+sysctl-c99-convert-arch-frv-kernel-pmc.patch
+sysctl-c99-convert-arch-frv-kernel-sysctlc.patch
+sysctl-sn-remove-sysctl-abi-breakage.patch
+sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc.patch
+sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage.patch
+sysctl-mips-au1000-remove-sys_sysctl-support.patch
+sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
+sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
+sysctl-s390-move-sysctl-definitions-to-sysctlh.patch
+sysctl-s390-move-sysctl-definitions-to-sysctlh-fix.patch
+sysctl-s390-remove-unnecessary-use-of-insert_at_head.patch
+sysctl-c99-convert-ctl_tables-in-arch-powerpc-kernel-idlec.patch
+sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch
+sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage.patch
+sysctl-x86_64-remove-unnecessary-use-of-insert_at_head.patch
+sysctl-c99-convert-ctl_tables-in-arch-x86_64-ia32-ia32_binfmtc.patch
+sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc.patch
+sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc.patch
+sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver.patch
+sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
+sysctl-register-the-sysctl-number-used-by-the-arlan-driver.patch
+sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch
+sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc-fix.patch
+sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls.patch
+sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
+sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
+sysctl-register-the-ocfs2-sysctl-numbers.patch
+sysctl-move-init_irq_proc-into-init-main-where-it-belongs.patch
+sysctl-move-utsname-sysctls-to-their-own-file.patch
+sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
+sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix.patch
+sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
+sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
+sysctl-remove-support-for-ctl_any.patch
+sysctl-remove-support-for-directory-strategy-routines.patch
+sysctl-remove-insert_at_head-from-register_sysctl.patch
+sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
+sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
+sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
+sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch
+sysctl-reimplement-the-sysctl-proc-support.patch
+sysctl-reimplement-the-sysctl-proc-support-fix.patch
+sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
+sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
+sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
+sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-hack.patch
+sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch

 A few sysctl patches.

+#profile-likely-unlikely-macros-x86_64-fix.patch

 Unneeded due to time patch droppage.


All 1376 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm1/patch-list



