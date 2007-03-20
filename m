Return-Path: <linux-kernel-owner+w=401wt.eu-S933994AbXCTE4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994AbXCTE4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 00:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933997AbXCTE4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 00:56:30 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46321 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933994AbXCTE42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 00:56:28 -0400
Date: Mon, 19 Mar 2007 20:56:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc4-mm1
Message-Id: <20070319205623.299d0378.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Temporarily at

  http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/

Will appear later at

  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/



- Restored the RSDL CPU scheduler (a new version thereof)



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


Changes since 2.6.21-rc3-mm1:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-arm-master.patch
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
 git-kbuild.patch
 git-kvm.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-netdev-all.patch
 git-ioat.patch
 git-ocfs2.patch
 git-parisc.patch
 git-selinux.patch
 git-pciseg.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-scsi-rc-fixes.patch
 git-unionfs.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-gccbug.patch

 git trees

-uml-hostfs-fix-double-free.patch
-uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
-uml-fix-a-memory-leak-in-the-multicast-driver.patch
-uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
-uml-mark-both-consoles-as-con_anytime.patch
-uml-fix-confusion-irq-early-reenabling.patch
-uml-activate_fd-return-enomem-only-when-appropriate.patch
-uml-fix-errno-usage.patch
-x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted.patch
-bluetooth-fix-socket-locking-in-hci_sock_dev_event.patch
-add-epoll-compat_-code-to-fs-compatc.patch
-check_partition-fix-error-check.patch
-uml-arch_prctl-should-set-thread-fs.patch
-connector-bugfix-for-cn_call_callback.patch
-26-altix-console-fix-for-config_debug_shirq-usage.patch
-ecryptfs-nested-locking-annotation.patch
-swsusp-disable-nonboot-cpus-before-entering-platform-suspend.patch
-paravirt-build-fixes.patch
-acpi-disabled-due-to-dmi-failure-or-blacklisted-year-should-be-noted-as-is-done-with-other-acpi-blacklisting.patch
-git-alsa-oops-fix.patch
-avr32-dma-mappingh.patch
-gregkh-driver-device-symlink.patch
-gregkh-driver-platform-reorder-platform_device_del.patch
-gregkh-driver-remove-devfs-from-maintainers.patch
-gregkh-driver-driver-core-export-device_rename.patch
-gregkh-driver-uio-irq.patch
-scheduled-removal-of-sa_xxx-interrupt-flags-fixups-4.patch
-make-drivers-char-drm-drm_vmcdrm_io_prot-static.patch
-fix-saa7146_clipping_mem-size.patch
-drivers-media-video-cpia_ppc-dont-use-_work_nar.patch
-dvb-core-fix-several-locking-related-problems.patch
-saa7134-fix-modules=n-compilation.patch
-ivtv-warning-fix.patch
-jdelvare-i2c-i2c-03-use-i2c_adapterdevparent-for-messages.patch
-jdelvare-i2c-i2c-i801-restore-initial-state.patch
-jdelvare-i2c-ds1374-check-for-workqueue-creation.patch
-crash-on-evdev-disconnect.patch
-expose-set_mode-method-so-it-can-be-wrapped.patch
-ata_piix-remove-ugly-layering-violation.patch
-pata_cmd640-multiple-updates.patch
-ide-cmd64x-fix-recovery-time-calculation-take2.patch
-mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch
-mtd-chips-oops-in-cfi_amdstd_sync.patch
-mtd-esb2-check-for-closed-rom-window.patch
-dilnetpc-fix-warning.patch
-mtd-correct-misspelled-preprocessor-variable.patch
-git-netdev-all-ipw2200-fix.patch
-mv643xx-ethernet-driver-irq-registration-fix.patch
-via-rhine-set-avoid_d3-for-broken-bioses.patch
-netxen-fix-warnings.patch
-e1000-fix-be-ready-for-incoming-irq-at-pci_request_irq.patch
-e1000-fix-firmware-handover-bits.patch
-e1000-fix-stop-raw-interrupts-disabled-nag-from-rt.patch
-tulip-fix-shutdown-dma-irq-race.patch
-tulip-fix-for-64-bit-mips.patch
-tulip-natsemi-dp83840a-phy-fix.patch
-nfs-fix-congestion-control-v4.patch
-nfs-nfs_getattr-cant-call-nfs_sync_mapping_range-for-non-regular-files.patch
-gregkh-pci-pci-allow-multiple-calls-to-pcim_pin_device.patch
-gregkh-pci-pcie-fix-section-mismatch-warning.patch
-gregkh-pci-pci-aer-fix-section-mismatch-warning.patch
-gregkh-pci-pci-fix-section-mismatch-warning.patch
-scatterlisth-needs-typesh.patch
-cleanup-the-includes-of-linux-pcih.patch
-gregkh-usb-usb-at91_udc-fix-more-modpost-bogosity.patch
-gregkh-usb-usb-storage-removed-duplicate-supertop-unusual_dev-entry.patch
-gregkh-usb-usb-storage-nokia-6288-unusual_devs-entry.patch
-gregkh-usb-usb-goku_udc-remove-crude-cache-coherency-code.patch
-gregkh-usb-usb-set-the-correct-interval-for-interrupt-urbs.patch
-gregkh-usb-uhci-fix-port-resume-problem.patch
-gregkh-usb-usb-ratelimit-debounce-error-messages.patch
-gregkh-usb-usb-kill-dead-code-from-hubc.patch
-gregkh-usb-usb-new-device-ids-for-cp2101-driver.patch
-gregkh-usb-usb-add-ql355p-power-supply-ids-to-fdti_sio.patch
-gregkh-usb-usb-add-additional-pids-in-ftdi_sio.patch
-gregkh-usb-usb-serial-fix-shutdown-device_unregister-order.patch
-gregkh-usb-usb-ftdi_sio-use-port_probe-port_remove-thereby-fixing-access-to-the-latency_timer.patch
-gregkh-usb-usb-rts-dtr-signal-patch-for-airprime-driver.patch
-gregkh-usb-usb-fix-usb-serial-device-naming-bug.patch
-gregkh-usb-usb-further-fix-for-usb-serial.patch
-gregkh-usb-usb-ipaqc-additional-devices.patch
-gregkh-usb-usbnet-dm9501-add-corega-fether-usb-txc-support.patch
-usbatm-create-sysfs-link-device-from-atm-class-device.patch
-usb-elan-ftdi-check-for-workqueue-creation-v2.patch
-cxacru-export-detailed-device-info-through-sysfs-updated.patch
-maintainers-add-myself-for-cxacru-in-drivers-usb-atm.patch
-x86_64-mm-defconfig-update.patch
-x86_64-mm-i386-defconfig-update.patch
-x86_64-wire-up-compat-sched_rr_get_interval2.patch
-x86_64-fix-section-mismatch-warnings.patch

 Merged into mainline or a subsystem tree

