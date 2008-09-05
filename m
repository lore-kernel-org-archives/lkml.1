Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYIEFkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYIEFkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 01:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbYIEFkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 01:40:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755582AbYIEFkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 01:40:09 -0400
Date: Thu, 4 Sep 2008 22:40:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc5-mm1
Message-Id: <20080904224004.d3dd3076.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.27-rc5/2.6.27-rc5-mm1/

- This kernel doesn't work very well if selinux is enabled: /proc/net
  breaks.

- suspend-to-RAM (and probably -to-disk) has regressed on one machine.

- Various other weird bumps, bangs and rattles, all of which have been
  reported, not all of which have been acknowledgedacpi^W^W^W^W.

- I seem to have a very large number of patches outstanding against a
  very large number of subsystems.  Many of which have already been sent
  to the relevant maintainer at least once.


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



Changes since 2.6.27-rc1-mm1:

 origin.patch
 git-jg-misc.patch
 git-libata-all.patch
 git-xtensa.patch

 git trees

-remove-newline-from-the-description-of-module-parameters.patch
-pnp-fix-formatting-of-dbg_pnp_show_resources-output.patch
-missing-symbol-prefix-on-vmlinuxldsh.patch
-missing-symbol-prefix-on-vmlinuxldsh-checkpatch-fixes.patch
-mm-hugetlb-dont-crash-when-hpage_shift-is-0.patch
-seq_file-fix-bug-when-seq_read-reads-nothing.patch
-pci-make-pci_register_driver-a-macro.patch
-acpi-add-checking-for-null-early-param.patch
-calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
-use-warn-in-arch-x86-mm-ioremapc.patch
-use-warn-in-arch-x86-mm-pageattrc.patch
-use-warn-in-arch-x86-kernel.patch
-arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
-i386-vmalloc-size-fix.patch
-x86-calgary-replace-num_dma_pages-with-iommu_num_pages.patch
-x86-export-is_uv_system.patch
-x86-tracehook_signal_handler.patch
-x86-tracehook-syscall.patch
-x86-tracehook-asm-syscallh.patch
-x86-signals-use-asm-syscallh.patch
-x86-tracehook-tif_notify_resume.patch
-intel_agp-official-name-for-gm45-chipset.patch
-amd64-agp-run-fallback-when-no-bridges-found-not-when-driver-registration-fails.patch
-agp-use-dev_printk-when-possible.patch
-ppc-use-the-common-ascii-hex-helpers.patch
-powerpc-replace-__function__-with-__func__.patch
-drivers-base-driverc-remove-unused-to_dev-macro.patch
-dev_printk-constify-the-dev-argument.patch
-drm-remove-defines-for-non-linux-systems.patch
-sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
-sis-drm-fix-a-pointer-cast-warning.patch
-v4l-link-tuner-before-saa7134.patch
-v4l-drx397xdc-sparse-annotations.patch
-v4l-drx397xdc-replace-__function__-occurrences.patch
-v4l-fix-kernel-doc-warning-function-name-and-docbook-filename.patch
-drivers-media-video-vinoc-needs-v4l2-ioctlh.patch
-i2c-renesas-highlander-fpga-smbus-support.patch
-hid-wellspring-device-quirks.patch
-migrate_timers-add-comment-use-spinlock_irq.patch
-drivers-input-serio-xilinx_ps2c-fix-warning.patch
-wistron_btns-add-support-for-fujitsu-siemens-amilo-pro-edition-v3505.patch
-maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
-input-bcm5974-055-smoother-motion-irq-simplification.patch
-genksyms-parser-fix-the-__attribute__-rule.patch
-genksyms-include-extern-information-in-dumps.patch
-libata-scsi-dont-start-hotplug-work-queue-if-hotplug-is-disabled.patch
-libata-core-make-sure-that-ata_force_tbl-is-freed-in-case-of-an-error.patch
-pata_viac-add-flag-for-vx800-and-add-a-function-for-fixing-internal-bugs-for-via-chipsets.patch
-cdrom-dont-check-cdc_play_audio-in-cdrom_count_tracks.patch
-drivers-mtd-nand-nandsimc-needs-div64h.patch
-jffs2-summary-allocation-dont-use-vmalloc.patch
-mtd-diskonchipc-fix-sparse-endian-warnings.patch
-mtdpart-handle-remaining-checkpatch-findings.patch
-blackfin-nfc-driver-fix-bug-do-not-clobber-the-status-from-the-first-256-bytes-if-operating-on-512-pages.patch
-blackfin-nfc-driver-fix-bug-hw-ecc-calc-by-making-sure-we-extract-11-bits-from-each-register-instead-of-10.patch
-blackfin-nfc-driver-add-support-for-the-ecc-layout-the-blackfin-bootrom-uses.patch
-blackfin-nfc-driver-add-proper-devinit-devexit-markings-to-probe-remove-functions.patch
-blackfin-nfc-driver-enable-blackfin-nand-hwecc-support-by-default.patch
-blackfin-nfc-driver-use-standard-dev_err-rather-than-printk.patch
-blackfin-nfc-driver-cleanup-the-error-exit-path-of-bf5xx_nand_probe-function.patch
-drivers-mtd-nand-nandsimc-fix-printk-warnings.patch
-mtd-dataflash-otp-support.patch
-random32-seeding-improvement.patch
-bridge-send-correct-mtu-value-in-pmtu.patch
-bridge-send-correct-mtu-value-in-pmtu-revised.patch
-net-use-the-common-ascii-hex-helpers.patch
-atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
-atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
-bluetooth-add-quirks-for-a-few-hci_usb-devices.patch
-nsc-ircc-default-to-dongle-type-9-on-ibm-hardware.patch
-irda-replace-__function__-with-__func__.patch
-hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
-isdn-use-the-common-ascii-hex-helpers.patch
-via-velocity-give-a-structure-to-the-rx-tx-fields.patch
-via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
-hamradio-add-missing-sanity-check-to-tty-operation.patch
-pegasus-add-blacklist-support-to-fix-belkin-bluetooth-dongle.patch
-drivers-net-ehea-ehea_mainc-release-mutex-in-error-handling-code.patch
-tg3-adapt-tg3-to-use-reworked-pci-pm-code.patch
-sky2-adapt-to-use-reworked-pci-pm-code.patch
-configure-out-file-locking-features.patch
-use-warn-in-kernel-lockdepc.patch
-sched-do_wait_for_common-use-signal_pending_state.patch
-wait_task_inactive-dont-consider-task-nivcsw.patch
-sched-type-fix.patch
-netfilter-conntrack_helper-needs-to-include-rculisth.patch
-drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
-drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
-cxacru-fix-printk-format-flag-in-error-message.patch
-cdc-acm-dont-unlock-acm-mutex-on-error-path.patch
-usb-move-usb-mon-up-to-misc-options-in-kconfig.patch
-pl2023-remove-usb-id-4348-5523-handled-by-ch341.patch
-usb-storage-unusual_devs-entries-for-iriver-t10-and-datafab-cfsm-reader.patch
-usb-core-driver-fix-warning.patch
-usb-hubc-fix-build-with-config_pm=n.patch
-ath5k-mask-out-unneeded-interrupts.patch
-ath5k-unify-resets.patch
-net-ieee80211-adjust-error-handling.patch
-wireless-replace-__function__-with-__func__.patch
-xfs-use-get_unaligned_-helpers.patch
-xfs-clean-up-stale-references-to-semaphores.patch
-xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion.patch
-xfs-extend-completions-to-provide-xfs-object-flush-requirements.patch
-xfs-replace-inode-flush-semaphore-with-a-completion.patch
-xfs-replace-dquot-flush-semaphore-with-a-completion.patch
-xfs-remove-the-sema_t-from-xfs.patch
-xtensa-warn-about-including-asm-rwsemh-directly.patch
-xtensa-replace-remaining-__function__-occurences.patch
-xtensa-use-newer-__spin_lock_unlocked-macro.patch
-modules-extend-initcall_debug-functionality-to-the-module-loader.patch
-powerpc-86xx-mpc8610_hpcd-add-watchdog-node.patch
-kdump-report-actual-value-of-vmcoreinfo_osrelease-in-vmcoreinfo.patch
-vt8623fb-fix-kernel-oops.patch
-block-ccissc-remove-pointless-curr_queue-calculation.patch
-spi-new-orion_spi-driver.patch
-spi-new-orion_spi-driver-fixes.patch
-relay-fix-4-off-by-one-errors-occuring-when-writing-to-a-cpu-buffer.patch
-semaphore-__down_common-use-signal_pending_state.patch
-genirq-better-warning-on-irqchip-set_type-failure.patch
-proc-fix-inode-number-bogorithmetic.patch
-proc-switch-inode-number-allocation-to-ida.patch
-blackfin-rtc-driver-if-we-dont-define-irq_set_freq-the-common-rtc-dev-layer-will-give-us-the-same-behavior-of-returning-enotty.patch
-blackfin-rtc-driver-fix-bug-only-rtc-interrupt-can-wake-up-deeper-sleep-core.patch
-blackfin-rtc-driver-add-support-for-power-management-framework.patch
-blackfin-rtc-driver-dont-bother-passing-the-rtc-struct-down-to-bfin_rtc_int_setclear-since-it-isnt-needed-shaves-off-100bytes.patch
-blackfin-rtc-driver-disable-the-write-complete-irq-upon-close.patch
-blackfin-rtc-driver-wait-for-the-write-complete-interrupt-complete-before-sleeping.patch
-blackfin-rtc-driver-convert-pie-handling-to-irq_set_state-as-pointed-out-by-david-brownell.patch
-blackfin-rtc-driver-drop-pie-stopwatch-code-since-the-hardware-can-only-do-a-max-of-1hz-and-this-same-functionality-is-provided-by-uie.patch
-backlight-add-more-information-output-to-pwm_backlight.patch
-backlight-add-module_alias-to-pwm_backlight-driver.patch
-remove-the-deprecated-cli-sti-functions.patch
-drivers-telephony-ixjc-depends-on-pnp.patch
-docsrc-build-documentation-sources.patch
-docsrc-fix-procfs-example.patch
-docsrc-fix-ifenslave-type.patch
-docsrc-fix-crc32hash-type.patch
-docsrc-fix-getdelays-printk-formats.patch
-firmware-use-dev_printk-when-possible.patch
-make-ioctlh-compatible-with-userland.patch
-rtc-pcf8563-remove-client-validation.patch
-rtc-m48t59-reduce-structure-m48t59_private.patch
-ali-m7101-pmu-also-available-on-sun-netras-too.patch
-firmware-memmap-cleanup.patch
-applesmc-support-for-intel-imac.patch
-applesmc-add-support-for-macbook-v3.patch
-drivers-hwmon-w83791dc-fix-unused-var-warning.patch
-hwmon-adc124s501-generic-driver.patch
-hwmon-adc124s501-generic-driver-update.patch
-i5k_amb-provide-labels-for-temperature-sensors.patch
-drivers-mtd-chips-jedec_probec-fix-am29dl800bb-device-id.patch
-forcedeth-bug-fix-realtek-phy-8211c-errata.patch
-drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
-maintainers-mention-lockd-and-sunrpc-in-nfs-entries.patch
-rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
-ftrace-disable-function-tracing-bringing-up-new-cpu.patch
-ftrace-make-output-nicely-spaced-for-up-to-999-cpus.patch
-clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
-clocksource-keep-track-of-original-clocksource-frequency.patch
-clocksource-introduce-clocksource_forward_now.patch
-clocksource-introduce-clock_monotonic_raw.patch
-posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch
-posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch
-unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
-rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
-devpts-switch-to-ida.patch
-devpts-switch-to-ida-checkpatch-fixes.patch
-byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
-byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

 Merged into mainline or a subsystem tree

