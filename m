Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbXLEFRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbXLEFRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 00:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbXLEFRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 00:17:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48708 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbXLEFRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 00:17:06 -0500
Date: Tue, 4 Dec 2007 21:17:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc4-mm1
Message-Id: <20071204211701.994dfce6.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Temporarily at

  http://userweb.kernel.org/~akpm/2.6.24-rc4-mm1/

Will appear later at

  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/


- Lots of device IDs have been removed from the e1000 driver and moved over
  to e1000e.  So if your e1000 stops working, you forgot to set CONFIG_E1000E.

- The s390 build is still broken.



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



Changes since 2.6.24-rc3-mm2:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-arm.patch
 git-avr32.patch
 git-avr32-fixup.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-powerpc-galak.patch
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
 git-lblnet.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mips.patch
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
 git-sparc64.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-x86.patch
 git-newsetup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-xtensa.patch

 git trees

-update-checkpatchpl-to-version-012.patch
-file-capabilities-allow-sigcont-within-session-v2.patch
-cris-build-fixes-atomich-needs-compilerh.patch
-atmel_spi-labels-gpios-better.patch
-ps3-prefix-all-ps3-specific-kernel-modules-with.patch
-ps3fb-video-memory-size-cleanups.patch
-fix-boot-problem-with-iseries-lacking-hugepage-support.patch
-uml-build-fix.patch
-xen-mask-_page_pcd-from-ptes.patch
-pnp-increase-the-maximum-number-of-resources.patch
-pnp-increase-the-maximum-number-of-resources-fix.patch
-proc-fix-null-i_fop-oops.patch
-wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
-proc-remove-races-from-proc_id_readdir.patch
-tpm-tis-device-driver-locality-request.patch
-termios-document-callback-more-clearly.patch
-s3c24xx-ensure-we-only-configure-valid-gpios.patch
-s3c2410-add-bus-number-to-spi-gpio-driver.patch
-ipc-lost-unlock-and-fput-in-mqueuec-on-error-path.patch
-fix-linux-kdh-usage-in-userspace.patch
-fix-linux-kdh-usage-in-userspace-checkpatch-fixes.patch
-m68k-zorro7xx-needs-asm-amigahwh.patch
-fb_ddc-fix-ddc-lines-quirk.patch
-drivers-pnp-resourcec-add-missing-pci_dev_put.patch
-mfd-sm501-debug-typo-fix.patch
-isolate-the-uts-namespaces-domainname-and-hostname-back.patch
-the-namespaces-compatibility-list.patch
-atmel_lcdfb-lcdc-startup-fix.patch
-dmaengine-correct-invalid-assumptions-in-the-kconfig-text.patch
-ip22zilog-fix-lockup-and-sysrq.patch
-fix-up-ext2_fsh-for-userspace-after-reservations-backport.patch
-hexdump-dont-print-bytes-with-bit-7-set.patch
-file-capabilities-dont-prevent-signaling-setuid-root.patch
-isdn-bootup-crash-fix-2624-rc3-git1.patch
-uml-fix-no_hz-busy-loop.patch
-leak-in-do_ubd_request.patch
-revert-keyspan-init-termios-properly.patch
-x86_64-efi-boot-support-efi-frame-buffer.patch
-x86_64-efi-boot-support-efi-boot-document.patch
-memory-hotplug-fix-fix-section-mismatch-in-vmammap_allock_block.patch
-memory-hotplug-x86_64-fix-section-mismatch-in-init_memory_mapping.patch
-fuse-fix-reading-past-eof.patch
-fuse-cleanup-add-fuse_get_attr_version.patch
-fuse-pass-open-flags-to-read-and-write.patch
-fuse-fix-fuse_file_ops-sending.patch
-fuse-fix-uninitialized-field-in-fuse_inode.patch
-fuse-fix-attribute-caching-after-rename.patch
-sound-core-memallocc-add-missing-pci_dev_put.patch
-arm-fix-memset-size-error.patch
-gregkh-driver-allow-legacy_ptys-to-be-set-to-0.patch
-gregkh-driver-create-sys-power-when-config_pm-is-set.patch
-gregkh-driver-uio-fix-up-the-uio-documentation.patch
-gregkh-driver-uio-add-uio-documentation-target-to-docbook-makefile.patch
-gregkh-driver-kobject-two-typo-fixes.patch
-gregkh-driver-sysfs-fix-off-by-one-error-in-fill_read_buffer.patch
-gregkh-driver-nozomi.patch
-git-drm-warning-fix.patch
-clocksource-make-clocksource_mask-bullet-proof.patch
-time-fold-__get_realtime_clock_ts-into-getnstimeofday.patch
-clean-hungarian-notation-from-timers.patch
-timer-cleanups.patch
-more-timer-related-cleanups.patch
-ata_generic-unindent-loop-in-generic_set_mode.patch
-libata-export-xfermode--pata-timing-related-functions.patch
-libata-clean-up-xfermode--pata-timing-related-stuff.patch
-libata-kill-ata_id_to_dma_mode.patch
-libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch
-libata-fix-ata_acpi_gtm_xfermask.patch
-libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch
-libata-implement-ata_acpi_init_gtm.patch
-libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
-libata-add-ata_cbl_pata_ign.patch
-pata_amd-update-mode-selection-for-nv-patas.patch
-sata_nv-dont-use-legacy-dma-in-adma-mode-v3.patch
-ide-mm-alim15x3-add-mitac-8317-and-derivatives-to-ali_cable_override.patch
-ide-mm-ide-fix-host-drivers-depending-on-ide_generic-to-probe-for-interfaces.patch
-fix-config_mtd_sharp_sl-if-config_mtd=m-try2.patch
-net-irda-parametersc-trivial-fixes.patch
-net-fix-tx-bug-vlan-in-vlan.patch
-xfrm_policy-warning-fix.patch
-phy-implement-release-function.patch
-git-nfsd-fix-nfsd_idmap-stubs.patch
-arch-parisc-remove-duplicate-includes.patch
-gregkh-pci-pci-pcie-portdriver-initialize-returned-value.patch
-gregkh-pci-pci-drivers-pci-pci-sysfsc-add-missing-pci_dev_put.patch
-gregkh-usb-usb-fix-usb_ohci_hcd_ssb-dependencies.patch
-gregkh-usb-usb-omap_udc-build-fix.patch
-gregkh-usb-usb-pl2303-add-support-for-corega-cg-usbrs232r.patch
-gregkh-usb-usb-storage-always-set-the-allow_restart-flag.patch
-gregkh-usb-usb-fix-priority-mistakes-in-drivers-usb-core-hubc.patch
-gregkh-usb-usb-free-memory-when-writing-fails-in-usb-serial-mos7840c.patch
-gregkh-usb-usb-fix-usbled-disconnect-read-race-2.patch
-gregkh-usb-usbserial-fix-inconsistent-lock-state.patch
-gregkh-usb-usb-fix-signr-comment-in-usbdevice_fsh.patch
-gregkh-usb-usb-power-management-documenation-update.patch
-gregkh-usb-usb-fix-locks-and-urb-status-in-adutux.patch
-gregkh-usb-usb-add-support-for-an-older-firmware-revision-for-the-nikon-d200.patch
-gregkh-usb-usb-fix-directory-references-in-usb-readme.patch
-gregkh-usb-usb-remove-usb-hub-entry-from-maintainers.patch
-gregkh-usb-usb-mailing-lists-have-changed.patch
-gregkh-usb-usb-hcd-avoid-duplicate-local_irq_disable.patch
-gregkh-usb-usb-sierra-new-product-id.patch
-gregkh-usb-usb-keep-track-of-whether-interface-sysfs-files-exist.patch
-gregkh-usb-usb-uevent-environment-key-fix.patch
-gregkh-usb-usb-make-the-microtek-driver-and-hal-cooperate.patch
-gregkh-usb-usb-fix-up-ehci-startup-synchronization.patch
-gregkh-usb-usb-usb-storage-unusual_devs-entry-for-jetflash-ts1gjf2a.patch
-gregkh-usb-usb-s3c2410-gadget-header-move-fixups.patch
-gregkh-usb-usb-s3c2410-gadget-allow-sharing-of-vbus-irq.patch
-gregkh-usb-usb-s3c2410-gadget-ensure-vbus-pin-in-input-mode-during-read.patch
-watchdog-add-nano-7240-driver-2.patch
-txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500.patch
-x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
-x86_64-do-not-set-boot-cpu-in-cpu_online_map-at-x86_64_start_kernel.patch
-vmlinux_32ldss-remove-repeated-comment-from-the-x86-32-linker-script.patch
-x86_64-make-sparsemem-vmemmap-the-only-memory-model.patch
-rtc-convert-mutex-to-bitfield.patch
-drm-i915-fix-pointer-strip.patch
-pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
-frv-fix-the-extern-declaration-of-kallsyms_num_syms.patch
-frv-arrange-things-such-that-bra-can-reach-from-the-trap.patch
-wait_task_stopped-pass-correct-exit_code-to.patch
-tty-add-the-new-termios2-ioctls-to-the-compatible.patch
-acpi-avoid-references-to-impossible-processors.patch
-fix-proc-net-breakage.patch
-lguest-prevent-visws-or-voyager-randconfigs.patch
-x86-paravirt-revert-exports-to-restore-old-behaviour.patch
-optimize-i8259-code-a-bit.patch
-mm-prevent-dereferencing-non-allocated-per_cpu-variables.patch
-mm-prevent-dereferencing-non-allocated-per_cpu-variables-fix.patch
-fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486.patch
-kernel-modulec-make_driver_name-can-use-kasrpintf.patch
-lockdep-show-held-locks-when-showing-a-stackdump.patch
-kmap_atomic-debugging.patch

 Merged into mainline or a subsystem tree

