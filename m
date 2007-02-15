Return-Path: <linux-kernel-owner+w=401wt.eu-S932717AbXBONOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbXBONOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 08:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932712AbXBONOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 08:14:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46462 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711AbXBONOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 08:14:20 -0500
Date: Thu, 15 Feb 2007 05:14:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20-mm1
Message-Id: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Temporarily at

  http://userweb.kernel.org/~akpm/2.6.20-mm1/

Will appear later at

 ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm1/


- This kernel doesn't compile on powerpc due to the local_t changes

- git-drm got dropped due to it breaking X

- The ext4 devel tree was added, then got dropped again due to various
  breakages.  Next time.

- The IDE tree got dropped due to various linkage problems

- The sony-laptop driver has been disabled due to disagreement between
  the git-acpi and git-backlight trees

- I'm not sure that all the necessary XFS-related fixes made it into the
  git-block tree.  But Jens put a nasty into the CPU scheduler so hopefully
  things will work there now.

- The UBI tree got dropped due to probable lack of a git sync with
  mainline (ie: it's a 13.5MB diff whcih doesn't apply very well)

- Probably lots of other things are broken too.  This is a bit of a
  heck-I'd-better-get-it-out-before-they-wreck-everything release.

- Added the "Use IOAT for MD" tree as git-md-accel.patch (Dan Williams
  <dan.j.williams@intel.com>)

- Added the v9fs tree as git-v9fs.patch (Eric Van Hensbergen
  <ericvh@gmail.com>)

- Added the rustyvisor

- Added the blackfin architecture

- Added the utrace tree.  This is a huge rewrite of the kernel's ptrace
  mechanisms (Roland McGrath <roland@redhat.com>).

- Added the Linux Kernel Markers code.  No idea how to use it and it
  seems we're not to be told.



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





Changes since 2.6.20-rc6-mm3:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-arm.patch
 git-audit-master.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-dvb.patch
 git-hid.patch
 git-ia64.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-libata-all.patch
 git-lxdialog.patch
 git-md-accel.patch
 git-mips.patch
 git-mtd.patch
 git-netdev-all.patch
 git-backlight.patch
 git-ioat.patch
 git-ocfs2.patch
 git-pciseg.patch
 git-sh.patch
 git-block.patch
 git-unionfs.patch
 git-v9fs.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-gccbug.patch

 git trees.

