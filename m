Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbXJLEcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbXJLEcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 00:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbXJLEcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 00:32:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36251 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbXJLEcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 00:32:01 -0400
Date: Thu, 11 Oct 2007 21:31:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-mm1
Message-Id: <20071011213126.cf92efb7.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/

- I've been largely avoiding applying anything since rc8-mm2 in an attempt
  to stabilise things for the 2.6.23 merge.

  But that didn't stop all the subsystem maintainers from going nuts, with
  the usual accuracy.  We're up to a 37MB diff now, but it seems to be working
  a bit better.



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


Changes since 2.6.23-rc8-mm2:

 git-acpi.patch
 git-alsa.patch
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
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-jg-misc.patch
 git-kbuild.patch
 git-kvm.patch
 git-leds.patch
 git-libata-all.patch
 git-m32r.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-net.patch
 git-backlight.patch
 git-battery.patch
 git-nfs.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-r8169.patch
 git-selinux.patch
 git-s390.patch
 git-sched.patch
 git-sh.patch
 git-sh64.patch
 git-scsi-misc.patch
 git-block.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-xfs.patch
 git-kgdb.patch

 git trees

-x86_64-mm-vdso-text-offset.patch
-fix-proc-acpi-alarm-to-work-with-bcd-alarm-encodings-award.patch
-input-xpad-fix-dependancy-on-leds-class.patch
-powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
-exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
-hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.patch
-acpi-clean-up-acpi_enter_sleep_state_prep.patch
-acpi-sbs-fix-sbs-add-alarm-patch.patch
-acpi-suppress-uninitialized-var-warning.patch
-generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
-documentation-arm-00-index-add-missing-entries.patch
-fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
-cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
-cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
-cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
-cpufreq-implement-config_cpu_freq-stub-for.patch
-cpufreq_stats-misc-cpuinit-section-annotations.patch
-powerpc-vdso-install-unstripped-copies-on-disk.patch
-powerpc-vdso-install-unstripped-copies-on-disk-update.patch
-sky-cpu-and-nexus-code-style-improvement.patch
-sky-cpu-and-nexus-include-ioh.patch
-sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
-sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
-sky-cpu-use-c99-style-for-struct-init.patch
-sky-cpu-and-nexus-get-rid-of-useless-null-init.patch
-sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface.patch
-powerpc-proper-defconfig-for-crosscompiles.patch
-powerpc-proper-defconfig-for-crosscompiles-fix.patch
-powerpc-ptrace-check_full_regs.patch
-gregkh-driver-sysfs-kill-sysfs_flag_removed.patch
-revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
-fix-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
-fix-3-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
-fix-2--gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
-fix-gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
-make-kobject-dynamic-allocation-check-use-kallsyms_lookup.patch
-kobject-temporarily-save-k_name-on-cleanup-for-debug-message.patch
-git-dvb-build-fix.patch
-dvb_en_50221-convert-to-kthread-api.patch
-fix-mux-setup-for-composite-sound-on-avertv-307.patch
-oops-in-pwc-v4l-driver.patch
-dvb-fix-kconfig-help-text.patch
-bfin_twi-remove-useless-twi_lock-mutex.patch
-drivers-hid-hid-debugc-add-kern_debug-prefix-fix-typo-constify-fix.patch
-git-jg-misc-fix.patch
-mkmakefile-include-arch-on-o=-builds.patch
-include-linux-kbuild-remove-duplicate-entries.patch
-tristate-choices-with-mixed-tristate-and-boolean.patch
-menuconfig-distinguish-between-selected-by-another-options-and-comments.patch
-git-kvm-warning-fix.patch
-pata_acpi-restore-driver.patch
-pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
-pata_acpi-use-ata_sff_port_start.patch
-libata-correct-handling-of-srst-reset-sequences.patch
-libata-add-a-drivers-ide-style-dma-disable.patch
-ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
-drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
-libata-add-human-readable-error-value-decoding-v3.patch
-libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch
-ahci-add-mcp79-support-to-ahci-driver.patch
-ahci-add-mcp79-support-to-ahci-driver-update.patch
-pata_pdc202xx_old-fix-timings.patch
-pata_ns87415-initial-cut-at-87415-87560-ide-support.patch
-pata_ns87415-initial-cut-at-87415-87560-ide-support-fix.patch
-fix-hpa-handling-regression.patch
-libata_scsi-fix-transfer-lengths.patch
-pata_atiixp-audit-notes-on-locking.patch
-pata_hpt3x2n-clean-up-dpll-stuff.patch
-libata-fix-hopefully-all-the-remaining-problems-with.patch
-fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
-fix-ide-ide-remove-ide-dma-check.patch
-mips-add-gpio-support-to-the-bcm947xx-platform.patch
-mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch
-git-net-fix-wireless-kconfig.patch
-git-net-fix-spidernet-build.patch
-git-net-sctp-build-fix.patch
-iseries_veth-kill-unused-variable.patch
-spider_net_ethtool-keep-up-with-recent-netdev-stats-changes.patch
-pasemi_mac-build-fix-after-recent-netdev-stats.patch
-net-atm-lecc-printk-warning-fix.patch
-document-the-fact-that-smsc-ircc2-will-not-use-pnp-by-default.patch
-dgrs-remove-from-build-config-and-maintainer-list.patch
-git-net-sctp-hack.patch
-phy-fixed-driver-rework-release-path-and-update.patch
-pci-x-pci-express-read-control-interfaces-e1000.patch
-drivers-net-cxgb3-xgmacc-remove-dead-code.patch
-e1000-if-0-two-functions.patch
-eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch
-avoid-possible-null-pointer-deref-in-3c359-driver.patch
-export-reciprocal_value-for-modules.patch
-sky2-avoid-divide-in-receive-path.patch
-skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
-fix-a-potential-null-pointer-dereference-in-uli526x_interrupt.patch
-phylib-spinlock-fixes-for-softirqs.patch
-forcedeth-no-link-is-informational.patch
-phylib-irq-event-workqueue-handling-fixes.patch
-phylib-fix-an-interrupt-loop-potential-when-halting.patch
-clean-up-redundant-phy-write-line-for-uli526x-ethernet.patch
-git-backlight-dependency-fix.patch
-clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
-revert-gregkh-pci-pci_bridge-device.patch
-pci-remove-irritating-try-pci=assign-busses-warning.patch
-fix-ide-legacy-mode-resources.patch
-fix-ide-legacy-mode-resources-fix.patch
-rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time.patch
-sched-use-show_regs-to-improve-__schedule_bug-output.patch
-some-proc-entries-are-missed-in-sched_domain-sys_ctl-debug.patch
-sh-cleanup-struct-irqaction-initializers.patch
-sh64-cleanup-struct-irqaction-initializers.patch
-git-scsi-misc-arcmsr-build-fix.patch
-drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
-remove-dead-references-to-module_parm-macro.patch
-fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch
-fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
-add-includes-to-scsi_transport_iscsih.patch
-fix-section-mismatch-in-the-adaptec-dpt-scsi-raid-driver.patch
-advansys-printk-fix.patch
-drivers-scsi-immc-fix-check-after-use.patch
-mpt-fusion-shut-up-uninitialized-variable.patch
-git-unionfs-fix-2.patch
-fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
-usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race.patch
-drivers-usb-misc-sisusbvga-sisusbc-kill-two-unused-variables.patch
-net-add-ath5k-wireless-driver-fix.patch
-fix-x86_64-mm-unwinder.patch
-kgdb-fix-help-text.patch
-kgdb-fix-docbook-and-kernel-doc-typos.patch
-seqfile-merge-duplite-code-to-seq_open_private.patch

 Merged into mainline or a subsystem tree

