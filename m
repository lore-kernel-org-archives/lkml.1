Return-Path: <linux-kernel-owner+w=401wt.eu-S1760624AbXK1LmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624AbXK1LmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 06:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758973AbXK1Lls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 06:41:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758865AbXK1Llp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 06:41:45 -0500
Date: Wed, 28 Nov 2007 03:41:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc3-mm2
Message-Id: <20071128034140.648383f0.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm2/

- All patches against subsystem trees were recently sent to the relevant
  maintainers.  Many (probably most) were ignored.  I don't know why this
  happens.

- First bug report: after ten minutes happily compiling kernels my
  2.6.24-rc3-mm2 x86_64 box spontaneously rebooted.

- s390 won't build due to a large clash with the driver tree which I didn't
  fix.

- the unprivileged mounts and revoke patchsets were dropped - they were
  getting in the way of other work and were somewhat out of date.

- I won't be paying much attention to feature patches for the rest of the
  2.6.24 development cycle.  We need to get the existing queue stabilised and
  I left this too late in 2.6.23.

  This only affects the patches which are only in -mm: expect ongoing mayhem
  in the various subsystem trees.



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




Changes since 2.6.24-rc3-mm1:

 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
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
 git-lblnet.patch
 git-leds.patch
 git-libata-all.patch
 git-m32r.patch
 git-md-accel.patch
 git-mips.patch
 git-mips-fixup.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-net.patch
 git-netdev-all.patch
 git-battery.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-parisc.patch
 git-selinux.patch
 git-s390.patch
 git-sched.patch
 git-sh.patch
 git-scsi-misc.patch
 git-scsi-rc-fixes.patch
 git-sparc64.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-x86.patch
 git-x86-build-fix.patch
 git-newsetup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-xtensa.patch

 git trees

-m68k-export-atari_keyb_init.patch
-amiga-zorro-bus-add-missing-zorro_device_remove.patch
-mac68k-mailing-list-addresss.patch
-ipmi-add-the-standard-watchdog-timeout-ioctls.patch
-uninitialised-variable-in-arm-ixp4xx-clockevents-code.patch
-unlock-when-ssp-tries-to-close-an-invalid-port.patch
-ixp4xx-remove-double-include.patch
-arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch
-arch-arm-removed-duplicate-includes.patch
-gx-suspmodc-use-boot_cpu_data-instead-of-current_cpu_data.patch
-cpufreq-fix-incorrect-comment-on-show_available_freqs-in-freq_tablec.patch
-create-sys-power-when-config_pm-is-set.patch
-sysfs-fix-off-by-one-error-in-fill_read_buffer.patch
-fs-sysfs-remove-spin_lock_unlocked.patch
-qlogic-infinipath-convert-ipath_eep_sem-to-mutex.patch
-input-polled-device-timer-rounding.patch
-pata_sisc-add-packard-bell-easynote-k5305-to-laptops.patch
-ahci-invalid-use-of-writel-readl-with-iomap.patch
-libata-core-list-more-documentation-sources-for-reference.patch
-libata-iordy-handling.patch
-libata-sff-tf_load.patch
-pata_ali-add-mitac-8317-and-derivatives.patch
-pata_ali-lots-of-problems-still-showing-up-with-small-atapi-dma.patch
-pata_hpt37x-fix-cable-detect-bug-spotted-by-sergei.patch
-pata_isapnp-polled-devices.patch
-pata_ninja32-cardbus-ata-initial-support.patch
-ide-mm-sis5513-add-packard-bell-easynote-k5305-to-laptops.patch
-ide-mm-ide-dont-set-pio-mode-on-pre-eide-drives.patch
-ide-mm-siimage-remove-resetproc-method.patch
-ide-mm-ide-skip-ide_wait_not_busy-on-noprobe-disks.patch
-ide-mm-aec62xx-fix-kernel-oops-in-driver-s-probe-function.patch
-ide-arm-hack.patch
-ide-add-helper-__ide_setup_pci_device.patch
-ide-printk-fix.patch
-pfkey-sending-an-sadb_get-responds-with-an-sadb_get.patch
-make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
-tlan-list-is-subscribers-only.patch
-net-sunrpc-remove-spin_lock_unlocked.patch
-drivers-net-chelsio-if-0-unused-functions.patch
-forcedeth-new-mcp79-device-ids.patch
-forcedeth-boot-delay-fix.patch
-blackfin-typo-config_rtc_bfin_module.patch
-git-nfs-make-nfs_wb_page_priority-static.patch
-fs-nfs-dirc-should-include-internalh.patch
-git-nfsd-build-fix.patch
-mem-policy-fix-mempolicy-usage-in-pci-driver.patch
-pci-get-rid-of-pci_devvendordevice_compatible-fields.patch
-quirk_vialatency-omit-reading-pci-revision-id.patch
-quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
-pci-remove-unneeded-lock_kernel-in-drivers-pci-syscallc.patch
-always-export-pci_scan_single_device.patch
-remove-additional-pci_scan_child_bus-prototype.patch
-pci-add-pci-quirk-function-for-some-chipsets.patch
-drivers-pci-quirksc-coding-style-cleanup.patch
-more-sanity-checks-for-dmar.patch
-more-sanity-checks-for-dmar-checkpatch-fixes.patch
-fix-build-breakage-if-sysfs-fix.patch
-nsp32_restart_autoscsi-remove-error-check.patch
-scsi-early-detection-of-medium-not-present-updated.patch
-scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers.patch
-scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
-usb-hcd-avoid-duplicate-local_irq_disable.patch
-usb-s3c2410_udc-minor-irq-handler-cleanups.patch
-usbserial-fix-inconsistent-lock-state.patch
-sis-fb-driver-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch
-usb-fix-locks-and-urb-status-in-adutux-updated.patch
-usb-mon-mon_binc-cleanups.patch
-usb-device-dma-support-on-omap2.patch
-ti-3410-5052-usb-serial-convert-td_open_close_lock-to-mutex.patch
-git-x86-thread_order-borkage.patch
-git-x86-thread_order-borkage-fix.patch
-git-x86-identify_cpu-fix.patch
-git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko.patch
-git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko-checkpatch-fixes.patch
-git-x86-inlining-borkage.patch
-x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2.patch
-pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2.patch
-nfs-fix-the-ustat-regression.patch
-isdn-validate-length-of-isdn_net_ioctl_cfgeaz.patch
-blackfin-remove-dump_thread.patch
-power_supply_ledssysfsc-should-include-power_supplyh.patch
-sisusb-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch
-doc-add-uio-document-to-docbook-compilation-target.patch

 Merged into mainline or a subsystem tree

