Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbXFFJIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbXFFJIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760214AbXFFJHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:07:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760098AbXFFJHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:07:46 -0400
Date: Wed, 6 Jun 2007 02:07:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc4-mm1
Message-Id: <20070606020737.4663d686.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/

- Somebody broke it on my powerpc G5, but I didn't have time to do yet
  another bisection yet.

- There's a lengthy patch series here from Nick which attempts to address
  the longstanding pagefault-vs-buffered-write deadlock.

  A great shower of filesystems were broken and have been disabled with
  CONFIG_BROKEN.  This includes reiser4.

- Complex patches which eliminate the kernel's fixed size limit on the
  command-line length.  These break nommu builds.



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




Changes since 2.6.21-rc3-mm1:


 git-acpi.patch
 git-alsa.patch
 git-arm-master.patch
 git-arm.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-drm.patch
 git-dvb.patch
 git-gfs2-nmw.patch
 git-hid.patch
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
 git-ubi.patch
 git-netdev-all.patch
 git-net.patch
 git-backlight.patch
 git-battery.patch
 git-ioat.patch
 git-nfs.patch
 git-nfs-server-cluster-locking-api.patch
 git-ocfs2.patch
 git-parisc.patch
 git-r8169.patch
 git-selinux.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-scsi-rc-fixes.patch
 git-scsi-target.patch
 git-unionfs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-xtensa.patch
 git-gccbug.patch

 git trees

-at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
-slub-more-documentation.patch
-slub-more-documentation-fix.patch
-smpboot-cachesize-comparison-fix-in-smp_tune_scheduling.patch
-pci-quirks-fix-msi-disabling-on-rs400-200-and-rs480.patch
-ntfs_init_locked_inode-fix-array-indexing.patch
-m68k-runtime-patching-infrastructure.patch
-slub-fix-numa--sysfs-bootstrap-issue.patch
-afs-needs-schedh.patch
-m68k-discontinuous-memory-support.patch
-fix-vmic-compilation.patch
-git-acpi-export-acpi_set_cstate_limit.patch
-acpi-bay-send-envp-with-uevent.patch
-remove-dell-optiplex-gx240-from-the-acpi-blacklist.patch
-fix-gregkh-driver-dmi-based-module-autoloading.patch
-fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
-power-management-use-mutexes-instead-of-semaphores.patch
-sysdev-use-mutex-instead-of-semaphore.patch
-saa7134-tvaudio-kthread-conversion.patch
-input-reduce-raciness-when-input-handlers-disconnect.patch
-input-convert-from-class-devices-to-standard-devices.patch
-drivers-input-mouse-kconfig-fix-typo.patch
-atm-fix-warning.patch
-pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips.patch
-fix-pci_find_present.patch
-sh-support-older-gccs.patch
-scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
-fix-for-bugzilla-8426-massive-slowdown-on-scsi-cd-dvd-drive-connected-to-mptspi-driver.patch
-scsi-fix-ambiguous-gdthtable-definition.patch
-sparc32-build-fix.patch
-b44-ssb-fix-an-invalid-pointer-casting.patch
-i386-pci-fixup-for-siemens-nixdorf-ag-fsc-multiprocessor-interrupt-controllers.patch
-x86_64-allocate-sparsemem-memmap-above-4g.patch
-add-select-phylib-to-the-ucc_geth-kconfig-option.patch
-fix-possible-udf-data-corruption.patch
-fix-possible-leakage-of-blocks-in-udf.patch
-fix-possible-leakage-of-blocks-in-udf-tidy.patch
-m68k-parenthesis-balance.patch
-msi-fix-the-ordering-of-msix-irqs.patch
-msi-mask-the-msix-vector-before-we-unmap-it.patch
-potential-parse-error-in-ifdef.patch
-potential-parse-error-in-ifdef-fix.patch
-potential-parse-error-in-ifdef-update.patch
-pci_ids-update-patch-for-intel-ich9m.patch
-x86-fix-oprofile-double-free-was-re-multiple-free.patch
-work-around-dell-e520-bios-reboot-bug.patch
-fix-compat-futex-code-for-private-futexes.patch
-skeletonfb-fix-of-xxxfb_setup-ifdef.patch
-vt8623fb-arkfb-null-pointer-dereference-fix.patch
-cfag12864bfb-use-sys_-instead-of-cfb_-framebuffer-accessors.patch
-fbdev-move-declaration-of-fb_class-to-linux-fbh.patch
-misc-tifm_7xx1-replace-deprecated-irq-flag.patch
-add-a-trivial-patch-style-checker-v2.patch
-documentation-how-to-use-gdb-to-decode-oopses.patch
-rtc-use-fallback-irq-if-pnp-tables-dont-provide-one.patch
-memory-hotplug-fix-unnecessary-calling-of-init_currenty_empty_zone.patch
-missing-include-linux-mmh-in-drivers-sbus-char-flashc.patch
-tty-fix-leakage-of-erestartsys-to-userland.patch
-isdn4linux-fix-maturity-label-v4.patch
-fix-broken-clir-in-isdn-driver.patch
-prism54-maintainers-update.patch
-aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch
-atmel_spi-dma-address-bugfix.patch
-neofb-fix-pseudo_palette-array-overrun-in-neofb_setcolreg.patch
-ramfs-nommu-a-bug-in-ramfs_nommu_resize-function-passing-old-size-to-vmtruncate.patch
-h8300-trival-patches.patch
-alpha-support-graphics-on-non-zero-pci-domains.patch
-alpha-support-graphics-on-non-zero-pci-domains-fix.patch
-alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
-alpha-correct-low-level-i-o-routines-for-sable-lynx.patch
-alpha-misc-fixes.patch

 Merged into mainline or a subsystem tree