-namespaces-fix-exit-race-by-splitting-exit.patch
-uml-fix-mknod.patch
-dont-allow-the-stack-to-grow-into-hugetlb-reserved-regions.patch
-use-__u8-__u32-in-userspace-ioctl-defines-for-i2o.patch
-fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
-m68k-uaccessh-needs-schedh.patch
-fs-lockd-clntlockc-add-missing-newlines-to-dprintks.patch
-knfsd-ratelimit-some-nfsd-messages-that-are-triggered-by-external-events.patch
-use-__u8-rather-than-u8-in-userspace-size-defines-in-hdregh.patch
-fuse-fix-bug-in-control-filesystem-mount.patch
-ufs-alloc-metadata-null-page-fix.patch
-ufs-truncate-negative-to-unsigned-fix.patch
-ufs-rellocation-fix.patch
-cdevh-forward-declarations.patch
-fix-via-irq-quirk-breakage.patch
-i386-in-assign_irq_vector-look-at-all-vectors-before-giving-up.patch
-translate-dashes-in-filenames-for-headers-install.patch
-remove-warning-vfs-is-out-of-sync-with-lock-manager.patch
-scsi_ioctl-sg_io-timeout-conversion-fix.patch
-fix-for-patch-ecdfc9787fe527491baefc22dce8b2dbd5b2908d.patch
-enable-mouse-button-23-emulation-for-x86-macs.patch
-x86-fix-vdso-mapping-for-aout-executables.patch
-mm-show-bounce-pages-in-oom-killer-output.patch
-add-install_special_mapping.patch
-i386-vdso-use-install_special_mapping.patch
-x86_64-ia32-vdso-use-install_special_mapping.patch
-powerpc-vdso-use-install_special_mapping.patch
-sh-vdso-use-install_special_mappingpatch.patch
-use-correct-macros-in-raid-code-not-raw-asm.patch
-use-correct-macros-in-raid-code-not-raw-asm-include.patch
-acpi-bay-remove-acpi-driver-struct.patch
-asus_acpi-add-support-for-asus-z81sp.patch
-exit-acpi-processor-module-gracefully-if-acpi-is-disabled-tidy.patch
-acpi-make-bay-depend-on-dock.patch
-acpi-updates-rtc-cmos-device-platform_data.patch
-acpi-updates-rtc-cmos-device-platform_data-vs-git-acpi.patch
-acpi-correct-apparent-typo-config_acpi_debug_output.patch
-drivers-acpi-hotkeyc-make-2-structs-static.patch
-2.6-sony_acpi4.patch
-sony_apci-resume.patch
-sony_apci-resume-fix.patch
-acpi-add-backlight-support-to-the-sony_acpi.patch
-acpi-add-backlight-support-to-the-sony_acpi-v2.patch
-video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
-sony_acpi-addacpi_bus_generate-event.patch
-sony_acpi-addacpi_bus_generate-event-fix.patch
-sony_acpi-add-lanpower-and-audiopower-controls.patch
-sony_acpi-allow-multiple-sony_acpi_values-for-the-same-name.patch
-sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration.patch
-agpgart-allow-drm-populated-agp-memory-types.patch
-agpgart-allow-drm-populated-agp-memory-types-tidy.patch
-agpgart-allow-drm-populated-agp-memory-types-update.patch
-arm-imx-serial-fix-tx-buffer-overflows.patch
-arm-imx-serial-fix-irq-allocation.patch
-amba-pl010-add-reference-to-ep93xx-to-kconfig-help-entry.patch
-avr32-fix-build-breakage.patch
-remove-hotplug-cpu-crap-from-cpufreq.patch
-rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
-rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix.patch
-rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-2.patch
-rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3.patch
-ondemand-governor-restructure-the-work-callback.patch
-ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback.patch
-cpu_freq_table-shouldnt-be-a-def_tristate.patch
-ppc-cs4218_tdm-remove-extra-brace.patch
-ppc-use-syslog-macro-for-the-printk-log-level.patch
-fix-ppc64s-writing-to-struct-file_operations.patch
-fix-apparent-typo-config_serial_cpm_smc.patch
-gregkh-driver-kobject_robust.patch
-gregkh-driver-pcmcia-device.patch
-gregkh-driver-driver-core-remove-device_is_registered-in-device_move.patch
-gregkh-driver-driver-core-allow-device_move.patch
-gregkh-driver-built-in-drivers-in-sys-modules.patch
-gregkh-driver-modules-drivers-dir-only-if-needed.patch
-gregkh-driver-pci-kbuild-modname.patch
-gregkh-driver-serio-kbuild-modname.patch
-gregkh-driver-usb-kbuild-modname.patch
-gregkh-driver-sys-modules-holders.patch
-gregkh-driver-driver-core-fixes-make_class_name-retval-checks.patch
-gregkh-driver-driver-core-fixes-device_register-retval-check-in-platformc.patch
-gregkh-driver-driver-core-don-t-stop-probing-on-probe-errors.patch
-gregkh-driver-driver-core-change-function-call-order-in-device_bind_driver.patch
-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
-gregkh-driver-sysfs-suppress-lockdep-warnings.patch
-gregkh-driver-sysfs-kobject_put-cleanup.patch
-gregkh-driver-kobject-kobject_put-cleanup.patch
-gregkh-driver-sysfs-error-handling-in-sysfs-fill_read_buffer.patch
-gregkh-driver-howto-add-a-reference-to-harbison-and-steele.patch
-gregkh-driver-sysfs-fix-missing-include-of-listh-in-sysfsh.patch
-gregkh-driver-add-uevent-vars-for-devices-with-a-class.patch
-gregkh-driver-add-device_type-to-device.patch
-gregkh-driver-allow-to-supress-uevent-for-devices.patch
-gregkh-driver-increase-firmware-loader-timeout.patch
-gregkh-driver-sysfs-shadow-directory-support.patch
-gregkh-driver-network-device.patch
-kobject-kobj-k_name-verification-fix.patch
-spider-fix-gregkh-driver-network-device.patch
-driver-core-per-subsystem-multithreaded-probing.patch
-powerpc-make-it-compile.patch
-driver-core-dont-fail-attaching-the-device-if-it.patch
-drivers-char-drm-drm_mmc-remove-unused-exports.patch
-avoid-race-when-deregistering-the-ir-control-for-dvb-usb.patch
-kthread-api-conversion-for-dvb_frontend-and-av7110.patch
-remove-the-unused-kernel-config-option-video_videobuf.patch
-drivers-media-dvb-frontends-make-4-functions-static.patch
-dvb-video_buf-depends-on-pci.patch
-drivers-media-video-convert-to-generic-boolean-values.patch
-drivers-media-video-cafe_ccicc-fix-warning.patch
-cx88-videoc-remove-struct-radionorms.patch
-if-0-v4l_printk_ioctl_arg.patch
-jdelvare-i2c-i2c-ali1563-cleanup-messages.patch
-jdelvare-i2c-i2c-vt8231-remove-superfluous-initialization.patch
-jdelvare-i2c-i2c-nforce2-drop-unused-reference-to-pci_dev.patch
-jdelvare-i2c-i2c-piix4-add-ati-sb600-support.patch
-jdelvare-i2c-i2c-smbus-doc-typo.patch
-jdelvare-i2c-i2c-i801-spelling-fix.patch
-jdelvare-i2c-i2c-completion-header-cleanups.patch
-jdelvare-i2c-i2c-driver-suspend-resume-shutdown-support.patch
-jdelvare-i2c-i2c-ali1563-fix-initialization.patch
-jdelvare-i2c-i2c-i801-document-unhiding-quirk.patch
-jdelvare-i2c-i2c-update-bus-id-list.patch
-jdelvare-i2c-i2c-add-ids-to-bus-drivers.patch
-jdelvare-i2c-i2c-ibm_iic-add-parent-device.patch
-jdelvare-i2c-i2c-viapro-add-cx700-support.patch
-jdelvare-i2c-i2c-01-hwmon-drivers-stop-using-i2c_adapterdev.patch
-jdelvare-i2c-i2c-02-i2c-bus-drivers-stop-using-i2c_adapterdev.patch
-jdelvare-i2c-i2c-03-misc-i2c-drivers-stop-using-i2c_adapterdev.patch
-jdelvare-i2c-i2c-04-other-drivers-stop-using-i2c_adapterdev.patch
-jdelvare-i2c-i2c-05-remove-i2c_adapterdev-from-all-i2c-adapters.patch
-jdelvare-i2c-i2c-06-missing-i2c_adapter-parent-devices.patch
-tsl2550-support-i2c-device-driver.patch
-ia64-enable-config_debug_spinlock_sleep.patch
-ia64-alignment-bug-in-ldscript.patch
-ia64-virt_to_page-can-be-called-with-null-arg.patch
-ia64-swiotlb-bug-fixes.patch
-ia64-make-swiotlb-use-bus_to_virt-virt_to_bus.patch
-ia64-swiotlb-cleanup.patch
-ia64-swiotlb-abstraction-eg-for-xen.patch
-ia64-missing-exports-hwsw_sync_.patch
-ia64-enable-swiotlb-only-when-needed.patch
-show_mem-for-ia64-sparsemem-numa.patch
-ia64-add-pci_get_legacy_ide_irq.patch
-ia64-register-memory-ranges-in-a-consistent-manner.patch
-ia64-clean-up-sparsemem-memory_present-calls.patch
-infiniband-fix-for-gregkh-driver-network-device.patch
-infiniband-work-around-gcc-bug-on-sparc64.patch
-ehca-fix-memleak-on-module-unloading.patch
-change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
-config_input_debug-improvements.patch
-search-a-little-harder-for-mkimage.patch
-make-mkcompile_h-use-lang=c-and-lc_all=c-for-cc-v.patch
-add-mailmap-for-proper-git-shortlog-output.patch
-qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
-kbuild-dont-ignore-localversion-files-if-the-path-includes-a.patch
-qconf-relocate-search-command.patch
-qconf-fix-showing-help-info-on-failed-search.patch
-qconf-back-button-behaviour-normalization.patch
-make-help-in-build-tree-doesnt-show-headers_-targets.patch
-kbuild-remove-references-to-deprecated-prepare-all-target.patch
-new-toplevel-target-headers_check_all.patch
-pata_platform-set_mode-fix.patch
-libata-scsi-ata_task_ioctl-should-return-ata-registers-from.patch
-sata_nv-cleanup-adma-error-handling-v2.patch
-sata_nv-cleanup-adma-error-handling-v2-cleanup.patch
-sata_nv-use-adma-for-nodata-commands.patch
-fix-config_sata_sis=y-compile-error.patch
-libata-fix-translation-for-start-stop-unit.patch
-mm-ide-ide-acpi-support-warning-fix.patch
-git-mips-kconfig-fix.patch
-git-mips-prom_free_prom_memory-borkage.patch
-mips-dbg_io-stray-brackets-fix.patch
-mips-turbochannel-update-to-the-driver-model.patch
-mips-turbochannel-update-to-the-driver-model-fix.patch
-mips-turbochannel-support-for-the-decstation.patch
-mips-eisa-registration-with-config_eisa.patch
-mips-declance-driver-model-for-the-pmad-a.patch
-mips-defxx-turbochannel-support.patch
-mips-pmag-ba-fb-convert-to-the-driver-model.patch
-mips-pmagb-b-fb-convert-to-the-driver-model.patch
-mips-dec_esp-driver-model-for-the-pmaz-a.patch
-git-mmc-fixup.patch
-mmc-add-a-quirk-to-allow-ene-pci-sd-card-readers-to-work-again.patch
-mmc-au1xmmc-return-errors-for-unknown-response-types.patch
-mmc-au1xmmc-implement-proper-ro-switch-detection.patch
-mtd_ck804xrom-must-depend-on-pci.patch
-git-netdev-all-atl1-build-fix.patch
-git-netdev-all-atl1-pm-fix.patch
-b44-fix-frequent-link-changes.patch
-spidernet-rework-rx-linked-list.patch
-cxgb3-vs-gregkh-driver-network-device.patch
-net-ifb-error-path-loop-fix.patch
-ucc-ether-driver-kmalloc-casting-cleanups.patch
-broadcom-4400-resume-small-fix-v2.patch
-remove-one-remaining-define-bcm_tso-1.patch
-fs_enet-of-related-fixup-for-fec-and-scc-macs.patch
-82596-warning-fix.patch
-hp100-convert-pci_module_init-to-pci_register_driver.patch
-ehea-fixed-wrong-jumbo-frames-status-query.patch
-ehea-fixed-missing-tasklet_kill-call.patch
-sky2-fix-msi-related-resume-breakage.patch
-user-of-the-jiffies-rounding-code-networking.patch
-net-irda-proper-prototypes.patch
-fix-for-crash-in-adummy_init.patch
-z85230-spinlock-logic.patch
-bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls.patch
-bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls-fix.patch
-net-wanrouter-wanmainc-cleanups.patch
-remove-tcp-header-from-tcp_v4_check-take-2.patch
-slip-replace-kmalloc-memset-pairs-with-the.patch
-remove-unused-kernel-config-option-dlci_count.patch
-dccp-warning-fixes.patch
-netfilter-warning-fix.patch
-nf_conntrack_h323-must-depend-on-ipv6-ipv6=n.patch
-bonding-arp-monitoring-broken-on-x86_64.patch
-r8169-warning-fixes.patch
-8250-uart-backup-timer.patch
-serial-trivial-code-flow-simplification.patch
-make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
-perle-multimodem-card-pci-ras-detection.patch
-serial-replace-kmallocmemset-with-kzalloc.patch
-fix-pnx8550-serial-breakage.patch
-pnx8550-uart-driver.patch
-pnx8550-uart-driver-fixes.patch
-gregkh-pci-pci-check-szhi-when-sz-is-0-when-64-bit-iomem-bigger-than-4g.patch
-gregkh-pci-pci-remove-too-specialized-__pci_enable_device-for-default-resume.patch
-gregkh-pci-pci-move-pci_fixup_device-and-is_enabled.patch
-gregkh-pci-pci-add-extremely-specialized-__pci_reenable_device.patch
-gregkh-pci-pci-add-selected_regions-funcs.patch
-gregkh-pci-pci-define-inline-for-test-of-channel-error-state.patch
-gregkh-pci-pci-use-newly-defined-pci-channel-offline-routine.patch
-gregkh-pci-pci-quirksc-cleanup.patch
-gregkh-pci-pci-remove-pci_find_device_reverse.patch
-gregkh-pci-pci-mark-pci_find_device-as-__deprecated.patch
-gregkh-pci-pciehp-cleanup-init_slot.patch
-gregkh-pci-pciehp-cleanup-slot-list.patch
-gregkh-pci-pciehp-remove-unnecessary-php_ctlr.patch
-gregkh-pci-pciehp-remove-unused-pci_bus-from-struct-controller.patch
-gregkh-pci-pciehp-cleanup-register-access.patch
-gregkh-pci-pciehp-cleanup-pciehph.patch
-gregkh-pci-pciehp-remove-unused-pcie_cap_base.patch
-gregkh-pci-pciehp-cleanup-wait-command-completion.patch
-gregkh-pci-pciehp-fix-wait-command-completion.patch
-gregkh-pci-pciehp-add-electro-mechanical-interlock-support-to-the-pcie-hotplug-driver.patch
-gregkh-pci-shpchp-remove-config_hotplug_pci_shpc_poll_event_mode.patch
-gregkh-pci-shpchp-remove-dbg_xxx_routine.patch
-gregkh-pci-shpchp-delete-trailing-whitespace.patch
-gregkh-pci-pci-quirk-1k-i-o-space-iobl_adr-fix-on-p64h2.patch
-gregkh-pci-pci-speed-up-the-intel-smbus-unhiding-quirk.patch
-gregkh-pci-pci-remove-quirk_sis_96x_compatible.patch
-gregkh-pci-pci-make-isa_bridge-alpha-only.patch
-gregkh-pci-pci-cleanup-msi-code.patch
-gregkh-pci-pci-power-management-remove-noise-on-non-manageable-hw.patch
-gregkh-pci-pci-duplicate-ids-ata_piix.patch
-gregkh-pci-pci-duplicate-ids-ipr.patch
-gregkh-pci-msi-replace-pci_msi_quirk-with-calls-to-pci_no_msi.patch
-gregkh-pci-msi-remove-pci_scan_msi_device.patch
-gregkh-pci-msi-combine-pci__msi-msix_state.patch
-gregkh-pci-msi-abstract-msi-suspend.patch
-make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch
-make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix.patch
-bugfixes-pci-devices-get-assigned-redundant-irqs.patch
-sh-add-kconfig-default.patch
-drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
-scsi-clean-up-warnings-in-advansys-driver.patch
-drivers-scsi-pcmcia-nsp_csh-removal-of-old.patch
-scsi-sic7xxx-stray-bracket-fix.patch
-scsi-53c7xx-brackets-fix.patch
-dac960-kmalloc-kzalloc-casting-cleanups.patch
-drivers-scsi-buslogic-replace-boolean-by-bool.patch
-git-block-fixup.patch
-git-block-borkage.patch
-git-block-atomicity-fix.patch
-gregkh-usb-usb-unusual_devsh-for-sony-floppy.patch
-gregkh-usb-usb-add-epic-support-to-the-io_edgeport-driver.patch
-gregkh-usb-usb-move-usb_device_class-class-devices-to-be-real-devices.patch
-gregkh-usb-usb-convert-usb-class-devices-to-real-devices.patch
-gregkh-usb-usb-rework-the-ohci-quirk-mecanism-as-suggested-by-david.patch
-gregkh-usb-usb-implement-support-for-split-endian-ohci.patch
-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio.patch
-gregkh-usb-usb-fix-ohci-warning.patch
-gregkh-usb-usb-fix-ehci-warning.patch
-gregkh-usb-usb-linux-usb_ch9h-becomes-linux-usb-ch9h.patch
-gregkh-usb-usb-define-usb_class_misc-in-linux-usb-ch9h.patch
-gregkh-usb-usb-remove-unneeded-void-casts-in-idmousec.patch
-gregkh-usb-usb-mutexification-of-rio500.patch
-gregkh-usb-usb-devioc-add-missing-init_list_head.patch
-gregkh-usb-usb-indicate-active-altsetting-in-proc-bus-usb-devices-file.patch
-gregkh-usb-usbcore-remove-unneeded-error-check.patch
-gregkh-usb-usb-ethernet-gadget-interop-with-mcci-windows-driver.patch
-gregkh-usb-rndis_host-learns-activesync-basics.patch
-gregkh-usb-ohci-rework-bus-glue-integration-to-allow-several-at-once.patch
-gregkh-usb-ohci-add-support-for-ohci-controller-on-the-of_platform-bus.patch
-gregkh-usb-usb-serial-add-dynamic-id-support-to-usb-serial-core.patch
-gregkh-usb-usb-serial-add-driver-pointer-to-all-usb-serial-drivers.patch
-gregkh-usb-usb-bugfix-for-aircable-add-module-and-name-to-usb_serial_driver.patch
-gregkh-usb-usb-gadget-file_storagec-remove-unnecessary-casts.patch
-gregkh-usb-usb-add-usb_endpoint_xfer_control-to-usbh.patch
-gregkh-usb-usb-add-binary-api-to-usbmon.patch
-gregkh-usb-usb-race-on-disconnect-in-mdc800.patch
-gregkh-usb-uhci-improved-debugging-checks-for-the-frame-list.patch
-gregkh-usb-uhci-no-dummy-tds-for-iso-qhs.patch
-gregkh-usb-usb-storage-scsi-level-fixes.patch
-gregkh-usb-usb-ohci-at91-refcount-fix-for-irq-wake-enables.patch
-gregkh-usb-usb-gadgetfs-whitespace-cleanup.patch
-gregkh-usb-usb-gadgetfs-remove-delayed-init-mode.patch
-gregkh-usb-usb-power-management-for-kaweth.patch
-gregkh-usb-usb-better-ethtool-support-for-kaweth.patch
-gregkh-usb-usb-ps3-ehci-bus-glue.patch
-gregkh-usb-usb-ps3-controller-hid-quirk.patch
-gregkh-usb-usb-ohci-error-handling-cleanup.patch
-gregkh-usb-usb-ps3-ohci-bus-glue.patch
-gregkh-usb-uhci-fix-bandwidth-allocation.patch
-gregkh-usb-usbcore-remove-unused-bandwith-related-code.patch
-gregkh-usb-ehci-local-variable-for-port-status-register.patch
-gregkh-usb-ehci-don-t-hide-ports-owned-by-the-companion.patch
-gregkh-usb-ehci-force-high-speed-devices-to-run-at-full-speed.patch
-gregkh-usb-usb-at91_udc-wakeup-event-updates.patch
-gregkh-usb-usb-total-removal-of-multithreaded-probing-in-usb.patch
-gregkh-usb-fix-for-bugzilla-7544.patch
-gregkh-usb-usb-race-fixes-for-usb-serial-step-1.patch
-gregkh-usb-usb-race-fixes-for-usb-serial-step-2.patch
-gregkh-usb-usb-race-fixes-for-usb-serial-step-3.patch
-gregkh-usb-usb-gadgetfs-cleanups.patch
-gregkh-usb-usb-gadgetfs-simplifications.patch
-gregkh-usb-usb-gadgetfs-race-fix.patch
-gregkh-usb-usb-gadgetfs-behaves-better-on-userspace-init-bug.patch
-gregkh-usb-usb-gadgetfs-aio-tweaks.patch
-gregkh-usb-usb-list-atmel-husb2_udc-gadget-controller.patch
-gregkh-usb-usb-usb-ethernet-gadget-recognizes-husb2dev.patch
-gregkh-usb-usb-sierra-wireless-auto-set-d0.patch
-gregkh-usb-usb-input-added-kernel-module-to-support-all-gtco-calcomp-usb-interwrite-school-products.patch
-gregkh-usb-usb-autosuspend-for-usb-printer-driver.patch
-gregkh-usb-usb-switch-ehci-hcd-to-new-polling-scheme.patch
-gregkh-usb-ehci-fix-interrupt-driven-remote-wakeup.patch
-gregkh-usb-usb-storage-use-first-bulk-endpoints-not-last.patch
-gregkh-usb-usbcore-trivial-whitespace-fixes.patch
-gregkh-usb-usb-a-bit-more-coding-style-cleanup.patch
-gregkh-usb-usb-duplicate-ids-visor.patch
-gregkh-usb-usb-duplicate-ids-ftdi_sio.patch
-gregkh-usb-usb-duplicate-ids-keyspan.patch
-gregkh-usb-usb-duplicate-ids-usb_storage.patch
-gregkh-usb-berry_charge.patch
-fix-gregkh-usb-usbcore-remove-unused-bandwith-related-code.patch
-fix-gregkh-usb-usb-linux-usb_ch9h-becomes-linux-usb-ch9h.patch
-usb_rtl8150-must-select-mii.patch
-input-hid-add-cidc-usb-device-to-hid-blacklist.patch
-usb-mass-storage-us_fl_ignore_residue-needed-for-aiptek-mp3-player.patch
-fix-misspelled-usbnet_mii-kernel-config-option.patch
-usb-in-init_endpoint_class-use-ptr_err-to-obtain-an-errno-value-not-is_err.patch
-fix-apparent-typo-config_usb_cdcether.patch
-pl2303-willcom-ws002in-support.patch
-use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch
-fix-unaligned-exception-in-drivers-net-wireless-orinococ.patch
-drivers-char-pcmcia-ipwireless_cs_-possible-cleanups.patch
-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
-x86_64-mm-kernel-mode-faults-pollute-current-thead.patch
-x86_64-mm-revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
-x86_64-mm-revert-x86_64-mm-add-genapic_force.patch
-x86_64-mm-revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
-x86_64-mm-optimize-fix-apic-mode-setup.patch
-x86_64-mm-a-memcpy-that-tries-to-reduce-cache-pressure.patch
-x86_64-mm-use-memcpy_uncached_read-in-rdma-interrupt-handler-to-reduce-packet-loss.patch
-x86_64-mm-config_physical_align-limited-to-4m.patch
-x86_64-mm-blink-driver.patch
-x86_64-mm-msr-on-cpu.patch
-x86_64-mm-mtrr-compat.patch
-x86_64-mm-update-disable_io_apic-to-use-8-bit-destination-field.patch
-revert-x86_64-mm-msr-on-cpu.patch
-fix-x86_64-mm-i386-config-core2.patch
-fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
-cleanup-x86_64-mm-vmi-timer.patch
-add-i386-idle-notifier-take-3-fix.patch
-all-transmeta-cpus-have-constant-tscs.patch
-x86-fix-dev_to_node-for-x86-and-x86_64.patch
-math-emu-setcc-avoid-gcc-extension.patch
-i386-adjustments-to-page-table-dump-during-oops-v2.patch
-x86_64-re-add-a-newline-to-restore_context.patch
-geode-support-classic-mediagxm.patch
-arch-i386-kernel-ptracec-trivial-whitespace-cleanup.patch
-i386-kwatch-kernel-watchpoints-using-cpu-debug-registers.patch
-i386-kwatch-kernel-watchpoints-using-cpu-debug-registers-fix.patch
-i386-entrys-end-endproc-annotations.patch
-x86_64-clean-up-sparsemem-memory_present-call.patch
-kexec-update-io-apic-dest-field-to-8-bit-for.patch
-remove-unused-kernel-config-option-x86_xadd.patch
-hpet-avoid-warning-message-livelock.patch
-minor-patch-for-compilation-warning-in-x86_64-signal-code.patch
-x86_64-fix-fs-gs-registers-for-vt-execution.patch
-x86_64-sync-up-probe_roms-with-i386.patch
-i386-add-option-to-show-more-code-in-oops-reports.patch
-use-__u32-in-asm-x86_64-msrh.patch
-xfs-remove-useless-wmb-memory-barrier.patch
-slab-remove-broken-pageslab-check-from-kfree_debugcheck.patch
-slab-cache-alloc-cleanups.patch
-avoid-excessive-sorting-of-early_node_map.patch
-avoid-excessive-sorting-of-early_node_map-tidy.patch
-proc-zoneinfo-fix-vm-stats-display.patch
-typeof-__page_to_pfn-with-sparsemem=y.patch
-page_mkwrite-race-fix.patch
-use-zvc-for-inactive-and-active-counts.patch
-use-zvc-for-inactive-and-active-counts-up-fix.patch
-use-zvc-for-free_pages.patch
-use-zvc-for-free_pages-fix.patch
-use-zvc-for-free_pages-fix-2.patch
-use-zvc-for-free_pages-fix-3.patch
-use-zvc-for-free_pages-fix-4.patch
-reorder-zvcs-according-to-cacheline.patch
-drop-free_pages.patch
-drop-free_pages-fix.patch
-drop-free_pages-sparc64-fix.patch
-drop-nr_free_pages_pgdat.patch
-drop-__get_zone_counts.patch
-drop-get_zone_counts.patch
-get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied.patch
-get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied-fix.patch
-deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
-introduce-config_zone_dma.patch
-optional-zone_dma-in-the-vm.patch
-optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
-optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
-optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs-fix.patch
-optional-zone_dma-in-the-vm-tidy.patch
-optional-zone_dma-for-ia64.patch
-remove-zone_dma-remains-from-parisc.patch
-remove-zone_dma-remains-from-sh-sh64.patch
-set-config_zone_dma-for-arches-with-generic_isa_dma.patch
-zoneid-fix-up-calculations-for-zoneid_pgshift.patch
-make-reading-proc-sys-kernel-cap-bould-not-require.patch
-alpha-increase-percpu_enough_room.patch
-pm-change-code-ordering-in-mainc.patch
-swsusp-change-code-ordering-in-diskc.patch
-swsusp-change-code-order-in-diskc-fix.patch
-swsusp-change-code-ordering-in-userc.patch
-swsusp-change-code-ordering-in-userc-sanity.patch
-swsusp-change-pm_ops-handling-by-userland-interface.patch
-m32r-build-fix-for-processors-without-isa_dsp_level2.patch
-m32r-fix-do_page_fault-and-update_mmu_cache.patch
-m32r-update-defconfig-files-for-v2619.patch
-m32r-fix-kernel-entry-address-of-vmlinux.patch
-m32r-cosmetic-updates-and-trivial-fixes.patch
-m68k-work-around-binutils-tokenizer-change.patch
-uml-console-locking-fixes.patch
-uml-return-hotplug-errors-to-host.patch
-uml-console-whitespace-and-comment-tidying.patch
-uml-lock-the-irqs_to_free-list.patch
-uml-add-locking-to-network-transport-registration.patch
-uml-network-driver-whitespace-and-style-fixes.patch
-uml-watchdog-driver-locking.patch
-uml-watchdog-driver-formatting.patch
-uml-audio-driver-locking.patch
-uml-audio-driver-formatting.patch
-uml-mconsole-locking.patch
-uml-make-two-variables-static.patch
-uml-port-driver-formatting.patch
-uml-kill-a-compilation-warning.patch
-uml-network-driver-locking-and-code-cleanup.patch
-uml-use-list_head-where-possible.patch
-uml-locking-commentary-in-the-random-driver.patch
-uml-mostly-const-a-structure.patch
-uml-chan_userh-formatting-fices.patch
-uml-console-locking-commentary-and-code-cleanup.patch
-uml-fix-previous-console-locking.patch
-uml-locking-comments-in-iomem-driver.patch
-uml-memc-and-physmemc-formatting-fixes.patch
-uml-initialize-a-list-head.patch
-uml-make-time-data-per-cpu.patch
-uml-delete-unused-file.patch
-uml-remove-unused-variable-and-function.patch
-uml-make-signal-handlers-static.patch
-uml-const-a-variable.patch
-uml-remove-code-controlled-by-non-existent-config-option.patch
-uml-add-per-device-queues-and-locks-to-ubd-driver.patch
-uml-locking-fixes-in-the-ubd-driver.patch
-uml-locking-comments-in-memory-and-tempfile-code.patch
-uml-locking-comments-in-startup-code.patch
-uml-style-fixes-in-startup-code.patch
-uml-libc-dependent-code-should-call-libc-directly.patch
-uml-fix-style-violations.patch
-uml-fix-apparent-config_64_bit-typo.patch
-drivers-add-lcd-support-3.patch
-drivers-add-lcd-support-3-Kconfig-fix.patch
-drivers-add-lcd-support-update-4.patch
-drivers-add-lcd-support-update-5.patch
-drivers-add-lcd-support-update6.patch
-drivers-add-lcd-support-update-7.patch
-drivers-add-lcd-support-update-8.patch
-drivers-add-lcd-support-update-9.patch
-drivers-add-lcd-support-workqueue-fixups.patch
-add-retain_initrd-boot-option.patch
-add-retain_initrd-boot-option-tweak.patch
-vt-refactor-console-sak-processing.patch
-sysctl_ms_jiffies-fix-oldlen-semantics.patch
-remove-include-linux-byteorder-pdp_endianh.patch
-9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
-count_vm_events-warning-fix.patch
-char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
-disable-init-initramfsc-updated.patch
-disable-init-initramfsc-updated-fix.patch
-disable-init-initramfsc-architectures.patch
-usr-gen_init_cpioc-support-for-hard-links.patch
-ioc3-ioc4-pci-mem-space-resources.patch
-char-isicom-remove-tty_hangwakeup-bottomhalves.patch
-struct-vfsmount-keep-mnt_count-mnt_expiry_mark-away-from-mnt_flags.patch
-avoid-one-conditional-branch-in-touch_atime.patch
-mxser-remove-ambiguous-redefinition-of-init_work.patch
-make-drivers-char-mxser_newcmxser_hangup-static.patch
-char-isicom-fix-locking-in-isr.patch
-char-isicom-augment-card_reset.patch
-char-isicom-check-card-state-in-isr.patch
-char-isicom-support-higher-rates.patch
-char-isicom-correct-probing-removing.patch
-char-tty_wakeup-cleanup.patch
-kill_pid_info-kill-acquired_tasklist_lock.patch
-lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
-lockdep-more-unlock-on-error-fixes.patch
-lockdep-more-unlock-on-error-fixes-fix.patch
-lockdep-add-graph-depth-information-to-proc-lockdep.patch
-igrab-should-check-for-i_clear.patch
-consolidate-line-discipline-number-definitions-v2.patch
-consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
-consolidate-line-discipline-number-definitions-v2-fix-2.patch
-scrub-non-__glibc__-checks-in-linux-socketh-and-linux-stath.patch
-rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
-drivers-char-vc_screenc-proper-prototypes.patch
-transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
-serial-serial_txx9-driver-update.patch
-relay-add-cpu-hotplug-support.patch
-ext2-skip-pages-past-number-of-blocks-in-ext2_find_entry.patch
-char-mxser_new-mark-init-functions.patch
-char-mxser_new-remove-useless-spinlock.patch
-char-serial167-cleanup.patch
-char-n_r3964-cleanup.patch
-consolidate-default-sched_clock.patch
-pktcdvd-cleanup.patch
-pnp-export-pnp_bus_type.patch
-char-mxser_new-remove-unused-stuff.patch
-char-mxser-obsolete-old-nonexperimental-new.patch
-char-mxser_new-remove-tty_wakeup-bottomhalf.patch
-char-mxser_new-clean-request_irq-call.patch
-doc-isicom-remove-reserved-ioctl-number.patch
-char-mxser_new-alter-locking-in-isr.patch
-char-mxser_new-header-file-cleanup.patch
-char-mxser_new-less-loops-in-isr.patch
-char-mxser_new-fix-twice-resource-releasing.patch
-char-mxser_new-do-not-put-pdev.patch
-char-mxser_new-upgrade-to-1915.patch
-char-mxser_new-upgrade-to-1915-fix.patch
-char-mxser_new-do-not-null-driver_data.patch
-char-mxser_new-lock-count-and-flags.patch
-char-mxser_new-fix-sparse-warning.patch
-aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
-add-taint_user-and-ability-to-set-taint-flags-from-userspace.patch
-add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
-add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2.patch
-char-moxa-remove-unused-allocated-page.patch
-char-moxa-do-not-initialize-global-static.patch
-char-moxa-timers-cleanup.patch
-char-moxa-remove-hangup-bottomhalf.patch
-char-moxa-remove-unused-functions.patch
-char-moxa-devids-cleanup.patch
-char-moxa-use-pci_device.patch
-char-moxa-eliminate-typedefs.patch
-char-moxa-macros-cleanup.patch
-char-moxa-use-del_timer_sync.patch
-char-moxa-remove-moxa_pci_devinfo.patch
-char-moxa-variables-cleanup.patch
-char-moxa-remove-useless-vairables.patch
-char-moxa-pci_probing-prepare.patch
-char-moxa-pci-probing.patch
-docbook-html-generate-chapter-section-level-tocs-for-functions.patch
-docbook-html-correction-of-recursive-a-tags-in-html-output.patch
-export-invalidate_mapping_pages-to-modules.patch
-remove-invalidate_inode_pages.patch
-use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
-fix-sparse-warnings-from-asmnet-checksumh.patch
-add-an-rcu-version-of-list-splicing.patch
-add-an-rcu-version-of-list-splicing-fix.patch
-ipmi-fix-some-rcu-problems.patch
-ipmi-fix-some-rcu-problems-update.patch
-factor-outstanding-i-o-error-handling.patch
-factor-outstanding-i-o-error-handling-tidy.patch
-sync_sb_inodes-propagate-errors.patch
-get-rid-of-double-zeroing-of-allocated-pages.patch
-relax-check-for-aix-in-msdos-partition-table.patch
-msdos-partitions-fix-logic-error-in-aix-detection.patch
-add-const-for-timespecval_compare-arguments.patch
-schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
-sysctl-warning-fix.patch
-proc_misc-warning-fix.patch
-remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
-kernel-doc-allow-a-little-whitespace.patch
-proc-remove-useless-and-buggy-nlink-settings.patch
-sysrq-showblockedtasks-is-sysrq-w.patch
-sysrq-alphabetize-command-keys-doc.patch
-kernel-doc-allow-more-whitespace.patch
-tty-improve-encode_baud_rate-logic.patch
-discuss-a-couple-common-errors-in-kernel-doc-usage.patch
-numerous-fixes-to-kernel-doc-info-in-source-files.patch
-common-compat_sys_sysinfo-v2.patch
-remove-a-couple-final-references-to-obsolete-verify_area.patch
-local_t-documentation.patch
-local_t-documentation-fix.patch
-rtc-framework-driver-for-cmos-rtcs.patch
-rtc-framework-driver-for-cmos-rtcs-fix.patch
-rtc-framework-driver-for-cmos-rtcs-fix-2.patch
-make-bh_unwritten-a-first-class-bufferhead-flag-v2.patch
-make-xfs-use-bh_unwritten-and-bh_delay-correctly.patch
-docbook-add-edd-firmware-interfaces.patch
-kernel-doc-fix-some-odd-spacing-issues.patch
-serial-support-for-new-board.patch
-cleanup-linux-byteorder-swabbh.patch
-ext3-refuse-ro-to-rw-remount-of-fs-with-orphan.patch
-ext4-refuse-ro-to-rw-remount-of-fs-with-orphan.patch
-audit-fix-audit_filter_user_rules-initialization-bug.patch
-raw-dont-allow-the-creation-of-a-raw-device-with-minor-number-0.patch
-sn2-use-static-proc_fops.patch
-sed-s-gawk-awk-scripts-gen_init_ramfssh.patch
-seq_file-conversion-coda.patch
-fix-umask-when-noacl-kernel-meets-extn-tuned-for-acls.patch
-seq_file-conversion-toshibac.patch
-return-enoent-from-ext3_link-when-racing-with-unlink.patch
-return-enoent-from-ext3_link-when-racing-with-unlink-fix.patch
-remove-ext_inc_count-and-_dec_count.patch
-remove-the-last-reference-to-rwlock_is_locked-macro.patch
-consolidate-bust_spinlocks.patch
-extract-and-use-wake_up_klogd.patch
-extend-the-set-of-__attribute__-shortcut-macros.patch
-documentation-rbtreetxt-updated.patch
-buffer-memorder-fix.patch
-remove-final-reference-to-superfluous-smp_commence.patch
-cleanup-include-linux-xattrh.patch
-cleanup-include-linux-reiserfs_xattrh.patch
-replace-regular-code-with-appropriate-calls-to-container_of.patch
-remove-dead-kernel-config-option-aedsp16_mpu401.patch
-remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
-remove-unused-kernel-config-option-zisofs_fs.patch
-remove-unused-kernel-config-option-lcd_device.patch
-remove-unused-kernel-config-option-paride_parport.patch
-order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
-minimize-lockdep_on-off-side-effect.patch
-kprobes-replace-magic-numbers-with-enum.patch
-some-rtc-documentation-updates.patch
-drivers-block-dac960-converted-boolean-to-bool.patch
-mxser-remove-useless-fields.patch
-fix-apparent-typo-config_lockdep_debug.patch
-ext-jbd-layer-function-called-instead-of-fs-specific-one.patch
-highmem-catch-illegal-nesting.patch
-change-constant-zero-to-notify_done-in-ratelimit_handler.patch
-spi-kconfig-fix.patch
-spi-controller-driver-for-omap-microwire.patch
-spi-controller-driver-for-omap-microwire-tidy.patch
-spi-controller-driver-for-omap-microwire-update.patch
-spi-controller-driver-for-omap-microwire-update-fix.patch
-spi-freescale-imx-spi-controller-driver-bis.patch
-spi-add-spi_set_drvdata-and-spi_get_drvdata.patch
-spi-documentation-does-not-need-to-set-drivers-bus_type-field.patch
-spi-remove-return-in-spi_unregister_driver.patch
-spi_bitbang-use-overridable-setup_transfer-method.patch
-spi-cleanup-method-param-becomes-non-const.patch
-add-shared-version-of-apm-emulation.patch
-arm-convert-to-use-shared-apm-emulation.patch
-mips-convert-to-use-shared-apm-emulation.patch
-sh-convert-to-use-shared-apm-emulation.patch
-minix-v3-support.patch
-have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode.patch
-have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode-update.patch
-tty-make-__proc_set_tty-static.patch
-tty-clarify-disassociate_ctty.patch
-tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
-signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
-signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
-pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
-pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
-pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
-tty-update-the-tty-layer-to-work-with-struct-pid.patch
-pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
-pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
-pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
-edac-e752x-bit-mask-fix.patch
-edac-e752x-byte-access-fix.patch
-edac-fix-in-e752x-mc-driver.patch
-edac-add-memory-scrubbing-controls-api-to-core.patch
-edac-add-fully-buffered-dimm-apis-to-core.patch
-gpio-core.patch
-omap-gpio-wrappers.patch
-omap-gpio-wrappers-tidy.patch
-at91-gpio-wrappers.patch
-at91-gpio-wrappers-tidy.patch
-pxa-gpio-wrappers.patch
-sa1100-gpio-wrappers.patch
-s3c2410-gpio-wrappers.patch
-drivers-isdn-pcbit-proper-prototypes.patch
-drivers-isdn-hisax-proper-prototypes.patch
-drivers-isdn-sc-proper-prototypes.patch
-isdn-capi-use-array_size-when-appropriate.patch
-isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
-isdn-rename-some-debugging-macros-to-not-resemble-config.patch
-isdn-rename-debug-option-config_serial_nopause_io.patch
-isdn-remove-defunct-test-emulator.patch
-isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
-drivers-isdn-hardware-eicon-convert-to-generic-boolean-values.patch
-drivers-isdn-hisax-convert-to-generic-boolean-values.patch
 -knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
-knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
-knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
-knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
-knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
-include-linux-nfsd-consth-remove-nfs_super_magic.patch
-ecryptfs-public-key-transport-mechanism.patch
-ecryptfs-public-key-transport-mechanism-fix.patch
-ecryptfs-public-key-packet-management.patch
-ecryptfs-public-key-packet-management-slab-fix.patch
-ecryptfs-xattr-flags-and-mount-options.patch
-ecryptfs-generalize-metadata-read-write.patch
-ecryptfs-generalize-metadata-read-write-fix.patch
-ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
-ecryptfs-encrypted-passthrough.patch
-ecryptfs-convert-f_op-write-to-vfs_write.patch
-ecryptfs-convert-kmap-to-kmap_atomic.patch
-ecryptfs-open-code-flag-checking-and-manipulation.patch
-ecryptfs-add-flush_dcache_page-calls.patch
-ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd.patch
-sched-avoid-div-in-rebalance_tick.patch
-rename-attach_pid-to-find_attach_pid.patch
-attach_pid-with-struct-pid-parameter.patch
-remove-find_attach_pid.patch
-statically-initialize-struct-pid-for-swapper.patch
-explicitly-set-pgid-sid-of-init.patch
-uts-namespace-remove-config_uts_ns.patch
-ipc-namespace-remove-config_ipc_ns.patch
-ipc-namespace-remove-config_ipc_ns-linkage-fix.patch
-ipc-namespace-remove-config_ipc_ns-linkage-fix-fix.patch
-dynamic-kernel-command-line-common.patch
-dynamic-kernel-command-line-alpha.patch
-dynamic-kernel-command-line-arm.patch
-dynamic-kernel-command-line-arm26.patch
-dynamic-kernel-command-line-avr32.patch
-dynamic-kernel-command-line-cris.patch
-dynamic-kernel-command-line-frv.patch
-dynamic-kernel-command-line-h8300.patch
-dynamic-kernel-command-line-i386.patch
-dynamic-kernel-command-line-ia64.patch
-dynamic-kernel-command-line-ia64-fix.patch
-dynamic-kernel-command-line-m32r.patch
-dynamic-kernel-command-line-m68k.patch
-dynamic-kernel-command-line-m68knommu.patch
-dynamic-kernel-command-line-mips.patch
-dynamic-kernel-command-line-parisc.patch
-dynamic-kernel-command-line-powerpc.patch
-dynamic-kernel-command-line-ppc.patch
-dynamic-kernel-command-line-s390.patch
-dynamic-kernel-command-line-sh.patch
-dynamic-kernel-command-line-sh64.patch
-dynamic-kernel-command-line-sparc.patch
-dynamic-kernel-command-line-sparc64.patch
-dynamic-kernel-command-line-um.patch
-dynamic-kernel-command-line-v850.patch
-dynamic-kernel-command-line-x86_64.patch
-dynamic-kernel-command-line-xtensa.patch
-dynamic-kernel-command-line-fixups.patch
-i386-2048-byte-command-line.patch
-x86_64-2048-byte-command-line.patch
-ia64-2048-byte-command-line.patch
-ufs2-write-mount-as-rw.patch
-ufs2-write-inodes-write.patch
-ufs2-write-block-allocation-update.patch
-proper-backlight-selection-for-fbdev-drivers.patch
-fbdev-driver-for-s3-trio-virge.patch
-fbdev-driver-for-s3-trio-virge-cleanups.patch
-remove-broken-video-drivers-v4.patch
-tgafb-switch-to-framebuffer_alloc.patch
-tgafb-fix-copying-overlapping-areas.patch
-tgafb-support-the-directcolor-visual.patch
-tgafb-fix-the-mode-register-setting.patch
-tgafb-module-support-fixes.patch
-tgafb-sync-on-green-support-fixes.patch
-tgafb-fix-the-pci-id-table.patch
-remove-bogus-con_is_present-prototypes.patch
-cyber2010-framebuffer-on-arm-netwinder-fix.patch
-cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
-proper-prototype-for-tosh_smm.patch
-recognize-video=gx1fb-option.patch
-correct-apparent-typo-config_aty_ct-in-aty-video.patch
-remove-555-unneeded-includes-of-schedh.patch
-oss-replace-kmallocmemset-combos-with-kzalloc.patch
-mark-struct-file_operations-const-1.patch
-mark-struct-file_operations-const-2.patch
-mark-struct-file_operations-const-2-fix.patch
-mark-struct-file_operations-const-3.patch
-mark-struct-file_operations-const-4.patch
-mark-struct-file_operations-const-4-fix.patch
-mark-struct-file_operations-const-5.patch
-mark-struct-file_operations-const-6.patch
-mark-struct-file_operations-const-7.patch
-mark-struct-file_operations-const-8.patch
-mark-struct-file_operations-const-9.patch
-mark-struct-inode_operations-const-1.patch
-mark-struct-inode_operations-const-2.patch
-mark-struct-inode_operations-const-3.patch
-mark-struct-super_operations-const.patch
-scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
-scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
-scheduled-removal-of-sa_xxx-interrupt-flags.patch
-scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
-sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
-sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs.patch
-sysctl-sunrpc-remove-unnecessary-insert_at_head-flag.patch
-sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de.patch
-sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
-sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
-sysctl-llc-remove-unnecessary-insert_at_head-flag.patch
-sysctl-ipx-remove-unnecessary-insert_at_head-flag.patch
-sysctl-decnet-remove-unnecessary-insert_at_head-flag.patch
-sysctl-dccp-remove-unnecessary-insert_at_head-flag.patch
-sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
-sysctl-atalk-remove-unnecessary-insert_at_head-flag.patch
-sysctl-xfs-remove-unnecessary-insert_at_head-flag.patch
-sysctl-c99-convert-xfs-ctl_tables.patch
-sysctl-c99-convert-xfs-ctl_tables-fixes.patch
-sysctl-scsi-remove-unnecessary-insert_at_head-flag.patch
-sysctl-md-remove-unnecessary-insert_at_head-flag.patch
-sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
-sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch
-sysctl-cdrom-remove-unnecessary-insert_at_head-flag.patch
-sysctl-cdrom-dont-set-de-owner.patch
-sysctl-move-ctl_pm-into-sysctlh-where-it-belongs.patch
-sysctl-frv-pm-remove-unnecessary-insert_at_head-flag.patch
-sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch
-sysctl-frv-remove-unnecessary-insert_at_head-flag.patch
-sysctl-c99-convert-arch-frv-kernel-pmc.patch
-sysctl-c99-convert-arch-frv-kernel-sysctlc.patch
-sysctl-sn-remove-sysctl-abi-breakage.patch
-sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc.patch
-sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage.patch
-sysctl-mips-au1000-remove-sys_sysctl-support.patch
-sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
-sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
-sysctl-s390-move-sysctl-definitions-to-sysctlh.patch
-sysctl-s390-move-sysctl-definitions-to-sysctlh-fix.patch
-sysctl-s390-remove-unnecessary-use-of-insert_at_head.patch
-sysctl-c99-convert-ctl_tables-in-arch-powerpc-kernel-idlec.patch
-sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch
-sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage.patch
-sysctl-x86_64-remove-unnecessary-use-of-insert_at_head.patch
-sysctl-c99-convert-ctl_tables-in-arch-x86_64-ia32-ia32_binfmtc.patch
-sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc.patch
-sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc.patch
-sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver.patch
-sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
-sysctl-register-the-sysctl-number-used-by-the-arlan-driver.patch
-sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch
-sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc-fix.patch
-sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls.patch
-sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
-sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
-sysctl-register-the-ocfs2-sysctl-numbers.patch
-sysctl-move-init_irq_proc-into-init-main-where-it-belongs.patch
-sysctl-move-utsname-sysctls-to-their-own-file.patch
-sysctl-move-utsname-sysctls-to-their-own-file-fix.patch
-sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
-sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix.patch
-sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
-sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
-sysctl-remove-support-for-ctl_any.patch
-sysctl-remove-support-for-directory-strategy-routines.patch
-sysctl-remove-insert_at_head-from-register_sysctl.patch
-sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
-sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
-sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
-sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch
-sysctl-reimplement-the-sysctl-proc-support.patch
-sysctl-reimplement-the-sysctl-proc-support-fix.patch
-sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
-sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
-sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
-sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix.patch
-sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
-debug-shared-irqs.patch
-debug-shared-irqs-kconfig-fix.patch

 Merged into mainline or a subsystem tree.