+ipc-lost-unlock-and-fput-in-mqueuec-on-error-path.patch
+fix-linux-kdh-usage-in-userspace.patch
+fix-linux-kdh-usage-in-userspace-checkpatch-fixes.patch
+m68k-zorro7xx-needs-asm-amigahwh.patch
+fb_ddc-fix-ddc-lines-quirk.patch
+drivers-pnp-resourcec-add-missing-pci_dev_put.patch
+mfd-sm501-debug-typo-fix.patch
+isolate-the-uts-namespaces-domainname-and-hostname-back.patch
+the-namespaces-compatibility-list.patch
+atmel_lcdfb-lcdc-startup-fix.patch
+dmaengine-correct-invalid-assumptions-in-the-kconfig-text.patch
+ip22zilog-fix-lockup-and-sysrq.patch
+fix-up-ext2_fsh-for-userspace-after-reservations-backport.patch
+hexdump-dont-print-bytes-with-bit-7-set.patch
+file-capabilities-dont-prevent-signaling-setuid-root.patch
+isdn-bootup-crash-fix-2624-rc3-git1.patch
+uml-fix-no_hz-busy-loop.patch
+leak-in-do_ubd_request.patch

 More 2.6.24 queue

+timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch
+timerfd-v3-new-timerfd-api.patch
+timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch
+timerfd-v3-un-break-config_timerfd.patch

 Probably 2.6.24?

+git-acpi-ia64-build-fix.patch

 Fix git-acpi

-acpi-enable-c3-power-state-on-dell-inspiron-8200-fix.patch

 Folded into acpi-enable-c3-power-state-on-dell-inspiron-8200.patch

-export-acpi_check_resource_conflict-update.patch

 Folded into export-acpi_check_resource_conflict.patch

+sound-core-memallocc-add-missing-pci_dev_put.patch

 ALSA fix