-fix-oops-in-platform-uevent.patch

 Unneeded

-slow-down-printk-during-boot-fix-2.patch
-slow-down-printk-during-boot-fix-3.patch
-slow-down-printk-during-boot-fix-4.patch

 Folded into slow-down-printk-during-boot.patch

+clockevents-fix-bogus-next_event-reset-for-oneshot-broadcast-devices.patch

 clockevents fix

+acpi-fix-bdc-handling-in-drivers-acpi-sleep-procc.patch

 ACPI fix

+generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch

 ALSA fix

+cifs-build-fix.patch
+cifs-warning-fixes.patch

 Fix git-cifs

-agk-dm-dm-ioctl-fix-compat-bounds-test.patch
+agk-dm-dm-mpath-rdac-fix-init-race.patch
+agk-dm-dm-ioctl-use-constant-struct-size.patch
+agk-dm-dm-fix-thaw_bdev.patch
+agk-dm-dm-bio_list-macro-renaming.patch
+agk-dm-dm-crypt-tidy-pending.patch
+agk-dm-dm-crypt-tidy-whitespace.patch
+agk-dm-dm-crypt-tidy-labels.patch
+agk-dm-dm-mpath-add-retry-pg-init.patch
+agk-dm-dm-mpath-add-hp-handler.patch
+agk-dm-dm-mpath-hp-retry-if-not-ready.patch
+agk-dm-dm-log-split-suspend.patch
+agk-dm-dm-raid1-add-mirror_set-to-struct-mirror.patch
+agk-dm-dm-raid1-handle-recovery-write-failures.patch

 device-mapper tree updates