+gpio-core-documentation.patch
+build-errors-uevent-with-config_sysfs=n.patch
+mincore-config_swap=n-fix.patch
+mincore-fill-in-results-properly.patch
+mincore-vma-crossing-fix.patch

 A few fixes

+make-aout-executables-work-again.patch

 This is also fixed in the x86_64 tree, differently.

+ifdef-acpi_future_usage-acpi_os_readable.patch

 ACPI fix

+at91-correct-value-for-at91_rstc_key.patch

 ARM fix

+powerpc-rtas-msi-support-fix.patch
+fix-cut-and-paste-breakage-in-arch-powerpc-platforms-pseries-pseriesh.patch
+powerpc-export-of_find_property.patch

 powerpc fixes

+gregkh-driver-driverh-copyright.patch
+gregkh-driver-driver-core-let-request_module-send-a-sys-modules-kmod-uevent.patch
+gregkh-driver-serial-add-pcmcia-ids-for-quatech-dsp-100-dual-rs232-adapter.patch
+gregkh-driver-kobject-kobj-k_name-verification-fix.patch
+gregkh-driver-driver-remove-redundant-kobject_unregister-checks.patch
+gregkh-driver-debugfs-implement-symbolic-links.patch
+gregkh-driver-debugfs-remove-misleading-comments.patch
+gregkh-driver-driver-core-device_add_attrs-cleanup.patch
+gregkh-driver-pcmcia-some-class_device-fallout.patch
+gregkh-driver-driver-core-per-subsystem-multithreaded-probing.patch
+gregkh-driver-powerpc-make-it-compile-for-multithread-change.patch
+gregkh-driver-driver-core-don-t-fail-attaching-the-device-if-it-cannot-be-bound.patch

 driver tree updates