+return-eperm-not-echild-on-security_task_wait-failure.patch
+splice-dont-steal.patch
+splice-dont-readpage.patch
+shmem-fix-bug-in-shmem_writepage.patch
+shmem-dont-release-lock-for-hole-punching.patch

 Possible 2.6.21 queue.

-macintosh-mangle-caps-lock-events-on-adb-keyboards.patch

 Dropped

+git-alsa-fixup.patch

 Fix rejects in git-alsa.

+drivers-char-agp-convert-to-generic-boolean.patch

 AGP cleanup

+git-arm-master.patch

 New ARM tree

+remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch

 Cleanup

+cifs-remove-unneeded-checks.patch

 CIFS cleanup

+remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
+remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
+powerpc-fix-breakage-caused-by-72486f1f8f0a2bc828b9d30cf4690cf2dd6807fc.patch
+ibmebus-uevent-support.patch
+ocotea-board-ntpd-complains-that-the-frequency-error-exceeds-the-tolerance.patch

 ppc stuff

+gregkh-driver-driver-core-fix-device_add-error-path.patch
+gregkh-driver-driver-core-fix-namespace-issue-with-devices-assigned-to-classes.patch
+gregkh-driver-dev_printk-and-new-style-class-devices.patch
+gregkh-driver-driver-core-use-attribute-groups-in-struct-device_type.patch
+gregkh-driver-named-device_type.patch
+gregkh-driver-uio-hilscher-cif-card-driver.patch

 Driver tree updates

