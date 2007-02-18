Return-Path: <linux-kernel-owner+w=401wt.eu-S1030317AbXBRFvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030317AbXBRFvy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 00:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932500AbXBRFvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 00:51:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59279 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbXBRFvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 00:51:52 -0500
Date: Sat, 17 Feb 2007 21:51:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20-mm2
Message-Id: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Temporarily at

  http://userweb.kernel.org/~akpm/2.6.20-mm2/

Will appear later at

 ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/


- There are IDE- and Xen-related module linkage errors during allmodconfig
  builds.  These have been reported.

- Quite a lot of less-popular architectures are broken by the utrace merge. 
  They will stay that way while the maintainers ponder
  http://people.redhat.com/roland/utrace/utrace-arch-porting-howto.txt

- Added the LED development tree to the -mm lineup as git-leds.patch
  (Richard Purdie <rpurdie@rpsys.net>)

- git-parisc.patch is back for a while

- git-audit.patch is back for a while

- git-drm.patch is still in disgrace

- Added Xen domain-U support

- Judging by the number of times I get asked "is there a git tree for -mm",
  nobody is reading the boilerplate.  Here it is again:



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




Changes since 2.6.20-mm1:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-arm.patch
 git-audit-master.patch
 git-avr32.patch
 git-cifs.patch
 git-powerpc.patch
 git-dvb.patch
 git-hid.patch
 git-ia64.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-leds.patch
 git-libata-all.patch
 git-ide.patch
 git-lxdialog.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-netdev-all.patch
 git-backlight.patch
 git-bluetooth.patch
 git-ioat.patch
 git-ocfs2.patch
 git-parisc.patch
 git-pciseg.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-block.patch
 git-unionfs.patch
 git-v9fs.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-gccbug.patch

 git trees

