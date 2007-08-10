Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbXHJFnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbXHJFnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 01:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbXHJFnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 01:43:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33051 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436AbXHJFnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 01:43:04 -0400
Date: Thu, 9 Aug 2007 22:42:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc2-mm2
Message-Id: <20070809224254.11f42716.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm2/

- Various problems from 2.6.23-rc2-mm1 were fixed



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



Changes since 2.6.23-rc1-mm2:

 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-agpgart.patch
 git-audit-master.patch
 git-cifs.patch
 git-cpufreq.patch
 git-dma.patch
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
 git-kvm.patch
 git-libata-all.patch
 git-m32r.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-netdev-all.patch
 git-ixgbe.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-r8169.patch
 git-s390.patch
 git-sh.patch
 git-sh64.patch
 git-scsi-misc.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-kgdb.patch

 git trees

-genirq-temporary-fix-for-level-triggered-irq-resend-fix.patch
-allow-rcutorture-to-handle-synchronize_sched.patch
-alpha-o_cloexec-definition.patch
-sound-pci-ioremap-iounmap-balancing.patch
-fix-ide-ide-add-platform-ide-driver.patch
-mmc-make-it-build.patch
-mmc-fix-section-mismatch-warnings-for-drivers-mmc-host.patch
-git-nfsd-build-fixes.patch
-nfsd-warning-fix.patch
-dvb-remove-bogus-bug_on-in-videobuf_dvb_thread.patch

 Merged into mainline or a subsystem tree

+hex_dump-add-missing-const-qualifiers.patch
+rcu-remove-prototype-for-nonexistent-function.patch
+cris-drivers-cdrom-kconfig-no-longer.patch
+spidev-warning-fix.patch
+timerremove-clockevents_unregister_notifier.patch
+fix-compilation-with-gcc-42.patch
+fix-compilation-with-gcc-42-fix.patch
+lguest-files-should-explicitly-include-asm-paravirth.patch
+alpha-werror-fixes-for-sys_titanc.patch
+readahead-docbook-fix.patch

 More 2.6.23 queue

+pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-3x.patch

 Might be 2.6.23

+acpi-ec-remove-potential-deadlock-from-ec.patch

 ACPI fix

+sound-pci-ioremap-iounmap-balancing.patch

 ALSA fix

+make-power-supply-class-available-for-arm-architecture.patch

 ARM fix

+git-dma-up-fix.patch

 Fix git-dma

+jdelvare-i2c-i2c-mpc-dont-disable-i2c-module-on-stop-condition.patch
+jdelvare-i2c-i2c-core-make-some-code-static.patch

 I2C tree updates

-drivers-i2c-i2c-corec-make-code-static.patch

 Dropped

+alpm-increase-number-of-allowable-device-flags.patch

 ALPM pathces were updated again

+st340823a-hpa-and-libata.patch
+pata_cmd64x-set-up-mwdma-modes-properly.patch
+ata_piix-disallow-udma-133-on-ich5-ich7.patch

 ata/pata things

+ide-hpt366-fix-pci-clock-detection-for-hpt374.patch
+ide-hpt366-ultradma-filtering-for-sata-cards.patch
+ide-atiixp-dma-setup-fixes.patch
+ide-it8213-piix-slc90e66-remove-dma-2-pio.patch
+ide-au1xxx-use-ide-tune-dma.patch
+ide-hpt34x-fix-config-hpt34x-autodma-n-handling.patch
+ide-ide-remove-drive-init-speed-zeroing.patch
+ide-ide-remove-ide-use-fast-pio.patch
+ide-cs5530-sc1200-add-pio-autotune-fallback-to-ide-dma-check.patch
+ide-sl82c105-add-pio-autotune-fallback-to-ide-dma-check.patch
+ide-ide-cris-add-pio-autotune-fallback-to-ide-dma-check.patch
+ide-ide-pmac-add-pio-autotune-fallback-to-ide-dma-check.patch
+ide-ide-remove-ide-dma-check.patch

 IDE tree updates

+mips-detect-bcm947xx-cpus.patch
+mips-bcm947xx-support.patch
+rfc-add-bcm947xx-to-kconfig.patch
+mips-add-bcm947xx-to-makefile.patch

 MIPS things

-8139too-force-media-setting-fix.patch

 Dropped - it broke

+revert-8139too-clean-up-i-o-remapping.patch

 Revert dud patch from git-netdev-all

+drivers-net-remove-superfluous-memset.patch
+net-tulip-xircom_cbc-remove-superfulous-priv-assignment.patch
+3c59x-fix-duplex-configuration.patch
+wol-bugfix-for-3c59xc.patch

 netdev fixes

