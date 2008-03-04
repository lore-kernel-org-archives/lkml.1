Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbYCDJUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbYCDJUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYCDJUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:20:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760729AbYCDJUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:20:00 -0500
Date: Tue, 4 Mar 2008 01:19:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc3-mm1
Message-Id: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/



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



Changes since 2.6.25-rc2-mm1:


 origin.patch
 git-x86.patch
 git-acpi.patch
 git-alsa.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-drm.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-dlm.patch
 git-hid.patch
 git-hrt.patch
 git-ia64.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-jfs.patch
 git-kvm.patch
 git-md-accel.patch
 git-mtd.patch
 git-ubi.patch
 git-net.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-parisc.patch
 git-selinux.patch
 git-s390.patch
 git-scsi-misc.patch
 git-block.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-xtensa.patch
 git-slub.patch
 git-semaphore.patch

 git tres

-revert-send-a-single-notification-on-device-state-changes.patch
-uml-fix-initrd-printk.patch
-uml-update-defconfig.patch
-arch-um-kernel-memc-fix-a-shadowed-variable.patch
-make-lkdtm-depend-on-block.patch
-fuse-fix-permission-checking.patch
-mn10300-define-hz-as-a-config-option.patch
-mn10300-define-so_mark.patch
-samples-build-fix.patch
-git-acpi-powerpc-kconfig-fix.patch
-remove-is_processor_present-prototype.patch
-git-agpgart-make-ia64-compile.patch
-git-audit-printk-warning-fix.patch
-enable-hotplug-memory-remove-for-ppc64.patch
-driver-base-memory-semaphore-to-mutex.patch
-drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
-gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
-jdelvare-i2c-i2c-pxa-misc-fixes.patch
-i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
-adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
-applesmc-sensors-set-for-macbook2.patch
-dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
-apanel-fix-kconfig-dependencies.patch
-ata-fix-sparse-warning-in-libatah.patch
-ide-mm-ide-add-missing-base-addresses-for-falconide-and-macide.patch
-ide-mm-ide-tape-schedule-driver-for-removal-after-6-months.patch
-ide-mm-ide-rework-powermac-media-bay-support.patch
-ide-mm-ide-remove-broken-dangerous-ide-unregister-scan-hwif-ioctls-take-2.patch
-fix-ide-mm-ide-rework-powermac-media-bay-support.patch
-mips-use-find_task_by_vpid-in-system-calls.patch
-fix-alignment-of-ip-config-output.patch
-git-nfsd-fix.patch
-ocfs2-le_add_cpu-conversion.patch
-blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch
-if-0-pci_cleanup_aer_correct_error_status.patch
-cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
-quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
-pci-disable-decoding-during-sizing-of-bars.patch
-kill-warnings-in-mptbaseh-on-parisc64.patch
-scsi-qlogicptic-section-fixes.patch
-megaraid-outb_p-extermination.patch
-embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
-introduce-path_put-unionfs.patch
-iget-stop-unionfs-from-using-iget-and-read_inode.patch
-gregkh-usb-usb-ftdi_sioc-add-missing.patch
-gregkh-usb-usb-sane-memory-allocation-in-option-driver.patch
-usb-microtek-remove-unused-semaphore.patch
-usb-libusual-locking-cleanup.patch
-usb-make-usb_storage_onetouch-available-with-pm.patch
-usb-ohci-sm501-driver-v2-fix.patch
-usb-yet-another-dell-wireless-cdma-evdo-modem.patch
-drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
-usb-ehci-tolerates-some-buggy-devices.patch
-usbatm-switch-to-kthread-api-stop-using-kill_proc.patch
-usb-serial-move-zte-mf330-from-sierra-to-option.patch
-it8712f_wdt-support-for-16-bit-timeout-values-wdioc_getstatus.patch
-pci-dont-load-acpi_php-when-acpi-is-disabled.patch
-x86-amd-thermal-interrupt-support.patch
-x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
-x86-visws-fix-printk-format-warnings.patch
-x86-minor-cleanup-of-comments-in-processorh.patch
-documentation-i386-io-apictxt-fix-description.patch
-x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
-rtc-cmos-display-hpet-emulation-mode.patch
-register_memory-unregister_memory-fix-use-after-free-and-refcounting.patch
-acer-wmi-fail-gracefully-if-acpi-is-disabled.patch
-tc1100-wmi-fail-gracefully-if-acpi-is-disabled.patch
-dmi-dont-save-the-same-device-twice-was-smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
-uml-remove-unused-sigcontext-accessors.patch
-uml-fix-helper_wait-calls-in-watchdog.patch
-uml-fix-fp-register-corruption.patch
-x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
-nbd-make-nbd-default-to-deadline-i-o-scheduler.patch
-efs-move-headers-out-of-include-linux.patch
-percpu-fix-debug_preempt-per_cpu-checking.patch
-proc-add-rlimit_rttime-to-proc-pid-limits.patch
-sparc-fix-build.patch
-drivers-video-uvesafbc-fix-section-mismatch-warning-in-param_set_scroll.patch
-remove-rcu_assign_pointernull-penalty-with-type-macro-safety.patch
-add-rcu_assign_index-if-ever-needed.patch
-add-rcu_assign_index-if-ever-needed-fix.patch
-dmi-prevent-linked-list-corruption-resent.patch
-proc-pid-pagemap-fix-pm_special-macro.patch
-x86-fix-clearcopy_user_page-declarations-in-pageh.patch
-futex-fix-init-order.patch
-futex-runtime-enable-pi-and-robust-functionality.patch
-bluetooth-fix-warning-in-net-bluetooth-hci_sysfsc.patch
-h8300-signalc-typo-fix.patch
-h8300-uaccessh-update.patch
-h8300-config_kallsyms-fix.patch
-h8300-irq-handling-update.patch
-h8300-defconfig-update.patch
-debugfs-fix-sparse-warnings.patch
-rtc-add-support-for-the-s-35390a-rtc-chip.patch
-rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
-ext4-mm-remove_incorrect_bkl_comments_in_ext4.patch
-ext4-mm-ext4_ialloc-flexbg.patch
-ext4-mm-ext4-online-defrag-iget-read-inode-fix.patch
-ext4-mm-convert_ext4_to_use_unlocked_ioctl_v2.patch
-ext4-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
-ext4-le_add_cpu-conversion.patch
-jbd2-sparse-warnings-in-revokec-journalc.patch
-ext4-convert-byte-order-of-constant-instead-of-variable.patch
-provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
-fix-shadowed-variables-in-kernel-posix-cpu-timersc.patch
-timers-simplify-lockdep-stuff.patch
-hrtimers-simplify-lockdep-stuff.patch
-kill-double_spin_lock.patch
-use-find_task_by_vpid-in-taskstats.patch
-deprecate-find_task_by_pid.patch

 Merged into mainline or a subsystem tree