-git-powerpc-galak.patch

 Dropped due to merge problems

+gregkh-driver-howto-update-ja_jp-howto-with-latest-changes.patch
+gregkh-driver-driver-core-clean-up-removed-functions-from-the-documentation.patch
+gregkh-driver-sysfs-fix-comments-of-sysfs_add-remove_one.patch
+gregkh-driver-sysfs-fix-sysfs_chmod_file-such-that-it-updates-sd-s_mode-too.patch
+gregkh-driver-sysfs-clean-up-header-files.patch
+gregkh-driver-sysfs-kill-sysfs_update_file.patch
+gregkh-driver-sysfs-reposition-sysfs_dirent-s_mode.patch
+gregkh-driver-sysfs-kill-unnecessary-sysfs_get-in-open-paths.patch
+gregkh-driver-sysfs-kill-unnecessary-null-pointer-check-in-sysfs_release.patch
+gregkh-driver-sysfs-make-bin-attr-open-get-active-reference-of-parent-too.patch
+gregkh-driver-sysfs-make-s_elem-an-anonymous-union.patch
+gregkh-driver-sysfs-open-code-sysfs_attach_dentry.patch
+gregkh-driver-sysfs-make-sysfs_root-a-regular-directory-dirent.patch
+gregkh-driver-sysfs-move-sysfs_dirent-s_children-into-sysfs_dirent-s_dir.patch
+gregkh-driver-sysfs-implement-sysfs_open_dirent.patch
+gregkh-driver-sysfs-move-sysfs-file-poll-implementation-to-sysfs_open_dirent.patch
+gregkh-driver-driver-core-remove-subsystem_init.patch
+gregkh-driver-kset-add-some-kerneldoc-to-help-describe-what-these-strange-things-are.patch
+gregkh-driver-kobject-update-the-copyrights.patch

 driver tree updates

-git-dvb-fixup-2.patch

 Unneeded

+git-dvb-fixup.patch
+git-dvb-rename-videobuf_qtype_opscopy_to_user.patch
+git-dvb-vs-i2c-tree.patch

 fix git-dvb

+jdelvare-i2c-i2c-bfin_twi-remove-useless-mutex.patch
+jdelvare-i2c-i2c-stub-add-multiple-chip-support.patch
+jdelvare-i2c-i2c-dev-rejects-i2c_m_recv_len.patch
+jdelvare-i2c-i2c-remove-nop-algo_control-methods.patch
+jdelvare-i2c-i2c-remove-algo_control.patch
+jdelvare-i2c-i2c-dev-move-interfaces-to-i2c-dev-h.patch
+jdelvare-i2c-i2c-at91-mark-as-broken.patch
+jdelvare-i2c-i2c-rename-pec-func-bit.patch
+jdelvare-i2c-i2c-au1550-fix-misused-register.patch
+jdelvare-i2c-i2c-nforce2-timeout-cleanup.patch
+jdelvare-i2c-i2c-nforce2-implement-abort.patch
+jdelvare-i2c-i2c-nforce2-declare-pec-functionality.patch

 I2C tree updates

+applesmc-for-mac-pro-2-x-quad-core-fix.patch

 Fix applesmc-for-mac-pro-2-x-quad-core.patch

-ia64-tree-wide-misc-__cpuinitdata-init-exit-fix.patch

 Folded into ia64-tree-wide-misc-__cpuinitdata-init-exit.patch

-infiniband-work-around-gcc-slub-problem.patch

 Unneeded

-console-keyboard-events-and-accessibility-fix.patch
-console-keyboard-events-and-accessibility-fix-2.patch

 Folded into console-keyboard-events-and-accessibility.patch

-first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
-first-stab-at-elantech-touchpad-driver-for-26226-testers-fix.patch

 I forget what happened to this

