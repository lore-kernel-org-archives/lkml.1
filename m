Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYAQKfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYAQKfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 05:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbYAQKfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 05:35:04 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752AbYAQKfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 05:35:00 -0500
Date: Thu, 17 Jan 2008 02:35:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc8-mm1
Message-Id: <20080117023514.9df393cf.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/

- selinux is busted on one of my two selinux-enabled test machines.

- suspend-to-ram and suspend-to-disk are totally hosed on one of my test
  machines.  I guess I get to bisect this.

- git-nfsd is dropped due to conflicts with git-nfs

- git-newsetup is dropped due to conflicts with git-x86 (I think)

- git-perfmon is dropped due to conflicts with git-x86 (I think)

- git-kgdb is dropped due to conflicts with git-damn-near-everything

- git-block is dropped due to conflicts with the IDE tree

- kvm probably doesn't work properly because I couldn't be bothered fixing
  the conflicts between git-kvm and the driver tree

- the volume of rejects and build errors which are caused by subsystem
  maintainers fiddling with other people's stuff is quite out of control. 
  Something needs to happen here.



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



Changes since 2.6.24-rc6-mm1:


 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-arm.patch
 git-audit-master.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-powerpc.patch
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
 git-net.patch
 git-netdev-all.patch
 git-backlight.patch
 git-battery.patch
 git-nfs.patch
 git-ocfs2.patch
 git-selinux.patch
 git-s390.patch
 git-sched.patch
 git-sh.patch
 git-scsi-misc.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-x86.patch
 git-xfs.patch
 git-cryptodev.patch
 git-xtensa.patch

 git trees

-quicklists-do-not-release-off-node-pages-early.patch
-ecryptfs-fix-string-overflow-on-long-cipher-names.patch
-fix-computation-of-skb-size-for-quota-messages.patch
-dont-send-quota-messages-repeatedly-when-hardlimit-reached.patch
-ecryptfs-fix-unlocking-in-error-paths.patch
-ecryptfs-redo-dgetmntget-on-dentry_open-failure.patch
-maintainers-mailing-list-archives-are-web-links.patch
-ps3-vuart-fix-error-path-locking.patch
-lib-proportion-fix-underflow-in-prop_norm_percpu.patch
-pcmcia-remove-pxa2xx_lubbock-build-warning.patch
-kconfig-obey-kconfig_allconfig-choices-with-randconfig.patch
-fix-crash-with-flat_memory-and-arch_pfn_offset-=-0.patch
-hfs-handle-more-on-disk-corruptions-without-oopsing.patch
-hfs-handle-more-on-disk-corruptions-without-oopsing-fix.patch
-tty-fix-logic-change-introduced-by-wait_event_interruptible_timeout.patch
-rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
-sound-usb-usbaudioc-fix-build-with-config_pm=n.patch
-kernel-auditc-warning-fix.patch
-kernel-compliment-va_copy-with-va_end.patch
-jdelvare-i2c-i2c-omap-fix-reset-on-error.patch
-jdelvare-i2c-i2c-spelling-fixes.patch
-jdelvare-i2c-i2c-id-document-optional.patch
-hp6xx-hp7xx-clean-up-drivers-input-keyboardtouchscreen-kconfigs.patch
-input-handle-ev_pwr-in-input_set_capability.patch
-kconfig-use-getopt-in-confc-for-handling-command-line.patch
-git-libata-all-fix-pata_winbond-borkage.patch
-git-libata-all-wtf.patch
-libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
-libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch
-libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
-libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
-ide-mm-ide-spelling-fixes.patch
-ide-mm-ide-cd-fix-samsung-cd-rom-scr-3231-quirk.patch
-ide-mm-ide-cd-fix-acer-aopen-24x-cdrom-speed-reporting-on-big-endian-machines.patch
-ide-mm-ide-cd-use-ide_cd_release-in-ide_cd_probe.patch
-ide-mm-ide-cd-fix-error-messages-in-cdrom_read-write_check_ireason.patch
-ide-mm-ide-cd-add-missing-ireason-masking-to-cdrom_write_intr.patch
-ide-mm-ide-cd-fix-error-messages-in-cdrom_write_intr.patch
-ide-mm-ide-cd-add-error-message-for-dma-error-to-cdrom_read_intr.patch
-ide-mm-ide-cd-fix-error-message-in-cdrom_pc_intr.patch
-ide-mm-ide-cd-fix-ireason-reporting-in-cdrom_pc_intr.patch
-ide-mm-ide-cd-remove-struct-atapi_capabilities_page.patch
-backlight-omap1-backlight-driver.patch
-nfs-stop-sillyname-renames-and-unmounts-from-racing-2.patch
-nfs-fix-up-problems-with-steves-sillyrename-fix.patch
-nfs-fix-nfs_free_unlinkdata.patch
-gregkh-pci-pci-add-pci-quirk-function-for-some-chipsets.patch
-git-sched-fix-preempt-rcu-on-non-preemptible-architectures.patch
-scsi-qla2xxx-qla_osc-section-fix.patch
-scsi-megaraidc-__devexit-annotation.patch
-gregkh-usb-usb-unbreak-fsl_usb2_udc.patch
-gregkh-usb-usb-vid-pid-update-for-sierra.patch
-gregkh-usb-usb-new-device-id-for-the-cp2101-driver.patch
-gregkh-usb-usb-update-pxa27x-ohci-driver-to-use-clk-support.patch
-add-support-for-sb1-hardware-watchdog.patch
-watchdog-use-sgi_has_indydog-for-indydog-depends.patch
-git-x86-arch-x86-math-emu-errorsc-fix-printk-warnings.patch
-git-x86-drivers-pnp-pnpbios-bioscallsc-build-fix.patch
-git-x86-export-leave_mm.patch
-arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5.patch
-arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes.patch
-arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes-checkpatch-fixes.patch
-drm-i915-fix-oops-after-killing-x.patch
-usbtouchscreen-fix-buffer-overflow-make-more-egalax-work-checkpatch-fixes.patch
-fix-rtc_aie-with-config_hpet_emulate_rtc.patch
-cpufreq-initialise-default-governor-before-use.patch
-arch-cris-arch-v10-vmlinuxldss-fix-boot-problem.patch
-a-few-corrections-to-include-linux-kbuild.patch
-add-dma-engine-driver-for-freescale-mpc85xx-processors.patch
-add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch
-add-dma-engine-driver-for-freescale-mpc85xx-processors-fix-fix.patch
-modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch

 Merged into mainline or a subsystem tree