+power-management-no-valid-states-w-o-pm_ops-docs.patch
+power-management-fix-struct-layout-and-docs.patch

 power management tweaks

+saa7134-cleanup.patch
+video4linux-fix-audio-input-for-avertv-go-007.patch

 DVB fixes

+jdelvare-i2c-i2c-04-kill-i2c_adapterclass_dev.patch
+jdelvare-i2c-i2c-05-i2c_adapter-devices-have-no-driver.patch
+jdelvare-i2c-i2c-06-remove-duplicate-i2c-drivers-list.patch
+jdelvare-i2c-i2c-algo-bit-always-send-stop-before-leaving.patch
+jdelvare-i2c-i2c-add-smbus-block-read-emulation.patch
+jdelvare-i2c-i2c-algo-bit-emulate-smbus-block-read.patch

 I2C tree updates

+i2c-tsl2550-support.patch

 i2c device support

+jdelvare-hwmon-hwmon-vt1211-add-probing-of-alternate-config-index-port.patch

 hwmon tree update

+ia64-point-saved_max_pfn-to-the-max_pfn-of-the-entire-system.patch

 ia64 fix

+setstream-param-for-psmouse.patch

 input fix

+sis-warning-fixes.patch
+libata-add-a-host-flag-to-indicate-lack-of-iordy.patch
+add-delay-around-sl82c105_reset_engine-calls.patch
+sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
+sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
+sata_nv-handle-serror-status-indication.patch
+sata-use-null-for-ptrs.patch
+ata-convert-gsi-to-irq-on-ia64.patch
+libata-fix-hopefully-all-the-remaining-problems-with.patch

 ata things