+update-checkpatchpl-to-version-003.patch
+m68knommu-fix-coldfire-timer-off-by-1.patch
+nommu-report-correct-errno-in-message.patch
+document-acked-by.patch
+pi-futex-fixes.patch
+update-feature-removal-scheduletxt-to-include-deprecated-functions.patch
+mount-t-tmpfs-o-mpol=-check-nodes-online.patch
+slab-fix-alien-cache-handling.patch
+potential-parse-error-in-ifdef-part-3.patch
+slub-return-zero_size_ptr-for-kmalloc0.patch
+ramfs-nommu-missed-posix-uid-gid-inode-attribute-checking.patch
+uml-fix-kernel-stack-size-on-x86_64.patch
+documentation-atomic_opstxt.patch

 2.6.22 queue

+checkpatch-produce-fewer-lines-of-output.patch

 Probably for 2.6.22

+git-acpi-tickh-needs-hrtimerh.patch
+git-acpi-add-exports.patch

 Fir git-acpi.patch

-git-alsa-fixup.patch

 Unneeded

+yet-another-uniwill-laptop-with-alc861-codec.patch

 ALSA fix

+intel_agp-add-support-for-965gme-gle.patch
+intel_agp-add-support-for-945gme.patch
+intel_agp-add-support-for-g33-q33-and-q35-chipsets.patch

 AGP work

+bugfix-cpufreq-in-combination-with-performance-governor.patch
+bugfix-cpufreq-in-combination-with-performance-governor-fix.patch

 cpufreq fix

+make-drivers-char-hvc_consoleckhvcd-static.patch

 powerpc driver cleanup

+gregkh-driver-sysdev-use-mutex-instead-of-semaphore.patch
+gregkh-driver-power-management-use-mutexes-instead-of-semaphores.patch
+gregkh-driver-block-device.patch

 Driver tree updates

+fix-2-gregkh-driver-dmi-based-module-autoloading.patch

 Fix it

+git-dvb-fix-the-tea5761-tuner-support.patch

 git-dvb fix

+jdelvare-i2c-video-matroxfb-crtc2-header-fix.patch

 I2C tree update

+i2c-iop3xx-switch-to-static-adapter-numbering.patch
+thecus-n2100-register-rtc-rs5c372-i2c-device.patch

 I2C things

+jdelvare-hwmon-hwmon-via686a-fix-temperature-interrupt-mode.patch
+jdelvare-hwmon-hwmon-via686a-to-platform-driver.patch
+jdelvare-hwmon-hwmon-via686a-dynamic-attributes.patch
+jdelvare-hwmon-hwmon-sis5595-to-platform-driver.patch
+jdelvare-hwmon-hwmon-sis5595-dynamic-attributes.patch

 hwmon tree updates

+git-input-fixup.patch

 Fix rejects in git-input.patch

+git-input-make-xpad_play_effect-static.patch

 input cleanup

+libata-config_pm=n-compile-fix.patch

 libata fix

+drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch

 Restore wrong patch (needs updating)

+ide-serverworks-remove-crappy-code.patch
+ide-serverworks-fix-csb6-tuning-logic.patch
+ide-it821x-raid-mode-fixes.patch
+ide-ide-hpa-detect-from-resume.patch

 IDE tree udpates

