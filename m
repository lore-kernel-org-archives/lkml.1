Return-Path: <linux-kernel-owner+w=401wt.eu-S938091AbXHIIve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938091AbXHIIve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 04:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759332AbXHIIvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 04:51:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34774 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757569AbXHIIvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 04:51:17 -0400
Date: Thu, 9 Aug 2007 01:51:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc2-mm1
Message-Id: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm1/

- Added new NFSD development tree as git-nfsd ("J.  Bruce Fields"
  <bfields@fieldses.org>)

- There is a new e1000 driver in git-netdev-all, called e1000e.  I'm sure
  the developers would like it tested.  Please cc netdev@vger.kernel.org on
  any reports.

- I dropped the SSB patches due to various catastrophes and they are being
  redone.  But git-wireless.patch had some dependencies upon SSB which were
  plugged with some nasty bandaids.  So there are some kconfig warnings whcih
  come out of there.  Don't worry about it for now.

- If there's a patch in here which you think should be in 2.6.23 but I do
  not have it designated in that way, please be sure to let me know.

- Apparently the importing of -mm into git (as described in the boilerplate
  below) is not presently working.



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



Changes since 2.6.23-rc2-mm1:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-audit-master.patch
 git-cifs.patch
 git-cpufreq.patch
 git-dma.patch
 git-drm.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-jg-misc.patch
 git-kvm.patch
 git-libata-all.patch
 git-m32r.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-netdev-all.patch
 git-ixgbe.patch
 git-net.patch
 git-nfs.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-r8169.patch
 git-s390.patch
 git-sched.patch
 git-sh.patch
 git-scsi-misc.patch
 git-sparc64.patch
 git-unionfs.patch
 git-v9fs.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-kgdb.patch
 git-block-vs-reiser4.patch

 git trees

-genirq-temporary-fix-for-level-triggered-irq-resend.patch
-git-acpi-mark_tsc_unstable-build-fix.patch
-drivers-acpi-sbsc-remove-dead-code.patch
-acpi-cure-run-together-printk-lines.patch
-make-struct-sony_nc_ids-static.patch
-kernel-auditscc-fix-an-off-by-one.patch
-powerpc-fix-num_cpus-calculation-in-smp_call_function_map.patch
-gregkh-driver-sysfs-remove-first-pass-at-shadow-directory-support.patch
-gregkh-driver-sysfs-implement-sysfs-manged-shadow-directory-support.patch
-gregkh-driver-sysfs-implement-sysfs_delete_link-and-sysfs_rename_link.patch
-gregkh-driver-driver-core-implement-shadow-directory-support-for-device-classes.patch
-drivers-media-video-msp3400-driverc-kmalloc-memset-conversion-to-kzalloc.patch
-sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
-libata-sff-unbreak-non-dma-capable-controllers-again.patch
-pata_cmd64x-correct-the-speed-ranges.patch
-pata_sis-fix-mwdma-for-=-udma66-chipsets-and-udma-for-udma33-chipsets.patch
-ide-cs5535-fix-array-overrun.patch
-ide-alim15x3-correct-hp-detect.patch
-ide-sis5513-add-fsc-amilo-a1630-pci-subvendor_dev-to-laptops.patch
-ide-cs5520-fix-pio-auto-tuning-in-ide-dma-check-method.patch
-ide-cs5535-pio-fixes.patch
-ide-it8213-pio-fixes-take2.patch
-ide-jmicron-pio-fixes.patch
-ide-piix-slc90e66-fix-pio1-handling-in-speedproc-method-take2.patch
-ide-scc_pata-pio-fixes.patch
-ide-ide-add-cable-detection-for-early-udma66-devices.patch
-ide-ide-pmac-use-ide-tune-dma.patch
-fix-ide-ide-add-ide-set-pio-take3.patch
-fix-runtogether-printks-in-cmd64x-ide-driver.patch
-eliminate-warnings-in-ide-tapec.patch
-drivers-ide-arm-icsidec-kmalloc-memset-conversion-to-kzalloc.patch
-mips-remove-some-duplicate-includes.patch
-mtd-remove-redundant-dead-code-from-physmap_ofc.patch
-mtd-onenand_simc-make-struct-info-static.patch
-drivers-mtd-inftlmountc-kmalloc-memset-conversion-to-kcalloc.patch
-drivers-pci-hotplug-cpqphp_ctrlc-kmalloc-memset-conversion-to-kzalloc.patch
-tiny-sched_getaffinity-cleanup.patch
-scsi-fix-build-for-config_scsi_tgt=n-2.patch
-aha152x-in-debug-mode.patch
-make-scsi_host_link_pm_policy-static.patch
-drivers-scsi-ide-scsic-kmalloc-memset-conversion-to-kzalloc.patch
-gregkh-usb-usb-nikon-d50-is-an-unusual-device.patch
-gregkh-usb-usb-clean-up-duplicate-includes-in-drivers-usb.patch
-gregkh-usb-usblp-implement-the-enospc-convention.patch
-gregkh-usb-usblp-make-use-of-urb_free_buffer.patch
-fix-gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-hosts.patch
-git-kgdb-arm-fix.patch
-git-kgdb-mips-fix.patch
-fix-kgdb-kernel-doc.patch
-serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
-nfs-fix-put_nfs_open_context.patch
-acpi_ec_remove-fix-use-after-free.patch
-acpi_battery_add-use-after-free.patch
-mm-migratec-cleanups.patch
-locks-kill-redundant-local-variable.patch
-cfs-mark-print_cfs_stats-static.patch
-stifb-detect-cards-in-double-buffer-mode-more-reliably.patch

 Merged into mainline or a subsystem tree

