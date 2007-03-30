Return-Path: <linux-kernel-owner+w=401wt.eu-S933409AbXC3IGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbXC3IGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 04:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933354AbXC3IGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 04:06:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55008 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933364AbXC3IGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 04:06:04 -0400
Date: Fri, 30 Mar 2007 01:05:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc5-mm3
Message-Id: <20070330010559.2a232d9a.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm3/

- git-cryptodev has things in it again

- Re-added git-e1000: a large amount of e1000 driver work

- git-net has a huge amount of material in it, but I dropped it because it
  went oops.

- git-block is back, minus the problematic unplugging rework.

- Lots of x86 updates.

- lguest is being redone and has been dropped

- The IDE development tree has been restored



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




Changes since 2.6.21-rc5-mm2:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-arm-master.patch
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
 git-e1000.patch
 git-ioat.patch
 git-ocfs2.patch
 git-parisc.patch
 git-r8169.patch
 git-selinux.patch
 git-pciseg.patch
 git-s390.patch
 git-scsi-misc.patch
 git-block.patch
 git-unionfs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-cryptodev.patch
 git-gccbug.patch

 git trees

-knfsd-allow-nfsd-readdir-to-return-64bit-cookies.patch
-knfsd-nfsd4-fix-inheritance-flags-on-v4-ace-derived-from-posix-default-ace.patch
-knfsd-nfsd4-demote-clientid-in-use-printk-to-a-dprintk.patch
-knfsd-nfsd4-remove-superfluous-cancel_delayed_work-call.patch
-md-allow-raid4-arrays-to-be-reshaped.patch
-md-clear-the-congested_fn-when-stopping-a-raid5.patch
-md-convert-compile-time-warnings-into-runtime-warnings.patch
-generic_serial-fix-decoding-of-baud-rate.patch
-correct-slow-acpi_pm-rating.patch
-isdn-fix-bchannel_bh-call-from-isar_bh.patch
-uml-fix-epoll.patch
-tty-minor-merge-correction.patch
-utsns-fix-config_uts_ns-behavior.patch
-drivers-spi-fix-section-mismatches.patch
-uml-fix-static-linking.patch
-uml-use-correct-register-file-size-everywhere.patch
-ntp-avoid-time_offset-overflows.patch
-ntp-avoid-time_offset-overflows-fix.patch
-drivers-eisa-pci_eisacpci_eisa_init-should-be-init.patch
-fix-struct-device-member-name-in-pcmcia-au1000_generic.patch
-block-io-errors-on-i2o-disk.patch
-ipcns-fix-config_ipc_ns-behavior.patch
-i2o-remove-markus-from-maintainers.patch
-fix-kernel-build-with-embedded-proc_fs-proc_sysctl.patch
-hrtimers-fix-reprogramming-smp-race.patch
-splice-dont-steal.patch
-splice-dont-readpage.patch
-cpuidle-fix-boot-hang.patch
-cpuidle-unsigned-bitfield.patch
-acpi-dock-use-null-for-pointer.patch
-sound-strlcpy-is-smart-enough.patch
-ehea-strlcpy-is-smart-enough.patch
-baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch
-remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
-tulip-fix-shutdown-dma-irq-race.patch
-sun3-3x-lance-trivial-fix-improved.patch
-forcedeth-fix-nic-poll.patch
-forcedeth-fix-tx-timeout.patch
-forcedeth-work-around-null-skb-dereference-crash-fix.patch
-drivers-net-vioc-possible-cleanups.patch
-bluetooth-hid-quirks-mightymouse-quirk.patch
-fix-gregkh-pci-pci-cleanup-the-includes-of-linux-pcih.patch
-msi-read-flush-msi-x-table.patch
-s390-kmalloc-kzalloc-casting-cleanups.patch
-block-blk_max_pfn-is-somtimes-wrong.patch
-make-elv_register-output-atomic.patch
-gregkh-usb-usb-usb_serial_driver-insufficient-for-clean-disconnect-handling.patch
-mm-set-hashdist_default-to-1-for-x86_64-numa.patch
-i386-modpost-apic-related-warning-fixes.patch
-arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
-arch-i386-kernel-alternativec-dont-include-bugsh.patch
-make-struct-vmi_ops-static.patch
-type-cast-clean-up-for-find_next_zero_bit.patch
-i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
-log-reason-why-tsc-was-marked-unstable.patch
-x86_64-shut-up-vm862.patch
-x86_64-fix-ia32_binfmtc-build-error.patch
-linux-sysdevh-needs-to-include-linux-moduleh.patch
-x86_64-irq-remove-extra-smp_processor_id-calling.patch
-i386-x86_64-early_printkc-make-simnow_init-static.patch
-make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
-i386-fix-gdts-number-of-quadwords-in.patch
-i386-fix-usage-of-mtune-when-x86_generic=y-or-config_mcore2=y.patch
-remove-constant_tsc-reporting-from-proc-cpuinfo-power.patch
-i386-vdso_prelink-warning-fix.patch
-cleanup-initialize-esp0-properly-all-the-time.patch
-lguest-preparation-export_symbol_gpl-5-functions.patch
-lguest-preparation-expose-futex-infrastructure.patch
-remove-hardcoding-of-hard_smp_processor_id-on-up.patch
-use-the-apic-to-determine-the-hardware-processor-id-i386.patch
-use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
-always-ask-the-hardware-to-obtain-hardware-processor.patch
-x86_64-remove-duplicated-code-for-reading-control-registers.patch
-introduce-load_tls-to-the-for-loop.patch
-remove-unused-set_seg_base.patch
-clarify-config_reorder-explanation.patch
-mm-inconsistent-use-of-node-ids.patch
-dma_ops-as-const.patch
-allow-i386-crash-kernels-to-handle-x86_64-dumps.patch
-allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
-prevent-acpi-quirk-warning-mass-spamming-in-logs.patch
-prevent-acpi-quirk-warning-mass-spamming-in-logs-tidy.patch
-x86_64-i386-add-command-line-length-to-boot-protocol.patch
-yet-another-function-to-load-cr3-register.patch
-i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
-i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda-fix.patch
-i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
-i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix.patch
-i386-gdt-cleanups-clean-up-cpu_init.patch
-i386-gdt-cleanups-cleanup-gdt-access.patch
-i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt.patch
-cleanup-rationalize-paravirt-wrappers.patch
-fix-x86_64-compilation-with-debug_sig-on.patch
-apmc-get-rid-of-unused-variables.patch
-apm-remove-the-apm_rtc_is_gmt-config-option.patch
-x86_64-use-lru-instead-of-page-index-and-page-private-for-pgd-lists-management.patch
-pci-set-pci=bfsort-for-poweredge-r900.patch
-fix-sudden-warps-in-mousedev.patch
-fix-sysfs-rom-file-creation-for-bios-rom-shadows.patch
-libata-identify-backwards-for-drive-side-cable-detection.patch
-update-__copy_to_user_inatomic.patch
-splice-partial-write-handling-fix.patch
-drivers-isdn-gigaset-mark-some-static-data-as-const-v2.patch

 Merged into mainline or a subsystem tree.