+cgroup-fix-default-notify_on_release-setting.patch
+update-checkpatchpl-to-version-015.patch
+serial-add-pnp-id-gvc0303-for-archtek-3334brv-isa-modem.patch
+cris-v10-include-mmh-instead-of-vmstath-in-kernel-timec.patch
+memory-resource-controller-use-strstrip-while-parsing-arguments.patch
+rtc-add-support-for-the-s-35390a-rtc-chip.patch
+specialixc-fix-possible-double-unlock.patch
+gpio-linux-gpioh-and-no-gpio-support-here-stubs.patch
+control-groups-add-paul-menage-a-maintainer.patch
+add-balbir-as-the-maintainer-for-memory-resource-controller.patch
+core-dump-user_regset-writeback.patch
+fix-malformed-early-option-loglevel.patch
+zlc_setup-handle-jiffies-wraparound.patch
+zlc_setup-handle-jiffies-wraparound-fix.patch
+hda_intel-needs-dma-mappingh.patch
+m68knommu-wire-up-new-timerfd-syscalls.patch

 2.6.25 queue

+define-functions-for-page-cache-handling.patch

 Will probably drop this series

-softlockup-workaround.patch

 I still need this on one machine to fix a poweroff regression.

+arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
+documentation-i386-io-apictxt-fix-description.patch
+add-the-dff-desktop-form-factor-dell-optiplex-745-to-the-reboot-errata-list.patch

 x86 things

+git-acpi-fixup.patch

 Fix git-acpi.

+acpi-add-acpi-aliases-to-toshiba_acpi-module.patch
+acpi-make-real-parent-for-acpi-button-input-devices.patch

 acpi things

+git-alsa-fix-git-conflicts.patch

 Fix git conflicts in git-alsa

+git-alsa-build-fix.patch
+snd-hda-intel-dont-print-using-snd_printdd-on-device-open.patch
+sound-use-bug_on.patch
+sound-replace-remaining-__function__-occurences.patch

 alsa stuff

+agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch

 agp fix

+arm-replace-remaining-__function__-occurences.patch

 cleanup

+cifs-remove-global_extern-macro.patch

 cifs cleanup

+cpufreq-fix-section-mismatch-warnings.patch

 cpufreq fix

+powerpc-replace-remaining-__function__-occurences.patch
+ppc-replace-remaining-__function__-occurences.patch

 powerpc things

+gregkh-driver-kobject-properly-initialize-ksets.patch
+gregkh-driver-kobject-catch-kobjects-that-are-not-initialized.patch
+gregkh-driver-uio-kconfig-improvements.patch
+gregkh-driver-uio-mark-pci_device_id-hilscher_pci_ids-__devinitdata.patch
+gregkh-driver-uio-arch-arm-kconfig-make-uio-available-on-arm-architecture.patch
+gregkh-driver-uio-remove-needless-pci_device_id-definition-from-uio_cifc.patch
+gregkh-driver-debugfs-fix-sparse-warnings.patch
+gregkh-driver-driver-core-memory-semaphore-to-mutex.patch
+gregkh-driver-driver-core-register_memory-unregister_memory-clean-ups-and-bugfix.patch
+gregkh-driver-driver-core-numactl-interleave-all-doesn-t-works-on-memoryless-node.patch
+gregkh-driver-sysfs-small-header-file-cleanup-for-sysfs-n.patch
+gregkh-driver-firmware-move-firmware_class-from-documentation-to-samples.patch
+gregkh-driver-firmware-clean-up-samples-for-coding-style-issues.patch
+gregkh-driver-pnp-add-all-pnp-card-device-id-s-as-individual-aliases.patch
+gregkh-driver-power_state-remove-it-from-driver-core.patch
+gregkh-driver-video-add-the-go7007-driver.patch

 driver tree updates

+revert-gregkh-driver-video-add-the-go7007-driver.patch
+drivers-base-cpu-fix-section-mismatch-in-cpucstore_online.patch
+sysdev-detect-multiple-driver-registrations.patch
+driver-core-fix-cleanup-when-failing-device_add.patch
+driver-core-debug-for-bad-dev_attr_show-return-value.patch

 Things for the driver tree.

+radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch

 drm fix

-git-dvb-someone-broke-the-gpio-includes.patch

 Unneeded

+video-limit-stack-usage-of-ir-kbd-i2cc.patch

 v4l fix

+jdelvare-i2c-i2c-amd756-fix-off-by-one.patch
+jdelvare-i2c-i2c-ibm_iic-01-change-log-levels.patch
+jdelvare-i2c-i2c-ibm_iic-02-of-platform.patch
+jdelvare-i2c-i2c-dev-split-i2cdev_ioctl.patch
+jdelvare-i2c-i2c-bus-driver-for-sh7760-soc.patch
+jdelvare-i2c-i2c-isp1301_omap-convert-to-new-style-1.patch

 i2c tree updates

+provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
+time-remove-obsolete-clock_tick_adjust.patch
+time-remove-obsolete-clock_tick_adjust-update.patch

 time-management things

+ia64-remove-unnecessary-nfs-includes-from-sys_ia32c.patch
+ia64-remove-remaining-__function__-occurences.patch

 ia64 things

+maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
+maple-add-driver-for-sega-dreamcast-controller.patch
+maple-add-driver-for-sega-dreamcast-controller-update.patch
+maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch
+input-put-ledstate-in-the-keyboard-notifier.patch
+input-put-ledstate-in-the-keyboard-notifier-fix.patch
+hdaps-invert-the-axes-for-hdaps-on-lenovo-r61i-thinkpads.patch
+input-core-driver-for-wm97xx-touchscreens.patch
+input-add-chip-driver-for-wm9705-touchscreen.patch
+input-add-chip-driver-for-wm9712-touchscreen.patch
+input-add-chip-driver-for-wm9713-touchscreen.patch
+input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone.patch
+input-build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers.patch
+input-add-lenovo-3000-n100-to-nomux-blacklist.patch
+input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
+ati_remote2-autorepeat-and-loadable-keymap-support.patch
+#input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch: jiri probs
+input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
+xpad-match-xbox-360-devices-with-interface-info.patch

 input patches I've been accumulating during Dmitry's absence.

+tags-add-menuconfig-symbols-as-well.patch

 kbuild tweak

+pata_amd-fix-sparse-warning.patch
+pata-i-do-not-think-it-means-what-you-think-it-means.patch
+pata-i-do-not-think-it-means-what-you-think-it-means-checkpatch-fixes.patch

 paa things