+ide-ide-generic-add-another-device-exception.patch

 IDE tweak

+git-md-accel-fixup.patch

 Fix rejects in git-md-accel.patch

+mtd-use-null-for-pointer.patch

 MTD sparse fix

+sundance-phy-address-form-0-only-for-device-id-0x0200.patch
+sundance-phy-address-form-0-only-for-device-id-0x0200-fix.patch

 netdev fixes

+ppp_mppe-account-for-osize-too-small-errors-in.patch

 Fix mppe

-bluetooth-postpone-hci_dev-unregistration.patch

 Dropped - unneeded, might be buggy.

-git-ioat-vs-git-md-accel.patch

 Unneeded

-gregkh-pci-pci-reduce-aer-init-error-information.patch
-gregkh-pci-msi-fix-arm-compile.patch
-allow-aer-to-build-for-config_acpi-=-n.patch

 Dropped

+pci_set_power_state-check-for-pm-capabilities-earlier.patch

 PCI logspam fix

-git-pciseg.patch
-pci-device-ensure-sysdata-initialised-v2.patch

 Other patches broke this

-git-scsi-misc-fixup.patch

 Unneeded

+scsi-dont-build-scsi_dma_mapunmap-for-has_dma.patch
+scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch

 SCSI updates

+update-documentation-block-barriertxt.patch

 Doc update

+usb-try-to-debug-bug-8561.patch
+usb-bugfix-gfp_kernel-gfp_atomic-in-spin_locked-region.patch
+usb-serial-fix-something.patch

 USB stuff

+x86_64-mm-compat-syscall-u64.patch
+x86_64-mm-cpa-cache-flush.patch
+x86_64-mm-disable-watchdog.patch
+x86_64-mm-fix-eventd-syscall.patch
+x86_64-mm-fam10-l3cache.patch

 x86 tree updates

+revert-x86_64-mm-verify-cpu-rename.patch
+revert-x86_64-mm-cpa-cache-flush.patch
+fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch

 Fix it

+round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
+mmconfig-validate-against-acpi-motherboard-resources.patch
+pci-disable-decode-of-io-memory-during-bar-sizing.patch
+x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
+i386-remove-support-for-the-rise-cpu.patch
+x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch
+x86-64-calgary-update-copyright-notice.patch
+x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch
+x86-64-calgary-introduce-chipset-specific-ops.patch
+x86-64-calgary-introduce-chipset-specific-ops-fix.patch
+x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch
+x86-64-calgary-introduce-calioc2-support.patch
+x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
+x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
+x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch
+x86-64-calgary-make-dump_error_regs-a-chip-op.patch
+x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch
+x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
+x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
+x86-64-calgary-cleanup-of-unneeded-macros.patch
+x86-64-calgary-tabify-and-trim-trailing-whitespace.patch
+x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch
+x86-64-calgary-tidy-up-debug-printks.patch
+i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
+i386-fix-section-mismatch-warning-in-intel_cacheinfo.patch
+i386-do-not-restore-reserved-memory-after-hibernation.patch
+i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
+paravirt-helper-to-disable-all-io-space.patch
+paravirt-helper-to-disable-all-io-space-fix.patch
+xen-disable-all-non-virtual-devices.patch
+dmi_match-patch-in-rebootc-for-sff-dell-optiplex-745-fixes-hang.patch
+x86_64-use-null-for-pointer.patch

 x86/x86-64 stuff

+ext3-lost-brelse-in-ext3_read_inode.patch
+ext4-lost-brelse-in-ext4_read_inode.patch
+acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch

 Probable 2.6.22 queue

+console-more-buf-for-index-parsing.patch
+console-console-handover-to-preferred-console.patch
+x86-initial-fixmap-support.patch
+serial-convert-early_uart-to-earlycon-for-8250.patch
+serial-assert-dtr-for-serial-console-devices.patch

 Another go at fixing some early console issues

+make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch

 Fix make-proc-slabinfo-use-seq_list_xxx-helpers.patch

+rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
+rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
+rework-ptep_set_access_flags-and-fix-sun4c-fix-fix-fix.patch

 Fix rework-ptep_set_access_flags-and-fix-sun4c.patch

+vmscan-fix-comments-related-to-shrink_list.patch

 Fix comments