+kobject-kobject_shadow_add-cleanup.patch
+driver-core-handles-kobject_uevent-failure-while-device_add.patch
+driver-core-handle-sysfs_op-failure-while-device_add.patch

 Driver things

+jdelvare-i2c-i2c-i801-restore-initial-state.patch
+jdelvare-i2c-ds1374-check-for-workqueue-creation.patch
+jdelvare-i2c-i2c-09-i2c-class-attribute-cleanup.patch
+jdelvare-i2c-i2c-10-rename-dev_to_i2c_adapter.patch
+jdelvare-i2c-scx200_acb-fix-pci-device-reference-count.patch
+jdelvare-i2c-i2c-parport-fix-race-on-unload.patch
+jdelvare-i2c-i2c-parport-light-to-platform-driver.patch
+jdelvare-i2c-i2c-elektor-to-isa-driver.patch
+jdelvare-i2c-i2c-pca-isa-to-isa-driver.patch
+jdelvare-i2c-i2c-algo-bit-document-udelay.patch
+jdelvare-i2c-i2c-01-i2c-stack-can-probe.patch
+jdelvare-i2c-i2c-02-i2c-stack-can-remove.patch
+jdelvare-i2c-i2c-03-i2c-document-probe-and-remove.patch
+jdelvare-i2c-i2c-04-i2c_board_info-and-i2c_new_device.patch
+jdelvare-i2c-i2c-05-i2c_add_numbered_adapter.patch
+jdelvare-i2c-i2c-06-export_symbol-cleanup.patch
+jdelvare-i2c-i2c-07-i2c_bit_add_numbered_bus.patch
+jdelvare-i2c-i2c-isa-exports-only-to-i2c-isa.patch
+jdelvare-i2c-i2c-del-driver-returns-void.patch
+jdelvare-i2c-i2c-rpx-will-be-removed.patch

 I2C tree updates

+jdelvare-hwmon-hwmon-w83627hf-cleanups.patch
+jdelvare-hwmon-hwmon-w83627hf-to-platform-driver.patch
+jdelvare-hwmon-hwmon-sysfs-interface-add-fan-target.patch
+jdelvare-hwmon-hwmon-smsc47m1-to-platform-driver.patch
+jdelvare-hwmon-hwmon-smsc47m1-use-drvname-consistently.patch
+jdelvare-hwmon-hwmon-max6650-new-driver.patch
+jdelvare-hwmon-hwmon-lm78-to-platform-driver.patch
+jdelvare-hwmon-hwmon-lm78-less-client-centric.patch
+jdelvare-hwmon-hwmon-lm78-use-dynamic-attributes.patch
+jdelvare-hwmon-hwmon-lm75-use-dynamic-attributes.patch

 hwmon tree updates

-fix-locking-in-mousedev.patch

 Dropped - git-input changes broke it.

+ata_generic-remove-all-the-crud-again-and-use-cable.patch
+pata_ali-remove-all-the-crap-again-and-switch-to.patch
+pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch
+pata_cs5535-re-remove-all-the-crap-and-switch-to-the-cable.patch
+pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch
+pata_netcell-re-remove-all-the-crud.patch
+pata_qdi-restore-cable-detect.patch
+pata_sl82c105-restore-cable-detect-method.patch
+pata_winbond-restore-cable-method.patch
+libata-acpi-add-infrastructure-for-drivers-to-use.patch
+pata_optidma-rework-for-cable-detect-and-to-remove.patch
+pata_acpi-restore-driver.patch
+ata-ncq-is-broken-on-maxtor-6l250s0.patch

 pata/sata things

+ide-ide-fix-pio-setup-on-resume-for-atapi.patch
+ide-it821x-pio-mode-setup-fixes.patch
+ide-siimage-swdma-mask-fix.patch
+ide-ide-cris-fix-speedproc-and-swdma-mask.patch
+ide-ide-dma-off-quietly-fix.patch
+ide-ide-no-mdma-udma-sharing-filter.patch
+ide-ide-tune-dma-2.patch
+ide-cs5530-sc1200-dma-cleanup.patch
+ide-cs5530-sc1200-add-speedproc.patch
+ide-sl82c105-add-speedproc.patch
+ide-ide-dma-enable.patch
+ide-ide-check-dma-words-validity.patch
+ide-ide-remove-ide-use-dma.patch

 IDE tree updates