+ide-mm-ide-rework-powermac-media-bay-support-take-2.patch
+ide-mm-ide-remove-dead-obsolete-busproc-method.patch
+ide-mm-ide-remove-broken-dangerous-ide-unregister-scan-hwif-ioctls-take-3.patch
+ide-mm-ide-pmac-remove-dead-code.patch
+ide-mm-ppc-hdpu-remove-dead-ide-code.patch
+ide-mm-ppc-ppc4xx-remove-ppc_ide_md-hooks.patch
+ide-mm-ppc-pmac-remove-ppc_ide_md-hooks.patch
+ide-mm-ppc-mpc8xx-remove-ppc_ide_md-hooks.patch
+ide-mm-ppc-lopec-remove-ppc_ide_md-hooks.patch
+ide-mm-ppc-sandpoint-remove-ppc_ide_md-hooks.patch
+ide-mm-ppc-pplus-remove-ppc_ide_md-ide_init_hwif-hook.patch
+ide-mm-ppc-remove-ppc_ide_md-ide_init_hwif-hook.patch
+ide-mm-ppc-dont-include-linux-ide-h.patch
+ide-mm-ppc-pmac-remove-no-longer-needed-ide-quirk.patch
+ide-mm-ide-add-config_ide_arch_obsolete_defaults-take-2.patch
+ide-mm-ide-remove-config_ide_arch_obsolete_init.patch
+ide-mm-ide-remove-ide_default_io_ctl-macro.patch
+ide-mm-ide-remove-ppc-ifdef-from-init_ide_data.patch
+ide-mm-ide-add-ide-4drives-host-driver-take-3.patch
+ide-mm-cmd640-cleanup-setup_device_ptrs.patch
+ide-mm-cmd640-init-hwif-io_ports-irq-explicitly.patch
+ide-mm-ide-limit-legacy-vlb-host-drivers-to-alpha-x86-and-mips.patch
+ide-mm-ide-init-hwif-io_ports-irq-explicitly-in-legacy-vlb-host-drivers.patch
+ide-mm-ide-remove-needless-hwif-irq-check-from-ide_hwif_configure.patch
+ide-mm-ide-remove-obsoleted-idex-noprobe-kernel-parameter.patch
+ide-mm-ide-move-default-ide-ports-setup-to-ide_generic-host-driver.patch
+ide-mm-ide-remove-ide_init_default_irq-macro.patch
+ide-mm-ide-cleanup-ide_match_hwif.patch
+ide-mm-ide-cleanup-ide_find_port.patch
+ide-mm-swarm-use-ide_find_port.patch
+ide-mm-ide-pmac-dynamically-allocate-struct-pmac_ide_hwif-instances-take-2.patch
+ide-mm-ide-pmac-use-ide_find_port.patch
+ide-mm-sgiioc4-use-ide_find_port.patch
+ide-mm-au1xxx-ide-use-ide_find_port.patch
+ide-mm-cmd640-remove-cmd_drives.patch
+ide-mm-cmd640-use-ide_find_port.patch
+ide-mm-scc_pata-store-hwif-pointer-in-struct-scc_ports.patch
+ide-mm-umc8672-dont-use-ide_hwifs-in-umc_set_pio_mode.patch
+ide-mm-ht6560b-use-driver-name-for-resource-allocation.patch
+ide-mm-qd65xx-return-error-value-in-qd_probe.patch
+ide-mm-ide-ide_hflag_bootable-to-ide_hflag_non_bootable.patch
+ide-mm-ide-use-div_round_up.patch
+ide-mm-ide-remove-pio-downgrade-quirk.patch
+ide-mm-ide-merge-ide_match_hwif-and-ide_find_port.patch
+ide-mm-ide-use-ide_find_port-in-legacy-vlb-host-drivers-take-2.patch
+ide-mm-ide-generic-use-ide_find_port-take-3.patch
+ide-mm-ide-unexport-ide_hwifs.patch
+ide-mm-ide-disk-add-proc_idedisk_read_smart-helper.patch
+ide-mm-ide-disk-fix-issues-found-by-checkpatch-pl.patch
+ide-mm-ide-cd-remove-the-internal-64k-buffer.patch
+ide-mm-remove-include-linux-hdsmart-h.patch
+ide-mm-ide_platform-fix-resources-handling.patch
+ide-mm-delkin_cb-fix-resources-handling.patch
+ide-mm-bast-ide-fix-resources-reservation.patch
+ide-mm-mpc8xx-make-m8xx_ide_init_ports-return-an-error-value.patch
+ide-mm-mpc8xx-fix-resources-reservation.patch
+ide-mm-falconide-fix-resources-reservation-take-2.patch
+ide-mm-ide-fix-enabling-dma-on-it821x-in-smart-mode.patch
+ide-mm-ide-remove-ide_hflag_cy82c693-host-flag.patch
+ide-mm-ide-remove-hwif-straight8-flag.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_setup-pci-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_pci_tc86c001-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_pci_slc90e66-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_pci_sis5513-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_pci_jmicron-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_pci_generic-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_legacy_umc8672-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_legacy_ide-4drives-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_ide-proc-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_ide-pnp-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_pci_opti621-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_pci_cmd640-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_legacy_hd-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_legacy_ali14xx-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_ide-floppy-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_pci_it8213-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_pci_cy82c693-c.patch
+ide-mm-ide-coding-style-fixes-to-drivers_ide_ide-cd-c.patch
+ide-mm-ide-cd-replace-__function__-with-__func__.patch
+ide-mm-ide-cd-put-proc-related-functions-together-under-single-ifdef.patch
+ide-mm-qd65xx-selectproc-method-needs-to-be-always-used.patch
+ide-mm-qd65xx-use-ide_hflag_single-host-flag.patch
+ide-mm-it821x-fix-kzalloc-failure-handling.patch
+ide-mm-sis5513-fail-early-for-unsupported-chipsets.patch
+ide-mm-ide-sanitize-handling-of-ide_hflag_no_set_mode-host-flag.patch
+ide-mm-ide-add-struct-ide_port_ops.patch
+ide-mm-ide-cd-include-proper-headers.patch
+ide-mm-ide-cd-put-all-proc-related-code-at-one-place.patch
+ide-mm-ide-cd-fixup-comments.patch
+ide-mm-ide-cd-shorten-lines-longer-than-80-columns.patch
+ide-mm-ide-cd-fix-remaining-checkpatch-pl-issues.patch
+ide-mm-ide-remove-noprobe-field-from-ide_hwif_t.patch
+ide-mm-ide-add-ide_legacy_device_add-helper.patch
+ide-mm-ide-use-ide_legacy_device_add-for-qd65xx-take-2.patch
+ide-mm-qd65xx-cleanup-qd_probe.patch
+ide-mm-ide-pnp-manage-io-resources-in-driver.patch
+ide-mm-ide-cs-manage-io-resources-in-driver.patch
+ide-mm-ide-register-ports-with-non-present-devices-for-warm-plug.patch
+ide-mm-ide-remove-ide_hwif_release_regions.patch
+ide-mm-ide-generic-manage-io-resources-in-driver.patch
+ide-mm-ide-4drives-manage-io-resources-in-driver.patch
+ide-mm-ide_arm-manage-io-resources-in-driver.patch
+ide-mm-ide-add-ide_legacy_init_one-helper.patch
+ide-mm-ide-manage-io-resources-in-ide_legacy_init_one.patch
+ide-mm-cmd640-manage-io-resources-in-driver.patch
+ide-mm-ide-manage-resources-for-pci-devices-in-ide_pci_enable.patch
+ide-mm-ide-remove-ide_hwif_request_regions.patch
+ide-mm-ide-cleanup-setting-hwif-mmio-flag.patch
+ide-mm-ide-tape-remove-idetape_pipeline_active.patch

 The IDE tree shows its usual levelof activity ;)