+stifb-detect-cards-in-double-buffer-mode-more-reliably.patch
+fbcon-kill-compile-warning.patch
+fbcon-kill-compile-warning-fix.patch
+pvr2fb-fix-oops-when-pseudo_palette-is-written.patch
+pvr2fb-consolidated-cleanup-of-pvr2fbc.patch
+pvr2fb-update-documentation-fb-pvr2fbtxt.patch
+matroxfb-rectify-jitter-g450-g550.patch
+frv-connect-up-fallocate.patch
+ecryptfs-fix-lookup-error-for-special-files.patch
+fix-missing-numa_zonelist_order-sysctl.patch
+remove-unused-struct-proc_dir_entryset.patch
+linux-audit-list-is-subscribers-only.patch
+ecryptfs-fix-error-handling-in-ecryptfs_init.patch
+hibernation-do-not-try-to-mark-invalid-pfns-as-nosave.patch
+drivers-char-pcmcia-cm40x0_csc-fix-release-function-call.patch
+memory-hotplug-document-take-3.patch
+kernel-parameterstxt-watchdogtxt-should-be-wdttxt.patch
+spi_mpc83xx-in-qe-mode-use-sysclk-2.patch
+spi_mpc83xx-fix-prescale-modulus-calculation.patch
+update-checkpatchpl-to-version-009.patch
+allow-rcutorture-to-handle-synchronize_sched.patch
+documentation-sysrq-description-of-h-slightly-inaccurate.patch
+docs-note-about-select-in-kconfig-languagetxt.patch
+alpha-o_cloexec-definition.patch
+fix-serial-buffer-memory-leak.patch
+fix-serial-buffer-memory-leak-fix.patch
+mtdchar-build-fix.patch

 2.6.23 queue

+finish-i386-and-x86-64-sysdata-conversion.patch
+remove-bdput-from-do_open-in-fs-block_devc.patch
+remove-bdput-from-do_open-in-fs-block_devc-fix.patch
+apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable.patch

 Probably for 2.6.23.

+slow-down-printk-during-boot-fix-4.patch

 Keep fixing slow-down-printk-during-boot.patch

+emu10k1-remove-redundant-memset.patch
+sound-pci-ioremap-iounmap-balancing.patch

 ALSA fixes

+at91-remove-at91_lcdch.patch

 arm fix

+allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch

 cpufreq changes

+gregkh-driver-sysfs-fix-locking-in-sysfs_lookup-and-sysfs_rename_dir.patch
+gregkh-driver-fix-off-by-one-in-sys-module-refcnt.patch
+gregkh-driver-howto-korean-translation-of-documentation-howto.patch
+gregkh-driver-howto-latest-lxr-url-address-changed.patch
+gregkh-driver-driver-core-make-sysfs-uevent-attributes-static.patch
+gregkh-driver-debugfs-helper-for-decimal-challenged.patch
+gregkh-driver-sysfs-remove-first-pass-at-shadow-directory-support.patch
+gregkh-driver-sysfs-cosmetic-changes-in-sysfs_lookup.patch
+gregkh-driver-sysfs-simplify-sysfs_rename_dir.patch
+gregkh-driver-sysfs-make-sysfs_add-remove_one-call-link-unlink_sibling-implictly.patch
+gregkh-driver-sysfs-make-sysfs_add_one-automatically-check-for-duplicate-entry.patch
+gregkh-driver-sysfs-make-sysfs_addrm_finish-return-void.patch

 driver tree updates

+mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch

 DRM fix

+git-dvb-fixup-2.patch

 Fix git-dvb

+ds1682-add-sesnsors-kconfig-variable-prefix.patch

 i2c fix

+sn-add-support-for-cpu-disable.patch

 ia64 fix

+clean-modulessymvers-in-external-module-dirs.patch
+scripts-ver_linux-correct-printing-of-binutils-version.patch
+improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch

 kbuild things

-libata-check-for-an-support.patch
-scsi-expose-an-to-user-space.patch
-libata-expose-an-to-user-space.patch
-scsi-save-disk-in-scsi_device.patch
-libata-send-event-when-an-received.patch
+libata-check-for-an-support.patch
+scsi-expose-an-support-to-user-space.patch
+libata-expose-an-to-user-space.patch
+libata-send-event-when-an-received.patch

 Updated atapi async notification patchset

-ata-ahci-alpm-store-interrupt-value.patch
-ata-ahci-alpm-expose-power-management-policy-option-to-users.patch
-ata-ahci-alpm-enable-link-power-management-for-ata-drivers.patch
-ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix.patch
-ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
+alpm-store-interrupt-value.patch
+alpm-enable-link-power-management-for-ata-drivers.patch
+alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch

 Updated ATA Aggressive Link Power Management patches

+libata-add-human-readable-error-value-decoding-v3.patch

 ata featurette

+ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
+ide-ide-add-cable-detection-for-early-udma66-devices-take-3.patch
+ide-ide-pmac-use-ide-tune-dma-take-2.patch
+ide-ide-pmac-fix-pio-setup-and-enable-autotune.patch
+ide-icside-use-ide-tune-dma.patch
+ide-au1xxx-fix-au1xxx-fix-set-pio-mode.patch
+ide-amd74xx-via82cxxx-check-ide-config-drive-speed-return-value.patch
+ide-cs5535-check-ide-config-drive-speed-return-value.patch
+ide-pdc202xx_new-check-ide-config-drive-speed-return-value.patch
+ide-ide-move-ide-config-drive-speed-to-upper-layers-take-2.patch
+ide-ide-change-master-slave-identify-order.patch
+ide-ide-remove-config-idedma-ivb.patch
+ide-cs5530-add-missing-dma-base-check.patch
+ide-cs5535-add-missing-dma-base-check.patch
+ide-pdc202xx_new-add-missing-dma-base-check.patch
+ide-pdc202xx_old-add-missing-dma-base-check.patch
+ide-sgiioc4-add-missing-dma-base-check.patch
+ide-triflex-add-missing-dma-base-check.patch
+ide-cs5520-fix-dma-base-equal-zero-handling.patch
+ide-sc1200-fix-dma-base-equal-zero-handling.patch
+ide-alim15x3-remove-redundant-m5229_revision-check.patch
+ide-hpt366-always-tune-pio.patch
+ide-ide-st340823a-hpa-workaround-take-3.patch
+ide-sis5513-dma-setup-fixes.patch
+ide-sis5513-always-tune-pio.patch
+ide-aec62xx-always-tune-pio.patch
+ide-slc90e66-always-tune-pio.patch
+ide-ide-cris-always-tune-pio.patch
+ide-cs5530-always-tune-pio.patch
+ide-sc1200-always-tune-pio.patch

 IDE tree updates

+ide-arm-hack.patch

 Make it compile

+mmc-make-it-build.patch

 Hack git-mmc to make it compile

+mmc-fix-section-mismatch-warnings-for-drivers-mmc-host.patch

 MMC fix

+e1000e-build-fix.patch

 Fix the new e1000 driver in git-netdev-all.

+natsemi-fix-netdev-error-acounting.patch
+uli526x-add-suspend-and-resume-routines.patch

 netdev fixes

+fix-several-memory-leaks-in-cr_backlight_probe-take2.patch

 backlight fix

+64-bit-ino-support-for-nfs-client.patch

 nfs feature work

+git-nfsd-build-fixes.patch
+nfsd-warning-fix.patch

 Fix git-nfsd.patch