-gpio-core-documentation.patch
-build-errors-uevent-with-config_sysfs=n.patch
-mincore-config_swap=n-fix.patch
-mincore-fill-in-results-properly.patch
-mincore-vma-crossing-fix.patch
-acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
-ifdef-acpi_future_usage-acpi_os_readable.patch
-at91-correct-value-for-at91_rstc_key.patch
-powerpc-rtas-msi-support-fix.patch
-fix-cut-and-paste-breakage-in-arch-powerpc-platforms-pseries-pseriesh.patch
-powerpc-export-of_find_property.patch
-libata-add-a-host-flag-to-indicate-lack-of-iordy.patch
-add-delay-around-sl82c105_reset_engine-calls.patch
-sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
-sata_nv-handle-serror-status-indication.patch
-ata-convert-gsi-to-irq-on-ia64.patch
-git-md-accel-fixes.patch
-git-md-accel-warning-fixes.patch
-git-md-accel-fix.patch
-revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
-fix-atl1-braino.patch
-net-wan-pc300tooc-pci_module_init-to-pci_register_driver.patch
-atl1-drop-net_pci-from-kconfig.patch
-atl1-read-mac-address-from-register.patch
-atl1-remove-unused-define.patch
-atl1-add-l1-device-id-to-pci_ids-then-use-it.patch
-atl1-bump-version-number.patch
-atm-use-array_size-macro-when-appropriate.patch
-bugfixes-and-new-hardware-support-for-arcnet-driver.patch
-git-backlight-sony-fix.patch
-parisc-fix-module_param-iommu-permission.patch
-pa-risc-fix-bogus-warnings-from-modpost.patch
-use-__u64-rather-than-u64-in-parisc-statfs-structs.patch
-pci-add-systems-for-automatic-breadth-first-device-sorting-update.patch
-x86-fix-dev_to_node-for-x86-and-x86_64.patch
-remove-extra-newline-from-info-message.patch
-fix-scsi-scsi_transporth-compile-error.patch
-pci_module_init-convertion-in-the-legacy-megaraid-driver.patch
-scsi-handle-bad-inquiry-responses.patch
-scsi-megaraid_sas-donot-process-cmds-if-hw_crit_error-is-set.patch
-scsi-megaraid_sas-added-bios_param-in-scsi_host_template.patch
-scsi-megaraid_sas-replace-pci_alloc_consitent-with-dma_alloc_coherent-in-ioctl-path.patch
-scsi-megaraid_sas-update-version-and-author-info.patch
-lpfc-add-pci-error-recovery-support.patch
-ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd.patch
-gregkh-usb-usb-ps3-don-t-call-ps3_system_bus_driver_register-on-other-platforms.patch
-nokia-e70-is-an-unusual-device.patch
-ueagle-atmc-needs-schedh.patch
-x86_64-mm-copy-user-nocache.patch
-x86_64-mm-make-the-numa-hash-function-nodemap-allocation.patch
-x86_64-mm-x86_64-make-the-numa-hash-function-nodemap-allocation-fix-fix.patch
-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
-x86_64-mm-fix-a-typo-in-an-irq-handler-name.patch
-x86_64-mm-mmconfig-share.patch
-x86_64-mm-only-call-unreachable_devices-when-type-1-is-available.patch
-x86_64-mm-detect-and-support-the-e7520-and-the-945g-gz-p-pl.patch
-x86_64-mm-reserve-resources-but-only-when-were-sure-about-them.patch
-x86_64-mm-mmconfig-ioremap.patch
-x86_64-mm-mmconfig-reject-broken-table.patch
-x86_64-mm-mmconfig-cleanup-defines.patch
-x86_64-mm-mmconfig-more-cleanup.patch
-x86_64-mm-mmconfig-unreachable-devices.patch
-x86_64-mm-mmconfig-move-e820-check.patch
-x86_64-mm-get-rid-of-arch_have_xtime_lock.patch
-x86_64-mm-improved-iommu-documentation.patch
-x86_64-mm-do-not-always-end-the-stack-trace-with-ulong_max.patch
-x86_64-mm-e820-include.patch
-x86_64-mm-page-allocation-hooks-for-vmi-backend.patch
-x86_64-mm-paravirt-cpu-hypercall-batching-mode.patch
-x86_64-mm-iopl-handling-for-paravirt-guests.patch
-x86_64-mm-smp-boot-hook-for-paravirt.patch
-x86_64-mm-vmi-backend-for-paravirt-ops.patch
-x86_64-mm-vmi-timer.patch
-x86_64-mm-profile-pc-badness.patch
-x86_64-mm-kprobe-rpl-fix.patch
-x86_64-mm-vmi-timer-race.patch
-x86_64-mm-paravirt-debug-defaults-off.patch
-x86_64-mm-move-startup_32-in-texthead-section.patch
-x86_64-mm-break-init-in-two-parts-to-avoid-modpost-warnings.patch
-x86_64-mm-mcheck-include.patch
-x86_64-mm-add-idle-notifier.patch
-x86_64-mm-improve-sched_clock-on-i686.patch
-x86_64-mm-romsignature-checksum-cleanup.patch
-x86_64-mm-fix-fake-numa-for-x86_64-machines-with-big-io-hole.patch
-x86_64-mm-remove-fastcall-references-in-x86_64-code.patch
-x86_64-mm-use-constant-instead-of-raw-number-in-x86_64-iopermc.patch
-x86_64-mm-handle-32-bit-perfmon-counter-writes-cleanly-in-x86_64-nmi_watchdog.patch
-x86_64-mm-handle-32-bit-perfmon-counter-writes-cleanly-in-i386-nmi_watchdog.patch
-x86_64-mm-handle-32-bit-perfmon-counter-writes-cleanly-in-oprofile.patch
-x86_64-mm-cleanup-doc-x86_64-files.patch
-x86_64-mm-list-x86_64-quilt-tree.patch
-x86_64-mm-simplify-notify_page_fault.patch
-x86_64-mm-mce_amd-issues.patch
-x86_64-mm-mce-trigger.patch
-x86_64-mm-remove-get_pmd.patch
-x86_64-mm-fix-tlbflush-comment.patch
-x86_64-mm-kconfig-typos.patch
-x86_64-mm-msr-scf-single.patch
-x86_64-mm-mtrr-scf-single.patch
-x86_64-mm-fix-preprocessor-condition.patch
-x86_64-mm-apm-seqfile.patch
-x86_64-mm-fix-size_or_mask-and-size_and_mask.patch
-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration-code-update-1.patch
-x86_64-mm-putreg-check.patch
-x86_64-mm-unexport-supported-pte.patch
-x86_64-mm-fs-gs-clear.patch
-x86_64-mm-iommu-boundary.patch
-x86_64-mm-remove-rom-reservation.patch
-x86_64-mm-define-dma-noncoherent-api-functions.patch
-x86_64-mm-robustify-bad_dma_address-handling.patch
-x86_64-mm-all-transmeta-cpus-have-constant-tscs.patch
-x86_64-mm-avoid-gcc-extension.patch
-x86_64-mm-support-classic-mediagxm.patch
-x86_64-mm-entrys-end-endproc-annotations.patch
-x86_64-mm-clean-up-sparsemem-memory_present-call.patch
-x86_64-mm-remove-unused-kernel-config-option-x86_xadd.patch
-x86_64-mm-update-io-apic-dest-field-to-8-bit-for-xapic.patch
-x86_64-mm-avoid-warning-message-livelock.patch
-x86_64-mm-minor-patch-for-compilation-warning-in-x86_64-signal-code.patch
-x86_64-mm-add-option-to-show-more-code-in-oops-reports.patch
-x86_64-mm-geode-configuration-fixes.patch
-x86_64-mm-survive-having-no-irq-mapping-for-a-vector.patch
-x86_64-mm-fix-gcc-check.patch
-x86_64-mm-paravirt-remove-fastcall.patch
-x86_64-mm-fam10-cpuid.patch
-x86_64-mm-fam10-nmi-watchdog.patch
-x86_64-mm-fix-microcode-warning.patch
-x86_64-mm-i386-fix-transmeta-warning.patch
-x86_64-mm-fails-to-detect-mediagx.patch
-x86_64-mm-aout-no-vdso.patch
-x86_64-mm-compat-epoll-pwait.patch
-x86_64-mm-paravirt-unhandled-fallthrough.patch
-x86_64-mm-move-mce_disabled-to-asm-mceh.patch
-x86_64-mm-rename-cpu_gdt_descr-and-remove-extern-declaration-from-smpbootc.patch
-x86_64-mm-remove-extern-declaration-from-mm-discontigc-put-in-header.patch
-x86_64-mm-pcspeaker-cleanup.patch
-x86_64-mm-mtrr-compat.patch
-x86_64-mm-broken-config_compat_vdso-on-i386.patch
-x86_64-mm-remove-mk-pte-phys.patch
-rdmsr_on_cpu-wrmsr_on_cpu.patch
-x86_64-irq-simplfy-__assign_irq_vector.patch
-x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
-i386-probe_roms-cleanup.patch
-fix-mtrr-compat-ioctl.patch
-i386-pit_latch_buggy-has-no-effect.patch
-add-an-option-for-the-via-c7-which-sets-appropriate-l1.patch
-i386-adjustments-to-page-table-dump-during-oops-v3.patch
-x86-mtrr-range-check-correction.patch
-x86-consolidate-smp_send_stop.patch
-vmi-versus-hrtimers.patch
-add-irq-flag-to-disable-balancing-for-an-interrupt.patch
-add-a-functions-to-handle-interrupt-affinity-setting.patch
-add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
-hz-free-ntp.patch
-uninline-jiffiesh-functions.patch
-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
-fix-timeout-overflow-with-jiffies.patch
-gtod-persistent-clock-support.patch
-i386-use-gtod-persistent-clock-support.patch
-i386-remove-useless-code-in-tscc.patch
-simplify-the-registration-of-clocksources.patch
-x86-rewrite-smp-tsc-sync-code.patch
-clocksource-replace-is_continuous-by-a-flag-field.patch
-clocksource-replace-is_continuous-by-a-flag-field-fix.patch
-clocksource-fixup-is_continous-changes-on-arm.patch
-clocksource-fixup-is_continous-changes-on-avr32.patch
-clocksource-fixup-is_continous-changes-on-s390.patch
-clocksource-fixup-is_continous-changes-on-mips.patch
-clocksource-remove-the-update-callback.patch
-clocksource-add-verification-watchdog-helper.patch
-mark-tsc-on-geodelx-reliable.patch
-uninline-irq_enter.patch
-fix-cascade-lookup-of-next_timer_interrupt.patch
-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
-hrtimers-namespace-and-enum-cleanup.patch
-hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
-hrtimers-cleanup-locking.patch
-hrtimers-add-state-tracking.patch
-hrtimers-clean-up-callback-tracking.patch
-hrtimers-move-and-add-documentation.patch
-acpi-fix-missing-include-for-up.patch
-acpi-keep-track-of-timer-broadcasting.patch
-allow-early-access-to-the-power-management-timer.patch
-i386-apic-clean-up-the-apic-code.patch
-clockevents-add-core-functionality.patch
-tick-management-core-functionality.patch
-tick-management-broadcast-functionality.patch
-tick-management-dyntick--highres-functionality.patch
-clockevents-i383-drivers.patch
-i386-rework-local-apic-timer-calibration.patch
-i386-prepare-for-dyntick.patch
-i386-prepare-nmi-watchdog-for-dynticks.patch
-i386-enable-dynticks-in-kconfig.patch
-hrtimers-add-high-resolution-timer-support.patch
-hrtimers-prevent-possible-itimer-dos.patch
-add-debugging-feature-proc-timer_stat.patch
-add-debugging-feature-proc-timer_stat-cleanup.patch
-add-debugging-feature-proc-timer_list.patch
-add-sysrq-q-to-print-timer_list-debug-info.patch
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
-time-x86_64-hpet-fixup-clocksource-changes.patch
-time-x86_64-tsc-fixup-clocksource-changes.patch
-time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
-time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
-posix-timers-rcu-optimization-for-clock_gettime.patch
-posix-timers-rcu-optimization-for-clock_gettime-fix.patch
-genirq-do-not-mask-interrupts-by-default.patch
-genirq-remove-irq_disabled.patch
-irq-kernel-doc-fixes.patch
-small-irq-management-simplification.patch
-knfsd-nfsd4-fix-non-terminated-string.patch
-knfsd-nfsd4-relax-checking-of-acl-inheritance-bits.patch
-knfsd-nfsd4-simplify-nfsv4-posix-translation.patch
-knfsd-nfsd4-represent-nfsv4-acl-with-array-instead-of-linked-list.patch
-knfsd-nfsd4-fix-memory-leak-on-kmalloc-failure-in-savemem.patch
-knfsd-nfsd4-fix-error-return-on-unsupported-acl.patch
-knfsd-nfsd4-acls-dont-return-explicit-mask.patch
-knfsd-nfsd4-acls-avoid-unnecessary-denies.patch
-knfsd-nfsd4-fix-handling-of-directories-without-default-acls.patch
-knfsd-stop-nfsd-writes-from-being-broken-into-lots-of-little-writes-to-filesystem.patch
-ecryptfs-reduce-stack-usage-in-ecryptfs_generate_key_packet_set.patch
-ecryptfs-fix-forgotten-format-specifier.patch

 Merged into mainline or a subsystem tree