+git-jg-misc-powernow-fix.patch

 Fix git-jg-misc

-git-kbuild-fixup.patch

 Unneeded

+drivers-ata-libata-ehc-fix-printk-warning.patch

 git-libata-all fix

+ide-atiixp-sb700-2-ide-channels.patch
+ide-hpt366-mwdma-filter-for-sata-cards-take-2.patch
+ide-ide-make-jmicron-match-vendor-and-device-class.patch
+ide-ide_platform-set-hwif-chipset.patch
+ide-ide-fix-ide-register-hw-to-check-hwif-io_ports.patch
+ide-icside-use-ec-dma-directly.patch
+ide-ide-remove-write-only-hwif-hw.patch
+ide-au1xxx-ide-set-autotune-and-no-io-32bit-also-for-the-slave-device.patch
+ide-dtc2278-set-pio-mask-also-for-the-second-port.patch
+ide-via82cxxx-keep-local-ide-pci-device-t-copy.patch
+ide-ide-replace-ide-pci-device-by-struct-ide-port-info.patch
+ide-ide-constify-struct-ide-port-info.patch
+ide-ali14xx-fix-deadlock-on-error-handling.patch
+ide-dtc2278-fix-deadlock-on-error-handling.patch
+ide-qd65xx-fix-deadlock-on-error-handling.patch
+ide-opti621-fix-deadlock-on-error-handling.patch
+ide-slc90e66-fix-deadlock-on-error-handling.patch
+ide-cmd640-fix-deadlock-on-error-handling.patch
+ide-ht6560b-fix-deadlock-on-error-handling.patch
+ide-ide-take-ide-lock-for-prefetch-disable-enable-in-do-special.patch
+ide-cs5530-remove-needless-ide-lock-taking.patch
+ide-ide-enhance-ide-setup-pci-noise.patch
+ide-ide-use-__ide_end_request-in-ide_end_dequeued_request.patch
+ide-ide-remove-dead-code-from-ide-driveid-update.patch
+ide-ide-remove-stale-comments-from-ide-taskfile-c.patch
+ide-fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
+ide-fix-ide-ide-remove-ide-dma-check.patch
+ide-ide-unexport-noautodma.patch
+ide-ide-pci-bmdma-initialization-fixes-take-2.patch
+ide-qd65xx-remove-pointless-qd-read-write-reg-take-2.patch

 IDE tree updates (breaks m68k)

+git-mtd-fixup.patch
+git-mtd-borkage.patch
+mtd-alaudac-warning-fix.patch

 Fix git-mtd.patch

+ircomm-discovery-indication-simplification.patch
+git-net-fix-qeth_main.patch

 Fix git-net.patch

+git-nfsd-fixup.patch

 Fix rejects in git-nfsd.patch

-git-r8169-fixup.patch

 Unneeded

+gregkh-pci-msi-use-correct-data-offset-for-32-bit-msi-in-read_msi_msg.patch
+gregkh-pci-pci-fix-ide-legacy-mode-resources.patch
+gregkh-pci-pci-implement-pci-noaer.patch
+gregkh-pci-pci-use-size-stored-in-proc_dir_entry-for-proc-bus-files.patch
+gregkh-pci-pci-write-file-size-to-inode-on-proc-bus-file-write.patch
+gregkh-pci-pci-remove-transparent-bridge-sizing.patch
+gregkh-pci-pci-skip-isa-ioresource-alignment-on-some-systems.patch
+gregkh-pci-pci-avoid-p2p-prefetch-window-for-expansion-roms.patch
+gregkh-pci-pci-use-_crs-for-pci-resource-allocation.patch

 PCI tree updates

+git-jg-misc-vs-gregkh-pci-pci-skip-isa-ioresource-alignment-on-some-systems.patch

 greg-vs-jeff cagematch

+qla2xxx-printk-fixes.patch

 Fix git-scsi-misc

+initio-fix-conflict-when-loading-driver.patch

 scsi fix

+git-block-fixup-1.patch
+git-block-fixup-fix.patch
+git-block-borkages.patch
+git-block-s390-fix.patch

 Fix git-block.patch some more

