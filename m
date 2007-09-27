Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbXI0JWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbXI0JWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 05:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbXI0JW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 05:22:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36721 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539AbXI0JWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 05:22:24 -0400
Date: Thu, 27 Sep 2007 02:22:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc8-mm2
Message-Id: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/


- The scheduler devel tree has been restored

- The driver tree is presently busted, so I reverted it to the 2..23-rc8-mm1
  version.

- It's now a nearly-32MB diff.


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


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-arm.patch
 git-audit-master.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-powerpc-galak.patch
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
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-net.patch
 git-backlight.patch
 git-nfs.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-r8169.patch
 git-selinux.patch
 git-s390.patch
 git-sched.patch
 git-sh.patch
 git-scsi-misc.patch
 git-block.patch
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

-ufs-fix-sun-state.patch
-fix-potential-oops-in-generic_setlease.patch
-fix-potential-oops-in-generic_setlease-fix.patch
-fix-mspec-handle-shrinking-virtual-memory-areas.patch
-missing-null-termination-in-one-wire-uevent.patch
-typo-fix-kernel-config-option.patch
-fix-modules-oopsing-in-lguest-guests.patch
-revert-8139too-clean-up-i-o-remapping.patch
-git-net-fix-macec.patch
-git-net-sky2-fixups.patch
-mv643xx_eth-remove-redundant-multiple-initialization.patch
-git-net-fix-pasemi_mac.patch
-make-mv643xx_ethc-build-again.patch
-net-myri10ge-force-select-inet_lro.patch
-net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
-net-bluetooth-hidp-corec-make-hidp_setup_input.patch
-git-nfsd-fix-generic_setlease-mismerge.patch
-git-nfsd-fix-memory-shortage-can-result-in-inconsistent-flocks-state.patch
-gregkh-pci-pci-fix-boot-time-hang-on-g31-g33-pc.patch
-i386-compaq-evo-n800c-needs-pci-bus-renumbering.patch
-i386-compaq-evo-n800c-needs-pci-bus-renumbering-fix.patch
-ipsc-update-version-information.patch
-git-block-dasd_eckd-fix.patch
-git-block-fix-headers_check.patch
-git-block-fix-qlogicpti-build.patch
-git-block-ps3disk-fix.patch
-usb-skeleton-leaking-locks-on-open.patch
-p54pci-terminate-pci-table.patch
-usb-dont-propagate-freeze-or-prethaw-suspends.patch
-ppp_mppe-dont-put-interimkey-on-the-stack.patch
-kconfig-syntax-cleanups.patch
-fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
-ext4-remove-obsolete-fragments.patch
-ext4-uninitialized-block-groups.patch
-ext4-uninitialized-block-groups-fix.patch
-introduce-ext4_find_next_bit.patch
-ext4-fix-sparse-warnings.patch
-ext4-flex_bg-kernel-support-v2.patch

 Merged into mainline or a subsystem tree

+x86_64-mm-vdso-text-offset.patch
+fix-proc-acpi-alarm-to-work-with-bcd-alarm-encodings-award.patch
+input-xpad-fix-dependancy-on-leds-class.patch

 2.6.23 queue

+acpi-suppress-uninitialized-var-warning.patch

 acpi fix

-git-cifs-build-fix.patch

 Unneeded

+powerpc-ptrace-check_full_regs.patch

 powerpc fix

+dvb-fix-kconfig-help-text.patch

 DVB update

+drivers-hid-hid-debugc-add-kern_debug-prefix-fix-typo-constify-fix.patch

 HID cleanup

+git-kvm-warning-fix.patch

 Fix git-kvm.patch

+pata_pdc202xx_old-fix-timings.patch
+pata_ns87415-initial-cut-at-87415-87560-ide-support.patch
+pata_ns87415-initial-cut-at-87415-87560-ide-support-fix.patch
+fix-hpa-handling-regression.patch
+libata_scsi-fix-transfer-lengths.patch
+pata_atiixp-audit-notes-on-locking.patch
+pata_hpt3x2n-clean-up-dpll-stuff.patch

 ata stuff

+git-net-sctp-hack.patch

 Fix result of fixing a reject between git-net and mainline

