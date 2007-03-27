Return-Path: <linux-kernel-owner+w=401wt.eu-S964828AbXC0E5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbXC0E5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 00:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964826AbXC0E5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 00:57:13 -0400
Received: from smtp.osdl.org ([65.172.181.24]:38731 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964828AbXC0E5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 00:57:11 -0400
Date: Mon, 26 Mar 2007 20:57:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc5-mm1
Message-Id: <20070326205706.a750bb35.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm1/


- The RSDL CPU scheduler is dropped again.  I'll do rc5-mm2 with it re-added.

- You may see this:

  init/missing_syscalls.c:5:27: error: linux/compile.h: No such file or directory

  during compilation.  It's probably a parallel-build bug in Sam's tree. 
  Just type make again.

- I dropped davem's net development tree due to a large collision with
  git-wireless.  I figured git-wireless would need more debugging ;)

- The IDE tree has been dropped because of a general mess against the recent
  IDE merge into mainline.  I'll restore it when Bart fixes it up.



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



Changes since 2.6.21-rc4-mm1:


 origin.patch
 git-acpi.patch
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
 git-ia64.patch
 git-ieee1394.patch
 git-infiniband.patch
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
 git-ioat.patch
 git-ocfs2.patch
 git-parisc.patch
 git-r8169.patch
 git-selinux.patch
 git-pciseg.patch
 git-s390.patch
 git-scsi-misc.patch
 git-scsi-rc-fixes.patch
 git-unionfs.patch
 git-watchdog.patch
 git-wireless.patch
 git-wireless-fixup.patch
 git-ipwireless_cs.patch
 git-gccbug.patch

 git trees

-drivers-char-agp-convert-to-generic-boolean.patch
-jdelvare-i2c-i2c-amd8111-missed-cleanup.patch
-jdelvare-i2c-i2c-i801-restore-initial-state.patch
-jdelvare-i2c-ds1374-check-for-workqueue-creation.patch
-cxgb3-add-sw-lro-support.patch
-8139too-fix-irq-problem-with-napi-netpoll.patch
-div64_64-common-code.patch
-allow-pktgen-to-work-with-loopback-devices.patch
-remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch
-smc-superio-chip-lpc47n227-not-identified-properly.patch
-mpt-fusion-handle-pci-layer-error-on-resume.patch
-mpt-fusion-handle-mpt_resume-failure-while-resuming.patch
-fusion-kernel-doc-warning-fixes.patch
-unionfs-sioq-not-__exit.patch
-gregkh-usb-usb-fix-usb-serial-regression.patch
-gregkh-usb-usb-two-more-device-ids-for-dm9601-usbnet-driver.patch
-gregkh-usb-usb-razr-v3i-unusual_devs.patch
-gregkh-usb-usb-necessary-update-for-mos7720-driver.patch
-gregkh-usb-airprime-usb-id-for-novatel-ev620-mini-pci-e-card.patch
-gregkh-usb-usb-fix-gadget-serial-response-on-usb_cdc_req_set_line_coding.patch
-usb-serial-io_edgeport-convert-to-generic-boolean.patch
-make-xfs-workqueues-nonfreezable.patch
-uhci-fix-problem-caused-by-lack-of-terminating-qh.patch
-blackfin-blackfin-i2c-driver-update-2.patch
-remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
-complain-about-missing-system-calls.patch
-complain-about-missing-system-calls-update.patch
-ptrace-needs-proc_fs.patch

 Merged into mainline or a subsystem tree.

+knfsd-allow-nfsd-readdir-to-return-64bit-cookies.patch
+knfsd-nfsd4-fix-inheritance-flags-on-v4-ace-derived-from-posix-default-ace.patch
+knfsd-nfsd4-demote-clientid-in-use-printk-to-a-dprintk.patch
+knfsd-nfsd4-remove-superfluous-cancel_delayed_work-call.patch
+md-allow-raid4-arrays-to-be-reshaped.patch
+md-clear-the-congested_fn-when-stopping-a-raid5.patch
+md-convert-compile-time-warnings-into-runtime-warnings.patch
+generic_serial-fix-decoding-of-baud-rate.patch
+correct-slow-acpi_pm-rating.patch
+isdn-fix-bchannel_bh-call-from-isar_bh.patch
+uml-fix-epoll.patch
+tty-minor-merge-correction.patch
+utsns-fix-config_uts_ns-behavior.patch
+drivers-spi-fix-section-mismatches.patch
+uml-fix-static-linking.patch
+uml-use-correct-register-file-size-everywhere.patch
+ntp-avoid-time_offset-overflows.patch
+ntp-avoid-time_offset-overflows-fix.patch
+drivers-eisa-pci_eisacpci_eisa_init-should-be-init.patch
+fix-struct-device-member-name-in-pcmcia-au1000_generic.patch
+block-io-errors-on-i2o-disk.patch
+ipcns-fix-config_ipc_ns-behavior.patch
+i2o-remove-markus-from-maintainers.patch
+fix-kernel-build-with-embedded-proc_fs-proc_sysctl.patch

 2.6.21 queue.