+fix-build-errors-if-bitop-functions-are-do-while-macros.patch
+xfs-warning-fix.patch
+machzwd-warning-fix.patch
+minix-v3-fix-superblock-definition.patch
+fix-missing-declaration-of-init_irq_proc.patch

 2.6.20-rc1 queue

+make-aout-executables-work-again-fix.patch

 Folded into make-aout-executables-work-again.patch (will probably drop this
 now)

+sony-laptop-fix-uninitialised-variable.patch

 sony-laptop fix

+fix-modular-agpgart-ia64-allmodconfig.patch

 AGP fix

+arm-dma-mappingh.patch

 ARM fix

+avr32-dma-mappingh.patch

 avr32 fix

+gregkh-driver-sysfs-fix-build-errors-uevent-with-config_sysfs-n.patch

 driver tree update

+fix-saa7146_clipping_mem-size.patch
+pvrusb-warning-fix.patch

 DVB updates

+ds1374-check-for-workqueue-creation.patch

 i2c driver fix

+remove-stack-hard-limit-on-ia64.patch

 ia64 mystery fix

+setstream-param-for-psmouse-tweak.patch

 Improve setstream-param-for-psmouse.patch

+kbuild-override-build-timestamp.patch

 kbuild tweak

+sata_via-fix-resource-managed-iomap-conversion.patch

 sata fix