+m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch

 m32r cleanup

+mips-replace-remaining-__function__-occurences.patch

 mips cleanup

+mtdoopsc-make-struct-oops_cxt-static-again.patch
+make-mtd-nand-cs553x_nandcpart_probes-static.patch
+jffs2-include-function-prototype-for-jffs2_ioctl.patch
+jffs2-fix-sparse-warning-in-nodemgmtc.patch
+jffs2-fix-sparse-warning-in-writec.patch
+jffs2-fix-sparse-warnings-in-gcc.patch
+block2mtd-logging-typo-fixes.patch
+jffs2-add-write-verify-on-dataflash.patch
+mtd-nor-add-support-for-the-st-m29w400db-flash-chip.patch

 mtd things

+cosa-srp-convert-channel_datarsem-to-mutex.patch

 mutex conversion

+bluetooth-make-hci_sock_cleanup-return-void.patch
+bluetooth-make-bnep_sock_cleanup-return-void.patch

 bluetooth things

-3c509-convert-to-isa_driver-and-pnp_driver-v4.patch
-3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch

 Dropped

+make-s2iocinit_tti-static.patch
+smc91x-pass-along-private-data-v2.patch
+smc91x-introduce-platform-data-flags-v2.patch
+smc91x-add-insw-outsw-to-default-config-v2.patch
+smc91x-make-superh-use-default-config-v2.patch
+drivers-net-apnec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+drivers-net-appletalk-copsc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+drivers-net-appletalk-ltpcc-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+drivers-net-arcnet-capmodec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+drivers-net-arcnet-com20020c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+drivers-net-at1700c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+drivers-net-atarilancec-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+drivers-net-8390c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
+drivers-net-ac3200c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch

 netdev things

+blackfin-replace-remaining-__function__-occurences.patch

 blackfin cleanup

+fs-ocfs2-use-bug_on.patch
+fs-ocfs2-dlm-dlmdomainc-fix-printk-warning.patch

 ocfs2 things

+parisc-replace-remaining-__function__-occurences.patch

 parisc cleanup

+pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
+pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
+pcmcia-annotate-cb_alloc-with-__ref.patch

 pcmcia things

+gregkh-pci-pci-if-0-pci_assign_resource_fixed.patch
+gregkh-pci-pci-remove-parisc-consumer-of-the-pci-global_list.patch
+gregkh-pci-pci-pcie-aer-don-t-check-_osc-when-acpi-is-disabled.patch
+gregkh-pci-pci-if-0-pci_cleanup_aer_correct_error_status.patch
+gregkh-pci-pci-include-pci-domain-in-pci-bus-names-on-x86-x86_64.patch
+gregkh-pci-pci-remove-pci-routeirq-noise-from-dmesg.patch

 PCI tree updates

+pci-fix-section-mismatch-warning-in-pci_scan_child_bus.patch
+pci_alloc_child_bus-mustnt-be-__devinit.patch
+pci_scan_device-mustnt-be-__devinit.patch
+pci_bus_size_cardbus-mustnt-be-__devinit.patch
+pci_setup_bridge-mustnt-be-__devinit.patch
+pci-simplify-quirk-debug-output.patch
+pci-iommu-iotlb-flushing.patch
+pci-consolidate-duplicated-msi-enable-functions.patch
+pci-use-dev_printk-in-quirk-messages.patch

 PCI things

-git-sched-git-rejects.patch
-tracing-is-borked-on-powerpc.patch

 Unneeded

+sh-superh-keysc-platform-driver.patch
+sh-superh-keysc-keypad-data-for-migor.patch
+sh-superh-keysc-keypad-data-for-solution-engine-7722.patch
+sh-replace-remaining-__function__-occurences.patch
+sh-export-copy-page-to-modules.patch

 SuperH things

+scsi-fix-section-mismatch-in-aic94xx.patch
+if-0-ses_match_host.patch

 scsi things

-libsas-convert-ata-bridge-to-use-new-eh.patch

 Dropped

+remove-ps2esdi.patch
+kconfig-cleanup-block-kconfig-help-descriptions.patch
+block-fix-shadowed-variable-warning-in-blk-mapc.patch
+block-remove-extern-on-function-definition.patch
+use-page_cache_xxx-in-fs-splicec.patch
+cciss-remove-read_ahead-define-and-use-block-layer-defaults.patch
+kconfig-cleanup-block-kconfigiosched-help-descriptions.patch
+device-mapper-not-reporting-no-barrier-support.patch

 block things

-unionfs-is-broken.patch
-git-unionfs-git-rejects.patch

 Unneeded