+gregkh-usb-usb-r8a66597-hcd-fix-class-or-vendor-request.patch
+gregkh-usb-usb-r8a66597-hcd-fix-endian-problem.patch
+gregkh-usb-usb-r8a66597-hcd-fix-driver-removing.patch
+gregkh-usb-usb-fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
+gregkh-usb-usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race.patch
+gregkh-usb-usb-drivers-usb-misc-sisusbvga-sisusbc-kill-two-unused-variables.patch
+gregkh-usb-usb-serial-gadget-disable-endpoints-on-unload.patch
+gregkh-usb-usb-export-urb-statistics-for-powertop.patch
+gregkh-usb-usb-move-linux-usb_gadgeth-to-linux-usb-gadgeth.patch
+gregkh-usb-usb-re-remove-linux-usb_sl811h.patch
+gregkh-usb-usb-unusual_devs-entry-for-nikon-dsc-d2xs.patch
+gregkh-usb-usb-visor-termios-bits.patch
+gregkh-usb-usb-funsoft-fix-termios.patch

 USB tree updates

+git-wireless-ath5k-broke.patch

 ath5k broke somehow, probably a marge glitch

+x86_64-mm-prefetch-builtin.patch
+x86_64-mm-remove-serialize-cpu.patch
-x86_64-mm-unwinder.patch
-x86_64-mm-unwinder-default.patch
-x86_64-mm-fix-arch-i386-kernel-nmi_c-unknown_nmi_panic_callback-declared-static-but-never-defined-warning.patch
-x86_64-mm-less-stack-alignment.patch
+x86_64-mm-remove-unordered-io.patch
+x86_64-mm-make-atomic64_t-work-like-atomic_t.patch
+x86_64-mm-remove-strrchr.patch
-x86_64-mm-optionally-show-last-exception-from-to-register-contents-v2.patch
+x86_64-mm-optionally-show-last-exception-from-to-register-contents.patch
-x86_64-mm-remove-fpu-port.patch
+x86_64-mm-fix-watchdog.patch
+x86_64-mm-mark-read_crx-asm-code-as-volatile.patch
+x86_64-mm-call-free_init_pages-with-irqs-enabled-in-alternative_instructions.patch
+x86_64-mm-ptrace-compat-tls.patch

 x86 tree changes

+fix-x86_64-mm-sched-clock-share.patch

 x86 stuff

-x86-use-num_online_nodes-to-get-physical-cpus-numbers-for.patch
-voyager-include-asm-smph-to-fix-compile-error.patch
-hpet-force-enable-on-ich34.patch

 Dropped, I think

-x86_64-cleanup-apic-c-fix.patch

 Folded into x86_64-cleanup-apic-c.patch

-ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch

 Folded into ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch

-ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch

 Folded into ich-force-hpet-ich5-quirk-to-force-detect-enable.patch

-optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-fix.patch

 Fix optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch

-x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch

 Folded into x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch

-x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-fix.patch

 Folded into x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is.patch

+pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2.patch

 PCI fix

+git-kgdb-be-modern.patch
+disable-kgdb-on-ppc.patch

 kgdb fixes

+mm-use-pagevec-to-rotate-reclaimable-page-fix-bug-at-include-linux-mmh220.patch
+mm-use-pagevec-to-rotate-reclaimable-page-kill-redundancy-in-rotate_reclaimable_page.patch
+mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drain.patch

 Fix mm-use-pagevec-to-rotate-reclaimable-page.patch a lot more

-have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
-only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
-slub-exploit-page-mobility-to-increase-allocation-order.patch
-slub-reduce-antifrag-max-order.patch

 Dropped

+memory-unplug-v7-memory-hotplug-cleanup-fix.patch

 Fix memory-unplug-v7-memory-hotplug-cleanup.patch

+hugetlb-move-update_and_free_page.patch
+hugetlb-try-to-grow-hugetlb-pool-for-map_private-mappings.patch
+hugetlb-try-to-grow-hugetlb-pool-for-map_shared-mappings.patch
+hugetlb-add-hugetlb_dynamic_pool-sysctl.patch
+hugetlbfs-read-support-fix-2-fix.patch
+hugetlb-fix-pool-resizing-corner-case-v2.patch

 Various hugetlb things

-mm-expose-bdi-statistics-in-sysfs.patch
-debug-sysfs-files-for-the-current-ratio-size-total.patch

 Dropped

+mm-document-tree_lock-zonelock-lockorder.patch
+writeback-dont-propagate-aop_writepage_activate.patch

 MM things