+hrtimers-fix-reprogramming-smp-race.patch

 Probaby 2.6.21.

+x86-msr-add-support-for-safe-variants.patch
+net-sunrpc-svcsockc-fix-a-check.patch

 Probably 2.6.22 material

+cpuidle-fix-boot-hang.patch
+cpuidle-unsigned-bitfield.patch
+acpi-dock-use-null-for-pointer.patch

 ACPI fixes

+git-avr32-fixup.patch

 Fix rejects in git-arv32.patch

-ibmebus-uevent-support.patch

 Broken.

+ibmebus-change-probe-remove-interface-from-using-loc-code-to-dt-path.patch

 powerpc update

+gregkh-driver-kobject-kobject_shadow_add-cleanup.patch

 Driver tree update

-uevent-improve-error-checking-and-handling.patch
-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
-kobject-kobject_shadow_add-cleanup.patch
-driver-core-handles-kobject_uevent-failure-while-device_add.patch
-driver-core-handle-sysfs_op-failure-while-device_add.patch

 Dropped due to firmware loader problems in rc4-mm1.

+fix-firmware-sample-code.patch

 Firmware loader documentation fix

+jdelvare-i2c-i2c-08-i2c_new_probed_device.patch
+jdelvare-i2c-i2c-09-document-i2c_new_device.patch
+jdelvare-i2c-i2c-algo-sgi-cleanup.patch
+jdelvare-i2c-i2c-blackfin-new-bus-driver.patch

 I2C tree updates

+jdelvare-hwmon-hwmon-coretemp-new-driver.patch
+jdelvare-hwmon-hwmon-coretemp-documentation.patch

 hwmon tree updates

+apple-smc-driver-hardware-monitoring-and-control.patch

 Macpro sensor driver

+git-ieee1394-vs-gregkh-driver-driver-core-use-attribute-groups-in-struct-device_type.patch

 Fix clash between Stefan and Greg.

+git-libata-all-ipr-fix.patch

 Fix git-libata-all bug.

+optional-led-trigger-for-libata.patch
+libata-misc-minor-merge-fixups.patch
+pata_pdc202xx_old-lba48-bug.patch
+pata_hpt37x-further-small-fixes.patch
+pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
+pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch

 sata/pata stuff

-ide-cmd64x-remove-broken-sw-mw-dma-support.patch
-ide-sl82c105-rework-pio-support.patch
-ide-sl82c105-dma-support-code-cleanup-take3.patch
-ide-cmd64x-interrupt-status-fixes-resend.patch
-ide-cmd64x-add-fix-enablebits.patch
-ide-cmd64x-procfs-code-fixes-cleanups.patch
-ide-cmd64x-use-interrupt-status-from-mrdmode-register.patch
-ide-cmd64x-add-back-mwdma-support.patch
-ide-ide-fix-dma-masks-v3.patch
-ide-ide-max-dma-mode-v3.patch
-ide-ide-tune-dma-helper.patch
-ide-ide-proc-fs.patch
-ide-ide-split-off-ioctls-from-settings-v2.patch
-ide-ide-move-settings-to-ide-proc.patch
-ide-ide-fix-cable-checks.patch
-ide-alim15x3-pio-fallback-fix.patch
-ide-alim15x3-use-ide-tune-dma.patch
-ide-pdc202xx_new-use-ide-tune-dma.patch
-ide-ide-register-hw-initializing-arg.patch
-ide-ide-proc-register-port.patch
-ide-ide-pci-pcibus-order.patch
-ide-pdc202xx_old-rewrite-mode-programming-v2.patch
-ide-serverworks-pio-mode-setup-fixes.patch
-ide-sis5513-pio-mode-setup-fixes.patch
-ide-ide-fix-pio-setup-on-resume-for-atapi.patch
-ide-it821x-pio-mode-setup-fixes.patch
-ide-siimage-swdma-mask-fix.patch
-ide-ide-cris-fix-speedproc-and-swdma-mask.patch
-ide-ide-dma-off-quietly-fix.patch
-ide-ide-no-mdma-udma-sharing-filter.patch
-ide-ide-tune-dma-2.patch
-ide-cs5530-sc1200-dma-cleanup.patch
-ide-cs5530-sc1200-add-speedproc.patch
-ide-sl82c105-add-speedproc.patch
-ide-ide-dma-enable.patch
-ide-ide-check-dma-words-validity.patch
-ide-ide-remove-ide-use-dma.patch

 Some were merged into mainline, the rest were dropped.