+aio-only-account-i-o-wait-time-in-read_events-if-there-are-active-requests.patch
+fix-cloneclone_newpid.patch
+rtc-assure-proper-memory-ordering-with-respect-to-rtc_dev_busy-flag.patch
+ufs-fix-nexstep-dir-block-size.patch
+ufs-fix-nexstep-dir-block-size-checkpatch-fixes.patch
+aoe-properly-initialise-the-request_queues-backing_dev_info.patch
+mm-backing-devc-fix-percpu_counter_destroy-call-bug-in-bdi_init.patch
+add-export_symbolksize.patch
+spi-use-mutex-not-semaphore.patch
+spi-at25-driver-is-for-eeprom-not-flash.patch
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
+avoid-potential-null-dereference-in-unregister_sysctl_table.patch
+gpio_cs5535-disable-aux-on-output.patch
+mm-fix-xip-file-writes.patch
+revert-dpt_i2o-convert-to-scsi-hotplug-model.patch

 2.6.24 queue

+__group_complete_signal-fix-coredump-with-group-stop-race.patch
+remove-handle_group_stop-in-favor-of-do_signal_stop.patch
+exec-rework-the-group-exit-and-fix-the-race-with-kill.patch

 Maybe 2.6.24

+timerfd-v3-new-timerfd-api-ia64-fix.patch
+timerfd-v3-new-timerfd-api-m68k-fix.patch
+timerfd-v3-new-timerfd-api-mips-fix.patch
+timerfd-v3-new-timerfd-api-arch-fixes.patch
+timerfd-v3-new-timerfd-api-powerpc-fix.patch
+timerfd-v3-new-timerfd-api-update-sys_nic-with-the-new-timerfd-syscalls.patch

 Maybe fix timerfd-v3-new-timerfd-api.patch just a bit.

