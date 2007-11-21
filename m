Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbXKUEpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbXKUEpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 23:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbXKUEpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 23:45:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605AbXKUEpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 23:45:34 -0500
Date: Tue, 20 Nov 2007 20:45:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc3-mm1
Message-Id: <20071120204525.ff27ac98.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm1/

- Added new git tree git-lblnet.patch: net labelling work (Paul Moore
  <paul.moore@hp.com)

- Re-added Smack

- Dropped git-kbuild.patch - it broke the scsi build

- I'm offline until Sunday (as are certain other patch targets..)


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



Changes since 2.6.24-rc2-mm1:


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
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-hrt.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-kvm.patch
 git-lblnet.patch
 git-leds.patch
 git-libata-all.patch
 git-m32r.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-net.patch
 git-netdev-all.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-parisc.patch
 git-selinux.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-scsi-rc-fixes.patch
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

-ecryptfs-cast-page-index-to-loff_t-instead-of-off_t.patch
-fix-oops-in-toshiba_acpi-error-return-path.patch
-rtc_hctosys-expects-rtcs-in-utc-doc.patch
-rtcs-handle-nvram-better.patch
-rtc-ds1307-exports-nvram.patch
-drivers-video-ps3fb-fix-memset-size-error.patch
-w1-fix-memset-size-error.patch
-slab-fix-typo-in-allocation-failure-handling.patch
-serial-add-pnp-id-for-davicom-isa-336k-modem.patch
-sysctl-check-length-at-deprecated_sysctl_warning.patch
-cm40x0_csc-fix-debug-macros.patch
-lib-move-bitmapo-from-lib-y-to-obj-y.patch
-uml-fix-symlink-loops.patch
-rtc-tweak-driver-documentation-for-rtc-periodic.patch
-chipsfb-uses-depends-on-pci.patch
-uvesafb-fix-warnings-about-unused-variables-on-non-x86.patch
-oprofile-oops-when-profile_pc-return-0lu.patch
-uml-fix-recvmsg-return-value-checking.patch
-uml-update-address-space-affected-by-pud_clear.patch
-uml-update-address-space-affected-by-pud_clear-checkpatch-fixes.patch
-improve-cgroup-printks.patch
-improve-cgroup-printks-fix.patch
-drivers-video-s1d13xxxfbc-as-module-with-dbg.patch
-forbid-user-to-change-file-flags-on-quota-files.patch
-forbid-user-to-change-file-flags-on-quota-files-fix.patch
-lxfb-use-the-correct-msr-number-for-panel-support.patch
-lguest_userc-fix-memory-leak.patch
-video-sis-fix-negative-array-index.patch
-8250_pnp-add-support-for-lg-c1-express-dual-machines.patch
-proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks.patch
-proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch
-migration-find-correct-vma-in-new_vma_page.patch
-memory-hotremove-unset-migrate-type-isolate-after-removal.patch
-make-getdelays-cgroupstats-aware.patch
-mm-speed-up-writeback-ramp-up-on-clean-systems.patch
-add-ioresouce_busy-flag-for-system-ram.patch
-acpi-make-acpi_procfs-default-to-y.patch
-spi-fix-double-free-on-spi_unregister_master.patch
-spi-fix-error-paths-on-txx9spi_probe.patch
-paride-pf-driver-fixes.patch
-drivers-misc-move-misplaced-pci_dev_puts.patch
-dmaengine-fix-broken-device-refcounting.patch
-atmel_serial-build-warnings-begone.patch
-hugetlb-follow_hugetlb_page-for-write-access.patch
-hugetlb-follow_hugetlb_page-for-write-access-fix.patch
-raid5-fix-unending-write-sequence.patch
-hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
-hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
-hugetlb-fix-quota-management-for-private-mappings.patch
-hugetlb-debit-quota-in-alloc_huge_page.patch
-hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
-hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
-mm-hugetlbc-make-a-function-static.patch
-hugetlb-fix-i_blocks-accounting.patch
-revert-task-control-groups-example-cpu-accounting-subsystem.patch
-fixes-to-the-bfs-filesystem-driver.patch
-linux-kernel-markers-fix-marker-mutex-not-taken-upon-module-load.patch
-linux-kernel-markers-document-format-string.patch
-linux-kernel-markers-fix-samples-to-follow-format-string-standard.patch
-acpi-sbs-fix-retval-warning.patch
-acpi-expose-_sun-in-proc-acpi-processor-info.patch
-powerpc-fix-fs_enet-module-build.patch
-fix-gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse.patch
-jdelvare-i2c-i2c-dev-add-comments.patch
-jdelvare-i2c-i2c-slave-busy-only-if-has-driver.patch
-jdelvare-i2c-i2c-make-i2c_check_addr-static.patch
-jdelvare-i2c-i2c-pasemi-replace-obsolete-driverfs-reference.patch
-jdelvare-i2c-i2c-eeprom-hide-serial-to-non-root-users.patch
-jdelvare-i2c-i2c-eeprom-recognize-vgn-prefix-as-vaio.patch
-jdelvare-i2c-i2c-pasemi-fix-nack-detection.patch
-hwmon-replace-power-of-two-test-in-drivers-hwmon-adt7470c.patch
-cscope-build-warning.patch
-ide-mm-ide-use-drive-select-all-for-req_type_ata_task-in-execute_drive_cmd.patch
-ide-mm-ide-pmac-skip-conservative-pio-downgrade.patch
-ide-mm-ide-add-missing-hob-bit-clearing-to-ide_dump_ata_status.patch
-ide-mm-ide-dont-bug-on-unsupported-transfer-modes.patch
-blk_dev_idecd-help-remove-outdated-note.patch
-remove-references-to-net-modulestxt.patch
-megaraid-sas-convert-aen_mutex-to-the-mutex-api.patch
-update-kerneldoc-comments-in-drivers-scsi-scsicamc.patch
-libsas-convert-sas_proto-users-to-sas_protocol.patch
-libsas-fix-various-sparse-complaints.patch
-unionfs-clear-partial-read.patch
-usb-power-managementtxt-disconnect-clarification.patch
-iwlwifi-remove-unnecessary-code-in-iwl3945-and-iwl4965-drivers.patch
-git-x86-broke-lguest.patch
-git-x86-broke-xen-too.patch
-i386-fix-reboot-with-no-keyboard-attached.patch
-oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters.patch
-oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
-remove-extern-declarations-for-code-data-bss-resource.patch
-x86_64-do-not-clear-cpu_index-set-by-store_cpu_info.patch
-x86-typo-about-sequence-of-cpu_index-and-cpu_online-in.patch
-i386-and-x86_64-randomize-brk.patch
-i386-and-x86_64-randomize-brk-fix.patch
-i386-and-x86_64-randomize-brk-fix-2.patch
-x86-bitops_32h-style-cleanups.patch
-x86-check-boundary-in-count-setup_resource-called-by.patch
-arch-x86-remove-duplicate-includes.patch
-x86-arch_register_cpu-section-fix.patch
-i386-reboot-fixup-for-wrap-2c-board-sc1100-based.patch
-fix-wrong-proc-cpuinfo-on-x64.patch
-x86_64-clean-up-stack-allocation-and-free.patch
-x86_64-configure-stack-size.patch
-ia32-emu-remove-dead-code.patch
-x86_64-add-acpi-reboot-option.patch
-git-cryptodev-hifn_795x-fixes.patch
-xtensa-iss_net_setup-must-be-__init.patch
-i-oat-add-support-for-version-2-of-ioatdma-device.patch
-reiserfs-dont-drop-pg_dirty-when-releasing-sub-page-sized-dirty-file.patch
-rtc-release-correct-region-in-error-path.patch
-rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
-i5000_edac-no-need-to-__stringify-kbuild_basename.patch
-serial-only-use-pnp-irq-if-its-valid.patch
-sunrpc-xprtrdma-transportc-fix-use-after-free.patch
-fix-mm-utilckrealloc.patch
-fuse_file_alloc-fix-null-dereferences.patch
-tle62x0-driver-stops-ignoring-read-errors.patch
-rd-fix-data-corruption-on-memory-pressure.patch
-cris-gpio-undo-locks-before-returning.patch
-mips-undo-locking-on-error-path-returns.patch
-mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
-proc-simplify-and-correct-proc_flush_task.patch
-fix-param_sysfs_builtin-name-length-check.patch
-mark-sys_open-sys_read-exports-unused.patch
-sysctl-fix-token-ring-procname.patch
-gbefb-fix-section-mismatch-warnings.patch
-vmstat-fix-section-mismatch-warning.patch
-pidns-place-under-config_experimental.patch
-pidns-place-under-config_experimental-checkpatch-fixes.patch
-__do_irq-does-not-check-irq_disabled-when-irq_per_cpu-is-set.patch
-hibernate-fix-lockdep-report-2.patch
-smbfs-fix-debug-builds.patch
-fix-64kb-blocksize-in-ext3-directories.patch
-fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
-uml-fix-spurious-irq-testing.patch
-uml-remove-last-include-of-libc-asm-pageh.patch
-uml-fix-build-for-config_tcp.patch
-uml-fix-build-for-config_printk.patch
-swap-delay-accounting-include-lock_page-delays.patch
-file-capabilities-allow-sigcont-within-session-v2.patch
-file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
-file-capabilities-allow-sigcont-within-session-v2-file-capabilities-remove-the-non-matching-uid-special-case-for-kill.patch
-feature-removal-schedule-remove-sa_-flags-entry.patch
-kernel-taskstatsc-fix-bogus-nlmsg_free.patch
-x86-show-cpuinfo-only-for-online-cpus.patch
-make-proc-acpi-ac_adapter-dependent-on-acpi_procfs.patch
-acpi-ac-update-ac-state-on-resume.patch
-keyspan-init-termios-properly.patch
-x86-disable-preemption-in-delay_tsc.patch
-oprofile-fix-oops-on-x86-32-bit.patch
-x86-early_quirks-cleanup.patch
-x86-dont-call-mce_create_device-on-cpu_up_prepare.patch
-aic94xx_sds-rename-flash_size.patch
-mips-pcspkr-build-fix.patch
-kernel-power-move-function-prototypes-to-header.patch
-cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
-cris-build-fixes-add-missing-syscalls.patch
-cris-build-fixes-hardirqh-include-asm-irqh.patch
-cris-build-fixes-atomich-needs-compilerh.patch
-cris-build-fixes-atomich-needs-compilerh-fix.patch
-cris-build-fixes-irq-fixes.patch
-cris-build-fixes-sys_crisc-needs-fsh.patch
-cris-build-fixes-add-baud-rate-defines.patch
-cris-build-fixes-update-eth_v10c-ethernet-driver.patch
-cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
-cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
-cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
-cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
-cris-build-fixes-setupc-needs-paramh.patch
-cris-build-fixes-fix-crisksymsc.patch
-cris-build-fixes-defconfig-updates.patch
-cris-array_size-cleanup.patch
-cris-dont-include-bitopsh-in-posix_typesh.patch
-crisv10-serial-driver-rewrite-take-three.patch
-cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two.patch
-cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
-crisv10-fix-timer-interrupt-parameters.patch
-crisv10-improve-and-bugfix-fasttimer.patch
-crisv32-add-cache-flush-operations.patch

 Merged into mainline or a subsystem tree