+pm-qos-infrastructure-and-interface.patch
+pm-qos-infrastructure-and-interface-fix.patch
+pm-qos-infrastructure-and-interface-vs-git-acpi.patch
+pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
+latencyc-use-qos-infrastructure.patch

 PM QoS interface

+uml-correctly-handle-skb-allocation-failures.patch
+uml-correctly-handle-skb-allocation-failures-fix.patch
+uml-fix-stub-address-calculations.patch
+uml-fix-stub-address-calculations-checkpatch-fixes.patch
+uml-arch-um-drivers-formatting.patch
+uml-arch-um-drivers-formatting-checkpatch-fixes.patch
+uml-definitively-kill-subprocesses-on-panic.patch

 UML updates

-clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch

 Dropped

-cache-pipe-buf-page-address-for-non-highmem-arch.patch

 Dropped

+add-kernel-notifierc-fix-2-fix-3.patch

 Fix add-kernel-notifierc.patch some more

-x86_64-efi-boot-support-efi-frame-buffer-driver.patch
-x86_64-efi-boot-support-efi-boot-document.patch

 Dropped

-i386-and-x86_64-randomize-brk.patch
-i386-and-x86_64-randomize-brk-fix.patch

 Dropped

-track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
-track-accurate-idle-time-with-tick_schedidle_sleeptime-fix.patch

 I forget
-jbd-slab-cleanups.patch
-jbd-slab-cleanups-2.patch
-jbd-slab-cleanups-3.patch
-move-kasprintfo-to-obj-y.patch
-anon_inodesc-fix-error-check-in-anon_inode_getfd.patch
-jbd2-ext4-cleanups-convert-to-kzalloc.patch
-jbd2-fix-commit-code-to-properly-abort-journal.patch
-remove-broken-netfilter-binary-sysctls-from-bridging-code.patch
-fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
-i386-cpuid-misc-cpuinit-annotations.patch
-cleanup-macros-for-distinguishing-mandatory-locks.patch
-gfs2-cleanup-explicit-check-for-mandatory-locks.patch
-9pfs-cleanup-explicit-check-for-mandatory-locks.patch
-afs-cleanup-explicit-check-for-mandatory-locks.patch
-nfs-cleanup-explicit-check-for-mandatory-locks.patch
-rework-proc-locks-via-seq_files-and-seq_list-helpers.patch
-rework-proc-locks-via-seq_files-and-seq_list-helpers-fix.patch
-rework-proc-locks-via-seq_files-and-seq_list-helpers-fix-2.patch
-funsoft-fix-termios.patch
-visor-termios-bits.patch

-futex_compat-simplify-pointer-magic.patch
-futex_compat-update-to-match-native-version.patch

 Dropped, I think

+stop-using-dma_xxbit_mask.patch
+stop-using-dma_xxbit_mask-fix.patch

 Cleanups

+increase-at_vector_size-to-terminate-saved_auxv-properly-updates.patch

 Fix increase-at_vector_size-to-terminate-saved_auxv-properly.patch

+anon-inodes-use-open-coded-atomic_inc-for-the-shared-inode.patch
+ncr53c8xx-remove-deprecated-irq-flags-sa_.patch
+completely-remove-deprecated-irq-flags-sa_.patch
+compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
+fs-correct-sus-compliance-for-open-of-large-file-without.patch
+ext3-remove-ifdef-config_ext3_index.patch
+rename-signalfd_siginfo-fields.patch
+break-elf_platform-and-stack-pointer-randomization-dependency.patch
+spin_lock_unlocked-cleanups.patch
+task_struct-move-fpu_counter-and-oomkilladj.patch
+f_dupfd_cloexec-implementation.patch
+f_dupfd_cloexec-implementation-fix-2.patch
+module-return-error-when-mod_sysfs_init-failed.patch
+ext3-lighten-up-resize-transaction-requirements.patch
+ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes.patch
+printk-add-kern_cont-annotation.patch
+lp_console-cleanups.patch
+reiserfs-do-not-repair-wrong-journal-params.patch
+dontdiff-update-based-on-gitignore-updates.patch

 Misc

+writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
+writeback-fix-ntfs-with-sb_has_dirty_inodes.patch
+writeback-remove-pages_skipped-accounting-in-__block_write_full_page.patch
+writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch
+writeback-introduce-writeback_controlmore_io-to-indicate-more-io.patch
+writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch

 More VFS writeback fixes

+spi_mpc83xx-handles-other-processors-with.patch
+documentation-spi-spidev_testc-constify-some-variables.patch

 SPI updates