+proc-fix-linkage-with-config_sysctl=y-config_proc_sysctl=n.patch
+uml-fix-unreasonably-long-udelay.patch

 2.6.21 queue

-shmem-fix-bug-in-shmem_writepage.patch
-shmem-dont-release-lock-for-hole-punching.patch

 Dropped, updated, merged into mainline.

-make-aout-executables-work-again.patch
-make-aout-executables-work-again-fix.patch

 Unneeded

+fix-sysfs-rom-file-creation-for-bios-rom-shadows.patch
+driver-core-suppress-uevents-via-filter.patch
+driver-core-switch-firmware_class-to.patch
+s390-cio-delay-uevents-for-subchannels.patch

 Driver core stuff

+jdelvare-i2c-i2c-omap-adapter-numbering.patch

 I2C tree update

+jdelvare-hwmon-hwmon-ad7418-new-driver.patch

 hwmon tree update

-git-ieee1394-vs-gregkh-driver-driver-core-use-attribute-groups-in-struct-device_type.patch

 Merged, I think.

-pata_cs5535-re-remove-all-the-crap-and-switch-to-the-cable.patch
-pata_pdc202xx_old-lba48-bug.patch
-ata-ncq-is-broken-on-maxtor-6l250s0.patch

 These got broken by git-libata-all changes.

+libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch

 Fix libata-acpi-add-infrastructure-for-drivers-to-use.patch

+pata_acpi-restore-driver-fix.patch

 Fix pata_acpi-restore-driver.patch

+testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch

 pata experiment

+ide-cmd64x-remove-broken-sw-mw-dma-support.patch
+ide-sl82c105-rework-pio-support.patch
+ide-sl82c105-dma-support-code-cleanup-take3.patch
+ide-cmd64x-interrupt-status-fixes-resend.patch
+ide-cmd64x-add-fix-enablebits.patch
+ide-cmd64x-procfs-code-fixes-cleanups.patch
+ide-cmd64x-use-interrupt-status-from-mrdmode-register.patch
+ide-cmd64x-add-back-mwdma-support.patch
+ide-ide-fix-dma-masks-v3.patch
+ide-ide-max-dma-mode-v3.patch
+ide-ide-tune-dma-helper.patch
+ide-ide-proc-fs.patch
+ide-ide-split-off-ioctls-from-settings-v2.patch
+ide-ide-move-settings-to-ide-proc.patch
+ide-ide-fix-cable-checks-take2.patch
+ide-alim15x3-pio-fallback-fix.patch
+ide-alim15x3-use-ide-tune-dma.patch
+ide-pdc202xx_new-enable-dma-for-all-atapi-devices.patch
+ide-pdc202xx_new-use-ide-tune-dma.patch
+ide-ide-register-hw-initializing-arg.patch
+ide-ide-proc-register-port.patch
+ide-ide-pci-pcibus-order.patch
+ide-pdc202xx_old-rewrite-mode-programming-v2.patch
+ide-serverworks-pio-mode-setup-fixes.patch
+ide-sis5513-pio-mode-setup-fixes.patch
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

 IDE is back

-git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch

 Damaged by the uevent patch droppage, I think.

+vioc-warning-fix.patch
+vioc-cast-warning-fix.patch

 Fix things in git-netdev-all.

+git-e1000-fixup-2.patch

 Fix rejects in git-e1000.patch

-s2io-add-pci-error-recovery-support.patch

 Dropped

+add-napi-support-to-sb1250-macc-take-2.patch

 netdev feature work

+ppp_generic-fix-lockdep-warning.patch

 Fix ppp lockdep warnings

-bonding-replace-system-timer-with-work-queue.patch
-bonding-replace-system-timer-with-work-queue-tidy.patch
-drivers-net-bonding-bond_maincmake-3-functions-static.patch
-resend-iphase-64bit-cleanup.patch

 Dropped - these need work and I got bored of carrying them.

-8250-make-probing-for-txen-bug-a-config-option.patch

 Dropped - should be done as a boot option.

-rm9000-serial-driver-tidy.patch

 Folded into rm9000-serial-driver.patch

+gregkh-pci-pci-set-pci-bfsort-for-poweredge-r900.patch
+gregkh-pci-msi-simplify-bug-handling-in-pci_disable_msi.patch
+gregkh-pci-msi-simplify-bug-handling-in-pci_disable_msix.patch
+gregkh-pci-msi-simplify-bug-handling-in-msi_remove_pci_irq_vectors-part-1.patch
+gregkh-pci-msi-simplify-bug-handling-in-msi_remove_pci_irq_vectors-part-2.patch
+gregkh-pci-msi-consolidate-msi-x-irq-freeing-code.patch
+gregkh-pci-msi-consolidate-bug_ons.patch
+gregkh-pci-msi-move-export_symbols-near-their-definition.patch
+gregkh-pci-msi-remove-msi_cache.patch
+gregkh-pci-msi-expand-pci_msi_supported.patch
+gregkh-pci-msi-consolidate-precondition-checks.patch

 PCI tree updates

+remove-pci_dac_dma_-apis.patch

 Remove old APIs

-scsi-megaraid_sas-throttle-io-if-cmds-are-in-risk-of.patch

 Dropped