+git-ide.patch

 Temporary: this is the git tree Linus forgot to merge

+ide-alim15x3-fix-pio-mode-setup.patch
+ide-cmd64x-fix-pio-mode-setup-take3.patch
+ide-ide-fix-drive-side-80c-cable-check.patch
+ide-cmd64x-remove-broken-sw-mw-dma-support.patch
+ide-cmd64x-fix-recovery-time-calculation.patch
+ide-piix-slc90e66-more-tuneproc-fixing-take2.patch
+ide-ide-get-best-pio-mode-returns-incorrect-iordy-setting-take2.patch
+ide-sl82c105-rework-pio-support.patch
+ide-sl82c105-dma-support-code-cleanup.patch
+ide-ide-fix-dma-masks-v3.patch
+ide-ide-max-dma-mode-v2.patch
+ide-ide-tune-dma-helper.patch
+ide-ide-proc-fs.patch
+ide-ide-split-off-ioctls-from-settings-v2.patch
+ide-ide-move-settings-to-ide-proc.patch
+ide-ide-fix-cable-checks.patch
+ide-alim15x3-pio-fallback-fix.patch
+ide-alim15x3-use-ide-tune-dma.patch
+ide-pdc202xx_new-use-ide-tune-dma.patch
+ide-ide-remove-obsolete-params-v2.patch
+ide-ide-register-hw-initializing-arg.patch
+ide-ide-proc-register-port.patch
+ide-ide-legacy-params-v2.patch
+ide-ide-pci-pcibus-order.patch

 Restored IDE tree