+revert-rm-pointless-dmaengine-exports.patch

 Revert a merged patch to make git-md-accel.patch easier to apply.

-git-md-accel-fixup.patch

 Unneeded

+git-md-accel-fix.patch

 Fix git-md-accel tree

-remove-fs-jffs2-ioctlc.patch

 Dropped

+mmc-consolidate-voltage-definitions.patch
+mmc-fix-handling-of-low-voltage-cards.patch
+remove-mmc_deselect_cards.patch

 MMC things

+mtd-pmc-msp71xx-flash-rootfs-mappings.patch
+jffs2-delete-everything-related-to-obsolete-jffs2_proc.patch
+romfs-printk-format-warnings.patch

 MTD stuff

+baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch
+remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
+tulip-fix-shutdown-dma-irq-race.patch
+sun3-3x-lance-trivial-fix-improved.patch
+remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch
+smc-superio-chip-lpc47n227-not-identified-properly.patch

 netdev things

+pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch

 PCMCIA cleanup

+gregkh-pci-pciehp-event-handling-rework.patch
+gregkh-pci-pciehp-adapt-to-device-driver-model.patch
+gregkh-pci-pci-scatterlisth-needs-typesh.patch
+gregkh-pci-pci-cleanup-the-includes-of-linux-pcih.patch

 PCI tree updates

-resurrect-sdev.patch
-bug-in-gdthc-crashing-machine.patch

 Dropped

+make-elv_register-output-atomic.patch

 Block cleanup

+unionfs-sioq-not-__exit.patch

 unionfs fixlet

+gregkh-usb-usb-fix-usb-serial-regression.patch
+gregkh-usb-usb-two-more-device-ids-for-dm9601-usbnet-driver.patch
+gregkh-usb-usb-razr-v3i-unusual_devs.patch
+gregkh-usb-usb-necessary-update-for-mos7720-driver.patch
+gregkh-usb-airprime-usb-id-for-novatel-ev620-mini-pci-e-card.patch
+gregkh-usb-ub-bind-to-first-endpoint-not-to-last.patch
+gregkh-usb-libusual-change-block-scope-variable-to-function-scope.patch
+gregkh-usb-usbcore-move-usb_autosuspend_work.patch
+gregkh-usb-usb-unnecessary-gfp_atomic-in-mos7720-driver.patch
+gregkh-usb-usbatm-create-sysfs-link-device-from-atm-class-device-to-usb-interface.patch
+gregkh-usb-usb-cxacru-export-detailed-device-info-through-sysfs.patch
+gregkh-usb-usb-maintainers-cxacru.patch
+gregkh-usb-usb-fix-race-in-hcd-removal.patch
+gregkh-usb-ehci-fsl-change-si_ctrl-pri_ctrl-register-offsets-according-to-errata.patch
+gregkh-usb-mos7720-update.patch
+gregkh-usb-usb-help-text-for-mos-7720-driver.patch
+gregkh-usb-usb-fix-gadget-serial-response-on-usb_cdc_req_set_line_coding.patch
+gregkh-usb-usb-separate-autosuspend-from-external-suspend.patch
+gregkh-usb-usb-allow-autosuspend-delay-to-equal-0.patch
+gregkh-usb-ehci-add-delay-to-bus_resume-before-accessing-ports.patch
+gregkh-usb-usb-usb_serial_driver-insufficient-for-clean-disconnect-handling.patch

 USB tree updates

+usb-serial-io_edgeport-convert-to-generic-boolean.patch
+usb-serial-whiteheat-convert-to-generic-boolean.patch

 USB stuff

+hack-to-make-wireless-work.patch

 The wireless tree seems to have broken the firmware loader.  Work around it.