+res_counter-fix-off-by-one-bug-in-setting-limit.patch
+forcedeth-fix-kexec-regression.patch
+atmel_lcdfb-fix-oops-in-rmmod-when-framebuffer-fails-to-register.patch
+tracehook-comment-pasto-fixes.patch

 2.6.27 queue

-linux-next-git-rejects.patch
-linux-next-fixup.patch

 Unneeded

+security-selinux-include-netlabelh-fix-two-build-errors.patch
+mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
+drivers-mfd-ucb1400_corec-needs-gpio.patch
+drivers-mfd-ucb1400_corec-further-unbork.patch
+kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
+fb-metronome-printk-format-warning.patch

 linux-next fixes

+introduce-generic-header-file-for-the-software-io-tlb.patch

 Early 2.6.28

+acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically.patch
+acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically-cleanup.patch
+toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7.patch
+toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix.patch
+toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix-fix.patch
+acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch

 ACPI things

+x86-fix-shadowed-variable-warning.patch
+x86-use-dev_printk-in-quirk-message.patch
+x86-make-poll_idle-behave-more-like-the-other-idle-methods.patch
+x86-make-poll_idle-behave-more-like-the-other-idle-methods-checkpatch-fixes.patch
+x86-init-annotations-in-early_printk-setup.patch
+x86-adjust-dependencies-for-config_x86_cmov.patch
+x86-pgd_cdtor-cleanup.patch
+x86-x86_physvirt_bits-field-also-for-i386.patch
+x86-adjust-vmalloc_sync_all-for-xen-2nd-try.patch
+x86-fix-ticket-spin-lock-asm-constraints.patch
+x86-64-reduce-boot-fixmap-space.patch
+x86-64-add-two-__cpuinit-annotations.patch
+x86-64-eliminate-dead-code.patch
+x86-64-slightly-streamline-32-bit-syscall-entry-code.patch
+x86_64-add-memory-hotremove-config-option.patch
+arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
+x86-use-common-header-for-software-io-tlb.patch

 x86 things

+drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch

 ALSA fix

+agp-follow-lspci-device-vendor-style.patch

 AGP update

+powerpc-convert-config_ppc_merge-to-config_ppc-for-legacy-io-checks.patch

 powerpc tweak

+fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
+platform-add-new-device-registration-helper.patch

 device driver core updates

+v4l-dvb-gspca-fix-wrong-retry-counting.patch

 v4l

+fs-gfs2-use-an-is_err-test-rather-than-a-null-test.patch

 GFS fix

+fs-dlm-configc-choose-better-identifiers.patch

 DLM fix

+hid-fix-gyration-build-error.patch

 HID fix

+hrtimer-reorder-struct-hrtimer-to-save-8-bytes-on-64-bit-builds.patch
+ntp-improve-adjtimex-frequency-rounding.patch
+posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
+posix-timers-always-do-get_task_structtimer-it_process.patch
+posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
+posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
+posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
+posix-timers-sys_timer_create-cleanup-the-error-handling.patch
+posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
+posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
+posix-timers-lock_timer-make-it-readable.patch

 Time-management things

+ia64-uv-provide-a-led-driver-for-uv-systems.patch
+ia64-uv-use-led-to-indicate-cpu-is-active.patch
+ia64-uv-use-blinking-led-for-heartbeat-display.patch
+ia64-uv-use-blinking-led-for-heartbeat-display-fix.patch
+ia64-avoid-invoking-irq-handlers-on-offline-cpus.patch
+ia64-use-common-header-for-software-io-tlb.patch
+ia64-fix-the-difference-between-node_mem_map-and-node_start_pfn.patch

 ia64 things

+drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
+serio_raw-add-support-for-translated-serio_i8042xl-ports.patch
+bcm5974-064-minor-cleanups-for-scripts-checkpatchpl.patch
+bcm5974-064-finger-tracking-and-counting-improved-further.patch
+bcm5974-063-btn_touch-event-added-for-mousedev.patch

 input things

+scripts-package-dont-break-if-%_smp_mflags-isnt-set.patch
+scripts-package-allow-custom-options-to-rpm.patch
+scripts-checksyscallssh-fix-for-non-gnu-sed.patch
+setlocalversion-dont-include-svn-change-count.patch
+adjust-init-section-definitions.patch

 kbuild things

+leds-avoid-needless-strlen-for-attributes.patch
+leds-wrap-use-default-on-trigger-for-power-led.patch
+led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch

 LED things

+libata-fix-lba28-lba48-off-by-one-bug-in-atah.patch
+libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver.patch
+libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix.patch
+libata-reorder-ata_device-to-remove-8-bytes-of-padding-on-64-bits.patch
+pata_sil680-convert-config_ppc_merge-to-config_ppc.patch

 ata things

+m32r-export-empty_zero_page.patch
+m32r-export-__ndelay.patch
+m32r-kernel-cleanups.patch

 m32r things

-git-ubi-git-rejects.patch

 Unneeded

+mmc-fix-comment-in-include-linux-mmc-hosth.patch

 mmc fix

+mtd-maps-make-uclinux-mapping-driver-depend-on-mtd_ram-since-it-only-probes-that.patch
+tmio_nand-fix-base-address-programming.patch

 MTD things

+net-fix-compilation-ng-when-config_module.patch
+netfilter-xt_time-gives-a-wrong-monthday-in-a-leap-year.patch
+drivers-atm-use-div_round_up.patch
+drivers-net-wan-use-div_round_up.patch
+hci_usb-replace-mb-with-smp_mb.patch
+irda-follow-lspci-device-vendor-style.patch

 net things

+drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch
+misdn-endian-annotations-for-struct-zt.patch
+misdn-annotate-iomem-pointer-and-add-statics.patch
+misdn-misc-timerdev-fixes.patch

 ISDN things

+skty2-adapt-to-the-reworked-pci-pm.patch
+e100-adapt-to-the-reworked-pci-pm.patch
+the-overdue-eepro100-removal.patch
+forcedeth-add-pci_enable_device-to-nv_resume.patch
+driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set.patch
+fs-enet-remove-code-associated-with-config_ppc_merge.patch
+netdev-drop-config_ppc_merge-from-kconfig.patch
+e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning.patch
+e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-checkpatch-fixes.patch
+e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-fix.patch
+forcdeth-increase-max_interrupt_work.patch
+atl1e-remove-the-unneeded-struct-atl1e_adapter.patch

 netdev things

+backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
+backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2.patch
+backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch

 backlight things

+bq27x00_battery-use-unaligned-access-helper.patch

 battery things

+nfs-err_ptr-is-expected-on-failure-from-nfs_do_clone_mount.patch
+sunrpc-do-not-pin-sunrpc-module-in-the-memory.patch
+nfs-remove-8-bytes-of-padding-from-struct-nfs_fattr-on-64-bit-builds.patch

 NFS things

+parisc-lib-make-code-static.patch
+drivers-parisc-make-code-static.patch

 parisc things

+pci-tidy-pme-support-messages-checkpatch-fixes.patch

 pci thing

+arch-s390-kernel-ptracec-fix-build.patch

 repair s390

+initramfs-fix-compilation-warning.patch
+less-softirq-vectors.patch
+dyn_array-use-%pf-instead-of-print_fn_descriptor_symbol.patch
+dyn_array-fix-typo.patch
+sched-fix-init_hrtick-section-mismatch-warning.patch
+sched-clarify-ifdef-tangle.patch
+lockstat-documentation-update.patch
+fix-fastboot-make-the-raid-autodetect-code-wait-for-all-devices-to-init.patch
+rcu-spinlocks-take-an-unsigned-long-flags.patch
+rcu-fix-sparse-shadowed-variable-warning.patch
+ftrace-warn-on-failure-to-disable-mcount-callers.patch
+ftrace-remove-direct-reference-to-mcount-in-trace-code.patch

 random ingo stuff

+scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
+drivers-scsi-a2091c-make-2-functions-static.patch
+drivers-scsi-a3000c-make-2-functions-static.patch
+drivers-scsi-use-div_round_up.patch
+drivers-scsi-megaraid-use-div_round_up.patch
+drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch

 More scsi things :(

-git-block-git-rejects.patch

 Unneeded

+drivers-block-use-div_round_up.patch
+floppy-support-arbitrary-first-sector-numbers.patch

 block things

+drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32.patch

 Repair sparc32 build

+usb-remove-code-associated-with-config_ppc_merge.patch
+drivers-usb-misc-use-an-is_err-test-rather-than-a-null-test.patch
+drivers-usb-musb-disable-it-on-superh.patch

 usb things

+fs_mbcache-dont-needlessly-make-it-built-in.patch
+vfs-make-security_inode_setattr-calling-consistent.patch
+vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
+include-linux-fsh-put-declarations-in-__kernel__.patch

 vfs things

+pika-warp-appliance-watchdog-timer.patch

 watchdog thing

+ath9k-uses-needs-led_classdev_register.patch

 wireless thing

+modules-remove-stop_machine-during-module-load.patch
+modules-remove-stop_machine-during-module-load-checkpatch-fixes.patch

 modules things

+async_tx-fix-the-bug-in-async_tx_run_dependencies.patch
+rtc-bunch-of-drivers-fix-no-irq-case-handing.patch

 More 2.6.27 things

+drivers-media-video-cafe_ccicc-needs-mmh.patch
+jbd2-abort-instead-of-waiting-for-nonexistent-transactions.patch
+misdn-dsp_cmxc-fix-size-checks.patch
+h8300-kallsyms-exclude-local-symbols.patch
+leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling.patch
+drivers-mmc-card-blockc-fix-refcount-leak-in-mmc_block_open.patch
+drivers-net-skfp-pmfc-use-offsetof-macro.patch
+drivers-net-atl1e-dont-take-the-mdio_lock-in-atl1e_probe.patch
+e1000e-prevent-corruption-of-eeprom-nvm.patch
+drivers-net-mlx4-allocc-needs-mmh.patch
+nec-fix-for-hibernate-and-rmmod-oops-fix.patch
+net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch
+net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2-fix.patch
+nfs-bug_on-in-nfs_follow_mountpoint.patch
+fix-pciehp_free_irq.patch
+pci-hotplug-fakephp-fix-deadlock-again.patch
+sched_clock-fix-nohz-interaction.patch
+acpi_pmc-use-proper-read-function-also-in-errata-mode.patch
+acpi_pmc-check-for-monotonicity.patch
+clockevents-prevent-clockevent-event_handler-ending-up-handler_noop.patch
+x86-delay-early-cpu-initialization-until-cpuid-is-done.patch
+x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx.patch
+x86-add-io-delay-quirk-for-presario-f700.patch
+posix-timers-use-struct-pid-instead-of-struct-task_struct.patch
+posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch
+posix-timers-simplify-de_thread-exit_itimers-path.patch

 Things which might be needed in 2.6.27 but which go via subsystem trees.

+memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
+mm-owner-fix-race-between-swap-and-exit.patch
+mm-owner-fix-race-between-swap-and-exit-fix.patch
+mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
+hugetlb-handle-updating-of-accessed-and-dirty-in-hugetlb_fault.patch
+show-memory-section-to-node-relationship-in-sysfs.patch
+mlock-mlocked-pages-are-unevictable-fix.patch
+doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch
+mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-__mlock_vma_pages_range-comment-block.patch
+mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap.patch
+mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch.patch
+mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
+mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race.patch
+mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region.patch
+mlock-revert-mainline-handling-of-mlock-error-return.patch
+mlock-make-mlock-error-return-posixly-correct.patch
+mlock-make-mlock-error-return-posixly-correct-fix.patch
+mm-pagecache-insertion-fewer-atomics.patch
+mm-unlockless-reclaim.patch
+mm-page-lock-use-lock-bitops.patch
+fs-buffer-lock-use-lock-bitops.patch
+mm-page-allocator-minor-speedup.patch
+mm-rewrite-vmap-layer.patch
+mm-rewrite-vmap-layer-fix.patch
+mm-rewrite-vmap-layer-fix-fix.patch
+mm-rewrite-vmap-layer-fix-fix-fix.patch
+mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

 Memory management updates

+uclinux-fix-gzip-header-parsing-in-binfmt_flatc.patch

 nommu

+h8300-update-timer-handler-delete-files.patch
+h8300-update-timer-handler-new-files.patch
+h8300-update-timer-handler-misc-update.patch
+h8300-kconfig-cleanup.patch
+h8300-generic_bug-support.patch
+h8300-generic_bug-support-checkpatch-fixes.patch
+asm-h8300-mdh-remove-cvs-keyword.patch

 h8/300

+alpha-miata-remove-dead-url.patch

 alpha

+pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
+pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
+#
+container-freezer-add-tif_freeze-flag-to-all-architectures.patch
+container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
+container-freezer-make-refrigerator-always-available.patch
+container-freezer-implement-freezer-cgroup-subsystem.patch
+container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
+container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig.patch
+container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process.patch
+container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
+container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch
+container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
+container-freezer-prevent-frozen-tasks-or-cgroups-from-changing.patch
+container-freezer-make-freezer-state-names-less-generic.patch
+container-freezer-rename-check_if_frozen.patch
+container-freezer-document-the-cgroup-freezer-subsystem.patch

 Power managememt

+maintainers-remove-hga-framebuffer-driver-entry.patch
+include-linux-mounth-remove-cvs-keyword.patch
+kernel-dmac-remove-a-cvs-keyword.patch
+inith-remove-long-dead-__setup_null_param-macro.patch
+drivers-misc-use-div_round_up.patch
+fs-make-linux-kernel-parsers-match_table_t-const.patch
+eeepc-laptop-use-standard-interfaces.patch
+fix-documentation-filesystems-ramfs-rootfs-initramfstxt.patch
+nubus-fix-mis-indented-statement.patch
+identify_ramdisk_image-correct-typo-about-return-value-in-comment.patch
+fix-random-typos.patch
+add-phys_addr_t-for-holding-physical-addresses.patch
+make-pfn_phys-explicitly-return-phys_addr_t.patch
+redefine-resource_size_t-as-phys_addr_t.patch
+separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh.patch
+separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
+separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
+fix-a-race-condtion-of-oops_in_progress.patch
+fix-a-race-condtion-of-oops_in_progress-fix.patch
+percpu-counters-clean-up-percpu_counter_sum_and_set-interface.patch
+vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch
+vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
+wait-kill-is_sync_wait.patch
+kconfig-eliminate-def_bool-n-constructs.patch
+initramfs-add-option-to-preserve-mtime-from-initramfs-cpio-images.patch
+make-taint-bit-reliable-v3.patch
+make-taint-bit-reliable-v3-fix.patch

 Misc

+compat-move-cp_compat_stat-to-common-code.patch
+compat-generic-compat-get-settimeofday.patch
+compat-generic-compat-get-settimeofday-checkpatch-fixes.patch

 compat hnadling

+x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
+sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
+powerpc-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
+introduce-generic-iommu_num_pages-function.patch
+x86-convert-gart-driver-to-generic-iommu_num_pages-function.patch
+x86-amd-iommu-convert-driver-to-generic-iommu_num_pages-function.patch
+x86-convert-calgary-iommu-driver-to-generic-iommu_num_pages-function.patch
+powerpc-use-iommu_num_pages-function-in-iommu-code.patch
+alpha-use-iommu_num_pages-function-in-iommu-code.patch
+sparc64-use-iommu_num_pages-function-in-iommu-code.patch

 IOMMU

+checkpatch-square-brackets-exemption-for-array-slices-in-braces.patch
+checkpatch-values-double-ampersand-may-be-unary.patch
+checkpatch-conditional-indent-labels-have-different-indent-rules.patch
+checkpatch-switch-indent-allow-plain-return.patch
+checkpatch-add-tests-for-the-attribute-matcher.patch
+checkpatch-____cacheline_aligned-et-al-are-modifiers.patch
+checkpatch-complex-macros-fix-up-extension-handling.patch
+checkpatch-fix-up-comment-checks-search-to-scan-the-entire-block.patch
+checkpatch-include-asm-checks-should-be-anchored.patch
+checkpatch-reduce-warnings-for-include-of-asm-fooh-to-check-from-arch-barc.patch
+checkpatch-report-any-absolute-references-to-kernel-source-files.patch
+checkpatch-report-the-real-first-line-of-all-suspect-indents.patch
+checkpatch-suspect-indent-skip-over-preprocessor-label-and-blank-lines.patch
+checkpatch-%lx-tests-should-hand-%%-as-a-literal.patch
+checkpatch-report-the-correct-lines-for-single-statement-blocks.patch
+checkpatch-perform-indent-checks-on-perl.patch
+checkpatch-version-022.patch
+checkpatch-case-default-checks-should-only-check-changed-lines.patch
+checkpatch-suppress-errors-triggered-by-short-patch.patch
+checkpatch-handle-comment-quote-nesting-correctly.patch
+checkpatch-check-line-endings-in-text-format-files.patch
+checkpatch-suspect-indent-count-condition-lines-correctly.patch
+checkpatch-ensure-we-only-apply-checks-to-the-lines-within-hunks.patch
+checkpatch-version-023.patch

 checkpatch updates

+oss-remove-references-to-dead-sound-oss-vars-aedsp16_msssbpro.patch

 OSS drivers

+binfmt_somc-add-module_license.patch

 binfmt

+make-probe_serial_gsc-static.patch
+serial-mpc52xx_uart-remove-code-associated-with-config_ppc_merge.patch

 serial

+mpc52xx_psc_spi-remove-code-associated-with-config_ppc_merge.patch

 spi

+i2o-fix-32-64bit-dma-locking.patch

 i2o

+drivers-net-xen-netfrontc-use-div_round_up.patch

 xen

+ecryptfs-remove-retry-loop-in-ecryptfs_readdir.patch

 ecryptfs

+autofs4-cleanup-autofs-mount-type-usage.patch
+autofs4-track-uid-and-gid-of-last-mount-requester.patch
+autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
+autofs4-devicer-node-ioctl-docoumentation.patch
+autofs4-add-miscellaneous-device-for-ioctls.patch
+autofs4-add-miscellaneous-device-for-ioctls-fix.patch
+autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
+autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch

 autofs

+rtc-pcf8563-remove-client-validation.patch
+rtc-ds1374-wakeup-support-update.patch
+rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
+rtc-rtc-rs5c372-add-support-for-ricoh-r2025s-d-rtc.patch
+rtc-file-close-consistently-disables-repeating-irqs.patch
+rtc-cmos-strongly-avoid-hpet-emulation.patch
+rtc-use-config_ppc-instead-of-config_ppc_merge.patch
+rtc-rtc-m41t80c-add-support-for-the-st-m41t65-rtc.patch

 rtc

+make-gpiochip-label-const.patch
+gpio-max7301-fix-the-race-between-chip-addition-and-pins-reconfiguration.patch

 gpio

+fb-push-down-the-bkl-in-the-ioctl-handler.patch
+fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
+radeonfb-revert-fix-radeon-ddc-regression.patch
+fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
+neofb-reduce-panning-function.patch
+viafb-viafbmodes-viafbtxt.patch
+viafb-viafbmodes-viafbtxt-fix.patch
+viafb-viafbmodes-viafbtxt-fix-fix.patch
+viafb-makefile-kconfig.patch
+viafb-accelc-accelh.patch
+viafb-accelc-accelh-checkpatch-fixes.patch
+viafb-accelc-accelh-update.patch
+viafb-chiph-debugh.patch
+viafb-dvic-dvih-globalc-and-globalh.patch
+viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
+viafb-hwc-hwh.patch
+viafb-hwc-hwh-checkpatch-fixes.patch
+viafb-ifacec-ifaceh-ioctlc-ioctlh.patch
+viafb-lcdc-lcdh-lcdtblh.patch
+viafb-makefile-shareh.patch
+viafb-tbl1636c-tbl1636h-tbldpasettingc-tbldpasettingh.patch
+viafb-viafbdevc-viafbdevh.patch
+viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
+viafb-viafbdevc-update.patch
+viafb-via_i2cc-via_i2ch-viamodec-viamodeh.patch
+viafb-via_utilityc-via_utilityh-vt1636c-vt1636h.patch
+viafb-maintainers-entry.patch
+fbdev-kconfig-update.patch
+fbdev-kconfig-update-fix.patch
+neofb-kill-some-redundant-code.patch
+vga16fb-remove-open_lock-mutex.patch
+neofb-remove-open_lock-mutex.patch
+tdfxfb-do-not-make-changes-to-default-tdfx_fix.patch
+intelfb-support-945gme-as-used-in-asus-eee-901.patch
+cirrusfb-remove-information-about-memory-size-during-mode-change.patch
+cirrusfb-simplify-clock-calculation.patch
+cirrusfb-remove-24-bpp-mode.patch
+cirrusfb-drop-device-pointers-from-cirrusfb_info.patch
+cirrusfb-use-modedb-and-add-mode_option-parameter-2nd-rev.patch
+cirrusfb-add-__devinit-attribute-to-probing-functions.patch
+cirrusfb-eliminate-crt-registers-from-global-structure.patch
+cirrusfb-drop-clock-fields-from-cirrusfb_regs-structure.patch
+atmel_lcdfb-disallow-setting-larger-resolution-than-the-framebuffer-memory-can-handle.patch
+efifb-imacfb-consolidation-hardware-support.patch

 fbdev

+pnp-remove-printk-with-outdated-version.patch
+pnp-make-the-resource-type-an-unsigned-long.patch
+pnp-make-the-resource-type-an-unsigned-long-fix.patch

 pnp

+telephony-remove-cvs-keywords.patch

 telephony

+ext2-fix-ext2-block-reservation-early-enospc-issue.patch

 ext2

+ext3-dont-try-to-resize-if-there-are-no-reserved-gdt-blocks-left.patch
+ext3-fix-ext3-block-reservation-early-enospc-issue.patch
+jbd-abort-instead-of-waiting-for-nonexistent-transactions.patch

 ext3

+hfsplus-quieten-down-mounting-hfsplus-journaled-fs-read-only.patch
+hfsplus-fix-buffer-overflow-with-a-corrupted-image.patch
+hfsplus-check-read_mapping_page-return-value.patch
+hfsplus-fix-another-bug-when-reading-a-corrupted-image.patch
+hfsplus-check-hfs_bnode_find-return-value.patch

 hfsplus

+reiserfs-procfsc-remove-cvs-keywords.patch
+fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch

 reiserfs

+quota-remove-cvs-keywords.patch

 quota

+cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
+cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch

 cgroups

+devcgroup-use-kmemdup.patch
+devcgroup-remove-unused-variable.patch
+devcgroup-remove-spin_lock.patch

 devcgroup

-memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
+memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
+memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
+memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
+memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
+memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch

 memrlimit controller

+cpuset-use-seq_cpumask-seq_nodemask.patch
+cpusetc-remove-extra-variable.patch

 cpusets

+irq-warn-about-irqf_disabledirqf_shared.patch

 genirq

+make-ptrace_untrace-static.patch

 ptrace

+kdump-update-elfcorehdr-documentation-to-reflect-supported-architectures.patch
+kdump-use-is_kdump_kernel-in-sba_init.patch
+kdump-add-is_vmcore_usable-and-vmcore_unusable.patch
+kdump-add-is_vmcore_usable-and-vmcore_unusable-update.patch
+kdump-use-is_vmcore_usable-and-vmcore_unusable-in-reserve_elfcorehdr.patch
+kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel.patch

 kdump

+message-queues-increase-range-limits.patch
+message-queues-increase-range-limits-checkpatch-fixes.patch

 IPC

+compat_binfmt_elf-definition-tweak.patch

 elf

+applicomc-fix-apparently-broken-code-in-do_ac_read.patch
+char-moxac-sparse-annotation.patch

 char drivers

+firmware-use-dev_printk-when-possible.patch

 firmware

+fs-partitions-acornc-remove-dead-code.patch

 partitions

+proc-move-sysrq-trigger-out-of-fs-proc.patch
+proc-fix-return-value-of-proc_reg_open-in-too-late-case.patch
+proc-proc_sys_root-tweak.patch
+proc-remove-dummy-vmcore_open.patch
+proc-remove-unused-get_dma_list.patch

 procfs

+sysctl-simplify-strategy.patch

 sysctl

+pid_ns-de_thread-kill-the-now-unneeded-child_reaper-change.patch
+pid_ns-kill-the-now-unused-task_child_reaper.patch

 pidns

+trace-code-and-documentation-merging-documentation-tracetxt-with-documentation-filesystems-relaytxt.patch
+rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements.patch
+rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements-fix.patch

 relayfs

+make-i82443bxgx_edac-coexist-with-intel_agp.patch

 edac

+parport-remove-cvs-keywords.patch

 parport

+tpm-work-around-bug-in-broadcom-bcm0102-chipset.patch
+tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch
+drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch

 tpm

+w1-be-able-to-manually-add-and-remove-slaves-fix.patch

 Fix w1-be-able-to-manually-add-and-remove-slaves.patch

+gru-driver-minor-updates.patch
+gru-driver-minor-updates-fix.patch

 GRU updates

+kernel-call-constructors-fix-3.patch
-gcov-create-links-to-gcda-files-in-build-directory.patch
+gcov-architecture-specific-compile-flag-adjustments-x86_64-fix-2.patch

 gcov

-resource-add-new-ioresource_clk-type-v2.patch
-i2c-sh_mobile-ioresource_clk-support.patch

 Dropped

+byteorder-add-new-headers-for-make-headers-install.patch
+byteorder-use-generic-c-version-for-value-byteswapping.patch

 byteorder

+ipc-semc-make-free_un-static.patch
+make-fs-proc-proc_sysctlc-grab_header-static.patch
+make-hp_wmi_notify-static.patch
+make-kprobesc-kretprobe_table_lock-static.patch
+acpi-use-bcd2bin-bin2bcd.patch
+alpha-use-bcd2bin-bin2bcd.patch
+cris-use-bcd2bin-bin2bcd.patch
+drivers-rtc-use-bcd2bin-bin2bcd.patch
+rtc-use-bcd2bin-bin2bcd.patch
+mips-use-bcd2bin-bin2bcd.patch
+mn10300-use-bcd2bin-bin2bcd.patch
+i2c-use-bcd2bin-bin2bcd.patch
+drivers-scsi-sr_vendorc-use-bcd2bin.patch
+remove-the-obsolete-bcdbin-binbcd-macros.patch
+include-linux-bcdh-remove-comments.patch
+fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
+fs-kconfig-move-autofs-autofs4-out.patch
+fs-kconfig-move-cifs-out.patch

 cleanups

+nilfs2-continuous-snapshotting-file-system.patch
+nilfs2-continuous-snapshotting-file-system-fix.patch
+nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch

 New log-based fs

+reiser4-compile-warning-cleanups.patch
+reiser4-use-wake_up_process-instead-of-wake_up-when-possible.patch
+reiser4-track-upstream-changes.patch

 reiser4 fixes

690 commits in 682 patch files

All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.27-rc5/2.6.27-rc5-mm1/patch-list