+dmaengine-uninline-large-functions.patch

 Fix git-md-accel build

+onenand_base-warning-fix.patch
+sc520cdp-warning-fix.patch
+netsc520-warning-fix.patch
+ck804xrom-warning-fix.patch
+esb2rom-warning-fixes.patch
+amd76xrom-warning-fix.patch
+ichxrom-warning-fix.patch
+jffs2-warning-fixes.patch
+cafe-warning-fix.patch
+git-ubi.patch

 Fix dwmw2 scruffinesses

+r8169-rtnl-and-flush_scheduled_work-deadlock.patch
+sis190-rtnl-and-flush_scheduled_work-deadlock.patch
+8139too-rtnl-and-flush_scheduled_work-deadlock.patch
+s2io-rtnl-and-flush_scheduled_work-deadlock.patch
+s2io-add-pci-error-recovery-support.patch
+revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
+dmfe-trivial-spelling-fixes.patch
+dmfe-fix-two-bugs.patch
+dmfe-fix-link-detection.patch
+dmfe-add-support-for-suspend-resume.patch
+dmfe-add-support-for-suspend-resume-fix.patch
+dmfe-add-support-for-wake-on-lan.patch
+sis900-warning-fixes.patch

 netdev updates

+backlight-tree-versus-acpi-tree.patch

 Fix disagreement between git trees