+pxa2xx-pcmcia-timing-issue-on-ipaq-h5550.patch

 pcmcia fix

+gregkh-pci-pci-lets-kill-the-pci-hidden-behind-bridge-message.patch
+gregkh-pci-pci-hotplug-cpqphp_ctrlc-kmalloc-memset-conversion-to-kzalloc.patch
+gregkh-pci-pci-unhide-smbus-on-compaq-deskpro-ep-401963-001-motherboard-with-i810-chipset.patch

 PCI tree updates

+mpt-fusion-fix-two-potential-mem-leaks.patch
+fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch

 SCSI fixes

+sysace-hdio_getgeo-has-its-own-method-for-ages.patch

 block driver cleanup

-git-unionfs-fixup.patch

 Unneeded

+git-unionfs-fix-2.patch

 Fix git-unionfs

+gregkh-usb-usb-px2xx_udc-bugfix-missing-check-for-gpio_pullup.patch
+gregkh-usb-usb-fix-bug-with-ehci-cpufreq-patch-on-nvidia-controllers.patch
+gregkh-usb-usb-cdc-acm-fix-sysfs-attribute-registration-bug.patch
+gregkh-usb-usb-visor-add-acer-s10-palm-device-id.patch
+gregkh-usb-usb-serial-garmin_gps-fixes-package-loss-if-used-from-gpsbabel.patch
+gregkh-usb-usb-stall-control-endpoint-when-file-storage-class-request-wvalue-0.patch
+gregkh-usb-usb-typo-usb_safe_padded-usb_serial_safe_padded.patch
+gregkh-usb-usb-u132-hcdc-fix-a-warning-when-config_pm-n.patch
+gregkh-usb-usb-clean-up-duplicate-includes-in-drivers-usb.patch
+gregkh-usb-usblp-implement-the-enospc-convention.patch
+gregkh-usb-usblp-make-use-of-urb_free_buffer.patch
+gregkh-usb-usb-ohci-handles-more-zfmicro-quirks.patch
+gregkh-usb-usb-remove-dead-references-to-safe_serial-config-variables.patch
+gregkh-usb-usb-usb_gadgeth-whitespace-fixes.patch
+gregkh-usb-usb-storage-usbat_check_status-fix-check-after-use.patch
+gregkh-usb-usb-add-urb-ep.patch
+gregkh-usb-usb-add-ep-enable.patch
+gregkh-usb-usb-add-direction-bit-to-urb-transfer_flags.patch
+gregkh-usb-usb-avoid-using-urb-pipe-in-usbcore.patch
+gregkh-usb-usb-address-0-handling-during-device-initialization.patch
+gregkh-usb-usb-avoid-urb-pipe-in-usbfs.patch
+gregkh-usb-usb-avoid-urb-pipe-in-usbmon.patch
+gregkh-usb-usb-cleanup-for-previous-patches.patch
+gregkh-usb-usb-update-spinlock-usage-for-root-hub-urbs.patch
+gregkh-usb-usb-separate-out-endpoint-queue-management-and-dma-mapping-routines.patch
+gregkh-usb-usb-add-drivers-usb-misc-iowarriorc-to-the-makefile.patch
+gregkh-usb-usb-gadget-gadget_is_-dualspeed-otg-predicates-and-cleanup.patch
+gregkh-usb-usb-gadget-ethernet-gadget-cleanups-shrinkage.patch
+gregkh-usb-usb-gadget-gmidi-cleanups.patch
+gregkh-usb-usb-gadget-serial-gadget-cleanups.patch
+gregkh-usb-usb-gadget-file-storage-gadget-cleanups.patch
+gregkh-usb-usb-gadget-gadget-zero-cleanups.patch
+gregkh-usb-usb-usb_get_configuration-obeys-authorization.patch
+gregkh-usb-usb-usb_probe_interface-obeys-authorization.patch
+gregkh-usb-usb-usb_generic_probe-obeys-authorization.patch
+gregkh-usb-usb-split-usb_new_device-for-clarity-and-refactoring.patch
+gregkh-usb-usb-introduce-usb_authorize-deauthorize.patch
+gregkh-usb-usb-hook-up-device-authorization-to-sysfs.patch
+gregkh-usb-usb-document-device-authorization.patch
+gregkh-usb-usb-choose_configuration.patch
+gregkh-usb-usb-usb_release_interface-static.patch

 USB tree updates