+update-checkpatchpl-to-version-012.patch
+file-capabilities-allow-sigcont-within-session-v2.patch
+cris-build-fixes-atomich-needs-compilerh.patch
+atmel_spi-labels-gpios-better.patch
+ps3-prefix-all-ps3-specific-kernel-modules-with.patch
+ps3fb-video-memory-size-cleanups.patch
+fix-boot-problem-with-iseries-lacking-hugepage-support.patch
+uml-build-fix.patch
+xen-mask-_page_pcd-from-ptes.patch
+pnp-increase-the-maximum-number-of-resources.patch
+pnp-increase-the-maximum-number-of-resources-fix.patch
+proc-fix-null-i_fop-oops.patch
+wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
+proc-remove-races-from-proc_id_readdir.patch
+m68k-export-atari_keyb_init.patch
+amiga-zorro-bus-add-missing-zorro_device_remove.patch
+mac68k-mailing-list-addresss.patch
+tpm-tis-device-driver-locality-request.patch
+termios-document-callback-more-clearly.patch
+s3c24xx-ensure-we-only-configure-valid-gpios.patch
+ipmi-add-the-standard-watchdog-timeout-ioctls.patch
+s3c2410-add-bus-number-to-spi-gpio-driver.patch
+revert-keyspan-init-termios-properly.patch
+memory-hotplug-fix-fix-section-mismatch-in-vmammap_allock_block.patch
+memory-hotplug-x86_64-fix-section-mismatch-in-init_memory_mapping.patch
+fuse-fix-reading-past-eof.patch
+fuse-cleanup-add-fuse_get_attr_version.patch
+fuse-pass-open-flags-to-read-and-write.patch
+fuse-fix-fuse_file_ops-sending.patch
+fuse-fix-uninitialized-field-in-fuse_inode.patch
+fuse-fix-attribute-caching-after-rename.patch
+clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch

 2.6.24 queue