+sdio-fix-module-device-table-definition-for-m68k.patch
+jbd-fix-assertion-failure-in-fs-jbd-checkpointc.patch
+proc-fix-pde-refcounting.patch

 Maybe 2.6.24

+git-avr32-fixup.patch

 Fix conflicts in git-avr32.patch

+powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y.patch

 powerpc fix

+gregkh-driver-nozomi.patch
+gregkh-driver-kobject-convert-hvc_console-to-use-kref-not-kobject.patch
+gregkh-driver-kobject-convert-hvcs-to-use-kref-not-kobject.patch
+gregkh-driver-kobject-grab-the-kset-reference-in-kobject_add-not-kobject_init.patch
+gregkh-driver-kobject-clean-up-debugging-messages.patch
+gregkh-driver-usb-use-proper-call-to-driver_create_file.patch
+gregkh-driver-pcmcia-use-proper-call-to-driver_create_file.patch
+gregkh-driver-pci-use-proper-call-to-driver_create_file.patch
+gregkh-driver-pci-remove-foolish-code-from-pci-driverc.patch
+gregkh-driver-driver-core-move-the-driver-specific-module-code-into-the-driver-core.patch
+gregkh-driver-driver-core-move-the-static-kobject-out-of-struct-driver.patch
+gregkh-driver-driver-core-clean-up-debugging-messages.patch
+gregkh-driver-kobject-fix-up-kobject_set_name-to-use-kvasprintf.patch
+gregkh-driver-kobject-add-kobject_init_ng-kobject_add_ng-and-kobject_init_and_add-functions.patch
+gregkh-driver-driver-core-fix-class-glue-dir-cleanup-logic.patch
+gregkh-driver-sysfs-fix-sys-module-holders-after-sysfs-logic-change.patch
+gregkh-driver-kobject-drop-child-parent-ref-at-unregistration.patch
+gregkh-driver-block-device.patch

 driver tree updates