+lockdep-annotate-kprobes-irq-fiddling.patch
+lockdep-annotate-kprobes-irq-fiddling-fix.patch

 lockdep+kprobes fixes

+ecryptfs-fix-error-handling.patch

 ecryptfs update

+rtc-rtc-class-driver-for-the-ds1374.patch
+rtc-fix-readback-from-sys-class-rtc-rtc-wakealarm.patch
+rtc-cmos-probe-cleanup.patch
+rtc-cmos-probe-cleanup-checkpatch-fixes.patch

 RTC updates

+vt-vgacon-check-if-screen-resize-request-comes-from-userspace.patch
+nvidiafb-correctly-assign-the-i2c-class-with-the-port-reversal.patch
+pmagb-b-fb-improve-diagnostics.patch
+fbcon-logo-disable-logo-at-boot.patch
+fbcon-logo-disable-logo-at-boot-fix.patch
+bf54x-lq043fb-framebuffer-driver-for-blackfin-bf54x-framebuffer-device-driver.patch
+video-gfx-merge-kconfig-menus.patch
+ps3av-eliminate-unneeded-temporary-variables.patch
+ps3av-eliminate-ps3av_debug.patch
+ps3av-use-ps3-video-mode-ids-in-autodetect-code.patch
+ps3av-treat-dvi-d-like-hdmi-in-autodetect.patch
+ps3av-add-autodetection-for-vesa-modes.patch
+ps3av-add-quirk-database-for-broken-monitors.patch
+ps3av-remove-unused-ps3av_set_mode.patch
+ps3av-dont-distinguish-between-boot-and-non-boot-autodetection.patch
+imxfb-fast-read-flag-and-nonstandard-field-configurable.patch

 More fbdev updates

-md-software-raid-autodetect-dev-list-not-array-fix.patch

 Folded into md-software-raid-autodetect-dev-list-not-array.patch

+do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist-fix.patch

 Fix  do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch

+intel-iommu-fix-for-iommu-early-crash-2.patch
+git-block-intel-iommu-sg-chaining-support.patch

 intl-iommu fixes

+ext4-jbd_slab_cleanup.patch
+ext4-jbd2_slab_cleanup.patch
+ext4-jbd_jbd_kmalloc_cleanup.patch
+ext4-jbd2_jbd_kmalloc_cleanup.patch
+ext4-jbd2-ext4-cleanups-convert-to-kzalloc.patch
+ext4-jbd2-fix-commit-code-to-properly-abort-journal.patch
+ext4-jbd2-debug-code-cleanup.patch
+ext4-remove-ifdef-config_ext4_index.patch
+ext4-ext4-convert_bg_block_bitmap_to_bg_block_bitmap_lo.patch
+ext4-ext4-convert_bg_inode_bitmap_and_bg_inode_table.patch
+ext4-ext4-convert_s_blocks_count_to_s_blocks_count_lo.patch
+ext4-ext4-convert_s_r_blocks_count_and_s_free_blocks_count.patch
+ext4-ext4-convert_ext4_extentee_start_to_ext4_extentee_start_lo.patch
+ext4-ext4-convert_ext4_extent_idxei_leaf_to_ext4_extent_idxei_leaf_lo.patch
+ext4-ext4-sparse-fix.patch
+ext4-ext4_fix_setup_new_group_blocks_locking.patch
+ext4-ext4_lighten_up_resize_transaction_requirements.patch
+ext4-jbd-stats-through-procfs.patch
-ext4-jbd-stats-through-procfs.patch
-ext4-jbd-stats-through-procfs_fix.patch
-ext4-fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
-ext4-new-extent-function.patch
+ext4-new-extent-function.patch
+ext4-mballoc-bug-workaround.patch
+ext4-jbd-blocks-reservation-fix-for-large-blk.patch
+ext4-jbd2-blocks-reservation-fix-for-large-blk.patch

 ext4 devel tree updates

+jbd-ext3-cleanups-convert-to-kzalloc.patch
+jbd-config_jbd_debug-cannot-create-proc-entry.patch
+jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
+jbd-fix-commit-code-to-properly-abort-journal.patch
+jbd-fix-jbd-warnings-when-compiling-with-config_jbd_debug.patch

 ext3/4 things