+usb-enable-hcd-support-on-sh-unconditionally.patch
+usb-r8a66597-hcd-clean-up-error-path.patch

 USB updates

-merge-the-sonics-silicon-backplane-subsystem.patch
-merge-the-sonics-silicon-backplane-subsystem-fix.patch
-avoid-ssb-compililation-on-s390.patch
-b44-ssb-fix-irq-routing-bits-on-the-backplane.patch
-merge-the-sonics-silicon-backplane-subsystem-update.patch
-ssb-compile-fix.patch
-watchdog-support-3.patch
-ssb-add-a-driver-for-the-broadcom-ohci-core.patch
-use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch

 I dropped the SSB code

+disable-b44-and-bcm43xx.patch

 Help git-wireless to compile without the SSB code there

-x86_64-get-mp_bus_to_node-as-early-v2.patch
-x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
-try-parent-numa_node-at-first-before-using-default-v2.patch
-net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
-dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
+x86_64-get-mp_bus_to_node-as-early-v3.patch
+x86_64-get-mp_bus_to_node-as-early-v3-fix.patch
+x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
+try-parent-numa_node-at-first-before-using-default.patch
+net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
+dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch

 These were updated

+optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
+i386-convert-mm_context_t-semaphore-to-a-mutex.patch
+x86_64-remove-sync_arb_ids.patch
+x86_64-clear-io_apic-before-enabing-apic-error-vector.patch

 x86 updates

-git-newsetup-fixup.patch

 Unneeded

+fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount.patch

 XFS fix

+kernel-auditscc-fix-an-off-by-one.patch
+document-linux-memory-policy-v3.patch
+futex_unlock_pi-hurts-my-brain-and-may-cause.patch
+block-hide-the-contents-of-linux-bioh-if-config_block=n.patch
+rtc-periodic-irq-fix.patch
+calgary-fix-mis-handled-pci-topology.patch
+fix-some-x86-x86-64-acpi-cpufreq-driver-issues.patch
+dvb-remove-bogus-bug_on-in-videobuf_dvb_thread.patch
+pci-align-bar-settings-for-legacy-mode-ide.patch
+pci-align-bar-settings-for-legacy-mode-ide-fix.patch

 2.6.23 material, but these belong to subssytem trees

+generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
+generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
+generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
+x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
+ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch

 tweak the virtual-memmap patches in -mm.

+slub-direct-pass-through-of-page-size-or-higher-kmalloc.patch
+#hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch: David Gibson had issues wrt reservation
+hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch
+remove-zero_page.patch
+mm-use-lockless-radix-tree-probe.patch
+mm-improve-find_lock_page.patch
+mm-clarify-__add_to_swap_cache-locking.patch
+radix-tree-use-indirect-bit.patch
+ensure-we-count-pages-transitioning-inactive-via-clear_active_flags.patch
+wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch
+wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix.patch

 MM updates

-fs-remove-some-aop_truncated_page-fix.patch

 Folded into fs-remove-some-aop_truncated_page.patch

+memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
+memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
+memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
+memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
+memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
+memoryless-nodes-no-need-for-kswapd.patch
+memoryless-nodes-slab-support.patch
+memoryless-nodes-slub-support.patch
+memoryless-nodes-uncached-allocator-updates.patch
+memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
+memoryless-nodes-update-memory-policy-and-page-migration.patch
+memoryless-nodes-add-n_cpu-node-state.patch
+memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
+memoryless-nodes-fix-gfp_thisnode-behavior.patch
+memoryless-nodes-use-n_high_memory-for-cpusets.patch

 Fix support for NUMA nodes which have no memory.

+categorize-gfp-flags.patch
+categorize-gfp-flags-fix.patch

 MM cleanup

+make-swappiness-safer-to-use.patch

 Make /proc/sys/vm/swappiness safer

+maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch
+maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch
+maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace.patch

 Fix the fancy memory-reporting patches in -mm.

+ifdef-struct-task_structsecurity.patch

 Save some space

+pm_trace-displays-the-wrong-time-from-the-rtc.patch
+freezer-be-more-verbose.patch
+freezer-use-wait-queue-instead-of-busy-looping.patch
+freezer-measure-freezing-time.patch

 PM updates