+driver-tree-broke-infiniband.patch
+gregkh-driver-driver-core-move-the-driver-specific-module-code-into-the-driver-core-fix.patch

 Fixes for driver tree

+jdelvare-i2c-i2c-remove-redundant-gpio-drivers.patch

 i2c tree update

+applesmc-sensors-set-for-macbook2.patch

 sensors driver update

+apanel-free-input-device-on-close.patch
+apanel-change-name-of-led.patch
+apanel-detach-on-shutdown.patch
+apanel-use-generic-keycode-routines.patch

 Update fujitsu-application-panel-driver.patch

+ads7846-stop-updating-dev-powerpower_state.patch

 input driver fix

+libata-xfer_mask-is-unsigned-int-not-unsigned-long-fix.patch
+libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
+ata-ahci-enclosure-management-via-led.patch
+libata-fix-early-use-of-port-printk-checkpatch-fixes.patch

 sata/pata things

+ide-mm-ide-scsi-add-ide_scsi_hex_dump-helper.patch
+ide-mm-ide-add-missing-checks-for-control-register-existence.patch
+ide-mm-ide-deprecate-config_blk_dev_offboard.patch
+ide-mm-ide-fix-ide_scan_pcibus-error-message.patch
+ide-mm-ide-coding-style-fixes-for-drivers-ide-setup-pci-c.patch
+ide-mm-ide-add-sys-bus-ide-devices-model-firmware-serial-sysfs-entries.patch
+ide-mm-ide-fix-host-drivers-depending-on-ide_generic-to-probe-for-interfaces-take-2.patch
+ide-mm-au1xxx-ide-au_ide_probe-fix.patch
+ide-mm-au1xxx-ide-use-ide_init_port_hw.patch
+ide-mm-ide-always-use-ide_std_init_ports-in-setup-pci-c.patch
+ide-mm-ide-use-ide_init_port_hw-in-setup-pci-c.patch
+ide-mm-rapide-remove-write-only-hwif-hwif_data.patch
+ide-mm-ide-pmac-use-custom-hwif-sg_max_nents-only-if-dma-support-is-enabled.patch
+ide-mm-ide-add-ide_set_irq-inline-helper.patch
+ide-mm-ide-print-banner-message-once-per-controller-in-m68k-host-drivers.patch
+ide-mm-ide-move-config_idepci_pcibus_order-code-to-ide-scan-pci-c.patch
+ide-mm-ide-make-config_idepci_pcibus_order-visible-and-deprecate-it.patch

 IDE tree updates

-git-mips-fixup.patch

 Unneeded

+remove-trailing-nuls-from-network-bonding-sysfs-interface.patch
+net-bonding-return-nothing-for-not-applicable-values.patch
+net-bonding-purely-cosmetic-rename-a-local-variable.patch

 net things

+net-smc911x-shut-up-compiler-warnings.patch
+bnx2x-depends-on-zlib_inflate.patch

 netdev things