+ocfs2-release-page-lock-before-calling-page_mkwrite.patch
+document-page_mkwrite-locking.patch
+slub-support-slub_debug-on-by-default.patch
+slub-support-slub_debug-on-by-default-tidy.patch
+numa-mempolicy-allow-tunable-policy-for-system-init.patch
+numa-mempolicy-allow-tunable-policy-for-system-init-fix.patch
+mm-revert-kernel_ds-buffered-write-optimisation.patch
+revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
+revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
+mm-clean-up-buffered-write-code.patch
+mm-debug-write-deadlocks.patch
+mm-trim-more-holes.patch
+mm-buffered-write-cleanup.patch
+mm-write-iovec-cleanup.patch
+mm-fix-pagecache-write-deadlocks.patch
+mm-buffered-write-iterator.patch
+fs-fix-data-loss-on-error.patch
+fs-introduce-write_begin-write_end-and-perform_write-aops.patch
+mm-restore-kernel_ds-optimisations.patch
+implement-simple-fs-aops.patch
+block_dev-convert-to-new-aops.patch
+ext2-convert-to-new-aops.patch
+ext3-convert-to-new-aops.patch
+ext4-convert-to-new-aops.patch
+xfs-convert-to-new-aops.patch
+gfs2-convert-to-new-aops.patch
+fs-new-cont-helpers.patch
+fat-convert-to-new-aops.patch
+hfs-convert-to-new-aops.patch
+hfsplus-convert-to-new-aops.patch
+hpfs-convert-to-new-aops.patch
+bfs-convert-to-new-aops.patch
+qnx4-convert-to-new-aops.patch
+reiserfs-use-generic-write.patch
+reiserfs-convert-to-new-aops.patch
+reiserfs-use-generic_cont_expand_simple.patch
+with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
+nfs-convert-to-new-aops.patch
+smb-convert-to-new-aops.patch
+fuse-convert-to-new-aops.patch
+hostfs-convert-to-new-aops.patch
+jffs2-convert-to-new-aops.patch
+ufs-convert-to-new-aops.patch
+udf-convert-to-new-aops.patch
+sysv-convert-to-new-aops.patch
+minix-convert-to-new-aops.patch
+jfs-convert-to-new-aops.patch
+nick-broke-stuff.patch
+nick-broke-more-stuff.patch
+nick-broke-even-more-stuff.patch
+nick-really-did-it-this-time.patch

 Fix the pagefault-versus-buffered-write deadlock

+do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
+print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch

 More updates to the page-mobility patches

+hexdump-more-output-formatting.patch

 hexdump.c feature creep

+freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch

 Fix the oft-fixed freezer-make-kernel-threads-nonfreezable-by-default.patch

+nommu-stub-expand_stack-for-nommu-case.patch
+m68knommu-use-trhead_size-instead-of-hard-constant.patch
+m68knommu-remove-cruft-from-setup-code.patch
+m68knommu-remove-old-cache-management-cruft-from-mm-code.patch

 nommu updates

+h8300-zimage-support-update.patch

 h8300 feature work

+swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch

 Fix swsusp-remove-code-duplication-between-diskc-and-userc.patch

+pm-introduce-hibernation-and-suspend-notifiers.patch
+pm-introduce-hibernation-and-suspend-notifiers-fix.patch
+pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
+pm-disable-usermode-helper-before-hibernation-and-suspend.patch
+pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch

 More power-management work

+uml-fix-request-sector-update.patch

 UML fixlet

-partitions-check-the-return-value-of-kobject_add-etc.patch

 Dropped - people kept on breaking it and I got fed up.

-preserve-the-dirty-bit-in-init_page_buffers.patch
-rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty.patch
-rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
-rd-simplify-by-using-the-same-helper-functions-in-libfs.patch

 Shelved these for now - I think they're causing BUG_ONs to trigger.

+udf-coding-style-conversion-lindent-fixups-2.patch

 More UDF whitespace fixing

+zs-move-to-the-serial-subsystem-update.patch

 Fix zs-move-to-the-serial-subsystem.patch