-cpqphp_ctrlc-remove-dead-code.patch

 Dropped

+drivers-scsi-ipsc-fix-scsi_add_host-warning.patch
+drivers-scsi-ipsc-fix-scsi_add_host-warning-fix.patch
+scsi-ipsc-warning-fix.patch
+message-fusion-remove-redundant-memset.patch

 SCSI fixes

+x86_64-vdso-install-unstripped-copies-on-disk.patch

 VDSO update

+consolidate-show_regs-and-show_registers-for-i386.patch
+i386-clean-up-oops-bug-reports.patch
+x86_64-remove-x86_cpu_to_log_apicid.patch

 x86 things

+belkin_sa-avoid-divide-by-zero-error.patch

 USB fix

+mm-clarify-__add_to_swap_cache-locking-fix.patch

 Fix mm-clarify-__add_to_swap_cache-locking.patch

+move-mm_struct-and-vm_area_struct.patch

 MM refactoring

+flush-cache-before-installing-new-page-at-migraton.patch
+flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch

 MM fixes

+file-capabilities-clear-fcaps-on-inode-change.patch

 file caps update

+freezer-introduce-freezer-firendly-waiting-macros-fix.patch

 PM fix

+uml-add-vde-networking-support.patch
+uml-remove-unnecessary-hostfs_getattr.patch

 UML updates

+aoe-remove-unecessary-wrapper-function.patch
+unicode-diacritics-support.patch
+mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
+jsm-remove-further-unneeded-crud.patch
+remove-consolemaph-from-header-exports.patch
+lib-sortc-optimization.patch
+x86_64-efi-boot-support-efi-frame-buffer-driver.patch
+x86_64-efi-boot-support-efi-boot-document.patch
+vfs-check-nanoseconds-in-utimensat.patch
+fix-execute-checking-in-permission.patch
+exec-remove-unnecessary-check-for-mnt_noexec.patch
+clean-out-unused-code-in-dentry-pruning.patch
+include-linux-typesh-in-if_fddih.patch

 misc

-nfs-remove-congestion_end.patch
-lib-percpu_counter_add.patch
-lib-percpu_counter-variable-batch.patch
-lib-make-percpu_counter_add-take-s64.patch
-lib-percpu_counter_set.patch
-lib-percpu_counter_sum_positive.patch
-lib-percpu_count_sum.patch
-lib-percpu_counter_init-error-handling.patch
-lib-percpu_counter_init_irq.patch
-mm-bdi-init-hooks.patch
-mm-bdi-init-hooks-fix.patch
-mtd-bdi-init-hooks.patch
-mtd-clean-up-the-backing_dev_info-usage.patch
-mtd-give-mtdconcat-devices-their-own-backing_dev_info.patch
-mm-scalable-bdi-statistics-counters.patch
-mm-count-reclaimable-pages-per-bdi.patch
-mm-count-writeback-pages-per-bdi.patch
-mm-expose-bdi-statistics-in-sysfs.patch
-lib-floating-proportions.patch
-lib-floating-proportions-_single.patch
-mm-per-device-dirty-threshold.patch
-mm-dirty-balancing-for-tasks.patch
-debug-sysfs-files-for-the-current-ratio-size-total.patch
-task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch

 Dropped due to crashiness

+unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling.patch

 Fix unprivileged-mounts-allow-unprivileged-mounts.patch

+tdfxfb-mtrr-support-fix-2.patch

 Fix tdfxfb-mtrr-support.patch

+fuse-fix-permission-checking-on-sticky-directories-fix-setting-i_mode-bits.patch

 Fix fuse-fix-permission-checking-on-sticky-directories-fix.patch

+fuse-clean-up-execute-permission-checking.patch

 FUES update

+fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch

 Fix fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch

+sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
+sysctl-factor-out-sysctl_data.patch
+sysctl-error-on-bad-sysctl-tables.patch
+sysctl-update-sysctl_check_table.patch
+sysct-mqueue-remove-the-binary-sysctl-numbers.patch
+sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
+sysctl-fix-neighbour-table-sysctls.patch
+sysctl-ipv6-route-flushing-kill-binary-path.patch
+sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
+sysctl-x86_64-remove-unnecessary-binary-paths.patch
+sysctl-remove-broken-cdrom-binary-sysctls.patch
+sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
+sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch

 sysctl cleanups

+make-access-to-tasks-nsproxy-lighter.patch

 nsproxy speedup



All 1215 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm2/patch-list