+pcmcia-stop-updating-dev-powerpower_state.patch

 pcmcia fix

+quirk-enable-msi-mapping-on-ht1000-v2.patch

 Fix quirk-enable-msi-mapping-on-ht1000.patch

-git-sh-fixup.patch

 Unneeded

+drivers-scsi-sgiwd93c-export-sgiwd93_reset.patch
+scsi-qla2xxx-qla_osc-section-fix.patch

 scsi fixes

-bidi-support-scsi_data_buffer-broke-qla1280.patch
-bidi-support-scsi_data_buffer-broke-lots-of-stuff.patch

 Folded into bidi-support-scsi_data_buffer.patch

+scsi-pending-arm-convert-to-accessors.patch

 scsi fix

+edgeport-usb-serial-converter-convert-es_sem-to-mutex.patch
+usb-testing-driver-convert-dev-sem-to-mutex.patch
+usb-testing-driver-dont-free-a-locked-mutex.patch

 USB things

+git-watchdog-hpwdt-build-fix.patch
+add-support-for-sb1-hardware-watchdog.patch
+add-support-for-sb1-hardware-watchdog-fix.patch

 watchdog things

+iwlwifi-3945-fix-race-conditional-panic.patch
+iwlwifi-4965-fix-race-conditional-panic.patch
+net-mac80211-fix-inappropriate-memory-freeing.patch
+bcm43xx_debugfs-sscanf-fix.patch

 wireless fixes

+revert-git-kvm-changes-in-arch-x86-kconfig.patch
 git-x86.patch
+revert-revert-git-kvm-changes-in-arch-x86-kconfig.patch

 Make git-x86 apply

-git-x86-build-fix.patch

 Unneeded

+git-x86-__vdso_getcpu-warning-fix.patch
+uml-add-asm-um-asmh.patch
+clocksource-make-clocksource_mask-bullet-proof.patch
+time-fold-__get_realtime_clock_ts-into-getnstimeofday.patch

 x86 stuff

+git-cryptodev-fixup.patch

 Fix conflicts in git-cryptodev

+ieee80211_rate-missed-unlock.patch
+slubs-ksize-fails-for-size-2048.patch
+vm-security-add-security-hook-to-do_brk.patch

 More 2.6.24 things

+vmstat-remove-prefetch.patch
+mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch
+mm-dont-waste-swap-on-locked-pages.patch
+skip-writing-data-pages-when-inode-is-under-i_sync.patch

 MM updates

+add-64-bit-capability-support-to-the-kernel-capabilities-export-__cap_-symbols.patch
+capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch

 Fix 64-bit capabilities

+smack-using-capabilities-32-and-33-update-cap_last_cap-to-reflect-cap_mac_admin.patch
+smack-mutex-capability-pointers-and-spelling-cleanup.patch

 smack updates

+nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch

 nommu update

+uml-fix-command-line-cflags-and-ldflags-support.patch
+uml-style-fixes-in-arch-um-os-linux.patch

 UML updates

+printk-trivial-optimizations-fix.patch

 Fix printk-trivial-optimizations.patch

-partitions-use-kasprintf.patch

 Dropped due to rejects

+inotify-send-in_attrib-events-when-link-count-changes-fix.patch
+reiserfs-complement-va_start-with-va_end.patch
+get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
+synclink-standardize-format-of-linux-header-file-includes-with.patch
+kernel-add-mutex_lock_killable.patch
+vfs-use-mutex_lock_killable-in-vfs_readdir.patch
+fix-__const_udelay-declaration-and-definition-mismatches.patch
+drivers-char-randomcwrite_pool-cond_resched-needed.patch
+kill-an-unused-ptr_err-in-bdev_cache_init.patch
+remove-rcu_assign_pointer-penalty-for-null-pointers.patch
+remove-superfluous-checks-for-config_blk_dev_initrd-from-initramfsc.patch
+serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch
+char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch
+clean-up-drivers-char-rtcc.patch
+sc26xx-new-serial-driver-for-sc2681-uarts.patch
+sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
+inotify-fix-race.patch
+inotify-remove-debug-code.patch
+documentation-about-unaligned-memory-access.patch
+drivers-char-tty_ioc-remove-pty_sem.patch
+drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
+unix98-allocated_ptys_lock-semaphore-to-mutex.patch
+kallsyms-should-prefer-non-weak-symbols.patch
+kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch

 Misc