+scsi-megaraid_sas-intercepts-cmd-timeout-and-throttle-io.patch
+qla2xxx-remove-duplicate-pci_disable_device-call.patch

 SCSI updates

+gregkh-usb-usb-aircable-cleanup.patch
+gregkh-usb-usb-fix-race-in-visor_write.patch
+gregkh-usb-usb-fix-race-in-ftdio_write.patch
+gregkh-usb-usb-ftdi_sio-add-usb-id-of-adstech-usbx-707.patch
+gregkh-usb-usb-fix-ark3116-memory-leak.patch

 USB tree updates

+usb-elan-ftdi-check-for-driver-registration-status-v2.patch

 USB fixlets

+x86_64-mm-defconfig-update.patch
+x86_64-mm-i386-defconfig-update.patch
+x86_64-mm-unwinder.patch
+x86_64-mm-fam10-oprofile.patch
+x86_64-mm-__init-to-__cpuinit-fixes-in-mtrr-code.patch
+x86_64-mm-gcc3-options.patch
+x86_64-mm-update-__copy_to_user_inatomic.patch
+x86_64-mm-clean-up-mach_reboot_fixups.patch
+x86_64-mm-fix-usage-of-mtune-when-x86_generic=y-or-config_mcore2=y.patch
+x86_64-mm-remove-unused-set_seg_base.patch
+x86_64-mm-remove-duplicated-code-for-reading-control-registers.patch
+x86_64-mm-fix-cpu-mhz-reporting-on-constant_tsc-cpus.patch
+x86_64-mm-simplify-smp_call_function-by-using-common-implementation.patch
+x86_64-mm-dma_ops-as-const.patch
+x86_64-mm-assembly-safe-page_h-and-pgtable_h.patch
+x86_64-mm-kill-temp-boot-pmds.patch
+x86_64-mm-clean-up-the-early-boot-page-table.patch
+x86_64-mm-fix-early-printk-to-use-standard-isa-mapping.patch
+x86_64-mm-modify-copy_bootdata-to-use-virtual-addresses.patch
+x86_64-mm-cleanup-segments.patch
+x86_64-mm-add-efer-to-the-register-set-saved-by-save_processor_state.patch
+x86_64-mm-64bit-pic-smp-trampoline.patch
+x86_64-mm-get-rid-of-dead-code-in-suspend-resume.patch
+x86_64-mm-wakeup_s-rename-registers-to-reflect-right-names.patch
+x86_64-mm-wakeup_s-misc-cleanups.patch
+x86_64-mm-64bit-acpi-wakeup-trampoline.patch
+x86_64-mm-modify-discover_ebda-to-use-virtual-addresses.patch
+x86_64-mm-remove-the-identity-mapping-as-early-as-possible.patch
+x86_64-mm-move-swsusp-__pa-dependent-code-to-arch-portion.patch
+x86_64-mm-do-not-use-virt_to_page-on-kernel-data-address.patch
+x86_64-mm-__pa-and-__pa_symbol-address-space-separation.patch
+x86_64-mm-relocatable-kernel-support.patch
+x86_64-mm-extend-bzimage-protocol-for-relocatable-bzimage.patch
+x86_64-mm-move-cpu-verification-code-to-common-file.patch
+x86_64-mm-block-reordering.patch
+x86_64-mm-uselib-aout.patch
+x86_64-mm-traps-style.patch
+x86_64-mm-set-hashdist_default-to-1-for-x86_64-numa.patch
+x86_64-mm-modpost-apic-related-warning-fixes.patch
+x86_64-mm-make-struct-vmi_ops-static.patch
+x86_64-mm-type-cast-clean-up-for-find_next_zero_bit.patch
+x86_64-mm-workaround-for-a-wmissing-prototypes-warning.patch
+x86_64-mm-fix-ia32_binfmt_c-build-error.patch
+x86_64-mm-remove-extra-smp_processor_id-calling.patch
+x86_64-mm-make-simnow_init-static.patch
+x86_64-mm-vmi_pmd_clear-static.patch
+x86_64-mm-fix-gdts-number-of-quadwords-in-comment.patch
+x86_64-mm-configurable-fake-numa-node-sizes.patch
+x86_64-mm-split-remaining-fake-nodes-equally.patch
+x86_64-mm-fixed-size-remaining-fake-nodes.patch
+x86_64-mm-remove-constant_tsc-reporting-from-proc-cpuinfo-power-flags.patch
+x86_64-mm-fake-numa-for-cpusets-document.patch
+x86_64-mm-vdso_prelink-warning-fix.patch
+x86_64-mm-initialize-esp0-properly-all-the-time.patch
+x86_64-mm-export_symbol_gpl-5-functions.patch
+x86_64-mm-get_futex_key-get_key_refs-and-drop_key_refs.patch
+x86_64-mm-introduce-load_tls-to-the-for-loop_.patch
+x86_64-mm-clarify-config_reorder-explanation.patch
+x86_64-mm-allow-i386-crash-kernels-to-handle-x86_64-dumps.patch
+x86_64-mm-prevent-acpi-quirk-warning-mass-spamming-in-logs.patch
+x86_64-mm-add-command-line-length-to-boot-protocol.patch
+x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
+x86_64-mm-use-per-cpu-gdt-immediately-upon-boot.patch
+x86_64-mm-clean-up-cpu_init.patch
+x86_64-mm-rename-boot_gdt_table-to-boot_gdt.patch
+x86_64-mm-rationalize-paravirt-wrappers.patch
+x86_64-mm-tighten-kernel-image-page-access-rights.patch
+x86_64-mm-get-rid-of-unused-variables.patch
+x86_64-mm-i386-eflags-header.patch
+x86_64-mm-remove-stext.patch
+x86_64-mm-remove-the-apm_rtc_is_gmt-config-option_.patch
+x86_64-mm-use-lru-instead-of-page-index-and-page-private-for-pgd-lists-management_.patch
+x86_64-mm-sys_ioperm-prototype-cleanup.patch
+x86_64-mm-remove-unexpected_io_apic.patch
+x86_64-mm-fix-vtime-vsyscall.patch
+x86_64-mm-vsyscall_gtod_data-diet-and-vgettimeofday-fix.patch
+x86_64-mm-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation_.patch
+x86_64-mm-adjust-edid-retrieval.patch
+x86_64-mm-fix-section-mismatch-compile-warning.patch
+x86_64-mm-cleanup-gdt-access.patch
+x86_64-mm-add-smp_ops-interface.patch
+x86_64-mm-add-machine_ops-interface-to-abstract-halting-and-rebooting.patch
+x86_64-mm-remove-hardcoding-of-hard_smp_processor_id-on-up-systems.patch
+x86_64-mm-change-email-address.patch
+x86_64-mm-i386-nmi-extern.patch
+x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
+x86_64-mm-fix-amd64-agp-aperture-validation.patch
+x86_64-mm-ignore-vgacon-if-hardware-not-present.patch

 A few x86 updates