-x86_64-efi-boot-support-efi-frame-buffer-v3.patch

 Folded into x86_64-efi-boot-support-efi-frame-buffer.patch

+git-acpi-fixup.patch

 Fix git-acpi.patch rejects

+agk-dm-dm-merge-max_hw_sector.patch
+agk-dm-dm-crypt-move-queue-functions.patch

 device mapper tree updates

+gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch

 Fix git-acpi versus driver tree

+intel-agp-enable-i915-recognition.patch

 AGP fix

+time-fold-__get_realtime_clock_ts-into-getnstimeofday.patch

 cleanup

+qlogic-infinipath-convert-ipath_eep_sem-to-mutex.patch
+fix-build-failure-when-config_infiniband_ipoib_cm-is-not-defined.patch

 scsi things

+input-polled-device-timer-rounding.patch

 input fix

+pata_sisc-add-packard-bell-easynote-k5305-to-laptops.patch
+ahci-invalid-use-of-writel-readl-with-iomap.patch
+libata-core-list-more-documentation-sources-for-reference.patch
+libata-iordy-handling.patch
+libata-sff-tf_load.patch
+pata_ali-add-mitac-8317-and-derivatives.patch
+pata_ali-lots-of-problems-still-showing-up-with-small-atapi-dma.patch
+pata_hpt37x-fix-cable-detect-bug-spotted-by-sergei.patch
+pata_isapnp-polled-devices.patch
+pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch
+pata_ninja32-cardbus-ata-initial-support.patch
+libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch

 sata/pata things