+add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
+buffer-kill-old-incorrect-comment.patch
+introduce-o_cloexec-take-2.patch
+introduce-o_cloexec-parisc-fix.patch
+o_cloexec-for-scm_rights.patch
+o_cloexec-for-scm_rights-fix.patch
+o_cloexec-for-scm_rights-fix-2.patch
+init-wait-for-asynchronously-scanned-block-devices.patch
+atmel_serial-fix-break-handling.patch
+documentation-proc-pid-stat-files.patch
+seq_file-more-atomicity-in-traverse.patch
+lib-add-idr_for_each.patch
+lib-add-idr_for_each-fix.patch
+lib-add-idr_remove_all.patch
+remove-capabilityh-from-mmh.patch
+kernel-utf-8-handling.patch
+remove-sonypi_camera_command.patch
+drop-an-empty-isicomh-from-being-exported-to-user-space.patch
+cobalt-remove-all-traces-of-cobalt-from-nvramc.patch
+ext3-ext4-orphan-list-check-on-destroy_inode.patch
+ext3-ext4-orphan-list-check-on-destroy_inode-fix.patch
+ext3-ext4-orphan-list-corruption-due-bad-inode.patch
+allow-file-system-to-configure-for-no-leases.patch
+remove-apparently-useless-commented-apm_get_battery_status.patch
+taskstats-add-context-switch-counters.patch
+taskstats-add-context-switch-counters-fix.patch
+sony-laptop-use-null-for-pointer.patch

 Misc

+introduce-i_sync.patch

 Fix a VFS deadlock which nobody seems to be able to explain or reproduce.

+spi-controller-drivers-check-for-unsupported-modes-update.patch

 Fix spi-controller-drivers-check-for-unsupported-modes.patch

+spi_lm70llp-parport-adapter-driver.patch
+spi_lm70llp-parport-adapter-driver-correction.patch

 SPI device driver

+sane-irq-initialization-in-sedlbauer-hisax.patch

 ISDN fix

+fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch

 Fix revoke for Nick's patches.  Wrongly.

+lguest-speed-up-paravirt_lazy_flush-handling.patch
+lguest-more-lazy_hcalls.patch
+lguest-the-guest-code-tsc-fix.patch
+lguest-the-guest-code-suppress-ide-probing.patch
+lguest-faster-tls-switching.patch
+lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command.patch
+lguest-the-host-code-use-tsc.patch
+lguest-the-host-code-use-hrtimers.patch
+lguest-the-host-code-update-for-mm-simplify-boot_params.patch
+lguest-the-net-driver-include-fix.patch
+lguest-the-documentation-example-launcher-example-launcher-fix.patch
+lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch

 lguest updates

+char-stallion-dont-fail-with-less-than-max-panels.patch
+char-stallion-alloc-tty-before-pci-devices-init.patch
+char-stallion-proper-fail-return-values.patch
+char-stallion-remove-user-class-report-request.patch

 Stallion driver fixes.

 I have a feeling these should be in 2.6.22.

+radeonfb-add-support-for-radeon-xpress-200m-rs485.patch
+nvidiafb-add-proper-support-for-geforce-7600-chipset.patch
+pm2fb-white-spaces-clean-up.patch
+fbcon-set_con2fb_map-fixes.patch
+fbcon-revise-primary-device-selection.patch
+fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch
+fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
+vt-add-comment-for-unbind_con_driver.patch
+68328fb-the-pseudo_palette-is-only-16-elements-long.patch
+controlfb-the-pseudo_palette-is-only-16-elements-long.patch
+cyblafb-fix-pseudo_palette-array-overrun-in-setcolreg.patch
+epson1355fb-color-setting-fixes.patch
+ffb-the-pseudo_palette-is-only-16-elements-long.patch
+fm2fb-the-pseudo_palette-is-only-16-elements-long.patch
+gbefb-the-pseudo_palette-is-only-16-elements-long.patch
+macfb-fix-pseudo_palette-size-and-overrun.patch
+offb-the-pseudo_palette-is-only-16-elements-long.patch
+platinumfb-the-pseudo_palette-is-only-16-elements.patch
+pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch
+q40fb-the-pseudo_palette-is-only-16-elements-long.patch
+sgivwfb-the-pseudo_palette-is-only-16-elements-long.patch
+sunxvr2500fb-fix-pseudo_palette-array-size.patch
+sunxvr500fb-fix-pseudo_palette-array-size.patch
+tgafb-actually-allocate-memory-for-the-pseudo_palette.patch
+tridentfb-fix-pseudo_palette-array-overrun-in-setcolreg.patch
+tx3912fb-fix-improper-assignment-of-info-pseudo_palette.patch
+atyfb-the-pseudo_palette-is-only-16-elements-long.patch
+radeonfb-the-pseudo_palette-is-only-16-elements-long.patch
+i810fb-the-pseudo_palette-is-only-16-elements-long.patch
+intelfb-the-pseudo_palette-is-only-16-elements-long.patch
+sisfb-fix-pseudo_palette-array-size-and-overrun.patch
+matroxfb-color-setting-fixes.patch
+pm3fb-fillrect-acceleration.patch
+i386-set-6-bit-dac-channel-properties-in-vesa-video.patch
+pm3fb-possible-cleanups.patch
+vt8623fbc-make-code-static.patch

 fbdev updates