+mtd-support-for-auto-locking-flash-on-power-up.patch

 MTD featurette.

+forcedeth-fix-nic-poll.patch
+forcedeth-fix-tx-timeout.patch
+forcedeth-work-around-null-skb-dereference-crash.patch
+forcedeth-work-around-null-skb-dereference-crash-fix.patch

 Forcedeth fixes

+fix-irq-problem-with-napi-netpoll.patch
+delete-unused-header-file-linux-sdla_frh.patch
+delete-unused-header-file-linux-if_wanpipe_commonh.patch
+net-tun-tap-fixed-hw-address-handling.patch

 net fixes

-net-uninline-skb_put.patch
-net-uninline-skb_put-fix.patch

 Dropped

+pcmcia-allow-pcmcia-scsi-drivers-to-be-built-into-the.patch

 pcmcia fix

+gregkh-pci-pci-fix-multiple-definition-of-queue_pushbutton_work.patch
+gregkh-pci-pci-kernel-doc-fix.patch
+gregkh-pci-pci-piggy-bus.patch

 PCI tree updates

+fix-gregkh-pci-pci-piggy-bus.patch
+fix-gregkh-pci-pci-cleanup-the-includes-of-linux-pcih.patch

 Fix it.

+msi-read-flush-msi-x-table.patch

 MSI fix

+scsi-spi-transport-scsi-domain-validation-after-reset.patch
+scsi-newstyle-hotplug-coldplug-support.patch
+use-unchecked_isa_dma-in-sd_revalidate_disk.patch
+make-mptspi_target_destroy-static.patch
+fdomainc-get-rid-of-unused-stuff.patch

 SCSI fixes

+gregkh-usb-usb-io_edgeport-race-condition-in-counters.patch
+gregkh-usb-usb-overhaul-of-mos7840-driver.patch
+gregkh-usb-usb-io_edgeport-convert-to-generic-boolean.patch
+gregkh-usb-usb-dm9601-fix-sparse-null-warnings.patch
+gregkh-usb-usb-iowarriorc-fix-null-dereference.patch
+gregkh-usb-usb-gtcoc-fix-a-use-before-check.patch
+gregkh-usb-usb-fix-endianness-in-mos7720.patch
+gregkh-usb-uhci-add-some-warn_ons.patch
+gregkh-usb-usb-omninet-memory-leak-in-error-case.patch
+gregkh-usb-option-close-race.patch
+gregkh-usb-usb-sierra-close-race.patch
+gregkh-usb-usb-ati_remote2-add-channel-support.patch
+gregkh-usb-usb-add-power-level-sysfs-attribute.patch
+gregkh-usb-usb-gadget-storage-needs-block.patch
+gregkh-usb-usb-make-usbdevices-export-their-device-nodes-instead-of-using-a-separate-class.patch

 USB tree updates

-hack-to-make-wireless-work.patch

 Dropped.

+lguest-clean-up-some-references-inittext-warnings.patch
+lguest-clean-up-some-references-inittext-warnings-2.patch
+lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages-tidy.patch
+lguest-compile-hypervisors-into-the-lg-module-directly.patch

 Fix rustystuff