+drivers-char-remove-unnecessary-pci_dev_put.patch

 Fix agp driver

+kernel-auditc-warning-fix.patch
+kernel-compliment-va_copy-with-va_end.patch

 Audit fixes

+git-cpufreq-query_current_values_with_pending_wait-build-fix.patch

 Fix git-cpufreq

-agk-dm-dm-crypt-move-bio-submission-to-thread.patch

 Might have been dropped.

+dm-persistent_read_metadata-warning-fix.patch

 DM fix

+powerpc-add-support-for-porta-and-portb-odr-registers.patch
+powerpc-stop-the-toc-overflowing-for-large-builds.patch
+ppc-fix-missed-increment-on-device-interface-counter.patch
+ppc-chrp-fix-possible-null-pointer-dereference.patch
+ppc-chrp-fix-possible-null-pointer-dereference-checkpatch-fixes.patch

 powerpc things

+gregkh-driver-allow-legacy_ptys-to-be-set-to-0.patch
+gregkh-driver-create-sys-power-when-config_pm-is-set.patch
+gregkh-driver-uio-fix-up-the-uio-documentation.patch
+gregkh-driver-uio-add-uio-documentation-target-to-docbook-makefile.patch
+gregkh-driver-kobject-two-typo-fixes.patch
+gregkh-driver-sysfs-fix-off-by-one-error-in-fill_read_buffer.patch
+gregkh-driver-documentation-replace-obsolete-driverfs-with-sysfs.patch
+gregkh-driver-driver-core-make-the-dev_-family-of-macros-in-deviceh-complete.patch
+gregkh-driver-sysfs-create-optimal-relative-symlink-targets.patch
+gregkh-driver-sysfs-remove-spin_lock_unlocked.patch
+gregkh-driver-driver-core-clean-up-shutdownc.patch
+gregkh-driver-driver-core-clean-up-device_shutdown.patch
+gregkh-driver-driver-core-make-sys-power-a-kobject.patch
+gregkh-driver-kobject-remove-old-outdated-documentation.patch
+gregkh-driver-kobject-update-the-kobject-kset-documentation.patch
+gregkh-driver-kobject-add-sample-code-for-how-to-use-kobjects-in-a-simple-manner.patch
+gregkh-driver-kobject-add-sample-code-for-how-to-use-ksets-ktypes-kobjects.patch
+gregkh-driver-driver-core-fix-race-in-__device_release_driver.patch

 Driver tree updates

-unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc-fix.patch

 Folded into unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch

+git-drm-warning-fix.patch

 Fix git-drm.patch

+jdelvare-i2c-i2c-delete-old-documentation.patch
+jdelvare-i2c-i2c-gpio-set-hwmon-class.patch
+jdelvare-i2c-i2c-add-missing-space.patch
+jdelvare-i2c-i2c-algo-pcf-kill-10bit-support.patch
+jdelvare-i2c-i2c-constify-client-address-data.patch
+jdelvare-i2c-i2c-constify-normal_i2c-rtc.patch
+jdelvare-i2c-i2c-constify-normal_i2c-other.patch
+jdelvare-i2c-i2c-kill-rogue-driver-ids.patch
+jdelvare-i2c-i2c-adapters-dont-set-retries.patch

 I2C tree updates

+fix-jdelvare-i2c-i2c-constify-client-address-data.patch
+oz99x-i2c-button-and-led-support-driver.patch
+fjkeyinf-driver-for-fsc-lifebook-laptops.patch

 i2c stuff

+revert-git-hrt.patch

 Drop dud patch from git-hrt.patch

+clean-hungarian-notation-from-timers.patch
+timer-cleanups.patch
+more-timer-related-cleanups.patch

 time cleanups

-ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch

 Folded into ia64-slim-down-__clear_bit_unlock.patch

+ia64-signal-remove-redundant-code-in-setup_sigcontext.patch

 ia64 fix

-make-wistron-btns-recognize-special-keys-on-medion-wim2160-notebooks.patch

 Dropped

-fujitsu-application-panel-driver-space-savings.patch

 Folded into fujitsu-application-panel-driver.patch

-elantech-touchpad-driver-fix.patch

 Folded into elantech-touchpad-driver.patch