+gregkh-usb-usb-microtek-remove-unused-semaphore.patch
+gregkh-usb-usb-libusual-locking-cleanup.patch
+gregkh-usb-usb-make-usb_storage_onetouch-available-with-pm.patch
+gregkh-usb-usb-usb-ohci-sm501-driver-use-the-conventional-convention-for-suspend-and-resume.patch
+gregkh-usb-usb-usbatm-convert-heavy-init-dances-to-kthread-api.patch
+gregkh-usb-usb-defines-for-usb-link-power-management-ecn.patch
+gregkh-usb-usb-ehci-minor-cleanups.patch
+gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
+gregkh-usb-usb-ehci-tolerates-some-buggy-devices.patch
+gregkh-usb-usb-ehci-minor-soc-bus-glue-fixes.patch
+gregkh-usb-usb-m66592-udc-reduce-size-of-data-structure.patch
+gregkh-usb-usb-ehci-refactor-if-state-hc_state_halt.patch
+gregkh-usb-usb-gadget-hangup-tty-on-g_serial-disconnect.patch
+gregkh-usb-usb-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
+gregkh-usb-usb-cypress_m8-feature-buffer-fixes.patch
+gregkh-usb-usb-cypress_m8-packet-format-is-separate-from-characteristic-size.patch
+gregkh-usb-usb-cypress_m8-don-t-issue-get_config-for-certain-devices.patch
+gregkh-usb-usb-cypress_m8-get-rid-of-pointless-null-check.patch
+gregkh-usb-usb-cypress_m8-limit-baud-rate-to-4800-for-usb-low-speed-devices.patch
+gregkh-usb-usb-misc-auerswald-cp_mutex-to-mutexdiff.patch
+gregkh-usb-usb-misc-auerswald-ccp_readmutex-to-mutexdiff.patch
+gregkh-usb-usb-misc-auerswald-ccp_mutex-to-mutexdiff.patch
+gregkh-usb-usb-minor-ehci-xitd-simplifications.patch
+gregkh-usb-usb-usb-serial-prepare-for-bkl-push-down.patch
+gregkh-usb-usb-ftdi_sio-note-missing-locking.patch
+gregkh-usb-usb-serial-note-mos7480-and-option-don-t-lock-modem-status.patch
+gregkh-usb-usb-iuu_phoenix-lock-priv-tiostatus-properly.patch
+gregkh-usb-usb-kobil_sct-get-rid-of-unneeded-priv-line_state.patch
+gregkh-usb-usb-ti_usb_3410_5052-extend-locking-to-msr-and-shadow-mcr.patch
+gregkh-usb-usb-io_ti-lock-mcr-and-msr-shadows-properly.patch
+gregkh-usb-usb-add-sensoray-2255-v4l-driver.patch

 USB tree updates

+usb-use-div_round_up.patch
+usbaudio-handle-kcalloc-failure.patch
+drivers-usb-serial-io_tic-remove-unneeded-null-tty-check.patch
+usb-remove-unnecessary-type-casting-of-urb-context.patch
+usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes.patch
+usb-fix-comment-of-struct-usb_interface.patch
+usb-mos7840c-add-support-for-the-mos7820-7840-based-bb-usb-rs485-converter.patch

 USB things

+9p-handle-kstrdup-and-match_strdup-failure.patch

 v9fs fix

-git-watchdog-git-rejects.patch

 Unneeded

+watchdog-hpwdt-fix-declaration-of-struct-smbios_entry_point.patch
+watchdog-hpwdt-fix-return-value-warning.patch
+watchdog-hpwdt-use-dmi_walk-instead-of-own-copy.patch

 Watchdog things

+the-scheduled-bcm43xx-removal.patch
+the-scheduled-ieee80211-softmac-removal.patch
+the-scheduled-rc80211-simplec-removal.patch
+wdev-ath5k-typecheck-on-nondebug.patch

 Wireless things

+use-page_cache_xxx-for-fs-xfs.patch

 Will probably drop

+crypto-switch-to-proc_create.patch

 Crypto fix

+xtensa-replace-remaining-__function__-occurences.patch

 xtensa cleanup

+git-semaphore-git-rejects.patch

 Fix git rejects in git-semaphore.patch

+alloc_percpu-fails-to-allocate-percpu-data.patch
+kthread-call-wake_up_process-without-the-lock-being-held.patch
+vt-notifier-fix-for-vt-switch.patch
+documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
+kprobes-indicate-kretprobe-support-in-kconfig.patch
+kprobes-move-kprobe-examples-to-samples.patch
+memory-controller-rename-to-memory-resource-controller.patch
+tridentfb-resource-management-fixes-in-probe-function.patch
+tridentfb-resource-management-fixes-in-probe-function-fix.patch
+add-noinline_for_stack.patch
+pktcdvd-reduce-stack-consumption.patch
+mpc5200-fix-build-error-on-mpc52xx_psc_spi-device-driver.patch
+ds1wm-should-check-for-is_errclk-instead-of-null.patch
+ds1wm-report-bus-reset-error.patch
+ndelay-switch-to-c-function-to-avoid-64-bit-division.patch
+ndelay-switch-to-c-function-to-avoid-64-bit-division-fix.patch
+sm501fb-direct-color-visual-does-not-work.patch
+sm501fb-rgb-offsets-are-reversed-in-16bpp-modes.patch
+sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes.patch
+sm501fb-fix-timing-limits.patch
+sm501-remove-a-duplicated-table.patch
+sm501-add-support-for-the-sm502-programmable-pll.patch
+sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes.patch
+ipwireless-fix-potential-tty-==-null-dereference.patch
+cris-import-stringc-memcpy-from-newlib-fixes-compile-error-with-gcc-4.patch
+include-falloch-in-header-y.patch
+alpha-convert-iommu-to-use-align.patch
+alpha-iommu-had-better-access-to-the-free-space-bitmap-at-only-one-place.patch
+alpha-make-iommu-respect-the-segment-boundary-limits.patch
+alpha-remove-unused-debug_forcedac-define-in-iommu.patch
+gitignore-ignore-emacs-backup-and-temporary-files.patch
+markers-dont-risk-null-deref-in-marker.patch
+markers-dont-risk-null-deref-in-marker-checkpatch-fixes.patch
+markers-add-an-if0-to-__mark_check_format.patch
+memcg-mm_match_cgroup-not-vm_match_cgroup.patch
+memcg-move_lists-on-page-not-page_cgroup.patch
+memcg-page_cache_release-not-__free_page.patch
+memcg-when-do_swaps-do_wp_page-fails.patch
+memcg-fix-vm_bug_on-from-page-migration.patch
+memcg-bad-page-if-page_cgroup-when-free.patch
+memcg-mem_cgroup_charge-never-null.patch
+memcg-remove-mem_cgroup_uncharge.patch
+memcg-memcontrol-whitespace-cleanups.patch
+memcg-memcontrol-uninlined-and-static.patch
+memcg-remove-clear_page_cgroup-and-atomics.patch
+memcg-css_put-after-remove_list.patch
+memcg-fix-mem_cgroup_move_lists-locking.patch
+memcg-simplify-force_empty-and-move_lists.patch
+memcg-fix-oops-on-null-lru-list.patch
+drivers-char-isicomc-correct-use-of-and.patch
+drivers-isdn-correct-use-of-and.patch
+drivers-serial-m32r_sioc-correct-use-of-and.patch
+fs-reiserfs-superc-correct-use-of-and.patch
+block-fix-residual-byte-count-handling.patch
+acpi-thinkpad-acpi-fix-hotkey_get_tablet_mode.patch
+cris-correct-usage-of-__user-for-copy-to-and-from-user-space-in-lib-usercopy-and-uaccessh-try-2.patch
+cris-correct-syscall-numbers-in-unistdh-for-timerfd_settime-and-timerfd_gettime.patch
+kernel-add-clamp-and-clamp_t-macros.patch
+kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
+kernel-add-clamp-and-clamp_t-macros-fix.patch
+ecryptfs-make-ecryptfs_prepare_write-decrypt-the-page.patch
+hisax_fcpcipnp-move-request_irq-later-in-probe.patch
+iommu-export-iommu_is_span_boundary-helper-function.patch
+iommu-parisc-pass-struct-device-to-iommu_alloc_range.patch
+iommu-parisc-pass-struct-device-to-iommu_alloc_range-checkpatch-fixes.patch
+iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits.patch
+iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits-checkpatch-fixes.patch
+md-fix-deadlock-in-md-raid1-and-md-raid10-when-handling-a-read-error.patch
+md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap.patch
+md-guard-against-possible-bad-array-geometry-in-v1-metadata.patch
+md-clean-up-irregularity-with-raid-autodetect.patch
+md-make-sure-a-reshape-is-started-when-device-switches-to-read-write.patch
+md-lock-access-to-rdev-attributes-properly.patch
+md-dont-attempt-read-balancing-for-raid10-far-layouts.patch
+md-fix-possible-raid1-raid10-deadlock-on-read-error-during-resync.patch
+md-the-md-raid10-resync-thread-could-cause-a-md-raid10-array-deadlock.patch
+hugetlb-correct-page-count-for-surplus-huge-pages.patch
+hugetlb-close-a-difficult-to-trigger-reservation-race.patch
+hugetlb-fix-pool-shrinking-while-in-restricted-cpuset.patch
+ext3-fix-mount-option-parsing.patch
+input-add-i2c-to-config-since-the-driver-makes-several-i2c-calls.patch
+kprobes-fix-a-null-pointer-bug-in-register_kretprobe.patch

 2.6.25 things which I'll be merging