+ide-mm-sis5513-add-packard-bell-easynote-k5305-to-laptops.patch
+ide-mm-ide-dont-set-pio-mode-on-pre-eide-drives.patch
+ide-mm-siimage-remove-resetproc-method.patch
+ide-mm-ide-skip-ide_wait_not_busy-on-noprobe-disks.patch
+ide-mm-aec62xx-fix-kernel-oops-in-driver-s-probe-function.patch
+ide-mm-serverworks-cleanup-set_dma_mode-method.patch
+ide-mm-ide-disk-add-idedisk_set_doorlock-helper.patch
+ide-mm-ide-hopefully-fix-vdma-for-cs5520.patch
+ide-mm-cy82c693-correct-dma-modes-clipping.patch
+ide-mm-cy82c693-add-set_dma_mode-method.patch
+ide-mm-sgiioc4-add-ide_toggle_bounce-calls.patch
+ide-mm-icside-add-ide_toggle_bounce-calls.patch
+ide-mm-au1xxx-ide-add-ide_toggle_bounce-calls.patch
+ide-mm-ide-remove-ide_dma_on-and-dma_off_quietly-methods-from-ide_hwif_t.patch
+ide-mm-ide-cris-fix-dma-methods.patch
+ide-mm-atiixp-remove-dma_host_on-and-dma_host_off-methods.patch
+ide-mm-ide-move-drive-using_dma-check-to-callers-of-dma_host_on-method.patch
+ide-mm-ide-merge-dma_host_-on-off-methods-into-dma_host_set-method.patch

 IDE tree updates

+ide-printk-fix.patch

 fix it

+git-mips-fixup.patch

 Fix rejects in git-mips.patch

+forcedeth-boot-delay-fix.patch

 forcedeth fix

-nfs-stop-sillyname-renames-and-unmounts-from-racing.patch
-nfs-stop-sillyname-renames-and-unmounts-from-racing-fix.patch
-nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix.patch
-nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix-fix.patch
+nfs-stop-sillyname-renames-and-unmounts-from-racing-2.patch
+nfs-fix-up-problems-with-steves-sillyrename-fix.patch
+nfs-fix-nfs_free_unlinkdata.patch

 Updated

-git-nfsd-fixup.patch

 Unneeded

+git-nfsd-build-fix.patch

 fix git-nfsd

+pci-add-pci-quirk-function-for-some-chipsets.patch
+drivers-pci-quirksc-coding-style-cleanup.patch
+more-sanity-checks-for-dmar.patch
+more-sanity-checks-for-dmar-checkpatch-fixes.patch

 PCI updates

+pcie-fix-double-initialization-bug.patch

 PCIE fix