+uml-fix-console-writing-bugs.patch
+uml-console-tidying.patch
+uml-stop-using-libc-asm-pageh.patch
+uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
+uml-fix-nonremovability-of-watchdog.patch
+uml-stop-specially-protecting-kernel-stacks.patch
+uml-stop-saving-process-fp-state.patch
+uml-physmem-code-tidying.patch

 UML updates

+printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch

 Fix printk-add-interfaces-for-external-access-to-the-log-buffer.patch

+add-all-thread-stats-for-taskstats_cmd_attr_tgid.patch
+pi-futex-set-pf_exiting-without-taking-pi_lock.patch
+do_sigaction-remove-now-unneeded-recalc_sigpending.patch
+deprecate-aout-elf-interpreters.patch
+deprecate-aout-elf-interpreters-fix.patch
+handle-the-multi-threaded-inits-exit-properly.patch
+tweak-proc-ipmi-removal.patch
+ufs-move-non-layout-parts-of-ufs_fsh-to-fs-ufs.patch
+#msleep-with-hrtimers.patch: overflow bug
+#msleep-with-hrtimers.patch
+add-linux-elfcore-compath.patch
+x86_64-use-linux-elfcore-compath.patch
+powerpc-use-linux-elfcore-compath.patch
+avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
+wait_task_zombie-remove-unneeded-child-signal-check.patch
+wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
+exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting.patch
+zap_other_threads-dont-optimize-thread_group_empty-case.patch
+do-not-export-usr-include-scsi-in-make-headers_install.patch
+add-mmf_dump_elf_headers.patch
+ext2-ext3-ext4-add-block-bitmap-validation.patch
+ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
+i386-pci_get_device-called-from-interrupt-in-reboot-fixups.patch

 misc.

+nfs-remove-congestion_end.patch
+lib-percpu_counter_add.patch
+lib-percpu_counter-variable-batch.patch
+lib-make-percpu_counter_add-take-s64.patch
+lib-percpu_counter_set.patch
+lib-percpu_counter_sum_positive.patch
+lib-percpu_count_sum.patch
+lib-percpu_counter_init-error-handling.patch
+lib-percpu_counter_init_irq.patch
+mm-bdi-init-hooks.patch
+mm-bdi-init-hooks-fix.patch
+mtd-bdi-init-hooks.patch
+mtd-clean-up-the-backing_dev_info-usage.patch
+mtd-give-mtdconcat-devices-their-own-backing_dev_info.patch
+mm-scalable-bdi-statistics-counters.patch
+mm-count-reclaimable-pages-per-bdi.patch
+mm-count-writeback-pages-per-bdi.patch
+mm-expose-bdi-statistics-in-sysfs.patch
+lib-floating-proportions.patch
+lib-floating-proportions-_single.patch
+mm-per-device-dirty-threshold.patch
+mm-dirty-balancing-for-tasks.patch
+debug-sysfs-files-for-the-current-ratio-size-total.patch

 Attempt to fix cross-device contention in the dirty-memory limiting code.

+fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
+isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch

 ISDN fixes

+fbdev-fix-incorrect-timings-in-some-modedb-entries.patch
+tdfxfb-code-improvements.patch
+tdfxfb-hardware-cursor.patch
+tdfxfb-mtrr-support.patch
+tdfxfb-mtrr-support-fix.patch
+pm2fb-checkpatch-fixes.patch
+pm3fb-checkpatch-fixes.patch
+drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch

 fbdev updates

+cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch

 Fix the CPU hotplug patches in -mm.

+intel-iommu-optimize-sg-map-unmap-calls.patch

 Fix the iommu patches in -mm.

+fuse-update-backing_dev_info-congestion-state.patch
+fuse-fix-reserved-request-wake-up.patch
+fuse-add-reference-counting-to-fuse_file.patch
+fuse-truncate-on-spontaneous-size-change.patch
+fuse-fix-page-invalidation.patch
+fuse-set-i_nlink-to-sane-value-after-mount.patch
+fuse-refresh-stale-attributes-in-fuse_permission.patch
+fuse-fix-permission-checking-on-sticky-directories.patch
+fuse-fix-permission-checking-on-sticky-directories-fix.patch
+fuse-cleanup-in-release.patch
+fuse-no-abort-on-interrupt.patch
+fuse-no-enoent-from-fuse-device-read.patch

 FUSE updates

+documentation-make-headers_installtxt.patch

 Documentation update

+task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch

 Fx the containers patches in -mm.



All 1162 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm1/patch-list