+i386-x86_64-early_printkc-make-simnow_init-static.patch
+make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
+i386-fix-gdts-number-of-quadwords-in.patch
+i386-fix-usage-of-mtune-when-x86_generic=y-or-config_mcore2=y.patch
+x86_64-configurable-fake-numa-node-sizes-fix.patch
+lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code.patch
+lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore.patch
+lguest-the-host-code-lgko-pin-stack-page-optimization.patch
+lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
+lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
+lguest-dont-crash-host-on-nmi.patch
+lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch
+lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
+lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch
+x86_64-remove-duplicated-code-for-reading-control-registers.patch
+introduce-load_tls-to-the-for-loop.patch
+remove-unused-set_seg_base.patch
+clarify-config_reorder-explanation.patch
+mm-inconsistent-use-of-node-ids.patch
+dma_ops-as-const.patch
+allow-i386-crash-kernels-to-handle-x86_64-dumps.patch
+allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
+prevent-acpi-quirk-warning-mass-spamming-in-logs.patch
+prevent-acpi-quirk-warning-mass-spamming-in-logs-tidy.patch

 x86/x86_64 updates

-xfs-use-xfs_get_buf_noaddr-for-iclogs.patch
-xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr.patch

 Dropped - they need updating.

+uhci-fix-problem-caused-by-lack-of-terminating-qh.patch

 USB fix

+move-free-pages-between-lists-on-steal-fix-2.patch
+move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch

 Fix move-free-pages-between-lists-on-steal.atch some more

+fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch

 ia64 fix

-mm-debug-check-for-the-fault-vs-invalidate-race.patch
-mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch

 Drop this debug patch: the fault-vs-invalidate patches cause the BUG_ON() to
 trigger.

+mm-merge-nopfn-into-fault-fix.patch

 Fix mm-merge-nopfn-into-fault.patch

+lumpy-reclaim-v4.patch
+lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch
+lumpy-only-count-taken-pages-as-scanned.patch

 Lumpy reclaim came back

+mm-filemapc-fix-mark_page_accessed-logic.patch

 Tighten use-once logic

+bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
+bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch

 More page allocator work

+blackfin-arch-balance-parenthesis-in-macros.patch

 blackfin fix

+remove-unused-header-file-arch-m68k-atari-atasoundh.patch

 m68k cleanup

+remove-unused-header-file-drivers-serial-crisv10h.patch
+cris-check-for-memory-allocation.patch

 Cris updates

+remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch

 UML cleanup

+ext3-dirindex-error-pointer-issues-fix.patch

 Fix ext3-dirindex-error-pointer-issues.patch

+fix-race-between-proc_readdir-and-remove_proc_entry.patch
+proc-remove-pathetic-deleted-warn_on.patch

 Fiddle with /proc races some more

+complain-about-missing-system-calls.patch
+complain-about-missing-system-calls-update.patch
+proc-maps-protection.patch
+proc-maps-protection-fix.patch
+proc-maps-protection-tidy.patch
+proc-maps-protection-fix-2.patch
+remove-unused-header-file-include-linux-elfnoteh.patch
+remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
+remove-unused-header-file-drivers-char-digih.patch
+array_size-check-for-type.patch
+drivers-char-synclinkc-check-kmalloc-return-value.patch
+procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
+vfs-delay-the-dentry-name-generation-on-sockets-and.patch
+tty-i386-x86_64-arbitary-speed-support.patch
+kprobes-make-kprobesymbol_name-const.patch
+fix-cycladesh-for-x86_64-and-probably-others.patch
+fix-cycladesh-for-x86_64-and-probably-others-fix.patch
+cyclades-remove-custom-types.patch
+splice-partial-write-handling-fix.patch
+small-fixes-for-jsm-driver.patch
+jsm-driver-fix-for-linuxpps-support.patch
+serial-allocate-minor-device-numbers-for.patch
+as-fix-antic_expire-check.patch
+rtc-add-rtc-rs5c313-driver.patch
+rtc-add-rtc-rs5c313-driver-tidy.patch
+rtc-add-rtc-rs5c313-driver-is-busted.patch
+rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
+fix-rmmod-read-write-races-in-proc-entries.patch
+getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
+futex-restartable-futex_wait.patch
+futex-restartable-futex_wait-fix.patch
+proc-oom_score-oops-re-badness.patch
+fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
+tty-remove-unnecessary-export-of-proc_clear_tty.patch
+tty-simplify-calling-of-put_pid.patch
+tty-introduce-no_tty-and-use-it-in-selinux.patch
+tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
+reiserfs-proc-support-requires-proc_fs.patch

 Misc