+sata_nv-dont-use-legacy-dma-in-adma-mode-v3.patch

 ata update

+ide-mm-alim15x3-add-mitac-8317-and-derivatives-to-ali_cable_override.patch
+ide-mm-ide-printk-fix.patch
+ide-mm-ide-dump-taskfile-hob-registers-in-ide_tf_load-if-debug-is-defined.patch
+ide-mm-ide-merge-fixup-and-quirkproc-methods.patch
+ide-mm-ide-dont-try-to-unregister-interfaces-if-initializing-in-ide_register_hw.patch
+ide-mm-ide-kill-probe_hwif_init.patch
+ide-mm-ide-fix-probing-for-hosts-with-serialized-or-irq-sharing-interfaces.patch
+ide-mm-rapide-set-hwif-chipset.patch
+ide-mm-swarm-set-hwif-chipset.patch
+ide-mm-ide-add-hwif-chipset-fixup-to-ide_device_add.patch
+ide-mm-ide-remove-ideprobe_init.patch
+ide-mm-sgiioc4-always-init-hwif-io_ports.patch
+ide-mm-ide-add-ide_init_port_hw-helper.patch
+ide-mm-ide-drop-initializing-argument-from-ide_register_hw.patch
+ide-mm-ide-move-ide_arm_init-call-from-init_ide_data-to-ide_init.patch
+ide-mm-cmd640-fix-dependency-on-ide_generic.patch
+ide-mm-ide-fix-host-drivers-depending-on-ide_generic-to-probe-for-interfaces.patch
+ide-mm-ide-make-remaining-built-in-only-ide-host-drivers-modular.patch

 IDE tree updates

-mmc-sd-write-operation-in-invalid-states-by-borken-cards.patch

 Dropped

+sdio_uart-fix-sign-of-paramter-status-in-sdio_uart_receive_chars.patch

 SDIO fix

-remove-fs-jffs2-ioctlc.patch

 Dropped

+fix-config_mtd_sharp_sl-if-config_mtd=m-try2.patch

 MTD fix

+net-irda-parametersc-trivial-fixes.patch
+net-fix-tx-bug-vlan-in-vlan.patch
+xfrm_policy-warning-fix.patch

 net things

+e100-free-irq-to-remove-warning-when-rebooting.patch

 netdev fix

+bluetooth-rfcomm-tty_close-before-destruct.patch

 bluetooth fix

+git-nfsd-fix-nfsd_idmap-stubs.patch

 Fix git-nfsd

+gregkh-pci-pci-pcie-portdriver-initialize-returned-value.patch
+gregkh-pci-pci-drivers-pci-pci-sysfsc-add-missing-pci_dev_put.patch
+gregkh-pci-pci-hotplug-switch-to-pci_get_bus_and_slot.patch
+gregkh-pci-pci-hotplug-remove-experimental.patch
+gregkh-pci-pci-hotplug-acpiphp-remove-unused-variable-from-acpiphp.patch
+gregkh-pci-pci-hotplug-pci_hotplug_core-whitespace-fix.patch
+gregkh-pci-pci-hotplug-link-fakephp-last.patch
+gregkh-pci-pci-quirk_vialatency-omit-reading-pci-revision-id.patch
+gregkh-pci-pci-via-cx700-quirk-to-disable-pci-bus-parking.patch
+gregkh-pci-pci-mem-policy-fix-mempolicy-usage-in-pci-driver.patch
+gregkh-pci-pci-get-rid-of-pci_dev-vendor-device-_compatible-fields.patch
+gregkh-pci-pci-remove-unneeded-lock_kernel-in-drivers-pci-syscallc.patch
+gregkh-pci-pci-always-export-pci_scan_single_device.patch
+gregkh-pci-pci-remove-additional-pci_scan_child_bus-prototype.patch
+gregkh-pci-pci-add-pci-quirk-function-for-some-chipsets.patch
+gregkh-pci-pci-drivers-pci-quirksc-coding-style-cleanup.patch
+gregkh-pci-pci-more-sanity-checks-for-dmar.patch
+gregkh-pci-pci-unhide-the-smbus-on-the-hp-xw4100.patch
+gregkh-pci-pci-hotplug-fix-rpaphp-directory-naming.patch
+gregkh-pci-pci-export-pci_restore_msi_state.patch
+gregkh-pci-pci-add-missing-space-in-printk-messages.patch

 PCI tree updates