+dell-cerc-support-for-megaraid_mbox.patch

 scsi fix

+iommu-sg-merging-add-device_dma_parameters-structure.patch
+iommu-sg-merging-pci-add-device_dma_parameters-support.patch
+iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
+iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
+iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
+iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
+iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
+iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
+iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
+iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
+iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch

 iommu work

+ti-3410-5052-usb-serial-convert-td_open_close_lock-to-mutex.patch

 USB driver cleanup

+git-x86-fixup.patch
+git-x86-thread_order-borkage.patch
+git-x86-thread_order-borkage-fix.patch
+git-x86-identify_cpu-fix.patch
+git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko.patch
+git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko-checkpatch-fixes.patch

 Fixes to gix-x86.patch

+x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2.patch

 change x86_64 default memory model

+frv-fix-the-extern-declaration-of-kallsyms_num_syms.patch
+frv-arrange-things-such-that-bra-can-reach-from-the-trap.patch
+add-mike-christie-to-maintainers.patch
+wait_task_stopped-pass-correct-exit_code-to.patch
+isdn-validate-length-of-isdn_net_ioctl_cfgeaz.patch
+tty-add-the-new-termios2-ioctls-to-the-compatible.patch
+acpi-avoid-references-to-impossible-processors.patch

 More 2.6.24 queue

+slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch

 Fix slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch

+config_highpte-vs-sub-page-page-tables-fix-2.patch

 Fix config_highpte-vs-sub-page-page-tables.patch some more

+vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
+mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
+page-allocator-get-rid-of-the-list-of-cold-pages.patch
+page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
+mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch

 MM updates

+64bit-capability-support-legacy-support-fix.patch

 Fix add-64-bit-capability-support-to-the-kernel.patch som emore

+smack-version-11c-simplified-mandatory-access-control-kernel.patch

 smack

+m68knommu-removing-config-variable-dumptoflash.patch

 m68knommu update

+pm-qos-remove-locks-around-blocking-notifier.patch

 Fix PM qos patches

+m68k-array_size-cleanup.patch
+dio-array_size-cleanup.patch
+m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch
+nubus-kill-drivers-nubus-nubus_symsc.patch
+m68k-kill-arch-m68k-mac-mac_ksymsc.patch
+m68k-kill-arch-m68k-hp300-ksymsc.patch
+m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
+m68k-kill-arch-m68k-atari-atari_ksymsc.patch
+m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
+mac68k-macii-adb-comment-correction.patch
+mac68k-remove-dead-code.patch
+mac68k-add-nubus-card-definitions-and-a-typo-fix.patch
+mac68k-remove-dead-mac_adbkeycodes.patch

 m68k stuff

+uml-arch-um-include-inith-needs-a-definition-of-__used.patch
+uml-improve-detection-of-host-cmov-checkpatch-fixes-fix.patch
+uml-tidy-pgtableh-fix.patch
+uml-remove-unused-variables-in-the-context-switcher.patch
+uml-convert-functions-to-void.patch
+uml-host-tls-diagnostics.patch
+uml-move-um_virt_to_phys.patch
+uml-header-untangling.patch
+uml-style-cleanup.patch
+uml-currenth-cleanup.patch
+uml-fix-page-table-data-sizes.patch
+uml-add-virt_to_pte.patch
+uml-simplify-sigsegv-handling.patch
+uml-use-ptrace-directly-in-libc-code.patch
+uml-kill-processes-instead-of-panicing-kernel.patch
+uml-add-missing-space.patch

 UML updates

-procfs-detect-duplicate-names.patch

 Updated

+use-__set_task_state-for-traced-stopped-tasks.patch

 cleanup

+genericizing-iova-fix.patch

 Fix genericizing-iova.patch

-mm-fix-blkdev-size-calculation-in-generic_write_checks.patch

 Dropped

+fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
+alpha-parisc-removing-config-variable-debug_rwlock.patch
+document-i_sync-and-i_datasync.patch
+ps3-checkpatch-drivers-ps3-ps3-sys-managerc.patch
+ps3-checkpatch-drivers-ps3-ps3-vuartc.patch
+percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
+i-oat-fixups-from-code-comments.patch
+printkc-use-unsigned-ints-instead-of-longs-for-logbuf-index.patch
+tpmc-fix-crash-during-device-removal.patch
+a-few-corrections-to-include-linux-kbuild.patch
+vt-bitlock-fix.patch
+avoid-divide-in-is_align.patch
+do_wait-remove-one-else-if-branch.patch

 Misc