+cpufreq-initialise-default-governor-before-use.patch
+hfs-fix-coverity-found-null-deref.patch
+address-hfs-on-disk-corruption-robustness-review-comments.patch
+address-hfs-on-disk-corruption-robustness-review-comments-checkpatch-fixes.patch
+pnpacpi-print-resource-shortage-message-only-once-more.patch
+cris-v10-vmlinuxldss-fix-kernel-oops-on-boot-and-use-common-defines.patch
+mm-fix-section-mismatch-warning-in-page_allocc.patch
+jbd-do-not-try-lock_acquire-after-handle-made-invalid.patch
+alpha-fix-conversion-from-denormal-float-to-double.patch
+ifdef-very-expensive-debug-check-in-page-fault-path.patch
+fix-radeonfb-regression-with-xpress-200m-5955.patch
+revert-local_t-documentation-update.patch
+fix-unbalanced-helper_lock-in-kernel-kmodc.patch

 2.6.24 queue

+acpi-ignore-acpi-video-devices-that-arent-present-in-hardware.patch
+acpi-ignore-acpi-video-devices-that-arent-present-in-hardware-checkpatch-fixes.patch

 ACPI fixes

+git-alsa-disable-sound-pci-ice1712-ice1724c.patch

 ALSA workaround

+intel_agp-add-new-chipset-ids.patch
+intel_agp-add-new-chipset-ids-checkpatch-fixes.patch

 agp device support

+git-audit-printk-warning-fix.patch

 Fix git-audit-master.patch

+drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch

 cpufreq fix

+agk-dm-dm-add-missing-memory-barrier-to-dm_suspend.patch
+agk-dm-dm-table-use-uninitialized_var.patch
+agk-dm-dm-ioctl-use-uninitialized_var.patch
+agk-dm-dm-tidy-alloc_dev-labels.patch
+agk-dm-dm-refactor-deferred-bio_list-processing.patch
+agk-dm-dm-tidy-dm_suspend.patch
+agk-dm-dm-split-dm_suspend-io_lock-hold-into-two.patch
+agk-dm-dm-refactor-dm_suspend-completion-wait.patch
+agk-dm-dm-targets-no-longer-experimental.patch
+agk-dm-dm-mpath-add-missing-static.patch
+agk-dm-dm-crypt-add-async-request-mempool.patch
+agk-dm-dm-crypt-add-completion-for-async.patch
+agk-dm-dm-crypt-prepare-async-callback-fn.patch
+agk-dm-dm-crypt-use-async-crypto.patch
+agk-dm-dm-move-deferred-bio-flushing-to-workqueue.patch
+agk-dm-dm-log-auto-load-modules.patch
+agk-dm-dm-stripe-trigger-event-on-failure.patch
+agk-dm-dm-stripe-enhanced-status-return.patch
+agk-dm-dm-loop.patch

 device mapper tree updates