+#x86_64-mm-sched-clock-share.patch
+#x86_64-mm-sched-clock64.patch
+#x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch

 I dropped this part of the x86 tree due to mysterious crashes on the
 long-suffering Vaio.

+fix-x86_64-mm-sched-clock-share.patch

 Fix x86 tree

-x86_64-do-not-enable-the-nmi-watchdog-by-default.patch

 Dropped - was fixed by other means

+i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs.patch

 x86 updates

-x86_64-map-fake-nodes-to-real-nodes.patch
-x86_64-disable-alien-cache-for-fake-numa.patch
-x86_64-export-physnode-mapping-to-userspace.patch
-x86_64-fake-numa-for-cpusets-document.patch

 Dropped

-lguest-kconfig-and-headers.patch
-lguest-the-host-code-lgko.patch
-lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code.patch
-lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore.patch
-lguest-the-host-code-lgko-pin-stack-page-optimization.patch
-lguest-guest-code.patch
-lguest-clean-up-some-references-inittext-warnings.patch
-lguest-clean-up-some-references-inittext-warnings-2.patch
-lguest-makefile.patch
-lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
-lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
-lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages-tidy.patch
-lguest-compile-hypervisors-into-the-lg-module-directly.patch
-lguest-dont-crash-host-on-nmi.patch
-lguest-trivial-guest-network-driver.patch
-lguest-trivial-guest-console-driver.patch
-lguest-trivial-guest-block-driver.patch
-lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch
-lguest-documentatation-and-example-launcher.patch
-lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
-lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch

 Dropped