+atmel_spi-throughput-improvement.patch
+atmel_spi-chain-dma-transfers.patch

 SPI updates

+gigaset-clean-up-urb-status-usage.patch
+gigaset-code-cleanups.patch
+bas_gigaset-suspend-support-v2.patch
+usb_gigaset-suspend-support-v3.patch
+gigaset-atomic-cleanup.patch

 ISDN

+rtc-ds1302-rtc-support.patch
+rtc-ds1302-rtc-support-checkpatch-fixes.patch

 RTC updates

+generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch

 Fix generic-gpio-gpio_chip-support.patch

+add-buffer-head-related-helper-functions.patch
+ext2-add-block-bitmap-validation.patch
+ext3-add-block-bitmap-validation.patch
+ext4-add-block-bitmap-validation.patch
+ext4-add-block-bitmap-validation-fix.patch

 ext2/3/4 runtie checks

-ridiculous-ext3-costs-was-re-page-fault-costs.patch

 Dropped

-nfsd-fix-wrong-mnt_writer-count-in-rename.patch

 Obsolete

+iget-stop-bfs-from-using-iget-and-read_inode-try-fix.patch

 Fix iget-stop-bfs-from-using-iget-and-read_inode-try.patch

+add-dma-engine-driver-for-freescale-mpc85xx-processors-fix-fix.patch

 Fix add-dma-engine-driver-for-freescale-mpc85xx-processors.patch

+embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-nfs4-fix.patch

 Fix embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
 
+use-struct-path-in-struct-svc_export-nfsd-fix-wrong-mnt_writer-count-in-rename.patch

 Fix use-struct-path-in-struct-svc_export.patch some more

-suppress-aout-library-support-if-config_binfmt_aout.patch
-suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes.patch
-usb-net2280-cant-have-a-function-called.patch
-usb-net2280-cant-have-a-function-called-checkpatch-fixes.patch
-mn10300-allocate-serial-port-uart-ids-for-on-chip-serial.patch
-mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
-mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
-mn10300-add-the-mn10300-am33-architecture-to-the-kernel-ia64-fix.patch

 Dropped

+add-the-namespaces-config-option.patch
+move-the-uts-namespace-under-uts_ns-option.patch
+move-the-ipc-namespace-under-ipc_ns-option.patch
+cleanup-the-code-managed-with-the-user_ns-option.patch
+cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
+cleanup-the-code-managed-with-pid_ns-option.patch
+cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
+mark-net_ns-with-depends-on-namespaces.patch

 Namespace updates

+proc-remove-module_license.patch
+proc-less-lock-operations-during-lookup.patch
+proc-simplify-function-prototypes.patch
+proc-remove-useless-check-on-symlink-removal.patch
+proc-remove-useless-checks-in-proc_register.patch
+proc-detect-duplicate-names-on-registration.patch
+proc-detect-duplicate-names-on-registration-fix.patch
+proc-implement-proc_single_file_operations.patch
+proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
+proc-seqfile-convert-proc_pid_statm.patch
+proc-proper-pidns-handling-for-proc-self.patch

 procfs maintenance

+intel-iommu-pmen-support.patch
+intel-iommu-fault_reason_index_cleanuppatch.patch
+intel-iommu-fault_reason_index_cleanuppatch-fix.patch

 Intel IOMMU updates

+tty-let-architectures-override-the-user-kernel-macros.patch
+tty-s390-support-for-termios2.patch
+moxa-first-pass-at-termios-reporting.patch
+n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch
+rocket-first-pass-at-termios-reporting.patch
+rocket-dont-let-random-users-reset-the-controller.patch
+tty_audit-fix-checkpatch-complaint.patch
+tty_io-drag-screaming-into-coding-style-compliance.patch
+tty_ioctl-drag-screaming-into-compliance-with-the-coding.patch
+8250_early-coding-style.patch
+8250_gsc-coding-style.patch
+8250_hp300-coding-style.patch
+8250_hub6-codding-style.patch
+8250_pci-coding-style.patch
+serial8250-coding-style.patch
+8250-enable-rate-reporting-via-termios.patch
+serial_core-bring-mostly-into-line-with-coding-style.patch

 tty/serial driver updates


3200 commits in 1255 patch files

All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm1/patch-list