+git-parisc-fixup.patch

 Fix rejects in git-parisc.patch

-drivers-scsi-aic7xxx-convert-to-generic-boolean-values.patch

 Dropped

+git-block-fixup.patch

 Fix rejects in git-block.patch

+gregkh-usb-usb-remove-airprime-device-from-optionc.patch
+gregkh-usb-usbnet-recognize-sitecom-cn-124.patch
+gregkh-usb-usbnet-init-fault-cleanup-whitespace-fixes.patch
+gregkh-usb-usbnet-add-missing-kconfig-for-kc2190-cables.patch
+gregkh-usb-usb-at91_udc-shrink-runtime-footprint.patch
+gregkh-usb-usb-ueagle-atmc-needs-schedh.patch
+gregkh-usb-usb-another-id-for-cp2101-driver.patch
+gregkh-usb-usb-stimulus.patch

 USB tree updates

+git-wireless-fixup.patch

 Fix rejects in git-wireless.patch

-before-x86_64-mm-mmconfig-share.patch

 Dropped

+x86_64-mm-revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
+x86_64-mm-revert-x86_64-mm-add-genapic_force.patch
+x86_64-mm-revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
+x86_64-mm-optimize-fix-apic-mode-setup.patch
+x86_64-mm-always-use-physical-delivery-mode-on-8-cpus.patch
+x86_64-mm-remove-clustered-apic-mode.patch
+x86_64-mm-default-to-physical-mode-on-hotplug-cpu-kernels.patch
+x86_64-mm-a-memcpy-that-tries-to-reduce-cache-pressure.patch
+x86_64-mm-fam10-l3cache.patch
+x86_64-mm-fix-i386-and-x86_64-fault-information-pollution.patch
+x86_64-mm-adjustments-to-page-table-dump-during-oops-v4.patch
+x86_64-mm-adjust-inclusion-of-asm-fixmap_h.patch
+x86_64-mm-adjust-inclusion-of-asm-vsyscall32_h.patch
+x86_64-mm-consolidate-smp_send_stop.patch
+x86_64-mm-no-need-to-use-traditional-for-processing-asm-in-i386-kernel.patch
+x86_64-mm-rwmsr-on-cpu.patch
+x86_64-mm-simplfy-__assign_irq_vector.patch
+x86_64-mm-handle-irqs-pending-in-irr-during-irq-migration.patch
+x86_64-mm-mtrr-range-check-correction.patch
+x86_64-mm-pit_latch_buggy-has-no-effect.patch
+x86_64-mm-add-an-option-for-the-via-c7-which-sets-appropriate-l1-cache.patch
+x86_64-mm-probe_roms-cleanup.patch

 x86 tree updates

+i386-irq-kill-irq-compression.patch
+x86-dont-probe-for-ddc-on-vbe12.patch

 x86 updates

+xen-paravirt-fix-typo-in-sync_constant_test_bits-name.patch
+xen-paravirt-ignore-vgacon-if-hardware-not-present.patch
+xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
+xen-paravirt-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
+xen-paravirt-paravirt_ops-allocate-a-fixmap-slot.patch
+xen-paravirt-remove-ctor-for-pgd-cache.patch
+xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
+xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment.patch
+xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction.patch
+xen-paravirt-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
+xen-paravirt-allocate-and-free-vmalloc-areas.patch
+xen-paravirt-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
+xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch
+xen-paravirt-add-xen-interface-header-files.patch
+xen-paravirt-core-xen-implementation.patch
+xen-paravirt-core-xen-implementation-fix.patch
+xen-paravirt-add-the-xen-virtual-console-driver.patch
+xen-paravirt-add-xen-grant-table-support.patch
+xen-paravirt-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
+xen-paravirt-add-xen-virtual-block-device-driver.patch
+xen-paravirt-add-the-xen-virtual-network-device-driver.patch

 Xen domU support