+x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
+x86_64-move-__vgetcpu_mode-__jiffies-to-the-vsyscall_2-zone.patch
+i386-machine_real_restart-replace-spin_lock_irqsave-with-spin_lock.patch

 x86 updates

-revert-ac97-fix-microphone-and-line_in-selection-logic.patch

 Unneeded

-free-swap-space-of-reactivated-pages.patch

 Dropped

+convert-hugetlbfs-to-use-vm_ops-fault.patch

 Fix mm-merge-nopfn-into-fault.patch

+blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch
+blackfin-arch-fix-bug-prevent-warning-in-case-bf531-is-target.patch
+blackfin-arch-fix-stamp537-isp1716-irq-setting-bug.patch

 blackfin updates

+uml-improve-checking-and-diagnostics-of-ethernet-macs.patch
+uml-eliminate-temporary-buffer-in-eth_configure.patch
+uml-replace-one-element-array-with-zero-element-array.patch

 UML updates

+add-file-position-info-to-proc.patch

 /proc feature work

-fix-bogus-softlockup-warning-with-sysrq-t.patch

 Dropped.

-fix-sysfs-reclaim-crash.patch

 Buggy, dropped.

+parport-dev-driver-model-support-powerpc-fix.patch

 Fix parport-dev-driver-model-support.patch

+cache-pipe-buf-page-address-for-non-highmem-arch.patch
+cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
+cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
+add-support-for-deferrable-timers-respun.patch
+add-support-for-deferrable-timers-respun-tidy.patch
+add-support-for-deferrable-timers-respun-fix.patch
+add-support-for-deferrable-timers-respun-fix-2.patch
+add-a-new-deferrable-delayed-work-init.patch
+linux-sysdevh-needs-to-include-linux-moduleh.patch
+remove-hardcoding-of-hard_smp_processor_id-on-up.patch
+irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
+time-smp-friendly-alignment-of-struct-clocksource.patch
+move-timekeeping-code-to-timekeepingc.patch
+move-timekeeping-code-to-timekeepingc-fix.patch
+ignore-stolen-time-in-the-softlockup-watchdog.patch
+add-touch_all_softlockup_watchdogs.patch
+header-cleaning-dont-include-smp_lockh-when-not-used.patch

 Misc

+dev-spidevbc-interface.patch

 SPI udpate

+sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch

 Update sched-implement-staircase-deadline-cpu-scheduler.patch

+utrace-x86_64-fix.patch

 Fix utrace build

+linux-kernel-markers-i386-optimization-fix.patch

 Fix linux-kernel-markers-i386-optimization.patch

+no-longer-include-asm-kdebugh.patch

 Cleanup

+revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode.patch
+revoke-core-code-break-cow-for-private-mappings.patch
+revoke-core-code-generic_file_revoke-stub-for-nommu.patch
+revoke-core-code-break-cow-fixes.patch

 Update revoke patches in -mm.

+add-irqf_irqpoll-flag-common-code.patch
+add-irqf_irqpoll-flag-on-x86_64.patch
+add-irqf_irqpoll-flag-on-i386.patch
+add-irqf_irqpoll-flag-on-ia64.patch
+add-irqf_irqpoll-flag-on-sh.patch
+add-irqf_irqpoll-flag-on-parisc.patch
+add-irqf_irqpoll-flag-on-arm.patch

 irqpoll fixes

+integrity-ima-integrity_measure-support-ima-exit.patch
+integrity-ima-identifiers.patch
+integrity-ima-cleanup.patch

 Update the integrity patches

-e1000_7033_dump_ring.patch
-e1000-printk-warning-fixes.patch

 Dropped due to clashes woith git-e1000.

-mm-only-free-swap-space-of-reactivated-pages-debug.patch

 Dropped.



All 1137 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm3/patch-list