+revert-agk-dm-dm-loop.patch

 Drop this - filp_open gets removed by another patch and breaks it.

+git-powerpc-fixup.patch

 Fix git conflicts in git-powerpc.patch

+arch-powerpc-platforms-pseries-add-missing-of_node_put.patch
+arch-powerpc-sysdev-add-missing-of_node_put.patch
+arch-powerpc-platforms-82xx-add-missing-of_node_put.patch

 powerpc stuff

 #GREGKH-DRIVER-START
+gregkh-driver-chinese-add-the-known_regression-uri-to-the-howto.patch
+gregkh-driver-chinese-rephrase-english-introduction-in-howto.patch
+gregkh-driver-chinese-change-man-pages-maintainer-address-in-howoto.patch
+gregkh-driver-chinese-add-translation-of-submittingpatches.patch
+gregkh-driver-chinese-add-translation-of-submittingdrivers.patch
+gregkh-driver-chinese-add-translation-of-oops-tracingtxt.patch
+gregkh-driver-chinese-add-translation-of-stable_kernel_rulestxt.patch
+gregkh-driver-chinese-add-translation-of-volatile-considered-harmfultxt.patch
+gregkh-driver-chinese-add-translation-of-sparsetxt.patch
+gregkh-driver-chinese-add-translation-of-codingstyle.patch
+gregkh-driver-sysfs-fix-a-copy-n-paste-typo-in-comment.patch
+gregkh-driver-modules-remove-unneeded-release-function.patch
+gregkh-driver-sysfs-make-sysfs_deprecated-depend-on-sysfs.patch
+gregkh-driver-driver-core-fix-build-with-sysfs-n.patch

 Driver tree updates

+revert-gregkh-driver-atm-convert-struct-class_device-to-struct-device.patch

 Drop a patch which conflicts with other trees

+pm-acquire-device-locks-on-suspend-rev-3.patch
+pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
+pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes-2.patch

 PM stuff

+gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch

 driver tree fix

+drm-convert-from-nopage-to-fault.patch
+drm-convert-from-nopage-to-fault-checkpatch-fixes.patch
+drm-i915-fix-oops-after-killing-x.patch

 DRM things

+drivers-media-dvb-frontends-xc5000c-dont-return-garbage-from-xc5000_init.patch
+drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
+git-dvb-fix-drivers-media-video-bt8xx-bttv-driverc-build.patch

 DVB fixes

+jdelvare-i2c-ixp4xx-i2c-gpio.patch
+jdelvare-i2c-i2c-sibyte-remove-bus-scan-parameter.patch
+jdelvare-i2c-i2c-transfer-support-atomic.patch
+jdelvare-i2c-i2c-pxa-add-polling-transfer.patch

 I2C tree updates

+oz99x-i2c-button-and-led-support-driver-update.patch

 Update oz99x-i2c-button-and-led-support-driver.patch

+i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
+i2c-isp1301_omap-new-style-i2c-driver-updates-part-2.patch

 New i2c driver

+hwmon-new-chip-driver-for-ti-ads7828-a-d.patch
+hwmon-new-chip-driver-for-ti-ads7828-a-d-checkpatch-fixes.patch
+hwmon-new-chip-driver-for-ti-ads7828-a-d-update.patch

 New hwmon driver

 (why are these things in my tree??)

+git-infiniband-fix-build-with-config_infiniband_ipoib_cm=n.patch

 Fix git-infiniband.

-wistron_btns-add-support-for-x86_64-systems.patch

 Dropped.

+drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch

 input fix