-ide-toshiba-tc86c001-ide-driver-take-2.patch
-ide-toshiba-tc86c001-ide-driver-take-2-fix.patch
-ide-toshiba-tc86c001-ide-driver-take-2-fix-2.patch
-ide-hpt3xx-rework-rate-filtering.patch
-ide-hpt3xx-rework-rate-filtering-tidy.patch
-ide-hpt3xx-print-the-real-chip-name-at-startup.patch
-ide-hpt3xx-switch-to-using-pci_get_slot.patch
-ide-hpt3xx-cache-channels-mcr-address.patch
-ide-hpt3x7-merge-speedproc-handlers.patch
-ide-hpt370-clean-up-dma-timeout-handling.patch
-ide-hpt3xx-init-code-rewrite.patch
-ide-piix-fix-82371mx-enablebits.patch
-ide-piix-tuneproc-fixes-cleanups.patch
-ide-slc90e66-carry-over-fixes-from-piix-driver.patch
-ide-hpt36x-pci-clock-detection-fix.patch
-ide-jmicron-warning-fix.patch
-ide-pdc202xx_new-remove-useless-code.patch
-ide-pdc202xx_-remove-check_in_drive_lists-abomination.patch
-ide-atiixpc-remove-unused-code.patch
-ide-atiixpc-sb600-ide-only-has-one-channel.patch
-ide-atiixpc-add-cable-detection-support-for-ati-ide.patch
-ide-ide-generic-jmicron-has-its-own-drivers-now.patch
-ide-ide-maintainers-entry.patch
-ide-it8213-ide-driver.patch
-ide-it8213-ide-driver-update.patch
-ide-ide-pci-init-tags.patch
-ide-pdc202xx_old-dead-code.patch
-ide-au1xxx-dead-code.patch
-ide-ide-pio-blacklisted.patch
-ide-ide-no-dsc-flag.patch
-ide-trm290-dma-ifdefs.patch
-ide-ide-pci-device-tables.patch
-ide-ide-dev-openers.patch
-ide-hpt366-init-dma.patch
-ide-cs5530-cleanup.patch
-ide-svwks-cleanup.patch
-ide-sis5513-config-xfer-rate.patch
-ide-ide-set-xfer-rate.patch
-ide-ide-use-fast-pio-v2.patch
-ide-ide-io-cleanup.patch
-ide-delkin_cb-ide-driver.patch
-ide-ide-acpi-support.patch
-ide-ide-pnp-exit-fix.patch
-ide-via-ide-update.patch
-ide-it8213-ide-driver-update-fixes.patch
-ide-ide-mmio-flag.patch
-ide-hpt34x-tune-chipset-fix.patch
-ide-ide-fix-pio-fallback.patch
-ide-piix-cleanup.patch
-ide-ide-dma-check-disable-dma-fix.patch
-ide-sgiioc4-ide-dma-check-fix.patch
-ide-ide-set-dma-helper.patch
-ide-ide-dma-off-void.patch
-ide-ide-dma-host-on-void.patch
-ide-ide-fix-dma-masks.patch
-ide-ide-max-dma-mode.patch
-ide-ide-tune-dma-helper.patch

 dropped.

+adjust-legacy-ide-resource-setting-v2.patch
+ide-pci-delkin_cbc-pci_module_init-to-pci_register_driver.patch

 IDE udpates

+git-md-accel-fixes.patch
+git-md-accel-warning-fixes.patch
+git-md-accel-fix.patch

 Fix git-md-accel.patch

+mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch

 UBI tree fix

+user-of-the-jiffies-rounding-code-e1000.patch
+revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
+phy-layer-add-kernel-doc-docbook.patch
+fix-atl1-braino.patch
+net-wan-pc300tooc-pci_module_init-to-pci_register_driver.patch
+ehea-dynamic-add--remove-port.patch
+atl1-drop-net_pci-from-kconfig.patch
+atl1-read-mac-address-from-register.patch
+atl1-remove-unused-define.patch
+atl1-add-l1-device-id-to-pci_ids-then-use-it.patch
+atl1-bump-version-number.patch
+Fabric7-VIOC-driver.patch
+Fabric7-VIOC-driver-fixes.patch
+natsemi-add-support-for-using-mii-port-with-no-phy-update.patch
+natsemi-support-aculab-e1-t1-pmxc-cpci-carrier-cards.patch

 netdev stuff

+atm-use-array_size-macro-when-appropriate.patch
+bugfixes-and-new-hardware-support-for-arcnet-driver.patch

 net things

+git-backlight-sony-fix.patch

 Fix git-backlight.patch for git-acpi driver

+git-ioat-vs-git-md-accel.patch

 Fix git-ioat.patch

-nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems.patch

 Dropped (I think)

-nfs-fix-congestion-control-v4-tweaks.patch

 Folded into nfs-fix-congestion-control-v4.patch

+gregkh-pci-pci-sysfs-kobject-kernel-doc-fixes.patch
+gregkh-pci-pci-pcitxt-fix-__devexit-usage.patch
+gregkh-pci-pci-make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch
+gregkh-pci-pci-pci-devices-get-assigned-redundant-irqs.patch
+gregkh-pci-pci-add-systems-for-automatic-breadth-first-device-sorting.patch
+gregkh-pci-pci-make-pci-device-numa-node-attribute-visible-in-sysfs.patch

 PCI tree updates