+make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
+drivers-isdn-hardware-eicon-remove-unused-header-files.patch

 ISDN updates

+lists-add-list-splice-tail.patch
+sched-remove-sleepavg-from-proc.patch
+sched-remove-noninteractive-flag.patch
+sched-dont-renice-kernel-threads.patch
+sched-implement-rsdl-cpu-scheduler.patch
+sched-document-rsdl-cpu-scheduler.patch

 RSDL CPU scheduler

-rcu-split-classic-rcu.patch
-rcu-softirq-for-rcu.patch
-rcu-fix-barriers.patch
-rcu-preemptible-rcu.patch
-rcu-debug-trace-for-rcu.patch

 Dropped.  It's too early to merge preemptible RCU, and the ther patches had
 dependencies on it.

-utrace-prep.patch
+proc-maps-protection-vs-utrace.patch
+utrace-utrace-tracehook-um.patch
-revert-utrace-prep-2.patch
+avr32-implement-utrace-support.patch
+utrace-printk-borkage.patch
+ptrace-needs-proc_fs.patch

 utrace updates

+some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch

 Cleanup

+udf-possible-null-pointer-dereference-while-load_partition.patch

 UDF fix

+add-ability-to-keep-track-of-callers-of-symbol_getput.patch
+add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
+update-mtd-use-of-symbol_getput.patch
+update-dvb-use-of-symbol_getput.patch

 Fiddle with symbol_get()

+attach_pid-with-struct-pid-parameter.patch
+statically-initialize-struct-pid-for-swapper.patch
+explicitly-set-pgid-and-sid-of-init-process.patch
+use-struct-pid-parameter-in-copy_process.patch
+# remove-the-likelypid-check-in-copy_process.patch: Oleg issues
+remove-the-likelypid-check-in-copy_process.patch
+use-task_pgrp-task_session-in-copy_process.patch
+kill-unused-sesssion-and-group-values-in-rocket-driver.patch
+fix-some-coding-style-errors-in-autofs.patch
+replace-pid_t-in-autofs-with-struct-pid-reference.patch

 PID management updates

+revoke-special-mmap-handling.patch
+revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
+revoke-core-code.patch
+revoke-core-code-misc-fixes.patch
+revoke-core-code-fix-shared-mapping-revoke.patch
+revoke-core-code-move-magic.patch
+revoke-support-for-ext2-and-ext3.patch
+revoke-add-documentation.patch
+revoke-wire-up-i386-system-calls.patch

 revoke() syscall

+readahead-state-based-method-check-node-id.patch
+readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch
+readahead-state-based-method-cancel-lookahead-gracefully.patch
+readahead-thrashing-recovery-method-check-unbalanced-aging.patch
+readahead-thrashing-recovery-method-refill-holes.patch
+readahead-call-scheme-cleanup.patch
+readahead-call-scheme-catch-thrashing-on-lookahead-time.patch
+readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
+readahead-remove-parameter-ra_max-from-adjust_rala.patch
+readahead-state-based-method-protect-against-tiny-size.patch
+readahead-rename-state_based_readahead-to-clock_based_readahead.patch
+readahead-account-i-o-block-times-for-stock-readahead.patch
+readahead-rescue_pages-updates.patch
+readahead-remove-noaction-shrink-events.patch

 Update the readahead patches in -mm.

+remove-unused-header-file-drivers-video-riva-nv4refh.patch
+fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch
+fbdev-fb_do_show_logo-updates.patch
+fbdev-correct-image-offsets-when-rotating-logo.patch
+radeonfb-add-support-for-radeon-xpress-200m.patch

 fbdev updates

+statistics-infrastructure-simplify-statistics-debugfs-write-function.patch

 Update statistics patches in -mm.

-ia64-enable-config_debug_spinlock_sleep.patch
-msi-debug-code.patch

 Dropped.




All 934 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/patch-list