-kvm-ist-kaput.patch

 Unneeded (but it's probably still kaput)

-git-lblnet-fixup.patch

 Unneeded

+ide-mm-ide-cd-remove-struct-atapi_capabilities_page-take-2.patch
+ide-mm-ide-add-ide_dump_identify-debug-helper.patch
+ide-mm-ide-floppy-tape-remove-debug-code-for-dumping-identify-data.patch
+ide-mm-ide-cd-move-the-remaining-cdrom-c-ioctl-handling-code-to-ide-cd_ioctl-c-v2.patch
+ide-mm-trm290-cannot-call-ide_setup_dma.patch
+ide-mm-ide-ide_setup_dma-assumes-8-ports.patch
+ide-mm-amd74xx-remove-amd_ide_chips-table.patch
+ide-mm-ide-add-ide_hflag_clear_simplex-host-flag.patch
+ide-mm-ide-add-ide_hflag_no_dsc-host-flag.patch
+ide-mm-piix-remove-stale-comments.patch
+ide-mm-ide-fix-ide_intr-for-non-pci-devices-and-config_blk_dev_idepci-y.patch
+ide-mm-ide-remove-bug_on-from-ide_build_sglist.patch
+ide-mm-ide-use-ide_destroy_dmatable-instead-of-pci_unmap_sg.patch
+ide-mm-ide-keep-pointer-to-struct-device-instead-of-struct-pci_dev-in-ide_hwif_t.patch
+ide-mm-au1xxx-ide-use-hwif-dev.patch
+ide-mm-icside-use-hwif-dev.patch
+ide-mm-ide-switch-to-dma-mapping-api.patch
+ide-mm-ide-use-ide_build_sglist-and-ide_destroy_dmatable-in-non-pci-host-drivers.patch
+ide-mm-au1xxx-ide-device-tree-bugfix.patch
+ide-mm-ide-pmac-macio-resource-freeing-bugfix.patch
+ide-mm-au1xxx-ide-rapide-use-hwif-index-for-ide_unregister.patch
+ide-mm-ide-delete-filenames-versions-from-comments.patch
+ide-mm-ide-update-add-my-copyrights.patch
+ide-mm-ide-floppy-cleanup-header.patch
+ide-mm-ide-dont-include-linux-hdsmart-h.patch
+ide-mm-linux-hdsmart-h-is-not-used-by-kernel-code.patch
+ide-mm-ide-fix-handling-of-busy-io-resources-in-probe_hwif.patch
+ide-mm-ide-move-wait_hwif_ready-documentation-in-the-right-place.patch
+ide-mm-ide-remove-hwif-present-manipulations-from-hwif_init.patch
+ide-mm-ide_platform-remove-struct-hwif_prop.patch
+ide-mm-ide-remove-unused-ide_hwgroup_t-fields.patch
+ide-mm-ide-remove-needless-zeroing-of-hwgroup-fields-from-init_irq.patch
+ide-mm-ide-cleanup-ide_system_bus_speed.patch
+ide-mm-ide-io-resources-are-released-too-early-in-ide_unregister.patch
+ide-mm-ide-factor-out-code-removing-port-from-hwgroup-from-ide_unregister.patch
+ide-mm-ide-prepare-init_irq-for-using-ide_remove_port_from_hwgroup.patch
+ide-mm-ide-use-ide_remove_port_from_hwgroup-in-init_irq.patch
+ide-mm-ide-make-probe_hwif-return-an-error-value.patch
+ide-mm-ide-move-handling-of-io-resources-out-of-ide_probe_port.patch
+ide-mm-ide-factor-out-code-for-tuning-devices-from-ide_probe_port.patch
+ide-mm-ide-move-hwif_register-call-out-of-ide_probe_port.patch
+ide-mm-dtc2278-fix-io_32bit-handling.patch
+ide-mm-au1xxx-ide-fix-io_32bit-handling.patch
+ide-mm-atiixp-cs5535-scc_pata-fix-idex-ata66-parameter-handling.patch
+ide-mm-macide-remove-drive-capacity64-quirk.patch
+ide-mm-ide-always-set-dma-masks-in-ide_pci_setup_ports.patch
+ide-mm-ide-separate-pci-specific-init-from-generic-init-in-ide_pci_setup_ports.patch
+ide-mm-ide-add-struct-ide_port_info-instances-to-legacy-host-drivers.patch
+ide-mm-ide-add-cable-detect-method-to-ide_hwif_t.patch
+ide-mm-ide-remove-needless-includes-from-pci-host-drivers.patch
+ide-mm-ide-floppy-convert-to-generic-packet-commands.patch
+ide-mm-ide-floppy-replace-ntoh-s-l-and-hton-s-l-calls-with-the-generic-byteorder.patch
+ide-mm-ide-floppy-remove-unnecessary-handler-ne-null-check.patch
+ide-mm-ide-floppy-disambiguate-function-names.patch
+ide-mm-ide-floppy-include-the-proper-headers.patch
+ide-mm-ide-floppy-cleanup-and-unify-debugging-macro-calls.patch
+ide-mm-ide-floppy-remove-struct-idefloppy_capabilities_page.patch
+ide-mm-ide-floppy-remove-struct-idefloppy_inquiry_result.patch
+ide-mm-ide-floppy-remove-struct-idefloppy_request_sense_result.patch
+ide-mm-ide-floppy-remove-struct-idefloppy_mode_parameter_header.patch
+ide-mm-ide-floppy-remove-struct-idefloppy_flexible_disk_page.patch
+ide-mm-ide-floppy-remove-struct-idefloppy_capacity_descriptor.patch
+ide-mm-ide-floppy-factor-out-ioctl-handlers-from-idefloppy_ioctl.patch
+ide-mm-ide-floppy-report-dma-handling-in-idefloppy_pc_intr-properly.patch
+ide-mm-ide-floppy-mv-idefloppy_-should_-report_error.patch
+ide-mm-ide-floppy-remove-idefloppy_debug_bugs-macro.patch
+ide-mm-ide-floppy-use-an-xfer_func_t-and-io_buf_t-typedefs-in-order-to-unify-rw.patch
+ide-mm-ide-floppy-merge-idefloppy_-input-output-_buffers.patch
+ide-mm-ide-floppy-remove-unused-idefloppy_use_read12.patch
+ide-mm-ide-floppy-remove-idefloppy_debug_info.patch

 IDE tree updates

+fix-ide-mm-ide-use-ide_destroy_dmatable-instead-of-pci_unmap_sg.patch
+drivers-ide-ide-acpic-fix-uninitialized-var-warning.patch
+drivers-ide-legacy-hdc-fix-uninitialized-var-warning.patch

 Fix it

+memstick-initial-commit-for-sony-memorystick-support.patch
+memstick-initial-commit-for-sony-memorystick-support-fix.patch
+memstick-initial-commit-for-sony-memorystick-support-fix-2.patch

 Memory stick driver

+fix-misparenthesization-introduced-by-commit-78b65179d08e7e4466ba69d5ede85035a2c96358.patch
+drivers-mtd-ubi-wlc-fix-uninitialized-var-warning.patch
+drivers-mtd-ubi-scanc-fix-uninitialized-var-warning.patch
+drivers-mtd-ubi-cdevc-unused-var.patch

 MTD fixes

-git-net-fixup.patch

 Unneeded

+git-net-fix-conflicts.patch

 Fix git conflicts in git-net

+git-netdev-all-fix-conflicts.patch

 Fix git conflicts in git-netdev-all

+git-netdev-all-fix-conflicts-fix.patch

 And fix the fix

+net-sunrpc-schedc-revert-git-net-changes.patch
+net-sunrpc-schedc-reapply-git-net-changes.patch

 futz around to make git-nfs apply

+at91_cf-use-generic-gpio-calls.patch
+drivers-pcmcia-add-missing-iounmap.patch
+drivers-pcmcia-add-missing-pci_dev_get.patch

 pcmcia things

+avoid-waking-up-closed-serial-ports-on-resume.patch
+serial-avoid-stalling-suspend-if-serial-port-wont-drain.patch
+serial-speed-setup-failure-reporting.patch
+serial-coding-style.patch

 serial driver things

+gregkh-pci-pci-remove-pci_enable_device_bars-from-documentation.patch
+gregkh-pci-pciehp-wait-for-1000ms-before-led-operation-after-power-off.patch
+gregkh-pci-pciehp-workaround-against-bad-dllp-during-power-off.patch
+gregkh-pci-pciehp-block-new-requests-from-the-device-before-power-off.patch
+gregkh-pci-pci-convert-drivers-pci-procc-to-use-unlocked_ioctl.patch
+gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch

 PCI tree updates

+revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages.patch
+fix-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch

 Fix it.

+quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
+quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch

 nvidia PCI fix

+x86-validate-against-acpi-motherboard-resources.patch

 PCI thing

+git-scsi-misc-vs-gregkh-pci-pci-remove-users-of-pci_enable_device_bars.patch

 Fix yet another subsystem smashup

+scsi-arcmsr-updates-1200015.patch
+drivers-scsi-dc395xc-fix-uninitialized-var-warning.patch

 scsi things

-scsi-scsi_data_buffer.patch
-scsi-bidi-support.patch

 I was told to drop these

+powerpc-export-copy_page-on-32bit.patch

 For unionfs

+gregkh-usb-usb-keyspan-fix-oops.patch
+gregkh-usb-usb-gadget-fix-fsl_usb2_udc-potential-oops.patch
+gregkh-usb-usb-cp2101-new-device-ids.patch
+gregkh-usb-usb-add-support-for-4348-5523-winchiphead-usb-rs-232-adapter.patch
+gregkh-usb-usb-sierra-add-support-for-aircard-881u.patch
+gregkh-usb-usb-adding-yc-cable-usb-serial-device-to-pl2303.patch
+gregkh-usb-usb-sierra-driver-add-devices.patch
+gregkh-usb-usb-correct-comments-in-usb-core-notifyc.patch
+gregkh-usb-usb-ftdi_sio-enabling-multiple-elv-devices-adding-em1010pc.patch
+gregkh-usb-usb-ftdi-sio-patch-to-add-vendor-device-id-for-atk_16ic-ccd.patch
+gregkh-usb-usb-use-gfp_noio-in-reset-path.patch
+gregkh-usb-usb-mos7720-clean-up-termios.patch
+gregkh-usb-usb-ti_usb-termios-cleanups.patch
+gregkh-usb-usb-io_ti-clean-up-termios-handling.patch
+gregkh-usb-usb-ftdi_sio-support-for-more-jtag-adaptors.patch
+gregkh-usb-usb-sierra-driver-add-update-dtr-logic.patch
+gregkh-usb-usb-export-suspend-statistics.patch
+gregkh-usb-usb-ohci-at91-uses-generic-gpio-calls.patch
+gregkh-usb-usb-at91_udc-uses-generic-gpio-calls-minor-cleanup.patch
+gregkh-usb-usb-pxa2xx_udc-use-debugfs-not-procfs.patch
+gregkh-usb-usb-add-ehci-ppc-of-bus-glue.patch
+gregkh-usb-usb-misc-legousbtower-semaphore-to-mutex.patch
+gregkh-usb-usb-add-ehci-ixp-bus-glue.patch
+gregkh-usb-usb-ehci-saves-some-memory-in-iso-transfer-descriptors.patch
+gregkh-usb-usb-ehci-minor-iso-updates-always-support-split-iso.patch
+gregkh-usb-usb-ehci-completes-high-speed-iso-urbs-sooner.patch
+gregkh-usb-usb-usbfs-struct-async-is-a-fixed-size-structure.patch
+gregkh-usb-usb-ehci-move-del_timer_sync-calls-outside-spinlocked-region.patch
+gregkh-usb-usb-ehci-add-a-short-delay-to-the-bus_suspend-routine.patch

 USB tree updates

+fix-gregkh-usb-usb-ti_usb-termios-cleanups.patch

 Fix it

+usb-make-usb_storage_onetouch-available-with-pm.patch
+drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch

 USB stuff

+wdt-fix-locking.patch
+wdt-fix-locking-checkpatch-fixes.patch

 Watchdog fixes

+iwlwifi-fix-typo-in-drivers-net-wireless-iwlwifi-kconfig.patch
+hostap-section-mismatch-warning.patch
+ssb-add-ssb_pcihost_set_power_state-function.patch
+b44-power-down-phy-when-interface-down.patch
+drivers-net-wireless-iwlwifi-iwl-3945c-fix-printk-warning.patch
+drivers-net-wireless-iwlwifi-iwl-4965c-fix-printk-warning.patch
+drivers-net-wireless-rt2x00-rt2x00usbc-fix-uninitialized-var-warning.patch

 wireless stuff

+revert-kvm-stuff-to-make-git-x86-apply.patch

 futz around with yet another subsystem tree wreck.

+git-x86-fixup-2.patch

 Fix git conflicts

+acpi-default-unmap-fixpatch.patch

 fix ia64 build

+git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch

 More patch intersections

+pci-dont-load-acpi_php-when-acpi-is-disabled-fix.patch

 PCI patch which was in the x86 tree and now isn't.  Needs to go into the PCI
 tree

+iommu-sg-add-iommu-helper-functions-for-the-free-area-management-update.patch

 Update iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch

+keyspan-fix-oops.patch
+sky2-wake-on-lan-configuration-issues.patch

 Might be 2.6.24 stuff

+include-count-of-pagecache-pages-in-show_mem-output.patch
+check-advice-of-fadvice64_64-even-if-get_xip_page-is-given.patch

 MM updates

-uml-runtime-detection-of-host-vmsplit-on-i386.patch

 Dropped - buggy

+uml-style-fixes-in-arch-um-kernel.patch
+uml-fix-hostfs-tv_usec-calculations.patch
+uml-signal-handling-tidying.patch
+uml-remove-init_irq_signals.patch

 UML updates

-bugh-remove-have_arch_bug--have_arch_warn.patch
-powerpc-switch-to-generic-warn_on-bug_on.patch

 Dropped

-fat-optimize-fat_count_free_clusters.patch

 Dropped, I think.

-avoid-overflows-in-kernel-timec.patch
-avoid-overflows-in-kernel-timec-fix.patch

 Dropped

+make-sys_poll-wait-at-least-timeout-ms.patch
+ds1wm-decouple-host-irq-and-intr-active-state-settings.patch
+documentation-add-hint-about-call-traces-module-symbols-to-bug-hunting.patch
+claim-maintainership-for-block2mtd-and-update-email-addresses.patch
+phantom-dont-grab-other-devices.patch
+system-timer-fix-crash-in-100hz-system-timer.patch
+system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
+speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
+tpm-infineon-section-mismatch.patch
+w1-remove-unused-and-confusing-variable.patch

 Misc

-sync_sb_inodes-propagate-errors.patch

 Dropped

-move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch

 Dropped

+fix-and-typo-in-eicons-addinfo.patch
+drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch

 i4l things

-ecryptfs-load-each-file-decryption-key-only-once.patch

 Dropped

+ecryptfs-check-for-existing-key_tfm-at-mount-time.patch

 ecryptfs work

+restore-jdelvare-i2c-i2c-add-i2c_new_dummy-utility.patch

 This patch got dropped from the I2C tree, but
 rtc-add-support-for-the-s-35390a-rtc-chip.patch needs it

-rtc-add-support-for-the-s-35390a-rtc-chip-fix.patch

 Folded into rtc-add-support-for-the-s-35390a-rtc-chip.patch

+rtc-add-support-for-the-s-35390a-rtc-chip-update.patch
+rtc-add-support-for-the-s-35390a-rtc-chip-update2.patch

 Fix rtc-add-support-for-the-s-35390a-rtc-chip.patch some more

-generic-gpio-gpio_chip-support.patch
-generic-gpio-gpio_chip-support-fix.patch
-generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
-avr32-uses-gpio_chip.patch
-mcp23s08-spi-gpio-expander.patch
-mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
-arm-pxa-gpiolib-support.patch
-arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch

 These got updated

+w1-gpio-add-gpio-w1-bus-master-driver.patch
+w1-gpio-add-gpio-w1-bus-master-driver-v3.patch

 New gpio driver

+gpiolib-add-drivers-gpio-directory.patch
+gpiolib-add-gpio-provider-infrastructure.patch
+gpiolib-update-documentation-gpiotxt.patch
+gpiolib-pxa-platform-support.patch
+gpiolib-pcf857x-i2c-gpio-expander-support.patch
+gpiolib-mcp23s08-spi-gpio-expander-support.patch
+gpiolib-pca9539-i2c-gpio-expander-support.patch
+gpiolib-deprecate-obsolete-pca9539-driver.patch
+gpiolib-avr32-at32ap-platform-support.patch

 gpio work

+vermilionc-use-align-not-__align_mask.patch
+fb-nvidiafb-try-harder-at-initial-mode-setting.patch
+tdfxfb-fix-section-mismatch-warnings.patch
+uvesafb-small-cleanups.patch
+drivers-video-add-missing-pci_dev_get.patch

 fbdev updates

+md-fix-use-after-free-bug-when-dropping-an-rdev-from-an-md-array.patch
+md-change-a-few-int-to-size_t-in-md.patch
+md-change-interate_mddev-to-for_each_mddev.patch
+md-change-iterate_rdev-to-rdev_for_each.patch
+md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending.patch
+md-fix-an-occasional-deadlock-in-raid5.patch

 RAID updates

-pnp-do-not-stop-start-devices-in-suspend-resume-path.patch

 Dropped

+pnp-do-not-test-pnp_driver_res_do_not_change-on-suspend-resume.patch

 pnp fix

+ext4-check-for-return-value-from-sb_set_blocksize.patch

 ext4 fixlet

+documentation-move-dnotifytxt-to-filesystems.patch
+documentation-move-sharedsubtreestxt-to-filesystems.patch
+documentation-create-new-scheduler-subdirectory.patch
+reporting-bugs-cc-the-mailing-list-too.patch

 Documentation

-memory-controller-memory-accounting-v7-move-page_assign_page_cgroup-to-vm_bug_on-in-free_hot_cold_page.patch

 Folded into memory-controller-memory-accounting-v7.patch

-memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch

 Folded into memory-controller-add-per-container-lru-and-reclaim-v7.patch

-memory-controller-improve-user-interface-memory-controller-enhancements-for-reclaiming-take2-possible-race-fix-in-res_counter.patch

 Folded into memory-controller-improve-user-interface.patch

-memory-controller-make-charging-gfp-mask-aware-fix.patch

 Folded into memory-controller-make-charging-gfp-mask-aware.patch

-memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page-warning-fix.patch

 Folded into memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch

-memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
-memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
-memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
-memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch

 Folded into memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch

-memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
-memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch

 Folded into memory-cgroup-enhancements-add-memorystat-file.patch

-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter-memory-controller-enhancements-for-reclaiming-take2-clean-up-remove-unused-variable.patch
-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter-memory-controller-enhancements-for-reclaiming-take2-add-bug_on-in-mem_cgroup_zoneinfo.patch

 Folded into per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch

-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch

 Folded into per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch

-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix-accounting-in-vmscanc-for-memory-controller.patch

 Folded into per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch

-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-bugfix-for-memory-cgroup-per-zone-struct-allocation.patch
-per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-memory-controller-enhancements-for-reclaiming-take2-define-free_mem_cgroup_per_zone_info.patch

 Folded into per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch

+cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
+cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
+cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch

 More cgroups fixes

+hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
+hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
+cpusets-update_cpumask-revision.patch
+cpusets-update_cpumask-revision-fix.patch
+cpusets-update_cpumask-revision-checkpatch-fixes.patch

 cpuset work

+drivers-edac-pci-broken-parity-regression.patch
+drivers-edac-i3000-64bit-build.patch
+drivers-edac-mpc85xx-add-static-scope.patch
+drivers-edac-i3000-missing-init-code.patch

 EDAC updates

-vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch

 Dropped

+iget-stop-isofs-from-using-read_inode-fix-2-update-fix.patch

 Fix iget-stop-isofs-from-using-read_inode.patch some more

+iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch

 Fix iget-stop-unionfs-from-using-iget-and-read_inode.patch some more

+embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch

 Repair damage from embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch

-proc-remove-useless-checks-in-proc_register.patch

 Dropped

+proc-fix-openless-usage-due-to-proc_fops-flip.patch
+proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch

 More procfs work

+modules-make-module_address_lookup-safe.patch
+modules-make-module_address_lookup-safe-fix.patch

 Modules updates

-aout-move-stack_top-to-asm-processorh-fix.patch

 Folded into aout-move-stack_top-to-asm-processorh.patch

+aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch

 Fix aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch

+byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core.patch
+ext3-replace-all-adds-to-little-endians-variables-with-le_add_cpu.patch
+xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
+xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch

 Cleanups

+mm-remove-nopage.patch
+fixup-container_of-usage.patch
+efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code.patch
+dont-error-on-higher-hz-values.patch
+aio-partial-write-should-not-return-error-code.patch
+aio-negative-offset-should-return-einval.patch
+ext2-remove-unused-ext2_put_inode-prototype.patch
+ufs-fix-symlink-creation-on-ufs2.patch
+ufs-fix-symlink-creation-on-ufs2-fix.patch
+asm-posix_typesh-scrub-__glibc__.patch
+allow-executables-larger-than-2gb.patch
+write_inode_now-avoid-unnecessary-synchronous-write.patch
+nuke-duplicate-include-from-printkc.patch
+nuke-a-duplicate-include-from-profilec.patch
+nuke-duplicate-header-from-sysctlc.patch

 Random stuff

+libfs-allow-error-return-from-simple-attributes.patch
+libfs-allow-error-return-from-simple-attributes-fix.patch
+libfs-make-simple-attributes-interruptible.patch
+libfs-rename-simple_attr_close-to-simple_attr_release.patch

 libfa cleanups

+udf-fix-coding-style-of-superc.patch
+udf-remove-some-ugly-macros.patch
+udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function.patch
+udf-check-if-udf_load_logicalvol-failed.patch
+udf-convert-macros-related-to-bitmaps-to-functions.patch
+udf-move-calculating-of-nr_groups-into-helper-function.patch
+udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
+udf-fix-coding-style.patch
+udf-create-common-function-for-tag-checksumming.patch
+udf-create-common-function-for-changing-free-space-counter.patch
+udf-replace-loops-coded-with-goto-to-real-loops.patch
+udf-convert-byte-order-of-constant-instead-of-variable.patch
+udf-remove-udf_i_-macros-and-open-code-them.patch
+udf-cache-struct-udf_inode_info.patch
+udf-fix-udf_debug-macro.patch
+udf-improve-readability-of-udf_load_partition.patch
+kill-udffs_dateversion.patch
+udf-remove-wrong-prototype-of-udf_readdir.patch
+udf-fix-3-signedness-1-unitialized-variable-warnings.patch
+udf-fix-signedness-issue.patch
+udf-avoid-unnecessary-synchronous-writes.patch

 Updated UDF updates

+fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
+fs-afs-securityc-fix-uninitialized-var-warning.patch

 Fix warnings

+reiser4-fix-dummy-ioctl_cryptcompress.patch
+reiser4-granulate-rw-serialization-when-accessing-file-conversion-set.patch
+reiser4-fix-disk-cluster-synchronization.patch
+reiser4-use-balance_dirty_pages_ratelimited_nr.patch
+reiser4-correct-references-to-filemap_nopage.patch

 reiser4 updates



7933 commits in 2056 patch files


All patches: ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/patch-list