+clean-up-redundant-phy-write-line-for-uli526x-ethernet.patch

 netdev cleanup

+git-r8169-fixup.patch

 Fix rejects in git-r8169.patch

+gregkh-pci-pci-remove-no-longer-correct-documentation-regarding-msi-vector-assignment.patch
+gregkh-pci-pci-i386-compaq-evo-n800c-needs-pci-bus-renumbering.patch
+gregkh-pci-pci-fix-incorrect-argument-order-to-list_add_tail-in-pci-dynamic-id-code.patch

 PCI tree updates

+gregkh-usb-usb-usb-skeleton-leaking-locks-on-open.patch
+gregkh-usb-usb-always-visit-drivers-usb-misc.patch
+gregkh-usb-usb-fix-double-frees-in-error-code-paths-of-ipaq-driver.patch
+gregkh-usb-usb-fix-limited_power-setting-mistake-in-hubc.patch
+gregkh-usb-usb-unusual_devs-update-for-nokia-6131.patch
+gregkh-usb-usb-don-t-propagate-freeze-or-prethaw-suspends.patch
+gregkh-usb-usb-remove-usb_quirk_no_autosuspend.patch
+gregkh-usb-usb-unusual_devs-modification-for-nikon-d200.patch
+gregkh-usb-usb-cp2101c-add-additional-device-id.patch
+gregkh-usb-usb-cxacru-use-appropriate-logging-for-errors.patch

 USB tree updates

+drivers-usb-misc-sisusbvga-sisusbc-kill-two-unused-variables.patch

 USB fix

-9p-fix-compile-error-if-config_sysctl.patch

 Unneeded

+revert-x86_64-mm-cpa-einval.patch

 Revert busted patch

+x86-64-disable-local-apic-timer-use-on-amd-systems-with-c1e.patch

 x86 update

+x86_64-cleanup-apic-c-fix.patch

 Fix x86_64-cleanup-apic-c.patch

+asm-i386-ioh-fix-constness.patch

 cleanups

+x86_64-vdso-linker-script-cleanup.patch
+x86_64-vdso-put-vars-in-rodata.patch
+x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch

 More x86 updates

+ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix.patch

 Fix ppc64-sparsemem_vmemmap-support.patch some more

+mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration.patch

 Fix mm-use-pagevec-to-rotate-reclaimable-page.patch some more

+memory-unplug-v7-page-offline-fix.patch

 Fix memory-unplug-v7-page-offline.patch

+oom-prevent-including-schedh-in-header-file.patch
+oom-add-header-file-to-kbuild-as-unifdef.patch
+oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch
+mm-test-and-set-zone-reclaim-lock-before-starting.patch
+mm-test-and-set-zone-reclaim-lock-before-starting-cleanup.patch

 More oom-killer work

+m32r-convert-to-generic-sys_ptrace.patch

 m32r update

+uml-time-build-fix.patch

 Fix uml patches in -mm

+uml-network-formatting.patch
+uml-network-driver-mtu-cleanups.patch

 UML updatelets

+add-in-sunos-41x-compatible-mode-for-ufs-fix-2.patch

 Fix add-in-sunos-41x-compatible-mode-for-ufs.patch some more

+remove-unused-member-from-nsproxy.patch
+use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
+jbd-ext3-cleanups-convert-to-kzalloc.patch
+vfs-use-the-predefined-d_unhashed-inline-function-instead.patch
+move-kasprintfo-to-obj-y.patch
+#increase-at_vector_size-to-terminate-saved_auxv-properly.patch: Tony wanted enhancements
+increase-at_vector_size-to-terminate-saved_auxv-properly.patch
+change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch
+delay-creation-of-khcvd-thread.patch
+hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help.patch
+lockdep-give-each-filesystem-its-own-inode-lock-class.patch
+menuconfig-transform-nls-and-dlm-menus.patch
+menuconfig-transform-network-filesystems-menu.patch
+fs-udf-ballocc-mark-a-variable-as-uninitialized_var.patch
+jbd-config_jbd_debug-cannot-create-proc-entry.patch
+jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
+jbd-fix-commit-code-to-properly-abort-journal.patch
+jbd-fix-jbd-warnings-when-compiling-with-config_jbd_debug.patch
+dont-truncate-proc-pid-environ-at-4096-characters.patch
+fix-wrong-filename-reference-in-drivers-testingtxt.patch
+anon_inodesc-fix-error-check-in-anon_inode_getfd.patch

 misc