+pnp-remove-null-pointer-checks.patch
+pnp-simplify-pnp-card-error-handling.patch
+pnp-use-dev_info-dev_err-etc-in-core.patch
+pnp-use-dev_info-dev_err-etc-in-core-fix.patch
+pnp-use-dev_info-dev_err-etc-in-core-fix-fix.patch
+pnp-use-dev_info-in-system-driver.patch
+pnp-simplify-pnpbios-insert_device.patch
+pnp-add-debug-message-for-adding-new-device.patch
+pnp-add-debug-message-for-adding-new-device-fix.patch
+pnp-add-debug-message-for-adding-new-device-fix-fix.patch

 pnp updates

+make-reiserfs-stop-using-struct-file-for-internal.patch

 reiserfs cleanup

+tweak-documentation-sm501txt.patch
+add-missing-entries-to-top-level-documentation-00-index.patch
+add-documentation-w1w1-masters-00-index.patch
+add-entries-to-documentation-powerpc.patch
+add-documentation-power-00-index.patch
+update-dma-mapping-documentation.patch
+kdump-documentation-cleanups.patch
+vmtxt-document-min_free_pages-as-critical-for-correctness.patch
+documentation-vm-slabinfoc-clean-up-this-code.patch

 Documentation updates

+make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch

 Fix make-access-to-tasks-nsproxy-lighter.patch some more

+lockdep-fix-mismatched-lockdep_depth-curr_chain_hash.patch
+lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch

 lockdep fixes

+cpuset-sched_load_balance-flag.patch
+cpuset-sched_load_balance-flag-fix.patch
+cpusets-decrustify-cpuset-mask-update-code.patch
+cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch

 cpuset updates

+memcontrol-move-oom-task-exclusion-to-tasklist.patch
+memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
+oom-add-sysctl-to-enable-task-memory-dump.patch
+kswapd-should-only-wait-on-io-if-there-is-io.patch

 memory controller and other MM updates

+powerpc-add-scaled-time-accounting-speedup.patch

 Improve powerpc-add-scaled-time-accounting.patch

+use-task_pid_nr-instead-of-pid_nrtask_pid.patch

 pid namespaces updates

+cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
+cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch

 CPU hotplug updates

+fix-idr_find-locking.patch
+ipc-remove-unneeded-parameters.patch

 IDR/IPC updates

+ext3-support-large-blocksize-up-to-pagesize.patch

 ext3 feature/fix

+hook-up-group-scheduler-with-control-groups.patch
+hook-up-group-scheduler-with-control-groups-fix.patch

 make sched container-aware

+change-struct-marker-users.patch
+combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
+linux-kernel-markers.patch
+linux-kernel-markers-checkpatch-fixes.patch
+linux-kernel-markers-coding-style-fixes.patch
+linux-kernel-markers-alignment-fix.patch
+add-samples-subdir.patch
+linux-kernel-markers-samples.patch
+linux-kernel-markers-samples-checkpatch-fixes.patch
+linux-kernel-markers-samples-coding-style-fix.patch
+linux-kernel-markers-samples-remove-asm.patch
+linux-kernel-markers-documentation.patch

 Linux kernel markers

+kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch
+uninline-forkc-exitc.patch
+uninline-forkc-exitc-checkpatch-fixes.patch

 cleanups/tweaks

+fuse-fix-allowing-operations.patch
+fuse-fix-race-between-getattr-and-write.patch
+fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
+fuse-add-file-handle-to-getattr-operation.patch
+fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
+fuse-clean-up-open-file-passing-in-setattr.patch
+vfs-allow-filesystems-to-implement-atomic-opentruncate.patch
+fuse-improve-utimes-support.patch
+fuse-add-atomic-opentruncate-support.patch
+fuse-support-bsd-locking-semantics.patch
+fuse-add-list-of-writable-files-to-fuse_inode.patch
+fuse-add-helper-for-asynchronous-writes.patch
+fuse-add-support-for-mandatory-locking.patch
+fuse-add-blksize-field-to-fuse_attr.patch

 FUSE updates

+sparse-pointer-use-of-zero-as-null.patch
+sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
+replace-__attribute_pure__-with-__pure.patch

 cleanups

+reiser4-fix-null-dereference-in-__mnt_is_readonly-in-ftruncate.patch
+reiser4-do-not-allocate-struct-file-on-stack.patch

 reiser4 updates

-check_dirty_inode_list.patch

 Dropped



6626 commits in 2239 patch files

All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/patch-list