+quirk-enable-msi-mapping-on-ht1000.patch

 MSI fix

+merge-multiple-error-paths-in-alloc_uid-into-one.patch

 UID allocation cleanup

+git-sh-fixup.patch

 Fix rejects in git-sh.patch

+git-scsi-misc-fixup.patch

 Fix rejects in git-scsi-misc.patch

-ips-trim-trailing-whitespace-checkpatch-fixes.patch

 Folded into ips-trim-trailing-whitespace.patch

-scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch

 Folded into scsi-gdth-kill-unneeded-irq-argument.patch

+add-accessors-for-segment_boundary_mask-in.patch
+pci-add-dma-segment-boundary-support.patch
+swiotlb-respect-the-segment-boundary-limits.patch
+call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch

 Fix iommu patches in -mm.

+libsas-convert-ata-bridge-to-use-new-eh.patch
+libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch

 SAS stuff

+gregkh-usb-usb-pl2303-add-support-for-corega-cg-usbrs232r.patch
+gregkh-usb-usb-fix-priority-mistakes-in-drivers-usb-core-hubc.patch
+gregkh-usb-usb-free-memory-when-writing-fails-in-usb-serial-mos7840c.patch
+gregkh-usb-usb-fix-usbled-disconnect-read-race-2.patch
+gregkh-usb-usbserial-fix-inconsistent-lock-state.patch
+gregkh-usb-usb-fix-signr-comment-in-usbdevice_fsh.patch
+gregkh-usb-usb-power-management-documenation-update.patch
+gregkh-usb-usb-fix-locks-and-urb-status-in-adutux.patch
+gregkh-usb-usb-add-support-for-an-older-firmware-revision-for-the-nikon-d200.patch
+gregkh-usb-usb-fix-directory-references-in-usb-readme.patch
+gregkh-usb-usb-remove-usb-hub-entry-from-maintainers.patch
+gregkh-usb-usb-mailing-lists-have-changed.patch
+gregkh-usb-usb-hcd-avoid-duplicate-local_irq_disable.patch
+gregkh-usb-usb-sierra-new-product-id.patch
+gregkh-usb-usb-keep-track-of-whether-interface-sysfs-files-exist.patch
+gregkh-usb-usb-uevent-environment-key-fix.patch
+gregkh-usb-usb-make-the-microtek-driver-and-hal-cooperate.patch
+gregkh-usb-usb-fix-up-ehci-startup-synchronization.patch
+gregkh-usb-usb-usb-storage-unusual_devs-entry-for-jetflash-ts1gjf2a.patch
+gregkh-usb-usb-s3c2410-gadget-header-move-fixups.patch
+gregkh-usb-usb-s3c2410-gadget-allow-sharing-of-vbus-irq.patch
+gregkh-usb-usb-s3c2410-gadget-ensure-vbus-pin-in-input-mode-during-read.patch
+gregkh-usb-usb-isd200-don-t-include-linux-ideh.patch
+gregkh-usb-usb-add-iuu_phoenix-driver.patch
+gregkh-usb-usb-sis-fb-driver-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch
+gregkh-usb-usb-sisusb-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch
+gregkh-usb-usb-s3c2410_udc-minor-irq-handler-cleanups.patch
+gregkh-usb-usb-usb-mon-mon_binc-cleanups.patch
+gregkh-usb-usb-device-dma-support-on-omap2.patch
+gregkh-usb-usb-ti-3410-5052-usb-serial-convert-td_open_close_lock-to-mutex.patch
+gregkh-usb-usb-m66592-udc-add-support-for-sh7722-usbf.patch
+gregkh-usb-usb-add-missing-space-to-printk-messages.patch
+gregkh-usb-usb-usb-storage-new-lockable-subclass-0x07.patch
+gregkh-usb-usb-add-printer-gadget-driver.patch
+gregkh-usb-usb-cypress_cy7c63-updated-contact-usage-information.patch
+gregkh-usb-usb-usb_serial_console-fix-command-line-parsing.patch
+gregkh-usb-usb-usb_serial-clean-tty-reference-in-the-last-close.patch
+gregkh-usb-usb-usb_serial_console-allocate-fake-tty-and-termios-before-calling-driver-open-method.patch
+gregkh-usb-usb-linux-usb-kbuild-needs-only-header-y-not-unifdef-y.patch
+gregkh-usb-usb-drop-unnecessary-continue-in-a-few-drivers.patch
+gregkh-usb-usb-make-ksuspend_usbd-thread-non-freezable.patch
+gregkh-usb-usb-don-t-change-hc-power-state-for-a-freeze.patch
+gregkh-usb-usb-gadget-code-switches-to-pr_err-and-friends.patch
+gregkh-usb-usb-prepare-serial-core-for-autosuspend.patch
+gregkh-usb-usb-cyberjack-remove-a-unnecessary-variable.patch
+gregkh-usb-usb-usb-peripheral-controller-driver-oops-avoidance.patch
+gregkh-usb-usb-force-handover-port-to-companion-when-hub_port_connect_change-fails.patch
+gregkh-usb-usb-dummy_hcd-don-t-register-drivers-on-the-platform-bus.patch

 USB tree updates