-touchkit-ps-2-touchscreen-driver.patch

 Dropped

+fix-mempolicys-check-on-a-system-with-memory-less-node.patch
+mincore-warning-fix.patch

 MM updates

+add-pagemlocked-page-state-bit-and-lru-infrastructure-fix.patch

 Fix add-pagemlocked-page-state-bit-and-lru-infrastructure.patch

+shm-make-sysv-ipc-shared-memory-use-stacked-files-real-fix.patch

 Fix shm-make-sysv-ipc-shared-memory-use-stacked-files.patch

-kconfig-fault_injection-can-be-selected-only-if-lockdep-is-enabled.patch
+fault-injection-split-up-stacktrace-filter-kconfig-option.patch

 Updated

+ipmi-add-pci-remove-handling.patch

 IMPI fix

+missing-__user-in-pointer-referenced-within-copy_from_user.patch
+update-doc-oops-tracingtxt-for-taint_user.patch
+update-doc-oops-tracingtxt-for-taint_user-fix.patch
+rtc-sa1100-rtc_wklarmenabled-bugfixes.patch
+at91_rtc-updates.patch
+gpio-api-pxa-wrapper-cleanup.patch
+remove-modpost-false-warnings-on-arm.patch
+drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module.patch
+lockdep-annotate-blkpg_del_partition.patch
+parport_pc-fix-parport_pc_probe_port-section-warning.patch
+freezer-task-exit_state-should-be-treated-as-bolean.patch
+softlockup-trivial-s-99-max_rt_prio.patch
+fix-constant-folding-and-poor-optimization-in-byte-swapping.patch

 Misc

+consolidate-generic_writepages-and-mpage_writepages.patch
+consolidate-generic_writepages-and-mpage_writepages-tidy.patch

 VFS code consolidation

+spi-controller-build-warning-fixes.patch
+spi_s3c2410_gpioc-spi-mode-2-and-3-support.patch

 SPI updates

+gpio-api-s3c2410-wrapper-cleanup-2.patch
+gpio-api-sa1100-wrapper-cleanup.patch

 GPIO updates

+unify-queue_delayed_work-and-queue_delayed_work_on-fix.patch

 Fix unify-queue_delayed_work-and-queue_delayed_work_on.patch

+workqueue-introduce-wq_per_cpu-helper.patch

 More in the workqueue work queue

-revert-x86_64-mm-putreg-check.patch

 Dropped

+atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix.patch
+atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix-2.patch
-atomich-add-atomic64_xchg-to-s390.patch
+local_t-mips-extension-fix.patch
+local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
+local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
-local_t-s390-cleanup.patch
+local_t-powerpc-extension-shrink-powerpc-localh.patch
+local_t-powerpc-extension-fix-build-fix.patch
+linux-kernel-markers-kconfig-menus-fix.patch
+linux-kernel-markers-kconfig-menus-fix-2.patch
+linux-kernel-markers-kconfig-menus-fix-3.patch
+linux-kernel-markers-kconfig-menus-fix-4.patch
+linux-kernel-markers-documentation.patch
+linux-kernel-markers-documentation-fix.patch
+linux-kernel-markers-documentation-update-adds-context.patch
+linux-kernel-markers-documentation-update-markerh.patch

 Keep trying to get Mathieu's stuff to compile :(

+ps3fb-thread-updates.patch
+ps3fb-thread-updates-update.patch
+ps3av-thread-updates.patch
+ps3fb-kill-superfluous-zero-initializations.patch
+ps3fb-atomic-fixes.patch
+ps3av-misc-updates.patch
+fb-sm501-framebuffer-driver-5.patch
+fb-sm501-framebuffer-driver-5-fix.patch
+i810fb-fix-i810_check_params-section-mismatch.patch
+aty128fb-fix-blanking.patch

 fbdev updates

-git-gccbug-fixup.patch

 Dropped.




All 829 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/patch-list