+pm-do-not-acquire-device-semaphores-upfront-during-suspend.patch
+pm-do-not-acquire-device-semaphores-upfront-during-suspend-fix.patch
+x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
+x86-fix-clearcopy_user_page-declarations-in-pageh.patch
+x86-visws-fix-printk-format-warnings.patch
+mpt-fusion-dont-oops-if-numphys==0.patch
+bluetooth-hci_core-defer-hci_unregister_sysfs.patch
+e100-do-suspend-shutdown-like-e1000.patch
+dm-raid1-bitops-bug.patch
+iova-lockdep-false-alarm-fix.patch
+bluetooth-conwise-technology-based-adapters-with-buggy-sco-support-bugzilla-9027.patch
+fix-typo-in-tick-broadcastc.patch
+i8042-use-sgi_has_i8042-to-select-sgi-i8042-handlinig.patch
+de2104x-remove-bug_on-when-changing-media-type.patch
+time-prevent-the-loop-in-timespec_add_ns-from-being-optimised-away.patch
+acpi-ec-fix-regression.patch
+drivers-acpi-asus_acpic-correct-use-of-and.patch
+drivers-media-video-em28xx-correct-use-of-and.patch
+drivers-media-video-em28xx-correct-use-of-and-fix.patch
+drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
+time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch
+scsi-arcmsr-update-driver-version.patch
+acpi-fix-overflow.patch
+the-kernel-gets-no-ip-from-some-dhcp-servers.patch
+fixed_phy-must-depend-on-phylib=y.patch
+ntfs-fix-nommu-build.patch
+2625-rc2-mm1-warning-at-arch-x86-mm-ioremapc129.patch
+slub-fix-possible-null-pointer-dereference.patch
+slub-fix-possible-null-pointer-dereference-fix.patch
+rxrpc-fix-rxrpc_recvmsgs-returning-of-msg_name.patch

 Things which I thik are for 2.6.25 and which others should be merging.

+mm-remove-nopage.patch
+make-swap_pte_to_pagemap_entry-static.patch
+mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
+mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
+mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
+mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
+mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
+mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
+use-page_cache_xxx-functions-in-mm-filemapc.patch
+use-page_cache_xxx-in-mm-page-writebackc.patch
+use-page_cache_xxx-in-mm-truncatec.patch
+use-page_cache_xxx-in-mm-rmapc.patch
+use-page_cache_xxx-in-mm-filemap_xipc.patch
+use-page_cache_xxx-in-mm-migratec.patch
+use-page_cache_xxx-in-fs-libfsc.patch
+use-page_cache_xxx-in-fs-sync.patch
+use-page_cache_xxx-in-fs-bufferc.patch
+use-page_cache_xxx-in-mm-mpagec.patch
+use-page_cache_xxx-in-mm-fadvisec.patch
+mm-try-both-endianess-when-checking-for-endianess.patch
+hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
+mm-move-cache_line_size-to-linux-cacheh.patch

 Memory management updates

+capabilities-implement-per-process-securebits.patch
+capabilities-implement-per-process-securebits-warning-fix.patch
+smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
+lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks.patch
+lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
+selinux-setup-new-inode-ipc-getsecid-hooks.patch
+audit-use-new-lsm-hooks-instead-of-selinux-exports.patch
+netlink-use-generic-lsm-hook.patch
+selinux-remove-redundant-exports.patch
+lsm-audit-introduce-generic-audit-lsm-hooks.patch
+lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
+audit-internally-use-the-new-lsm-audit-hooks.patch
+selinux-use-new-audit-hooks-remove-redundant-exports.patch
+selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
+audit-final-renamings-and-cleanup.patch
+audit-final-renamings-and-cleanup-checkpatch-fixes.patch
+smack-make-smk_cipso_doi-and-smk_unlbl_ambient.patch

 Security updates

+alpha-handle-kcalloc-failure.patch
+alpha-remove-remaining-__function__-occurences.patch

 alpha updates

+m68k-replace-remaining-__function__-occurences.patch

 m68k update

+crisv10-prepare-for-bkl-push-down.patch

 cris..

+uml-replace-remaining-__function__-occurences.patch

 uml

+cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch
+cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch
+cpu-fix-section-mismatch-warnings-in-cpu_down.patch
+cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch
+tpm-fix-section-mismatch-warning.patch
+fs-ramfs-extern-cleanup.patch
+make-udf_error-static.patch
+fs-hfsplus-proper-externs.patch
+fs-freevxfs-proper-externs.patch
+make-__put_super-static.patch
+make-vfs_ioctl-static.patch
+fs-fs-writeback-make-2-functions-static.patch
+fs-drop_cachesc-make-2-functions-static.patch
+fs-aioc-make-3-functions-static.patch
+let-log_buf_shift-default-to-17.patch
+fs-timerfdc-should-include-linux-syscallsh.patch
+remove-generic_commit_write.patch
+make-fs-bufferccont_expand_zero-static.patch
+make-binfmt_flat-a-bool.patch
+remove-mca_is_adapter_used.patch
+autofs4-fix-sparse-warning-in-rootc.patch
+ipwireless-remove-dead-code.patch
+fs-remove-unused-fops-from-struct-char_device_struct.patch
+affs-handle-match_strdup-failure.patch
+hfs-handle-match_strdup-failure.patch
+hfsplus-handle-match_strdup-failure.patch
+lib-inflatec-handle-failed-malloc.patch
+simplify-initcall_debug-output.patch
+iomap-fix-64-bits-resources-on-32-bits.patch
+fs-affs-filec-use-bug_on.patch
+proper-__do_softirq-prototype.patch
+misc-phantom-add-compat-ioctl.patch
+misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
+misc-phantom-fix-poll.patch
+misc-phantom-consistent-whitespace.patch
+remove-the-macro-get_personality.patch
+exec-remove-argv_len-from-struct-linux_binprm.patch
+proper-extern-for-late_time_init.patch

 misc