+belkin_sa-clean-up-for-new-style-termios-and-speed.patch
+keyspan_pda-clean-up-speed-handling.patch
+mct232-speed-new-termios-and-compliance-cleanups.patch
+mct232-speed-new-termios-and-compliance-cleanups-fix.patch
+ohci-hcdcohci_irq-locking-fix.patch

 USB things

+txx9-watchdog-driver.patch
+txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500.patch

 Watchdog updates

-jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch

 Dropped

-git-x86-fixup.patch

 Unneeded

+git-x86-build-fix.patch

 Fix git-x86

+x86_64-do-not-set-boot-cpu-in-cpu_online_map-at-x86_64_start_kernel.patch
+vmlinux_32ldss-remove-repeated-comment-from-the-x86-32-linker-script.patch
+x86_64-make-sparsemem-vmemmap-the-only-memory-model.patch
+x86_64-add-acpi-reboot-option.patch
+x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
+x86_64-efi-runtime-service-support-efi-runtime-services.patch
+x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
+x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch

 x86 things

-ia64-export-copy_page-to-modules-fix.patch

 Folded into ia64-export-copy_page-to-modules.patch

+scsi-early-detection-of-medium-not-present-updated.patch
+fix-proc-net-breakage.patch
+lguest-prevent-visws-or-voyager-randconfigs.patch
+x86-paravirt-revert-exports-to-restore-old-behaviour.patch

 More 2.6.24 queue

+vmalloc-add-const-to-void-parameters-fix.patch

 Fix vmalloc-add-const-to-void-parameters.patch

+mm-page-writeback-highmem_is_dirtyable-option.patch
+mm-page-writeback-highmem_is_dirtyable-option-fix.patch
+shmem-factor-out-sbi-free_inodes-manipulations.patch
+shmem-factor-out-sbi-free_inodes-manipulations-fix.patch

 MM updates

+fix-proc-dcache-deadlock-in-do_exit.patch

 Fix a bug which probably isn't there.

+add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message.patch
+add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
+add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
+capabilities-introduce-per-process-capability-bounding-set.patch

 Security things

+smack-using-capabilities-32-and-33.patch

 smack update

+alpha-kill-deprecated-virt_to_bus.patch
+alpha-doesnt-use-socketcall.patch

 alpha fixes

+dio-array_size-cleanup-update.patch
+dio-array_size-cleanup-update-checkpatch-fixes.patch

 Fix dio-array_size-cleanup.patch

+cris-avoid-using-arch-links-in-kconfig.patch

 cris fix

+uml-clean-up-task_size-usage.patch
+uml-cover-stubs-with-a-vma.patch

 UML updates

-fix-versus-precedence-in-various-places-checkpatch-fixes.patch

 Folded into fix-versus-precedence-in-various-places.patch

+proc-loadavg-reading-race.patch
+fs-use-hlist_unhashed.patch
+partitions-use-kasprintf.patch
+fs-use-list_for_each_entry_reverse-and-kill-sb_entry.patch
+#enable-dual-rng-on-via-c7.patch: preliminary
+radix_treeh-trivial-comment-correction.patch
+ncpfs-update-diagnostic-strings-to-match-routine-names.patch
+hfs-update-comment-to-reflect-actual-init-and-exit-routines.patch
+maintainers-order-auerswald-alphabetically.patch
+inotify-send-in_attrib-events-when-link-count-changes.patch
+via-rng-enable-secondary-noise-source-on-cpus-where-it-is-present.patch
+mm-prevent-dereferencing-non-allocated-per_cpu-variables.patch
+mm-prevent-dereferencing-non-allocated-per_cpu-variables-fix.patch

 Misc