+cfs-scheduler-v15-rc3-mm1.patch
+kernel-sched_fairc-make-code-static.patch
+fs-proc-basec-make-a-struct-static.patch
+cfs-warning-fixes.patch

 CFS fixes

+arch-personality-independent-stack-top.patch
+audit-rework-execve-audit.patch
+audit-rework-execve-audit-fix.patch
+mm-move_page_tables_up.patch
+mm-variable-length-argument-support.patch
+mm-variable-length-argument-support-fix.patch

 Remove the fixed limit on command line size

+drivers-edac-add-edac_mc_find-api.patch
+drivers-edac-core-make-functions-static.patch
+drivers-edac-add-rddr2-memory-types.patch
+drivers-edac-split-out-functions-to-unique-files.patch
+drivers-edac-add-edac_device-class.patch
+drivers-edac-mc-sysfs-add-missing-mem-types.patch
+drivers-edac-change-from-semaphore-to-mutex-operation.patch
+drivers-edac-new-intel-5000-mc-driver.patch
+drivers-edac-coreh-fix-scrubdefs.patch
+drivers-edac-new-i82443bxgz-mc-driver.patch
+drivers-edac-add-new-nmi-rescan.patch
+drivers-edac-mod-use-edac_coreh.patch
+drivers-edac-add-dev_name-getter-function.patch
+drivers-edac-new-inte-30x0-mc-driver.patch
+drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
+drivers-edac-updated-pci-monitoring.patch
+drivers-edac-mod-assert_error-check.patch
+drivers-edac-mod-pci-poll-names.patch
+drivers-edac-core-lindent-cleanup.patch
+drivers-edac-edac_device-sysfs-cleanup.patch
+drivers-edac-cleanup-workq-ifdefs.patch
+drivers-edac-lindent-amd76x.patch
+drivers-edac-lindent-i5000.patch
+drivers-edac-lindent-e7xxx.patch
+drivers-edac-lindent-i3000.patch
+drivers-edac-lindent-i82860.patch
+drivers-edac-lindent-i82875p.patch
+drivers-edac-lindent-e752x.patch
+drivers-edac-lindent-i82443bxgx.patch
+drivers-edac-lindent-r82600.patch
+drivers-edac-drivers-to-use-new-pci-operation.patch
+drivers-edac-add-device-sysfs-attributes.patch
+drivers-edac-device-output-clenaup.patch
+drivers-edac-add-info-kconfig.patch
+drivers-edac-update-maintainers-files-for-edac.patch
+drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch

 EDAC updates

+lockstat-human-readability-tweaks-fix.patch

 Fix lockstat-human-readability-tweaks.patch

-statistics-infrastructure-prerequisite-list.patch
-statistics-infrastructure-prerequisite-parser.patch
-statistics-infrastructure-prerequisite-parser-fix.patch
-add-for_each_substring-and-match_substring.patch
-statistics-infrastructure-prerequisite-timestamp.patch
-statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch
-statistics-infrastructure-documentation.patch
-statistics-infrastructure.patch
-statistics-infrastructure-add-for_each_substring-and-match_substring-exploitation.patch
-statistics-infrastructure-fix-parsing-of-statistics-type-attribute.patch
-statistics-infrastructure-simplify-statistics-debugfs-write-function.patch
-statistics-infrastructure-simplify-statistics-debugfs-read-functions.patch
-statistics-infrastructure-fix-string-termination.patch
-statistics-infrastructure-small-cleanup-in-debugfs-write-function.patch
-statistics-infrastructure-fix-cpu-hot-unplug-related-memory-leak.patch
-statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-cleanup.patch
-statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-labels.patch
-statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-keys.patch
-statistics-infrastructure-statistics-fix-sorted-list.patch
-add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
-statistics-infrastructure-exploitation-zfcp.patch

 Dropped, for now.

+nick-broke-reiser4-too.patch

 argh

+print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch

 Update -mm-only debug patch for Mel's changes



All 119 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/patch-list