+ecryptfs-remove-header_extent_size-fix.patch

 Fix ecryptfs-remove-header_extent_size.patch

+ecryptfs-clean-up-page-flag-handling.patch

 ecryptfs update

+video-gfx-fix-menu-ordering.patch

 fbdev fixlet

+ext4-jbd_to_jbd2_naming_cleanups.patch
+ext4-remove-obsolete-fragments.patch
+ext4-uninitialized-block-groups.patch
+ext4-fix-sparse-warnings.patch
+ext4-flex_bg-kernel-support-v2.patch
+ext4-ext4-journal-chksum-review-fix.patch
-ext4-booked-page-flag.patch
-ext4-ext4-block-reservation.patch
-ext4-ext4_block_reservation_fix3.patch
-ext4-ext4-delayed-allocation.patch
-ext4-ext4-delalloc-extents-48bit.patch
-ext4-ext4_nodelalloc_mount_opt.patch
-ext4-ext4_reserve_global_return_error_fix.patch
-ext4-ext4_rebalance_reservation_invariant_checking_fix.patch
-ext4-ext4_delalloc_setpageprivate_fix.patch
+ext4-fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
+ext4-delalloc-vfs.patch
+ext4-delalloc-ext4.patch
+ext4-ext-truncate-mutex.patch
+ext4-ext3-4-migrate.patch
+ext4-new-extent-function.patch
+ext4-generic-find-next-le-bit.patch
+ext4-mballoc-core.patch

 The ext4 tree got updates

+peterz-vs-ext4-mballoc-core.patch

 And promptly broke

+jbd2-ext4-cleanups-convert-to-kzalloc.patch
+jbd2-fix-commit-code-to-properly-abort-journal.patch

 ext4 stuff

+fix-very-high-interrupt-rate-for-irq8-rtc-unless-pnpacpi=off.patch

 pnp workaround

+r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch

 Fix r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch

+task-containersv11-basic-task-container-framework-fix-cgroup_create_dir-comments.patch
+add-cgroup-write_uint-helper-method.patch

 Fix cgroups

+uninline-find_task_by_xxx-set-of-functions.patch
+uninline-find_pid-etc-set-of-functions.patch
+uninline-the-task_xid_nr_ns-calls.patch

 Shrinkage

+memcontrol-move-mm_cgroup-to-header-file.patch

 memory controller updates

+extended-crashkernel-command-line-update.patch
+extended-crashkernel-command-line-comment-fix.patch
+extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch
-use-extended-crashkernel-command-line-on-i386-fix-config_nohighmem-for-extended-crashkernel-command-line.patch
-use-extended-crashkernel-command-line-on-i386-fix-config_nohighmem-for-extended-crashkernel-command-line-fix.patch
+use-extended-crashkernel-command-line-on-i386-update.patch
+use-extended-crashkernel-command-line-on-x86_64-update.patch
+use-extended-crashkernel-command-line-on-ia64-update.patch
+use-extended-crashkernel-command-line-on-ppc64-update.patch
+use-extended-crashkernel-command-line-on-sh-update.patch

 churn, churn

+usb_serial-stop-passing-null-to-functions-that-expect-data.patch
+ark3116-update-termios-handling.patch
+usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
+ch341-fix-termios-handling.patch
+digi_acceleport-fix-termios-and-also-readability-a-bit.patch
+empeg-clean-up-and-handle-speeds.patch
+funsoft-fix-termios.patch
+ir_usb-termios-handling.patch
+keyspan-termios-tidy.patch
+kobil_sct-termios-encoding-fixups.patch
+option-termios-handling.patch
+sierra-termios.patch
+usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
+visor-termios-bits.patch

 Update varios drivers for tty API changes


5631 commits in 2124 patch files

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/patch-list