+atmel_spi-fix-dmachain-oops-with-debug-enabled.patch

 Atmel SPI driver fix

+arm-pxa-gpiolib-support.patch
+arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch

 GPIO core work

-unprivileged-mounts-add-user-mounts-to-the-kernel.patch
-unprivileged-mounts-allow-unprivileged-umount.patch
-unprivileged-mounts-account-user-mounts.patch
-unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
-unprivileged-mounts-allow-unprivileged-bind-mounts.patch
-unprivileged-mounts-allow-unprivileged-mounts.patch
-unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
-unprivileged-mounts-propagation-inherit-owner-from-parent.patch
-unprivileged-mounts-add-no-submounts-flag.patch

 Dropped

+drivers-video-remove-unnecessary-pci_dev_put.patch

 fbdev fix

+ext4-fix-up-ext4fs_debug-builds.patch
+ext4-fix-up-ext4fs_debug-builds-checkpatch-fixes.patch

 ext4 tree updates

+reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch

 reiserfs cleanup

+r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch

 Fix r/o bind-mounts patches in -mm

-revoke-special-mmap-handling.patch
-revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
-revoke-core-code.patch
-slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
-revoke-support-for-ext2-and-ext3.patch
-revoke-add-documentation.patch
-revoke-wire-up-i386-system-calls.patch
-fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
-fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
-revoke-vs-git-block.patch

 Dropped

+memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page-warning-fix.patch

 Fix memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch

+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch

 cgroup memeory controller updates

+vmcoreinfo-rename-vmcoreinfos-macros-returning-the-size.patch
+vmcoreinfo-use-the-existing-offsetof-for-vmcoreinfo_offset.patch
+vmcoreinfo-add-vmcoreinfo_-to-all-the-call-for-vmcoreinfo_append_str.patch
+vmcoreinfo-fix-the-configuration-dependencies.patch
+vmcoreinfo-fix-the-configuration-dependencies-fix.patch
+vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch

 kdump stuff

-add-cmpxchg_local-to-sh64.patch

 Dropped - the sh devel tree does a lot of consolidation between the 32-bit
 and 64-bit versions.

+mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch

 Serial driver cleanup

+proc-fix-the-threaded-proc-self.patch

 procfs work

+intel-iommu-pmen-support-fix.patch

 Fix intel-iommu-pmen-support.patch

+modules-handle-symbols-that-have-a-zero-value.patch
+modules-include-sectionsh-to-avoid-defining-linker-variables.patch
+modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
+kernel-modulec-make_driver_name-can-use-kasrpintf.patch

 module loader work

+ipc-uninline-some-code-from-utilh.patch
+ipc-semaphores-consolidate-sem_stat-and.patch
+ipc-make-struct-ipc_ids-static-in-ipc_namespace.patch
+ipc-consolidate-sem_exit_ns-msg_exit_ns-and-shm_exit_ns.patch

 IPC cleanups

+kill-pt_attached.patch
+kill-my_ptrace_child.patch
+ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
+ptrace_stop-fix-the-race-with-ptrace-detachattach.patch
+wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
+do_wait-factor-out-retval-=-0-checks.patch
+ptrace_stop-fix-racy-nonstop_code-setting.patch
+wait_task_stopped-remove-unneeded-delay_group_leader-check.patch
+do_wait-cleanup-delay_group_leader-usage.patch
+do_wait-fix-security-checks.patch
+do_wait-fix-security-checks-fix.patch
+wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch
+wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch
+sys_setpgid-simplify-pid-ns-interaction.patch

 core kernel work - mainly cleanups

+reiser4-make-methods-supplied-to-vfs-invariant.patch
+reiser4-new-export-ops.patch

 reiser4 updates

+undeprecate-pci_find_device.patch

 Remove some warnings which nobody is fixing.




3329 commits in 1415 patch files


All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm2/patch-list