+move-kprobes-examples-to-samples-resend-vs-git-x86.patch

 Fix move-kprobes-examples-to-samples-resend.patch

+gigaset-permit-module-unload.patch

 gigaset fix

+rtc-cmos-alarm-acts-as-oneshot.patch
+platform-real-time-clock-driver-for-dallas-1511-chip.patch
+#
+blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz.patch
+blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler.patch
+blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs.patch
+blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp.patch
+blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch
+blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment.patch
+blackfin-rtc-driver-convert-sync-wait-to-use-the-irq-write-complete-notice.patch

 rtc updates

+fbmon-remove-unnecessary-local-variable.patch
+fbmon-cleanup-trailing-whitespaces.patch
+fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch

 fbdev queue

+declare-pnp-option-parsing-functions-as-__init.patch
+declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
+isapnp-driver-semaphore-to-mutex.patch
+isapnp-driver-semaphore-to-mutex-fix.patch
+isapnp-driver-semaphore-to-mutex-fix-fix.patch

 pnp updates

-ext4-add-block-bitmap-validation-fix.patch

 Folded into ext4-add-block-bitmap-validation.patch

-ext4-fix-up-ext4fs_debug-builds-checkpatch-fixes.patch

 Folded into ext4-fix-up-ext4fs_debug-builds.patch

+jbd2-fix-assertion-failure-in-fs-jbd2-checkpointc.patch
+ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks.patch
+ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks-fix.patch

 ext4 updates

+memory-controller-improve-user-interface-memory-controller-enhancements-for-reclaiming-take2-possible-race-fix-in-res_counter.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter-memory-controller-enhancements-for-reclaiming-take2-clean-up-remove-unused-variable.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter-memory-controller-enhancements-for-reclaiming-take2-add-bug_on-in-mem_cgroup_zoneinfo.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-bugfix-for-memory-cgroup-per-zone-struct-allocation.patch
+per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-memory-controller-enhancements-for-reclaiming-take2-define-free_mem_cgroup_per_zone_info.patch

 Update cgroups memory controller patches in -mm.

-add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch

 Dropped due to rejects

+proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
+proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
+proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch

 procfs work

+fix-setsid-for-sub-namespace-sbin-init.patch
+teach-set_special_pids-to-use-struct-pid.patch
+move-daemonized-kernel-threads-into-the-swappers-session.patch
+start-the-global-sbin-init-with-00-special-pids.patch
+clocksource-remove-redundant-code.patch
+clockevent-simplify-list-operations.patch
+timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
+time-fix-typo-in-comments.patch
+time-delete-comments-that-refer-to-noexistent-symbols.patch

 Core kernel updates

+aout-move-stack_top-to-asm-processorh.patch
+aout-mark-arches-that-support-aout-format.patch
+aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
+aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
+aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
+aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
+aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
+usb-net2280-cant-have-a-function-called-show_registers.patch
+mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
+mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
+mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
+mn10300-add-platform-mtd-support-for-the-asb2303-board.patch

 mn10300 architecture and associated stuff

+rewrite-rd.patch
+rewrite-rd-fix.patch
+rewrite-rd-fixes.patch

 Reimplamantation of the ramdisk driver

+linux-kernel-markers-support-multiple-probes.patch
+linux-kernel-markers-support-multiple-probes-update.patch
+linux-kernel-markers-create-modpost-file.patch

 markers update

+cramfs-make-cramfs-little-endian-only.patch
+cramfs-make-cramfs-little-endian-only-update.patch
+cramfs-make-cramfs-little-endian-only-fix.patch
+cramfs-update-documentation.patch

 cramfs work (needs updating)

+reiser4-new-export-ops-update.patch
+reiser4-specify-splice-file-operations.patch

 reiser5 updates


4453 commits in 1478 patch files


All patches:
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/patch-list