+x86_64-i386-add-command-line-length-to-boot-protocol.patch
+yet-another-function-to-load-cr3-register.patch
+allow-per-cpu-variables-to-be-page-aligned.patch
+i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
+i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda-fix.patch
+i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
+i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix.patch
+i386-gdt-cleanups-clean-up-cpu_init.patch
+i386-gdt-cleanups-cleanup-gdt-access.patch
+i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt.patch
+cleanup-rationalize-paravirt-wrappers.patch
+fix-x86_64-compilation-with-debug_sig-on.patch
+apmc-get-rid-of-unused-variables.patch
+apm-remove-the-apm_rtc_is_gmt-config-option.patch
+x86_64-use-lru-instead-of-page-index-and-page-private-for-pgd-lists-management.patch

 x86 updates

+drivers-mfd-sm501c-fix-an-off-by-one.patch
+pci-set-pci=bfsort-for-poweredge-r900.patch
+fix-sudden-warps-in-mousedev.patch
+fix-sysfs-rom-file-creation-for-bios-rom-shadows.patch
+libata-identify-backwards-for-drive-side-cable-detection.patch

 Things which I think should be in 2.6.21, but which are supposed to go via
 subsystem maintainers.

+mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
+mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix-2.patch

 Fix mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch

+mm-debug-check-for-the-fault-vs-invalidate-race.patch

 Add debug check.

+i386-add-ptep_test_and_clear_dirtyyoung.patch
+i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
+i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
+smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
+smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
+smaps-use-ptep_test_and_clear_young.patch

 More work on the new smaps feature.

+add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch
+anti-fragmentation-switch-over-to-pfn_valid_within.patch
+lumpy-move-to-using-pfn_valid_within.patch

 New version of lumpy reclaim

+mm-move-common-segment-checks-to-separate-helper-function-v7.patch
+mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
+slab-use-num_possible_cpus-in-enable_cpucache.patch
+slab-dont-allocate-empty-shared-caches.patch
+slab-numa-kmem_cache-diet.patch
+do-not-disable-interrupts-when-reading-min_free_kbytes.patch

 MM updates

+blackfin-arch-2.6.21-rc4-mm1-update.patch
+blackfin-arch-fix-struct-dmasg-packing-bug.patch
+blackfin-arch-cleanup-cache-header-file.patch
+blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
+blackfin-arch-fix-compiling-error-in-flat-c-file.patch
+blackfin-arch-power-management-replace-firmware-disk-mode.patch
+blackfin-arch-add-kdebug-header-file.patch
+blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
+blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
+blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch

 Blackfin updates

-nommu-hide-vm_mm-in-nommu-mode.patch

 Dropped, but I'll bring this back.

+swsusp-use-inline-functions-for-changing-page-flags.patch
+swsusp-do-not-use-page-flags.patch
+mm-remove-unused-page-flags.patch
+swsusp-fix-error-paths-in-snapshot_open.patch
+swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
+rework-pm_ops-pm_disk_mode-kill-misuse.patch
+power-management-remove-firmware-disk-mode.patch
+power-management-implement-pm_opsvalid-for-everybody.patch
+power-management-force-pm_opsvalid-callback-to-be.patch

 Swsusp and power-management work.

+array_size-check-for-type-uml-fix.patch

 Fix array_size-check-for-type.patch

+uml-move-sigio-testing-to-sigioc.patch
+uml-create-archh.patch
+uml-create-as-layouth.patch
+uml-move-remaining-useful-contents-of-user_utilh.patch
+uml-remove-user_utilh.patch
+uml-add-missing-__init-declarations.patch
+remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch

 UML updates

+merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
+merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix.patch
+merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch

 Fix merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch

+extend-print_symbol-capability-fix.patch

 Fix extend-print_symbol-capability.patch

-remove-unused-header-file-include-linux-elfnoteh.patch

 Dropped

+proc-maps-protection-fix-3.patch

 Change permissions on /proc/pid/maps

+fix-rmmod-read-write-races-in-proc-entries-fix.patch

 Fix fix-rmmod-read-write-races-in-proc-entries.patch

+tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch

 Fix tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch

+kprobes-fix-sparse-null-warning.patch
+add-ability-to-keep-track-of-callers-of-symbol_getput.patch
+add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
+update-mtd-use-of-symbol_getput.patch
+update-dvb-use-of-symbol_getput.patch
+move-die-notifier-handling-to-common-code.patch
+move-die-notifier-handling-to-common-code-fixes.patch
+move-die-notifier-handling-to-common-code-fixes-2.patch
+time-smp-friendly-alignment-of-struct-clocksource.patch
+time-smp-friendly-alignment-of-struct-clocksource-fix.patch
+char-rocket-add-module_device_table.patch
+char-cs5535_gpio-add-module_device_table.patch
+turn-do_sync_file_range-into-do_sync_mapping_range.patch
+remove-do_sync_file_range.patch
+protect-tty-drivers-list-with-tty_mutex.patch
+fix-bogus-softlockup-warning-with-sysrq-t.patch
+fix-sysfs-reclaim-crash.patch
+# more-scheduled-oss-driver-removal.patch: too early?
+more-scheduled-oss-driver-removal.patch
+schedule-obsolete-oss-drivers-for-removal-4th-round.patch
+delete-unused-header-file-math-emu-extendedh.patch
+fix-sscanf-%n-match-at-end-of-input-string.patch
+fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
+make-remove_inode_dquot_ref-static.patch
+fix-race-between-attach_task-and-cpuset_exit.patch
+delete-unused-header-file-linux-awe_voiceh.patch
+kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
+parport-dev-driver-model-support.patch
+legacy-pc-parports-support-parport-dev.patch
+layered-parport-code-uses-parport-dev.patch

 Misc

+ext4-use-null-for-pointers.patch

 ext4 cleanup

+minor-spi_butterfly-cleanup.patch

 SPI cleanup

+remove-nfs4_acl_add_ace.patch

 NFSD cleanup

-lists-add-list-splice-tail.patch
-sched-remove-sleepavg-from-proc.patch
-sched-remove-noninteractive-flag.patch
-sched-dont-renice-kernel-threads.patch
-sched-implement-rsdl-cpu-scheduler.patch
-sched-document-rsdl-cpu-scheduler.patch

 RSDL is dropped

+declare-struct-ktime.patch
+futex-priority-based-wakeup.patch
+make-futex_wait-use-an-hrtimer-for-timeout.patch
+make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
+make-futex_wait-use-an-hrtimer-for-timeout-fix-2.patch
+futex_requeue_pi-optimization.patch
+sys_futex64-allows-64bit-futexes.patch
+sys_futex64-allows-64bit-futexes-fix.patch
+sys_futex64-allows-64bit-futexes-workaround.patch

 futex features

-add-ability-to-keep-track-of-callers-of-symbol_getput.patch
-add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
-update-mtd-use-of-symbol_getput.patch
-update-dvb-use-of-symbol_getput.patch

 I think Sam merged this

-remove-the-likelypid-check-in-copy_process.patch

 Dropped

+dont-init-pgrp-and-__session-in-init_signals.patch

 Cleanup

+revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
+revoke-core-code-revoke-no-revoke-for-nommu.patch

 More work on the revoke() patches

+dm-call-clone_init-early.patch
+dm-do-not-access-the-bio-after-generic_make_request.patch
+dm-get-rid-of-first_clone-in-dm-crypt.patch
+dm-allocate-smaller-clones.patch

 DM fixes

+integrity-service-api-and-dummy-provider-integrity_dummy_verify_metadata.patch
+slim-main-lsm-getprocattr-hook-api-change.patch
+slim-integrity-patch.patch
+integrity-new-hooks.patch
+integrity-new-hooks-fix.patch
+integrity-fs-hook-placement.patch
+integrity-evm-as-an-integrity-service-provider.patch
+integrity-evm-as-an-integrity-service-provider-tidy.patch
+integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
+integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
+integrity-ima-integrity_measure-support.patch
+integrity-ima-integrity_measure-support-tidy.patch
+integrity-ima-integrity_measure-support-fix.patch
+integrity-ima-integrity_measure-support-fix-2.patch
+#integrity-mtime-patch-for-mmap-files.patch
+integrity-tpm-internal-kernel-interface.patch
+integrity-tpm-internal-kernel-interface-tidy.patch
+ibac-patch.patch

 Integrity driver feature work.

+vdso-print-fatal-signals-fix-compiling-error-bug-in.patch

 Fix vdso-print-fatal-signals-use-ctl_unnumbered.patch

+mm-only-hrtimers-debug-patch.patch
+mm-only-hrtimers-debug-patch-fix.patch

 hrtimers debug stuff.


All 1077 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm1/patch-list