+pci-add-systems-for-automatic-breadth-first-device-sorting-update.patch
+x86-fix-dev_to_node-for-x86-and-x86_64.patch

 PCI fixes

+scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
+drivers-scsi-aacraid-cleanups.patch
+drivers-scsi-aic7xxx-convert-to-generic-boolean-values.patch
+drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
+cleanup-variable-usage-in-mesh-interrupt-handler.patch
+fix--confusion-in-fusion-driver.patch
+scsi-megaraid_sas-donot-process-cmds-if-hw_crit_error-is-set.patch
+scsi-megaraid_sas-added-bios_param-in-scsi_host_template.patch
+scsi-megaraid_sas-throttle-io-if-fw-is-busy.patch
+scsi-megaraid_sas-replace-pci_alloc_consitent-with-dma_alloc_coherent-in-ioctl-path.patch
+scsi-megaraid_sas-return-sync-cache-call-with-success.patch
+scsi-megaraid_sas-update-version-and-author-info.patch
+lpfc-add-pci-error-recovery-support.patch

 scsi fixes

+git-block-dupe-definitions.patch
+git-block-xfs-barriers-broke.patch
+block-blk_max_pfn-is-somtimes-wrong.patch

 git-block fixes

+git-unionfs-fixup.patch

 Fix rejects in git-unionfs.

+ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd.patch

 Fix ecryptfs for unionfs changes

+gregkh-usb-ehci-turn-off-remote-wakeup-during-shutdown.patch
+gregkh-usb-berry_charge.patch
+gregkh-usb-usb-in-init_endpoint_class-use-ptr_err-to-obtain-an-errno-value-not-is_err.patch
+gregkh-usb-usb-fix-needless-failure-under-certain-conditions.patch
+gregkh-usb-usb-pl2303-willcom-ws002in-support.patch
+gregkh-usb-usb-teac-hd-35pu-patch-to-unusual_devsh.patch
+gregkh-usb-usb-unusual_devs-update-for-sony-p990i-phone.patch
+gregkh-usb-usb-add-flow-control-to-usb-serial-generic-driver.patch
+gregkh-usb-usb-fix-apparent-typo-config_usb_cdcether.patch
+gregkh-usb-usbcore-small-changes-to-hub-driver-s-suspend-method.patch
+gregkh-usb-ehci-add-debugging-message-to-ehci_bus_suspend.patch
+gregkh-usb-usb-descriptor-structures-have-to-be-packed.patch
+gregkh-usb-usb-fix-error-cleanup-path-in-airprime.patch
+gregkh-usb-usb-fix-concurrent-buffer-access-in-the-hub-driver.patch
+gregkh-usb-usb-asix-fix-endian-issues-in-asix_tx_fixup.patch
+gregkh-usb-usb-fix-autosuspend-race-in-skeleton-driver.patch
+gregkh-usb-usb-storage-indistinguishable-devices-with-broken-and-unbroken-firmware.patch
+gregkh-usb-usb-usb_rtl8150-must-select-mii.patch
+gregkh-usb-usb-input-hid-add-cidc-usb-device-to-hid-blacklist.patch
+gregkh-usb-usb-fix-misspelled-usbnet_mii-kernel-config-option.patch
+gregkh-usb-usb-storage-us_fl_ignore_residue-needed-for-aiptek-mp3-player.patch
+gregkh-usb-usb-use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch
+gregkh-usb-usb-fix-g_serial-small-error.patch
+gregkh-usb-usb-make-usb_iso_packet_descriptorstatus-signed.patch
+gregkh-usb-usb-unconfigure-devices-which-have-config-0.patch
+gregkh-usb-usb-cdc-acm-fix-incorrect-throtteling-make-set_control-optional.patch
+gregkh-usb-usb-quirky-device-for-cdc-acm.patch
+gregkh-usb-usb-kernel-doc-fixes.patch
+gregkh-usb-usb-hid-corec-removes-gtco-calcomp-interwrite-ipanel-pids-from-blacklist.patch
+gregkh-usb-usb-ps3-don-t-call-ps3_system_bus_driver_register-on-other-platforms.patch
+gregkh-usb-usb-change-__init-to-__devinit-for-isp116x_probe.patch
+gregkh-usb-usb-iowarrior.patch
+gregkh-usb-usb_match_device.patch
+gregkh-usb-usb-blacklist.patch

 USB tree updates

+ueagle-atmc-needs-schedh.patch

 USB fix

+before-x86_64-mm-mmconfig-share.patch

 Remove an acpi patch to make the x86_64 tree apply

+x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
+x86_64-mm-mmconfig-share.patch
+x86_64-mm-only-call-unreachable_devices-when-type-1-is-available.patch
+x86_64-mm-detect-and-support-the-e7520-and-the-945g-gz-p-pl.patch
+x86_64-mm-reserve-resources-but-only-when-were-sure-about-them.patch
+x86_64-mm-mmconfig-ioremap.patch
+x86_64-mm-mmconfig-reject-broken-table.patch
+x86_64-mm-mmconfig-cleanup-defines.patch
+x86_64-mm-mmconfig-more-cleanup.patch
+x86_64-mm-mmconfig-unreachable-devices.patch
+x86_64-mm-mmconfig-move-e820-check.patch
+x86_64-mm-profile-pc-badness.patch
+x86_64-mm-kprobe-rpl-fix.patch
+x86_64-mm-vmi-timer-race.patch
+x86_64-mm-paravirt-debug-defaults-off.patch
+x86_64-mm-unexport-supported-pte.patch
+x86_64-mm-fs-gs-clear.patch
+x86_64-mm-iommu-boundary.patch
+x86_64-mm-remove-rom-reservation.patch
+x86_64-mm-define-dma-noncoherent-api-functions.patch
+x86_64-mm-robustify-bad_dma_address-handling.patch
+x86_64-mm-all-transmeta-cpus-have-constant-tscs.patch
+x86_64-mm-avoid-gcc-extension.patch
+x86_64-mm-support-classic-mediagxm.patch
+x86_64-mm-entrys-end-endproc-annotations.patch
+x86_64-mm-clean-up-sparsemem-memory_present-call.patch
+x86_64-mm-remove-unused-kernel-config-option-x86_xadd.patch
+x86_64-mm-update-io-apic-dest-field-to-8-bit-for-xapic.patch
+x86_64-mm-avoid-warning-message-livelock.patch
+x86_64-mm-minor-patch-for-compilation-warning-in-x86_64-signal-code.patch
+x86_64-mm-add-option-to-show-more-code-in-oops-reports.patch
+x86_64-mm-geode-configuration-fixes.patch
+x86_64-mm-survive-having-no-irq-mapping-for-a-vector.patch
+x86_64-mm-fix-gcc-check.patch
+x86_64-mm-paravirt-remove-fastcall.patch
+x86_64-mm-fam10-cpuid.patch
+x86_64-mm-fam10-nmi-watchdog.patch
+x86_64-mm-fix-microcode-warning.patch
+x86_64-mm-i386-fix-transmeta-warning.patch
+x86_64-mm-fails-to-detect-mediagx.patch
+x86_64-mm-aout-no-vdso.patch
+x86_64-mm-compat-epoll-pwait.patch
+x86_64-mm-paravirt-unhandled-fallthrough.patch
+x86_64-mm-move-mce_disabled-to-asm-mceh.patch
+x86_64-mm-rename-cpu_gdt_descr-and-remove-extern-declaration-from-smpbootc.patch
+x86_64-mm-remove-extern-declaration-from-mm-discontigc-put-in-header.patch
+x86_64-mm-pcspeaker-cleanup.patch
+x86_64-mm-mtrr-compat.patch
+x86_64-mm-broken-config_compat_vdso-on-i386.patch
+x86_64-mm-remove-mk-pte-phys.patch
+fix-mtrr-compat-ioctl.patch
+i386-pit_latch_buggy-has-no-effect.patch
+add-an-option-for-the-via-c7-which-sets-appropriate-l1.patch
+i386-adjustments-to-page-table-dump-during-oops-v3.patch
+x86-mtrr-range-check-correction.patch
+x86-consolidate-smp_send_stop.patch
+cleanup-initialize-esp0-properly-all-the-time.patch
+cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
+lguest-preparation-export_symbol_gpl-5-functions.patch
+lguest-preparation-expose-futex-infrastructure.patch
+lguest-kconfig-and-headers.patch
+lguest-the-host-code-lgko.patch
+lguest-guest-code.patch
+lguest-makefile.patch
+lguest-trivial-guest-network-driver.patch
+lguest-trivial-guest-network-driver-fix.patch
+lguest-trivial-guest-console-driver.patch
+lguest-trivial-guest-block-driver.patch
+lguest-documentatation-and-example-launcher.patch

 x86_64 tree updates

+after-before-x86_64-mm-mmconfig-share.patch
+rdmsr_on_cpu-wrmsr_on_cpu.patch
+x86_64-irq-simplfy-__assign_irq_vector.patch
+x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
+i386-modpost-apic-related-warning-fixes.patch

 x86 updates

-spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
-spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch

 Folded into spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch

+vm-invalidate_inode_pages2_range-should-not-exit-early.patch
+use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
+use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch
+make-try_to_unmap-return-a-special-exit-code.patch
+add-pagemlocked-page-state-bit-and-lru-infrastructure.patch
+add-nr_mlock-zvc.patch
+logic-to-move-mlocked-pages.patch
+consolidate-new-anonymous-page-code-paths.patch
+avoid-putting-new-mlocked-anonymous-pages-on-lru.patch
+opportunistically-move-mlocked-pages-off-the-lru.patch

 MM updates

+smaps-extract-pmd-walker-from-smaps-code.patch
+smaps-add-pages-referenced-count-to-smaps.patch
+smaps-add-clear_refs-file-to-clear-reference.patch
+smaps-add-clear_refs-file-to-clear-reference-fix.patch
+smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
+smaps-add-clear_refs-file-to-clear-reference-docs.patch

 Instrumentation for monitoring application's mapped memory usage.

+blackfin-Documentation.patch
+blackfin-arch.patch
+driver_bfin_serial_core.patch

 blackfin arch