+fs-inodec-use-hlist_for_each_entry.patch
+fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch

 VFS cleanup

+add-rcu_assign_index-if-ever-needed.patch
+add-rcu_assign_index-if-ever-needed-fix.patch
+rcu-split-listh-and-move-rcu-protected-lists-into-rculisth.patch
+rculisth-use-the-rcu-api.patch

 RCU updates

-inflate-refactor-inflate-malloc-code.patch
-inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch

 Dropped (I think)

+serial-silence-section-mismatch-warnings-in-8250_pci.patch
+serial-remove-double-initializer.patch
+char-make-functions-static-in-synclinkmpc.patch
+fix-tty-speed-handling-on-8250.patch
+uart_get_baud_rate-stop-mangling-termios.patch

 Serial updates

+spi-pxa2xx_spi-sparse-fixes.patch
+documentation-move-spidev_fdx-example-to-its-own-source-file.patch

 SPI updates

+vt-notifier-extension-for-accessibility.patch
+vt-notifier-extension-for-accessibility-checkpatch-fixes.patch

 VT updates

+kprobes-prevent-probing-of-preempt_schedule.patch
+kprobes-prevent-probing-of-preempt_schedule-fix.patch
+kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch

 kprobes updates

+capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
+avm-fix-sparse-warning-using-integer-as-null-pointer.patch
+eicon-fix-sparse-integer-as-null-pointer-warnings.patch

 ISDM updates

+i2o-remove-static-inline-forward-declarations.patch

 i2o cleanup

+xen-make-blkif_getgeo-static.patch

 xen clenaup

+remove-ecryptfs_header_cache_0.patch

 ecryptfs cleanup

+rtc-silence-section-mismatch-warning-in-rtc-test.patch
+make-ds1511_rtc_readset_time-static.patch

 RTC updates

+fbdev-use-div_round_up-or-roundup.patch
+pm2fb-correct-error-values-returned-from-probe-function.patch
+fbcon-replace-mono_col-macro-with-static-inline.patch
+fbcon-replace-mono_col-macro-with-static-inline-fix.patch
+gxfb-replace-fbsize-config-option-with-a-kernel-argument.patch
+gxfb-set-the-right-registers-to-tweak-the-sync-polarity.patch
+gxfb-dont-enable-the-crt-dacs-when-we-are-in-flatpanel-mode.patch
+gxfb-use-pci_device-for-gxfbs-pci-device-table.patch
+lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
+fbdev-defio-and-metronomefb-v4.patch
+arkfb-add-option-mode_option.patch
+s3fb-add-option-mode_option.patch
+fbdev-add-removed-option-mode-to-keep-compatibility.patch

 fbdev updates

+md-fix-integer-as-null-pointer-warnings-in-mdc.patch

 md update

+pnp-skip-dev-protocol-null-checks.patch
+pnp-simplify-quirk-debug-output.patch

 pnp updates

+ext2-improve-ext2_readdir-return-value.patch
+ext2-use-ext2_group_first_block_no.patch
+ext2-use-ext2_fsblk_t-type.patch
+use-page_cache_xxx-in-ext2.patch
+use-page_cache_xxx-in-ext2-fix.patch
+fs-ext2-use-bug_on.patch

 ext2 updates

+make-ext3_xattr_list-static.patch
+ext3-use-ext3_group_first_block_no.patch
+ext3-add-missing-ext3_journal_stop.patch
+ext3-use-ext3_get_group_desc.patch
+ext3-check-ext3_journal_get_write_access-errors.patch
+use-page_cache_xxx-in-fs-ext3.patch
+fs-ext3-use-bug_on.patch
+jbd-fix-the-way-the-b_modified-flag-is-cleared.patch
+jbd-fix-possible-journal-overflow-issues.patch

 ext3 updates

+udf-fix-sparse-warning-in-nameic.patch
+udf-fix-anchor-point-detection.patch

 UDF updates

+use-page_cache_xxx-in-fs-reiserfs.patch
+reiserfs-fix-sparse-warnings-in-fix_nodec.patch
+reiserfs-fix-sparse-warnings-in-do_balanc.patch
+reiserfs-fix-sparse-warning-in-nameic.patch
+reiserfs-fix-sparse-warnings-in-lbalancec.patch
+reiserfs-fix-sparse-warning-in-journalc.patch
+reiserfs-fix-more-sparse-warnings-in-do_balanc.patch

 reiserfs updates

+fat_valid_media-remove-pointless-test.patch
+fat-detect-media-without-partition-table-correctly.patch

 FATFS updates

+make-cgroup_enable_task_cg_lists-static.patch
+cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
+cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
+cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
+cgroup-api-files-add-res_counter_read_u64.patch
+cgroup-api-files-use-read_u64-in-memory-controller.patch
+cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
+cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
+cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
+cgroup-api-files-add-cgroup-map-data-type.patch
+cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
+cgroup-api-files-drop-mem_cgroup_force_empty.patch
+cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
+cgroup-api-files-make-cgroup_debug-default-to-off.patch

 Control groups updates

+kernel-cpusetc-make-3-functions-static.patch

 cpusets cleanup

+lock_task_sighand-add-rcu-lock-unlock.patch
+k_getrusage-dont-take-rcu_read_lock.patch
+do_task_stat-dont-take-rcu_read_lock.patch
+signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
+signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
+#signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch: Roland probs?
+signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
+signals-cleanup-security_task_kill-usage-implementation.patch

 signal management updates

+introduce-kill_orphaned_pgrp-helper.patch
+will_become_orphaned_pgrp-partially-fix-insufficient-exit_state-check.patch
+exit_notify-fix-kill_orphaned_pgrp-usage-with-mt-exit.patch

 pgrp handling updates

+ptrace-introduce-task_detached-helper.patch
+ptrace-introduce-ptrace_reparented-helper.patch
+reparent_thread-use-same_thread_group.patch
+document-de_thread-with-exit_notify-connection.patch

 ptrace updates

+workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
+workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
+cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch

 workqueue management updates

+simplify-cpu_hotplug_begin-put_online_cpus.patch

 CPU hotplug updates

+ext4-mm-ext4_ialloc-flexbg.patch
+ext4-mm-convert_ext4_to_use_unlocked_ioctl_v2.patch
+ext4-mm-ext4_reduce_mballoc_stack_usage_with_noinline.patch
+ext4-mm-ext4-convert-list_for_each_rcu-to_list_for_each_entry_rcu.patch
+ext4-mm-ext4-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
+ext4-mm-ext4_lex_add_cpu_conversion.patch
+ext4-mm-ext4-convert-byte-order-of-constant-instead-of-variable.patch
+ext4-mm-jbd2-sparse-warnings-in-revokec-journalc.patch
+ext4-mm-ext4-use-group-first-block-no.patch
+ext4-mm-ext4-use-ext4_get_group_desc.patch
+ext4-mm-ext4-check-ext4_journal_get_write_access-errors.patch
+ext4-mm-ext4-remove-extra_ext4_new_blocks_old_define-from-mballoc-c.patch
+ext4-mm-ext4_page_mkwrite.patch

 EXT4 tree updates

+make-ext4_xattr_list-static.patch
+use-page_cache_xxx-in-fs-ext4.patch
+fs-ext4-use-bug_on.patch
+jbd2-fix-the-way-the-b_modified-flag-is-cleared.patch
+jbd2-fix-possible-journal-overflow-issues.patch
+ext4-fix-mount-option-parsing.patch

 ext4 things

+ext4-is-broken.patch

 Disable ext4: it uses old interfaces which aren't in -mm any more.

+ipmi-remove-unused-target-and-action-in-makefile.patch

 IPMI cleanup

+amiserial-prepare-for-locking-relaxation-in-caller.patch
+cyclades-prepare-for-relaxed-locking-in-callers.patch
+epca-lock_kernel-push-down.patch
+esp-lock_kernel-push-down.patch
+isicom-prepare-for-lock_kernel-push-down.patch
+isicom-istallion-prepare-for-lock_kernel-pushdown.patch
+mxser-prepare-for-bkl-pushdown.patch
+nozomi-prepare-for-bkl-pushdown.patch
+riscom8-prepare-for-bkl-pushdown.patch
+rocket-prepare-for-bkl-pushdown.patch
+serial167-prepare-to-push-bkl-down-into-drivers.patch
+specialix-prepare-for-bkl-pushdown.patch
+stallion-prepare-for-bkl-push-down.patch
+sx-prepare-for-bkl-pushdown.patch
+synclink-series-prepare-for-bkl-pushdown.patch
+viocons-bkl-locking.patch
+vt_ioctl-prepare-for-bkl-push-down.patch
+isdn_tty-prepare-for-bkl-push-down.patch
+68360serial-note-that-there-isnt-any-info-mcr-locking.patch
+serial_core-prepare-for-bkl-push-down.patch
+redo-locking-of-tty-pgrp.patch
+resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
+tty_io-fix-remaining-pid-struct-locking.patch

 TTY updates

+char-moxa-remove-static-isa-support.patch
+char-moxa-cleanup-module-param-passed-isa-init.patch
+char-moxa-pci-io-space-fixup.patch
+char-moxa-fix-tiocg-ssoftcar-param.patch
+char-moxa-add-firmware-loading.patch
+char-moxa-merge-c2xx-and-c320-firmware-loading.patch
+char-moxa-remove-port-port.patch
+char-moxa-remove-unused-port-entries.patch
+char-moxa-centralize-board-readiness.patch
+char-moxa-timer-cleanup.patch
+char-moxa-ioctl-cleanup.patch
+char-moxa-merge-2-poll-functions.patch
+char-moxa-cleanup-rx-tx.patch
+char-moxa-serialise-timer.patch
+char-moxa-rework-open-close.patch
+char-moxa-little-cleanup.patch
+char-moxa-remove-useless-tty-functions.patch
+char-moxa-introduce-moxa_is_320-macro.patch
+char-moxa-notify-about-board-readiness.patch
+char-moxa-update-credits.patch
+char-moxa-add-firmware-loading-fix.patch
+char-fix-sparse-shadowed-variable-warnings-in-espc.patch
+char-espc-fix-possible-double-unlock.patch
+char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
+cycladesc-fix-sparse-shadowed-variable-warnings.patch
+epcac-static-functions-and-integer-as-null-pointer-fixes.patch
+epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch

 Char driver updates

+keys-add-keyctl-function-to-get-a-security-label-fix.patch

 Fix keys-add-keyctl-function-to-get-a-security-label.patch

+keys-switch-to-proc_create.patch

 key management fix

+procfs-task-exe-symlink.patch
+procfs-task-exe-symlink-fix.patch
+procfs-task-exe-symlink-fix-2.patch
+proc-switch-to-proc_create.patch

 procfs updates

+include-linux-sysctlh-remove-empty-else.patch
+sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
+sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
+sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch

 sysctl updates

+free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
+use-find_task_by_vpid-in-taskstats.patch
+deprecate-find_task_by_pid.patch
+deprecate-find_task_by_pid-warning-fix.patch

 PID management updates

+edd-add-default-mode-config_edd_off=n-override-with-edd=onoff.patch
+edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch

 EDD updates

+generalize-asm-generic-ioctlh-to-allow-overriding-values.patch

 cleanup

+atmel_tc-library.patch
+atmel_tc-clocksource-clockevent-code.patch

 atmel_tc updates

+remove-aoedev_isbusy.patch

 AOE update

+make-marker_debug-static.patch

 markers cleanup

+modules-warn-about-suspicious-return-values-from-modules-init-hook.patch

 modules debugging aid

+pidns-make-pid-level-and-pid_ns-level-unsigned.patch

 namespaces update

+mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch

 Fix mm-bdi-export-bdi-attributes-in-sysfs.patch even more

+basic-braille-screen-reader-support.patch
+basic-braille-screen-reader-support-fixes.patch
+basic-braille-screen-reader-support-ppc-fix.patch
+basic-braille-screen-reader-support-doc.patch

 Support braille readers during early boot

+mm-remove-remaining-__function__-occurances.patch
+block-remove-remaining-__function__-occurances.patch
+kernel-replace-remaining-__function__-occurances.patch
+lib-replace-remaining-__function__-occurances.patch

 cleanups

+reiser4-code-cleanups.patch

 reiser4 update

-profile-likely-unlikely-macros-fix.patch

 Folded into profile-likely-unlikely-macros.patch

+put_pid-make-sure-we-dont-free-the-live-pid.patch

 put_pid() debugging



2993 commits in 1101 patch files

All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/patch-list