+fix-rmmod-read-write-races-in-proc-entries-fix.patch

 Fix this patch again

-replace-highest_possible_node_id-with-nr_node_ids-fix.patch

 Folded into replace-highest_possible_node_id-with-nr_node_ids.patch

+convert-highest_possible_processor_id-to-nr_cpu_ids-fix.patch
+slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch
+filesystem-disk-errors-at-boot-time-caused-by-probe.patch
+allow-access-to-proc-pid-fd-after-setuid.patch
+allow-access-to-proc-pid-fd-after-setuid-fix.patch
+allow-access-to-proc-pid-fd-after-setuid-update.patch
+allow-access-to-proc-pid-fd-after-setuid-update-2.patch
+shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
+fs-fix-__block_write_full_page-error-case-buffer-submission.patch
+ext2-3-4-fix-file-date-underflow-on-ext2-3-filesystems-on-64-bit-systems.patch
+kprobes-list-all-active-probes-in-the-system.patch
+kprobes-list-all-active-probes-in-the-system-fix.patch
+reduce-size-of-task_struct-on-64-bit-machines.patch
+reduce-size-of-task_struct-on-64-bit-machines-fix.patch
+fix-quadratic-behavior-of-shrink_dcache_parent.patch
+mm-shrink-parent-dentries-when-shrinking-slab.patch
+fat-dio-write-fallback-to-normal-buffered.patch
+kconfig-fault_injection-can-be-selected-only-if-lockdep-is-enabled.patch
+pktcdvd-correctly-set-cmd_len-field-in-pkt_generic_packet.patch
+mwave-interesting-flags-savings.patch
+ext-update-documentation.patch
+add-epoll-compat-code-to-kernel-compatc.patch
+add-epoll-compat-code-to-kernel-compatc-tidy.patch
+cfag12864b-fix-crash-when-built-in-and-no-parport.patch
+lockdep-debug_locks-check-after-check_chain_key.patch
+mfd-sm501-core-driver-3.patch
+kernel-doc-include-struct-short-description-in-title.patch
+tty-use-null-for-ptrs.patch
+cdrom-use-unsigned-bitfields.patch
+8250-fix-gcc4-signed-unsigned-mismatch-warning.patch
+update-osdl-linux-foundation-maintainer-addresses.patch
+ppc64-kdump-documentation-update-for-2620.patch
+loosen-dependancy-on-rtc-cmos.patch
+ipmi-add-powerpc-openfirmware-sensing.patch
+ipmi-allow-shared-interrupts.patch
+ipmi-add-new-ipmi-nmi-watchdog-handling.patch
+fs-fix-libfs-data-leak.patch
+fs-fix-nobh-data-leak.patch
+autofs4-header-file-update.patch
+autofs4-fix-another-race-between-mount-and-expire.patch
+autofs4-check-for-directory-re-create-in-lookup.patch
+affs-implement-drop_inode.patch
+genalloc-warning-fixes.patch

 Misc

+factor-outstanding-i-o-error-handling.patch
+factor-outstanding-i-o-error-handling-tidy.patch
+sync_sb_inodes-propagate-errors.patch

 Try to fix IO error handling, not very successfuly.

-tick-management-dyntick--highres-functionality-fix.patch
-tick-management-dyntick--highres-functionality-fix-2.patch

 Folded into other patches

+add-debugging-feature-proc-timer_stat-cleanup.patch

 Tidy add-debugging-feature-proc-timer_stat.patch

+posix-timers-rcu-optimization-for-clock_gettime.patch
+posix-timers-rcu-optimization-for-clock_gettime-fix.patch

 posix-timers speedup

+genirq-do-not-mask-interrupts-by-default.patch
+genirq-remove-irq_disabled.patch
+irq-kernel-doc-fixes.patch
+small-irq-management-simplification.patch

 IRQ management updates

+call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch

 Fix call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch

-workqueue-rework-threads-hotplug-management.patch

 Dropped

+workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
+workqueue-kill-run_scheduled_work.patch
+workqueue-dont-save-interrupts-in-run_workqueue.patch
+workqueue-dont-save-interrupts-in-run_workqueue-update-2.patch
+workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
+workqueue-introduce-cpu_singlethread_map.patch
+workqueue-introduce-workqueue_struct-singlethread.patch
+workqueue-make-init_workqueues-__init.patch
+make-queue_delayed_work-friendly-to-flush_fork.patch
+unify-queue_delayed_work-and-queue_delayed_work_on.patch
+make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch
+ipvs-flush-defense_work-before-module-unload.patch
+slab-shutdown-cache_reaper-when-cpu-goes-down.patch
+unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch

 More workqueue changes

+per-backing_dev-dirty-and-writeback-page-accounting-fix.patch

 Fix per-backing_dev-dirty-and-writeback-page-accounting.patch

+knfsd-nfsd4-fix-non-terminated-string.patch
+knfsd-nfsd4-relax-checking-of-acl-inheritance-bits.patch
+knfsd-nfsd4-simplify-nfsv4-posix-translation.patch
+knfsd-nfsd4-represent-nfsv4-acl-with-array-instead-of-linked-list.patch
+knfsd-nfsd4-fix-memory-leak-on-kmalloc-failure-in-savemem.patch
+knfsd-nfsd4-fix-error-return-on-unsupported-acl.patch
+knfsd-nfsd4-acls-dont-return-explicit-mask.patch
+knfsd-nfsd4-acls-avoid-unnecessary-denies.patch
+knfsd-nfsd4-fix-handling-of-directories-without-default-acls.patch
+knfsd-stop-nfsd-writes-from-being-broken-into-lots-of-little-writes-to-filesystem.patch

 nfsd updates

+ecryptfs-reduce-stack-usage-in-ecryptfs_generate_key_packet_set.patch
+ecryptfs-fix-forgotten-format-specifier.patch

 ecryptfs fixes

+rework-compat_sys_io_submit.patch
+fix-aioh-includes.patch
+fix-access_ok-checks.patch
+make-good_sigevent-non-static.patch
+make-good_sigevent-non-static-fix.patch
+make-__sigqueue_free-and.patch
+aio-completion-signal-notification.patch
+aio-completion-signal-notification-fix.patch
+aio-completion-signal-notification-fixes-and-cleanups.patch
+aio-completion-signal-notification-small-cleanup.patch
+add-listio-syscall-support.patch

 AIO listio support

+sysctl-remove-insert_at_head-from-register_sysctl-fix.patch

 fix -mm-only sched patches

-introduce-and-use-get_task_mnt_ns.patch
-introduce-and-use-get_task_mnt_ns-tweaks.patch
-nsproxy-externalizes-exit_task_namespaces.patch
-nsproxy-externalizes-exit_task_namespaces-fix.patch
-user-namespace-add-the-framework.patch
-user-namespace-add-the-framework-fix.patch
-user-namespace-add-the-framework-fixes.patch
-user-ns-add-user_namespace-ptr-to-vfsmount.patch
-user-ns-add-user_namespace-ptr-to-vfsmount-fixes.patch
-user-ns-hook-permission.patch
-user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
-user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
-user-ns-implement-shared-mounts.patch
-user-ns-implement-shared-mounts-fixes.patch
-user_ns-handle-file-sigio.patch
-user_ns-handle-file-sigio-fix.patch
-user_ns-handle-file-sigio-fix-2.patch
-user-ns-implement-user-ns-unshare.patch
-user-ns-implement-user-ns-unshare-tidy.patch

 Dropped

+rcutorture-use-array_size-macro-when-appropriate.patch
+rcutorture-style-cleanup-avoid-=-null-in-boolean-tests.patch
+rcutorture-remove-redundant-assignment-to-cur_ops-in.patch

 RCU updates

-rcu-preemptible-rcu-fix.patch

 Folded into rcu-preemptible-rcu.patch

-rcu-debug-trace-for-rcu-fix.patch
-rcu-debug-trace-for-rcu-fix-2.patch
-rcu-trivial-fixes.patch

 Folded into rcu-debug-trace-for-rcu.patch

+revert-x86_64-mm-putreg-check.patch

 Prepare for utrace

+utrace-utrace-tracehook.patch
+utrace-utrace-tracehook-ia64.patch
+utrace-utrace-tracehook-sparc64.patch
+utrace-utrace-tracehook-s390.patch
+utrace-utrace-regset.patch
+utrace-utrace-regset-ia64.patch
+utrace-utrace-regset-sparc64.patch
+utrace-utrace-regset-s390.patch
+utrace-utrace-core.patch
+utrace-utrace-ptrace-compat.patch
+utrace-utrace-ptrace-compat-ia64.patch
+utrace-utrace-ptrace-compat-sparc64.patch
+utrace-utrace-ptrace-compat-s390.patch

 utrace tree

+utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch

 Fix it.

+atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
+atomich-complete-atomic_long-operations-in-asm-generic.patch
+atomich-i386-type-safety-fix.patch
+atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
+atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
+atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
+atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
+atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
+atomich-add-atomic64_xchg-to-s390.patch
+atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
+atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
+local_t-architecture-independant-extension.patch
+local_t-alpha-extension.patch
+local_t-i386-extension.patch
+local_t-ia64-extension.patch
+local_t-mips-extension.patch
+local_t-parisc-cleanup.patch
+local_t-powerpc-extension.patch
+local_t-powerpc-extension-fix.patch
+local_t-s390-cleanup.patch
+local_t-sparc64-cleanup.patch
+local_t-x86_64-extension.patch

 atomic_t and local_t work

+linux-kernel-markers-kconfig-menus.patch
+linux-kernel-markers-architecture-independant-code.patch
+linux-kernel-markers-powerpc-optimization.patch
+linux-kernel-markers-i386-optimization.patch
+linux-kernel-markers-non-optimized-architectures.patch

 Linux Kenrel Markers

+readahead-partial-sendfile-fix.patch

 Fix readahead patches in -mm.

+reiser4-vs-git-block3.patch

 Fix reiser4 for git-block

+drivers-mdc-use-array_size-macro-when-appropriate.patch

 MD cleanup

+ia64-enable-config_debug_spinlock_sleep.patch
+keep-track-of-network-interface-renaming.patch

 debug things

+git-gccbug-fixup.patch

 Fix rejects in git-gccbug.patch



All 887 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm1/patch-list


